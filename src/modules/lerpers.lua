--Lanred
--6/29/2023

--//types
type normalLerpValues = CFrame | Vector3 | Vector2 | UDim2

--//core
--functions
local function gammaToLinear(value: number): number
	if value <= 0.04045 then
		return value / 12.92
	else
		return ((value + 0.055) / 1.055) ^ 2.4
	end
end

local function linearToGamma(value: number): number
	if value <= 0.0031308 then
		return value * 12.92
	else
		return 1.055 * (value ^ (1 / 2.4)) - 0.055
	end
end

--main
local functions = {}

function functions.normal(start: normalLerpValues, target: normalLerpValues, alpha: number): normalLerpValues
	return (start :: any):Lerp(target, alpha)
end

function functions.number(start: number, target: number, alpha: number): number
	return start + (target - start) * alpha
end

function functions.boolean(start: boolean, target: boolean, alpha: number): boolean
	return alpha > 0.5 and target or start
end

function functions.color3(start: Color3, target: Color3, alpha: number): Color3
	--convert the colors to linear
	local linearStart: Color3 = Color3.new(gammaToLinear(start.R), gammaToLinear(start.G), gammaToLinear(start.B))
	local linearTarget: Color3 = Color3.new(gammaToLinear(target.R), gammaToLinear(target.G), gammaToLinear(target.B))

	--interpolate the linear colors
	local r: number = linearStart.R + (linearTarget.R - linearStart.R) * alpha
	local g: number = linearStart.G + (linearTarget.G - linearStart.G) * alpha
	local b: number = linearStart.B + (linearTarget.B - linearStart.B) * alpha

	--convert them back to gamma
	return Color3.new(linearToGamma(r), linearToGamma(g), linearToGamma(b))
end

function functions.udim(start: UDim, target: UDim, alpha: number): UDim
	--get the start scale and offset
	local startScale: number = start.Scale
	local startOffset: number = start.Offset

	--calculate the target scale and offset
	local targetScale: number = target.Scale - startScale
	local targetOffset: number = target.Offset - startOffset

	--convert them into a UDim
	return UDim.new(startScale + alpha * targetScale, targetOffset + alpha * targetOffset)
end

return {
	--normal lerper
	["CFrame"] = functions.normal,
	["UDim2"] = functions.normal,
	["Vector2"] = functions.normal,
	["Vector3"] = functions.normal,

	--number lerper
	["number"] = functions.number,

	--boolean lerper
	["boolean"] = functions.boolean,

	--color3 lerper
	["Color3"] = functions.color3,

	--udim lerper
	["UDim"] = functions.udim,
}
