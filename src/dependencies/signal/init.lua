--Lanred
--6/28/2023

--[[
	This is a modified version of Quenty's NevermoreEngine Signal module.
	The original file can be found here: https://github.com/Quenty/NevermoreEngine/blob/6ca66a994dba630ad9ac0e2208ac3b8b6630b053/Modules/Events/Signal.lua
]]

--TODO: modify to use methods like so: https://gist.github.com/stravant/b75a322e0919d60dde8a0316d1f09d2f
--TODO: improve signal / fire methods

--//dependencies
local assert = require(script.Parent.assert)

--//components
local messages = require(script.messages)

--//core
--main
local signal = {}
signal.__index = signal

function signal:Fire(...: any)
	self._data = { ... }
	self._argumentCount = select("#", ...)

	self._event:Fire()

	self._data = nil
	self._argumentCount = nil
end

function signal:Connect(callback: (...any) -> ...any): RBXScriptConnection
	assert(typeof(callback) == "function", messages.invalidConnectFunction, typeof(callback))

	return self._event.Event:Connect(function()
		callback(unpack(self._data, 1, self._argumentCount))
	end)
end

function signal:Wait()
	self._event.Event:Wait()

	assert(self._data, messages.noData)

	return unpack(self._data, 1, self._argumentCount)
end

function signal:destroy()
	if typeof(self._event) == "BindableEvent" then
		self._event:Destroy()
		self._event = nil
	end

	self._data = nil
	self._argumentCount = nil
end

signal.Destroy = signal.destroy

--component
local component = {}

function component.new()
	return setmetatable({
		_event = Instance.new("BindableEvent"),
		_data = nil,
		_argumentCount = nil,
	}, signal)
end

return component
