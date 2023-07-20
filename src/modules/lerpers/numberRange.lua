--[[
	@title lerpers/numberRange
	@author Lanred, Validark
]]

-- Lerps a number range.
-- @param {NumberRange} start [The starting range.]
-- @param {NumberRange} target [The target range.]
-- @return (alpha: number) -> NumberRange
return function(start: NumberRange, target: NumberRange): (alpha: number) -> NumberRange
	local minStart, maxStart = start.Min, start.Max
	local minDelta, maxDelta = target.Min - minStart, target.Max - maxStart

	-- @param {number} alpha [The alpha.]
	-- @returns NumberRange
	return function(alpha: number): NumberRange
		return NumberRange.new(minStart + alpha * minDelta, maxStart + alpha * maxDelta)
	end
end
