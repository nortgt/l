--// SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

game.StarterGui:SetCore("SendNotification", {
    Title = "Welcome to Hexagon",
    Text = "https://discord.gg/Q9R5FDapth, Join the official Discord server",
    Duration = 20,
})

local player = Players.LocalPlayer

pcall(function() player:WaitForChild("PlayerGui"):FindFirstChild("Hexagon"):Destroy() end)

-- 1. CREACIÓN DE GUI CON DISEÑO FLYGUI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local dragHandle = Instance.new("Frame")
local title = Instance.new("TextLabel")
local subtitle = Instance.new("TextLabel")
local closebutton = Instance.new("TextButton")
local mini = Instance.new("TextButton")
local mini2 = Instance.new("TextButton")

-- Elementos de UI
local Scroll = Instance.new("ScrollingFrame")
local Layout = Instance.new("UIListLayout")
local MiniBtn = Instance.new("ImageButton")

-- Main GUI
ScreenGui.Name = "Hexagon"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- Main Frame
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.Size = UDim2.new(0, 280, 0, 320)
MainFrame.Active = true
MainFrame.ClipsDescendants = true

-- Add rounded corners
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = MainFrame

-- RGB Stroke (animado)
local RGBStroke = Instance.new("UIStroke")
RGBStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
RGBStroke.Thickness = 2
RGBStroke.Parent = MainFrame

-- Drag Handle
dragHandle.Name = "DragHandle"
dragHandle.Parent = MainFrame
dragHandle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
dragHandle.BorderSizePixel = 0
dragHandle.Size = UDim2.new(1, 0, 0, 40)
dragHandle.ZIndex = 2

-- Drag handle corners
local dragCorner = Instance.new("UICorner")
dragCorner.CornerRadius = UDim.new(0, 12)
dragCorner.Parent = dragHandle

-- Title
title.Name = "Title"
title.Parent = dragHandle
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 15, 0, 8)
title.Size = UDim2.new(0, 150, 0, 16)
title.Font = Enum.Font.GothamBold
title.Text = "HEXAGON HUB"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left

-- Subtitle
subtitle.Name = "Subtitle"
subtitle.Parent = dragHandle
subtitle.BackgroundTransparency = 1
subtitle.Position = UDim2.new(0, 15, 0, 24)
subtitle.Size = UDim2.new(0, 150, 0, 12)
subtitle.Font = Enum.Font.Gotham
subtitle.Text = "by Roun95"
subtitle.TextColor3 = Color3.fromRGB(150, 150, 150)
subtitle.TextSize = 10
subtitle.TextXAlignment = Enum.TextXAlignment.Left

-- Close Button
closebutton.Name = "Close"
closebutton.Parent = dragHandle
closebutton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closebutton.BackgroundTransparency = 0.8
closebutton.Position = UDim2.new(1, -35, 0, 8)
closebutton.Size = UDim2.new(0, 26, 0, 26)
closebutton.Font = Enum.Font.GothamBold
closebutton.Text = "X"
closebutton.TextColor3 = Color3.fromRGB(255, 255, 255)
closebutton.TextSize = 16
closebutton.ZIndex = 3

-- Close button corner
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closebutton

-- Minimize Button
mini.Name = "minimize"
mini.Parent = dragHandle
mini.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
mini.BackgroundTransparency = 0.8
mini.Position = UDim2.new(1, -70, 0, 8)
mini.Size = UDim2.new(0, 26, 0, 26)
mini.Font = Enum.Font.GothamBold
mini.Text = "-"
mini.TextColor3 = Color3.fromRGB(255, 255, 255)
mini.TextSize = 20
mini.ZIndex = 3

-- Minimize button corner
local miniCorner = Instance.new("UICorner")
miniCorner.CornerRadius = UDim.new(0, 8)
miniCorner.Parent = mini

-- Restore Button (initially hidden)
mini2.Name = "minimize2"
mini2.Parent = dragHandle
mini2.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
mini2.BackgroundTransparency = 0.8
mini2.Position = UDim2.new(1, -70, 0, 8)
mini2.Size = UDim2.new(0, 26, 0, 26)
mini2.Font = Enum.Font.GothamBold
mini2.Text = "+"
mini2.TextColor3 = Color3.fromRGB(255, 255, 255)
mini2.TextSize = 16
mini2.Visible = false
mini2.ZIndex = 3

-- Restore button corner
local mini2Corner = Instance.new("UICorner")
mini2Corner.CornerRadius = UDim.new(0, 8)
mini2Corner.Parent = mini2

-- SCROLLING FRAME (contenido)
Scroll.Parent = MainFrame
Scroll.Size = UDim2.new(1, -20, 1, -55)
Scroll.Position = UDim2.new(0, 10, 0, 45)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.ScrollBarThickness = 4
Scroll.BackgroundTransparency = 1
Scroll.ScrollingDirection = Enum.ScrollingDirection.Y
Scroll.BorderSizePixel = 0

-- Scroll bar styling
Scroll.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
Scroll.ScrollBarImageTransparency = 0.5

-- Layout
Layout.Parent = Scroll
Layout.Padding = UDim.new(0, 8)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- MINIMIZED FLOATING BUTTON
MiniBtn.Parent = ScreenGui
MiniBtn.Size = UDim2.new(0, 50, 0, 50)
MiniBtn.Position = UDim2.new(0.1, 0, 0.6, 0)
MiniBtn.Image = "rbxassetid://108946066610871"
MiniBtn.ImageTransparency = 0.2
MiniBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MiniBtn.BackgroundTransparency = 0.2
MiniBtn.Visible = false
MiniBtn.Active = true
MiniBtn.Draggable = true
MiniBtn.ZIndex = 10

-- Mini button corner
local miniBtnCorner = Instance.new("UICorner")
miniBtnCorner.CornerRadius = UDim.new(0, 12)
miniBtnCorner.Parent = MiniBtn

-- RGB Stroke for minimized button
local MiniStroke = Instance.new("UIStroke")
MiniStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MiniStroke.Thickness = 2
MiniStroke.Parent = MiniBtn

-- RGB Animation
task.spawn(function()
    while true do
        for i = 0, 1, 0.01 do
            RGBStroke.Color = Color3.fromHSV(i, 1, 1)
            MiniStroke.Color = Color3.fromHSV(i, 1, 1)
            task.wait(0.05)
        end
    end
end)

-- Update scroll size
Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Scroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 20)
end)

-- 2. LÓGICA DE INTERFAZ (Arrastrar y minimizar)
local minimized, dragging, dragInput, dragStart, startPos = false, false, nil, nil, nil

local function update(input)
    if not dragging then return end
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

local function startDrag(input)
    dragging = true
    dragStart = input.Position
    startPos = MainFrame.Position
    
    input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then
            dragging = false
        end
    end)
end

for _, element in pairs({dragHandle, title, subtitle}) do
    element.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            startDrag(input)
        end
    end)
end

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        update(input)
    end
end)

dragHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

-- Minimizar
mini.MouseButton1Click:Connect(function()
    minimized = true
    Scroll.Visible = false
    mini.Visible = false
    mini2.Visible = true
    MiniBtn.Visible = true
    MainFrame:TweenSize(UDim2.new(0, 280, 0, 40), "Out", "Quad", 0.3, true)
    MainFrame.BackgroundTransparency = 0.3
    RGBStroke.Thickness = 1
end)

mini2.MouseButton1Click:Connect(function()
    minimized = false
    Scroll.Visible = true
    mini.Visible = true
    mini2.Visible = false
    MiniBtn.Visible = false
    MainFrame:TweenSize(UDim2.new(0, 280, 0, 320), "Out", "Quad", 0.3, true)
    MainFrame.BackgroundTransparency = 0
    RGBStroke.Thickness = 2
end)

MiniBtn.MouseButton1Click:Connect(function()
    minimized = false
    Scroll.Visible = true
    mini.Visible = true
    mini2.Visible = false
    MiniBtn.Visible = false
    MainFrame:TweenSize(UDim2.new(0, 280, 0, 320), "Out", "Quad", 0.3, true)
    MainFrame.BackgroundTransparency = 0
    RGBStroke.Thickness = 2
end)

closebutton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

--/// UI CREATOR FUNCTIONS (con estilo mejorado)

local function Button(text)
    local b = Instance.new("TextButton")
    b.Parent = Scroll
    b.Size = UDim2.new(1, -10, 0, 45)
    b.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.Text = text
    b.AutoButtonColor = false
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = b

    -- Hover effect
    b.MouseEnter:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.15), {
            Size = UDim2.new(1, -5, 0, 48),
            BackgroundColor3 = Color3.fromRGB(65, 65, 65)
        }):Play()
    end)

    b.MouseLeave:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.15), {
            Size = UDim2.new(1, -10, 0, 45),
            BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        }):Play()
    end)

    return b
end

local function Toggle(text)
    local frame = Instance.new("Frame")
    frame.Parent = Scroll
    frame.Size = UDim2.new(1, -10, 0, 45)
    frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 8)
    frameCorner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text .. ": OFF"
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left

    local t = Instance.new("TextButton")
    t.Parent = frame
    t.AnchorPoint = Vector2.new(1, 0.5)
    t.Position = UDim2.new(0.95, 0, 0.5, 0)
    t.Size = UDim2.new(0, 50, 0, 28)
    t.Text = ""
    t.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    t.AutoButtonColor = false
    t.ZIndex = 2
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = t

    local c = Instance.new("Frame")
    c.Parent = t
    c.Size = UDim2.new(0, 22, 0, 22)
    c.Position = UDim2.new(0, 3, 0.5, 0)
    c.AnchorPoint = Vector2.new(0, 0.5)
    c.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    c.ZIndex = 3
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = c

    return frame, label, t, c
end

--/// ADD BUTTONS
local NoclipFrame, NoclipLabel, NoclipToggle, NoclipCircle = Toggle("Noclip")
local FPFrame, FPLabel, FPToggle, FPCircle = Toggle("Floating Platform")
local InfJFrame, InfJLabel, InfJToggle, InfJCircle = Toggle("Infinite Jump")
local BFFrame, BFLabel, BFToggle, BFCircle = Toggle("Bubble Float")

local SaveP = Button("Save Position")
local TpPosition = Button("TP Position")
local FpsBooster = Button("FPS Booster")

--/// FEATURES (código original intacto)

-- // Noclip
local noclipOn = false
NoclipToggle.MouseButton1Click:Connect(function()
    noclipOn = not noclipOn
    NoclipLabel.Text = "Noclip: " .. (noclipOn and "ON" or "OFF")
    local targetPos = noclipOn and UDim2.new(1, -27, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
    local targetColor = noclipOn and Color3.fromRGB(60, 180, 60) or Color3.fromRGB(70, 70, 70)
    TweenService:Create(NoclipCircle, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos}):Play()
    TweenService:Create(NoclipToggle, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = targetColor}):Play()
end)

RunService.Stepped:Connect(function()
    if noclipOn and player.Character then
        for _, v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

-- // Floating Platform
local platformEnabled = false
local platform = nil
local updateConn = nil
local humanoidRootPart

local function onCharacterAdded(character)
    humanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)
    if platformEnabled and humanoidRootPart and not platform then
        createPlatform()
    end
end

if player.Character then
    onCharacterAdded(player.Character)
end
player.CharacterAdded:Connect(onCharacterAdded)

local function createPlatform()
    if platform then return end
    platform = Instance.new("Part")
    platform.Name = "FloatingPlatform_" .. player.Name
    platform.Size = Vector3.new(6, 1, 6)
    platform.Anchored = true
    platform.Material = Enum.Material.Neon
    platform.Transparency = 0.3
    platform.Color = Color3.fromRGB(45, 45, 45)
    platform.CanCollide = true
    platform.TopSurface = Enum.SurfaceType.Smooth
    platform.BottomSurface = Enum.SurfaceType.Smooth
    platform.Parent = workspace

    if updateConn then updateConn:Disconnect() end
    updateConn = RunService.RenderStepped:Connect(function()
        if not platform or not platformEnabled or not humanoidRootPart then return end
        local targetPos = humanoidRootPart.Position - Vector3.new(0, 3, 0)
        platform.Position = platform.Position:Lerp(targetPos, 0.35)
    end)
end

local function removePlatform()
    if updateConn then
        updateConn:Disconnect()
        updateConn = nil
    end
    if platform then
        platform:Destroy()
        platform = nil
    end
end

FPToggle.MouseButton1Click:Connect(function()
    platformEnabled = not platformEnabled

    if platformEnabled then
        if not humanoidRootPart and player.Character then
            humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
        end
        createPlatform()
    else
        removePlatform()
    end

    player.AncestryChanged:Connect(function()
        if not player:IsDescendantOf(game) then
            removePlatform()
        end
    end)

    FPLabel.Text = "Floating Platform: " .. (platformEnabled and "ON" or "OFF")
    local targetPos = platformEnabled and UDim2.new(1, -27, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
    local targetColor = platformEnabled and Color3.fromRGB(60, 180, 60) or Color3.fromRGB(70, 70, 70)
    TweenService:Create(FPCircle, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos}):Play()
    TweenService:Create(FPToggle, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = targetColor}):Play()
end)

-- Infinite Jump
local infJump = false

InfJToggle.MouseButton1Click:Connect(function()
    infJump = not infJump
    InfJLabel.Text = "Infinite Jump: " .. (infJump and "ON" or "OFF")
    local targetPos = infJump and UDim2.new(1, -27, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
    local targetColor = infJump and Color3.fromRGB(60, 180, 60) or Color3.fromRGB(70, 70, 70)
    TweenService:Create(InfJCircle, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos}):Play()
    TweenService:Create(InfJToggle, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = targetColor}):Play()
end)

UserInputService.JumpRequest:Connect(function()
    if infJump and player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- // Bubble Float
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

local toggled = false
local floatForce = nil
local gyro = nil
local particleEmitter = nil
local light = nil

BFToggle.MouseButton1Click:Connect(function()
    toggled = not toggled

    BFLabel.Text = "Bubble Float: " .. (toggled and "ON" or "OFF")
    local targetPos = toggled and UDim2.new(1, -27, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
    local targetColor = toggled and Color3.fromRGB(60, 180, 60) or Color3.fromRGB(70, 70, 70)
    TweenService:Create(BFCircle, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos}):Play()
    TweenService:Create(BFToggle, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = targetColor}):Play()

    if toggled then
        floatForce = Instance.new("BodyVelocity")
        floatForce.Velocity = Vector3.new(0, 2, 0)
        floatForce.MaxForce = Vector3.new(0, 4000, 0)
        floatForce.Parent = hrp

        gyro = Instance.new("BodyGyro")
        gyro.MaxTorque = Vector3.new(4000, 4000, 4000)
        gyro.P = 3000
        gyro.Parent = hrp

        light = Instance.new("PointLight")
        light.Brightness = 2
        light.Range = 12
        light.Color = Color3.fromRGB(255, 0, 0)
        light.Parent = hrp

        particleEmitter = Instance.new("ParticleEmitter")
        particleEmitter.Texture = "rbxassetid://241837157"
        particleEmitter.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
        particleEmitter.LightEmission = 0.7
        particleEmitter.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(1, 0)})
        particleEmitter.Rate = 25
        particleEmitter.Lifetime = NumberRange.new(1, 2)
        particleEmitter.Speed = NumberRange.new(0, 1)
        particleEmitter.SpreadAngle = Vector2.new(360, 360)
        particleEmitter.Parent = hrp

        task.spawn(function()
            local angle = 0
            while toggled and floatForce and gyro do
                angle += 1
                floatForce.Velocity = Vector3.new(0, math.sin(angle / 10) * 2, 0)
                gyro.CFrame = gyro.CFrame * CFrame.Angles(0, math.rad(1), 0)
                light.Color = Color3.fromHSV((tick() % 5) / 5, 1, 1)
                task.wait(0.05)
            end
        end)
    else
        if floatForce then floatForce:Destroy() floatForce = nil end
        if gyro then gyro:Destroy() gyro = nil end
        if particleEmitter then particleEmitter.Enabled = false particleEmitter:Destroy() particleEmitter = nil end
        if light then light:Destroy() light = nil end
    end
end)

-- // Teleport Player
local savedPos = nil
local moving = false

local function smoothMove(targetPos)
    if moving == true then return end
    moving = true

    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")

    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(400000, 400000, 400000)
    bv.Velocity = Vector3.zero
    bv.Parent = hrp

    while moving and (hrp.Position - targetPos).Magnitude > 3 do
        local direction = (targetPos - hrp.Position).Unit
        bv.Velocity = direction * 20
        task.wait()
    end

    bv.Velocity = Vector3.zero
    task.wait(0.15)
    bv:Destroy()
    moving = false
end

SaveP.MouseButton1Click:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        savedPos = char.HumanoidRootPart.Position
        SaveP.Text = "✓ Saved!"
        task.wait(0.8)
        SaveP.Text = "Save Position"
    end
end)

TpPosition.MouseButton1Click:Connect(function()
    if savedPos then
        smoothMove(savedPos)
    else
        TpPosition.Text = "✗ No saved pos!"
        task.wait(0.8)
        TpPosition.Text = "TP Position"
    end
end)

-- FPS Booster (código original)
FpsBooster.MouseButton1Click:Connect(function()
    local decalsyeeted = true
    local g = game
    local w = g.Workspace
    local l = g.Lighting
    local t = w.Terrain
    t.WaterWaveSize = 0
    t.WaterWaveSpeed = 0
    t.WaterReflectance = 0
    t.WaterTransparency = 1
    l.GlobalShadows = false
    l.Brightness = 0
    l.FogEnd = 9e9
    l.FogStart = 9e9
    settings().Rendering.QualityLevel = "Level01"
    settings().Rendering.ReloadAssets = false
    for i, v in pairs(g:GetDescendants()) do
        if v:IsA("Part") or v:IsA("Union") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then 
            v.Material = "Plastic"
            v.Reflectance = 0
            v.BackSurface = "SmoothNoOutlines"
            v.BottomSurface = "SmoothNoOutlines"
            v.FrontSurface = "SmoothNoOutlines"
            v.LeftSurface = "SmoothNoOutlines"
            v.RightSurface = "SmoothNoOutlines"
            v.TopSurface = "SmoothNoOutlines"
        elseif v:IsA("Decal") or v:IsA("Texture") and decalsyeeted then
            v.Transparency = 1
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Lifetime = NumberRange.new(0)
        elseif v:IsA("Explosion") then
            v.BlastPressure = 1
            v.BlastRadius = 1
        elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") or v:IsA("Beam") then
            v.Enabled = false
        elseif v:IsA("MeshPart") then
            v.Material = "Plastic"
            v.Reflectance = 0
        end
    end
    for i, e in pairs(l:GetChildren()) do
        if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") or e:IsA("PostEffect") then
            e.Enabled = false
        end
    end
    w.DescendantAdded:Connect(function(child)
        task.spawn(function()
            if child:IsA('ForceField') or child:IsA('Sparkles') or child:IsA('Smoke') or child:IsA('Fire') or child:IsA('Beam') then
                RunService.Heartbeat:Wait()
                child:Destroy()
            end
        end)
    end)
    
    FpsBooster.Text = "✓ FPS Boosted!"
    task.wait(1)
    FpsBooster.Text = "FPS Booster"
end)