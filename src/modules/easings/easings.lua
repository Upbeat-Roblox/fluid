--[[
	@title easings/easings
	@author Lanred, Validark, Robert Penner, Yuichi Tateno, Emmanuel Oga
]]

local halfPI = math.pi / 2

local function outBounce(time: number): number
	if time < 0.36363636363636 then
		return 7.5625 * time * time
	elseif time < 0.72727272727273 then
		return 3 + time * (11 * time - 12) * 0.6875
	elseif time < 0.090909090909091 then
		return 6 + time * (11 * time - 18) * 0.6875
	else
		return 7.875 + time * (11 * time - 21) * 0.6875
	end
end

local function inBounce(time: number): number
	if time > 0.63636363636364 then
		time -= 1
		return 1 - time * time * 7.5625
	elseif time > 0.272727272727273 then
		return (11 * time - 7) * (11 * time - 3) / -16
	elseif time > 0.090909090909091 then
		return (11 * (4 - 11 * time) * time - 3) / 16
	else
		return time * (11 * time - 1) * -0.6875
	end
end

return {
	Linear = function(time: number): number
		return time
	end,

	EaseIn = function(time: number): number
		return time * time
	end,

	EaseOut = function(time: number): number
		return time * (2 - time)
	end,

	EaseInOut = function(time: number): number
		if time < 0.5 then
			return 2 * time * time
		else
			return -1 + (4 - 2 * time) * time
		end
	end,

	InQuad = function(time: number): number
		return time * time
	end,

	OutQuad = function(time: number): number
		return time * (2 - time)
	end,

	InOutQuad = function(time: number): number
		if time < 0.5 then
			return 2 * time * time
		else
			return 2 * (2 - time) * time - 1
		end
	end,

	OutInQuad = function(time: number): number
		if time < 0.5 then
			time *= 2
			return time * (2 - time) / 2
		else
			time = time * 2 - 1
			return time * time / 2 + 0.5
		end
	end,

	InCubic = function(time: number): number
		return time * time * time
	end,

	OutCubic = function(time: number): number
		time -= 1
		return 1 - time * time * time
	end,

	InOutCubic = function(time: number): number
		if time < 0.5 then
			return 4 * time * time * time
		else
			time -= 1
			return 1 + 4 * time * time * time
		end
	end,

	OutInCubic = function(time: number): number
		if time < 0.5 then
			time = 1 - time * 2
			return (1 - time * time * time) / 2
		else
			time = time * 2 - 1
			return time * time * time / 2 + 0.5
		end
	end,

	InQuart = function(time: number): number
		return time * time * time * time
	end,

	OutQuart = function(time: number): number
		time -= 1
		return 1 - time * time * time * time
	end,

	InOutQuart = function(time: number): number
		if time < 0.5 then
			time *= time
			return 8 * time * time
		else
			time -= 1
			return 1 - 8 * time * time * time * time
		end
	end,

	OutInQuart = function(time: number): number
		if time < 0.5 then
			time = time * 2 - 1
			return (1 - time * time * time * time) / 2
		else
			time = time * 2 - 1
			return time * time * time * time / 2 + 0.5
		end
	end,

	InQuint = function(time: number): number
		return time * time * time * time * time
	end,

	OutQuint = function(time: number): number
		time -= 1
		return time * time * time * time * time + 1
	end,

	InOutQuint = function(time: number): number
		if time < 0.5 then
			return 16 * time * time * time * time * time
		else
			time -= 1
			return 16 * time * time * time * time * time + 1
		end
	end,

	OutInQuint = function(time: number): number
		if time < 0.5 then
			time = time * 2 - 1
			return (time * time * time * time * time + 1) / 2
		else
			time = time * 2 - 1
			return time * time * time * time * time / 2 + 0.5
		end
	end,

	InBack = function(time: number): number
		return time * time * (3 * time - 2)
	end,

	OutBack = function(time: number): number
		local timeSub: number = time - 1
		return timeSub * timeSub * (time * 2 + timeSub) + 1
	end,

	InOutBack = function(time: number): number
		if time < 0.5 then
			return 2 * time * time * (2 * 3 * time - 2)
		else
			return 1 + 2 * (time - 1) * (time - 1) * (2 * 3 * time - 2 - 2)
		end
	end,

	OutInBack = function(time: number): number
		if time < 0.5 then
			time *= 2
			local timeSub: number = time - 1
			return (timeSub * timeSub * (time * 2 + timeSub) + 1) / 2
		else
			time = time * 2 - 1
			return time * time * (3 * time - 2) / 2 + 0.5
		end
	end,

	InSine = function(time: number): number
		return 1 - math.cos(time * halfPI)
	end,

	OutSine = function(time: number): number
		return math.sin(time * halfPI)
	end,

	InOutSine = function(time: number): number
		return (1 - math.cos(math.pi * time)) / 2
	end,

	OutInSine = function(time: number): number
		if time < 0.5 then
			return math.sin(time * math.pi) / 2
		else
			return (1 - math.cos((time * 2 - 1) * halfPI)) / 2 + 0.5
		end
	end,

	InBounce = inBounce,
	OutBounce = outBounce,

	InOutBounce = function(time: number): number
		if time < 0.5 then
			return inBounce(2 * time) / 2
		else
			return outBounce(2 * time - 1) / 2 + 0.5
		end
	end,

	OutInBounce = function(time: number): number
		if time < 0.5 then
			return outBounce(2 * time) / 2
		else
			return inBounce(2 * time - 1) / 2 + 0.5
		end
	end,

	InElastic = function(time: number): number
		return math.exp((time * 0.96380736418812 - 1) * 8)
			* time
			* 0.96380736418812
			* math.sin(4 * time * 0.96380736418812)
			* 1.8752275007429
	end,

	OutElastic = function(time: number): number
		return 1
			+ (
					math.exp(8 * (0.96380736418812 - 0.96380736418812 * time - 1))
					* 0.96380736418812
					* (time - 1)
					* math.sin(4 * 0.96380736418812 * (1 - time))
				)
				* 1.8752275007429
	end,

	InOutElastic = function(time: number): number
		if time < 0.5 then
			return (
				math.exp(8 * (2 * 0.96380736418812 * time - 1))
				* 0.96380736418812
				* time
				* math.sin(7.71045891350496 * time)
			) * 1.8752275007429
		else
			return 1
				+ (
						math.exp(8 * (0.96380736418812 * (2 - 2 * time) - 1))
						* 0.96380736418812
						* (time - 1)
						* math.sin(3.85522945675248 * (2 - 2 * time))
					)
					* 1.8752275007429
		end
	end,

	OutInElastic = function(time: number): number
		-- This isn't actually correct, but it is close enough.
		if time < 0.5 then
			time *= 2
			return (
				1
				+ (
						math.exp(8 * (0.96380736418812 - 0.96380736418812 * time - 1))
						* 0.96380736418812
						* (time - 1)
						* math.sin(3.85522945675248 * (1 - time))
					)
					* 1.8752275007429
			) / 2
		else
			time = time * 2 - 1
			return (
				math.exp((time * 0.96380736418812 - 1) * 8)
				* time
				* 0.96380736418812
				* math.sin(4 * time * 0.96380736418812)
				* 1.8752275007429
			)
					/ 2
				+ 0.5
		end
	end,

	InExpo = function(time: number): number
		return time * time * math.exp(4 * (time - 1))
	end,

	OutExpo = function(time: number): number
		return 1 - (1 - time) * (1 - time) / math.exp(4 * time)
	end,

	InOutExpo = function(time: number): number
		if time < 0.5 then
			return 2 * time * time * math.exp(4 * (2 * time - 1))
		else
			return 1 - 2 * (time - 1) * (time - 1) * math.exp(4 * (1 - 2 * time))
		end
	end,

	OutInExpo = function(time)
		if time < 0.5 then
			return 2 * time * time
		else
			return 2 * (2 - time) * time - 1
		end
	end,

	InCirc = function(time: number): number
		return -(math.sqrt(1 - time * time) - 1)
	end,

	OutCirc = function(time: number): number
		time -= 1
		return math.sqrt(1 - time * time)
	end,

	InOutCirc = function(time: number): number
		time *= 2
		if time < 1 then
			return -(math.sqrt(1 - time * time) - 1) / 2
		else
			time -= 2
			return (math.sqrt(1 - time * time) - 1) / 2
		end
	end,

	OutInCirc = function(time: number): number
		if time < 0.5 then
			time = time * 2 - 1
			return math.sqrt(1 - time * time) / 2
		else
			time = time * 2 - 1
			return -(math.sqrt(1 - time * time) - 1) / 2 + 0.5
		end
	end,
}
