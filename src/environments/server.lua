--[[
	@title environments/server
	@author Lanred
	@version 1.0.0
]]

local Players = game:GetService("Players")

local types = require(script.Parent.Parent.types)

local tween = require(script.Parent.Parent.dependencies.tween)

local tweenEvent: RemoteEvent = script.Parent.Parent.events.tween

-- Generates a tween ID.
-- TODO: Remove reliance on `os.clock`.
-- @returns string
local function generateTweenID(): string
	return tostring(os.clock())
end

--[[
	This is the server environment. It is used to create tweens on
	the server and pass them to the clients.

	@class
	@public
]]

local server = {}
server._tweens = {}

-- Starts the event listeners.
-- @private
-- @returns never
function server:_start()
	Players.PlayerAdded:Connect(function(player: Player)
		tweenEvent:FireClient(player, "create", true, server._tweens)
	end)
end

-- Creates a server tween object and adds it to the list of tweens.
-- @public
-- @extends serverTween constructor
function server:create(targets: types.targets, info: types.serverTweenInfo, properties: types.properties): types.serverTween
	local tweenID: string = generateTweenID()
	local self: types.serverTween = tween.server(targets, info :: any, properties, tweenID)
	server._tweens[tweenID] = self

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
function server:createOnServer(targets: types.targets, info: types.normalTweenInfo, properties: types.properties): types.normalTween
	return tween.normal(targets, info, properties)
end

-- An alias to `create`
server.CreateOnServer = server.createOnServer

return server
