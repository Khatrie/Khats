local QBCore = exports['qb-core']:GetCoreObject()
local pedSpawned = false
local onjob = false
local dropoffblip = nil
local dealerblip = nil
local package = nil

 function getpackage()
    package = AddBlipForCoord(-1273.18, -1371.93)
	SetBlipAsShortRange(package, true)
	SetBlipSprite(package, 501)
	SetBlipColour(package, 37)
	SetBlipScale(package, 0.7)
	SetBlipDisplay(package, 6)
	BeginTextCommandSetBlipName('Pickup')
	AddTextComponentString('Pickup')
	EndTextCommandSetBlipName('Pickup')
    SetNewWaypoint(-1273.18, -1371.93)
end

RegisterNetEvent('Khats:startjob', function()
    if not onjob then
         print("started")
         QBCore.Functions.Notify("New Email.", 'error', 2500)
         TriggerServerEvent('qb-phone:server:sendNewMail', {
            sender = "Unknown",
            subject = "Location",
            message = "I'll send the location to your GPS soon, Make it quick.",
        })
        Citizen.Wait(math.random(20000, 60000))
        boxzonecreate()
        getpackage()
            exports['qb-target']:RemoveZone("startrun")
            onjob = true
    else
        QBCore.Functions.Notify("You're already on the job idiot.", 'error', 5000)
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    onjob = false
end)

function spawnguard()
    local chance = math.random(1,#Config.Locations)
    local modelHash = `mp_m_securoguard_01` -- The ` return the jenkins hash of a string. see more at: https://cookbook.fivem.net/2019/06/23/lua-support-for-compile-time-jenkins-hashes/

                        if not HasModelLoaded(modelHash) then
                        RequestModel(modelHash)
                            while not HasModelLoaded(modelHash) do
                                Wait(100)
                            end
                        end

                local oxydealer = CreatePed(1, modelHash, Config.Locations[chance], false)
                                SetEntityInvincible(oxydealer, true)
                                SetBlockingOfNonTemporaryEvents(oxydealer, true)
                                FreezeEntityPosition(oxydealer, true)

                exports['qb-target']:AddCircleZone('startrun', Config.Locations[chance], 0.5, {
                    name='startrun',
                    debugPoly=false,
                    minZ = 3.30,
                    maxZ = 5.50,
                    }, {
                        options = {
                            {
                                type = 'client',
                                event = 'Khats:startjob',
                                icon = 'fas fa-box-open',
                                label = 'Start Job',
                            },
                        },
                    distance = 3.5
                })
                pedSpawned = true
end

function animation()
    TriggerEvent('animations:client:EmoteCommandStart', {"Give"})
    QBCore.Functions.Progressbar("givetake2_b", "Inspecting Package", 5000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
    }, {}, {}, function() -- Done
    end)
end

function spawndrop()
    Citizen.Wait(1000)
    local hasitem = QBCore.Functions.HasItem("package")
    if hasitem == true then
    local chance = math.random(1,#Config.Dropoff)
    local modelHash = `a_m_m_acult_01` -- The ` return the jenkins hash of a string. see more at: https://cookbook.fivem.net/2019/06/23/lua-support-for-compile-time-jenkins-hashes/
                        SetNewWaypoint(Config.Dropoff[chance])
                        if not HasModelLoaded(modelHash) then
                        RequestModel(modelHash)
                            while not HasModelLoaded(modelHash) do
                                Wait(100)
                            end
                        end
                dealer = CreatePed(1, modelHash, Config.Dropoff[chance], true)
                                SetBlockingOfNonTemporaryEvents(dealer, true)
                exports['qb-target']:AddCircleZone('drop', Config.Dropoff[chance], 1.5, {
                    name='drop',
                    debugPoly=false,
                    minZ = 3.30,
                    maxZ = 5.50,
                    }, {
                        options = {
                            {
                                type = 'client',
                                event = 'Khats:dropoff',
                                icon = 'fas fa-box-open',
                                label = 'Dropoff Package',
                            },
                        },
                    distance = 3.5
                })
            else
                onjob = false
                QBCore.Functions.Notify("Gameover.", 'error', 5000)
            end
            end

function deletedealer()
    if DoesEntityExist(dealer) then
        DeleteEntity(dealer)
    end
end

function continue()
    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items[reward], "add")
    Citizen.Wait(1000)
    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["package"], "remove")
    Citizen.Wait(10000)
    exports['qb-target']:RemoveZone("drop")
    deletedealer()
    spawndrop()
end

RegisterNetEvent('Khats:dropoff', function ()
    QBCore.Functions.Notify("Dropping off", 'error', 5000)

    local hasItem = QBCore.Functions.HasItem("package")
    local reward = Config.Mime[math.random(1,#Config.Mime)]

    if hasItem then
        animation()
        local hasItem2 = QBCore.Functions.HasItem("smallnote")
        local hasItem3 = QBCore.Functions.HasItem("mediumnote")
        local hasItem4 = QBCore.Functions.HasItem("largenote")
            if hasItem2 then
                local amount = math.random(3)
                TriggerServerEvent('QBCore:Server:RemoveItem', "package", 1)
                TriggerServerEvent('QBCore:Server:RemoveItem', "smallnote", 1)
                TriggerServerEvent('QBCore:Server:AddItem', reward, amount)
                TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items[reward], "add")
                continue()
            elseif hasItem3 then
                TriggerServerEvent('QBCore:Server:RemoveItem', "package", 1)
                TriggerServerEvent('QBCore:Server:RemoveItem', "mediumnote", 1)
                TriggerServerEvent('QBCore:Server:AddItem', reward, math.random(3))
                Citizen.Wait(1000)
                TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items[reward], "add")
                continue()
            elseif hasItem4 then
                TriggerServerEvent('QBCore:Server:RemoveItem', "package", 1)
                TriggerServerEvent('QBCore:Server:RemoveItem', "largenote", 1)
                TriggerServerEvent('QBCore:Server:AddItem', reward, math.random(5))
                Citizen.Wait(1000)
                TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items[reward], "add")
                continue()
            elseif hasItem then 
                TriggerServerEvent('QBCore:Server:AddItem', reward, 1)
                TriggerServerEvent('QBCore:Server:RemoveItem', "package", 1)
                TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items[reward], "add")
                continue()
            elseif not hasItem then
                onjob = false
            end
        end
    end)

function boxzonecreate()
    exports['qb-target']:AddBoxZone('oxypickup', vector3(-1273.2, -1371.91, 4.3), 2, 2, {
    name='oxypickup',
    heading=200,
    debugPoly=true,
    minZ = 3.30,
    maxZ = 5.50,
    }, {
        options = {
            {
                type = 'client',
                event = 'PickupPackage',
                icon = 'fas fa-box-open',
                label = 'Pickup Package',
            },
        },
    distance = 3.5
})
end

RegisterNetEvent('PickupPackage', function ()
        RemoveBlip(package)
        local random = math.random(100)

        if random >= 1 and random <= 20 then 
            amount = '5'
        elseif random >= 21 and random <= 35 then 
            amount = '6'
        elseif random >= 36 and random <= 49 then 
            amount = '7'
        elseif random >= 50 and random <= 69 then 
            amount = '8'
        elseif random >= 70 and random <= 79 then 
            amount = '9'
        elseif random >= 80 and random <= 100 then 
            amount = '10'
        end
        TriggerServerEvent('QBCore:Server:AddItem', "package", amount)
        --TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["package"], "add")
        exports['qb-target']:RemoveZone("oxypickup")
        spawndrop()
end)

function Blip()
    local package = AddBlipForCoord(-1273.18, -1371.93)
    SetBlipAsShortRange(package, true)
    SetBlipSprite(package, 501)
    SetBlipColour(package, 37)
    SetBlipScale(package, 0.7)
    SetBlipDisplay(package, 6)
    BeginTextCommandSetBlipName('Pickup')
    AddTextComponentString('Pickup')
    EndTextCommandSetBlipName('Pickup')
end

Citizen.CreateThread(function()
    if pedSpawned then return end
        spawnguard()
end)

RegisterCommand('ks', function (input)
    print("Onjob", #Config.Rewards)
    print("Pedspawned", pedSpawned)
    QBCore.Functions.Notify("State 2 activate/start", 'error', 5000)
end)

RegisterCommand('ds', function (input)
        print(Location)
end)

RegisterCommand('st', function (input)
    onjob = false
    spawnguard()
    QBCore.Functions.Notify("restarted script", 'error', 5000)
end)

RegisterCommand('rz', function (input)
    exports['qb-target']:RemoveZone("drop")
    exports['qb-target']:RemoveZone("startrun")
    QBCore.Functions.Notify("restarted script", 'error', 5000)
end)