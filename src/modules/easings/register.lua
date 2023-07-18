--[[
	@title easings/register
	@author Lanred
	@version 1.0.0
]]

local messages = require(script.Parent.Parent.Parent.messages)

local easings = require(script.Parent.easings)

-- Used to register / create new easings.
-- @param {string} name [The name of the new easing.]
-- @param {(time: number) -> number} easingFunction [The easing function.]
-- @returns never
return function(name: string, easingFunction: (time: number) -> number)
	assert(easings[name] == nil, messages.easing.alreadyRegisteredStyle:format(name))

	easings[name] = easingFunction
end
