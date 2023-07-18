--[[
	@title tween/base
	@author Lanred
	@version 1.0.0
]]

local types = require(script.Parent.Parent.Parent.types)
local messages = require(script.Parent.Parent.Parent.messages)

local GoodSignal = require(script.Parent.Parent.GoodSignal)

local updateProperty = require(script.Parent.Parent.Parent.modules.updateProperty)
local parser = require(script.Parent.Parent.Parent.modules.parser)
local easings = require(script.Parent.Parent.Parent.modules.easings)

-- Destroys a signal.
-- @param {any} signal [The signal to destroy.]
-- @returns never
local function destroySignal(signal)
	signal:DisconnectAll()
	setmetatable(signal, nil)
	table.freeze(signal)
end

--[[
	A class that represents a tween without any update method or methods, besides `destroy`.

	@class
	@private

	@param {targets} targets [The targets to tween.]
	@param {info} info [The tween info.]
	@param {properties} properties [The properties of which to tween.]
]]

local class = {}
class.__index = class

-- Starts the tween.
-- @public
-- @param {boolean?} forceRestart [If true the tween will restart.]
-- @returns never
function class:play(forceRestart: boolean?)
	assert(self._state ~= Enum.PlaybackState.Playing, messages.tween.tweenAlreadyPlaying)

	-- If the tween was not paused or if `forceRestart` is true
	-- then it needs to be restarted.
	if forceRestart == true or self._state ~= Enum.PlaybackState.Cancelled then
		self._elapsedTime = 0
	end

	-- If the tween was paused then we are resuming the tween.
	if self._state == Enum.PlaybackState.Cancelled then
		self.resumed:Fire()
	end

	self:_updateState(Enum.PlaybackState.Playing)
	self._startTime = os.clock() - self._elapsedTime

	-- Fire the extension function, if there is one.
	if self._playExtension ~= nil then
		self:_playExtension()
	end
end

-- Stops the tween.
-- @public
-- @returns never
function class:stop()
	assert(self._state ~= Enum.PlaybackState.Playing, messages.tween.triedToMethodButTweenNotPlaying, "stop")

	self:_updateState(Enum.PlaybackState.Cancelled)
	self.stopped:Fire()

	-- Fire the extension function, if there is one.
	if self._stopExtension ~= nil then
		self:_stopExtension()
	end
end

-- Scrub through the tween.
-- @public
-- @param {number} position [The position of the tween to move to.]
-- @returns never
function class:scrub(position: number)
	assert(self._state ~= Enum.PlaybackState.Playing, messages.tween.triedToMethodButTweenNotPlaying, "srub")
	assert(typeof(position) == "number", messages.invalidType, typeof(position), "position")

	position = math.clamp(position, 0, 100) / 100

	if position >= self._elapsedTime then
		self._startTime -= position
	elseif position < self._elapsedTime then
		self._startTime += position
	end

	-- Update the tween so that the change is instant. This also prevents
	-- the tween from not updating if its stopped.
	self:_update(math.clamp(position / self.duration, 0, 1))
end

-- Destroys the tween.
-- @public
-- @returns never
function class:destroy()
	self.destroyed:Fire()

	if self._state == Enum.PlaybackState.Playing then
		self:stop()
	end

	destroySignal(self.completed)
	destroySignal(self.stopped)
	destroySignal(self.stateChanged)
	destroySignal(self.update)
	destroySignal(self.resumed)
	destroySignal(self.destroyed)

	-- This destroys the object and freezes it to render is unusable.
	setmetatable(self, nil)
	table.freeze(self)
end

-- An alias to `destroy`
class.Destroy = class.destroy

-- Updates the state of the tween.
-- @private
-- @param {Enum.PlaybackState} state [The new state.]
-- @returns never
function class:_updateState(state: Enum.PlaybackState)
	-- If the new state is the same as the current state then
	-- we dont need to update. This prevents the stateChanged event from firing due to
	-- duplicate changes.
	if self._state ~= state then
		self._state = state
		self.stateChanged:Fire(state)
	end
end

-- Reverses the tween.
-- @private
-- @returns never
function class:_reverse()
	self._reversed = not self._reversed
	self._elapsedTime = 0
	self._startTime = os.clock()
end

-- Completes the tween.
-- @private
-- @returns never
function class:_complete()
	self:_updateState(Enum.PlaybackState.Completed)
	self.completed:Fire()

	if self.destroyOnComplete == true then
		self:destroy()
	end

	-- Fire the extension function, if there is one.
	if self._completeExtension ~= nil then
		self:_completeExtension()
	end
end

-- Updates an tween instances. Can take a `delta` parameter which
-- is passed to `_updatePropertiesOnInstance`.
-- @private
-- @param {number?} delta [The delta to use when calculating the values for the tween.]
-- @returns never
function class:_update(delta: number?)
	-- This variable is used to make sure that the tween still has valid targets.
	-- If it does not then its processing power.
	local targetCount: number = 0

	for index: number, target: types.targets in pairs(self.targets) do
		-- The only way to check if its still a valid target is if its a Instance.
		if typeof(target) == "Instance" and target.Parent == nil then
			table.remove(self.targets, index)
			continue
		end

		targetCount += 1
		self:_updatePropertiesOnInstance(target, delta)
	end

	if targetCount <= 0 then
		self:stop()
	end

	if self._elapsedTime >= self.duration then
		if self.reverses == true then
			self:_reverse()
		else
			self:_complete()
		end
	end
end

-- Updates an instance using the current delta or a custom delta if one is provided.
-- @private
-- @param {targets} instance [The target to update.]
-- @param {number?} customDelta [The delta to use when calculating the value.]
-- @returns never
function class:_updatePropertiesOnInstance(instance: types.targets, customDelta: number?)
	for property: string, targetValue: types.dataTypeWithFunction in pairs(self._properties.target[instance]) do
		-- If a custom delta is provided then the duration needs to be excused
		-- the way this is done is by using math.huge. If a custom delta is not provided
		-- it defaults to the property duration or the tween duration.
		local duration: number = typeof(customDelta) == "number" and math.huge
			or self._properties.parameters[property].duration
		local value: types.dataTypeWithFunction
		local percent: number = 0

		if self._elapsedTime >= duration then
			value = self._reversed == true and self._properties.start[instance][property] or targetValue
			percent = 100
		else
			local delta: number

			if typeof(customDelta) == "number" then
				delta = customDelta
			else
				local timeRatio: number = math.clamp(self._elapsedTime / duration, 0, 1)
				delta = self._reversed == true and (1 - timeRatio) or timeRatio
			end

			percent = easings.easings[self._properties.parameters[property].easing](delta)
			value = self._properties.lerpers[instance][property](percent)
		end

		updateProperty(instance, property, value)
		self.update:Fire(instance, property, value, percent)
	end
end

return {
	-- This prevents the class constructor from being exposed directly in the class
	-- and instead seperates the two to prevent the constructor from being apart of the class
	-- this helps to prevent issues i've encountered while having a class constructor directly in the class.
	-- @private
	-- @param {tweenTargets} targets [The targets to tween.]
	-- @param {normalTweenInfo|serverTweenInfo} info [The tween info.]
	-- @param {properties} properties [The properties of which to tween.]
	-- @returns baseTween
	new = function(
		targets: types.tweenTargets,
		info: types.normalTweenInfo | types.serverTweenInfo,
		properties: types.properties
	): types.baseTween
		assert(
			(typeof(targets) == "Instance" or typeof(targets) == "table"),
			messages.creation.invalidTargets:format(typeof(targets))
		)
		assert(typeof(properties) == "table", messages.creation.invalidProperties)

		local parsedInfo: any = parser.info(info)

		-- Converting the targets to an array reduces project and file size.
		-- The reason being it prevents update functions from having to check if the targets
		-- is a Instance or array/dictionary.
		if typeof(targets) == "Instance" then
			targets = { targets }
		end

		return setmetatable({
			-- Public
			-- Variables
			targets = targets,
			reverses = parsedInfo.reverses,
			repeatCount = parsedInfo.repeatCount,
			duration = parsedInfo.duration,
			method = parsedInfo.method,
			destroyOnComplete = parsedInfo.destroyOnComplete,
			-- The `updateSteps` variable is only valid on the server but is still parsed
			-- as the base tween does not know what type of tween this is.
			updateSteps = parsedInfo.updateSteps,

			-- Events
			completed = GoodSignal.new(),
			stopped = GoodSignal.new(),
			stateChanged = GoodSignal.new(),
			resumed = GoodSignal.new(),
			update = GoodSignal.new(),
			destroyed = GoodSignal.new(),

			-- Private
			-- Variables
			_startTime = 0,
			_elapsedTime = 0,
			_reversed = false,
			_state = Enum.PlaybackState.Begin,
			_properties = parser.properties(targets :: types.targets, properties, parsedInfo),
		}, class) :: any
	end,

	-- This exposes the class so that other classes may extend it.
	class = class,
}
