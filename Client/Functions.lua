if (ZSX == nil) then
  return nil;
end

-- Callback

ZSX.Callbacks = {}

--  Code from: https://github.com/esx-framework/esx_core/blob/bcc1e876b6b7befa8630ee5fafc605b10dc290d3/%5Bcore%5D/es_extended/client/modules/callback.lua
local RequestId = 0
local serverRequests = {}
local clientCallbacks = {}

ZSX.Callbacks.TriggerServer = function(eName, callback, ...)
  	serverRequests[RequestId] = callback
  	TriggerServerEvent('zsx:triggerServerCallback', eName, RequestId, GetInvokingResource() or "unknown", ...)
    RequestId = RequestId + 1
end

RegisterNetEvent('zsx:serverCallback', function(requestId, invoker, ...)
	if not serverRequests[requestId] then
		return print(('[^1ERROR^7] Server Callback with requestId ^5%s^7 Was Called by ^5%s^7 but does not exist.'):format(requestId, invoker))
	end

	serverRequests[requestId](...)
	serverRequests[requestId] = nil
end)

ZSX.Callbacks.Register = function(eName, callback)
  clientCallbacks[eventName] = callback
end

RegisterNetEvent('zsx:triggerClientCallback', function(eventName, requestId, invoker, ...)
	if not clientCallbacks[eventName] then
		return print(('[^1ERROR^7] Client Callback not registered, name: ^5%s^7, invoker resource: ^5%s^7'):format(eventName, invoker))
	end

	clientCallbacks[eventName](function(...)
		TriggerServerEvent('zsx:clientCallback', requestId, invoker, ...)
	end, ...)
end)
