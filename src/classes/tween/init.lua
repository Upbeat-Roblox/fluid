--[[
	@title tween
	@author Lanred
]]

local normalTween = require(script.normal)
local serverTween = require(script.server)

return {
	normal = normalTween,
	server = serverTween,
}
