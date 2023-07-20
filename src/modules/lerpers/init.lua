--[[
	@title lerpers
	@author Lanred
]]

-- Please do note that these functions use the same methods that can
-- be seen in BoatTween's `Lerps.lua` file. While not all of these
-- functions are written by the developers of BoatTween
-- a great amount of them have been taken from there!
-- https://github.com/boatbomber/BoatTween/blob/master/src/BoatTween/Lerps.lua

local normalLerper = require(script.normal)
local numberLerper = require(script.number)
local booleanLerper = require(script.boolean)
local colorLerper = require(script.color)
local udimLerper = require(script.udim)
local numberRangeLerper = require(script.numberRange)
local numberSequenceKeypointLerper = require(script.numberSequenceKeypoint)
local physicalPropertiesLerper = require(script.physicalProperties)
local rayLerper = require(script.ray)
local rectLerper = require(script.rect)
local regionLerper = require(script.region)

return {
	["CFrame"] = normalLerper,
	["UDim2"] = normalLerper,
	["Vector2"] = normalLerper,
	["Vector3"] = normalLerper,
	["number"] = numberLerper,
	["boolean"] = booleanLerper,
	["Color3"] = colorLerper,
	["UDim"] = udimLerper,
	["NumberRange"] = numberRangeLerper,
	["NumberSequenceKeypoint"] = numberSequenceKeypointLerper,
	["PhysicalProperties"] = physicalPropertiesLerper,
	["Ray"] = rayLerper,
	["Rect"] = rectLerper,
	["Region3"] = regionLerper,
}
