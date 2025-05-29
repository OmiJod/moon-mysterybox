local spawnedProps = {}

RegisterNetEvent('mysterybox:useBox', function(boxType)
    local boxData = Config.Boxes[boxType]
    if not boxData then return end

    lib.callback('mysterybox:checkCooldown', false, function(response)
        if not response.canOpen then
            lib.notify({
                description = ("You must wait %d seconds before opening another box."):format(response.remaining),
                type = 'error'
            })
            return
        end

        lib.progressBar({
            duration = 3500,
            label = 'Opening Mystery Box...',
            useWhileDead = false,
            canCancel = false,
            disable = {
                move = true,
                car = true,
                mouse = false,
                combat = true,
            }
        })

        TriggerServerEvent('mysterybox:openBox', boxType)
    end, boxType)
end)

RegisterNetEvent("mysterybox:spawnProps", function(boxes)
    for _, box in pairs(boxes) do
        local model = box.prop_name
        local coords = vector3(box.x, box.y, box.z)
        local heading = box.heading

        RequestModel(model)
        while not HasModelLoaded(model) do Wait(0) end

        local prop = CreateObject(GetHashKey(model), coords.x, coords.y, coords.z, true, false, true)
        SetEntityHeading(prop, heading)

        local netId = ObjToNet(prop)
        SetNetworkIdExistsOnAllMachines(netId, true)
        SetNetworkIdCanMigrate(netId, false)

        spawnedProps[box.id] = netId
        TriggerServerEvent("mysterybox:registerProp", box.id, netId)

        if Config.Target == "qb-target" then
            exports['qb-target']:AddTargetEntity(prop, {
                options = {
                    {
                        icon = 'fa-solid fa-box',
                        label = 'Open Mystery Box',
                        action = function()
                            lib.callback('mysterybox:checkCooldown', false, function(response)
                                if not response.canOpen then
                                    lib.notify({
                                        description = ("You must wait %d seconds before opening another box."):format(response.remaining),
                                        type = 'error'
                                    })
                                    return
                                end
                        
                                if lib.progressBar({
                                    duration = 2000,
                                    label = 'Opening Mystery Box',
                                    useWhileDead = false,
                                    canCancel = true,
                                    disable = {
                                        move = true,
                                        car = true,
                                        combat = true,
                                    },
                                    anim = {
                                        dict = 'amb@prop_human_bum_bin@base',
                                        clip = 'base',
                                    },
                                }) then 
                                    TriggerServerEvent("mysterybox:lootProp", box.id) 
                                else 
                                    print('Do stuff when cancelled') 
                                end
                            end)
                        end,
                    }
                },
                distance = 2.0
            })
        elseif Config.Target == "ox_target" then
            exports.ox_target:addLocalEntity(prop, {
                {
                    icon = 'fa-solid fa-box',
                    label = 'Open Mystery Box',
                    onSelect = function()
                        lib.callback('mysterybox:checkCooldown', false, function(response)
                            if not response.canOpen then
                                lib.notify({
                                    description = ("You must wait %d seconds before opening another box."):format(response.remaining),
                                    type = 'error'
                                })
                                return
                            end
                    
                            if lib.progressBar({
                                duration = 2000,
                                label = 'Opening Mystery Box',
                                useWhileDead = false,
                                canCancel = true,
                                disable = {
                                    move = true,
                                    car = true,
                                    combat = true,
                                },
                                anim = {
                                    dict = 'amb@prop_human_bum_bin@base',
                                    clip = 'base',
                                },
                            }) then 
                                TriggerServerEvent("mysterybox:lootProp", box.id) 
                            else 
                                print('Do stuff when cancelled') 
                            end
                        end)
                    end                
                }
            })
        end
    end
end)

RegisterNetEvent("mysterybox:despawnProp", function(id)
    local netId = spawnedProps[id]
    if netId then
        local prop = NetToEnt(netId)
        if DoesEntityExist(prop) then
            DeleteEntity(prop)
        end
        spawnedProps[id] = nil
    end
end)

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    TriggerServerEvent("mysterybox:playerLoaded")
end)
