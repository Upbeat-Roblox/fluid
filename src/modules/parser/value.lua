--[[
	@title parser/value
	@author Lanred
]]

local types = require(script.Parent.Parent.Parent.types)
local messages = require(script.Parent.Parent.Parent.messages)

local getTableType = require(script.Parent.Parent.getTableType)

-- Gets a property value from a model.
-- @param {Model} model [They model to get the value from.]
-- @param {string} property [The property name.]
-- @returns dataTypeNoFunction
local function getPropertyValueFromModel(model: Model, property: string): types.dataTypeNoFunction
	if property == "Position" or property == "CFrame" then
		return model:GetPivot()
	elseif property == "Color" or property == "Transparency" then
		local propertyValue: any = nil

		for _, instance: Instance in ipairs(model:GetDescendants()) do
			if instance:IsA("BasePart") == false then
				continue
			end

			local value: Color3 | number = (instance :: any)[property]

			-- In reality having all `BaseParts` not be the same
			-- will not affect the tween but there would be no way
			-- for the parser to get a certain starting value.
			-- TODO: Find ways to improve this so that not all
			-- `BaseParts` have to have the same value.
			if propertyValue == nil then
				propertyValue = value
			elseif value ~= propertyValue then
				error(messages.parser.modelPropertiesAreNotTheSame, 0)
			end
		end

		-- If not starting value was set then that means that no valid
		-- `BaseParts` where found.
		if propertyValue == nil then
			error(messages.parser.noValidModelBaseParts:format(model.Name), 0)
		end

		return propertyValue :: any
	else
		error(messages.parser.invalidModelProperties:format(property), 0)
	end
end

-- Gets the property value from a instance. If the instance
-- is a model then it will get use the `getPropertyValueFromModel` function.
-- @param {targets} instance [The instance to get the value from.]
-- @param {string} property [The property to get the value from.]
-- @returns dataTypeNoFunction
local function getPropertyValue(instance: types.targets, property: string): types.dataTypeNoFunction
	if typeof(instance) == "Instance" and instance:IsA("Model") then
		return getPropertyValueFromModel(instance, property)
	else
		return (instance :: any)[property]
	end
end

-- Gets the start and target values from the passed array.
-- @param {targets} instance [The instance.]
-- @param {string} property [The property.]
-- @param {{ dataTypeNoFunction }} value [The values.]
-- @returns boolean, types.dataTypeNoFunction, types.dataTypeNoFunction
local function getStartAndTargetFromValueArray(
	instance: types.targets,
	property: string,
	value: { types.dataTypeNoFunction }
): (boolean, types.dataTypeNoFunction, types.dataTypeNoFunction)
	local startWasDefined: boolean = false
	local start: types.dataTypeNoFunction
	local target: types.dataTypeNoFunction

	if #value >= 2 then
		startWasDefined = true
		start = value[1]
		target = value[2]
	else
		-- Two values should be provided but incase they are
		-- not just get a starting property.
		start = getPropertyValue(instance, property)
		target = value[1]
	end

	return startWasDefined, start, target
end

-- Gets the start and target property values for a property.
-- @param {targets} instance [The instance to get the values from.]
-- @param {string} property [The property to use for the values.]
-- @param {propertyParameters} propertyParameters [The property parameters to use.]
-- @returns dataTypeNoFunction, dataTypeNoFunction
return function(
	instance: types.targets,
	property: string,
	propertyParameters: types.propertyParameters
): (types.dataTypeNoFunction, types.dataTypeNoFunction)
	local propertyParametersTableType: types.arrayTypes = getTableType(propertyParameters)

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
			start = getPropertyValue(instance, property)
			target = propertyParameters.value
		end

		-- Do the provided values need to be added to the property values?
		if typeof(propertyParameters.addValue) == "boolean" and propertyParameters.addValue == true then
			local startingValue: types.dataTypeNoFunction = getPropertyValue(instance, property)
			finialStart = startWasDefined == true and (startingValue :: any) + start or start
			finialTarget = (startingValue :: any) + target
		elseif propertyParameters.addValue ~= nil then
			error(messages.parser.invalidAdd:format(typeof(propertyParameters.addValue)), 0)
		else
			finialStart = start
			finialTarget = target
		end
	elseif propertyParametersTableType == "Array" then
		local _startWasDefinedValue, startValue, targetValue =
			getStartAndTargetFromValueArray(instance, property, propertyParameters)
		finialStart = startValue
		finialTarget = targetValue
	elseif propertyParametersTableType == "Empty" then
		finialStart = getPropertyValue(instance, property)
		finialTarget = propertyParameters :: any
	else
		error(messages.parser.invalidPropertyParameters, 0)
	end

	-- Confirm that they are of the same type.
	if typeof(finialStart) ~= typeof(finialTarget) then
		error(messages.parser.invalidTargetDataType:format(typeof(finialStart), typeof(finialTarget)), 0)
	end

	return finialStart, finialTarget
end
