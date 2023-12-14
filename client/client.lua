ESX = exports["es_extended"]:getSharedObject()

_k = Citizen

local id = GetPlayerServerId(PlayerId())
local name = GetPlayerFromServerId(PlayerId())
local playerName = GetPlayerName(PlayerId())
local grade = ESX.PlayerData.job.grade_name
local money = ESX.PlayerData.money

local recoverPlayerSkin = function()
  ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
      local isMale = skin.sex == 0


      TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
          ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
              TriggerEvent('skinchanger:loadSkin', skin)
              TriggerEvent('esx:restoreLoadout')
          end)
      end)
  end)
end

local choosePed = function()
  local input = lib.inputDialog('Menu Ped', {{label = 'Nom du Ped', description = 'Cherche "Ped model" et inscris le nom du ped.', type = 'input'}, {label = 'Enlever', type = 'checkbox'}, {label = 'Accepter', type = 'checkbox', required = true}})
  if input[2] then
    recoverPlayerSkin()
  end
  local player = PlayerId()
  local pedHash = GetHashKey(input[1])
  RequestModel(pedHash)
  while not HasModelLoaded(pedHash) do
      Wait(100)
      lib.notify({
        title = 'Notification',
        description = 'Le ped est invalide ! ('..input[1]..')',
        position = 'top',
        duration = '500',
        style = {
            backgroundColor = '#141517',
            color = '#FFFFFF',
            ['.description'] = {
              color = '#909296'
            },
        },  
        type = 'error',
      })
      return
  end
  SetPlayerModel(player, pedHash)
  SetModelAsNoLongerNeeded(pedHash)
  lib.notify({
    title = 'Notification',
    description = 'le ped : '..input[1]..' à bien été chargé !',
    position = 'top',
    duration = '500',
    style = {
        backgroundColor = '#141517',
        color = '#FFFFFF',
        ['.description'] = {
          color = '#909296'
        },
    },  
    type = 'success',
  })
end

lib.registerContext({
  id = "administration",
  title = 'Administration',
  onExit = function()
    TriggerEvent('deco')
  end,
  options = {
    {
      title = 'Personnel',
      description = 'Affecte que vous.',
      menu = "perso",
      icon = 'user',
      iconColor = '#FFDDD2',
    },
    {
      title = ' ',
      progress = '100',
    },
    {
      title = 'Annonces',
      description = 'Envoie une notification a tout le serveur.',
      icon = 'bullhorn',
      iconColor = '#F8FFD6',
      onSelect = function()
        local input = lib.inputDialog('Annonces', {{label = 'Redémarage du serveur', type = 'checkbox'}, {label = 'Maintenance', type = 'checkbox'}})
        if input[1] then
          TriggerServerEvent('annonce1')
        elseif input [2] then
          TriggerServerEvent('annonce2')
        end
      end,
    },
    {
      title = 'Téléportation',
      description = 'Se téléporter aux endroits définis.',
      icon = 'location-dot',
      iconColor = '#E3FFFE',
      onSelect = function()
        local player = PlayerPedId()
        local input = lib.inputDialog('Téléportation', {{label = 'Maze Bank', type = 'checkbox'}, {label = 'Fourrière', type = 'checkbox'}, {label = 'Commisariat', type = 'checkbox'}, {label = 'Benny\'s', type = 'checkbox'}, {label = 'Parking Central', type = 'checkbox'}})
        if input[1] then
          SetEntityCoords(player, -75.04, -818.94, 325.17, true)
        elseif input [2] then
          SetEntityCoords(player, 410.24, -1623.71, 28.27, true)
        elseif input [3] then
          SetEntityCoords(player, 427.45, -977.94, 29.69, true)
        elseif input [4] then
          SetEntityCoords(player, -211.50, -1323.58, 29.88, true)
        elseif input [5] then
          SetEntityCoords(player, 215.16, -809.78, 29.72, true)
        end
      end,
    },
    { 
      title = 'Ped',
      description = 'Permet de choisir un Ped !',
      icon = 'street-view',
      iconColor = '#FBE5FF',
      onSelect = function()
          choosePed()
      end
    },
    { 
      title = 'Props',
      description = 'Ajouter des props.',
      icon = 'thumbtack',
      iconColor = '#DA7F7F',  
      onSelect = function()
        lib.showContext('props')
      end,
    },
    {
      title = 'Serveur',
      description = 'Permet de gerer le serveur.',
      icon = 'server',
      iconColor = '#FFFFFF',
      onSelect = function()
        local input = lib.inputDialog('Gestion Serveur', {{label = 'Restart', description = 'Entre le nom de la ressource.', type = 'input'}, {label = 'Refresh serveur', type = 'checkbox'}})
        if input[1] then
          ressource = input[1]
          ExecuteCommand("restart "..ressource)
        elseif input [2] then
          ExecuteCommand("refresh")
        end
      end,
    },
    {
      title = ' ',
      progress = '100',
    },
    {
      title = 'Gestion joueurs',
      description = 'Acceder à la gestion des joueurs.',
      icon = 'gear',
      iconColor = '#D2FFD4',
      menu = 'joueurs',
    },
  }
})

lib.registerContext({
  id = "perso",
  title = 'Personnel',
  menu = "administration",
  options = {
    {
      title = "Tes informations",
      description = 'Regarde à droite !',
      icon = 'clipboard',
      iconColor = '#F8FFD8',
      metadata = {
        {label = 'Id ', value = ' '..id},
        {label = 'Grade ', value = ' '..grade},
        {label = 'Money ', value = ' '..money},
        {label = 'Name ', value = ' '..playerName},
      },
    },
    {
      title = ' ',
      progress = '100',
    },
    {
      title = "Noclip",
      description = 'Activer noclip.',
      onSelect = function()
        local input = lib.inputDialog('Noclip', {{label = 'Activer', type = 'checkbox'}, {label = 'Désactiver', type = 'checkbox'}})
        if input[1] then
          ExecuteCommand('+noclip')
        elseif input [2] then
          ExecuteCommand('-noclip')
        end
      end,
    },
    {
      title = "Téléporter au marker",
      description = 'Permet d\'aller directement sur son marker !',
      onSelect = function()
        ExecuteCommand('tpm')
      end,
    },
    {
      title = "Santé",
      description = 'Permet de se revive tout simplement.',
      onSelect = function()
        local input = lib.inputDialog('Santé', {{label = 'Revive', type = 'checkbox'}, {label = 'Heal', type = 'checkbox'}})
        if input[1] then
          ExecuteCommand('revive me')
        elseif input [2] then
          ExecuteCommand('heal me')
        end
      end,
    },
    {
      title = "Spawn un véhicule",
      description = 'Fait spawn n\'importe quel véhicule !',
      onSelect = function()
        local input = lib.inputDialog('Spawn Véhicule', {{label = 'Véhicule', type = 'input', icon = 'car', description = 'Renseigne le nom du véhicule.', required = true}})
        local veh_model = input[1]
        local vehicleModel = GetHashKey(veh_model)
        if not IsModelInCdimage(vehicleModel) or not IsModelAVehicle(vehicleModel) then
          print("Modèle de véhicule invalide : " .. veh_model)
          lib.notify({
            title = 'Notification',
            description = "Modèle de véhicule invalide : " .. veh_model,
            position = 'top',
            duration = '500',
            style = {
                backgroundColor = '#141517',
                color = '#FFFFFF',
                ['.description'] = {
                  color = '#909296'
                },
            },  
            type = 'error',
          })
          return
        else
          print("Modèle de véhicule valide : " .. veh_model)
          lib.notify({
            title = 'Notification',
            description = "Modèle de véhicule valide : " .. veh_model,
            position = 'top',
            duration = '500',
            style = {
                backgroundColor = '#141517',
                color = '#FFFFFF',
                ['.description'] = {
                  color = '#909296'
                },
            },  
            type = 'success',
          })
        end
        RequestModel(veh_model)
        Citizen.Wait(0)
        local source = source
        local player = PlayerPedId(source)
        local veh_coords = GetEntityCoords(player)
        local veh_Heading = 100
        local veh = CreateVehicle(vehicleModel, veh_coords, veh_Heading, false, false)
          Wait(100)
          local seatIndex = -1
          TaskWarpPedIntoVehicle(player, veh, seatIndex)
      end,
    },
    {
      title = "Delete son véhicule",
      description = 'Supprime le véhicule dans lequel tu te trouves.',
      onSelect = function()
        local GetVeh = GetVehiclePedIsIn(PlayerPedId(), false) 
        local HashVeh = GetEntityModel(GetVeh)
        Wait(100)
          DeleteEntity(GetVeh)
      end,
    },
    {
      title = ' ',
      progress = '100',
    },
    {
      title = "Give",
      description = 'Permet de se give un item.',
      icon = 'circle-plus',
      iconColor = '#F8DBFF',
      onSelect = function()
        local input = lib.inputDialog('Menu Give', {{label = 'Item', type = 'input', icon = 'bookmark', description = 'Que veut-tu te give ?', required = true}, {label = 'Nombre', type = 'number', min = '0', max = '10000', icon = 'hashtag', description = 'Combien d\'items ?', required = true}, {type = 'checkbox', label = 'Accepter', checked = false, required = true}})
          local item = input[1]
          local amount = input[2]
          TriggerServerEvent('give', item, amount)
          lib.notify({
            id = 'success_give',
            title = 'Notification',
            description = 'Give réussi !',
            position = 'top',
            duration = '500',
            style = {
                backgroundColor = '#141517',
                color = '#FFFFFF',
                ['.description'] = {
                  color = '#909296'
                },
            },  
            type = 'success',
        })
      end,
    },
  }
})

lib.registerContext({
  id = "joueurs",
  title = 'Gestion joueurs',
  menu = "administration",
  options = {
    {
      title = "Goto",
      description = 'Se téléporter au joueur définis.',
      icon = 'person-hiking',
      iconColor = '#E2E2FF',
      onSelect = function()
        local input = lib.inputDialog('Goto Id', {{label = 'Id', type = 'number', icon = 'user', description = 'Entre l\'id du joueur', required = true}, {label = 'Accepter', type = 'checkbox', required = true}})
        local id = input[1]
        local command = "goto " .. id
        ExecuteCommand(command)
      end,
    },
    {
      title = ' ',
      progress = '100',
    },
    {
      title = "Revive",
      description = 'Permet de se revive le joueur séléctionné !',
      onSelect = function()
        local input = lib.inputDialog('Revive Id', {{label = 'Id', type = 'number', icon = 'user', description = 'Entre l\'id du joueur', required = true}, {label = 'Accepter', type = 'checkbox', required = true}})
        local id = input[1]
        local command = "revive " .. id
        ExecuteCommand(command)
      end,
    },
    {
      title = "Heal",
      description = 'Soigner le joueur séléctionné.',
      onSelect = function()
        local input = lib.inputDialog('Heal Id', {{label = 'Id', type = 'number', icon = 'user', description = 'Entre l\'id du joueur', required = true}, {label = 'Accepter', type = 'checkbox', required = true}})
        local id = input[1]
        local command = "heal " .. id
        ExecuteCommand(command)
      end,
    },
    {
      title = "Clear Inventaire",
      description = 'Clear l\'inventaire du joueur séléctionné.',
      onSelect = function()
        local input = lib.inputDialog('ClearInv Id', {{label = 'Id', type = 'number', icon = 'user', description = 'Entre l\'id du joueur', required = true}, {label = 'Accepter', type = 'checkbox', required = true}})
        local id = input[1]
        local command = "clearinv " .. id
        ExecuteCommand(command)
      end,
    },
    {
      title = "Freeze",
      description = 'Freeze le joueur séléctionné !',
      onSelect = function()
        local input = lib.inputDialog('Freeze Id', {{label = 'Id', type = 'number', icon = 'user', description = 'Entre l\'id du joueur', required = true}, {label = 'Accepter', type = 'checkbox', required = true}})
        local id = input[1]
        local command = "freeze " .. id
        ExecuteCommand(command)
      end,
    },
    {
      title = "UnFreeze",
      description = 'UnFreeze le joueur séléctionné !',
      onSelect = function()
        local input = lib.inputDialog('UnFreeze Id', {{label = 'Id', type = 'number', icon = 'user', description = 'Entre l\'id du joueur', required = true}, {label = 'Accepter', type = 'checkbox', required = true}})
        local id = input[1]
        local command = "unfreeze " .. id
        ExecuteCommand(command)
      end,
    },
    {
      title = "Jail",
      description = 'Permet de jail le joueur séléctionné.',
      onSelect = function()
        local input = lib.inputDialog('Jail Id', {{label = 'Id', type = 'number', icon = 'user', description = 'Entre l\'id du joueur', required = true}, {label = 'Temps', type = 'number', icon = 'hashtag', description = 'Temps en minute !', required = true}, {label = 'Raison', type = 'input', description = 'Entre la raison du jail', required = true}, {label = 'Accepter', type = 'checkbox', required = true}})
                            
        if not input then return end

        local playerID = tonumber(input[1])
        local jailTime = tonumber(input[2])
        local reason = input[3]

        if playerID and jailTime and reason then
            local position = {
                x = 1642.28,
                y = 2570.56,
                z = 45.56
            }
            TriggerServerEvent('jail', playerID, jailTime, reason, position)
        else
            print("Erreur: ID, Temps ou raison invalide")
        end
      end,
    },
    {
      title = "Save",
      description = 'Save le joueur séléctionné !',
      onSelect = function()
        local input = lib.inputDialog('Save Id', {{label = 'Id', type = 'number', icon = 'user', description = 'Entre l\'id du joueur', required = true}, {label = 'Accepter', type = 'checkbox', required = true}})
        local id = input[1]
        local command = "save " .. id
        ExecuteCommand(command)
      end,
    },
    {
      title = "Kill",
      description = 'kill le joueur séléctionné.',
      onSelect = function()
        local input = lib.inputDialog('Kill Id', {{label = 'Id', type = 'number', icon = 'user', description = 'Entre l\'id du joueur', required = true}, {label = 'Accepter', type = 'checkbox', required = true}})
        local id = input[1]
        local command = "kill " .. id
        ExecuteCommand(command)
      end,
    },
    {
      title = "Job",
      description = 'Permet de setjob le joueur séléctionné.',
      onSelect = function()
        local input = lib.inputDialog('Setjob Id', {{label = 'Id', type = 'number', icon = 'user', description = 'Entre l\'id du joueur', required = true}, {label = 'Job', type = 'input', icon = 'id-badge', description = 'Entre le nouveau job', required = true}, {label = 'Grade', type = 'number', description = 'Entre le grade du job', required = true}, {label = 'Accepter', type = 'checkbox', required = true}})
        local id = input[1]
        local job = input[2]
        local grade = input[3]
        local command = "setjob "..id..' '..job..' '..grade
        ExecuteCommand(command)
        lib.notify({
          id = 'success_give',
          title = 'Notification',
          description = '',
          position = 'top',
          duration = '500',
          style = {
              backgroundColor = '#141517',
              color = '#FFFFFF',
              ['.description'] = {
                color = '#909296'
              },
          },  
          type = 'success',
      })
      end,
    },
    {
      title = ' ',
      progress = '100',
    },
    {
      title = "Bring",
      description = 'téléporter le joueur définis sur toi !',
      icon = 'person-walking-arrow-loop-left',
      iconColor = '#E2E2FF',
      onSelect = function()
        local input = lib.inputDialog('Bring Id', {{label = 'Id', type = 'number', icon = 'user', description = 'Entre l\'id du joueur', required = true}, {label = 'Accepter', type = 'checkbox', required = true}})
        local id = input[1]
        local command = "bring " .. id
        ExecuteCommand(command)
      end,
    },
  }
})


optionsProps = {}

for k,v in pairs(k.props) do
    table.insert(optionsProps, {
        title = v.label, 
        description = 'Model: '..v.model,
        onSelect = function()
            local playerPed = PlayerPedId()
            local wait = 1500
            local _src = source 
            SpawnObj(v.model)
            local nameprops = v.label
            ExecuteCommand("e pickup")
            FreezeEntityPosition(playerPed, true)
            Wait(wait)
            ClearPedTasks(playerPed)
            FreezeEntityPosition(playerPed, false)
            lib.notify({
              title = 'Notification',
              description = 'Vous avez fait spawn : ' ..nameprops,
              position = 'top',
              duration = '500',
              style = {
                  backgroundColor = '#141517',
                  color = '#FFFFFF',
                  ['.description'] = {
                    color = '#909296'
                  },
              },  
              type = 'success',
            })
        end
    })
end

lib.registerContext({
  menu = 'administration',
  id = 'props',
  title = 'Catégorie Props',
  options = optionsProps
})

-- Liste des noms d'administrateurs autorisés

local admins = {
  k.perm.admin1,
  k.perm.admin2,
  k.perm.admin3,
  k.perm.admin4,
  k.perm.admin5,
  k.perm.admin6,
  k.perm.admin7,
  k.perm.admin8,
  k.perm.admin9,
  k.perm.admin10,
}

RegisterNetEvent("connexion")
AddEventHandler("connexion", function()
  local playerName = GetPlayerName(PlayerId())
  local command = "administration"

  function IsAdmin(playerName)
    for _, admin in ipairs(admins) do
      if playerName == admin then
        return true
      end
    end
    return false
  end

  if IsAdmin(playerName) then
    ExecuteCommand("administration")
    Wait(300)
    print("Accès autorisé en tant que : " .. playerName)
    lib.notify({
      title = 'Notification',
      description = "Accès autorisé en tant que : " .. playerName,
      position = 'top',
      duration = '500', -- 5000 millisecondes (5 secondes)
      style = {
        backgroundColor = '#141517',
        color = '#FFFFFF',
        ['.description'] = {
          color = '#909296'
        },
      },
      icon = "id-badge",
      iconColor = '#E2E2FF',
    })
  else
    Wait(300)
    lib.notify({
      title = 'Notification',
      description = 'Vous n\'avez pas les permissions nécessaires',
      position = 'top',
      duration = '500', -- 5000 millisecondes (5 secondes)
      style = {
        backgroundColor = '#141517',
        color = '#FFFFFF',
        ['.description'] = {
          color = '#909296'
        },
      },
      type = 'error',
    })
  end
end)

RegisterNetEvent("deco")
AddEventHandler("deco", function()
  local playerName = GetPlayerName(PlayerId())
  local command = "administration"
  function IsAdmin(playerName)
    -- Vérifiez si le nom du joueur est dans la liste des administrateurs
    for _, admin in ipairs(admins) do
        if playerName == admin then
            return true
        end
    end
    return false
  end  
  -- Exécutez la commande côté client uniquement si le joueur est un administrateur
  if IsAdmin(playerName) then
    Wait(300)
      -- Exécutez la commande en tant qu'administrateur
      print("Déconnection en tant que : " ..playerName)
      lib.notify({
        title = 'Notification',
        description = "Déconnection en tant que : " ..playerName,
        position = 'top',
        duration = '500',
        style = {
            backgroundColor = '#141517',
            color = '#FFFFFF',
            ['.description'] = {
              color = '#909296'
            },
        },  
        icon = 'person-walking-arrow-loop-left',
        iconColor = '#E2E2FF',
      })
    end
end)




RegisterCommand('administration', function() 
  lib.showContext('administration')
end, false)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if IsControlJustPressed(0, 57) then -- https://docs.fivem.net/docs/game-references/controls/ pour changer la touche, to change the key
      TriggerEvent('connexion')
    end
  end
end)




local noclip = false
local noclip_speed = 1.5



--[[
  * Created by MiiMii1205
  * license MIT
--]]

-- Constants --
MOVE_UP_KEY = 20
MOVE_DOWN_KEY = 44
CHANGE_SPEED_KEY = 21
MOVE_LEFT_RIGHT = 30
MOVE_UP_DOWN = 31
NOCLIP_TOGGLE_KEY = 289
NO_CLIP_NORMAL_SPEED = k.speed.noclip_normal
NO_CLIP_FAST_SPEED = k.speed.noclip_run
ENABLE_TOGGLE_NO_CLIP = true
ENABLE_NO_CLIP_SOUND = true

local eps = 0.01
local RESSOURCE_NAME = GetCurrentResourceName();

STARTUP_STRING = ('%s v%s initialized'):format(RESSOURCE_NAME, GetResourceMetadata(RESSOURCE_NAME, 'version', 0))
STARTUP_HTML_STRING = (':business_suit_levitating: %s <small>v%s</small> initialized'):format(RESSOURCE_NAME, GetResourceMetadata(RESSOURCE_NAME, 'version', 0))

-- Variables --
local isNoClipping = false
local playerPed = PlayerPedId()
local playerId = PlayerId()
local speed = NO_CLIP_NORMAL_SPEED
local input = vector3(0, 0, 0)
local previousVelocity = vector3(0, 0, 0)
local breakSpeed = 10.0;
local offset = vector3(0, 0, 1);

local noClippingEntity = playerPed;

function ToggleNoClipMode()
    return SetNoClip(not isNoClipping)
end

function IsControlAlwaysPressed(inputGroup, control) return IsControlPressed(inputGroup, control) or IsDisabledControlPressed(inputGroup, control) end

function IsControlAlwaysJustPressed(inputGroup, control) return IsControlJustPressed(inputGroup, control) or IsDisabledControlJustPressed(inputGroup, control) end

function Lerp (a, b, t) return a + (b - a) * t end

function IsPedDrivingVehicle(ped, veh)
    return ped == GetPedInVehicleSeat(veh, -1);
end

function SetInvincible(val, id)
    SetEntityInvincible(id, val)
    return SetPlayerInvincible(id, val)
end

function SetNoClip(val)

    if (isNoClipping ~= val) then

        noClippingEntity = playerPed;

        if IsPedInAnyVehicle(playerPed, false) then
            local veh = GetVehiclePedIsIn(playerPed, false);
            if IsPedDrivingVehicle(playerPed, veh) then
                noClippingEntity = veh;
            end
        end

        local isVeh = IsEntityAVehicle(noClippingEntity);

        isNoClipping = val;

        if ENABLE_NO_CLIP_SOUND then

            if isNoClipping then
                PlaySoundFromEntity(-1, "SELECT", playerPed, "HUD_LIQUOR_STORE_SOUNDSET", 0, 0)
            else
                PlaySoundFromEntity(-1, "CANCEL", playerPed, "HUD_LIQUOR_STORE_SOUNDSET", 0, 0)
            end

        end

        TriggerEvent('msgprinter:addMessage', ((isNoClipping and ":airplane: No-clip enabled") or ":rock: No-clip disabled"), GetCurrentResourceName());
        SetUserRadioControlEnabled(not isNoClipping);

        if (isNoClipping) then

            TriggerEvent('instructor:add-instruction', { MOVE_LEFT_RIGHT, MOVE_UP_DOWN }, "move", RESSOURCE_NAME);
            TriggerEvent('instructor:add-instruction', { MOVE_UP_KEY, MOVE_DOWN_KEY }, "move up/down", RESSOURCE_NAME);
            TriggerEvent('instructor:add-instruction', { 1, 2 }, "Turn", RESSOURCE_NAME);
            TriggerEvent('instructor:add-instruction', CHANGE_SPEED_KEY, "(hold) fast mode", RESSOURCE_NAME);
            TriggerEvent('instructor:add-instruction', NOCLIP_TOGGLE_KEY, "Toggle No-clip", RESSOURCE_NAME);
            SetEntityAlpha(noClippingEntity, 51, 0)

            -- Start a No CLip thread
            Citizen.CreateThread(function()

                local clipped = noClippingEntity
                local pPed = playerPed;
                local isClippedVeh = isVeh;
                -- We start with no-clip mode because of the above if --
                SetInvincible(true, clipped);

                if not isClippedVeh then
                    ClearPedTasksImmediately(pPed)
                end

                while isNoClipping do
                    Citizen.Wait(0);

                    FreezeEntityPosition(clipped, true);
                    SetEntityCollision(clipped, false, false);

                    SetEntityVisible(clipped, false, false);
                    SetLocalPlayerVisibleLocally(true);
                    SetEntityAlpha(clipped, 51, false)

                    SetEveryoneIgnorePlayer(pPed, true);
                    SetPoliceIgnorePlayer(pPed, true);

                    -- `(a and b) or c`, is basically `a ? b : c` --
                    input = vector3(GetControlNormal(0, MOVE_LEFT_RIGHT), GetControlNormal(0, MOVE_UP_DOWN), (IsControlAlwaysPressed(1, MOVE_UP_KEY) and 1) or ((IsControlAlwaysPressed(1, MOVE_DOWN_KEY) and -1) or 0))
                    speed = ((IsControlAlwaysPressed(1, CHANGE_SPEED_KEY) and NO_CLIP_FAST_SPEED) or NO_CLIP_NORMAL_SPEED) * ((isClippedVeh and 2.75) or 1)

                    MoveInNoClip();

                end

                Citizen.Wait(0);

                FreezeEntityPosition(clipped, false);
                SetEntityCollision(clipped, true, true);

                SetEntityVisible(clipped, true, false);
                SetLocalPlayerVisibleLocally(true);
                ResetEntityAlpha(clipped);

                SetEveryoneIgnorePlayer(pPed, false);
                SetPoliceIgnorePlayer(pPed, false);
                ResetEntityAlpha(clipped);

                Citizen.Wait(500);

                -- We're done with the while so we aren't in no-clip mode anymore --
                -- Wait until the player starts falling or is completely stopped --
                if isClippedVeh then

                    while (not IsVehicleOnAllWheels(clipped)) and not isNoClipping do
                        Citizen.Wait(0);
                    end

                    while not isNoClipping do

                        Citizen.Wait(0);

                        if IsVehicleOnAllWheels(clipped) then

                            -- We hit land. We can safely remove the invincibility --
                            return SetInvincible(false, clipped);

                        end

                    end

                else

                    if (IsPedFalling(clipped) and math.abs(1 - GetEntityHeightAboveGround(clipped)) > eps) then
                        while (IsPedStopped(clipped) or not IsPedFalling(clipped)) and not isNoClipping do
                            Citizen.Wait(0);
                        end
                    end

                    while not isNoClipping do

                        Citizen.Wait(0);

                        if (not IsPedFalling(clipped)) and (not IsPedRagdoll(clipped)) then

                            -- We hit land. We can safely remove the invincibility --
                            return SetInvincible(false, clipped);

                        end

                    end

                end

            end)

        else
            ResetEntityAlpha(noClippingEntity)
            TriggerEvent('instructor:flush', RESSOURCE_NAME);
        end

    end

end

function MoveInNoClip()

    SetEntityRotation(noClippingEntity, GetGameplayCamRot(0), 0, false)
    local forward, right, up, c = GetEntityMatrix(noClippingEntity);
    previousVelocity = Lerp(previousVelocity, (((right * input.x * speed) + (up * -input.z * speed) + (forward * -input.y * speed))), Timestep() * breakSpeed);
    c = c + previousVelocity
    SetEntityCoords(noClippingEntity, c - offset, true, true, true, false)

end

function MoveCarInNoClip()

    SetEntityRotation(noClippingEntity, GetGameplayCamRot(0), 0, false)
    local forward, right, up, c = GetEntityMatrix(noClippingEntity);
    previousVelocity = Lerp(previousVelocity, (((right * input.x * speed) + (up * input.z * speed) + (forward * -input.y * speed))), Timestep() * breakSpeed);
    c = c + previousVelocity
    SetEntityCoords(noClippingEntity, (c - offset) + (vec(0, 0, .3)), true, true, true, false)

end

AddEventHandler('playerSpawned', function()

    playerPed = PlayerPedId()
    playerId = PlayerId()

end)

AddEventHandler('RCC:newPed', function()

    playerPed = PlayerPedId()
    playerId = PlayerId()

end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == RESSOURCE_NAME then
        SetNoClip(false);
        FreezeEntityPosition(noClippingEntity, false);
        SetEntityCollision(noClippingEntity, true, true);

        SetEntityVisible(noClippingEntity, true, false);
        SetLocalPlayerVisibleLocally(true);
        ResetEntityAlpha(noClippingEntity);

        SetEveryoneIgnorePlayer(playerPed, false);
        SetPoliceIgnorePlayer(playerPed, false);
        ResetEntityAlpha(noClippingEntity);
        SetInvincible(false, noClippingEntity);
    end
end)

Citizen.CreateThread(function()

    print('{ By Kiwi }')
    TriggerEvent('msgprinter:addMessage', STARTUP_HTML_STRING, GetCurrentResourceName());

    if ENABLE_TOGGLE_NO_CLIP then

        RegisterCommand("noClip", function(source, args, rawCommand)
            SetNoClip(tonumber(args[1]) == 1)
        end)

        RegisterCommand("+noClip", function(source, rawCommand)
            SetNoClip(true)
        end)
        RegisterCommand("-noClip", function(source, rawCommand)
            SetNoClip(false)
        end)

        RegisterCommand("toggleNoClip", function(source, rawCommand)
            ToggleNoClipMode()
        end)
    end

end)

function SpawnObj(obj)
  local playerPed = PlayerPedId()
  local coords, forward = GetEntityCoords(playerPed), GetEntityForwardVector(playerPed)
  local objectCoords = (coords + forward * 1.0)
  local Ent = nil

  SpawnObject(obj, objectCoords, function(obj)
      SetEntityCoords(obj, objectCoords, 0.0, 0.0, 0.0, 0)
      SetEntityHeading(obj, GetEntityHeading(playerPed))
      PlaceObjectOnGroundProperly(obj)
      Ent = obj
      Wait(1)
  end)
  Wait(1)
  while Ent == nil do Wait(1) end
  SetEntityHeading(Ent, GetEntityHeading(playerPed))
  PlaceObjectOnGroundProperly(Ent)
  local placed = false
  while not placed do
      _k.Wait(1)
      local coords, forward = GetEntityCoords(playerPed), GetEntityForwardVector(playerPed)
      local objectCoords = (coords + forward * 1.0)
      SetEntityCoords(Ent, objectCoords, 0.0, 0.0, 0.0, 0)
      SetEntityHeading(Ent, GetEntityHeading(playerPed))
      PlaceObjectOnGroundProperly(Ent)
      SetEntityAlpha(Ent, 170, 170)

      if IsControlJustReleased(1, 38) then
          placed = true
      end
  end

  FreezeEntityPosition(Ent, true)
  SetEntityInvincible(Ent, true)
  ResetEntityAlpha(Ent)
end

function SpawnObject(model, coords, cb)
  local model = GetHashKey(model)

  _k.CreateThread(function()
      RequestModels(model)
      Wait(1)
      local obj = CreateObject(model, coords.x, coords.y, coords.z, true, false, true)

      if cb then
          cb(obj)
      end
  end)
end

function RequestModels(modelHash)
  if not HasModelLoaded(modelHash) and IsModelInCdimage(modelHash) then
      RequestModel(modelHash)

      while not HasModelLoaded(modelHash) do
          _k.Wait(1)
      end
  end
end
