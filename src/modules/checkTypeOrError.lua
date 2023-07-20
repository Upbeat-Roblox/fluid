--[[
	@title checkTypeOrError
	@author Lanred
]]

local messages = require(script.Parent.Parent.messages)

-- Checks the type of the passed value and if its the required type
-- then it will return that value. Otherwise it will return a default value if
-- the value is nil. If the value is not nil and has a incorrect type
-- it will throw an error.
-- @param {any} value [The value to check.]
-- @param {string} valueName [The name of the value, used for the error.]
-- @param {string} type [The correct value type.]
-- @param {any} default [The default value.]
-- @returns any
return function(value: any, valueName: string, type: string, default: any): any
	if typeof(value) == type then
		return value
	elseif value == nil then
		return default
	elseif value ~= nil then
		error(messages.invalidType:format(typeof(value), type, valueName), 0)
	end

	-- Silences a `ImplicitReturn` warning.
	return
end
