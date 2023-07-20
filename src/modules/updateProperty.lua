--[[
	@title updateProperty
	@author Lanred
]]

local types = require(script.Parent.Parent.types)

-- Updates the property of a model by updating all of the
-- BaseParts in the model.
-- @param [Model] model [The model to update.]
-- @param [string] property [The property to update.]
-- @param [dataTypeWithFunction] value [The new property value.]
-- @returns never
local function updateModelProperty(model: Model, property: string, value: types.dataTypeWithFunction)
	for _, instance: Instance in ipairs(model:GetDescendants()) do
		if instance:IsA("BasePart") == false then
			continue
		end

		(instance :: any)[property] = value
	end
end

-- Updates the property of an instance.
-- @param [targets] instance [The instance to update.]
-- @param [string] property [The property to update.]
-- @param [dataTypeWithFunction] value [The new property value.]
-- @returns never
return function(instance: types.tweenTargets, property: string, value: types.dataTypeWithFunction)
	if typeof(instance) == "Instance" and instance:IsA("Model") then
		if property == "CFrame" then
			instance:PivotTo(value :: CFrame)
		elseif property == "Position" then
			instance:PivotTo(CFrame.new(value :: Vector3))
		elseif property == "Transparency" or property == "Color" then
			updateModelProperty(instance, property, value)
		end
	elseif typeof(instance) == "Instance" or typeof(instance) == "table" then
		(instance :: any)[property] = value
	end
end
