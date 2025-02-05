# منع استخدام المعدات العسكرية لغير العسكريين

## الوصف
هذا السكربت يمنع اللاعبين غير العسكريين من استخدام المعدات العسكرية، مما يساعد على الحد من تهريب الأسلحة والتخريب داخل السيرفر. يهدف السكربت إلى تحسين بيئة اللعب ومنع الشرطة أو اللاعبين غير المصرح لهم من استخدام الأسلحة العسكرية وقتل المتعة في السيرفر.

## كيفية التعديل والاستخدام
- يعتمد السكربت على **QBCore Framework**.
- لاستخدامه، يجب التعديل في **السيرفر سايت** داخل الحقيبة.
- عند محاولة لاعب غير مصرح له باستخدام سلاح عسكري، سيتم منعه تلقائيًا.

## المتطلبات
- سيرفر يعمل بنظام **QBCore**.
- سكربت **qb-inventory** أو أي سكربت حقيبة متوافق.
- سكربت **qb-policeweapon** (أو أي سكربت مسؤول عن التحقق من صلاحيات استخدام الأسلحة).

---

# Restrict Military Equipment Usage for Non-Military Players

## Description
This script prevents non-military players from using military equipment, helping to reduce weapon smuggling and server disruption. It aims to enhance gameplay by restricting unauthorized players, including police, from using military weapons and disrupting the server experience.

## How to Modify and Use
- This script is based on the **QBCore Framework**.
- To use it, modifications must be made in the **server-side** inventory system.
- If an unauthorized player attempts to use a military weapon, they will be automatically restricted.

## Requirements
- A server running **QBCore**.
- **qb-inventory** script or any compatible inventory script.
- **code-weaponcheck** script (or any script handling weapon usage permissions).


Search for this RegisterNetEvents

inventory:server:UseItemSlot

inventory:server:UseItem

and replace this on qb-inventory\server

RegisterNetEvent('inventory:server:UseItemSlot', function(slot)
    local src = source
    local itemData = GetItemBySlot(src, slot)
    if not itemData then return end
    local itemInfo = QBCore.Shared.Items[itemData.name]
    if itemData.type == "weapon" then
        TriggerEvent('qb-policeweapon:checkWeapon', itemData.name, src)
        TriggerClientEvent("inventory:client:UseWeapon", src, itemData, itemData.info.quality and itemData.info.quality > 0)
        TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "use")
    elseif itemData.useable then
        UseItem(itemData.name, src, itemData)
        TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "use")
    end
end)

RegisterNetEvent('inventory:server:UseItem', function(inventory, item)
    local src = source
    if inventory ~= "player" and inventory ~= "hotbar" then return end
    local itemData = GetItemBySlot(src, item.slot)
    if not itemData then return end
    local itemInfo = QBCore.Shared.Items[itemData.name]
    if itemData.type == "weapon" then
        TriggerEvent('qb-policeweapon:checkWeapon', itemData.name, src)
        TriggerClientEvent("inventory:client:UseWeapon", src, itemData, itemData.info.quality and itemData.info.quality > 0)
        TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "use")
    else
        UseItem(itemData.name, src, itemData)
        TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "use")
    end
