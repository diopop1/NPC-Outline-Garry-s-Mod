if CLIENT then
    -- Create client-side variables for controlling the effect
    local npc_outline_enabled = CreateClientConVar("pp_npc_outline", "0", true, false)
    local npc_outline_r = CreateClientConVar("pp_npc_outline_r", "255", true, false)
    local npc_outline_g = CreateClientConVar("pp_npc_outline_g", "255", true, false)
    local npc_outline_b = CreateClientConVar("pp_npc_outline_b", "255", true, false)
    local npc_outline_a = CreateClientConVar("pp_npc_outline_a", "255", true, false)
    local npc_outline_distance = CreateClientConVar("pp_npc_outline_distance", "1000", true, false)
    local npc_outline_text_distance = CreateClientConVar("pp_npc_outline_text_distance", "500", true, false)
    local npc_outline_visibility_check = CreateClientConVar("pp_npc_outline_visibility_check", "1", true, false)
    local npc_outline_dynamic = CreateClientConVar("pp_npc_outline_dynamic", "1", true, false)
    local npc_outline_show_text = CreateClientConVar("pp_npc_outline_show_text", "1", true, false)
    local npc_outline_show_ragdolls = CreateClientConVar("pp_npc_outline_show_ragdolls", "1", true, false)
    local npc_outline_enable_hostility_detection = CreateClientConVar("pp_npc_outline_hostility_detection", "1", true, false)
    local npc_outline_show_players = CreateClientConVar("pp_npc_outline_show_players", "1", true, false)  -- New convar for player outlines
    local npc_outline_max_entities = CreateClientConVar("pp_npc_outline_max_entities", "0", true, false)


-- Создание нескольких шрифтов

    surface.CreateFont("NPCOutlineTextSmall3", {
        font = "Arial",
        size = 1,
        weight = 500,
        antialias = true
    })


    surface.CreateFont("NPCOutlineTextSmall2", {
        font = "Arial",
        size = 4,
        weight = 500,
        antialias = true
    })

    surface.CreateFont("NPCOutlineTextSmall1", {
        font = "Arial",
        size = 8,
        weight = 500,
        antialias = true
    })

    surface.CreateFont("NPCOutlineTextSmall", {
        font = "Arial",
        size = 8,
        weight = 500,
        antialias = true
    })

    surface.CreateFont("NPCOutlineTextMedium", {
        font = "Arial",
        size = 15,
        weight = 500,
        antialias = true
    })

    surface.CreateFont("NPCOutlineTextLarge", {
        font = "Arial",
        size = 30,
        weight = 500,
        antialias = true
    })


    -- Register effect in post-processing menu
    list.Set("PostProcess", "NPC Outline", {
        icon = "materials/gui/postprocess/npc_outline.jpg",
        convar = "pp_npc_outline",
        category = "#shaders_pp",
        cpanel = function(CPanel)
            CPanel:AddControl("CheckBox", {
                Label = "Enable NPC Outline",
                Command = "pp_npc_outline"
            })

            CPanel:AddControl("Color", {
                Label = "Outline Color",
                Red = "pp_npc_outline_r",
                Green = "pp_npc_outline_g",
                Blue = "pp_npc_outline_b",
                Alpha = "pp_npc_outline_a"
            })

            CPanel:AddControl("Slider", {
                Label = "Outline Draw Distance",
                Command = "pp_npc_outline_distance",
                Type = "Float",
                Min = "100",
                Max = "5000"
            })

            CPanel:AddControl("Slider", {
                Label = "Text Draw Distance",
                Command = "pp_npc_outline_text_distance",
                Type = "Float",
                Min = "100",
                Max = "5000"
            })

            CPanel:AddControl("Slider", {
                Label = "Maximum Number of Entities",
                Command = "pp_npc_outline_max_entities",
                Type = "Int",
                Min = "0",
                Max = "100"
            })


            CPanel:AddControl("CheckBox", {
                Label = "Check NPC Visibility (Experimental)",
                Command = "pp_npc_outline_visibility_check"
            })

            CPanel:AddControl("CheckBox", {
                Label = "Enable Dynamic Effects (Experimental)",
                Command = "pp_npc_outline_dynamic"
            })

            CPanel:AddControl("CheckBox", {
                Label = "Show NPC Name and HP (Experimental)",
                Command = "pp_npc_outline_show_text"
            })

            CPanel:AddControl("CheckBox", {
                Label = "Show Ragdolls",
                Command = "pp_npc_outline_show_ragdolls"
            })

            CPanel:AddControl("CheckBox", {
                Label = "Enable Hostility Detection (Experimental)",
                Command = "pp_npc_outline_hostility_detection"
            })

            CPanel:AddControl("CheckBox", {
                Label = "Show Player Outlines (Experimental)",  -- Checkbox for player outlines
                Command = "pp_npc_outline_show_players"
            })
        end
    })

    -- Define the outline color function
    local function GetOutlineColor(entity)
        local a = npc_outline_a:GetInt()

        if npc_outline_enable_hostility_detection:GetBool() then
            local hostileClasses = {"npc_combine_s", "npc_metropolice", "npc_antlion"}
            local entityClass = entity:GetClass()

            for _, class in ipairs(hostileClasses) do
                if entityClass == class then
                    return Color(255, 0, 0, a)
                end
            end

            return Color(0, 255, 0, a)
        end

        return Color(npc_outline_r:GetInt(), npc_outline_g:GetInt(), npc_outline_b:GetInt(), a)
    end

 -- Функция для выбора шрифта в зависимости от расстояния
    local function GetFontByDistance(distance)
        if distance < 85 then
            return "NPCOutlineTextLarge"
        elseif distance < 250 then
            return "NPCOutlineTextMedium"
        elseif distance < 500 then
            return "NPCOutlineTextSmall"
        elseif distance < 750 then
            return "NPCOutlineTextSmall1"
        elseif distance < 1500 then
            return "NPCOutlineTextSmall2"
        else
            return "NPCOutlineTextSmall3"
        end
    end

 local function DrawOutline(entity)
    if not npc_outline_enabled:GetBool() then return end

    local maxDistance = npc_outline_distance:GetFloat()
    local maxTextDistance = npc_outline_text_distance:GetFloat()
    local checkVisibility = npc_outline_visibility_check:GetBool()
    local dynamicEffects = npc_outline_dynamic:GetBool()
    local showText = npc_outline_show_text:GetBool()
    local showRagdolls = npc_outline_show_ragdolls:GetBool()

    if maxDistance == nil or maxTextDistance == nil then
        print("Error: maxDistance or maxTextDistance is nil.")
        return
    end

    local playerPos = LocalPlayer():GetPos()
    local entityPos = entity:GetPos()
    local distance = playerPos:Distance(entityPos)

    -- Skip rendering if the entity is too far
    if distance > maxDistance then
        return
    end

    local mins, maxs = entity:OBBMins(), entity:OBBMaxs()

    local corners = {
        Vector(mins.x, mins.y, mins.z),
        Vector(mins.x, maxs.y, mins.z),
        Vector(maxs.x, maxs.y, mins.z),
        Vector(maxs.x, mins.y, mins.z),
        Vector(mins.x, mins.y, maxs.z),
        Vector(mins.x, maxs.y, maxs.z),
        Vector(maxs.x, maxs.y, maxs.z),
        Vector(maxs.x, mins.y, maxs.z)
    }

    local screenCorners = {}
    local visible = false

    for _, corner in ipairs(corners) do
        local screenPos = entity:LocalToWorld(corner):ToScreen()
        table.insert(screenCorners, screenPos)

        if screenPos.visible then
            visible = true
        end
    end

    if not visible or #screenCorners == 0 then
        return
    end

    local minX, minY = ScrW(), ScrH()
    local maxX, maxY = 0, 0

    for _, corner in ipairs(screenCorners) do
        minX = math.min(minX, corner.x)
        minY = math.min(minY, corner.y)
        maxX = math.max(maxX, corner.x)
        maxY = math.max(maxY, corner.y)
    end

    if minX == ScrW() or minY == ScrH() or maxX == 0 or maxY == 0 then
        return
    end

    local outlineColor = GetOutlineColor(entity)

    if dynamicEffects then
        local currentTime = CurTime()
        local sizeOffset = math.sin(currentTime * 2) * 5
        local jitter = math.random() * 5

        minX = minX - sizeOffset + jitter
        minY = minY - sizeOffset + jitter
        maxX = maxX + sizeOffset + jitter
        maxY = maxY + sizeOffset + jitter

        if math.random() < 0.0000000001 then
            minX = minX + math.random(-50, 50)
            minY = minY + math.random(-50, 50)
            maxX = maxX + math.random(-50, 50)
            maxY = maxY + sizeOffset + jitter
        end
    end

    local width = maxX - minX
    local height = maxY - minY

    -- Draw the outline
    surface.SetDrawColor(outlineColor)
    surface.DrawOutlinedRect(minX, minY, width, height)

    if showText and distance <= maxTextDistance then
        local text
        if entity:IsRagdoll() then
            text = "Unable to determine"
        elseif entity:IsPlayer() then
            text = entity:Nick() .. " - HP: " .. entity:Health()
        else
            local name = entity:GetClass()
            local hp = entity:Health()
            text = name .. " - HP: " .. hp
        end

        local screenSize = width 
        local selectedFont = GetFontByDistance(distance)
        
        -- Set the font
        surface.SetFont(selectedFont)
        local textWidth, textHeight = surface.GetTextSize(text)

        -- Calculate the text position
        local centerX = (minX + maxX) / 2
        local centerY = minY - (textHeight / 50) - 1

        local textPosX = centerX - (textWidth / 2)
        local textPosY = centerY

        -- Draw the text
        surface.SetTextColor(outlineColor.r, outlineColor.g, outlineColor.b, outlineColor.a)
        surface.SetTextPos(textPosX, textPosY)
        surface.DrawText(text)
    end
end


    local function DrawNPCOutline()
        if not npc_outline_enabled:GetBool() then return end

        local maxDistance = npc_outline_distance:GetFloat()
        local checkVisibility = npc_outline_visibility_check:GetBool()
        local showRagdolls = npc_outline_show_ragdolls:GetBool()
        local showPlayers = npc_outline_show_players:GetBool()
        local maxEntities = npc_outline_max_entities:GetInt()  -- Get the maximum number of entities to outline

        if maxDistance == nil then
            print("Error: maxDistance is nil.")
            return
        end

        local playerPos = LocalPlayer():GetPos()
        local playerEyePos = LocalPlayer():EyePos()

        -- Function to process entities
        local function ProcessEntities(entityClass)
            local entities = ents.FindByClass(entityClass)
            local count = 0

            for _, entity in ipairs(entities) do
                if IsValid(entity) then
                    local entityPos = entity:GetPos()

                    if entityPos:Distance(playerPos) <= maxDistance then
                        if checkVisibility then
                            local traceData = {
                                start = playerEyePos,
                                endpos = entity:EyePos(),
                                filter = LocalPlayer(),
                                mask = MASK_VISIBLE
                            }
                            local trace = util.TraceLine(traceData)

                            if trace.Hit and trace.Entity ~= entity then
                                continue
                            end
                        end

                        DrawOutline(entity)
                        count = count + 1

                        if maxEntities > 0 and count >= maxEntities then
                            return
                        end
                    end
                end
            end
        end

        -- Draw outlines for NPCs
        ProcessEntities("npc_*")

        -- Draw outlines for ragdolls
        if showRagdolls then
            ProcessEntities("prop_ragdoll")
        end

        -- Draw outlines for players
        if showPlayers then
            local count = 0
            for _, ply in ipairs(player.GetAll()) do
                if IsValid(ply) and ply ~= LocalPlayer() then
                    local plyPos = ply:GetPos()

                    if plyPos:Distance(playerPos) <= maxDistance then
                        if checkVisibility then
                            local traceData = {
                                start = playerEyePos,
                                endpos = ply:EyePos(),
                                filter = LocalPlayer(),
                                mask = MASK_VISIBLE
                            }
                            local trace = util.TraceLine(traceData)

                            if trace.Hit and trace.Entity ~= ply then
                                continue
                            end
                        end

                        DrawOutline(ply)
                        count = count + 1

                        if maxEntities > 0 and count >= maxEntities then
                            break
                        end
                    end
                end
            end
        end
    end

    hook.Add("HUDPaint", "DrawNPCOutline", DrawNPCOutline)
end


/*
| Copyright © diopop1 - 2024 |

[ diopop1 - development. ]
[ ChatGPT - assistance in writing code. ]

{ Version - 1.2 }

All rights reserved, but you can improve the addon and release it as an improved version but with me as the author of the original addon.
*/