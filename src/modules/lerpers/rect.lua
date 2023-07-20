--[[
	@title lerpers/rect
	@author Lanred, Validark
]]

-- Lerps a rect.
-- @param {Rect} start [The starting rect.]
-- @param {Rect} target [The target rect.]
-- @return (alpha: number) -> Rect
return function(start: Rect, target: Rect): (alpha: number) -> Rect
	-- @param {number} alpha [The alpha.]
	-- @returns Rect
	return function(alpha: number): Rect
		return Rect.new(
			start.Min.X + alpha * (target.Min.X - start.Min.X),
			start.Min.Y + alpha * (target.Min.Y - start.Min.Y),
			start.Max.X + alpha * (target.Max.X - start.Max.X),
			start.Max.Y + alpha * (target.Max.Y - start.Max.Y)
		)
	end
end
