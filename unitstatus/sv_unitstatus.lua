--[[
    Sonaran CAD Plugins

    Plugin Name: unitstatus
    Creator: SonoranCAD
    Description: Allows updating unit status

    Put all server-side logic in this file.
]]

local pluginConfig = Config.GetPluginConfig("unitstatus")

if pluginConfig.enabled then
    local ESX
	Citizen.CreateThread(function()
		while not ESX do
			TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
			Citizen.Wait(5)
		end
	end)

    registerApiType("UNIT_STATUS", "emergency")

    function setUnitStatus(apiId, status, player)
        local statusNumber = nil
        debugLog(("%s %s %s"):format(apiId, status, player))
        if tonumber(status) ~= nil and tonumber(status) >= 0 and tonumber(status) <= 5 then
            statusNumber = tonumber(status)
        else
            statusNumber = tonumber(pluginConfig.statusCodes[string.upper(status)])
        end
        assert(statusNumber ~= nil, ("Status %s was not found in config"):format(status))
        local payload = {{["apiId"] = apiId, ["status"] = statusNumber}}
        performApiRequest(payload, "UNIT_STATUS", function(res, success)
            TriggerEvent("SonoranCAD::unitstatus:StatusUpdate", apiId, statusNumber, success)
            if player ~= nil then
                TriggerClientEvent("SonoranCAD::unitstatus:StatusUpdate", player, apiId, statusNumber, success)
            end
        end)
    end

    exports('cadSetUnitStatus', setUnitStatus)

    RegisterNetEvent("SonoranCAD::unitstatus:UpdateStatus")
    AddEventHandler("SonoranCAD::unitstatus:UpdateStatus", function(status)
        local source = source
        local job = ESX.GetPlayerFromId(source).getJob()
        local allowed = job and pluginConfig.jobs[job.name]
        if not allowed then
            TriggerClientEvent("chat:addMessage", source, {args = {"^0[ ^1Error ^0] ", "Access denied."}})
            return
        end
        local ids = GetIdentifiers(source)
        local identifier = ids[Config.primaryIdentifier]
        setUnitStatus(identifier, status, source)
    end)

end