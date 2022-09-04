QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('Khats:server:rewardpayout', function (jobId)
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)
    local items = Config.Rewards.items

    Player.Functions.RemoveItem(items.FetchItemContents, items.FetchItemContentsAmount)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[items.FetchItemContents], "remove")

    Player.Functions.AddMoney('cash', Config.Jobs[jobId].Payout)

    for k, v in pairs(Config.Rewards.Special) do
        local chance = math.random(0,100)
        print('chance for '..v.Item..': '..chance)
        if chance < v.Chance then 
            Player.Functions.AddItem(v.Item, v.Amount)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[v.Item], "add")
        end
    end
end)

RegisterServerEvent('Khats:server:takepackage', function ()
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)
    local items = Config.Mime[math.random(1,#Config.Mime)]
    local amount = math.random(3)
            Player.Functions.AddItem(items, amount)
        Player.Functions.RemoveItem("package", 1)
        --TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[items], "add")
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["package"], "remove")
    else 
        print("error, no space") end
end)



    local randItem = Config.CrackPool[math.random(1, #Config.CrackPool)]
    amount = math.random(1, 2)
    if Player.Functions.AddItem(randItem, amount) then
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[randItem], 'add', amount)
  