QBCore = exports['qb-core']:GetCoreObject()

QBCore.Commands.Add('td', 'help text here', {}, false, function(source, args)
    TriggerServerEvent("QBCore:ToggleDuty")
end)

RegisterNetEvent('Khats:ContainerRewards')
AddEventHandler('Khats:ContainerRewards', function(ItemAmount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local otherchance = math.random(1, 4)
    local odd = math.random(1, 4)
    local amount = ItemAmount

    if otherchance == odd then
        local item = math.random(1, #Config.ContainerRewardsRare)
        if Player.Functions.AddItem(Config.ContainerRewardsRare[item], amount) then
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.ContainerRewardsRare[item]], 'add', amount)
        else
            TriggerClientEvent('QBCore:Notify', src, 'You have to much in your pocket', 'error')
        end
    else
        local item = math.random(1, #Config.ContainerRewards)
        local amount = math.random(1,10)
        if Player.Functions.AddItem(Config.ContainerRewards[item], amount) then
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.ContainerRewards[item]], 'add', amount)
        else
            TriggerClientEvent('QBCore:Notify', src, 'You have to much in your pocket', 'error')
        end
    end
end)
