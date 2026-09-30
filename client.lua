local ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('evade:activate')
AddEventHandler('evade:activate', function()
    local playerPed = PlayerPedId()
    SetEntityInvincible(playerPed, true)
    Citizen.Wait(Config.EvadeTime * 1000)
    SetEntityInvincible(playerPed, false)
    TriggerServerEvent('evade:deactivate')
end)

RegisterNetEvent('evade:notify')
AddEventHandler('evade:notify', function(message)
    ESX.ShowNotification(message)
end)