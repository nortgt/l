local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local main = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
main.ResetOnSpawn = false

local Frame = Instance.new("Frame", main)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Position = UDim2.new(0.1, 0, 0.1, 0)
Frame.Size = UDim2.new(0, 189, 0, 54)
Frame.Active, Frame.Draggable = true, true

function createBtn(text, size, position)
    local btn = Instance.new("TextButton")
    btn.Parent = Frame
    if position then
        btn.Position = position
    end
    btn.Size = size
    btn.BackgroundColor3 = Color3.fromRGB(74, 76, 81)
    btn.Font = Enum.Font.SourceSans
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(202, 178, 251)
    btn.TextSize = 14
    return btn
end

local up = createBtn("↑", UDim2.new(0, 44, 0, 27))
local down = createBtn("↓", UDim2.new(0, 44, 0, 27), UDim2.new(0, 0, 0.52, 0))
local toggle = createBtn("FLY", UDim2.new(0, 54, 0, 27), UDim2.new(0.72, 0, 0.52, 0))
local plus = createBtn("+", UDim2.new(0, 44, 0, 27), UDim2.new(0.236, 0, 0, 0))
plus.BackgroundColor3 = Color3.fromRGB(54, 57, 62)
plus.TextSize = 25

local speedLabel = Instance.new("TextLabel", Frame)
speedLabel.Text = "1"
speedLabel.BackgroundColor3 = Color3.fromRGB(74, 76, 81)
speedLabel.Position = UDim2.new(0.48, 0, 0.52, 0)
speedLabel.Size = UDim2.new(0, 44, 0, 27)
speedLabel.Font = Enum.Font.SourceSans
speedLabel.TextColor3 = Color3.fromRGB(202, 178, 251)
speedLabel.TextScaled, speedLabel.TextSize, speedLabel.TextWrapped = true, 14, true

local minus = createBtn("-", UDim2.new(0, 44, 0, 27), UDim2.new(0.24, 0, 0.516, 0))
minus.BackgroundColor3 = Color3.fromRGB(54, 57, 62)
minus.TextSize = 25

local title = Instance.new("TextLabel", Frame)
title.Text = "NOVA 🌠"
title.BackgroundColor3 = Color3.fromRGB(46, 49, 54)
title.Position = UDim2.new(0.475, 0, 0, 0)
title.Size = UDim2.new(0, 100, 0, 27)
title.Font = Enum.Font.SourceSans
title.TextColor3, title.TextSize, title.TextWrapped = Color3.fromRGB(202, 178, 251), 25, true

local close = createBtn("x", UDim2.new(0, 44, 0, 27), UDim2.new(0, 0, -1, 27))
close.BackgroundColor3 = Color3.fromRGB(54, 57, 62)
close.TextSize = 25

local minimize = createBtn("-", UDim2.new(0, 44, 0, 27), UDim2.new(0, 44, -1, 27))
minimize.BackgroundColor3 = Color3.fromRGB(46, 49, 54)
minimize.TextSize = 35

local maximize = createBtn("+", UDim2.new(0, 44, 0, 27), UDim2.new(0, 44, -1, 54))
maximize.BackgroundColor3 = Color3.fromRGB(46, 49, 54)
maximize.TextSize, maximize.Visible = 30, false

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
    else
        startFly()
    end
end)

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

close.MouseButton1Click:Connect(function()
    main:Destroy()
    stopFly()
end)

local function toggleMinimize(minimizeMode)
    local buttons = {up, down, toggle, plus, speedLabel, minus, minimize}
    for _, btn in pairs(buttons) do
        btn.Visible = not minimizeMode
    end
    maximize.Visible = minimizeMode
    Frame.BackgroundTransparency = minimizeMode and 1 or 0
    close.Position = minimizeMode and UDim2.new(0, 0, -1, 54) or UDim2.new(0, 0, -1, 27)
end

minimize.MouseButton1Click:Connect(function() toggleMinimize(true) end)
maximize.MouseButton1Click:Connect(function() toggleMinimize(false) end)

local inputConnections = {
    UIS.InputBegan:Connect(handleInput),
    UIS.InputEnded:Connect(handleInput)
}

LocalPlayer.CharacterAdded:Connect(function()
    wait(0.7)
    stopFly()
end)

main.Destroying:Connect(function()
    for _, conn in pairs(inputConnections) do
        conn:Disconnect()
    end
    stopFly()
end)
