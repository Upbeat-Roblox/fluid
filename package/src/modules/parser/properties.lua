--Lanred
--7/3/2023

--this module handles all of the parameter parsing of properties for a tween

--//types
local types = require(script.Parent.Parent.Parent.types)

--//dependencies
local assert = require(script.Parent.Parent.Parent.dependencies.assert)

--//modules
local easings = require(script.Parent.Parent.easings)
local valueParser = require(script.Parent.value)

--//components
local messages = require(script.Parent.Parent.Parent.messages)

--//core
--functions
local function getPropertyParameters(propertyData: types.property, minDuration: number): types.defaultInfo?
	if typeof(propertyData) ~= "table" then
		return nil
	end

	local parameters: types.defaultInfo = {
		easing = nil,
		duration = nil,
		delay = nil,
	}

	--set the easing parameter
	if typeof(propertyData.easing) == "string" then
		--confirm that it is a valid easing
		assert(easings.easings[propertyData.easing] ~= nil, messages.parser.invalidEasing, propertyData.easing)

		parameters.easing = propertyData.easing
	elseif propertyData.easing ~= nil then
		error(messages.invalidType:format(typeof(propertyData.easing), "easing"), 0)
	end

	--set the duration parameter
	if typeof(propertyData.duration) == "number" then
		--confirm that it is a valid easing
		assert(
			propertyData.duration >= minDuration,
			messages.parser.propertyParameterDurationToSmall,
			propertyData.duration,
			minDuration
		)

		parameters.duration = propertyData.duration
	elseif propertyData.duration ~= nil then
		error(messages.invalidType:format(typeof(propertyData.duration), "duration"), 0)
	end

	--set the delay parameter
	if typeof(propertyData.delay) == "number" then
		--confirm that it is a valid easing
		parameters.delay = propertyData.delay
	elseif propertyData.delay ~= nil then
		error(messages.invalidType:format(typeof(propertyData.delay), "delay"), 0)
	end

	return parameters
end

--main
return function(targets: types.targetsNoInstance, properties: types.properties, minDuration: number)
	local startingProperties: { [types.targetsNoInstance]: types.properties } = {}
	local targetProperties: { [types.targetsNoInstance]: types.properties } = {}
	local propertyParameters: { [string]: types.defaultInfo? } = {}

	--set the property parameters info
	for property: string, propertyData: types.property in pairs(properties) do
		propertyParameters[property] = getPropertyParameters(propertyData, minDuration)
	end

	--set all the target properties
	for _index: number, target: any in pairs(targets) do
		--register them so that they can be used later
		startingProperties[target] = {}
		targetProperties[target] = {}

		--set the properties for this instance
		for property: string, propertyData: types.property in pairs(properties) do
			local startValue: types.dataTypeNoFunction, targetValue: types.dataTypeNoFunction =
				valueParser(target, property, propertyData)
			startingProperties[target][property] = startValue :: any
			targetProperties[target][property] = targetValue :: any
		end
	end

	return {
		start = startingProperties,
		target = targetProperties,
		parameters = propertyParameters,
	}
end
