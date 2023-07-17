--[[
	@title easings/easings
	@author Lanred
	@version 1.0.0
]]

return {
	Linear = function(time: number)
		return time
	end,

	EaseIn = function(time: number)
		return time * time
	end,

	EaseOut = function(time: number)
		return time * (2 - time)
	end,

	EaseInOut = function(time: number)
		if time < 0.5 then
			return 2 * time * time
		else
			return -1 + (4 - 2 * time) * time
		end
	end,

	OutInExpo = function(time)
		if time < 0.5 then
			return 2 * time * time
		else
			return 2 * (2 - time) * time - 1
		end
	end,
}
