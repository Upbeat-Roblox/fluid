--Lanred
--6/27/2023

--//roblox services
local RunService = game:GetService("RunService")

--//core
--variables
local isClient: boolean = RunService:IsClient()

--main
local environment

--run the correct environment
if isClient == true then
	environment = require(script.environments.client)
else
	environment = require(script.environments.server)
end

environment:_start()
return environment
