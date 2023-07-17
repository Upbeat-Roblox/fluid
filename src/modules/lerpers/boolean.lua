--[[
	@title lerpers/boolean
	@author Lanred
	@version 1.0.0
]]

-- Lerps a boolean.
-- @param {boolean} start [The starting boolean.]
-- @param {boolean} target [The target boolean.]
-- @return (alpha: number) -> boolean
return function(start: boolean, target: boolean): (alpha: number) -> boolean
	-- @param {number} alpha [The alpha.]
	-- @returns boolean
	return function(alpha: number): boolean
		return alpha > 0.5 and target or start
	end
end