--[[
	      ___           ___       ___                       ___     
	     /\  \         /\__\     /\__\          ___        /\  \    
	    /::\  \       /:/  /    /:/  /         /\  \      /::\  \   
	   /:/\:\  \     /:/  /    /:/  /          \:\  \    /:/\:\  \  
	  /::\~\:\  \   /:/  /    /:/  /  ___      /::\__\  /:/  \:\__\ 
	 /:/\:\ \:\__\ /:/__/    /:/__/  /\__\  __/:/\/__/ /:/__/ \:|__|
	 \/__\:\ \/__/ \:\  \    \:\  \ /:/  / /\/:/  /    \:\  \ /:/  /
	      \:\__\    \:\  \    \:\  /:/  /  \::/__/      \:\  /:/  / 
	       \/__/     \:\  \    \:\/:/  /    \:\__\       \:\/:/  /  
	                  \:\__\    \::/  /      \/__/        \::/__/   
	                   \/__/     \/__/                     ~~       

	Devforum Post:
	Github: https://github.com/monke-mob/fluid
	Documentation: https://monke-mob.github.io/fluid
]]

--[[
	@title fluid
	@author Lanred
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
return environment
