--Lanred
--7/8/2023

--//types
local types = require(script.Parent.Parent.Parent.types)

--//roblox services
local RunService = game:GetService("RunService")

--//modules
local easings = require(script.Parent.Parent.Parent.modules.easings)

--//components
local messages = require(script.Parent.Parent.Parent.messages)

--//core
--variables
local isClient: boolean = RunService:IsClient()
local defaultUpdateMethodForServer: types.updateMethod = "Heartbeat"
local defaultUpdateMethodForClient: types.updateMethod = "RenderStepped"

--main
return function(info: types.info)
	assert(typeof(info) == "table", messages.parser.invalidInfo)

	--easing
	if typeof(info.easing) == "string" and easings.easings[info.easing] == nil then
		error(messages.parser.invalidEasing:format(info.easing), 0)
	elseif typeof(info.easing) ~= "string" and info.easing == nil then
		info.easing = "Linear"
	elseif typeof(info.easing) ~= "string" then
		error(messages.invalidType:format(typeof(info.easing), "easing"), 0)
	end

	--method
	if typeof(info.method) == "string" and RunService[info.method] == nil then
		error(messages.parser.invalidUpdateMethod:format(info.easing), 0)
	elseif isClient == false and info.method == "RenderStepped" then
		error(messages.parser.renderSteppedOnServer, 0)
	elseif typeof(info.easing) ~= "string" and info.easing == nil then
		info.method = isClient == true and defaultUpdateMethodForClient or defaultUpdateMethodForServer
	elseif typeof(info.method) ~= "string" then
		error(messages.invalidType:format(typeof(info.easing), "easing"), 0)
	end

	--duration
	if typeof(info.duration) ~= "number" and info.duration == nil then
		info.duration = 1
	elseif typeof(info.duration) ~= "number" then
		error(messages.invalidType:format(typeof(info.duration), "duration"), 0)
	end

	--repeatCount
	if typeof(info.repeatCount) ~= "number" and info.repeatCount == nil then
		info.repeatCount = 1
	elseif typeof(info.repeatCount) ~= "number" then
		error(messages.invalidType:format(typeof(info.repeatCount), "repeatCount"), 0)
	end

	--reverses
	if typeof(info.reverses) ~= "boolean" and info.reverses == nil then
		info.reverses = false
	elseif typeof(info.reverses) ~= "boolean" then
		error(messages.invalidType:format(typeof(info.reverses), "reverses"), 0)
	end

	--destroyOnComplete
	if typeof(info.destroyOnComplete) ~= "boolean" and info.destroyOnComplete == nil then
		info.destroyOnComplete = false
	elseif typeof(info.destroyOnComplete) ~= "boolean" then
		error(messages.invalidType:format(typeof(info.destroyOnComplete), "destroyOnComplete"), 0)
	end

	return info
end
