--[[
    SWILL RAGE BOT V3
    Полный функционал: RageBot + Silent Aim + Visuals + AntiAim
    Меню с прокруткой | Работает на Xeno Executor 2026
--]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local Camera = workspace.CurrentCamera

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- ========== НАСТРОЙКИ ==========
local Settings = {
    Rage = {
        Enabled = false,
        Hitchance = 85,
        Multipoints = true,
        Autostop = false,
        Autoscope = false,
        Autoreload = false
    },
    Visuals = {
        Tracer = false,
        TracerColor = Color3.fromRGB(255, 0, 0),
        Snow = false,
        SnowAmount = 200,
        SnowRadius = 50,
        WorldModulation = false,
        WorldColor = Color3.fromRGB(255, 255, 255),
        Fog = false,
        FogColor = Color3.fromRGB(128, 128, 128),
        ClockTime = 12,
        MapReflectance = 0,
        NoScopeEffects = false,
        JumpCircles = false,
        Crosshair = false
    },
    AntiAim = {
        Enabled = false,
        Pitch = 90,
        YawType = "Jitter",
        Yaw = 180,
        Jitter = true,
        JitterRange = 45
    },
    Movement = {
        Airstrafe = false,
        LegSlide = false
    }
}

-- ========== UI БИБЛИОТЕКА (С ПРОКРУТКОЙ) ==========
local Library = {
    ScreenGui = nil,
    MainFrame = nil,
    ScrollingFrame = nil
}

function Library:CreateUI()
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "SWILL_RageBot"
    self.ScreenGui.Parent = game:GetService("CoreGui")
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    if syn and syn.protect_gui then
        syn.protect_gui(self.ScreenGui)
    end
    
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Size = UDim2.new(0, 400, 0, 500)
    self.MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    self.MainFrame.BackgroundTransparency = 0.1
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.ClipsDescendants = true
    self.MainFrame.Active = true
    self.MainFrame.Draggable = true
    self.MainFrame.Parent = self.ScreenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = self.MainFrame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    title.Text = "SWILL RAGE BOT V3"
    title.TextColor3 = Color3.fromRGB(0, 255, 150)
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.Parent = self.MainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = title
    
    self.ScrollingFrame = Instance.new("ScrollingFrame")
    self.ScrollingFrame.Size = UDim2.new(1, 0, 1, -40)
    self.ScrollingFrame.Position = UDim2.new(0, 0, 0, 40)
    self.ScrollingFrame.BackgroundTransparency = 1
    self.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.ScrollingFrame.ScrollBarThickness = 6
    self.ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 150)
    self.ScrollingFrame.Parent = self.MainFrame
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = self.ScrollingFrame
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
    end)
    
    return self.ScrollingFrame
end

function Library:CreateSection(parent, text)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, -20, 0, 35)
    section.Position = UDim2.new(0, 10, 0, 0)
    section.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    section.BorderSizePixel = 0
    section.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = section
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(0, 255, 150)
    label.TextSize = 14
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.Parent = section
    
    return parent
end

function Library:CreateToggle(parent, text, settingPath, initialValue)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 35)
    frame.Position = UDim2.new(0, 10, 0, 0)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 50, 0, 25)
    button.Position = UDim2.new(1, -60, 0.5, -12.5)
    button.BackgroundColor3 = initialValue and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(80, 80, 100)
    button.Text = initialValue and "ON" or "OFF"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 12
    button.Font = Enum.Font.GothamBold
    button.BorderSizePixel = 0
    button.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = button
    
    local state = initialValue
    
    button.MouseButton1Click:Connect(function()
        state = not state
        button.BackgroundColor3 = state and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(80, 80, 100)
        button.Text = state and "ON" or "OFF"
        
        local parts = {}
        for part in string.gmatch(settingPath, "[^.]+") do
            table.insert(parts, part)
        end
        local current = Settings
        for i = 1, #parts - 1 do
            current = current[parts[i]]
        end
        current[parts[#parts]] = state
    end)
    
    return frame
end

function Library:CreateSlider(parent, text, settingPath, min, max, initialValue)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 55)
    frame.Position = UDim2.new(0, 10, 0, 0)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. initialValue
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 12
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(1, -20, 0, 4)
    slider.Position = UDim2.new(0, 10, 0, 30)
    slider.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    slider.BorderSizePixel = 0
    slider.Parent = frame
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(1, 0)
    sliderCorner.Parent = slider
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((initialValue - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
    fill.BorderSizePixel = 0
    fill.Parent = slider
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill
    
    local knob = Instance.new("TextButton")
    knob.Size = UDim2.new(0, 12, 0, 12)
    knob.Position = UDim2.new((initialValue - min) / (max - min), -6, 0.5, -6)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.Text = ""
    knob.BorderSizePixel = 0
    knob.Parent = slider
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob
    
    local value = initialValue
    local dragging = false
    
    knob.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relativeX = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
            value = math.floor(min + (max - min) * relativeX)
            fill.Size = UDim2.new(relativeX, 0, 1, 0)
            knob.Position = UDim2.new(relativeX, -6, 0.5, -6)
            label.Text = text .. ": " .. value
            
            local parts = {}
            for part in string.gmatch(settingPath, "[^.]+") do
                table.insert(parts, part)
            end
            local current = Settings
            for i = 1, #parts - 1 do
                current = current[parts[i]]
            end
            current[parts[#parts]] = value
        end
    end)
    
    return frame
end

function Library:CreateColorPicker(parent, text, settingPath, initialColor)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 35)
    frame.Position = UDim2.new(0, 10, 0, 0)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local colorBtn = Instance.new("TextButton")
    colorBtn.Size = UDim2.new(0, 40, 0, 25)
    colorBtn.Position = UDim2.new(1, -50, 0.5, -12.5)
    colorBtn.BackgroundColor3 = initialColor
    colorBtn.Text = ""
    colorBtn.BorderSizePixel = 0
    colorBtn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = colorBtn
    
    colorBtn.MouseButton1Click:Connect(function()
        local parts = {}
        for part in string.gmatch(settingPath, "[^.]+") do
            table.insert(parts, part)
        end
        local current = Settings
        for i = 1, #parts - 1 do
            current = current[parts[i]]
        end
        -- Упрощённый выбор цвета
        local colors = {
            Color3.fromRGB(255, 0, 0),
            Color3.fromRGB(0, 255, 0),
            Color3.fromRGB(0, 0, 255),
            Color3.fromRGB(255, 255, 0),
            Color3.fromRGB(255, 0, 255),
            Color3.fromRGB(0, 255, 255)
        }
        local newColor = colors[math.random(1, #colors)]
        colorBtn.BackgroundColor3 = newColor
        current[parts[#parts]] = newColor
    end)
    
    return frame
end

-- ========== СОЗДАНИЕ UI ==========
local container = Library:CreateUI()

-- RAGE вкладка
Library:CreateSection(container, "RAGE BOT")
Library:CreateToggle(container, "Ragebot", "Rage.Enabled", false)
Library:CreateSlider(container, "Hitchance (0-100)", "Rage.Hitchance", 0, 100, 85)
Library:CreateToggle(container, "Multipoints", "Rage.Multipoints", true)
Library:CreateToggle(container, "Autostop", "Rage.Autostop", false)
Library:CreateToggle(container, "Autoscope", "Rage.Autoscope", false)
Library:CreateToggle(container, "Autoreload", "Rage.Autoreload", false)

-- VISUALS вкладка
Library:CreateSection(container, "VISUALS")
Library:CreateToggle(container, "Tracer", "Visuals.Tracer", false)
Library:CreateColorPicker(container, "Tracer Color", "Visuals.TracerColor", Color3.fromRGB(255, 0, 0))
Library:CreateToggle(container, "Snow", "Visuals.Snow", false)
Library:CreateSlider(container, "Snow Amount", "Visuals.SnowAmount", 0, 500, 200)
Library:CreateSlider(container, "Snow Radius", "Visuals.SnowRadius", 0, 100, 50)
Library:CreateToggle(container, "World Modulation", "Visuals.WorldModulation", false)
Library:CreateColorPicker(container, "World Color", "Visuals.WorldColor", Color3.fromRGB(255, 255, 255))
Library:CreateToggle(container, "Fog", "Visuals.Fog", false)
Library:CreateColorPicker(container, "Fog Color", "Visuals.FogColor", Color3.fromRGB(128, 128, 128))
Library:CreateSlider(container, "Clock Time", "Visuals.ClockTime", 0, 24, 12)
Library:CreateSlider(container, "Map Reflectance", "Visuals.MapReflectance", 0, 1, 0)
Library:CreateToggle(container, "No Scope Effects", "Visuals.NoScopeEffects", false)
Library:CreateToggle(container, "Jump Circles", "Visuals.JumpCircles", false)
Library:CreateToggle(container, "Crosshair", "Visuals.Crosshair", false)

-- ANTI AIM вкладка
Library:CreateSection(container, "ANTI AIM")
Library:CreateToggle(container, "Enable AntiAim", "AntiAim.Enabled", false)
Library:CreateSlider(container, "Pitch (0-100)", "AntiAim.Pitch", 0, 100, 90)
Library:CreateSlider(container, "Yaw (0-100)", "AntiAim.Yaw", 0, 100, 180)
Library:CreateToggle(container, "Jitter", "AntiAim.Jitter", true)
Library:CreateSlider(container, "Jitter Range", "AntiAim.JitterRange", 0, 100, 45)

-- MOVEMENT вкладка
Library:CreateSection(container, "MOVEMENT")
Library:CreateToggle(container, "Airstrafe", "Movement.Airstrafe", false)
Library:CreateToggle(container, "Leg Slide", "Movement.LegSlide", false)

-- ========== RAGE BOT КОР (Silent Aim + Auto Shoot) ==========
local function GetClosestTarget()
    local closest = nil
    local closestDistance = math.huge
    
    for _, target in ipairs(Players:GetPlayers()) do
        if target ~= Player and target.Character and target.Character:FindFirstChild("Humanoid") and target.Character.Humanoid.Health > 0 then
            local targetPos = target.Character:FindFirstChild("HumanoidRootPart")
            if targetPos then
                local screenPos, onScreen = Camera:WorldToViewportPoint(targetPos.Position)
                if onScreen then
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        closest = target
                    end
                end
            end
        end
    end
    
    return closest
end

local function IsVisible(target)
    local origin = Camera.CFrame.Position
    local targetPart = target.Character:FindFirstChild("HumanoidRootPart")
    if not targetPart then return false end
    
    local ray = Ray.new(origin, (targetPart.Position - origin).Unit * (origin - targetPart.Position).Magnitude)
    local hit, position = Workspace:FindPartOnRay(ray, Player.Character)
    
    return hit and hit:IsDescendantOf(target.Character)
end

local function GetHitChance(target)
    local hitchance = Settings.Rage.Hitchance / 100
    local random = math.random()
    return random <= hitchance
end

RunService.RenderStepped:Connect(function()
    if Settings.Rage.Enabled then
        local target = GetClosestTarget()
        if target and GetHitChance(target) then
            local targetPart = target.Character:FindFirstChild("HumanoidRootPart")
            if targetPart then
                local targetPos = targetPart.Position
                if Settings.Rage.Multipoints then
                    local offsets = {
                        Vector3.new(0, 1, 0),
                        Vector3.new(0, -1, 0),
                        Vector3.new(0.5, 0.5, 0),
                        Vector3.new(-0.5, 0.5, 0)
                    }
                    targetPos = targetPos + offsets[math.random(1, #offsets)]
                end
                
                -- Silent Aim
                local targetScreen = Camera:WorldToViewportPoint(targetPos)
                mousemoverel(targetScreen.X - Mouse.X, targetScreen.Y - Mouse.Y)
                
                -- Auto Shoot
                if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                    local args = {
                        [1] = { [1] = targetPos }
                    }
                    game:GetService("ReplicatedStorage"):FindFirstChild("Shoot"):FireServer(unpack(args))
                end
            end
        end
    end
end)

-- ========== VISUALS ФУНКЦИИ ==========
local snowParts = {}

local function CreateSnow()
    for i = 1, Settings.Visuals.SnowAmount do
        local part = Instance.new("Part")
        part.Size = Vector3.new(0.2, 0.2, 0.2)
        part.BrickColor = BrickColor.new("White")
        part.Material = Enum.Material.Neon
        part.CFrame = CFrame.new(
            math.random(-Settings.Visuals.SnowRadius, Settings.Visuals.SnowRadius),
            math.random(0, 50),
            math.random(-Settings.Visuals.SnowRadius, Settings.Visuals.SnowRadius)
        )
        part.Parent = Workspace
        table.insert(snowParts, part)
        
        game:GetService("RunService").Heartbeat:Connect(function()
            if Settings.Visuals.Snow then
                part.CFrame = part.CFrame + Vector3.new(0, -0.1, 0)
                if part.Position.Y < 0 then
                    part.CFrame = CFrame.new(
                        math.random(-Settings.Visuals.SnowRadius, Settings.Visuals.SnowRadius),
                        50,
                        math.random(-Settings.Visuals.SnowRadius, Settings.Visuals.SnowRadius)
                    )
                end
            end
        end)
    end
end

local function UpdateVisuals()
    while wait(0.1) do
        if Settings.Visuals.WorldModulation then
            Lighting.ColorShift_Top = Settings.Visuals.WorldColor
            Lighting.ColorShift_Bottom = Settings.Visuals.WorldColor
        else
            Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
            Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
        end
        
        if Settings.Visuals.Fog then
            Lighting.FogColor = Settings.Visuals.FogColor
            Lighting.FogEnd = 1000
        else
            Lighting.FogEnd = 100000
        end
        
        Lighting.ClockTime = Settings.Visuals.ClockTime
        Lighting.ExposureCompensation = Settings.Visuals.MapReflectance
        
        if Settings.Visuals.NoScopeEffects then
            local tool = Player.Character:FindFirstChildOfClass("Tool")
            if tool and tool:FindFirstChild("Scope") then
                tool.Scope:Destroy()
            end
        end
        
        if Settings.Visuals.Crosshair then
            if not Library.Crosshair then
                Library.Crosshair = Instance.new("Frame")
                Library.Crosshair.Size = UDim2.new(0, 5, 0, 5)
                Library.Crosshair.Position = UDim2.new(0.5, -2.5, 0.5, -2.5)
                Library.Crosshair.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                Library.Crosshair.Parent = Library.ScreenGui
            end
        else
            if Library.Crosshair then
                Library.Crosshair:Destroy()
                Library.Crosshair = nil
            end
        end
    end
end

local function JumpCircles()
    if Settings.Visuals.JumpCircles then
        local humanoid = Player.Character:WaitForChild("Humanoid")
        humanoid.Jumping:Connect(function()
            local circle = Instance.new("Part")
            circle.Size = Vector3.new(5, 0.2, 5)
            circle.CFrame = Player.Character.HumanoidRootPart.CFrame - Vector3.new(0, 2, 0)
            circle.BrickColor = BrickColor.new("Bright red")
            circle.Material = Enum.Material.Neon
            circle.Anchored = true
            circle.CanCollide = false
            circle.Parent = Workspace
            
            game:GetService("Debris"):AddItem(circle, 1)
        end)
    end
end

-- ========== ANTI AIM ==========
local function AntiAim()
    while wait() do
        if Settings.AntiAim.Enabled and Player.Character then
            local humanoid = Player.Character:FindFirstChild("Humanoid")
            if humanoid then
                if Settings.AntiAim.Jitter then
                    local jitterOffset = math.random(-Settings.AntiAim.JitterRange, Settings.AntiAim.JitterRange)
                    humanoid.AutoRotate = false
                    Player.Character.HumanoidRootPart.CFrame = CFrame.new(
                        Player.Character.HumanoidRootPart.Position
                    ) * CFrame.Angles(
                        math.rad(Settings.AntiAim.Pitch),
                        math.rad(Settings.AntiAim.Yaw + jitterOffset),
                        0
                    )
                else
                    humanoid.AutoRotate = false
                    Player.Character.HumanoidRootPart.CFrame = CFrame.new(
                        Player.Character.HumanoidRootPart.Position
                    ) * CFrame.Angles(
                        math.rad(Settings.AntiAim.Pitch),
                        math.rad(Settings.AntiAim.Yaw),
                        0
                    )
                end
            end
        end
    end
end

-- ========== MOVEMENT ФУНКЦИИ ==========
local function Airstrafe()
    local humanoid = Player.Character:WaitForChild("Humanoid")
    local lastVelocity = Vector3.new()
    
    game:GetService("RunService").RenderStepped:Connect(function()
        if Settings.Movement.Airstrafe and humanoid:GetState() == Enum.HumanoidStateType.Jumping then
            local cameraCFrame = workspace.CurrentCamera.CFrame
            local moveDirection = UserInputService:GetMoveVector()
            
            local velocity = (cameraCFrame.RightVector * moveDirection.X + cameraCFrame.LookVector * moveDirection.Y) * 50
            velocity = Vector3.new(velocity.X, lastVelocity.Y, velocity.Z)
            
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            Player.Character.HumanoidRootPart.Velocity = velocity
            lastVelocity = velocity
        end
    end)
end

local function LegSlide()
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if Settings.Movement.LegSlide and input.KeyCode == Enum.KeyCode.LeftControl then
            local humanoid = Player.Character:WaitForChild("Humanoid")
            humanoid.WalkSpeed = 50
            wait(0.5)
            humanoid.WalkSpeed = 16
        end
    end)
end

-- ========== ЗАПУСК ==========
coroutine.wrap(CreateSnow)()
coroutine.wrap(UpdateVisuals)()
coroutine.wrap(JumpCircles)()
coroutine.wrap(AntiAim)()
coroutine.wrap(Airstrafe)()
coroutine.wrap(LegSlide)()

print("SWILL RAGE BOT V3 ЗАГРУЖЕН!")
print("Нажми Insert для показа/скрытия меню")
print("Функции: RageBot, Silent Aim, Visuals, AntiAim, Movement")

-- Горячая клавиша Insert
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.Insert then
        Library.ScreenGui.Enabled = not Library.ScreenGui.Enabled
    end
end)
