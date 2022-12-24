local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Commands.Add('td', 'help text here', {}, false, function(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    if Player.PlayerData.job.onduty then
        Player.Functions.SetJobDuty(false)
        TriggerClientEvent('QBCore:Notify', source, "Off Duty")
    else
        Player.Functions.SetJobDuty(true)
        TriggerClientEvent('QBCore:Notify', source, "On Duty")
    end
    TriggerClientEvent('QBCore:Client:SetDuty', source, Player.PlayerData.job.onduty)
end)
