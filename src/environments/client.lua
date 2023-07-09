--Lanred
--6/27/2023

--TODO: when getting request from server to play tween, if it has already started, to calc to find current point

--//types
local types = require(script.Parent.Parent.types)

--//dependencies
local tween = require(script.Parent.Parent.dependencies.tween)

--//events
local tweenEvent: RemoteEvent = script.Parent.Parent.events.tween

--//core
--main
local client = {}

--contains a list of all of the current tweens
client._tweens = {}

--sets up event listeners
function client._start()
	tweenEvent.OnClientEvent:Connect(function(isBulk: boolean, ...)
		if isBulk == true then
			client._bulk(...)
		else
			client._single(...)
		end
	end)
end

--this is just a wrapper around _single. it takes the data in bulk and then passes it to the _single function
function client._bulk(event: types.events, data)
	for _, objectData in pairs(data) do
		client._single(event, objectData)
	end
end

--this function handles a event from the server and perfoms the requested action
function client._single(event: types.events, data)
	if event == "create" then
		client:create(unpack(data))
	elseif event == "destroy" then
		client._tweens[data]:destroy()
	elseif event == "play" then
		client._tweens[data]:play()
	elseif event == "stop" then
		client._tweens[data]:stop()
	elseif event == "scrub" then
		client._tweens[data.id]:scrub(data.position)
	end
end

--creates a tween object
function client:create(
	targets: types.targets,
	info: types.info,
	properties: types.properties,
	tweenID: string?
): tween.tween
	local self: tween.tween = tween.new(targets, info, properties)

	--does it have a tweenID? if so the key is going to be that id
	if tweenID ~= nil then
		client._tweens[tweenID] = self
	else
		--it does not have a tweenID so just push it into the array
		table.insert(client._tweens, self)
	end

	return self
end

client.Create = client.create

return client
