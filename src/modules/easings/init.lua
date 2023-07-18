--[[
	@title easings
	@author Lanred
	@version 1.0.0
]]

local easings = require(script.easings)
local register = require(script.register)
local update = require(script.update)

return {
	easings = easings,
	registerEasing = register,
	updateEasing = update,
}
