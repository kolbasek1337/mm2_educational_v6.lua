-- ============================================
-- MM2 SCRIPT v9.0 - TELEPORT FLING SYSTEM
-- Механика: Телепорт вверх → Захват цели → Отбрасывание → Возврат
-- ============================================

print("========================================")
print("⚡ MM2 Script v9.0 - TELEPORT FLING")
print("========================================")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ============================================
-- [CONFIG]
-- ============================================
local Config = {
    ESP = {
        Enabled = false,
        ShowNames = true,
        ShowRoles = true,
        XRay = false,
        MaxDistance = 400,
        UpdateRate = 0.1
    },
    Fling = {
        LaunchHeight = 500000000,      -- Высота телепорта (studs)
        ThrowPower = 5000000,       -- Сила отбрасывания
        ThrowDistance = 5000000,     -- Дистанция отбрасывания
        Duration = 2.51           -- Длительность импульса
    },
    GunESP = {
        Enabled = false
    },
    Player = {
        WalkSpeed = 16,
        Noclip = false
    }
}

-- ============================================
-- [ESP SYSTEM]
-- ============================================
local ESPObjects = {}
local GunHighlights = {}

local function GetRole(player)
    if not player then return "Innocent" end
    
    if player.Backpack then
        if player.Backpack:FindFirstChild("Knife") then return "Murderer" end
        if player.Backpack:FindFirstChild("Gun") then return "Sheriff" end
    end
    
    if player.Character then
        if player.Character:FindFirstChild("Knife") then return "Murderer" end
        if player.Character:FindFirstChild("Gun") then return "Sheriff" end
        local roleObj = player.Character:FindFirstChild("Role")
        if roleObj and roleObj:IsA("StringValue") then return roleObj.Value end
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

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_" .. player.Name
    billboard.Size = UDim2.new(0, 250, 0, 80)
    billboard.StudsOffset = Vector3.new(0, 4, 0)
    billboard.AlwaysOnTop = false
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

    data.Billboard.AlwaysOnTop = Config.ESP.XRay
    data.Billboard.Adornee = hrp
    data.Highlight.Parent = character
end

local function CheckDroppedGuns()
    if not Config.GunESP.Enabled then
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
        if not h.Parent then
            pcall(function() h:Destroy() end)
            GunHighlights[h] = nil
        end
    end
end

-- ============================================
-- [TELEPORT FLING SYSTEM]
-- Механика: Телепорт вверх → Захват цели → Отбрасывание → Возврат
-- ============================================
local FlingActive = false

local function TeleportFling(targetPlayer)
    if FlingActive then 
        warn("[Fling] Already active!")
        return false 
    end
    
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
    
    local targetChar = targetPlayer.Character
    local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
    local targetHum = targetChar and targetChar:FindFirstChildOfClass("Humanoid")
    
    if not myHRP or not myHum or not targetHRP or not targetHum then 
        warn("[Fling] Missing parts!")
        return false 
    end
    
    if targetHum.Health <= 0 then
        warn("[Fling] Target is dead!")
        return false
    end
    
    FlingActive = true
    print("[Fling] ========================================")
    print("[Fling] TARGET: " .. targetPlayer.Name)
    print("[Fling] ========================================")
    
    -- ФАЗА 1: Сохраняем исходную позицию
    local originalPosition = myHRP.CFrame
    print("[Fling] Phase 1: Saved position at " .. tostring(originalPosition.Position))
    
    -- ФАЗА 2: Отключаем коллизии у себя
    print("[Fling] Phase 2: Disabling collisions...")
    local myParts = {}
    for _, part in ipairs(myChar:GetDescendants()) do
        if part:IsA("BasePart") then
            myParts[part] = part.CanCollide
            part.CanCollide = false
        end
    end
    
    -- ФАЗА 3: Телепорт ВВЕРХ
    print("[Fling] Phase 3: Teleporting UP to height " .. Config.Fling.LaunchHeight)
    myHRP.CFrame = originalPosition + Vector3.new(0, Config.Fling.LaunchHeight, 0)
    myHum.PlatformStand = true
    task.wait(0.1)
    
    -- ФАЗА 4: Телепорт ЦЕЛИ к себе (рядом)
    print("[Fling] Phase 4: Teleporting target to me...")
    targetHRP.CFrame = myHRP.CFrame * CFrame.new(0, 0, -2)
    targetHum.PlatformStand = true
    task.wait(0.05)
    
    -- ФАЗА 5: Создаём Weld между мной и целью
    print("[Fling] Phase 5: Creating Weld constraint...")
    local weld = Instance.new("Weld")
    weld.Part0 = myHRP
    weld.Part1 = targetHRP
    weld.C0 = CFrame.new(0, 0, 0)
    weld.C1 = CFrame.new(0, 0, 2)  -- Смещение цели
    weld.Parent = myHRP
    
    -- ФАЗА 6: Создаём BodyVelocity на СЕБЯ с огромной силой
    print("[Fling] Phase 6: Applying launch velocity...")
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.P = 125000000
    
    -- Вектор отбрасывания (вперёд + вверх)
    local launchDirection = myHRP.CFrame.LookVector
    local launchVelocity = (launchDirection * Config.Fling.ThrowPower) + Vector3.new(0, Config.Fling.ThrowPower * 0.5, 0)
    
    bv.Velocity = launchVelocity
    bv.Parent = myHRP
    
    -- ФАЗА 7: Держим силу
    print("[Fling] Phase 7: Maintaining force for " .. Config.Fling.Duration .. "s...")
    local startTime = tick()
    while tick() - startTime < Config.Fling.Duration do
        if not myHRP or not myHRP.Parent or not targetHRP or not targetHRP.Parent then
            break
        end
        bv.Velocity = launchVelocity
        task.wait()
    end
    
    -- ФАЗА 8: Очистка
    print("[Fling] Phase 8: Cleanup...")
    weld:Destroy()
    bv:Destroy()
    
    -- Сбрасываем скорости
    myHRP.AssemblyLinearVelocity = Vector3.zero
    myHRP.AssemblyAngularVelocity = Vector3.zero
    targetHRP.AssemblyLinearVelocity = Vector3.zero
    targetHRP.AssemblyAngularVelocity = Vector3.zero
    
    -- ФАЗА 9: ВОЗВРАТ НА ИСХОДНУЮ ПОЗИЦИЮ
    print("[Fling] Phase 9: Returning to original position...")
    myHRP.CFrame = originalPosition
    myHum.PlatformStand = false
    myHum:ChangeState(Enum.HumanoidStateType.GettingUp)
    Camera.CameraSubject = myHum
    Camera.CameraType = Enum.CameraType.Custom
    
    -- Возвращаем коллизии
    for part, original in pairs(myParts) do
        if part and part.Parent then
            part.CanCollide = original
        end
    end
    
    -- Финальный сброс
    task.wait(0.1)
    myHRP.AssemblyLinearVelocity = Vector3.zero
    myHRP.AssemblyAngularVelocity = Vector3.zero
    myHum.PlatformStand = false
    
    FlingActive = false
    print("[Fling] ========================================")
    print("[Fling] COMPLETE! Target launched!")
    print("[Fling] ========================================")
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
                if d < 100 and d < dist then nearest, dist = p, d end
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
-- [GUI]
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
Title.Text = "⚡ MM2 v9.0 - TELEPORT FLING"
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

-- Вкладки
local espContent, espLayout = CreateTab("ESP", 1)
local flingContent, flingLayout = CreateTab("Fling", 2)
local movementContent, movementLayout = CreateTab("Movement", 3)

-- ESP
CreateToggle(espContent, espLayout, "ESP Enabled", false, function(v) Config.ESP.Enabled = v end)
CreateToggle(espContent, espLayout, "Show Names", true, function(v) Config.ESP.ShowNames = v end)
CreateToggle(espContent, espLayout, "Show Roles", true, function(v) Config.ESP.ShowRoles = v end)
CreateToggle(espContent, espLayout, "XRay", false, function(v) Config.ESP.XRay = v end)
CreateToggle(espContent, espLayout, "Gun Highlight", false, function(v) Config.GunESP.Enabled = v end)

-- Fling
CreateButton(flingContent, flingLayout, "🚀 Teleport Fling Nearest", function()
    local t = GetNearestPlayer()
    if t then task.spawn(function() TeleportFling(t) end) 
    else warn("No target!") end
end)
CreateButton(flingContent, flingLayout, "🔪 Teleport Fling Murderer", function()
    local t = GetPlayerByRole("Murderer")
    if t then task.spawn(function() TeleportFling(t) end) 
    else warn("Murderer not found!") end
end)
CreateButton(flingContent, flingLayout, " Teleport Fling Sheriff", function()
    local t = GetPlayerByRole("Sheriff")
    if t then task.spawn(function() TeleportFling(t) end) 
    else warn("Sheriff not found!") end
end)

-- Movement
CreateToggle(movementContent, movementLayout, "Noclip", false, function(v) Config.Player.Noclip = v end)

-- Показываем ESP
espContent.Visible = true
local firstTab = SideBar:FindFirstChildWhichIsA("TextButton")
if firstTab then
    firstTab.BackgroundColor3 = Color3.fromRGB(0, 220, 255)
    firstTab.TextColor3 = Color3.new(1, 1, 1)
end

ToggleBtn.MouseButton1Click:Connect(function() Menu.Visible = not Menu.Visible end)

-- ============================================
-- [MAIN LOOP]
-- ============================================
local function OnPlayerAdded(player)
    task.wait(1)
    CreateESP(player)
end

Players.PlayerAdded:Connect(OnPlayerAdded)
for _, p in ipairs(Players:GetPlayers()) do
    task.spawn(function() OnPlayerAdded(p) end)
end

RunService.Heartbeat:Connect(function()
    for player, _ in pairs(ESPObjects) do
        if player and player.Parent then UpdateESP(player) end
    end
    CheckDroppedGuns()
    
    if Config.Player.Noclip and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
    
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = Config.Player.WalkSpeed end
end)

print("========================================")
print("✅ MM2 Script v9.0 Loaded!")
print("🚀 TELEPORT FLING SYSTEM READY")
print(" ESP | Fling | Movement")
print("========================================")
