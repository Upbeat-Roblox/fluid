--[[
	@title parser/info
	@author Lanred
	@version 1.0.0
]]

local RunService = game:GetService("RunService")

local types = require(script.Parent.Parent.Parent.types)
local messages = require(script.Parent.Parent.Parent.messages)

local checkTypeOrError = require(script.Parent.Parent.checkTypeOrError)
local easings = require(script.Parent.Parent.easings)

local isClient: boolean = RunService:IsClient()
local defaultUpdateMethodForServer: types.updateMethod = "Heartbeat"
local defaultUpdateMethodForClient: types.updateMethod = "RenderStepped"

-- Type checks all of the info and provides defaults if the info is not given.
-- @param {normalTweenInfo|serverTweenInfo} info [The info to parse.]
-- @return normalTweenInfo|serverTweenInfo
return function(info: types.normalTweenInfo | types.serverTweenInfo)
	assert(typeof(info) == "table", messages.parser.invalidInfo)

	-- We check this before as the `updateSteps` parameter will be set to
	-- a default value if its not provided, in return causing this to always be true.
	if (info :: any).updateSteps ~= nil and isClient == true then
		error(messages.parser.updateStepsOnClient, 0)
	end

	local parsedInfo = {
		easing = checkTypeOrError(info.easing, "easing", "string", "Linear"),
		method = checkTypeOrError(
			(info :: any).method,
			"method",
			"string",
			isClient == true and defaultUpdateMethodForClient or defaultUpdateMethodForServer
		),
		duration = checkTypeOrError(info.duration, "duration", "number", 1),
		repeatCount = checkTypeOrError(info.repeatCount, "repeatCount", "number", 1),
		updateSteps = checkTypeOrError((info :: any).updateSteps, "updateSteps", "number", 5),
		reverses = checkTypeOrError(info.reverses, "reverses", "boolean", false),
		destroyOnComplete = checkTypeOrError(info.destroyOnComplete, "destroyOnComplete", "boolean", false),
	}

	-- Confirm that it is a valid easing.
	if easings.easings[info.easing] == nil then
		error(messages.parser.invalidEasing:format(parsedInfo.easing), 0)
	end

	-- Confirm that its a valid update method.
	if RunService[parsedInfo.method] == nil then
		error(messages.parser.invalidUpdateMethod:format(parsedInfo.method), 0)
	elseif isClient == false and parsedInfo.method == "RenderStepped" then
		error(messages.parser.renderSteppedOnServer, 0)
	end

	return parsedInfo
end
