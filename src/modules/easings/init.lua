--[[
	@title easings
	@author Lanred
]]

local easings = require(script.easings)
local register = require(script.register)
local update = require(script.update)

return {
	easings = easings,
	registerEasing = register,
	updateEasing = update,
}
