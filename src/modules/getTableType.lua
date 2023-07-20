--[[
	@title getTableType
	@author Lanred, XAXA
    @source https://devforum.roblox.com/t/detecting-type-of-table-empty-array-dictionary-mixedtable/292323/15
]]

local types = require(script.Parent.Parent.types)

-- Gets the type of a array.
-- @param {table} t [The table to type check.]
-- @returns arrayTypes
return function(t): types.arrayTypes
	if typeof(t) ~= "table" or next(t) == nil then
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