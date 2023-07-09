--Lanred
--6/28/2023

--TODO: create a server barebones tween which just handles state and rerouting

--//roblox services
local Players = game:GetService("Players")

--//events
local tweenEvent: RemoteEvent = script.Parent.Parent.events.tween

--//core
--main
local server = {}

--contains a list of all of the current tweens
server._tweens = {}

function server:_start()
	Players.PlayerAdded:Connect(server._playerAdded)
end

function server._playerAdded()
	tweenEvent:FireAllClients(true, "create", server._tweens)
end

function server:create(...: any)
	tweenEvent:FireAllClients(false, "create", ...)
end

return server
