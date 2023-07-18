--[[
	@title easings/update
	@author Lanred
	@version 1.0.0
]]

local messages = require(script.Parent.Parent.Parent.messages)

local easings = require(script.Parent.easings)

-- Used to update a easing. While internally this is the same as
-- the `register` method it serves to prevent developers from
-- attempting to update unregistered easings.
-- @param {string} name [The name of the easing.]
-- @param {(time: number) -> number} easingFunction [The new easing function.]
-- @returns never
return function(name: string, easingFunction: (time: number) -> number)
	assert(easings[name] == nil, messages.easing.styleNotRegistered:format(name))

	easings[name] = easingFunction
end
