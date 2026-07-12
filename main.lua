-- ============================================
-- [SPIN FLING SYSTEM] - ИСПРАВЛЕННАЯ ВЕРСИЯ
-- ============================================
local FlingActive = false

local function SpinFling(targetPlayer)
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
    print("[Fling] Phase 1: Saved position")
    
    -- ФАЗА 2: Отключаем коллизии у себя
    print("[Fling] Phase 2: Disabling collisions...")
    local myParts = {}
    for _, part in ipairs(myChar:GetDescendants()) do
        if part:IsA("BasePart") then
            myParts[part] = part.CanCollide
            part.CanCollide = false
        end
    end
    
    -- ФАЗА 3: Телепорт ОЧЕНЬ ВЫСОКО В ВОЗДУХ
    print("[Fling] Phase 3: Teleporting UP to " .. Config.Fling.LaunchHeight .. " studs...")
    myHRP.CFrame = originalPosition + Vector3.new(0, Config.Fling.LaunchHeight, 0)
    myHum.PlatformStand = true
    
    myHRP.AssemblyLinearVelocity = Vector3.zero
    myHRP.AssemblyAngularVelocity = Vector3.zero
    task.wait(0.1)
    
    -- ФАЗА 4: Телепорт жертвы к себе
    print("[Fling] Phase 4: Teleporting target to me...")
    targetHRP.CFrame = myHRP.CFrame * CFrame.new(0, 0, -2)
    targetHum.PlatformStand = true
    targetHRP.AssemblyLinearVelocity = Vector3.zero
    targetHRP.AssemblyAngularVelocity = Vector3.zero
    task.wait(0.05)
    
    -- ФАЗА 5: Создаём BodyAngularVelocity для ЖЁСТКОГО ВРАЩЕНИЯ
    print("[Fling] Phase 5: Starting SPIN...")
    local bav = Instance.new("BodyAngularVelocity")
    bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bav.P = 100000
    
    local spinVector
    if Config.Fling.SpinAxis == "X" then
        spinVector = Vector3.new(Config.Fling.SpinSpeed, 0, 0)
    elseif Config.Fling.SpinAxis == "Z" then
        spinVector = Vector3.new(0, 0, Config.Fling.SpinSpeed)
    elseif Config.Fling.SpinAxis == "ALL" then
        spinVector = Vector3.new(Config.Fling.SpinSpeed, Config.Fling.SpinSpeed, Config.Fling.SpinSpeed)
    else
        spinVector = Vector3.new(0, Config.Fling.SpinSpeed, 0)
    end
    
    bav.AngularVelocity = spinVector
    bav.Parent = myHRP
    
    -- ФАЗА 6: ВРАЩАЕМСЯ 1 СЕКУНДУ
    print("[Fling] Phase 6: Spinning for " .. Config.Fling.SpinDuration .. "s...")
    local startTime = tick()
    while tick() - startTime < Config.Fling.SpinDuration do
        if not myHRP or not myHRP.Parent then break end
        
        if targetHRP and targetHRP.Parent then
            targetHRP.CFrame = myHRP.CFrame * CFrame.new(0, 0, -2)
        end
        
        bav.AngularVelocity = spinVector
        
        task.wait()
    end
    
    -- ФАЗА 7: ОСТАНОВКА ВРАЩЕНИЯ + МОЩНЫЙ ИМПУЛЬС ЖЕРТВЕ
    print("[Fling] Phase 7: Stopping spin and launching target...")
    bav:Destroy()
    
    -- Сбрасываем скорости у себя
    myHRP.AssemblyLinearVelocity = Vector3.zero
    myHRP.AssemblyAngularVelocity = Vector3.zero
    
    -- СОЗДАЁМ МОЩНЫЙ IMPULSE ДЛЯ ЖЕРТВЫ
    if targetHRP and targetHRP.Parent then
        -- Случайное направление отбрасывания (горизонтальное)
        local randomAngle = math.random() * math.pi * 2
        local launchDirection = Vector3.new(
            math.cos(randomAngle),
            0.5,  -- Немного вверх
            math.sin(randomAngle)
        ).Unit
        
        -- Огромная сила отбрасывания
        local launchPower = 100000
        local launchVelocity = launchDirection * launchPower
        
        -- Применяем импульс через AssemblyLinearVelocity (мгновенно)
        targetHRP.AssemblyLinearVelocity = launchVelocity
        targetHRP.AssemblyAngularVelocity = Vector3.new(
            math.random(-100, 100),
            math.random(-100, 100),
            math.random(-100, 100)
        )
        
        -- Дополнительно создаём BodyVelocity для удержания силы
        local targetBV = Instance.new("BodyVelocity")
        targetBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        targetBV.P = 125000
        targetBV.Velocity = launchVelocity
        targetBV.Parent = targetHRP
        
        -- Держим силу 0.5 секунды
        task.wait(0.5)
        targetBV:Destroy()
        
        -- Отключаем PlatformStand у жертвы (чтобы она могла умереть от падения)
        targetHum.PlatformStand = false
    end
    
    task.wait(0.1)
    
    -- ФАЗА 8: ВОЗВРАТ НА ИСХОДНУЮ ПОЗИЦИЮ
    print("[Fling] Phase 8: Returning to original position...")
    myHRP.CFrame = originalPosition
    myHRP.AssemblyLinearVelocity = Vector3.zero
    myHRP.AssemblyAngularVelocity = Vector3.zero
    
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
    print("[Fling] COMPLETE! Target launched far away!")
    print("[Fling] ========================================")
    return true
end
