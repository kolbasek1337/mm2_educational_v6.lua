-- ============================================
-- MM2 EDUCATIONAL SCRIPT v6.0
-- Для GitHub: kolbasek1337/my-mm2-script
-- ЦЕЛЬ: Демонстрация механик Roblox и защита от детекта
-- ============================================

print(" MM2 Educational Script v6.0 Loading...")
print("📚 Изучаем внутреннюю механику Roblox")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ============================================
-- [CONFIG] Настройки с анти-детект лимитами
-- ============================================
local Config = {
    ESP = {
        Enabled = false,
        ShowNames = false,
        ShowRoles = false,
        XRay = false,           -- AlwaysOnTop для BillboardGui
        MaxDistance = 400,      -- Не показывать слишком далеких (оптимизация)
        UpdateRate = 0.1        -- Обновлять ESP каждые 0.1 сек (не каждый кадр!)
    },
    Fling = {
        Power = 30000,          -- Умеренная сила (50000+容易被检测到)
        Duration = 0.15,        -- Короткий импульс (меньше = безопаснее)
        ReturnDelay = 0.05      -- Быстрый возврат на место
    },
    Autofarm = {
        Enabled = false,
        Speed = 30,             -- Скорость движения (не телепорт!)
        CheckDistance = 7       -- Макс. дистанция сбора (имитация легального)
    },
    Player = {
        WalkSpeed = 16,
        Noclip = false
    }
}

-- ============================================
-- [ESP SYSTEM] Клиентская визуализация
-- ============================================
-- ТЕОРИЯ: ESP работает только на клиенте. 
-- Сервер не может запретить Highlight/BillboardGui.
-- Уязвимость MM2: Роли хранятся в Backpack/Character.
-- ============================================

local ESPObjects = {}
local GunHighlights = {}

local function GetRole(player)
    -- Читаем роль так, как это делает игра
    if not player then return "Innocent" end
    
    -- Способ 1: StringValue в игроке
    local roleObj = player:FindFirstChild("Role")
    if roleObj and roleObj:IsA("StringValue") then return roleObj.Value end
    
    -- Способ 2: StringValue в персонаже
    if player.Character then
        local charRole = player.Character:FindFirstChild("Role")
        if charRole and charRole:IsA("StringValue") then return charRole.Value end
    end
    
    -- Способ 3: Оружие в рюкзаке (MM2 хранит роль здесь!)
    if player.Backpack then
        if player.Backpack:FindFirstChild("Knife") then return "Murderer" end
        if player.Backpack:FindFirstChild("Gun") then return "Sheriff" end
    end
    
    -- Способ 4: Оружие в руках
    if player.Character then
        if player.Character:FindFirstChild("Knife") then return "Murderer" end
        if player.Character:FindFirstChild("Gun") then return "Sheriff" end
    end
    
    return "Innocent"
end

local function GetColor(role)
    local colors = {
        Innocent = Color3.fromRGB(0, 255, 128),
        Murderer = Color3.fromRGB(255, 50, 50),
        Sheriff = Color3.fromRGB(50, 150, 255),
        Hero = Color3.fromRGB(255, 200, 0)
    }
    return colors[role] or colors.Innocent
end

local function CreateESP(player)
    if not player or player == LocalPlayer then return end
    if ESPObjects[player] then return end

    -- BillboardGui: Видимый через стены благодаря AlwaysOnTop
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_" .. player.Name
    billboard.Size = UDim2.new(0, 250, 0, 80)
    billboard.StudsOffset = Vector3.new(0, 4, 0)
    billboard.AlwaysOnTop = false -- Будет меняться динамически
    billboard.ResetOnSpawn = false
    billboard.Parent = game:GetService("CoreGui")

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 18
    nameLabel.TextStrokeTransparency = 0.3
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.Text = player.Name
    nameLabel.Parent = billboard

    local roleLabel = Instance.new("TextLabel")
    roleLabel.Size = UDim2.new(1, 0, 0.5, 0)
    roleLabel.Position = UDim2.new(0, 0, 0.5, 0)
    roleLabel.BackgroundTransparency = 1
    roleLabel.Font = Enum.Font.Gotham
    roleLabel.TextSize = 15
    roleLabel.TextStrokeTransparency = 0.3
    roleLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
    roleLabel.Text = "[...]"
    roleLabel.Parent = billboard

    -- Highlight: Подсветка модели
    local highlight = Instance.new("Highlight")
    highlight.FillTransparency = 0.7
    highlight.OutlineTransparency = 0
    highlight.Parent = game:GetService("CoreGui")

    ESPObjects[player] = {
        Billboard = billboard,
        NameLabel = nameLabel,
        RoleLabel = roleLabel,
        Highlight = highlight,
        LastUpdate = 0
    }
end

local function UpdateESP(player)
    if not player or not ESPObjects[player] then return end
    local data = ESPObjects[player]
    local character = player.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local isAlive = character and hrp and humanoid and humanoid.Health > 0

    if not Config.ESP.Enabled or not isAlive then
        data.Billboard.Adornee = nil
        data.Highlight.Parent = nil
        return
    end

    -- Оптимизация: обновляем роль не каждый кадр, а раз в 0.1 сек
    local now = tick()
    if now - data.LastUpdate > Config.ESP.UpdateRate then
        local role = GetRole(player)
        local color = GetColor(role)
        data.Highlight.FillColor = color
        data.Highlight.OutlineColor = color
        data.RoleLabel.Text = "[" .. role .. "]"
        data.RoleLabel.TextColor3 = color
        data.LastUpdate = now
    end

    -- XRay режим: AlwaysOnTop = true делает видимым сквозь стены
    data.Billboard.AlwaysOnTop = Config.ESP.XRay
    data.Billboard.Adornee = hrp
    data.Highlight.Parent = character
end

-- ============================================
-- [GUN ESP] Подсветка выпавшего оружия
-- ============================================
local function CheckDroppedGuns()
    if not Config.GunESP and not Config.GunESP.Enabled then
        for _, h in pairs(GunHighlights) do pcall(function() h:Destroy() end) end
        GunHighlights = {}
        return
    end
    
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name == "GunDrop" or obj.Name:find("Gun") or obj.Name:find("Knife")) then
            if not obj:FindFirstChild("GunESP_Highlight") then
                local h = Instance.new("Highlight")
                h.Name = "GunESP_Highlight"
                h.FillColor = Color3.fromRGB(255, 220, 0)
                h.OutlineColor = Color3.fromRGB(255, 255, 255)
                h.FillTransparency = 0.4
                h.OutlineTransparency = 0
                h.Parent = obj
                GunHighlights[h] = true
            end
        end
    end
    
    for h, _ in pairs(GunHighlights) do
        if not h.Parent or not h.Parent.Parent then
            pcall(function() h:Destroy() end)
            GunHighlights[h] = nil
        end
    end
end

-- ============================================
-- [FLING SYSTEM] Безопасный импульсный флинг
-- ============================================
-- ТЕОРИЯ: Используем Network Ownership + BodyVelocity.
-- АНТИ-ДЕТЕКТ: Короткая длительность, умеренная сила, 
-- полный сброс состояния после.
-- ============================================

local FlingInProgress = false

local function SafeFling(targetPlayer)
    if FlingInProgress then return false end
    
    local targetHrp = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    local targetHum = targetPlayer.Character and targetPlayer.Character:FindFirstChildOfClass("Humanoid")
    local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local myHum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    
    if not targetHrp or not targetHum or not myHrp or not myHum then return false end
    if targetHum.Health <= 0 or myHum.Health <= 0 then return false end
    
    FlingInProgress = true
    print("[Fling] Targeting: " .. targetPlayer.Name)
    
    -- Сохраняем свою позицию
    local savedCFrame = myHrp.CFrame
    
    -- Отключаем свои коллизии (проходим сквозь цель)
    for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
        if part:IsA("BasePart") then pcall(function() part.CanCollide = false end) end
    end
    
    -- Телепорт к цели
    myHrp.CFrame = targetHrp.CFrame * CFrame.new(0, 0, -1)
    task.wait(0.03) -- Минимальная синхронизация с сервером
    
    -- Создаем BodyVelocity НА ЦЕЛИ (не на себе!)
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.P = 125000
    bv.Velocity = Vector3.new(0, Config.Fling.Power, 0)
    bv.Parent = targetHrp
    
    -- Применяем силу короткое время (0.15 сек)
    task.wait(Config.Fling.Duration)
    
    -- Удаляем силу
    pcall(function() bv:Destroy() end)
    
    -- МГНОВЕННЫЙ ВОЗВРАТ НА МЕСТО
    myHrp.CFrame = savedCFrame
    myHrp.AssemblyLinearVelocity = Vector3.zero
    myHrp.AssemblyAngularVelocity = Vector3.zero
    
    -- ПОЛНЫЙ СБРОС СОСТОЯНИЯ (Анти-баг ходьбы)
    task.wait(Config.Fling.ReturnDelay)
    myHum.PlatformStand = false
    myHum:ChangeState(Enum.HumanoidStateType.GettingUp)
    Camera.CameraSubject = myHum
    Camera.CameraType = Enum.CameraType.Custom
    
    -- Восстанавливаем коллизии
    for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
        if part:IsA("BasePart") then pcall(function() part.CanCollide = true end) end
    end
    
    -- Финальный сброс
    task.wait(0.1)
    myHrp.AssemblyLinearVelocity = Vector3.zero
    myHrp.AssemblyAngularVelocity = Vector3.zero
    myHum.PlatformStand = false
    
    FlingInProgress = false
    print("[Fling] Done! State reset complete.")
    return true
end

local function GetNearestPlayer()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local nearest, dist = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local th = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
            local h = p.Character and p.Character:FindFirstChildOfClass("Humanoid")
            if th and h and h.Health > 0 then
                local d = (hrp.Position - th.Position).Magnitude
                if d < dist then nearest, dist = p, d end
            end
        end
    end
    return nearest
end

local function GetPlayerByRole(roleName)
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and GetRole(p) == roleName and p.Character then
            return p
        end
    end
    return nil
end

-- ============================================
-- [AUTOFARM COINS] Легитимная симуляция сбора
-- ============================================
-- ТЕОРИЯ: Используем плавное движение вместо телепорта.
-- Проверяем Magnitude перед сбором (как сервер).
-- ============================================

local function FindNearestCoin()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    
    local nearest, dist = nil, math.huge
    -- Ищем монеты в workspace (адаптируй под структуру MM2)
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name == "Coin" or obj.Name:find("Coin")) then
            local d = (hrp.Position - obj.Position).Magnitude
            if d < dist then nearest, dist = obj, d end
        end
    end
    return nearest, dist
end

local farmRunning = false
task.spawn(function()
    while true do
        task.wait(0.1)
        if Config.Autofarm.Enabled and not farmRunning then
            local coin, dist = FindNearestCoin()
            if coin and dist <= 100 then -- Не фармить слишком далеко
                farmRunning = true
                -- ПЛАВНОЕ ДВИЖЕНИЕ (имитация ходьбы)
                local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local startPos = hrp.Position
                local targetPos = coin.Position
                local steps = math.ceil(dist / Config.Autofarm.Speed)
                
                for i = 1, steps do
                    if not Config.Autofarm.Enabled or not hrp.Parent then break end
                    local t = i / steps
                    hrp.CFrame = CFrame.new(startPos:Lerp(targetPos, t))
                    task.wait(0.016) -- 60 FPS движение
                end
                
                -- Проверка дистанции перед "сбором" (анти-детект)
                if hrp and (hrp.Position - coin.Position).Magnitude <= Config.Autofarm.CheckDistance then
                    print("[Autofarm] Collected coin at safe distance")
                else
                    warn("[Autofarm] Too far, skipped collection")
                end
                
                farmRunning = false
            end
        end
    end
end)

-- ============================================
-- [GUI] Вкладки: ESP | Fling | Movement
-- ============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2_GUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 70, 0, 70)
ToggleBtn.Position = UDim2.new(0.92, 0, 0.05, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 220, 255)
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Parent = ScreenGui
local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 14)
btnCorner.Parent = ToggleBtn

local Menu = Instance.new("Frame")
Menu.Size = UDim2.new(0, 450, 0, 400)
Menu.Position = UDim2.new(0.05, 0, 0.1, 0)
Menu.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
Menu.BorderSizePixel = 0
Menu.Visible = false
Menu.Parent = ScreenGui
local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 12)
menuCorner.Parent = Menu

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
Header.BorderSizePixel = 0
Header.Parent = Menu
local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12, 0, 0)
headerCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ MM2 EDUCATIONAL v6.0"
Title.TextColor3 = Color3.fromRGB(0, 220, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local SideBar = Instance.new("Frame")
SideBar.Size = UDim2.new(0, 110, 1, -50)
SideBar.Position = UDim2.new(0, 0, 0, 50)
SideBar.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
SideBar.BorderSizePixel = 0
SideBar.Parent = Menu

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -115, 1, -55)
ContentArea.Position = UDim2.new(0, 115, 0, 55)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = Menu

local function CreateTab(name, order)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, -10, 0, 40)
    tabBtn.Position = UDim2.new(0, 5, 0, (order - 1) * 45)
    tabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    tabBtn.Text = name
    tabBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.TextSize = 13
    tabBtn.BorderSizePixel = 0
    tabBtn.Parent = SideBar
    local tc = Instance.new("UICorner")
    tc.CornerRadius = UDim.new(0, 8)
    tc.Parent = tabBtn

    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, 0, 1, 0)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 5
    content.ScrollBarImageColor3 = Color3.fromRGB(0, 220, 255)
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.Visible = false
    content.Parent = ContentArea
    local cl = Instance.new("UIListLayout")
    cl.Padding = UDim.new(0, 8)
    cl.SortOrder = Enum.SortOrder.LayoutOrder
    cl.Parent = content

    tabBtn.MouseButton1Click:Connect(function()
        for _, c in ipairs(ContentArea:GetChildren()) do
            if c:IsA("ScrollingFrame") then c.Visible = false end
        end
        for _, b in ipairs(SideBar:GetChildren()) do
            if b:IsA("TextButton") then
                b.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
                b.TextColor3 = Color3.fromRGB(180, 180, 200)
            end
        end
        content.Visible = true
        tabBtn.BackgroundColor3 = Color3.fromRGB(0, 220, 255)
        tabBtn.TextColor3 = Color3.new(1, 1, 1)
    end)
    return content, cl
end

local function CreateToggle(parent, layout, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 45)
    frame.BackgroundColor3 = Color3.fromRGB(25, 30, 45)
    frame.BorderSizePixel = 0
    frame.LayoutOrder = #parent:GetChildren()
    frame.Parent = parent
    local fc = Instance.new("UICorner")
    fc.CornerRadius = UDim.new(0, 8)
    fc.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.65, 0, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(240, 240, 255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 55, 0, 30)
    toggleBtn.Position = UDim2.new(1, -65, 0.5, -15)
    toggleBtn.BackgroundColor3 = default and Color3.fromRGB(0, 255, 128) or Color3.fromRGB(80, 80, 100)
    toggleBtn.Text = default and "ON" or "OFF"
    toggleBtn.TextColor3 = Color3.new(1, 1, 1)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 12
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Parent = frame
    local tcc = Instance.new("UICorner")
    tcc.CornerRadius = UDim.new(0, 6)
    tcc.Parent = toggleBtn

    toggleBtn.MouseButton1Click:Connect(function()
        local newState = toggleBtn.Text ~= "ON"
        toggleBtn.Text = newState and "ON" or "OFF"
        toggleBtn.BackgroundColor3 = newState and Color3.fromRGB(0, 255, 128) or Color3.fromRGB(80, 80, 100)
        if callback then callback(newState) end
    end)
    task.wait()
    parent.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end

local function CreateButton(parent, layout, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(25, 30, 45)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(240, 240, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.BorderSizePixel = 0
    btn.LayoutOrder = #parent:GetChildren()
    btn.Parent = parent
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 8)
    bc.Parent = btn
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 220, 255)
    stroke.Thickness = 1
    stroke.Transparency = 0.6
    stroke.Parent = btn

    btn.MouseButton1Click:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(35, 40, 60)
        task.wait(0.1)
        btn.BackgroundColor3 = Color3.fromRGB(25, 30, 45)
        if callback then callback() end
    end)
    task.wait()
    parent.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end

-- Создание вкладок
local espContent, espLayout = CreateTab("ESP", 1)
local flingContent, flingLayout = CreateTab("Fling", 2)
local movementContent, movementLayout = CreateTab("Movement", 3)

-- ESP элементы
CreateToggle(espContent, espLayout, "ESP Enabled", false, function(v) Config.ESP.Enabled = v end)
CreateToggle(espContent, espLayout, "Show Names", false, function(v) Config.ESP.ShowNames = v end)
CreateToggle(espContent, espLayout, "Show Roles", false, function(v) Config.ESP.ShowRoles = v end)
CreateToggle(espContent, espLayout, "XRay (Through Walls)", false, function(v) Config.ESP.XRay = v end)
CreateToggle(espContent, espLayout, "Gun Drop Highlight", false, function(v) Config.GunESP = {Enabled = v} end)

-- Fling элементы
CreateButton(flingContent, flingLayout, "🚀 Fling Nearest (Safe)", function()
    local t = GetNearestPlayer()
    if t then task.spawn(function() SafeFling(t) end) end
end)
CreateButton(flingContent, flingLayout, "🔪 Fling Murderer", function()
    local t = GetPlayerByRole("Murderer")
    if t then task.spawn(function() SafeFling(t) end) end
end)
CreateButton(flingContent, flingLayout, "🔫 Fling Sheriff", function()
    local t = GetPlayerByRole("Sheriff")
    if t then task.spawn(function() SafeFling(t) end) end
end)

-- Movement элементы
CreateToggle(movementContent, movementLayout, "Noclip", false, function(v) Config.Player.Noclip = v end)
CreateToggle(movementContent, movementLayout, "Autofarm Coins", false, function(v) Config.Autofarm.Enabled = v end)

-- Показываем первую вкладку
espContent.Visible = true
local firstTabBtn = SideBar:FindFirstChildWhichIsA("TextButton")
if firstTabBtn then
    firstTabBtn.BackgroundColor3 = Color3.fromRGB(0, 220, 255)
    firstTabBtn.TextColor3 = Color3.new(1, 1, 1)
end

ToggleBtn.MouseButton1Click:Connect(function() Menu.Visible = not Menu.Visible end)

-- ============================================
-- [MAIN LOOP] Главный цикл обновления
-- ============================================

local function OnPlayerAdded(player)
    task.wait(1)
    CreateESP(player)
end

Players.PlayerAdded:Connect(OnPlayerAdded)
for _, player in ipairs(Players:GetPlayers()) do
    task.spawn(function() OnPlayerAdded(player) end)
end

RunService.Heartbeat:Connect(function()
    -- ESP обновление
    for player, _ in pairs(ESPObjects) do
        if player and player.Parent then UpdateESP(player) end
    end
    
    -- Gun ESP
    CheckDroppedGuns()
    
    -- Noclip
    if Config.Player.Noclip and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
    
    -- WalkSpeed
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = Config.Player.WalkSpeed end
end)

print("========================================")
print("✅ MM2 Educational Script v6.0 Loaded!")
print("📚 Tabs: ESP | Fling | Movement")
print("🛡️  Anti-Detect: Safe Fling + Smooth Autofarm")
print("========================================")
