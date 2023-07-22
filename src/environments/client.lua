--[[
	@title environments/client
	@author Lanred
]]

local types = require(script.Parent.Parent.types)

local tween = require(script.Parent.Parent.classes.tween)

local easings = require(script.Parent.Parent.modules.easings)

local tweenEvent: RemoteEvent = script.Parent.Parent.events.tween
local easingEvent: RemoteEvent = script.Parent.Parent.events.easing
local requestEvent: RemoteEvent = script.Parent.Parent.events.request

type normalProperties = {
	start: { [Instance]: types.properties },
	target: { [Instance]: types.properties },
}

-- Converts a event safe properties back to normal.
-- @param {eventSafeProperties} eventSafeProperties [The event safe properties to convert.]
-- @returns normalProperties
local function convertEventSafePropertiesToNormal(
	targets: types.targets,
	eventSafeProperties: types.eventSafeProperties
): normalProperties
	local properties: normalProperties = {
		start = {},
		target = {},
	}

	for index: number, target: Instance in ipairs(targets) do
		properties.start[target] = eventSafeProperties.start[index]
		properties.target[target] = eventSafeProperties.target[index]
	end

	return properties
end

--[[
	This is the client environment. It handles all requests from the client
	scripts to create tweens and also handles requests from the server to
	handle tweens.

	@class
	@public
]]

local client = {}
client._tweens = {}

-- Starts the event listeners.
-- @public
-- @returns never
function client.start()
	-- Request the tweens and easings from the server.
	requestEvent:FireServer()

	tweenEvent.OnClientEvent:Connect(function(isBulk: boolean, ...)
		if isBulk == true then
			client._tweenBulk(...)
		else
			client._tweenSingle(...)
		end
	end)

	easingEvent.OnClientEvent:Connect(function(isBluk: boolean, ...)
		if isBluk == true then
			client._easingBulk(...)
		else
			client._easingSingle(...)
		end
	end)
end

-- This is a wrapper around the `_tweenSingle` function. The `data` parameter is a
-- array of the data that is going to the `_tweenSingle` function.
-- @private
-- @param {{ data }} data [The event data.]
-- @returns never
function client._tweenBulk(event: types.tweenEvents, data)
	for _, objectData in pairs(data) do
		client._tweenSingle(event, objectData)
	end
end

-- Handles a request to perform a certain type of tween event.
-- @private
-- @param {tweenEvents} event [The type of event.]
-- @param {data} data [The event data.]
-- @returns never
function client._tweenSingle(event: types.tweenEvents, data)
	if event == "create" then
		client:create(unpack(data))
	elseif event == "createOnJoin" then
		local self = client:create(unpack(data.data))
		local normalProperties: normalProperties = convertEventSafePropertiesToNormal(self.targets, data.properties)
		self:_recalculateProperties(normalProperties.start, normalProperties.target)
		self._startTime = data.startTime
		self._elapsedTime = data.elapsedTime

		if data.state == Enum.PlaybackState.Playing then
			self:play()
		else
			self._state = data.state
		end
	elseif event == "destroy" then
		client._tweens[data]:destroy()
		client._tweens[data] = nil
	elseif event == "play" then
		client._tweens[data]:play()
	elseif event == "stop" then
		client._tweens[data]:stop()
	elseif event == "scrub" then
		local tweenID: string, position: number = unpack(data)
		client._tweens[tweenID]:scrub(position)
	end
end

-- This is a wrapper around the `_easingSingle` function. The `data` parameter is a
-- array of the data that is going to the `_easingSingle` function.
-- @private
-- @param {{ data }} data [The event data.]
-- @returns never
function client._easingBulk(data)
	for _, objectData in pairs(data) do
		client._easingSingle(unpack(objectData))
	end
end

-- Handles a request to register / update a easing.
-- @private
-- @param {string} name [The name of the easing.]
-- @param {(time: number) -> number} easingFunction [The easing function.]
-- @returns never
function client._easingSingle(name: string, easingFunction: (time: number) -> number)
	easings.easings[name] = easingFunction
end

-- Creates a tween object and adds it to the list of tweens.
-- @public
-- @extends normalTween constructor
function client:create(
	targets: types.targets,
	info: types.normalTweenInfo,
	properties: types.properties,
	tweenID: string?
): types.normalTween
	local self: types.normalTween = tween.normal(targets, info, properties)

	-- The `tweenID` paramter is intended for use by the server. This allows the server
	-- to request a certain tween be changed.
	if tweenID ~= nil then
		client._tweens[tweenID] = self
	end

	return self
end

-- An alias to `create`
client.Create = client.create

return client
