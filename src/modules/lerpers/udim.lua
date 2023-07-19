--[[
	@title lerpers/udim
	@author Lanred, Validark
	@version 1.0.0
]]

-- Lerps a UDim.
-- @param {UDim} start [The starting UDim.]
-- @param {UDim} target [The target UDim.]
-- @return (alpha: number) -> UDim
return function(start: UDim, target: UDim): (alpha: number) -> UDim
	local startScale: number = start.Scale
	local startOffset: number = start.Offset
	local targetScale: number = target.Scale - startScale
	local targetOffset: number = target.Offset - startOffset

	-- @param {number} alpha [The alpha.]
	-- @returns boolean
	return function(alpha: number): UDim
		return UDim.new(startScale + alpha * targetScale, targetOffset + alpha * targetOffset)
	end
end
