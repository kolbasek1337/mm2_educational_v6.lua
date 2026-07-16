-- MM2 ULTIMATE HUB [good] v5.0
-- with Loading Bar & Toggle Menu
-- Created by goodlooking team

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- =============================================
-- 1. ЗАГРУЗОЧНЫЙ ЭКРАН (LOADING SCREEN)
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
LoadingCenter.Size = UDim2.new(0, 400, 0, 200)
LoadingCenter.Position = UDim2.new(0.5, -200, 0.5, -100)
LoadingCenter.BackgroundColor3 = Color3.fromRGB(15, 10, 35)
LoadingCenter.BackgroundTransparency = 0.1
LoadingCenter.BorderSizePixel = 0

local Corner = Instance.new("UICorner")
Corner.Parent = LoadingCenter
Corner.CornerRadius = UDim.new(0, 20)

local Gradient = Instance.new("UIGradient")
Gradient.Parent = LoadingCenter
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 0, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 0, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 200, 255))
})
Gradient.Rotation = 45

local TitleLoad = Instance.new("TextLabel")
TitleLoad.Parent = LoadingCenter
TitleLoad.Size = UDim2.new(1, 0, 0, 50)
TitleLoad.Position = UDim2.new(0, 0, 0, 20)
TitleLoad.BackgroundTransparency = 1
TitleLoad.Text = "⚡ GOOD MM2 ⚡"
TitleLoad.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLoad.TextScaled = true
TitleLoad.Font = Enum.Font.GothamBold

local SubTitle = Instance.new("TextLabel")
SubTitle.Parent = LoadingCenter
SubTitle.Size = UDim2.new(1, 0, 0, 30)
SubTitle.Position = UDim2.new(0, 0, 0, 75)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "ЗАГРУЗКА..."
SubTitle.TextColor3 = Color3.fromRGB(180, 160, 220)
SubTitle.TextSize = 18
SubTitle.Font = Enum.Font.GothamSemibold
SubTitle.TextScaled = false

-- Полоса загрузки (фон)
local BarBg = Instance.new("Frame")
BarBg.Parent = LoadingCenter
BarBg.Size = UDim2.new(0.8, 0, 0, 16)
BarBg.Position = UDim2.new(0.1, 0, 0, 120)
BarBg.BackgroundColor3 = Color3.fromRGB(30, 20, 50)
BarBg.BorderSizePixel = 0

local CornerBar = Instance.new("UICorner")
CornerBar.Parent = BarBg
CornerBar.CornerRadius = UDim.new(0, 12)

-- Полоса загрузки (заполнение)
local BarFill = Instance.new("Frame")
BarFill.Parent = BarBg
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(120, 0, 255)
BarFill.BorderSizePixel = 0

local CornerFill = Instance.new("UICorner")
CornerFill.Parent = BarFill
CornerFill.CornerRadius = UDim.new(0, 12)

local GradientFill = Instance.new("UIGradient")
GradientFill.Parent = BarFill
GradientFill.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 0, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 200, 255))
})
GradientFill.Rotation = 90

-- Процент загрузки
local PercentLabel = Instance.new("TextLabel")
PercentLabel.Parent = LoadingCenter
PercentLabel.Size = UDim2.new(1, 0, 0, 30)
PercentLabel.Position = UDim2.new(0, 0, 0, 145)
PercentLabel.BackgroundTransparency = 1
PercentLabel.Text = "0%"
PercentLabel.TextColor3 = Color3.fromRGB(200, 180, 255)
PercentLabel.TextSize = 16
PercentLabel.Font = Enum.Font.GothamBold
PercentLabel.TextScaled = false

-- Функция обновления загрузки
local function updateLoading(progress, text)
    progress = math.clamp(progress, 0, 1)
    local size = progress * 100
    BarFill.Size = UDim2.new(progress, 0, 1, 0)
    PercentLabel.Text = math.floor(size) .. "%"
    if text then
        SubTitle.Text = text
    end
end

-- СИМУЛЯЦИЯ ЗАГРУЗКИ (в реальном скрипте здесь будет загрузка модулей)
local function loadScript()
    local steps = {
        {p = 0.05, text = "Инициализация..."},
        {p = 0.15, text = "Загрузка UI..."},
        {p = 0.30, text = "Настройка ESP..."},
        {p = 0.45, text = "Калибровка Aim..."},
        {p = 0.60, text: "Активация Fling..."},
        {p = 0.75, text = "Настройка AutoFarm..."},
        {p = 0.90, text = "Финализация..."},
        {p = 1.00, text = "ГОТОВО!"}
    }

    for _, step in ipairs(steps) do
        updateLoading(step.p, step.text)
        wait(0.3 + math.random() * 0.2)
    end

    -- Плавное исчезновение загрузочного экрана
    local tween = TweenService:Create(LoadingFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 1
    })
    tween:Play()
    tween.Completed:Connect(function()
        LoadingGui:Destroy()
    end)
    wait(0.6)
    
    -- Создаём основной интерфейс
    createMainUI()
end

-- =============================================
-- 2. ОСНОВНОЙ ИНТЕРФЕЙС
-- =============================================
local ScreenGui = nil
local MainFrame = nil
local menuVisible = true

function createMainUI()
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game.CoreGui
    ScreenGui.Name = "GoodHub"
    ScreenGui.ResetOnSpawn = false

    MainFrame = Instance.new("Frame")
    MainFrame.Parent = ScreenGui
    MainFrame.Size = UDim2.new(0, 420, 0, 520)
    MainFrame.Position = UDim2.new(0.5, -210, 0.5, -260)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 5, 30)
    MainFrame.BackgroundTransparency = 0.15
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

    -- Кнопка закрытия меню (свернуть)
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Parent = MainFrame
    ToggleBtn.Size = UDim2.new(0, 36, 0, 36)
    ToggleBtn.Position = UDim2.new(1, -46, 0, 8)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 30, 80)
    ToggleBtn.Text = "—"
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.TextSize = 24
    ToggleBtn.Font = Enum.Font.GothamBold
    local cornerToggle = Instance.new("UICorner")
    cornerToggle.Parent = ToggleBtn
    cornerToggle.CornerRadius = UDim.new(0, 10)
    ToggleBtn.MouseButton1Click:Connect(function()
        toggleMenu()
    end)

    -- Кнопка закрытия (полное удаление)
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Parent = MainFrame
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -12, 0, 8)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 50)
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.TextSize = 18
    CloseBtn.Font = Enum.Font.GothamBold
    local cornerClose = Instance.new("UICorner")
    cornerClose.Parent = CloseBtn
    cornerClose.CornerRadius = UDim.new(0, 10)
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
        menuVisible = false
    end)

    -- Заголовок
    local Title = Instance.new("TextLabel")
    Title.Parent = MainFrame
    Title.Size = UDim2.new(1, -100, 0, 40)
    Title.Position = UDim2.new(0, 10, 0, 8)
    Title.BackgroundTransparency = 1
    Title.Text = "⚡ GOOD MM2 ⚡"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 22
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- Toggles
    local toggles = {
        ESP = false,
        Aim = false,
        Fling = false,
        AutoFarm = false
    }

    local function createToggle(name, yPos, color)
        local btn = Instance.new("TextButton")
        btn.Parent = MainFrame
        btn.Size = UDim2.new(0.8, 0, 0, 40)
        btn.Position = UDim2.new(0.1, 0, 0, yPos)
        btn.BackgroundColor3 = color or Color3.fromRGB(30, 10, 60)
        btn.BackgroundTransparency = 0.3
        btn.Text = name .. ": OFF"
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextScaled = true
        btn.Font = Enum.Font.GothamSemibold
        local cornerBtn = Instance.new("UICorner")
        cornerBtn.Parent = btn
        cornerBtn.CornerRadius = UDim.new(0, 12)
        local glow = Instance.new("UIStroke")
        glow.Parent = btn
        glow.Color = Color3.fromRGB(150, 0, 255)
        glow.Thickness = 1.5
        btn.MouseButton1Click:Connect(function()
            local key = name:gsub(" ", "")
            toggles[key] = not toggles[key]
            btn.Text = name .. ": " .. (toggles[key] and "ON" or "OFF")
            btn.BackgroundColor3 = toggles[key] and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(30, 10, 60)
        end)
        return btn
    end

    createToggle("ESP", 80, Color3.fromRGB(40, 0, 80))
    createToggle("Aim", 140, Color3.fromRGB(40, 0, 80))
    createToggle("Fling", 200, Color3.fromRGB(40, 0, 80))
    createToggle("AutoFarm", 260, Color3.fromRGB(40, 0, 80))

    -- Кнопка "Показать меню" (появляется, если меню скрыто)
    local ShowBtn = Instance.new("TextButton")
    ShowBtn.Parent = ScreenGui
    ShowBtn.Size = UDim2.new(0, 120, 0, 40)
    ShowBtn.Position = UDim2.new(0.5, -60, 0.9, 0)
    ShowBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 200)
    ShowBtn.Text = "📂 ПОКАЗАТЬ"
    ShowBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ShowBtn.TextSize = 16
    ShowBtn.Font = Enum.Font.GothamBold
    ShowBtn.Visible = false
    local cornerShow = Instance.new("UICorner")
    cornerShow.Parent = ShowBtn
    cornerShow.CornerRadius = UDim.new(0, 14)
    ShowBtn.MouseButton1Click:Connect(function()
        menuVisible = true
        MainFrame.Visible = true
        ShowBtn.Visible = false
    end)

    -- Drag
    local dragging, dragInput, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

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
                bill.Size = UDim2.new(0, 100, 0, 40)
                bill.AlwaysOnTop = true
                local label = Instance.new("TextLabel")
                label.Parent = bill
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.Text = plr.Name .. "\n" .. (plr.Character:FindFirstChild("tool") and "🔪" or "🟢")
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

    -- AutoFarm Coins
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

    -- Функция скрытия/показа меню
    function toggleMenu()
        menuVisible = not menuVisible
        MainFrame.Visible = menuVisible
        ShowBtn.Visible = not menuVisible
    end

    -- Main loop
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

    print("[good] MM2 HUB загружен. Наслаждайся.")
end

-- =============================================
-- 3. ЗАПУСК
-- =============================================
-- Запускаем загрузку с анимацией
spawn(function()
    loadScript()
end)
