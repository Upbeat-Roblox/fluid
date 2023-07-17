--[[
	@title environments/client
	@author Lanred
	@version 1.0.0
]]

local types = require(script.Parent.Parent.types)

local tween = require(script.Parent.Parent.dependencies.tween)

local tweenEvent: RemoteEvent = script.Parent.Parent.events.tween

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
-- @private
-- @returns never
function client._start()
	tweenEvent.OnClientEvent:Connect(function(isBulk: boolean, ...)
		if isBulk == true then
			client._bulk(...)
		else
			client._single(...)
		end
	end)
end

-- This is a wrapper around the `_single` function. The `data` parameter is a
-- array of the data that is going to the `_single` function.
-- @private
-- @param {{data}} data [The event data.]
-- @returns never
function client._bulk(event: types.events, data)
	for _, objectData in pairs(data) do
		client._single(event, objectData)
	end
end

-- Handles a request to perform a certain type of event.
-- @private
-- @param {events} event [The type of event.]
-- @param {data} data [The event data.]
-- @returns never
function client._single(event: types.events, data)
	if event == "create" then
		client:create(unpack(data))
	elseif event == "destroy" then
		client._tweens[data]:destroy()
		client._tweens[data] = nil
	elseif event == "play" then
		client._tweens[data]:play()
	elseif event == "stop" then
		client._tweens[data]:stop()
	elseif event == "scrub" then
		client._tweens[data.id]:scrub(data.position)
	end
end

-- Creates a tween object and adds it to the list of tweens.
-- @public
-- @extends normalTween constructor
function client:create(targets: types.targets, info: types.info, properties: types.properties, tweenID: string?): types.normalTween
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
