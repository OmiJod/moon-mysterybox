Config = {}

Config.Debug = true

Config.Target = "qb-target"

Config.Inventory = "qb"

Config.DiscordWebhook = ''

Config.Boxes = {
    basic_box = {
        label = "Basic Mystery Box",
        description = "A simple box containing random rewards.",
        rewardsMin = 1,
        rewardsMax = 3,
        rareChance = 10, -- in %
        cooldown = 10, -- in seconds
        onlyOneRare = true,
        commonRewards = {
            { item = "water", count = 1 },
            { item = "bread", count = 1 },
            { item = "bandage", count = 1 }
        },
        rareRewards = {
            { item = "weapon_knife", count = 1 },
            { item = "money", amount = 500 }
        }
    },
    premium_box = {
        label = "Premium Box",
        description = "Contains premium loot with higher rare chance.",
        rewardsMin = 2,
        rewardsMax = 4,
        rareChance = 30,
        cooldown = 20,
        onlyOneRare = false,
        commonRewards = {
            { item = "repairkit", count = 1 },
            { item = "sandwich", count = 1 }
        },
        rareRewards = {
            { item = "weapon_pistol", count = 1 },
            { item = "money", amount = 1000 }
        }
    },
    mysterybox_grey = {
        label = "Mystery Box",
        description = "Contains something nice.",
        rewardsMin = 2,
        rewardsMax = 4,
        rareChance = 30,
        cooldown = 30,
        onlyOneRare = false,
        commonRewards = {
            { item = "repairkit", count = 1 },
            { item = "sandwich", count = 1 }
        },
        rareRewards = {
            { item = "weapon_pistol", count = 1 },
            { item = "money", amount = 1000 }
        }
    }
}

Config.SpawnedBoxes = {
    MaxBoxes = 3,
    Locations = {
        {
            coords = vec4(37.80, -1090.96, 28.59, 263), -- Spot 8
            prop = "prop_boxpile_07d",
            lootTable = {
                { item = "water", amount = 8 }
            }
        },
        {
            coords = vec4(36.57, -1093.59, 28.55, 274), -- Spot 7
            prop = "prop_boxpile_07d",
            lootTable = {
                { item = "water", amount = 7 }
            }
        },
        {
            coords = vector4(35.13, -1095.93, 28.51, 271), -- Spot 6
            prop = "prop_boxpile_07d",
            lootTable = {
                { item = "water", amount = 6 }
            }
        },
        {
            coords = vector4(34.00, -1098.36, 28.43, 292), -- Spot 5
            prop = "prop_boxpile_07d",
            lootTable = {
                { item = "water", amount = 5 }
            }
        },
        {
            coords = vector4(32.57, -1100.65, 28.42, 266), -- Spot 4
            prop = "prop_boxpile_07d",
            lootTable = {
                { item = "water", amount = 4 }
            }
        },
        {
            coords = vector4(30.91, -1103.41, 28.37, 272), -- Spot 3
            prop = "prop_boxpile_07d",
            lootTable = {
                { item = "water", amount = 3 }
            }
        },
        {
            coords = vector4(28.47, -1107.86, 28.32, 264), -- Spot 2
            prop = "prop_boxpile_07d",
            lootTable = {
                { item = "water", amount = 2 },
                { item = "weapon_pistol", amount = 2 }
            }
        },
        {
            coords = vector4(27.10, -1110.75, 28.31, 252), -- Spot 1
            prop = "prop_boxpile_02b",
            lootTable = {
                { item = "water", amount = 1 },
                { item = "weapon_rpg", amount = 1 }
            }
        }
    }
}