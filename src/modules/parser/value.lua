--Lanred
--7/3/2023

--parses the value / target values for a tween

--//types
local types = require(script.Parent.Parent.Parent.types)

type arrayTypes = "Array" | "Dictionary" | "Mixed" | "Empty"

--//dependencies
local assert = require(script.Parent.Parent.Parent.dependencies.assert)

--//components
local messages = require(script.Parent.Parent.Parent.messages)

--//core
--functions
local function getPropertyForModel(model: Model, property: string): types.dataTypeNoFunction
	if property == "Position" or property == "CFrame" then
		return model:GetPivot()
	elseif property == "Color" or property == "Transparency" then
		local startingValue: (Color3 | number)? = nil

		for _, instance: Instance in ipairs(model:GetDescendants()) do
			if instance:IsA("BasePart") == false then
				continue
			end

			local value: Color3 | number = (instance :: any)[property]

			if startingValue == nil then
				startingValue = value
			elseif value ~= startingValue then
				error(messages.parser.modelPropertiesAreNotTheSame, 0)
			end
		end

		--check to make sure a starting value was set. if it was not then no valid BaseParts where found
		assert(startingValue, messages.parser.noValidModelBaseParts, model.Name)

		return startingValue :: any
	else
		error(messages.parser.invalidModelProperties:format(property), 0)
	end
end

--gets the property value based off the instance type
local function getPropertyValue(instance: types.targets, property: string): types.dataTypeNoFunction
	if typeof(instance) == "Instance" and instance:IsA("Model") then
		return getPropertyForModel(instance, property)
	else
		return (instance :: any)[property]
	end
end

local function getStartAndTargetFromValueArray(
	instance: types.targets,
	property: string,
	value: { types.dataTypeNoFunction }
): (boolean, types.dataTypeNoFunction, types.dataTypeNoFunction)
	local startWasDefined: boolean = false
	local start: types.dataTypeNoFunction
	local target: types.dataTypeNoFunction

	--if its length is two or more then the first one is the start and the second is the target
	if #value >= 2 then
		startWasDefined = true
		start = value[1]
		target = value[2]
	else
		--the developer should try to provide two values but this is just incase they dont
		start = getPropertyValue(instance, property)
		target = value[1]
	end

	return startWasDefined, start, target
end

--big thanks to XAXA from this DevForum post:
--https://devforum.roblox.com/t/detecting-type-of-table-empty-array-dictionary-mixedtable/292323/15
local function getTableType(t): arrayTypes
	if next(t) == nil then
		return "Empty"
	end
	local isArray = true
	local isDictionary = true
	for k, _ in next, t do
		if typeof(k) == "number" and k % 1 == 0 and k > 0 then
			isDictionary = false
		else
			isArray = false
		end
	end
	if isArray then
		return "Array"
	elseif isDictionary then
		return "Dictionary"
	else
		return "Mixed"
	end
end

--main
return function(
	instance: types.targets,
	property: string,
	propertyParameters: types.propertyParameters
): (types.dataTypeNoFunction, types.dataTypeNoFunction)
	local propertyParametersTableType: arrayTypes = getTableType(propertyParameters)

	assert(
		(propertyParametersTableType == "Dictionary" and typeof(propertyParameters.value) ~= "function")
			or typeof(propertyParameters) ~= "function",
		messages.parser.valueParameterIsAFunction
	)

	local finialStart: types.dataTypeNoFunction
	local finialTarget: types.dataTypeNoFunction

	if propertyParametersTableType == "Dictionary" then
		local startWasDefined: boolean = false
		local start: types.dataTypeNoFunction
		local target: types.dataTypeNoFunction

		if typeof(propertyParameters.value) == "table" then
			local startWasDefinedValue, startValue, targetValue =
				getStartAndTargetFromValueArray(instance, property, propertyParameters.value)
			startWasDefined = startWasDefinedValue
			start = startValue
			target = targetValue
		else
			--the value is the target, so get the starting based off of the instance property
			start = getPropertyValue(instance, property)
			target = propertyParameters.value
		end

		--do we need to add the values to the current target values?
		if typeof(propertyParameters.addValue) == "boolean" and propertyParameters.addValue == true then
			--we do so lets get the starting value and add to that
			local startingValue: types.dataTypeNoFunction = getPropertyValue(instance, property)
			--if the start was not defined then the start is whatever it is in the target already
			finialStart = startWasDefined == true and (startingValue :: any) + start or start
			finialTarget = (startingValue :: any) + target
		elseif propertyParameters.addValue ~= nil then
			--this reports to the developer that the add value is invalid
			error(messages.parser.invalidAdd:format(typeof(propertyParameters.addValue)), 0)
		else
			--we dont so the start and target is the finial
			finialStart = start
			finialTarget = target
		end
	elseif propertyParametersTableType == "Array" then
		--the property parameters are the start and target values
		local _startWasDefinedValue, startValue, targetValue =
			getStartAndTargetFromValueArray(instance, property, propertyParameters)
		finialStart = startValue
		finialTarget = targetValue
	elseif propertyParametersTableType == "Empty" then
		--the value is the target, so get the starting based off of the instance property
		finialStart = getPropertyValue(instance, property)
		finialTarget = propertyParameters :: any
	else
		error(messages.parser.invalidPropertyParameters, 0)
	end

	if typeof(finialStart) ~= typeof(finialTarget) then
		error(messages.parser.invalidTargetDataType:format(typeof(finialStart), typeof(finialTarget)), 0)
	end

	return finialStart, finialTarget
end
