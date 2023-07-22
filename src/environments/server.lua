--[[
	@title environments/server
	@author Lanred
]]

local types = require(script.Parent.Parent.types)

local tween = require(script.Parent.Parent.classes.tween)

local easings = require(script.Parent.Parent.modules.easings)

local tweenEvent: RemoteEvent = script.Parent.Parent.events.tween
local easingEvent: RemoteEvent = script.Parent.Parent.events.easing
local requestEvent: RemoteEvent = script.Parent.Parent.events.request

-- Generates a tween ID.
-- TODO?: Remove reliance on `os.clock`.
-- @returns string
local function generateTweenID(): string
	return tostring(os.clock())
end

-- Converts a the tween `_properties` variable into a
-- event safe dictionary.
-- @param {tweenTargets} targets [The tween targets.]
-- @param {internalTweenProperties} properties [The properties to convert.]
-- @returns eventSafeProperties
local function convertPropertiesToEventSafe(
	targets: types.targets,
	properties: types.internalTweenProperties
): types.eventSafeProperties
	local eventSafeProperties: types.eventSafeProperties = {
		start = {},
		target = {},
	}

	for index: number, target: types.targets in ipairs(targets) do
		eventSafeProperties.start[index] = properties.start[target]
		eventSafeProperties.target[index] = properties.target[target]
	end

	return eventSafeProperties
end

--[[
	This is the server environment. It handles all requests from server
	scripts to create tweens and also offload tween work to the clients.

	@class
	@public
]]

local server = {}
server._tweens = {}

-- Starts the event listeners.
-- @public
-- @returns never
function server:start()
	requestEvent.OnServerEvent:Connect(function(player: Player)
		tweenEvent:FireClient(player, true, "createOnJoin", server._tweens)
		easingEvent:FireClient(player, true, easings.easings)
	end)
end

-- Creates a server tween object and adds it to the list of tweens.
-- @public
-- @extends serverTween constructor
function server:create(
	targets: types.targets,
	info: types.serverTweenInfo,
	properties: types.properties
): types.serverTween
	local tweenID: string = generateTweenID()
	local self: types.serverTween = tween.server(targets, info, properties, tweenID)
	server._tweens[tweenID] = {
		data = { self.targets, info, properties, tweenID },
		properties = convertPropertiesToEventSafe(self.targets, self._properties),
		startTime = 0,
		elapsedTime = 0,
		state = Enum.PlaybackState.Begin,
	}

	-- Connect the `stateChanged` event so that whenever
	-- the tween is started / resumed we can update the
	-- tween data with the new start time.
	self.stateChanged:Connect(function(state: Enum.PlaybackState)
		server._tweens[tweenID].state = state
		server._tweens[tweenID].startTime = self._startTime
		server._tweens[tweenID].elapsedTime = self._elapsedTime
	end)

	-- Connect the destroyed event so that whenever
	-- the tween is finished it can be removed from the list
	-- and tell the clients to destroy it.
	self.destroyed:Connect(function()
		server._tweens[tweenID] = nil
		tweenEvent:FireAllClients(false, "destroy", tweenID)
	end)

	return self
end

-- An alias to `create`
server.Create = server.create

-- Creates a normal tween object.
-- @public
-- @extends normalTween constructor
function server:createOnServer(
	targets: types.targets,
	info: types.normalTweenInfo,
	properties: types.properties
): types.normalTween
	return tween.normal(targets, info, properties)
end

-- An alias to `createOnServer`
server.CreateOnServer = server.createOnServer

return server
