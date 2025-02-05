QBCore = exports['qb-core']:GetCoreObject()

local function autoDetectClothingSystem()
    local systems = {
        ["illenium-appearance"] = "illenium-appearance",
        ["fivem-appearance"] = "fivem-appearance",
        ["qb-clothing"] = "qb-clothing"
    }

    for resource, system in pairs(systems) do
        if GetResourceState(resource) == "started" then
            return system
        end
    end

    return nil
end

local clothingSystem = Config.ClothingSystem

if clothingSystem == "auto" then
    clothingSystem = autoDetectClothingSystem()
end

if clothingSystem then
    print("[QB-PoliceWeapon] Detected clothing system : " .. clothingSystem)
else
    print("[QB-PoliceWeapon]  Using configured clothing system: !")
end

RegisterNetEvent('qb-policeweapon:denyWeapon')
AddEventHandler('qb-policeweapon:denyWeapon', function(itemName)
    if clothingSystem == "illenium-appearance" then
        TriggerEvent("illenium-appearance:client:reloadSkin")
        TriggerEvent("illenium-appearance:ReloadSkin")
    elseif clothingSystem == "fivem-appearance" then
        TriggerEvent("fivem-appearance:client:reloadSkin")
    elseif clothingSystem == "qb-clothing" then
        TriggerEvent("qb-clothing:client:reloadSkin")
    else
        print("[QB-PoliceWeapon] No valid clothing system found.")
    end
end)
