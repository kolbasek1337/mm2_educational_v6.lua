-- MM2 ULTIMATE HUB [good]
-- Created by goodlooking team
-- Полный рабочий скрипт для Murder Mystery 2

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "GoodHub"

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 420, 0, 520)
Frame.Position = UDim2.new(0.5, -210, 0.5, -260)
Frame.BackgroundColor3 = Color3.fromRGB(15, 5, 30)
Frame.BackgroundTransparency = 0.15
Frame.BorderSizePixel = 0
Frame.ClipsDescendants = true

local Corner = Instance.new("UICorner")
Corner.Parent = Frame
Corner.CornerRadius = UDim.new(0, 16)

local Gradient = Instance.new("UIGradient")
Gradient.Parent = Frame
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 0, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 0, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 200, 255))
})
Gradient.Rotation = 45

local Title = Instance.new("TextLabel")
Title.Parent = Frame
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Position = UDim2.new(0, 0, 0, 10)
Title.BackgroundTransparency = 1
Title.Text = "⚡ GOOD MM2 ⚡"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold

-- Toggles
local toggles = {
    ESP = false,
    Aim = false,
    Fling = false,
    AutoFarm = false
}

local function createToggle(name, yPos, color)
    local btn = Instance.new("TextButton")
    btn.Parent = Frame
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

-- Close button
local Close = Instance.new("TextButton")
Close.Parent = Frame
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -40, 0, 10)
Close.BackgroundColor3 = Color3.fromRGB(200, 0, 50)
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.TextScaled = true
Close.Font = Enum.Font.GothamBold
local cornerClose = Instance.new("UICorner")
cornerClose.Parent = Close
cornerClose.CornerRadius = UDim.new(0, 8)
Close.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Drag
local dragging, dragInput, dragStart, startPos
Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
Frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
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

-- Aim (автонаводка на убийцу с оружием)
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

-- AutoFarm Coins (сбор монет по карте)
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

-- Main loop
RunService.Heartbeat:Connect(function()
    updateESP()
    aimAssist()
    farmCoins()
end)

-- AutoFarm coins каждые 0.2 сек дополнительно для скорости
spawn(function()
    while wait(0.2) do
        if toggles.AutoFarm then
            farmCoins()
        end
    end
end)

-- Первый запуск ESP
wait(0.5)
updateESP()

print("[good] MM2 HUB загружен. Наслаждайся.")
