--[[
	@title lerpers/normal
	@author Lanred
]]

type normalLerpValues = CFrame | Vector3 | Vector2 | UDim2

-- Lerps a CFrame, Vector3, Vector2, or UDim2 using the Roblox lerper.
-- @param {normalLerpValues} start [The starting value.]
-- @param {normalLerpValues} target [The target value.]
-- @return (alpha: number) -> normalLerpValues
return function(start: normalLerpValues, target: normalLerpValues): (alpha: number) -> normalLerpValues
	-- @param {number} alpha [The alpha.]
	-- @returns boolean
	return function(alpha: number): normalLerpValues
		return (start :: any):Lerp(target, alpha)
	end
end
