--Lanred
--6/3/2023

--TODO: create a benchmark from calling the play function to the first update
--TODO: add a delay info so that you can delay the start
--TODO: allow realtime addition of easing styles
--[[
	TODO: instead of reculating the lerp everytime store it so that it can be used everytime just with an updated time
	In other words improve the handling of the lerping functions liek perhaps doing it like how boat tween does where it
	decides the lerping function before the tween starts and just loops through that table it created along with the new delta.
]]
--TODO: allow functions to be a valid value option but if they use functions then they are stuck with just that functions to handle everything

--//roblox services
local RunService = game:GetService("RunService")

--//dependencies
local bareboneTween = require(script.Parent.bareboneTween)
local assert = require(script.Parent.assert)

--//types
--declare types down here as the tween type needs the bareboneTween dependency
local types = require(script.Parent.Parent.types)

export type tween = bareboneTween.bareboneTween & {
	--private locals:
	_startTime: number,
	_elapsedTime: number,
	_reversed: boolean,
	_updateMethod: RBXScriptConnection?,

	--public methods:
	play: <a>(self: a, forceRestart: boolean?) -> never,
	stop: types.neverFunction,
	scrub: <a>(self: a, position: number) -> never,

	--private methods:
	_update: <a>(self: a, delta: number) -> never,
	_updatePropertiesOnInstance: <a>(instance: Instance, delta: number) -> never,
	_updateProperty: <a>(self: a, target: types.targets, property: string, value: types.dataType) -> never,
	_updateModelProperty: <a>(self: a, target: Model, property: string, value: types.dataType) -> never,
	_startMethod: types.neverFunction,
	_endMethod: types.neverFunction,
}

--//modules
local easings = require(script.Parent.Parent.modules.easings)
local lerpers = require(script.Parent.Parent.modules.lerpers)

--//components
local messages = require(script.Parent.Parent.messages)

--//core
--variables
local freeThread: thread

--functions
local function functionPasser(callback, ...)
	local aquiredThread = freeThread
	freeThread = nil :: any
	callback(...)
	freeThread = aquiredThread
end

local function threadYielder()
	while true do
		functionPasser(coroutine.yield())
	end
end

local function spawnThread(callback, ...)
	if freeThread == nil then
		freeThread = coroutine.create(threadYielder)
		coroutine.resume(freeThread)
	end

	task.spawn(freeThread, callback, ...)
end

--main
local tween = bareboneTween.tween
tween.__index = tween

--sets the tween state to playing
function tween:play(forceRestart: boolean?)
	assert(self._state ~= Enum.PlaybackState.Playing, messages.tween.tweenAlreadyPlaying)

	--only restart the tween if it was not paused or if told to
	if forceRestart == true or self._state ~= Enum.PlaybackState.Cancelled then
		self._elapsedTime = 0
	end

	--was it paused? if so fire the resumed event
	if self._state == Enum.PlaybackState.Cancelled then
		self.resumed:Fire()
	end

	self:_updateState(Enum.PlaybackState.Playing)
	self._startTime = os.clock() - self._elapsedTime
	self:_startMethod()
end

--sets the tween state to stopped
function tween:stop()
	assert(self._state ~= Enum.PlaybackState.Playing, messages.tween.triedToMethodButTweenNotPlaying, "stop")

	self:_updateState(Enum.PlaybackState.Cancelled)
	self:_endMethod()
	self.stopped:Fire()
end

--skips to a position in the tween
function tween:scrub(position: number)
	assert(self._state ~= Enum.PlaybackState.Playing, messages.tween.triedToMethodButTweenNotPlaying, "srub")
	assert(typeof(position) == "number", messages.invalidType, typeof(position), "position")

	position = math.clamp(position, 0, 100) / 100

	--check weather to add to or subtract from the _startTime
	if position >= self._elapsedTime then
		self._startTime -= position
	elseif position < self._elapsedTime then
		self._startTime += position
	end

	--go ahead and update the tween
	self:_update(math.clamp(position / self.duration, 0, 1))
end

--updates the tween based on the delta
function tween:_update(customDelta: number?)
	--update the properties of the targets
	local targetCount: number = 0

	for index: number, target: types.targets in pairs(self.targets) do
		--check to make sure that the target has not been destroyed
		if typeof(target) == "Instance" and target.Parent == nil then
			table.remove(self.targets, index)
		end

		--add to the target count as this target is being updated
		targetCount += 1

		--update the instance
		self:_updatePropertiesOnInstance(target, customDelta)
	end

	--if no targets are left then stop
	if targetCount <= 0 then
		self:stop()
	end

	--check to see if the tween is done
	if self._elapsedTime >= self.duration then
		if self.reverses == true then
			--reverse the tween
			self._reversed = not self._reversed
			self._elapsedTime = 0
			self._startTime = os.clock()
		else
			--its not reversing so stop and destroy
			if self._updateMethod ~= nil then
				self:_endMethod()
			end

			self:_updateState(Enum.PlaybackState.Completed)
			self.completed:Fire()

			--if destroyOnComplete == true then the tween needs to be destroyed
			if self.destroyOnComplete == true then
				self:destroy()
			end
		end
	end
end

--updates the properties of the needed instance
function tween:_updatePropertiesOnInstance(instance: types.targets, customDelta: number?)
	for property: string, targetValue: types.dataType in pairs(self._properties.target[instance]) do
		local duration: number = typeof(customDelta) == "number" and math.huge
			or (self._properties.parameters[property].duration or self.duration)

		if self._elapsedTime >= duration then
			self:_updateProperty(
				instance,
				property,
				self._reversed == true and self._properties.start[instance][property] or targetValue
			)
		else
			--calculate the delta
			local delta: number

			if typeof(customDelta) == "number" then
				delta = customDelta
			else
				local timeRatio: number = math.clamp(self._elapsedTime / duration, 0, 1)
				delta = self._reversed == true and (1 - timeRatio) or timeRatio
			end

			--get the value and update
			local percent: number = easings.easings[self._properties.parameters[property].easing or self.easing](delta)
			local value: CFrame =
				lerpers[typeof(targetValue)](self._properties.start[instance][property], targetValue, percent)
			self:_updateProperty(instance, property, value)

			--fire the update event
			self.update:Fire(instance, property, value, percent)
		end
	end
end

--updates the property of an instance
function tween:_updateProperty(instance: types.targets, property: string, value: types.dataType)
	if typeof(instance) == "Instance" and instance:IsA("Model") then
		if property == "CFrame" then
			instance:PivotTo(value :: CFrame)
		elseif property == "Position" then
			instance:PivotTo(CFrame.new(value :: Vector3))
		elseif property == "Transparency" or property == "Color" then
			self:_updateModelProperty(instance, property, value)
		end
	elseif typeof(instance) == "Instance" or typeof(instance) == "table" then
		(instance :: any)[property] = value
	end
end

--get a models descendants and updates them based on the property
function tween:_updateModelProperty(model: Model, property: string, value: types.dataType)
	for _, instance: Instance in ipairs(model:GetDescendants()) do
		if instance:IsA("BasePart") == false then
			continue
		end

		(instance :: any)[property] = value
	end
end

--starts a method to update the tween
function tween:_startMethod()
	assert(self._updateMethod == nil, messages.tween.updateMethodAlreadyStarted)

	self._updateMethod = RunService[self.method]:Connect(function()
		self._elapsedTime = os.clock() - self._startTime

		--update the tween
		spawnThread(function()
			self:_update()
		end)
	end)
end

--stops the update method that updates the tween
function tween:_endMethod()
	assert(self._updateMethod ~= nil, messages.tween.updateMethodNotStarted)

	--disconnect the loop and set it to nil. we are no longer using it
	self._updateMethod:Disconnect()
	self._updateMethod = nil
end

--component
local component = {}

function component.new(targets: types.targets, info: types.info, properties: types.properties): tween
	local self = bareboneTween.new(targets, info, properties)
	self._startTime = 0
	self._elapsedTime = 0
	self._reversed = false
	self._updateMethod = nil
	return setmetatable(self, tween)
end

return component
