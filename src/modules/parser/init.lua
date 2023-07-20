--[[
	@title parser
	@author Lanred
]]

local propertiesParser = require(script.properties)
local infoParser = require(script.info)

return {
	properties = propertiesParser,
	info = infoParser,
}
