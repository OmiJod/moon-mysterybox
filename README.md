````markdown
# 🎁 QBOX Mystery Box System

An immersive, two-part Mystery Box system for QBOX/QBCore & ESX servers — allowing players to open boxes from their inventory or discover lootable props in the game world. Includes full reward config, cooldown logic, Discord logging, and Ox/QB Inventory support.

---

## ✨ Features

### 📦 Inventory Mystery Boxes
- Configurable box types (`basic_box`, `premium_box`, `mysterybox_grey`, etc.)
- Define:
  - Label & description
  - Reward ranges
  - Rare reward chance & limit
  - Cooldowns per player
  - Separate **common** and **rare** item pools
- Prevents box spam with a cooldown system
- Framework support: **QBCore** & **ESX**
- Inventory support: **ox_inventory** & **qb-inventory**
- Clean UI with `ox_lib` notifications and progress bars
- Discord webhook logging (player name, box used, reward)

### 🌍 World-Spawning Mystery Boxes
- Spawns props at random map locations each restart
- Fully configurable:
  - Max box count
  - Spawn coordinates
  - Props per location
  - Item/money rewards per location
- Players interact using `ox_target`
- Despawn after looting
- Server syncs props on join
- Optional loot cooldown per player

---

## 🛠️ Installation

### 1. SQL Setup
Execute this in your database:

```sql
CREATE TABLE `mysterybox_spawned` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`prop_name` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8mb3_general_ci',
	`x` FLOAT NULL DEFAULT NULL,
	`y` FLOAT NULL DEFAULT NULL,
	`z` FLOAT NULL DEFAULT NULL,
	`heading` FLOAT NULL DEFAULT NULL,
	`location_index` INT(11) NULL DEFAULT NULL,
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='utf8mb3_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=180;
````

---

### 2. Install Items

#### 🔹 QBCore Shared Items

```lua
['basic_box'] = {
    name = 'basic_box',
    label = 'Basic Mystery Box',
    weight = 100,
    type = 'item',
    image = 'basic_box.png',
    unique = true,
    useable = true,
    shouldClose = true
},
['premium_box'] = {
    name = 'premium_box',
    label = 'Premium Mystery Box',
    weight = 100,
    type = 'item',
    image = 'premium_box.png',
    unique = true,
    useable = true,
    shouldClose = true
},
['mysterybox_grey'] = {
    name = 'mysterybox_grey',
    label = 'Grey Mystery Box',
    weight = 100,
    type = 'item',
    image = 'mysterybox_grey.png',
    unique = true,
    useable = true,
    shouldClose = true
}
```

#### 🔸 Ox Inventory Items

```lua
{
  name = 'basic_box',
  label = 'Basic Mystery Box',
  weight = 100,
  stack = false,
  close = true,
  description = 'Open to receive random rewards'
},
{
  name = 'premium_box',
  label = 'Premium Mystery Box',
  weight = 100,
  stack = false,
  close = true,
  description = 'A better mystery box with higher-tier loot'
},
{
  name = 'mysterybox_grey',
  label = 'Grey Mystery Box',
  weight = 100,
  stack = false,
  close = true,
  description = 'Strange box of unknown origin...'
}
```

---

### 3. Configure & Enjoy

* Tweak `config.lua` to customize boxes, rewards, cooldowns, and spawn behavior.
* Set your framework (`qb` or `esx`), inventory type (`ox` or `qb`), and webhook URL.
* Use `debug = true` to test and verify behavior.

---

## 🧠 Notes

* Uses `ox_lib`, `ox_target`, `ox_inventory` or `qb-inventory`, and supports both QBCore & ESX.
* Future-proof, extensible structure for adding new box types, locations, and more.
* Designed with performance and multiplayer sync in mind.

---

## 📸 Screenshots / Demo

*Add your preview GIFs or images here.*

---

## 📞 Support

For issues or feature requests, please open a GitHub issue or contact the developer via Discord.

---
