--[[
	@title parser
	@author Lanred
	@version 1.0.0
]]

local propertiesParser = require(script.properties)
local infoParser = require(script.info)

return {
	properties = propertiesParser,
	info = infoParser,
}
