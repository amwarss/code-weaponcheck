QBCore = exports['qb-core']:GetCoreObject()

local discordWebhookURL = 'https://discordapp.com/api/webhooks/'

local function sendToDiscord(playerName, playerId, weaponName)
    local embed = {
        {
            ["title"] = "Unauthorized Weapon Usage",
            ["description"] = string.format("**Player Name:** %s\n**Player ID:** %s\n**Weapon Used:** %s", playerName, playerId, weaponName),
            ["color"] = 16711680,
            ["footer"] = {
                ["text"] = "Code Police Weapon Restriction"
            },
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }
    }

    PerformHttpRequest(discordWebhookURL, function(err, text, headers) end, 'POST', json.encode({embeds = embed}), {['Content-Type'] = 'application/json'})
end

RegisterServerEvent('qb-policeweapon:checkWeapon')
AddEventHandler('qb-policeweapon:checkWeapon', function(itemName, src)
    local Player = QBCore.Functions.GetPlayer(src)
    for _, weapon in pairs(Config.PoliceWeapons) do
        if weapon == itemName then
            if Player.PlayerData.job.name == Config.PoliceJobName then
                TriggerClientEvent('QBCore:Notify', src, Config.Messages.Authorized, 'success')
                TriggerClientEvent('qb-policeweapon:allowWeapon', src, itemName)
            else
                TriggerClientEvent('QBCore:Notify', src, Config.Messages.Unauthorized, 'error')
                Player.Functions.RemoveItem(itemName, 1)
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[itemName], 'remove')

                TriggerClientEvent('qb-policeweapon:denyWeapon', src, itemName)

                local playerName = GetPlayerName(src)
                local playerId = Player.PlayerData.source
                sendToDiscord(playerName, playerId, itemName)
            end
            break
        end
    end
end)


