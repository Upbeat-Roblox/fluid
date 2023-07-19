--[[
	@title tween
	@author Lanred
	@version 1.0.0
]]

local normalTween = require(script.normal)
local serverTween = require(script.server)

return {
	normal = normalTween,
	server = serverTween,
}
