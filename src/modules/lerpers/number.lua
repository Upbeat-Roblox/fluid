--[[
	@title lerpers/number
	@author Lanred
]]

-- Lerps a number.
-- @param {number} start [The starting number.]
-- @param {number} target [The target number.]
-- @return (alpha: number) -> number
return function(start: number, target: number): (alpha: number) -> number
	local delta: number = (target - start)

	-- @param {number} alpha [The alpha.]
	-- @returns boolean
	return function(alpha: number): number
		return start + delta * alpha
	end
end
