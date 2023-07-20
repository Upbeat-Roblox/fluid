--[[
	@title lerpers/numberSequenceKeypoint
	@author Lanred, Validark
]]

-- Lerps a number sequence keypoint.
-- @param {NumberSequenceKeypoint} start [The starting keypoint.]
-- @param {NumberSequenceKeypoint} target [The target keypoint.]
-- @return (alpha: number) -> NumberSequenceKeypoint
return function(
	start: NumberSequenceKeypoint,
	target: NumberSequenceKeypoint
): (alpha: number) -> NumberSequenceKeypoint
	local startValue, startTime, startEnvelope = start.Value, start.Time, start.Envelope
	local deltaValue, deltaTime, deltaEnvelope = target.Time - startTime, target.Value - startValue, target.Envelope - startEnvelope

	-- @param {number} alpha [The alpha.]
	-- @returns NumberSequenceKeypoint
	return function(alpha: number): NumberSequenceKeypoint
		return NumberSequenceKeypoint.new(startTime + alpha * deltaTime, startValue + alpha * deltaValue, startEnvelope + alpha * deltaEnvelope)
	end
end
