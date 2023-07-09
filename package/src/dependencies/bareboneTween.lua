--Lanred
--7/8/2023

--this is a tween but it does not include any of the update methods or a start, stop, and scrub method.

--//types
local types = require(script.Parent.Parent.types)

export type bareboneTween = {
	--public locals:
	targets: types.targets,
	properties: types.properties,
	easing: string,
	duration: number,
	method: types.updateMethod,
	reverses: boolean,
	repeatCount: number,
	destroyOnComplete: boolean,

	--private locals:
	_state: Enum.PlaybackState,
	_properties: {
		start: { [types.targetsNoInstance]: types.properties },
		target: { [types.targetsNoInstance]: types.properties },
		parameters: { [string]: types.defaultInfo? },
	},

	--public events:
	completed: RBXScriptSignal,
	stopped: RBXScriptSignal,
	stateChanged: RBXScriptSignal,
	update: RBXScriptSignal,
	resumed: RBXScriptSignal,

	--public methods:
	destroy: types.neverFunction,
	Destroy: types.neverFunction,

	--private methods:
	_updateState: <a>(self: a, state: Enum.PlaybackState) -> never,
}

--//dependencies
local signal = require(script.Parent.signal)

--//modules
local parser = require(script.Parent.Parent.modules.parser)

--//components
local messages = require(script.Parent.Parent.messages)

--//core
--main
local tween = {}
tween.__index = tween

--destroys and stops playing the tween
function tween:destroy()
	--if the tween is playing then stop it
	if self._state == Enum.PlaybackState.Playing then
		self:stop()
	end

	--destroy the events
	self.completed:destroy()
	self.stopped:destroy()
	self.stateChanged:destroy()
	self.update:destroy()
	self.resumed:destroy()

	--clear the metatable
	setmetatable(self, nil)
	table.clear(self)
	table.freeze(self)
end

tween.Destroy = tween.destroy

--updates the tween state
function tween:_updateState(state: Enum.PlaybackState)
	--dont reupdate the state if its the same as the current one
	if self._state == state then
		return
	end

	self._state = state
	self.stateChanged:Fire(state)
end

--component
local component = {}

--make the tween component public so that other scripts may access it
component.tween = tween

function component.new(targets: types.targets, info: types.info, properties: types.properties)
	assert(
		(typeof(targets) == "Instance" or typeof(targets) == "table"),
		messages.creation.invalidTargets,
		typeof(targets)
	)
	assert(typeof(properties) == "table", messages.creation.invalidProperties)

	--convert the targets to a array if it is an instance
	if typeof(targets) == "Instance" then
		targets = { targets }
	end

	--parse the info
	info = parser.info(info)

	return setmetatable({
		--public locals:
		targets = targets,
		properties = properties,
		easing = info.easing,
		duration = info.duration,
		reverses = info.reverses,
		repeatCount = info.repeatCount,
		method = info.method,
		destroyOnComplete = info.destroyOnComplete,

		--private locals:
		_state = Enum.PlaybackState.Begin,
		_properties = parser.properties(
			targets :: types.targetsNoInstance,
			properties,
			typeof(info.duration) == "number" and info.duration or 1
		),

		--public events:
		completed = signal.new(),
		stopped = signal.new(),
		stateChanged = signal.new(),
		update = signal.new(),
		resumed = signal.new(),
	}, tween)
end

return component
