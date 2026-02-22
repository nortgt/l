local Flymguiv2 = Instance.new("ScreenGui", game.CoreGui)
Flymguiv2.Name, Flymguiv2.ZIndexBehavior = "Car Fly gui v2", Enum.ZIndexBehavior.Sibling

local Drag = Instance.new("Frame", Flymguiv2)
Drag.Name, Drag.Active, Drag.Draggable = "Drag", true, true
Drag.BackgroundColor3, Drag.BorderSizePixel = Color3.fromRGB(0, 150, 191), 0
Drag.Position, Drag.Size = UDim2.new(0.482, 0, 0.455, 0), UDim2.new(0, 237, 0, 27)

local FlyFrame = Instance.new("Frame", Drag)
FlyFrame.Name, FlyFrame.Draggable = "FlyFrame", true
FlyFrame.BackgroundColor3, FlyFrame.BorderSizePixel = Color3.fromRGB(80, 80, 80), 0
FlyFrame.Position, FlyFrame.Size = UDim2.new(-0.002, 0, 0.989, 0), UDim2.new(0, 237, 0, 139)

function createLabel(name, text, position, size, color)
    local label = Instance.new("TextLabel", FlyFrame)
    label.Name, label.Text = name, text
    label.BackgroundColor3, label.BorderSizePixel = color, 0
    label.Position, label.Size = position, size
    label.Font, label.TextColor3 = Enum.Font.SourceSans, Color3.fromRGB(255, 255, 255)
    label.TextScaled, label.TextSize, label.TextWrapped = true, 14, true
    return label
end

function createButton(name, text, position, size, color)
    local button = Instance.new("TextButton", FlyFrame)
    button.Name, button.Text = name, text
    button.BackgroundColor3, button.BorderSizePixel = color, 0
    button.Position, button.Size = position, size
    button.Font, button.TextColor3 = Enum.Font.SourceSans, Color3.fromRGB(255, 255, 255)
    button.TextScaled, button.TextSize, button.TextWrapped = true, 14, true
    return button
end

createLabel("SubTitle", "by Nova", UDim2.new(0, 0, 0, 0), UDim2.new(0, 237, 0, 27), Color3.fromRGB(0, 150, 191))

local Speed = Instance.new("TextBox", FlyFrame)
Speed.Name, Speed.Text = "Speed", "50"
Speed.BackgroundColor3, Speed.BorderColor3 = Color3.fromRGB(63, 63, 63), Color3.fromRGB(0, 0, 191)
Speed.Position, Speed.Size = UDim2.new(0.445, 0, 0.403, 0), UDim2.new(0, 111, 0, 33)
Speed.Font, Speed.PlaceholderColor3 = Enum.Font.SourceSans, Color3.fromRGB(255, 255, 255)
Speed.TextColor3, Speed.TextScaled = Color3.fromRGB(255, 255, 255), true

createLabel("Speeed", "Speed:", UDim2.new(0.076, 0, 0.403, 0), UDim2.new(0, 87, 0, 32), Color3.fromRGB(80, 80, 80))
createLabel("Stat", "Status:", UDim2.new(0.3, 0, 0.24, 0), UDim2.new(0, 85, 0, 15), Color3.fromRGB(80, 80, 80))

local Stat2 = createLabel("Stat2", "Off", UDim2.new(0.547, 0, 0.24, 0), UDim2.new(0, 27, 0, 15), Color3.fromRGB(80, 80, 80))
Stat2.TextColor3 = Color3.fromRGB(255, 0, 0)

local Fly = createButton("Fly", "Enable", UDim2.new(0.076, 0, 0.706, 0), UDim2.new(0, 199, 0, 32), Color3.fromRGB(0, 150, 191))

local Unfly = createButton("Unfly", "Disable", UDim2.new(0.076, 0, 0.706, 0), UDim2.new(0, 199, 0, 32), Color3.fromRGB(0, 150, 191))
Unfly.Visible = false

local Title = createLabel("Vfly", "Vfly", UDim2.new(0, 0, 0, 0), UDim2.new(0, 57, 0, 27), Color3.fromRGB(0, 150, 191))
Title.Parent = Drag

local Close = createButton("Close", "X", UDim2.new(0.875, 0, 0, 0), UDim2.new(0, 27, 0, 27), Color3.fromRGB(0, 150, 191))
Close.Parent = Drag

local Minimize = createButton("Minimize", "-", UDim2.new(0.75, 0, 0, 0), UDim2.new(0, 27, 0, 27), Color3.fromRGB(0, 150, 191))
Minimize.Parent = Drag

local Flyon = Instance.new("Frame", Flymguiv2)
Flyon.Name, Flyon.Visible = "Fly on", false
Flyon.BackgroundColor3, Flyon.BorderSizePixel = Color3.fromRGB(0, 0, 0), 0
Flyon.Position, Flyon.Size = UDim2.new(0.118, 0, 0.55, 0), UDim2.new(0.148, 0, 0.315, 0)
Flyon.Active, Flyon.Draggable = true, true

function createFlyButton(text, position, rotation)
    local btn = Instance.new("TextButton", Flyon)
    btn.Text = text
    btn.BackgroundColor3, btn.BorderSizePixel = Color3.fromRGB(0, 150, 191), 0
    btn.Position, btn.Size = position, UDim2.new(0.709, 0, 0.499, 0)
    btn.Rotation = rotation or 0
    btn.Font, btn.TextColor3 = Enum.Font.SourceSans, Color3.fromRGB(255, 255, 255)
    btn.TextScaled, btn.TextWrapped = true, true
    return btn
end

local W = createFlyButton("^", UDim2.new(0.135, 0, 0.015, 0))
local S = createFlyButton("^", UDim2.new(0.134, 0, 0.48, 0), 180)

function applyVelocity(direction)
    local HumanoidRP = game.Players.LocalPlayer.Character.HumanoidRootPart
    if HumanoidRP and HumanoidRP:FindFirstChild("BodyVelocity") then
        for i = 1, 10 do
            HumanoidRP.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * (Speed.Text * direction)
            wait(0.1)
        end
        HumanoidRP.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * 0
    end
end

local function flyConnect(btn, dir)
    btn.MouseButton1Click:Connect(function() applyVelocity(dir) end)
    btn.TouchLongPress:Connect(function() applyVelocity(dir) end)
end

flyConnect(W, 1)
flyConnect(S, -1)

Fly.MouseButton1Click:Connect(function()
    local HumanoidRP = game.Players.LocalPlayer.Character.HumanoidRootPart
    Fly.Visible, Unfly.Visible, Flyon.Visible = false, true, true
    Stat2.Text, Stat2.TextColor3 = "On", Color3.fromRGB(0, 255, 0)
    
    local BV = Instance.new("BodyVelocity", HumanoidRP)
    local BG = Instance.new("BodyGyro", HumanoidRP)
    BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    
    game:GetService('RunService').RenderStepped:connect(function()
        BG.MaxTorque, BG.D, BG.P = Vector3.new(math.huge, math.huge, math.huge), 5000, 100000
        BG.CFrame = game.Workspace.CurrentCamera.CFrame
    end)
end)

Unfly.MouseButton1Click:Connect(function()
    local HumanoidRP = game.Players.LocalPlayer.Character.HumanoidRootPart
    Fly.Visible, Unfly.Visible, Flyon.Visible = true, false, false
    Stat2.Text, Stat2.TextColor3 = "Off", Color3.fromRGB(255, 0, 0)
    
    if HumanoidRP then
        local bv = HumanoidRP:FindFirstChildOfClass("BodyVelocity")
        local bg = HumanoidRP:FindFirstChildOfClass("BodyGyro")
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
    end
end)

Close.MouseButton1Click:Connect(function()
    Flymguiv2:Destroy()
end)

Minimize.MouseButton1Click:Connect(function()
    if Minimize.Text == "-" then
        Minimize.Text, FlyFrame.Visible = "+", false
    else
        Minimize.Text, FlyFrame.Visible = "-", true
    end
end)