local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('evade:check', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerId = xPlayer.identifier

    MySQL.Async.fetchScalar('SELECT evade_active FROM evade_system WHERE player_id = @player_id', {
        ['@player_id'] = playerId
    }, function(result)
        if result then
            cb(result)
        else
            MySQL.Async.execute('INSERT INTO evade_system (player_id) VALUES (@player_id)', {
                ['@player_id'] = playerId
            }, function()
                cb(false)
            end)
        end
    end)
end)

RegisterNetEvent('evade:activate')
AddEventHandler('evade:activate', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerId = xPlayer.identifier

    if xPlayer.getAccount('bank').money >= Config.EvadePrice then
        xPlayer.removeAccountMoney('bank', Config.EvadePrice)
        MySQL.Async.execute('UPDATE evade_system SET evade_active = TRUE, evade_end_time = UNIX_TIMESTAMP() + @evade_time WHERE player_id = @player_id', {
            ['@player_id'] = playerId,
            ['@evade_time'] = Config.EvadeTime
        }, function()
            TriggerClientEvent('evade:activate', source)
        end)
    else
        TriggerClientEvent('evade:notify', source, 'Not enough money in bank account')
    end
end)

RegisterNetEvent('evade:deactivate')
AddEventHandler('evade:deactivate', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerId = xPlayer.identifier

    MySQL.Async.execute('UPDATE evade_system SET evade_active = FALSE, evade_cooldown_end_time = UNIX_TIMESTAMP() + @evade_cooldown WHERE player_id = @player_id', {
        ['@player_id'] = playerId,
        ['@evade_cooldown'] = Config.EvadeCooldown
    })
end)