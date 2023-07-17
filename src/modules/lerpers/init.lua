--[[
	@title lerpers
	@author Lanred
	@version 1.0.0
]]

-- Please do note that these functions use the same methods that can
-- be seen in BoatTween's Lerps.lua file. While not all of these
-- functions are written by the developers of BoatTween
-- a great amount of them have been taken from there!
-- You can find the file here: https://github.com/boatbomber/BoatTween/blob/master/src/BoatTween/Lerps.lua

local normalLerper = require(script.normal)
local numberLerper = require(script.number)
local booleanLerper = require(script.boolean)
local colorLerper = require(script.color)
local udimLerper = require(script.udim)

return {
	-- Normal
	["CFrame"] = normalLerper,
	["UDim2"] = normalLerper,
	["Vector2"] = normalLerper,
	["Vector3"] = normalLerper,

	-- Number
	["number"] = numberLerper,

	-- Boolean
	["boolean"] = booleanLerper,

	-- Color
	["Color3"] = colorLerper,

	-- UDim
	["UDim"] = udimLerper,
}
