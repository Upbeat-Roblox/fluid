--[[
	@title tween/server
	@author Lanred
	@version 1.0.0
]]

local types = require(script.Parent.Parent.Parent.types)

local baseTween = require(script.Parent.base)

local tweenEvent: RemoteEvent = script.Parent.Parent.Parent.events.tween

--[[
	Represents a tween object created by the server. This is not the same as the tween class!
	This is a wrapper around server-client communication and allows the server to act as if it is tweening.
	When in reality the clients are going to be tweening using the tween class.

	@class
	@public
	@extends baseTween

	@param {tweenTargets} targets [The targets to tween.]
	@param {serverTweenInfo} info [The tween info.]
	@param {properties} properties [The properties of which to tween.]
]]

local class = {}
class.__index = class
setmetatable(class, baseTween.class)

-- @private
-- @extends baseTween play
-- @returns never
function class:_playExtension()
	self:_startUpdater()
	tweenEvent:FireAllClients(false, "play", self._tweenID)
end

-- @private
-- @extends baseTween stop
-- @returns never
function class:_stopExtension()
	self:_endUpdater()
	tweenEvent:FireAllClients(false, "stop", self._tweenID)
end

-- @private
-- @extends baseTween _complete
-- @returns never
function class:_completeExtension()
	self:_endUpdater()
end

-- Starts the updater for the current tween.
-- @private
-- @returns never
function class:_startUpdater()
	-- The '_updaterStart' variable is intended to be used as a ID which is
	-- why we store its value in a variable and then update it.
	local updaterStart: number = os.clock()
	self._updaterStart = updaterStart

	task.spawn(function()
		while self._state == Enum.PlaybackState.Playing do
			for _step = 1, self.updateSteps do
				-- Confirm that the tween is still running and has not been stopped / restarted.
				if self._updaterStart ~= updaterStart then
					break
				end

				self._elapsedTime = os.clock() - self._startTime

				-- The `normal` tween class updates on a different thread.
				-- However since the `server` tween class is only intended to update a few times it does not use a seperate thread to update.
				-- This could cause performance problems if the developer attempts to have a large step count
				-- but if the developer is attemping to make the tween smooth they should be using the `normal` tween class instead.
				self:_update()

				task.wait(self.duration / self.updateSteps)
			end
		end
	end)
end

-- Stops the updater for the current tween.
-- @private
-- @returns never
function class:_endUpdater()
	self._updaterStart = nil
end

-- @private
-- @extends baseTween constructor
-- @param {string} tweenID [The ID of the tween used by both environments.]
-- @returns serverTween
return function(targets: types.tweenTargets, info: types.serverTweenInfo, properties: types.properties, tweenID: string)
	-- This is given the type of `any` to prevent the type checker from screaming
	-- that you cannot add `variable` to table '{ @metatable class, baseTween }'.
	local baseClass: types.baseTween = baseTween.new(targets, info :: any, properties)
	local self = setmetatable(baseClass, class)

	-- Add the extended variables to the object.
	self._updaterStart = nil
	self._tweenID = tweenID

	tweenEvent:FireAllClients(false, "create", { targets, info, properties, tweenID })

	return self
end
