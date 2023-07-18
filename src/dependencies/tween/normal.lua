--[[
	@title tween/normal
	@author Lanred
	@version 1.0.0
]]

local RunService = game:GetService("RunService")

local types = require(script.Parent.Parent.Parent.types)

local baseTween = require(script.Parent.base)

local freeThread: thread

-- @param {(...any) -> any} callback [The callback to use for the thread.]
-- @param {...any} ... [The data to pass to the callback.]
-- @returns never
local function functionPasser(callback, ...)
	local aquiredThread = freeThread
	freeThread = nil :: any
	callback(...)
	freeThread = aquiredThread
end

-- Used to yield a thread.
-- @returns never
local function threadYielder()
	while true do
		functionPasser(coroutine.yield())
	end
end

-- Spawns / reuses a thread for the passed callback.
-- @param {(...any) -> any} callback [The callback to use for the thread.]
-- @param {...any} ... [The data to pass to the callback.]
-- @returns never
local function spawnThread(callback, ...)
	if freeThread == nil then
		freeThread = coroutine.create(threadYielder)
		coroutine.resume(freeThread)
	end

	task.spawn(freeThread, callback, ...)
end

--[[
	Represents a tween object.

	@class
	@public
	@extends bareboneTween

	@param {targets} targets [The targets to tween.]
	@param {info} info [The tween info.]
	@param {properties} properties [The properties of which to tween.]
]]

local class = {}
class.__index = class
setmetatable(class, baseTween.class)

-- @private
-- @extends baseTween play
-- @returns never
function class:_playExtension()
	self:_startMethod()
end

-- @private
-- @extends baseTween stop
-- @returns never
function class:_stopExtension()
	self:_endMethod()
end

-- @private
-- @extends baseTween _complete
-- @returns never
function class:_completeExtension()
	self:_endMethod()
end

-- Starts the updater for the current tween.
-- @private
-- @returns never
function class:_startMethod()
	self._updateMethod = RunService[self.method]:Connect(function()
		self._elapsedTime = os.clock() - self._startTime

		-- Updating on a different thread helps to improve performance by moving
		-- the tween calculations off the main thread.
		spawnThread(function()
			self:_update()
		end)
	end)
end

-- Stops the updater for the current tween.
-- @private
-- @returns never
function class:_endMethod()
	self._updateMethod:Disconnect()
	self._updateMethod = nil
end

-- @private
-- @extends baseTween constructor
-- @returns normalTween
return function(targets: types.tweenTargets, info: types.info, properties: types.properties)
	-- This is given the type of `any` to prevent the type checker from screaming
	-- that you cannot add `variable` to table '{ @metatable class, baseTween }'.
	local baseClass: types.baseTween = baseTween.new(targets, info :: any, properties)
	local self = setmetatable(baseClass, class)

	-- Add the extended variables to the object.
	self._updateMethod = nil

	return self
end
