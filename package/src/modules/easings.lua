--Lanred
--6/27/2023

--//types
export type style = (t: number) -> number

--//dependencies
local assert = require(script.Parent.Parent.dependencies.assert)

--//components
local messages = require(script.Parent.Parent.messages)

--//core
--main
local service = {}
service.easings = {
	Linear = function(t: number)
		return t
	end,

	EaseIn = function(t: number)
		return t * t
	end,
	
	EaseOut = function(t: number)
		return t * (2 - t)
	end,

	EaseInOut = function(t: number)
		if t < 0.5 then
			return 2 * t * t
		else
			return -1 + (4 - 2 * t) * t
		end
	end,

	OutInExpo = function(T)
		if T < 0.5 then
			return 2 * T * T
		else
			return 2 * (2 - T) * T - 1
		end
	end,
}

function service:_start() end

--register and update, even though they do the same thing, are seperate to prevent dual registering a style

--creates a style
function service:registerStyle(name: string, callback: style)
	assert(service.easings[name] == nil, messages.easing.alreadyRegisteredStyle, name)

	service.easings[name] = callback
end

--updates a style
function service:updateStyle(name: string, callback: style)
	assert(service.easings[name] ~= nil, messages.easing.styleNotRegistered, name)

	service.easings[name] = callback
end

return service
