-- ============================================
-- MM2 WORKING FLING SYSTEM v8.0
-- Работает через СЕБЯ (self-fling) + коллизии
-- ============================================

print("🔧 Loading WORKING Fling System...")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Config = {
    Fling = {
        Power = 100,  -- Скорость (не сила!)
        Height = 50,  -- Высота подброса
        Duration = 0.3
    }
}

-- ============================================
-- РАБОЧИЙ FLING (через СЕБЯ)
-- ============================================
local function WorkingFling(targetPlayer)
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
    
    local targetChar = targetPlayer.Character
    local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
    
    if not myHRP or not myHum or not targetHRP then
        warn("[Fling] Missing parts!")
        return false
    end
    
    print("[Fling] Starting self-fling...")
    
    -- Сохраняем позицию
    local savedPos = myHRP.CFrame
    
    -- Отключаем коллизии СЕБЯ
    for _, part in ipairs(myChar:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
    
    -- PlatformStand
    myHum.PlatformStand = true
    
    -- Телепорт к цели (внутрь)
    myHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 0)
    task.wait(0.05)
    
    -- Создаём BodyVelocity на СЕБЯ
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Velocity = Vector3.new(0, Config.Fling.Power, 0)
    bv.Parent = myHRP
    
    -- Держим позицию внутри цели
    for i = 1, Config.Fling.Duration * 60 do  -- 60 FPS
        if not myHRP or not myHRP.Parent then break end
        myHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 0)
        task.wait(1/60)
    end
    
    -- Очистка
    bv:Destroy()
    myHRP.CFrame = savedPos
    myHRP.AssemblyLinearVelocity = Vector3.zero
    
    task.wait(0.1)
    myHum.PlatformStand = false
    
    -- Восстанавливаем коллизии
    for _, part in ipairs(myChar:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
        end
    end
    
    print("[Fling] Done!")
    return true
end

-- ============================================
-- АЛЬТЕРНАТИВА: Использование RemoteEvent (если есть)
-- ============================================
local function TryRemoteFling(targetPlayer)
    -- Ищем уязвимые RemoteEvent в игре
    local repStorage = game:GetService("ReplicatedStorage")
    local remotes = repStorage:FindFirstChild("Remotes") or repStorage
    
    -- Проверяем возможные события
    local possibleEvents = {
        "Fling", "Hit", "Attack", "KnifeHit", 
        "ServerHit", "Throw", "Stab"
    }
    
    for _, eventName in ipairs(possibleEvents) do
        local event = remotes:FindFirstChild(eventName)
        if event and event:IsA("RemoteEvent") then
            print("[Fling] Found RemoteEvent: " .. eventName)
            -- Пробуем отправить (может сработать, может нет)
            pcall(function()
                event:FireServer(targetPlayer.Character.HumanoidRootPart.Position)
            end)
        end
    end
end

-- ============================================
-- ESP (сокращённо)
-- ============================================
local ESPObjects = {}

local function GetRole(player)
    if player.Backpack then
        if player.Backpack:FindFirstChild("Knife") then return "Murderer" end
        if player.Backpack:FindFirstChild("Gun") then return "Sheriff" end
    end
    if player.Character then
        if player.Character:FindFirstChild("Knife") then return "Murderer" end
        if player.Character:FindFirstChild("Gun") then return "Sheriff" end
    end
    return "Innocent"
end

local function CreateESP(player)
    if player == LocalPlayer or ESPObjects[player] then return end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = game:GetService("CoreGui")
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = player.Name
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 16
    label.Parent = billboard
    
    ESPObjects[player] = {Billboard = billboard, Label = label}
end

local function UpdateESP(player)
    local data = ESPObjects[player]
    if not data then return end
    
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        data.Billboard.Parent = nil
        return
    end
    
    data.Billboard.Parent = hrp
    local role = GetRole(player)
    data.Label.Text = player.Name .. " [" .. role .. "]"
end

-- ============================================
-- GUI
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui")

local Menu = Instance.new("Frame")
Menu.Size = UDim2.new(0, 300, 0, 300)
Menu.Position = UDim2.new(0.5, -150, 0.5, -150)
Menu.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Menu.Visible = false
Menu.Parent = ScreenGui

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 60, 0, 60)
toggleBtn.Position = UDim2.new(0.9, 0, 0.1, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
toggleBtn.Text = "MENU"
toggleBtn.Parent = ScreenGui

toggleBtn.MouseButton1Click:Connect(function()
    Menu.Visible = not Menu.Visible
end)

local content = Instance.new("ScrollingFrame")
content.Size = UDim2.new(1, -10, 1, -10)
content.Position = UDim2.new(0, 5, 0, 5)
content.BackgroundTransparency = 1
content.Parent = Menu

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 5)
layout.Parent = content

local function addButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Parent = content
    btn.MouseButton1Click:Connect(callback)
    task.wait()
    content.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
end

-- Кнопки
addButton("🚀 Fling Nearest (Self)", function()
    local nearest = nil
    local minDist = math.huge
    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    if not myHRP then return end
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local th = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
            if th then
                local dist = (myHRP.Position - th.Position).Magnitude
                if dist < minDist then
                    nearest = p
                    minDist = dist
                end
            end
        end
    end
    
    if nearest and minDist < 50 then
        WorkingFling(nearest)
    else
        warn("No target nearby!")
    end
end)

addButton("🔪 Fling Murderer", function()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and GetRole(p) == "Murderer" then
            WorkingFling(p)
            break
        end
    end
end)

addButton("👥 ESP Toggle", function()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            if not ESPObjects[p] then
                CreateESP(p)
            end
        end
    end
end)

-- ============================================
-- MAIN LOOP
-- ============================================
Players.PlayerAdded:Connect(CreateESP)
for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then CreateESP(p) end
end

RunService.Heartbeat:Connect(function()
    for p, _ in pairs(ESPObjects) do
        if p and p.Parent then UpdateESP(p) end
    end
end)

print("✅ WORKING Fling System Loaded!")
print("ℹ️  Fling работает через СЕБЯ (вы подлетаете вверх с игроком)")
