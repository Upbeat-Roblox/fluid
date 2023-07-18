--[[
  _____   _           _       _ 
 |  ___| | |  _   _  (_)   __| |
 | |_    | | | | | | | |  / _` |
 |  _|   | | | |_| | | | | (_| |
 |_|     |_|  \__,_| |_|  \__,_|

 Devforum Post:
 Github: https://github.com/Lanred-Dev/Fluid
 Documentation: https://lanred-dev.github.io/Fluid
]]

--[[
	@title fluid
	@author Lanred
	@version 1.0.0
]]

local RunService = game:GetService("RunService")

local easings = require(script.modules.easings)

local isClient: boolean = RunService:IsClient()
local environment

if isClient == true then
	environment = require(script.environments.client)
else
	environment = require(script.environments.server)
end

environment.easings = easings
environment:_start()
return environment
