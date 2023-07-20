--[[
	@title lerpers/region
	@author Lanred, Validark
]]

-- Lerps a Vector3.
-- @param {Vector3} start [The starting vector.]
-- @param {Vector3} target [The target vector.]
-- @param {number} alpha [The alpha.]
-- @returns Vector3
local function lerp(start: Vector3, target: Vector3, alpha: number): Vector3
	return start + alpha * (target - start)
end

-- Lerps a Region3.
-- @param {Region3} start [The starting region.]
-- @param {Region3} target [The target region.]
-- @return (alpha: number) -> Region3
return function(start: Region3, target: Region3): (alpha: number) -> Region3
	-- @param {number} alpha [The alpha.]
	-- @returns Region3
	return function(alpha: number): Region3
		local minRegionIntersect = lerp(start.CFrame * (-start.Size / 2), target.CFrame * (-target.Size / 2), alpha)
		local maxRegionIntersect = lerp(start.CFrame * (start.Size / 2), target.CFrame * (target.Size / 2), alpha)

		return Region3.new(
			Vector3.new(
				minRegionIntersect.X < maxRegionIntersect.X and minRegionIntersect.X or maxRegionIntersect.X,
				minRegionIntersect.Y < maxRegionIntersect.Y and minRegionIntersect.Y or maxRegionIntersect.Y,
				minRegionIntersect.Z < maxRegionIntersect.Z and minRegionIntersect.Z or maxRegionIntersect.Z
			),
			Vector3.new(
				minRegionIntersect.X > maxRegionIntersect.X and minRegionIntersect.X or maxRegionIntersect.X,
				minRegionIntersect.Y > maxRegionIntersect.Y and minRegionIntersect.Y or maxRegionIntersect.Y,
				minRegionIntersect.Z > maxRegionIntersect.Z and minRegionIntersect.Z or maxRegionIntersect.Z
			)
		)
	end
end
