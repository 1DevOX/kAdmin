ESX = exports["es_extended"]:getSharedObject()

RegisterServerEvent("give")
AddEventHandler("give",function(item, amount)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addInventoryItem(item, amount)
end)

RegisterServerEvent("annonce1")
AddEventHandler("annonce1",function()
    notif1(annonce1)
end)

RegisterServerEvent("annonce2")
AddEventHandler("annonce2",function()
    notif2(annonce2)
end)

RegisterServerEvent("annonce3")
AddEventHandler("annonce3",function()
    notif3(annonce3)
end)

function notif1(annonce1)
local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        TriggerClientEvent('ox_lib:notify', xPlayers[i], {
            id = 'notif',
            title = 'Annonce',
            description = 'Redémarage du serveur !',
            position = 'top',
            duration = '1500',
            style = {
                backgroundColor = '#141517',
                color = '#FFFFFF',
                ['.description'] = {
                  color = '#909296'
                },
            },
            icon = 'bullhorn',
            iconColor = '#F8FFD6'
        })
    end
end

function notif2(annonce2)
local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        TriggerClientEvent('ox_lib:notify', xPlayers[i], {
            id = 'notif',
            title = 'Annonce',
            description = 'Maintenance du serveur !',
            position = 'top',
            duration = '1500',
            style = {
                backgroundColor = '#141517',
                color = '#FFFFFF',
                ['.description'] = {
                  color = '#909296'
                },
            },
            icon = 'bullhorn',
            iconColor = '#F8FFD6'
        })
    end
end

    local jailedPlayers = {}

    local function jailPlayer(source, targetId, jailTime, reason, position)
        local xPlayer = ESX.GetPlayerFromId(source)
        local targetPlayer = ESX.GetPlayerFromId(targetId)
    
        local targetName = GetPlayerName(targetId)
        local jailerName = GetPlayerName(source)
    
        MySQL.Async.execute('INSERT INTO jail (identifier, name, jailTime, reason, jailer) VALUES (@identifier, @name, @jailTime, @reason, @jailer)', {
            ['@identifier'] = targetPlayer.getIdentifier(),
            ['@name'] = targetName,
            ['@jailTime'] = jailTime,
            ['@reason'] = reason,
            ['@jailer'] = jailerName
        })
    
        targetPlayer.setCoords(position)
    
        jailedPlayers[targetId] = {releaseTime = os.time() + jailTime * 60, isJailed = true, manualUnjail = false}
    
        xPlayer.showNotification('Vous avez emprisonné ' .. targetName .. ' pour ' .. jailTime .. ' minutes pour la raison suivante : ' .. reason)

    end
    
    local function unjailPlayer(identifier)
        local xPlayer = ESX.GetPlayerFromIdentifier(identifier)
    
        if xPlayer then
            if jailedPlayers[xPlayer.source] then
                jailedPlayers[xPlayer.source].manualUnjail = true
            end
    
            local position = {
                x = 1847.9,
                y = 2586.2,
                z = 45.7
            }
    
            xPlayer.setCoords(position)
    
            MySQL.Async.execute('DELETE FROM jail WHERE identifier = @identifier', {
                ['@identifier'] = identifier
            })

        end
    end
    
    RegisterServerEvent('jail')
    AddEventHandler('jail', function(playerID, jailTime, reason, position)
        local source = source
        local targetPlayer = ESX.GetPlayerFromId(playerID)
    
        if targetPlayer and jailTime and reason then
            jailPlayer(source, playerID, jailTime, reason, position)
        else
            print("Erreur: ID de joueur, Temps ou raison invalide")
        end
    end)
    
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1000)
    
            for playerId, data in pairs(jailedPlayers) do
                if data.manualUnjail == false and os.time() >= data.releaseTime then
                    local xPlayer = ESX.GetPlayerFromId(playerId)
    
                    if xPlayer then
                        MySQL.Async.fetchScalar('SELECT identifier FROM jail WHERE identifier = @identifier', {
                            ['@identifier'] = xPlayer.getIdentifier()
                        }, function(result)
                            if result then
                                local position = {
                                    x = 1847.9,
                                    y = 2586.2,
                                    z = 45.7
                                }
    
                                xPlayer.setCoords(position)
    
                                MySQL.Async.execute('DELETE FROM jail WHERE identifier = @identifier', {
                                    ['@identifier'] = xPlayer.getIdentifier()
                                })
    
                                jailedPlayers[playerId] = nil

                            end
                        end)
                    end
                end
            end
        end
end)

    