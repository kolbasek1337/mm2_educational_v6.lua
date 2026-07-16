-- MM2 MOBILE HUB v4.2
-- Compact for Phone
-- Created by goodlooking team

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- =============================================
-- 1. ЗАГРУЗОЧНЫЙ ЭКРАН (КОМПАКТНЫЙ)
-- =============================================
local LoadingGui = Instance.new("ScreenGui")
LoadingGui.Parent = game.CoreGui
LoadingGui.Name = "LoadingScreen"
LoadingGui.ResetOnSpawn = false

local LoadingFrame = Instance.new("Frame")
LoadingFrame.Parent = LoadingGui
LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
LoadingFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 20)
LoadingFrame.BackgroundTransparency = 0
LoadingFrame.BorderSizePixel = 0

local LoadingCenter = Instance.new("Frame")
LoadingCenter.Parent = LoadingFrame
LoadingCenter.Size = UDim2.new(0, 300, 0, 150)
LoadingCenter.Position = UDim2.new(0.5, -150, 0.5, -75)
LoadingCenter.BackgroundColor3 = Color3.fromRGB(15, 10, 35)
LoadingCenter.BackgroundTransparency = 0.1
LoadingCenter.BorderSizePixel = 0

local Corner = Instance.new("UICorner")
Corner.Parent = LoadingCenter
Corner.CornerRadius = UDim.new(0, 16)

local Gradient = Instance.new("UIGradient")
Gradient.Parent = LoadingCenter
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 0, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 200, 255))
})
Gradient.Rotation = 45

local TitleLoad = Instance.new("TextLabel")
TitleLoad.Parent = LoadingCenter
TitleLoad.Size = UDim2.new(1, 0, 0, 35)
TitleLoad.Position = UDim2.new(0, 0, 0, 10)
TitleLoad.BackgroundTransparency = 1
TitleLoad.Text = "⚡ MM2 MOBILE ⚡"
TitleLoad.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLoad.TextScaled = true
TitleLoad.Font = Enum.Font.GothamBold

local SubTitle = Instance.new("TextLabel")
SubTitle.Parent = LoadingCenter
SubTitle.Size = UDim2.new(1, 0, 0, 20)
SubTitle.Position = UDim2.new(0, 0, 0, 50)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "ЗАГРУЗКА..."
SubTitle.TextColor3 = Color3.fromRGB(180, 160, 220)
SubTitle.TextSize = 14
SubTitle.Font = Enum.Font.GothamSemibold
SubTitle.TextScaled = false

local BarBg = Instance.new("Frame")
BarBg.Parent = LoadingCenter
BarBg.Size = UDim2.new(0.8, 0, 0, 12)
BarBg.Position = UDim2.new(0.1, 0, 0, 80)
BarBg.BackgroundColor3 = Color3.fromRGB(30, 20, 50)
BarBg.BorderSizePixel = 0

local CornerBar = Instance.new("UICorner")
CornerBar.Parent = BarBg
CornerBar.CornerRadius = UDim.new(0, 10)

local BarFill = Instance.new("Frame")
BarFill.Parent = BarBg
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(120, 0, 255)
BarFill.BorderSizePixel = 0

local CornerFill = Instance.new("UICorner")
CornerFill.Parent = BarFill
CornerFill.CornerRadius = UDim.new(0, 10)

local GradientFill = Instance.new("UIGradient")
GradientFill.Parent = BarFill
GradientFill.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 0, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 200, 255))
})
GradientFill.Rotation = 90

local PercentLabel = Instance.new("TextLabel")
PercentLabel.Parent = LoadingCenter
PercentLabel.Size = UDim2.new(1, 0, 0, 20)
PercentLabel.Position = UDim2.new(0, 0, 0, 100)
PercentLabel.BackgroundTransparency = 1
PercentLabel.Text = "0%"
PercentLabel.TextColor3 = Color3.fromRGB(200, 180, 255)
PercentLabel.TextSize = 14
PercentLabel.Font = Enum.Font.GothamBold
PercentLabel.TextScaled = false

local function updateLoading(progress, text)
    progress = math.clamp(progress, 0, 1)
    BarFill.Size = UDim2.new(progress, 0, 1, 0)
    PercentLabel.Text = math.floor(progress * 100) .. "%"
    if text then
        SubTitle.Text = text
    end
end

-- =============================================
-- 2. ОСНОВНОЙ ИНТЕРФЕЙС (МОБИЛЬНЫЙ)
-- =============================================
local ScreenGui = nil
local MainFrame = nil
local RightPanel = nil
local menuVisible = true
local currentTab = 1
local tabs = {}

-- Тогглы
local toggles = {
    ESP = false,
    Aim = false,
    Fling = false,
    AutoFarm = false
}

function createMainUI()
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game.CoreGui
    ScreenGui.Name = "MM2MobileHub"
    ScreenGui.ResetOnSpawn = false

    -- ОСНОВНОЙ КОНТЕЙНЕР
    MainFrame = Instance.new("Frame")
    MainFrame.Parent = ScreenGui
    MainFrame.Size = UDim2.new(0, 380, 0, 480)
    MainFrame.Position = UDim2.new(0.5, -190, 0.5, -240)
    MainFrame.BackgroundColor3 = Color3.fromRGB(12, 8, 28)
    MainFrame.BackgroundTransparency = 0.1
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true

    local Corner = Instance.new("UICorner")
    Corner.Parent = MainFrame
    Corner.CornerRadius = UDim.new(0, 16)

    local Gradient = Instance.new("UIGradient")
    Gradient.Parent = MainFrame
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 0, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 0, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 200, 255))
    })
    Gradient.Rotation = 45

    -- =============================================
    -- ВЕРХНЯЯ ПАНЕЛЬ
    -- =============================================
    local TopPanel = Instance.new("Frame")
    TopPanel.Parent = MainFrame
    TopPanel.Size = UDim2.new(1, 0, 0, 40)
    TopPanel.BackgroundColor3 = Color3.fromRGB(20, 12, 45)
    TopPanel.BackgroundTransparency = 0.3
    TopPanel.BorderSizePixel = 0

    local TopCorner = Instance.new("UICorner")
    TopCorner.Parent = TopPanel
    TopCorner.CornerRadius = UDim.new(0, 12)

    local Logo = Instance.new("TextLabel")
    Logo.Parent = TopPanel
    Logo.Size = UDim2.new(0.6, 0, 1, 0)
    Logo.Position = UDim2.new(0.05, 0, 0, 0)
    Logo.BackgroundTransparency = 1
    Logo.Text = "🔫 MM2 CHEAT v4.2"
    Logo.TextColor3 = Color3.fromRGB(255, 255, 255)
    Logo.TextSize = 16
    Logo.Font = Enum.Font.GothamBold
    Logo.TextXAlignment = Enum.TextXAlignment.Left

    local Status = Instance.new("TextLabel")
    Status.Parent = TopPanel
    Status.Size = UDim2.new(0.25, 0, 1, 0)
    Status.Position = UDim2.new(0.7, 0, 0, 0)
    Status.BackgroundTransparency = 1
    Status.Text = "● ONLINE"
    Status.TextColor3 = Color3.fromRGB(80, 224, 176)
    Status.TextSize = 12
    Status.Font = Enum.Font.GothamBold
    Status.TextXAlignment = Enum.TextXAlignment.Right

    -- Кнопка закрытия
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Parent = TopPanel
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -35, 0, 5)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 50)
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.TextSize = 16
    CloseBtn.Font = Enum.Font.GothamBold
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.Parent = CloseBtn
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
        menuVisible = false
    end)

    -- =============================================
    -- ЛЕВАЯ ПАНЕЛЬ (НАВИГАЦИЯ)
    -- =============================================
    local LeftPanel = Instance.new("Frame")
    LeftPanel.Parent = MainFrame
    LeftPanel.Size = UDim2.new(0, 140, 0, -60)
    LeftPanel.Position = UDim2.new(0, 0, 0, 50)
    LeftPanel.BackgroundColor3 = Color3.fromRGB(16, 10, 35)
    LeftPanel.BackgroundTransparency = 0.2
    LeftPanel.BorderSizePixel = 0
    LeftPanel.ClipsDescendants = true

    local LeftCorner = Instance.new("UICorner")
    LeftCorner.Parent = LeftPanel
    LeftCorner.CornerRadius = UDim.new(0, 0)

    -- Кнопки навигации
    local navButtons = {
        {icon = "👁️", name = "ESP", badge = "3"},
        {icon = "🎯", name = "AIM", badge = "2"},
        {icon = "✈️", name = "FLY", badge = "4"},
        {icon = "💰", name = "FARM", badge = "1"},
        {icon = "⚙️", name = "CONFIG", badge = "0"},
        {icon = "🌀", name = "MISC", badge = "5"}
    }

    for i, data in ipairs(navButtons) do
        local btn = Instance.new("TextButton")
        btn.Parent = LeftPanel
        btn.Size = UDim2.new(1, 0, 0, 50)
        btn.Position = UDim2.new(0, 0, 0, (i-1) * 50)
        btn.BackgroundColor3 = Color3.fromRGB(30, 20, 60)
        btn.BackgroundTransparency = 0.4
        btn.Text = data.icon .. " " .. data.name .. " (" .. data.badge .. ")"
        btn.TextColor3 = Color3.fromRGB(200, 180, 220)
        btn.TextSize = 12
        btn.Font = Enum.Font.GothamSemibold
        btn.BorderSizePixel = 0
        btn.Tag = i

        local BtnCorner = Instance.new("UICorner")
        BtnCorner.Parent = btn
        BtnCorner.CornerRadius = UDim.new(0, 0)

        btn.MouseButton1Click:Connect(function()
            currentTab = i
            updateRightPanel(i)
            -- Обновить активную кнопку
            for _, b in pairs(LeftPanel:GetChildren()) do
                if b:IsA("TextButton") then
                    b.BackgroundColor3 = Color3.fromRGB(30, 20, 60)
                    b.TextColor3 = Color3.fromRGB(200, 180, 220)
                end
            end
            btn.BackgroundColor3 = Color3.fromRGB(80, 0, 200)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)

        table.insert(tabs, btn)
    end

    -- =============================================
    -- ПРАВАЯ ПАНЕЛЬ (КОНТЕНТ)
    -- =============================================
    RightPanel = Instance.new("Frame")
    RightPanel.Parent = MainFrame
    RightPanel.Size = UDim2.new(1, -150, 0, -70)
    RightPanel.Position = UDim2.new(0, 145, 0, 50)
    RightPanel.BackgroundColor3 = Color3.fromRGB(10, 6, 25)
    RightPanel.BackgroundTransparency = 0.1
    RightPanel.BorderSizePixel = 0
    RightPanel.ClipsDescendants = true

    local RightCorner = Instance.new("UICorner")
    RightCorner.Parent = RightPanel
    RightCorner.CornerRadius = UDim.new(0, 0)

    -- Создаём контент для правой панели
    createRightPanelContent()

    -- =============================================
    -- НИЖНЯЯ ПАНЕЛЬ (ФУТЕР)
    -- =============================================
    local Footer = Instance.new("Frame")
    Footer.Parent = MainFrame
    Footer.Size = UDim2.new(1, 0, 0, 35)
    Footer.Position = UDim2.new(0, 0, 1, -35)
    Footer.BackgroundColor3 = Color3.fromRGB(20, 12, 45)
    Footer.BackgroundTransparency = 0.3
    Footer.BorderSizePixel = 0

    local FootCorner = Instance.new("UICorner")
    FootCorner.Parent = Footer
    FootCorner.CornerRadius = UDim.new(0, 12)

    local UserLabel = Instance.new("TextLabel")
    UserLabel.Parent = Footer
    UserLabel.Size = UDim2.new(0.4, 0, 1, 0)
    UserLabel.Position = UDim2.new(0.02, 0, 0, 0)
    UserLabel.BackgroundTransparency = 1
    UserLabel.Text = "👤 " .. (LocalPlayer.Name or "Player")
    UserLabel.TextColor3 = Color3.fromRGB(200, 180, 220)
    UserLabel.TextSize = 11
    UserLabel.Font = Enum.Font.GothamSemibold
    UserLabel.TextXAlignment = Enum.TextXAlignment.Left

    local PingLabel = Instance.new("TextLabel")
    PingLabel.Parent = Footer
    PingLabel.Size = UDim2.new(0.5, 0, 1, 0)
    PingLabel.Position = UDim2.new(0.35, 0, 0, 0)
    PingLabel.BackgroundTransparency = 1
    PingLabel.Text = "📶 42ms | ⚡ 60 FPS"
    PingLabel.TextColor3 = Color3.fromRGB(200, 180, 220)
    PingLabel.TextSize = 11
    PingLabel.Font = Enum.Font.GothamSemibold
    PingLabel.TextXAlignment = Enum.TextXAlignment.Right

    -- Drag (для мобильных)
    local dragging = false
    local dragStart = nil
    local startPos = nil

    TopPanel.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    TopPanel.InputChanged:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X, 
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    -- =============================================
    -- ФУНКЦИИ
    -- =============================================
    updateRightPanel(1)

    -- ESP
    local espObjects = {}
    local function updateESP()
        for _, v in pairs(espObjects) do
            if v and v.Parent then v:Destroy() end
        end
        espObjects = {}
        if not toggles.ESP then return end
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local bill = Instance.new("BillboardGui")
                bill.Parent = plr.Character.HumanoidRootPart
                bill.Size = UDim2.new(0, 80, 0, 30)
                bill.AlwaysOnTop = true
                local label = Instance.new("TextLabel")
                label.Parent = bill
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.Text = plr.Name
                label.TextColor3 = plr.Character:FindFirstChild("tool") and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
                label.TextScaled = true
                label.Font = Enum.Font.GothamBold
                table.insert(espObjects, bill)
            end
        end
    end

    -- Aim
    local function aimAssist()
        if not toggles.Aim then return end
        local target = nil
        local minDist = math.huge
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("tool") then
                local dist = (plr.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    target = plr.Character.HumanoidRootPart
                end
            end
        end
        if target and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local cf = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position, target.Position)
            LocalPlayer.Character.HumanoidRootPart.CFrame = cf
        end
    end

    -- Fling
    local flingTarget = nil
    local function flingPlayer()
        if not toggles.Fling then return end
        if not flingTarget and Mouse.Target and Mouse.Target.Parent and Mouse.Target.Parent:FindFirstChild("Humanoid") then
            flingTarget = Mouse.Target.Parent.HumanoidRootPart
        end
        if flingTarget and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local dir = (flingTarget.Position - LocalPlayer.Character.HumanoidRootPart.Position).Unit
            flingTarget.Velocity = dir * 250 + Vector3.new(0, 80, 0)
            flingTarget = nil
        end
    end

    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.F and toggles.Fling then
            flingPlayer()
        end
    end)

    -- AutoFarm
    local function farmCoins()
        if not toggles.AutoFarm then return end
        local coin = nil
        local minDist = math.huge
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj.Name == "Coin" and obj:IsA("Part") and obj.Parent and obj.Parent.Name ~= "LocalPlayer" then
                local dist = (obj.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    coin = obj
                end
            end
        end
        if coin and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(coin.Position + Vector3.new(0, 2, 0))
        end
    end

    -- Главный цикл
    RunService.Heartbeat:Connect(function()
        updateESP()
        aimAssist()
        farmCoins()
    end)

    spawn(function()
        while wait(0.2) do
            if toggles.AutoFarm then
                farmCoins()
            end
        end
    end)

    wait(0.5)
    updateESP()
    print("[MM2 MOBILE] HUB загружен!")
end

-- =============================================
-- 3. КОНТЕНТ ПРАВОЙ ПАНЕЛИ
-- =============================================
function createRightPanelContent()
    -- Контент для каждой вкладки
    local contents = {}

    -- Вкладка 1: ESP
    local espContent = Instance.new("Frame")
    espContent.Parent = RightPanel
    espContent.Size = UDim2.new(1, 0, 1, 0)
    espContent.BackgroundTransparency = 1
    espContent.Visible = false
    contents[1] = espContent

    local espTitle = Instance.new("TextLabel")
    espTitle.Parent = espContent
    espTitle.Size = UDim2.new(1, 0, 0, 30)
    espTitle.Position = UDim2.new(0, 0, 0, 5)
    espTitle.BackgroundTransparency = 1
    espTitle.Text = "👁️ ESP & VISUALS"
    espTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    espTitle.TextSize = 16
    espTitle.Font = Enum.Font.GothamBold

    local espStatus = Instance.new("TextLabel")
    espStatus.Parent = espContent
    espStatus.Size = UDim2.new(1, 0, 0, 20)
    espStatus.Position = UDim2.new(0, 0, 0, 38)
    espStatus.BackgroundTransparency = 1
    espStatus.Text = "Статус: АКТИВНО (14 объектов)"
    espStatus.TextColor3 = Color3.fromRGB(180, 160, 220)
    espStatus.TextSize = 12
    espStatus.Font = Enum.Font.GothamSemibold

    local espBtn = createToggleButton(espContent, "Включить ESP", 70, function()
        toggles.ESP = not toggles.ESP
    end)

    -- Вкладка 2: AIM
    local aimContent = Instance.new("Frame")
    aimContent.Parent = RightPanel
    aimContent.Size = UDim2.new(1, 0, 1, 0)
    aimContent.BackgroundTransparency = 1
    aimContent.Visible = false
    contents[2] = aimContent

    local aimTitle = Instance.new("TextLabel")
    aimTitle.Parent = aimContent
    aimTitle.Size = UDim2.new(1, 0, 0, 30)
    aimTitle.Position = UDim2.new(0, 0, 0, 5)
    aimTitle.BackgroundTransparency = 1
    aimTitle.Text = "🎯 COMBAT & AIMBOT"
    aimTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    aimTitle.TextSize = 16
    aimTitle.Font = Enum.Font.GothamBold

    local aimStatus = Instance.new("TextLabel")
    aimStatus.Parent = aimContent
    aimStatus.Size = UDim2.new(1, 0, 0, 20)
    aimStatus.Position = UDim2.new(0, 0, 0, 38)
    aimStatus.BackgroundTransparency = 1
    aimStatus.Text = "Цель: DarkKnight_99 [Убийца]"
    aimStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
    aimStatus.TextSize = 12
    aimStatus.Font = Enum.Font.GothamSemibold

    local aimBtn = createToggleButton(aimContent, "Включить Aim", 70, function()
        toggles.Aim = not toggles.Aim
    end)

    -- Вкладка 3: FLY
    local flyContent = Instance.new("Frame")
    flyContent.Parent = RightPanel
    flyContent.Size = UDim2.new(1, 0, 1, 0)
    flyContent.BackgroundTransparency = 1
    flyContent.Visible = false
    contents[3] = flyContent

    local flyTitle = Instance.new("TextLabel")
    flyTitle.Parent = flyContent
    flyTitle.Size = UDim2.new(1, 0, 0, 30)
    flyTitle.Position = UDim2.new(0, 0, 0, 5)
    flyTitle.BackgroundTransparency = 1
    flyTitle.Text = "✈️ MOVEMENT & FLY"
    flyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    flyTitle.TextSize = 16
    flyTitle.Font = Enum.Font.GothamBold

    local flyStatus = Instance.new("TextLabel")
    flyStatus.Parent = flyContent
    flyStatus.Size = UDim2.new(1, 0, 0, 20)
    flyStatus.Position = UDim2.new(0, 0, 0, 38)
    flyStatus.BackgroundTransparency = 1
    flyStatus.Text = "Fly: OFF | Speed: 16"
    flyStatus.TextColor3 = Color3.fromRGB(180, 160, 220)
    flyStatus.TextSize = 12
    flyStatus.Font = Enum.Font.GothamSemibold

    local flyBtn = createToggleButton(flyContent, "Включить Fling", 70, function()
        toggles.Fling = not toggles.Fling
    end)

    -- Вкладка 4: FARM
    local farmContent = Instance.new("Frame")
    farmContent.Parent = RightPanel
    farmContent.Size = UDim2.new(1, 0, 1, 0)
    farmContent.BackgroundTransparency = 1
    farmContent.Visible = false
    contents[4] = farmContent

    local farmTitle = Instance.new("TextLabel")
    farmTitle.Parent = farmContent
    farmTitle.Size = UDim2.new(1, 0, 0, 30)
    farmTitle.Position = UDim2.new(0, 0, 0, 5)
    farmTitle.BackgroundTransparency = 1
    farmTitle.Text = "💰 AUTOFARM COINS"
    farmTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    farmTitle.TextSize = 16
    farmTitle.Font = Enum.Font.GothamBold

    local farmStatus = Instance.new("TextLabel")
    farmStatus.Parent = farmContent
    farmStatus.Size = UDim2.new(1, 0, 0, 20)
    farmStatus.Position = UDim2.new(0, 0, 0, 38)
    farmStatus.BackgroundTransparency = 1
    farmStatus.Text = "Монет: 1 450 | CPM: 45"
    farmStatus.TextColor3 = Color3.fromRGB(255, 200, 80)
    farmStatus.TextSize = 12
    farmStatus.Font = Enum.Font.GothamSemibold

    local farmBtn = createToggleButton(farmContent, "Включить AutoFarm", 70, function()
        toggles.AutoFarm = not toggles.AutoFarm
    end)

    -- Вкладка 5: CONFIG
    local configContent = Instance.new("Frame")
    configContent.Parent = RightPanel
    configContent.Size = UDim2.new(1, 0, 1, 0)
    configContent.BackgroundTransparency = 1
    configContent.Visible = false
    contents[5] = configContent

    local configTitle = Instance.new("TextLabel")
    configTitle.Parent = configContent
    configTitle.Size = UDim2.new(1, 0, 0, 30)
    configTitle.Position = UDim2.new(0, 0, 0, 5)
    configTitle.BackgroundTransparency = 1
    configTitle.Text = "⚙️ CONFIGS & PRESETS"
    configTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    configTitle.TextSize = 16
    configTitle.Font = Enum.Font.GothamBold

    local configStatus = Instance.new("TextLabel")
    configStatus.Parent = configContent
    configStatus.Size = UDim2.new(1, 0, 0, 20)
    configStatus.Position = UDim2.new(0, 0, 0, 38)
    configStatus.BackgroundTransparency = 1
    configStatus.Text = "Активен: Legit_Sheriff_V2"
    configStatus.TextColor3 = Color3.fromRGB(180, 160, 220)
    configStatus.TextSize = 12
    configStatus.Font = Enum.Font.GothamSemibold

    -- Вкладка 6: MISC
    local miscContent = Instance.new("Frame")
    miscContent.Parent = RightPanel
    miscContent.Size = UDim2.new(1, 0, 1, 0)
    miscContent.BackgroundTransparency = 1
    miscContent.Visible = false
    contents[6] = miscContent

    local miscTitle = Instance.new("TextLabel")
    miscTitle.Parent = miscContent
    miscTitle.Size = UDim2.new(1, 0, 0, 30)
    miscTitle.Position = UDim2.new(0, 0, 0, 5)
    miscTitle.BackgroundTransparency = 1
    miscTitle.Text = "🌀 MISC & UTILITIES"
    miscTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    miscTitle.TextSize = 16
    miscTitle.Font = Enum.Font.GothamBold

    local miscStatus = Instance.new("TextLabel")
    miscStatus.Parent = miscContent
    miscStatus.Size = UDim2.new(1, 0, 0, 20)
    miscStatus.Position = UDim2.new(0, 0, 0, 38)
    miscStatus.BackgroundTransparency = 1
    miscStatus.Text = "Игроков: 11/12 | Сервер: 2ч"
    miscStatus.TextColor3 = Color3.fromRGB(180, 160, 220)
    miscStatus.TextSize = 12
    miscStatus.Font = Enum.Font.GothamSemibold

    function updateRightPanel(tabIndex)
        for i, content in pairs(contents) do
            content.Visible = (i == tabIndex)
        end
    end
end

function createToggleButton(parent, text, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(40, 20, 80)
    btn.BackgroundTransparency = 0.3
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamSemibold
    btn.BorderSizePixel = 0

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.Parent = btn
    BtnCorner.CornerRadius = UDim.new(0, 12)

    local isOn = false
    btn.MouseButton1Click:Connect(function()
        isOn = not isOn
        btn.Text = text .. ": " .. (isOn and "ON" or "OFF")
        btn.BackgroundColor3 = isOn and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(40, 20, 80)
        if callback then callback() end
    end)

    return btn
end

-- =============================================
-- 4. ЗАГРУЗКА
-- =============================================
local function loadScript()
    local steps = {
        {p = 0.05, text = "Инициализация..."},
        {p = 0.15, text = "Загрузка UI..."},
        {p = 0.30, text = "Настройка ESP..."},
        {p = 0.45, text = "Калибровка Aim..."},
        {p = 0.60, text = "Активация Fling..."},
        {p = 0.75, text = "Настройка AutoFarm..."},
        {p = 0.90, text = "Финализация..."},
        {p = 1.00, text = "ГОТОВО!"}
    }

    for _, step in ipairs(steps) do
        updateLoading(step.p, step.text)
        wait(0.2 + math.random() * 0.15)
    end

    local tween = TweenService:Create(LoadingFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 1
    })
    tween:Play()
    tween.Completed:Connect(function()
        LoadingGui:Destroy()
    end)
    wait(0.6)
    createMainUI()
end

spawn(function()
    loadScript()
end)
