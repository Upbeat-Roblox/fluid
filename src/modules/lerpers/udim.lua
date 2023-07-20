--[[
	@title lerpers/udim
	@author Lanred, Validark
]]

-- Lerps a UDim.
-- @param {UDim} start [The starting UDim.]
-- @param {UDim} target [The target UDim.]
-- @return (alpha: number) -> UDim
return function(start: UDim, target: UDim): (alpha: number) -> UDim
	local startScale, startOffset = start.Scale, start.Offset
	local deltaScale, deltaOffset = target.Scale - startScale, target.Offset - startOffset

	-- @param {number} alpha [The alpha.]
	-- @returns boolean
	return function(alpha: number): UDim
		return UDim.new(startScale + alpha * deltaScale, startOffset + alpha * deltaOffset)
	end
end
