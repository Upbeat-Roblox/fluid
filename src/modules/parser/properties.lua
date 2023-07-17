--[[
	@title parser/properties
	@author Lanred
	@version 1.0.0
]]

local types = require(script.Parent.Parent.Parent.types)
local messages = require(script.Parent.Parent.Parent.messages)

local checkTypeOrError = require(script.Parent.Parent.checkTypeOrError)
local lerpers = require(script.Parent.Parent.lerpers)
local easings = require(script.Parent.Parent.easings)
local valueParser = require(script.Parent.value)

-- Setup the parameters for a property based on the `propertyData` parameter.
-- @param {property} propertyData [The data for the property.]
-- @param {normalTweenInfo|types.serverTweenInfo} info [The tween info.]
-- @returns info
local function getPropertyParameters(propertyData: types.propertyParameters, info: types.normalTweenInfo | types.serverTweenInfo): types.info
	if typeof(propertyData) ~= "table" then
		propertyData = {} :: any
	end

	local parameters: types.info = {
		easing = checkTypeOrError(propertyData.easing, "easing", "string", info.easing),
		duration = checkTypeOrError(propertyData.duration, "duration", "number", info.duration),
		delay = checkTypeOrError(propertyData.delay, "delay", "number", info.delay),
	}

	-- Confirm that it is a valid easing.
	if easings.easings[parameters.easing] == nil then
		error(messages.parser.invalidEasing:format(propertyData.easing), 0)
	end

	-- Confirm that the duration is not smaller than the tween duration.
	if parameters.duration < info.duration then
		error(messages.parser.propertyParameterDurationToSmall:format(parameters.duration, info.duration), 0)
	end

	return parameters
end

-- Sets up the starting and target values as well as the property parameters for the tween.
-- @param {targetsNoInstance} targets [The targets to tween.]
-- @param {properties} properties [The properties of which to tween.]
-- @param {normalTweenInfo|serverTweenInfo} info [The tween info.]
-- @returns {{ start: { [targetsNoInstance]: properties }, target: { [targetsNoInstance]: properties }, parameters: { [string]:info } }}
return function(targets: types.targets, properties: types.properties, info: types.normalTweenInfo | types.serverTweenInfo)
	local startingProperties: { [types.targets]: types.properties } = {}
	local targetProperties: { [types.targets]: types.properties } = {}
	local propertyLerpers: { [types.targets]: { [string]: () -> ((alpha: number) -> any) } } = {}
	local propertyParameters: { [string]: types.info } = {}

	-- Set the property parameters for each property.
	for property: string, propertyData: types.property in pairs(properties) do
		propertyParameters[property] = getPropertyParameters(propertyData, info)
	end

	-- Set the starting and target property values.
	for _index: number, target: any in pairs(targets) do
		startingProperties[target] = {}
		targetProperties[target] = {}
		propertyLerpers[target] = {}

		-- Register the values on a per instance basis.
		for property: string, propertyData: types.property in pairs(properties) do
			local startValue: types.dataTypeNoFunction, targetValue: types.dataTypeNoFunction =
				valueParser(target, property, propertyData)
			startingProperties[target][property] = startValue :: any
			targetProperties[target][property] = targetValue :: any
			propertyLerpers[target][property] = lerpers[typeof(targetValue)](startValue, targetValue)
		end
	end

	return {
		start = startingProperties,
		target = targetProperties,
		lerpers = propertyLerpers,
		parameters = propertyParameters,
	}
end
