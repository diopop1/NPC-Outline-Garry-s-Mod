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
    local npc_outline_accuracy = CreateClientConVar("pp_npc_outline_accuracy", "1", true, false)
    local npc_outline_frame_disappears = CreateClientConVar("pp_npc_outline_frame_disappears", "1", true, false)
    local npc_outline_frame_distortions = CreateClientConVar("pp_npc_outline_frame_distortions", "1", true, false)
    local npc_outline_text_display = CreateClientConVar("pp_npc_outline_text_display", "1", true, false)
    local npc_outline_show_transport = CreateClientConVar("pp_npc_outline_show_transport", "1", true, false)

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

            CPanel:AddControl("Label", {
                Text = "------- Additional options -------"
            })

            CPanel:AddControl("CheckBox", {
                Label = "Check NPC Visibility",
                Command = "pp_npc_outline_visibility_check"
            })

            CPanel:AddControl("CheckBox", {
                Label = "Enable Hostility Detection (Experimental)",
                Command = "pp_npc_outline_hostility_detection"
            })


            CPanel:AddControl("Label", {
                Text = "------- Dynamic effects -------"
            })

            CPanel:AddControl("CheckBox", {
                Label = "Enable Dynamic Effects (Experimental)",
                Command = "pp_npc_outline_dynamic"
            })


            CPanel:AddControl("Slider", {
                Label = "The accuracy of the frame where 1 is extremely inaccurate",
                Command = "pp_npc_outline_accuracy",
                Type = "Int",
                Min = "1",
                Max = "4"
            })


             CPanel:AddControl("CheckBox", {
                Label = "Frame Disappears (Experimental)",
                Command = "pp_npc_outline_frame_disappears"
            })

            CPanel:AddControl("CheckBox", {
                Label = "Additional Frame Distortions (Experimental)",
                Command = "pp_npc_outline_frame_distortions"
            })

            CPanel:AddControl("Label", {
                Text = "------- Text -------"
            })

            CPanel:AddControl("CheckBox", {
                Label = "Show NPC Name and HP (Experimental)",
                Command = "pp_npc_outline_show_text"
            })

            CPanel:AddControl("CheckBox", {
                Label = "Other text format",
                Command = "pp_npc_outline_text_display"
            })

            CPanel:AddControl("Label", {
                Text = "------- Displaying objects -------"
            })

            CPanel:AddControl("CheckBox", {
                Label = "Show Ragdolls",
                Command = "pp_npc_outline_show_ragdolls"
            })

            CPanel:AddControl("CheckBox", {
                Label = "Show Transport (Experimental)",
                Command = "pp_npc_outline_show_transport"
            })

            CPanel:AddControl("CheckBox", {
                Label = "Show Player Outlines (Experimental)",  -- Checkbox for player outlines
                Command = "pp_npc_outline_show_players"
            })

            CPanel:AddControl("Label", {
                Text = "What is this for? This addon adds a stroke effect around NPCs, similar to the object recognition feature inspired by the Bodycam game.\n" ..
                       "— — — — — — — — — — — — — \n" ..
                       "| About the modification \n" ..
                       "|                        \n" ..
                       "| Version = 1.3C         \n" ..
                       "| Stability = 8/10       \n" ..
                       "| Developer = diopop1    \n" ..
                       "|"
            })

        end
    })

    -- Define the outline color function
local function GetOutlineColor(entity)
    local a = npc_outline_a:GetInt()

    -- Пропускаем регдоллы, транспорт и игроков
    if entity:IsRagdoll() or entity:IsVehicle() or entity:IsPlayer() then
        return Color(npc_outline_r:GetInt(), npc_outline_g:GetInt(), npc_outline_b:GetInt(), a)  -- Цвет по умолчанию
    end

    if npc_outline_enable_hostility_detection:GetBool() then
        local hostileClasses = {
            "npc_combine_s",
            "npc_metropolice",
            "npc_antlion",
            "npc_zombie*",        -- Поддержка зомби
            "npc_fastzombie*",    -- Поддержка быстрых зомби
            "npc_headcrab*",      -- Поддержка всех зомби, начинающихся с npc_headcrab
            "npc_zombine*",
            "npc_antlionguard"
        }
        local entityClass = entity:GetClass()

        -- Проверяем, является ли класс сущности враждебным
        for _, class in ipairs(hostileClasses) do
            -- Проверяем наличие символа * и сравниваем с префиксом
            if class:find("%*") then
                local prefix = class:gsub("%*", "")  -- Удаляем *
                if entityClass:find(prefix) == 1 then
                    return Color(255, 0, 0, a)  -- Красный цвет для враждебных NPC
                end
            else
                if entityClass == class then
                    return Color(255, 0, 0, a)  -- Красный цвет для враждебных NPC
                end
            end
        end

        return Color(0, 255, 0, a)  -- Зеленый цвет для нейтральных NPC
    end

    -- Возвращаем цвет, заданный в настройках, если обнаружение враждебности отключено
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


local frameRemovalStates = {}

local function HandleFrameRemoval(entity, accuracy, disappears)
    if not disappears then
        return false -- If frame removal is disabled, return false
    end

    local speed = entity:GetVelocity():Length()
    local removalDuration
    if accuracy == 1 then
        removalDuration = math.random(0.001, 3)
    elseif accuracy == 2 then
        removalDuration = math.random(0.001, 5)
    elseif accuracy == 3 then
        removalDuration = math.random(0.001, 7)
    elseif accuracy == 4 then
        removalDuration = math.random(0.001, 10)
    else
        removalDuration = math.random(0.001, 3)
    end

    local removalChance
    if accuracy == 1 then
        removalChance = math.random(0.00001, 0.0001)
    elseif accuracy == 2 then
        removalChance = math.random(0.0001, 0.001)
    elseif accuracy == 3 then
        removalChance = math.random(0.0005, 0.001)
    elseif accuracy == 4 then
        removalChance = math.random(0.0001, 0.001)
    else
        removalChance = math.random(0.00001, 0.0001)
    end

    local reducedSpeed
    if accuracy == 1 then
        reducedSpeed = speed / 1000000
    elseif accuracy == 2 then
        reducedSpeed = speed / 9500000
    elseif accuracy == 3 then
        reducedSpeed = speed / 9250000
    elseif accuracy == 4 then
        reducedSpeed = speed / 9000000
    else
        reducedSpeed = speed / 1000000
    end

    local currentTime = CurTime()
    removalChance = removalChance + reducedSpeed

    -- Инициализация состояния для текущего NPC, если оно еще не существует
    if not frameRemovalStates[entity] then
        frameRemovalStates[entity] = { removed = false, removalTime = 0 }
    end

    local frameRemoved = frameRemovalStates[entity].removed
    local frameRemovalTime = frameRemovalStates[entity].removalTime

    -- Check if the frame should be removed
    if not frameRemoved and math.random() < removalChance then
        frameRemoved = true
        frameRemovalTime = currentTime + removalDuration
        frameRemovalStates[entity].removed = true
        frameRemovalStates[entity].removalTime = frameRemovalTime
    end

    -- If the frame is removed, check the time
    if frameRemoved then
        if currentTime < frameRemovalTime then
            return true -- Frame is removed
        else
            frameRemoved = false -- Reset state after time expires
            frameRemovalStates[entity].removed = false
        end
    end

    return false -- Frame is not removed
end


-- Функция для рандомизации положения
local function RandomizeOutlinePosition(entity, minX, minY, maxX, maxY, chance, accuracy)
    -- Проверка, отключена ли функция
    if npc_outline_frame_distortions:GetBool() == false then
        return minX, minY, maxX, maxY -- Если функция отключена, просто возвращаем значения
    end

   local chance
    if accuracy == 1 then
        chance = math.random(0.00001, 0.0001)
    elseif accuracy == 2 then
        chance = math.random(0.0001, 0.001)
    elseif accuracy == 3 then
        chance = math.random(0.0005, 0.001)
    elseif accuracy == 4 then
        chance = math.random(0.0001, 0.001)
    else
        chance = math.random(0.00000001, 0.00001)
    end

    local Duration = math.random(0.01, 5)

    -- Инициализация состояния для каждого NPC
    if not entity.state then
        entity.state = {
            frame = false,
            frameTime = 0,
            offsetX = 0,
            offsetY = 0
        }
    end

    local currentTime = CurTime()

    -- Проверка, должен ли фрейм быть активирован
    if not entity.state.frame and math.random() < chance then
        entity.state.frame = true
        entity.state.frameTime = currentTime + Duration

        -- Генерация случайных значений только один раз
        entity.state.offsetX = math.random(-2500, 2500) -- Измените диапазон по вашему усмотрению
        entity.state.offsetY = math.random(-2500, 2500) -- Измените диапазон по вашему усмотрению
    end 

    -- Если фрейм активен, рандомизируем позиции
    if entity.state.frame then
        if currentTime < entity.state.frameTime then
            minX = minX + entity.state.offsetX
            minY = minY + entity.state.offsetY
            maxX = maxX + entity.state.offsetX
            maxY = maxY + entity.state.offsetY
        else
            entity.state.frame = false -- Сброс состояния после истечения времени
        end
    end

    return minX, minY, maxX, maxY -- Возвращаем значения
end


local function DrawOutline(entity)
    if not npc_outline_enabled:GetBool() then return end

    local maxDistance = npc_outline_distance:GetFloat()
    local maxTextDistance = npc_outline_text_distance:GetFloat()
    local dynamicEffects = npc_outline_dynamic:GetBool()
    local showText = npc_outline_show_text:GetBool()
    local showRagdolls = npc_outline_show_ragdolls:GetBool()
    local accuracy = npc_outline_accuracy:GetInt()
    local disappears = npc_outline_frame_disappears:GetBool() -- Checkbox for frame removal



    if maxDistance == nil or maxTextDistance == nil then
        return
    end

    local playerPos = LocalPlayer():GetPos()
    local entityPos = entity:GetPos()
    local distance = playerPos:Distance(entityPos)

    -- Skip rendering if the entity is too far
    if distance > maxDistance then
        return
    end

    -- Internal function to check visibility
local function IsEntityVisible(entity)
    if not IsValid(entity) then
        return false
    end

    local player = LocalPlayer()
    local npc_outline_show_transport = GetConVar("pp_npc_outline_show_transport"):GetBool()

    local trace = util.TraceLine({
        start = player:GetShootPos(),
        endpos = entity:GetPos() + Vector(0, 0, 10),
        filter = function(ent)
            if npc_outline_show_transport then
                return ent ~= entity and ent:GetClass() ~= "lvs_wheeldrive_wheel" and ent:GetClass() ~= "gmod_sent_vehicle_fphysics_wheel" and ent ~= player
            else
                -- Используйте другой фильтр, если npc_outline_show_transport выключен
                return ent ~= entity and ent ~= player
            end
        end
    })

    return not trace.Hit
end

local checkVisibility = npc_outline_visibility_check:GetBool()

if checkVisibility and not IsEntityVisible(entity) then
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
    local minX, minY = ScrW(), ScrH()
    local maxX, maxY = 0, 0

    for _, corner in ipairs(corners) do
        local screenPos = entity:LocalToWorld(corner):ToScreen()
        table.insert(screenCorners, screenPos)

        if screenPos.visible then
            minX = math.min(minX, screenPos.x)
            minY = math.min(minY, screenPos.y)
            maxX = math.max(maxX, screenPos.x)
            maxY = math.max(maxY, screenPos.y)
        end
    end

    if minX == ScrW() or minY == ScrH() or maxX == 0 or maxY == 0 then
        return
    end

    local outlineColor = GetOutlineColor(entity)
    local outlineVisible = true
    local prevMinX, prevMinY, prevMaxX, prevMaxY
    local interpolationSpeed = 5

    -- Set jitter and sizeOffset based on accuracy
local jitter, sizeOffset
local interpolationSpeed = 5 -- Скорость интерполяции

-- Устанавливаем значения jitter и sizeOffset в зависимости от accuracy и скорости
if accuracy == 1 then
    jitter = math.random(3, 5) -- Увеличиваем jitter в зависимости от скорости
    sizeOffset = math.random(-5, 5) -- Увеличиваем sizeOffset в зависимости от скорости
elseif accuracy == 2 then
    jitter = math.random(5, 15)
    sizeOffset = math.random(-15, 15) 
elseif accuracy == 3 then
    jitter = math.random(25, 50)
    sizeOffset = math.random(-30, 30) 
elseif accuracy == 4 then
    jitter = math.random(35, 75)
    sizeOffset = math.random(-50, 50)
else
    jitter = math.random(300, 500)
    sizeOffset = math.random(-15, 15) 
end

    -- Interpolation function
    local function interpolate(from, to, alpha)
        return from + (to - from) * alpha
    end

    -- Функция для получения величины скорости
    local function getVelocityMagnitude(entity)
        return entity:GetVelocity():Length()
    end

    -- Main outline display and management function
    if dynamicEffects then
        if not prevMinX then
            prevMinX, prevMinY = minX, minY
            prevMaxX, prevMaxY = maxX, maxY
        end
        
        
        -- После вычисления minX, minY, maxX, maxY
        minX, minY, maxX, maxY = RandomizeOutlinePosition(entity, minX, minY, maxX, maxY, chance, accuracy)
        local speed = getVelocityMagnitude(entity)
    
    local multiplier
 if accuracy == 1 then
    multiplier = 0.03
 elseif accuracy == 2 then
    multiplier = 0.05
 elseif accuracy == 3 then
    multiplier = 0.1
 elseif accuracy == 4 then
    multiplier = 0.15
 else
    multiplier = 0.2 -- Значение по умолчанию, если accuracy не соответствует ни одному из условий
end

-- Добавляем случайное смещение в зависимости от скорости
local errorOffset = math.random(-speed * multiplier, speed * multiplier)


        minX = minX - sizeOffset + jitter + errorOffset
        minY = minY - sizeOffset + jitter + errorOffset
        maxX = maxX + sizeOffset + jitter + errorOffset
        maxY = maxY + sizeOffset + jitter + errorOffset

        minX = interpolate(prevMinX, minX, FrameTime() * interpolationSpeed)
        minY = interpolate(prevMinY, minY, FrameTime() * interpolationSpeed)
        maxX = interpolate(prevMaxX, maxX, FrameTime() * interpolationSpeed)
        maxY = interpolate(prevMaxY, maxY, FrameTime() * interpolationSpeed)

        prevMinX, prevMinY = minX, minY
        prevMaxX, prevMaxY = maxX, maxY

        -- Handle frame removal
        if HandleFrameRemoval(entity, accuracy, disappears) then
            return -- Stop execution if the frame is removed
        end
    end


    local width = maxX - minX
    local height = maxY - minY

    

 -- Рисуем контур
    surface.SetDrawColor(outlineColor)
    surface.DrawOutlinedRect(minX, minY, width, height)

    -- Проверяем, нужно ли отображать текст
    if showText and distance <= maxTextDistance then
        local text
        local hpText

        -- Определяем текст в зависимости от типа сущности
        if entity:IsRagdoll() then
            text = "Unable to determine"
            hpText = ""
        elseif entity:IsPlayer() then
            text = entity:Nick()
            hpText = "HP: " .. entity:Health()
        else
            local name = entity:GetClass()
            local hp = entity:Health()
            text = name
            hpText = "HP: " .. hp
        end

        local selectedFont = GetFontByDistance(distance)
        
        -- Устанавливаем шрифт
        surface.SetFont(selectedFont)
        local textWidth, textHeight = surface.GetTextSize(text)
        local hpWidth, hpHeight = surface.GetTextSize(hpText)

        -- Рассчитываем позицию текста
        local centerX = (minX + maxX) / 2.02
        local textPosX = centerX - (textWidth / 2)
        local textPosY = minY - (textHeight / 50) - 1

        -- Проверяем значение ConVar для отображения текста
        if npc_outline_text_display:GetBool() then
            -- Отображение текста в строку
            surface.SetTextColor(outlineColor.r, outlineColor.g, outlineColor.b, outlineColor.a)
            surface.SetTextPos(textPosX, textPosY)
            surface.DrawText(text .. " - " .. hpText) -- Объединяем текст в строку
        else
            -- Отображение HP под названием
            surface.SetTextColor(outlineColor.r, outlineColor.g, outlineColor.b, outlineColor.a)
            surface.SetTextPos(textPosX, textPosY)
            surface.DrawText(text)

            -- Рассчитываем позицию текста HP
            local centerX = (minX + maxX) / 2.025
            local hpPosX = centerX - (hpWidth / 2)
            local hpPosY = textPosY + textHeight + 2 -- немного ниже названия

            -- Рисуем HP
            surface.SetTextPos(hpPosX, hpPosY)
            surface.DrawText(hpText)
        end -- Закрываем блок if для npc_outline_text_display:GetBool()
    end -- Закрываем блок if для showText and distance <= maxTextDistance
end


    local function DrawNPCOutline()
        if not npc_outline_enabled:GetBool() then return end

        local maxDistance = npc_outline_distance:GetFloat()
        local checkVisibility = npc_outline_visibility_check:GetBool()
        local showRagdolls = npc_outline_show_ragdolls:GetBool()
        local showPlayers = npc_outline_show_players:GetBool()
        local maxEntities = npc_outline_max_entities:GetInt()  -- Get the maximum number of entities to outline
        local showTransport = npc_outline_show_transport:GetBool()  -- Get the value for showing transport

        if maxDistance == nil then
            print("Error: maxDistance is nil.")
            return
        end

        local playerPos = LocalPlayer():GetPos()
        local playerEyePos = LocalPlayer():EyePos()

        -- Function to process entities
    local function ProcessEntities(entityClass, exclusionClasses)
        exclusionClasses = exclusionClasses or {}
        local entities = ents.FindByClass(entityClass)
        local count = 0

        for _, entity in ipairs(entities) do
            if IsValid(entity) then
             local entityPos = entity:GetPos()

            -- Проверка на исключение классов
            local skip = false
            for _, exclusionClass in ipairs(exclusionClasses) do
                if string.match(entity:GetClass(), exclusionClass) then
                    skip = true
                    break
                end
            end

            if skip then continue end

            if entityPos:Distance(playerPos) <= maxDistance then
                if checkVisibility then
                    local traceData = {
                        start = playerEyePos,
                        endpos = entity:GetPos() + Vector(0, 0, 10),
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
        ProcessEntities("npc_*", {"npc_grenade*", "npc_satchel*"})

        -- Draw outlines for ragdolls
        if showRagdolls then
            ProcessEntities("prop_ragdoll")
        end

   if showTransport then    -- Обработка транспортных средств
    -- Функция для проверки видимости транспортных средств
    local function IsTransportEntityVisible(entity)
        if not IsValid(entity) then
            return false
        end

        local player = LocalPlayer()
        local trace = util.TraceLine({
            start = player:GetShootPos(),
            endpos = entity:GetPos() + Vector(0, 0, 100),
            filter = {player, entity}
        })

        return not trace.Hit
    end

    local function ProcessTransportEntities(entityClass, exclusionClasses)
        exclusionClasses = exclusionClasses or {}
        local entities = ents.FindByClass(entityClass)
        local count = 0

        for _, entity in ipairs(entities) do
            if IsValid(entity) then
                local entityPos = entity:GetPos()
                local playerPos = LocalPlayer():GetPos()

                -- Проверка на исключение классов
                local skip = false
                for _, exclusionClass in ipairs(exclusionClasses) do
                    if string.match(entity:GetClass(), exclusionClass) then
                        skip = true
                        break
                    end
                end

                if skip then continue end

                if entityPos:Distance(playerPos) <= maxDistance then
                    -- Проверка видимости для транспортных средств
                    if not IsTransportEntityVisible(entity) then
                        continue
                    end

                    -- Логика для рисования контуров
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
                    local minX, minY = ScrW(), ScrH()
                    local maxX, maxY = 0, 0

                    for _, corner in ipairs(corners) do
                        local screenPos = entity:LocalToWorld(corner):ToScreen()
                        table.insert(screenCorners, screenPos)

                        if screenPos.visible then
                            minX = math.min(minX, screenPos.x)
                            minY = math.min(minY, screenPos.y)
                            maxX = math.max(maxX, screenPos.x)
                            maxY = math.max(maxY, screenPos.y)
                        end
                    end

                    if minX == ScrW() or minY == ScrH() or maxX == 0 or maxY == 0 then
                        continue
                    end

                    DrawOutline(entity)  -- Вызов функции для рисования контура
                    count = count + 1

                    if maxEntities > 0 and count >= maxEntities then
                        return
                    end
                end
            end
        end
    end

    -- Вызываем функцию для каждого класса транспортных средств
    ProcessTransportEntities("prop_vehicle_*", {"prop_vehicle_prisoner_*"})
    ProcessTransportEntities("sw_*", {})
    ProcessTransportEntities("lvs_wheeldrive_*", {"lvs_wheeldrive_wheel", "lvs_wheeldrive_engine", "lvs_wheeldrive_steerhandler", "lvs_wheeldrive_trailerhitch", "lvs_wheeldrive_fueltank"})
    ProcessTransportEntities("gmod_sent_vehicle_*", {"gmod_sent_vehicle_fphysics_wheel", "gmod_sent_vehicle_fphysics_attachment", "gmod_sent_vehicle_fphysics_gaspump*"})
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

{ Version - 1.3C }

All rights reserved, but you can improve the addon and release it as an improved version but with me as the author of the original addon.
*/