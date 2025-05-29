local QBCore = exports['qb-core']:GetCoreObject()
local spawnedBoxes = {} 


RegisterNetEvent('mysterybox:openBox', function(boxType)
    local src = source
    local xPlayer = GetPlayerName(src)
    local boxConfig = Config.Boxes[boxType]
    local Player = QBCore.Functions.GetPlayer(src)

    if not boxConfig then return end

    local onCooldown, remaining = IsOnCooldown(src)
    if onCooldown then
        TriggerClientEvent('ox_lib:notify', src, {
            description = ("You must wait %d seconds before opening another box."):format(remaining),
            type = 'error'
        })
        return
    end

    SetCooldown(src, boxConfig.cooldown)
    if Config.Inventory == "ox" then
        exports.ox_inventory:RemoveItem(src, boxType, 1)
    elseif Config.Inventory == "qb" then
        Player.Functions.RemoveItem(boxType, 1)
    end

    local rewards = GiveReward(src, boxConfig)
    SendWebhookLog(xPlayer, boxConfig.label, rewards)
end)


lib.callback.register('mysterybox:checkCooldown', function(source, boxType)
    local onCooldown, remaining = IsOnCooldown(source)
    if onCooldown then
        return { canOpen = false, remaining = remaining }
    end
    return { canOpen = true }
end)


AddEventHandler('onResourceStart', function(res)
    if res ~= GetCurrentResourceName() then return end

    MySQL.Async.execute('DELETE FROM mysterybox_spawned', {}, function()
        local possibleLocations = Config.SpawnedBoxes.Locations
        local maxBoxes = math.min(Config.SpawnedBoxes.MaxBoxes or 10, #possibleLocations)
        local selectedIndices = {}
        local count = 0
        while count < maxBoxes do
            local rand = math.random(1, #possibleLocations)
            if not selectedIndices[rand] then
                selectedIndices[rand] = true
                count = count + 1
                local data = possibleLocations[rand]
                MySQL.Async.execute('INSERT INTO mysterybox_spawned (prop_name, x, y, z, heading, location_index) VALUES (?, ?, ?, ?, ?, ?)', {
                    data.prop, data.coords.x, data.coords.y, data.coords.z, data.coords.w, rand
                })
            end
        end        

        Wait(500)
        RefreshSpawnedBoxes()
    end)
end)

for boxName, boxData in pairs(Config.Boxes) do
    QBCore.Functions.CreateUseableItem(boxName, function(source, item)
        TriggerClientEvent('mysterybox:useBox', source, boxName)
    end)
end

RegisterNetEvent("mysterybox:playerLoaded", function()
    local src = source
    MySQL.Async.fetchAll('SELECT * FROM mysterybox_spawned', {}, function(rows)
        -- Store location index in memory
        for _, row in ipairs(rows) do
            if not spawnedBoxes[row.id] then
                spawnedBoxes[row.id] = {
                    netId = nil, 
                    locationIndex = row.location_index
                }
            end
        end
        TriggerClientEvent("mysterybox:spawnProps", src, rows)
    end)
end)

RegisterNetEvent("mysterybox:registerProp", function(boxId, netId)
    if not spawnedBoxes[boxId] then
        spawnedBoxes[boxId] = { netId = netId, locationIndex = 1 } -- fallback if something fails
    else
        spawnedBoxes[boxId].netId = netId
    end
end)

RegisterNetEvent("mysterybox:lootProp", function(boxId)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    local boxData = spawnedBoxes[boxId]
    if not boxData then return end
    local locationData = Config.SpawnedBoxes.Locations[boxData.locationIndex]
    if not locationData or not locationData.lootTable then return end
    local onCooldown, remaining = IsOnCooldown(src)
    if onCooldown then
        TriggerClientEvent('ox_lib:notify', src, {
            description = ("You must wait %d seconds before opening another box."):format(remaining),
            type = 'error'
        })
        return
    end

    SetCooldown(src, 3000)
    local reward = locationData.lootTable[math.random(1, #locationData.lootTable)]
    if reward.item == "money" then
        player.Functions.AddMoney("cash", reward.amount)
    else
        player.Functions.AddItem(reward.item, reward.amount)
    end



    MySQL.Async.execute('DELETE FROM mysterybox_spawned WHERE id = ?', {boxId})
    TriggerClientEvent("mysterybox:despawnProp", -1, boxId)
    spawnedBoxes[boxId] = nil
end)

function RefreshSpawnedBoxes()
    MySQL.Async.fetchAll('SELECT * FROM mysterybox_spawned', {}, function(rows)
        for _, player in pairs(QBCore.Functions.GetQBPlayers()) do
            TriggerClientEvent("mysterybox:spawnProps", player.PlayerData.source, rows)
        end
    end)
end
