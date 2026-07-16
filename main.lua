-- MM2 MOBILE HUB v4.2
-- FULL LAYOUT: Left Nav + Right Content
-- Created by goodlooking team

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- =============================================
-- 1. ЗАГРУЗОЧНЫЙ ЭКРАН
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
-- 2. ТОГГЛЫ
-- =============================================
local toggles = {
    ESP = false,
    Aim = false,
    Fling = false,
    AutoFarm = false
}

-- =============================================
-- 3. ОСНОВНОЙ ИНТЕРФЕЙС (ПО МАКЕТУ)
-- =============================================
local ScreenGui = nil
local MainFrame = nil
local currentTab = 1
local navButtons = {}

function createMainUI()
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game.CoreGui
    ScreenGui.Name = "MM2MobileHub"
    ScreenGui.ResetOnSpawn = false

    -- =============================================
    -- ОСНОВНАЯ РАМКА
    -- =============================================
    MainFrame = Instance.new("Frame")
    MainFrame.Parent = ScreenGui
    MainFrame.Size = UDim2.new(0, 400, 0, 500)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 6, 25)
    MainFrame.BackgroundTransparency = 0.05
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true

    local MainCorner = Instance.new("UICorner")
    MainCorner.Parent = MainFrame
    MainCorner.CornerRadius = UDim.new(0, 16)

    local MainGradient = Instance.new("UIGradient")
    MainGradient.Parent = MainFrame
    MainGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 0, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 0, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 200, 255))
    })
    MainGradient.Rotation = 45

    -- =============================================
    -- ВЕРХНЯЯ ПАНЕЛЬ (Лого + Статус)
    -- =============================================
    local TopPanel = Instance.new("Frame")
    TopPanel.Parent = MainFrame
    TopPanel.Size = UDim2.new(1, 0, 0, 45)
    TopPanel.BackgroundColor3 = Color3.fromRGB(20, 12, 45)
    TopPanel.BackgroundTransparency = 0.4
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
    CloseBtn.Position = UDim2.new(1, -35, 0, 8)
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
    end)

    -- =============================================
    -- ЛЕВАЯ ПАНЕЛЬ (НАВИГАЦИЯ)
    -- =============================================
    local LeftPanel = Instance.new("Frame")
    LeftPanel.Parent = MainFrame
    LeftPanel.Size = UDim2.new(0, 150, 1, -80)
    LeftPanel.Position = UDim2.new(0, 0, 0, 50)
    LeftPanel.BackgroundColor3 = Color3.fromRGB(16, 10, 35)
    LeftPanel.BackgroundTransparency = 0.2
    LeftPanel.BorderSizePixel = 0
    LeftPanel.ClipsDescendants = true

    local LeftBorder = Instance.new("Frame")
    LeftBorder.Parent = LeftPanel
    LeftBorder.Size = UDim2.new(0, 1, 1, 0)
    LeftBorder.Position = UDim2.new(1, -1, 0, 0)
    LeftBorder.BackgroundColor3 = Color3.fromRGB(100, 80, 180)
    LeftBorder.BackgroundTransparency = 0.3
    LeftBorder.BorderSizePixel = 0

    -- Кнопки навигации
    local navData = {
        {icon = "👁️", name = "ESP & VISUALS", badge = "3"},
        {icon = "🎯", name = "COMBAT & AIMBOT", badge = "2"},
        {icon = "✈️", name = "MOVEMENT & FLY", badge = "4"},
        {icon = "💰", name = "AUTOFARM COINS", badge = "1"},
        {icon = "⚙️", name = "CONFIGS & PRESETS", badge = "0"},
        {icon = "🌀", name = "MISC & UTILITIES", badge = "5"}
    }

    for i, data in ipairs(navData) do
        local btn = Instance.new("TextButton")
        btn.Parent = LeftPanel
        btn.Size = UDim2.new(1, 0, 0, 42)
        btn.Position = UDim2.new(0, 0, 0, (i-1) * 42)
        btn.BackgroundColor3 = (i == 1) and Color3.fromRGB(80, 0, 200) or Color3.fromRGB(30, 20, 60)
        btn.BackgroundTransparency = (i == 1) and 0.3 or 0.5
        btn.Text = data.icon .. " " .. data.name .. "  (" .. data.badge .. ")"
        btn.TextColor3 = (i == 1) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 160, 220)
        btn.TextSize = 11
        btn.Font = Enum.Font.GothamSemibold
        btn.BorderSizePixel = 0
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.TextWrapped = true
        btn.ClipsDescendants = true
        btn.Tag = i

        local BtnCorner = Instance.new("UICorner")
        BtnCorner.Parent = btn
        BtnCorner.CornerRadius = UDim.new(0, 0)

        btn.MouseButton1Click:Connect(function()
            currentTab = i
            updateRightPanel(i)
            -- Обновить стиль кнопок
            for _, b in pairs(LeftPanel:GetChildren()) do
                if b:IsA("TextButton") then
                    b.BackgroundColor3 = Color3.fromRGB(30, 20, 60)
                    b.BackgroundTransparency = 0.5
                    b.TextColor3 = Color3.fromRGB(180, 160, 220)
                end
            end
            btn.BackgroundColor3 = Color3.fromRGB(80, 0, 200)
            btn.BackgroundTransparency = 0.3
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)

        table.insert(navButtons, btn)
    end

    -- =============================================
    -- ПРАВАЯ ПАНЕЛЬ (КОНТЕНТ)
    -- =============================================
    local RightPanel = Instance.new("Frame")
    RightPanel.Parent = MainFrame
    RightPanel.Size = UDim2.new(1, -155, 1, -80)
    RightPanel.Position = UDim2.new(0, 150, 0, 50)
    RightPanel.BackgroundColor3 = Color3.fromRGB(10, 6, 25)
    RightPanel.BackgroundTransparency = 0.1
    RightPanel.BorderSizePixel = 0
    RightPanel.ClipsDescendants = true

    -- =============================================
    -- НИЖНЯЯ ПАНЕЛЬ (ФУТЕР)
    -- =============================================
    local Footer = Instance.new("Frame")
    Footer.Parent = MainFrame
    Footer.Size = UDim2.new(1, 0, 0, 30)
    Footer.Position = UDim2.new(0, 0, 1, -30)
    Footer.BackgroundColor3 = Color3.fromRGB(20, 12, 45)
    Footer.BackgroundTransparency = 0.4
    Footer.BorderSizePixel = 0

    local FootCorner = Instance.new("UICorner")
    FootCorner.Parent = Footer
    FootCorner.CornerRadius = UDim.new(0, 12)

    local UserLabel = Instance.new("TextLabel")
    UserLabel.Parent = Footer
    UserLabel.Size = UDim2.new(0.35, 0, 1, 0)
    UserLabel.Position = UDim2.new(0.02, 0, 0, 0)
    UserLabel.BackgroundTransparency = 1
    UserLabel.Text = "👤 " .. (LocalPlayer.Name or "Player")
    UserLabel.TextColor3 = Color3.fromRGB(180, 160, 220)
    UserLabel.TextSize = 10
    UserLabel.Font = Enum.Font.GothamSemibold
    UserLabel.TextXAlignment = Enum.TextXAlignment.Left

    local PingLabel = Instance.new("TextLabel")
    PingLabel.Parent = Footer
    PingLabel.Size = UDim2.new(0.6, 0, 1, 0)
    PingLabel.Position = UDim2.new(0.3, 0, 0, 0)
    PingLabel.BackgroundTransparency = 1
    PingLabel.Text = "📶 42ms | ⚡ 60 FPS | ✅ HWID: OK"
    PingLabel.TextColor3 = Color3.fromRGB(180, 160, 220)
    PingLabel.TextSize = 10
    PingLabel.Font = Enum.Font.GothamSemibold
    PingLabel.TextXAlignment = Enum.TextXAlignment.Right

    -- =============================================
    -- ДИНАМИЧЕСКИЙ КОНТЕНТ ПРАВОЙ ПАНЕЛИ
    -- =============================================
    local rightContents = {}

    -- Функция создания контента для вкладок
    function createTabContent(tabIndex)
        local container = Instance.new("Frame")
        container.Parent = RightPanel
        container.Size = UDim2.new(1, 0, 1, 0)
        container.BackgroundTransparency = 1
        container.Visible = (tabIndex == 1)
        container.Name = "Tab" .. tabIndex
        
        -- Заголовок
        local title = Instance.new("TextLabel")
        title.Parent = container
        title.Size = UDim2.new(1, 0, 0, 30)
        title.Position = UDim2.new(0, 0, 0, 5)
        title.BackgroundTransparency = 1
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.TextSize = 15
        title.Font = Enum.Font.GothamBold
        title.TextXAlignment = Enum.TextXAlignment.Left
        
        -- Подзаголовок
        local subtitle = Instance.new("TextLabel")
        subtitle.Parent = container
        subtitle.Size = UDim2.new(1, 0, 0, 20)
        subtitle.Position = UDim2.new(0, 0, 0, 38)
        subtitle.BackgroundTransparency = 1
        subtitle.TextColor3 = Color3.fromRGB(180, 160, 220)
        subtitle.TextSize = 11
        subtitle.Font = Enum.Font.GothamSemibold
        subtitle.TextXAlignment = Enum.TextXAlignment.Left
        
        -- Контейнер для кнопок-тогглов
        local toggleContainer = Instance.new("Frame")
        toggleContainer.Parent = container
        toggleContainer.Size = UDim2.new(1, 0, 1, -70)
        toggleContainer.Position = UDim2.new(0, 0, 0, 65)
        toggleContainer.BackgroundTransparency = 1
        
        -- Заполнение контентом
        if tabIndex == 1 then -- ESP
            title.Text = "👁️ ESP & VISUALS"
            subtitle.Text = "Отображение сквозь стены: АКТИВНО (14 объектов)"
            addToggle(toggleContainer, "ESP", 0, function()
                toggles.ESP = not toggles.ESP
            end)
            addToggle(toggleContainer, "Players ESP", 40, function() end)
            addToggle(toggleContainer, "Items ESP", 80, function() end)
            
        elseif tabIndex == 2 then -- COMBAT
            title.Text = "🎯 COMBAT & AIMBOT"
            subtitle.Text = "Цель: DarkKnight_99 [Убийца]"
            addToggle(toggleContainer, "Aim Assist", 0, function()
                toggles.Aim = not toggles.Aim
            end)
            addToggle(toggleContainer, "Silent Aim", 40, function() end)
            addToggle(toggleContainer, "Trigger Bot", 80, function() end)
            
        elseif tabIndex == 3 then -- FLY
            title.Text = "✈️ MOVEMENT & FLY"
            subtitle.Text = "Fly: OFF | Speed: 16"
            addToggle(toggleContainer, "Fling", 0, function()
                toggles.Fling = not toggles.Fling
            end)
            addToggle(toggleContainer, "Fly Mode", 40, function() end)
            addToggle(toggleContainer, "Noclip", 80, function() end)
            
        elseif tabIndex == 4 then -- FARM
            title.Text = "💰 AUTOFARM COINS"
            subtitle.Text = "Монет: 1 450 | CPM: 45 | Level: 14 min"
            addToggle(toggleContainer, "Auto Farm", 0, function()
                toggles.AutoFarm = not toggles.AutoFarm
            end)
            addToggle(toggleContainer, "Auto Collect", 40, function() end)
            addToggle(toggleContainer, "Anti AFK", 80, function() end)
            
        elseif tabIndex == 5 then -- CONFIG
            title.Text = "⚙️ CONFIGS & PRESETS"
            subtitle.Text = "Активен: Legit_Sheriff_V2.json"
            addToggle(toggleContainer, "Rage_Murderer", 0, function() end)
            addToggle(toggleContainer, "Legit_Casual", 40, function() end)
            addToggle(toggleContainer, "AFK_CoinFarm", 80, function() end)
            
        elseif tabIndex == 6 then -- MISC
            title.Text = "🌀 MISC & UTILITIES"
            subtitle.Text = "Игроков: 11/12 | Сервер: 2ч 14м"
            addToggle(toggleContainer, "Chat Spy", 0, function() end)
            addToggle(toggleContainer, "Anti AFK", 40, function() end)
            addToggle(toggleContainer, "Auto Boxes", 80, function() end)
        end
        
        return container
    end

    -- Функция создания кнопки-тоггла
    function addToggle(parent, text, yPos, callback)
        local btn = Instance.new("TextButton")
        btn.Parent = parent
        btn.Size = UDim2.new(0.95, 0, 0, 32)
        btn.Position = UDim2.new(0.025, 0, 0, yPos)
        btn.BackgroundColor3 = Color3.fromRGB(40, 20, 80)
        btn.BackgroundTransparency = 0.3
        btn.Text = text .. ": OFF"
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 12
        btn.Font = Enum.Font.GothamSemibold
        btn.BorderSizePixel = 0
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.TextWrapped = true
        
        local BtnCorner = Instance.new("UICorner")
        BtnCorner.Parent = btn
        BtnCorner.CornerRadius = UDim.new(0, 10)
        
        local isOn = false
        btn.MouseButton1Click:Connect(function()
            isOn = not isOn
            btn.Text = text .. ": " .. (isOn and "ON" or "OFF")
            btn.BackgroundColor3 = isOn and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(40, 20, 80)
            if callback then callback() end
        end)
        
        return btn
    end

    -- Создаём контент для всех вкладок
    for i = 1, 6 do
        rightContents[i] = createTabContent(i)
    end

    -- Функция обновления правой панели
    function updateRightPanel(tabIndex)
        for i, content in pairs(rightContents) do
            content.Visible = (i == tabIndex)
        end
    end

    -- Переключение на первую вкладку по умолчанию
    updateRightPanel(1)

    -- =============================================
    -- DRAG ДЛЯ МОБИЛЬНЫХ
    -- =============================================
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
    -- ФУНКЦИИ СКРИПТА
    -- =============================================
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
    print("[MM2 MOBILE] HUB загружен по макету!")
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
