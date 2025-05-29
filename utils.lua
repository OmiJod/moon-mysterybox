local playerCooldowns = {}

function IsOnCooldown(source)
    local now = os.time()
    local cooldownEnd = playerCooldowns[source]
    if cooldownEnd and cooldownEnd > now then
        return true, cooldownEnd - now
    end
    return false, 0
end

function SetCooldown(source, seconds)
    playerCooldowns[source] = os.time() + seconds
end

function SendWebhookLog(playerName, boxType, rewards)
    if not Config.DiscordWebhook or Config.DiscordWebhook == "" then return end

    local rewardStr = ""
    for _, reward in ipairs(rewards) do
        if reward.item == "money" then
            rewardStr = rewardStr .. string.format("- 💵 %s\n", reward.amount)
        else
            rewardStr = rewardStr .. string.format("- 📦 %s x%d\n", reward.item, reward.count)
        end
    end

    local data = {
        username = "Mystery Box Logs",
        embeds = {{
            title = "🎁 Mystery Box Opened",
            description = string.format("**Player:** %s\n**Box Type:** %s\n\n**Rewards:**\n%s", playerName, boxType, rewardStr),
            color = 3447003
        }}
    }

    PerformHttpRequest(Config.DiscordWebhook, function() end, 'POST', json.encode(data), {
        ['Content-Type'] = 'application/json'
    })
end

function GiveReward(source, boxConfig)
    local rewardsGiven = {}
    local Player = QBCore.Functions.GetPlayer(source)

    local totalRewards = math.random(boxConfig.rewardsMin, boxConfig.rewardsMax)
    local addedRare = false

    for i = 1, totalRewards do
        local isRare = math.random(100) <= boxConfig.rareChance
        if isRare and not (boxConfig.onlyOneRare and addedRare) and #boxConfig.rareRewards > 0 then
            local reward = boxConfig.rareRewards[math.random(#boxConfig.rareRewards)]
            table.insert(rewardsGiven, reward)
            addedRare = true
        else
            local reward = boxConfig.commonRewards[math.random(#boxConfig.commonRewards)]
            table.insert(rewardsGiven, reward)
        end
    end

    for _, reward in ipairs(rewardsGiven) do
        if reward.item == "money" then
            Player.Functions.AddMoney('cash', reward.amount, 'Mystery Box')
        else
            if Config.Inventory == "ox" then
                exports.ox_inventory:AddItem(source, boxType, 1)
            elseif Config.Inventory == "qb" then
                Player.Functions.AddItem(boxType, 1)
            end
        end
    end

    return rewardsGiven
end
