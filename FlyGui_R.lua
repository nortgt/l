local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- 1. CREACIÓN DE GUI CON DISEÑO FLYGUI
local main = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local dragHandle = Instance.new("Frame")
local title = Instance.new("TextLabel")
local closebutton = Instance.new("TextButton")
local mini = Instance.new("TextButton")
local mini2 = Instance.new("TextButton")

-- Elementos de control
local up = Instance.new("TextButton")
local down = Instance.new("TextButton")
local toggle = Instance.new("TextButton")
local plus = Instance.new("TextButton")
local minus = Instance.new("TextButton")
local speedLabel = Instance.new("TextLabel")

-- Main GUI
main.Name = "NovaFlyGUI"
main.Parent = LocalPlayer:WaitForChild("PlayerGui")
main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
main.ResetOnSpawn = false

-- Main Frame
Frame.Parent = main
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.1, 0, 0.1, 0)
Frame.Size = UDim2.new(0, 240, 0, 120)
Frame.Active = true

-- Add rounded corners
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = Frame

-- Add subtle drop shadow
local shadow = Instance.new("UIStroke")
shadow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
shadow.Color = Color3.fromRGB(60, 60, 60)
shadow.Thickness = 2
shadow.Transparency = 0.7
shadow.Parent = Frame

-- Drag Handle
dragHandle.Name = "DragHandle"
dragHandle.Parent = Frame
dragHandle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
dragHandle.BorderSizePixel = 0
dragHandle.Size = UDim2.new(1, 0, 0, 30)
dragHandle.ZIndex = 2

-- Drag handle corners
local dragCorner = Instance.new("UICorner")
dragCorner.CornerRadius = UDim.new(0, 8)
dragCorner.Parent = dragHandle

-- Title
title.Name = "Title"
title.Parent = dragHandle
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 10, 0, 0)
title.Size = UDim2.new(1, -10, 1, 0)
title.Font = Enum.Font.GothamBold
title.Text = "NOVA FLY"
title.TextColor3 = Color3.fromRGB(202, 178, 251)
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left

-- Close Button
closebutton.Name = "Close"
closebutton.Parent = dragHandle
closebutton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closebutton.BackgroundTransparency = 0.8
closebutton.Position = UDim2.new(1, -30, 0, 2)
closebutton.Size = UDim2.new(0, 26, 0, 26)
closebutton.Font = Enum.Font.GothamBold
closebutton.Text = "X"
closebutton.TextColor3 = Color3.fromRGB(255, 255, 255)
closebutton.TextSize = 16
closebutton.ZIndex = 3

-- Close button corner
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closebutton

-- Minimize Button
mini.Name = "minimize"
mini.Parent = dragHandle
mini.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
mini.BackgroundTransparency = 0.8
mini.Position = UDim2.new(1, -60, 0, 2)
mini.Size = UDim2.new(0, 26, 0, 26)
mini.Font = Enum.Font.GothamBold
mini.Text = "-"
mini.TextColor3 = Color3.fromRGB(255, 255, 255)
mini.TextSize = 20
mini.ZIndex = 3

-- Minimize button corner
local miniCorner = Instance.new("UICorner")
miniCorner.CornerRadius = UDim.new(0, 6)
miniCorner.Parent = mini

-- Restore Button (initially hidden)
mini2.Name = "minimize2"
mini2.Parent = dragHandle
mini2.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
mini2.BackgroundTransparency = 0.8
mini2.Position = UDim2.new(1, -60, 0, 2)
mini2.Size = UDim2.new(0, 26, 0, 26)
mini2.Font = Enum.Font.GothamBold
mini2.Text = "+"
mini2.TextColor3 = Color3.fromRGB(255, 255, 255)
mini2.TextSize = 16
mini2.Visible = false
mini2.ZIndex = 3

-- Restore button corner
local mini2Corner = Instance.new("UICorner")
mini2Corner.CornerRadius = UDim.new(0, 6)
mini2Corner.Parent = mini2

-- Función para crear botones con estilo
local function createStyledButton(parent, posX, posY, sizeX, sizeY, text, color, textSize)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.BackgroundColor3 = color
    btn.Position = UDim2.new(posX, 0, posY, 0)
    btn.Size = UDim2.new(0, sizeX, 0, sizeY)
    btn.Font = Enum.Font.Gotham
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.TextSize = textSize or 14
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    -- Hover effects
    local originalColor = color
    local hoverColor = Color3.fromRGB(
        math.min(color.R * 255 + 20, 255) / 255,
        math.min(color.G * 255 + 20, 255) / 255,
        math.min(color.B * 255 + 20, 255) / 255
    )
    
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = hoverColor
    end)
    
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = originalColor
    end)
    
    return btn
end

local function createStyledLabel(parent, posX, posY, sizeX, sizeY, text, bgColor)
    local lbl = Instance.new("TextLabel")
    lbl.Parent = parent
    lbl.BackgroundColor3 = bgColor
    lbl.Position = UDim2.new(posX, 0, posY, 0)
    lbl.Size = UDim2.new(0, sizeX, 0, sizeY)
    lbl.Font = Enum.Font.GothamBold
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
    lbl.TextSize = 14
    
    local lblCorner = Instance.new("UICorner")
    lblCorner.CornerRadius = UDim.new(0, 6)
    lblCorner.Parent = lbl
    
    return lbl
end

-- Crear botones con el nuevo diseño
up = createStyledButton(Frame, 0.05, 0.3, 50, 35, "↑", Color3.fromRGB(60, 60, 80), 20)
down = createStyledButton(Frame, 0.05, 0.65, 50, 35, "↓", Color3.fromRGB(60, 60, 80), 20)

plus = createStyledButton(Frame, 0.3, 0.3, 50, 35, "+", Color3.fromRGB(60, 80, 60), 20)
minus = createStyledButton(Frame, 0.3, 0.65, 50, 35, "-", Color3.fromRGB(80, 60, 60), 20)

toggle = createStyledButton(Frame, 0.55, 0.65, 100, 35, "FLY", Color3.fromRGB(80, 60, 60), 16)

speedLabel = createStyledLabel(Frame, 0.55, 0.3, 50, 35, "1", Color3.fromRGB(40, 40, 40))

-- 2. LÓGICA DE INTERFAZ (Arrastrar y minimizar)
local minimized, dragging, dragInput, dragStart, startPos = false, false, nil, nil, nil

local function update(input)
    if not dragging then return end
    local delta = input.Position - dragStart
    Frame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

local function startDrag(input)
    dragging = true
    dragStart = input.Position
    startPos = Frame.Position
    
    input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then
            dragging = false
        end
    end)
end

for _, element in pairs({dragHandle, title}) do
    element.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            startDrag(input)
        end
    end)
end

UIS.InputChanged:Connect(function(input)
    if input == dragInput and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        update(input)
    end
end)

dragHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

-- Minimizar/Restaurar
local uiElements = {up, down, toggle, plus, minus, speedLabel}

mini.MouseButton1Click:Connect(function()
    minimized = true
    for _, element in ipairs(uiElements) do
        element.Visible = false
    end
    mini.Visible = false
    mini2.Visible = true
    Frame:TweenSize(UDim2.new(0, 240, 0, 30), "Out", "Quad", 0.3, true)
    Frame.BackgroundTransparency = 0.5
end)

mini2.MouseButton1Click:Connect(function()
    minimized = false
    for _, element in ipairs(uiElements) do
        element.Visible = true
    end
    mini.Visible = true
    mini2.Visible = false
    Frame:TweenSize(UDim2.new(0, 240, 0, 120), "Out", "Quad", 0.3, true)
    Frame.BackgroundTransparency = 0
end)

closebutton.MouseButton1Click:Connect(function()
    main:Destroy()
    stopFly()
end)

-- 3. LÓGICA DE VUELO (sin cambios funcionales)
local speed, isFlying, tpWalking, flySpeed = 1, false, false, 0
local maxFlySpeed, lastSpeed = 50, 0
local flyControls = {f = 0, b = 0, l = 0, r = 0}
local lastControls = {f = 0, b = 0, l = 0, r = 0}

local function enableHumanoidStates(humanoid, enable)
    local states = {
        Enum.HumanoidStateType.Climbing, Enum.HumanoidStateType.FallingDown,
        Enum.HumanoidStateType.Flying, Enum.HumanoidStateType.Freefall,
        Enum.HumanoidStateType.GettingUp, Enum.HumanoidStateType.Jumping,
        Enum.HumanoidStateType.Landed, Enum.HumanoidStateType.Physics,
        Enum.HumanoidStateType.PlatformStanding, Enum.HumanoidStateType.Ragdoll,
        Enum.HumanoidStateType.Running, Enum.HumanoidStateType.RunningNoPhysics,
        Enum.HumanoidStateType.Seated, Enum.HumanoidStateType.StrafingNoPhysics,
        Enum.HumanoidStateType.Swimming
    }
    
    for _, state in ipairs(states) do
        humanoid:SetStateEnabled(state, enable)
    end
    humanoid:ChangeState(enable and Enum.HumanoidStateType.RunningNoPhysics or Enum.HumanoidStateType.Swimming)
end

local function setupFlyRig(rigPart)
    local bg = Instance.new("BodyGyro", rigPart)
    bg.P, bg.maxTorque = 9e4, Vector3.new(9e9, 9e9, 9e9)
    bg.cframe = rigPart.CFrame
    
    local bv = Instance.new("BodyVelocity", rigPart)
    bv.velocity, bv.maxForce = Vector3.new(0, 0.1, 0), Vector3.new(9e9, 9e9, 9e9)
    
    return bg, bv
end

local function startFly()
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildWhichIsA("Humanoid")
    if not humanoid then return end
    
    isFlying, humanoid.PlatformStand = true, true
    character.Animate.Disabled = true
    
    for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
        track:AdjustSpeed(0)
    end
    
    enableHumanoidStates(humanoid, false)
    
    tpWalking = true
    spawn(function()
        while tpWalking and isFlying do
            RunService.Heartbeat:Wait()
            if character and humanoid and humanoid.MoveDirection.Magnitude > 0 then
                character:TranslateBy(humanoid.MoveDirection * speed)
            end
        end
    end)
    
    local rigPart = humanoid.RigType == Enum.HumanoidRigType.R6 and 
                    character:FindFirstChild("Torso") or 
                    character:FindFirstChild("UpperTorso")
    if not rigPart then return end
    
    local bg, bv = setupFlyRig(rigPart)
    
    while isFlying and humanoid.Health > 0 do
        RunService.RenderStepped:Wait()
        
        if flyControls.l + flyControls.r ~= 0 or flyControls.f + flyControls.b ~= 0 then
            flySpeed = math.min(flySpeed + 0.5 + (flySpeed / maxFlySpeed), maxFlySpeed)
        elseif flySpeed > 0 then
            flySpeed = math.max(flySpeed - 1, 0)
        end
        
        if (flyControls.l + flyControls.r) ~= 0 or (flyControls.f + flyControls.b) ~= 0 then
            local cam = workspace.CurrentCamera
            local look = cam.CoordinateFrame.lookVector
            local moveVector = (look * (flyControls.f + flyControls.b)) + 
                              ((cam.CoordinateFrame * CFrame.new(flyControls.l + flyControls.r, 
                                                                (flyControls.f + flyControls.b) * 0.2, 0).p) - 
                               cam.CoordinateFrame.p)
            bv.velocity = moveVector * flySpeed
            lastControls = {f = flyControls.f, b = flyControls.b, l = flyControls.l, r = flyControls.r}
        elseif flySpeed > 0 then
            local cam = workspace.CurrentCamera
            local look = cam.CoordinateFrame.lookVector
            local moveVector = (look * (lastControls.f + lastControls.b)) + 
                              ((cam.CoordinateFrame * CFrame.new(lastControls.l + lastControls.r, 
                                                                (lastControls.f + lastControls.b) * 0.2, 0).p) - 
                               cam.CoordinateFrame.p)
            bv.velocity = moveVector * flySpeed
        else
            bv.velocity = Vector3.new(0, 0, 0)
        end
        
        bg.cframe = workspace.CurrentCamera.CoordinateFrame * 
                   CFrame.Angles(-math.rad((flyControls.f + flyControls.b) * 50 * flySpeed / maxFlySpeed), 0, 0)
    end
    
    bg:Destroy()
    bv:Destroy()
end

local function stopFly()
    isFlying, tpWalking = false, false
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildWhichIsA("Humanoid")
    if not humanoid then return end
    
    humanoid.PlatformStand, character.Animate.Disabled = false, false
    enableHumanoidStates(humanoid, true)
    
    flyControls, lastControls, flySpeed = {f = 0, b = 0, l = 0, r = 0}, {f = 0, b = 0, l = 0, r = 0}, 0
end

local function handleInput(input, isGameProcessed)
    if isGameProcessed or not isFlying then return end
    
    local keyMap = {
        [Enum.KeyCode.W] = "f",
        [Enum.KeyCode.S] = "b",
        [Enum.KeyCode.A] = "l",
        [Enum.KeyCode.D] = "r"
    }
    
    local control = keyMap[input.KeyCode]
    if control then
        flyControls[control] = input.UserInputState == Enum.UserInputState.Begin and 1 or 0
    end
end

toggle.MouseButton1Click:Connect(function()
    if isFlying then
        stopFly()
        toggle.BackgroundColor3 = Color3.fromRGB(80, 60, 60)
        toggle.Text = "FLY"
    else
        startFly()
        toggle.BackgroundColor3 = Color3.fromRGB(60, 80, 60)
        toggle.Text = "STOP"
    end
end)

-- Movimiento vertical
local function verticalMove(direction)
    local connection
    local button = direction > 0 and up or down
    
    button.MouseButton1Down:Connect(function()
        connection = button.MouseEnter:Connect(function()
            while connection do
                RunService.Heartbeat:Wait()
                local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    root.CFrame = root.CFrame * CFrame.new(0, direction, 0)
                end
            end
        end)
    end)
    
    button.MouseLeave:Connect(function()
        if connection then
            connection:Disconnect()
            connection = nil
        end
    end)
end

verticalMove(1)
verticalMove(-1)

-- Control de velocidad
plus.MouseButton1Click:Connect(function()
    speed = speed + 1
    speedLabel.Text = tostring(speed)
end)

minus.MouseButton1Click:Connect(function()
    if speed > 1 then
        speed = speed - 1
        speedLabel.Text = tostring(speed)
    else
        speedLabel.Text = "Min: 1"
        wait(1)
        speedLabel.Text = tostring(speed)
    end
end)

-- Eventos de input
local inputConnections = {
    UIS.InputBegan:Connect(handleInput),
    UIS.InputEnded:Connect(handleInput)
}

-- Manejo de respawn
LocalPlayer.CharacterAdded:Connect(function()
    wait(0.7)
    stopFly()
end)

-- Limpieza al destruir
main.Destroying:Connect(function()
    for _, conn in pairs(inputConnections) do
        conn:Disconnect()
    end
    stopFly()
end)
