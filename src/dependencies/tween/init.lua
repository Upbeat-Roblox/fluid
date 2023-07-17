--[[
	@title tween
	@author Lanred
	@version 1.0.0
]]

-- The `base` tween is not made public as it is a private class
-- and is only to be used by public facing components extending it.

local normalTween = require(script.normal)
local serverTween = require(script.server)

return {
	normal = normalTween,
	server = serverTween,
}
