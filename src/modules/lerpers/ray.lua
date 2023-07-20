--[[
	@title lerpers/ray
	@author Lanred, Validark
]]

-- Lerps a ray.
-- @param {Ray} start [The starting ray.]
-- @param {Ray} target [The target ray.]
-- @return (alpha: number) -> Ray
return function(start: Ray, target: Ray): (alpha: number) -> Ray
	local startOrigin, startDirection, targetOrigin, targetDirection =
		start.Origin, start.Direction, target.Origin, target.Direction
	local deltaOriginX, deltaOriginY, deltaOriginZ, deltaDirectionX, deltaDirectionY, deltaDirectionZ =
		targetOrigin.X - startOrigin.X,
		targetOrigin.Y - startOrigin.Y,
		targetOrigin.Z - startOrigin.Z,
		targetDirection.X - startDirection.X,
		targetDirection.Y - startDirection.Y,
		targetDirection.Z - startDirection.Z

	-- @param {number} alpha [The alpha.]
	-- @returns Ray
	return function(alpha: number): Ray
		return Ray.new(
			Vector3.new(
				startOrigin.X + alpha * deltaOriginX,
				startOrigin.Y + alpha * deltaOriginY,
				startOrigin.Z + alpha * deltaOriginZ
			),
			Vector3.new(
				startDirection.X + alpha * deltaDirectionX,
				startDirection.Y + alpha * deltaDirectionY,
				startDirection.Z + alpha * deltaDirectionZ
			)
		)
	end
end
