local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

pcall(function() LocalPlayer.PlayerGui:FindFirstChild("BringParts"):Destroy() end)

local Gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
Gui.Name, Gui.ZIndexBehavior = "BringParts", Enum.ZIndexBehavior.Sibling

local Main = Instance.new("Frame", Gui)
Main.Name, Main.Active, Main.Draggable = "Main", true, true
Main.BackgroundColor3, Main.BorderColor3, Main.BorderSizePixel = Color3.fromRGB(75,75,75), Color3.fromRGB(0,0,0), 0
Main.Position, Main.Size = UDim2.new(0.3, 0, 0.5, 0), UDim2.new(0.24, 0, 0.17, 0)

function createConstraint(parent, maxSize)
    local constraint = Instance.new("UITextSizeConstraint", parent)
    constraint.MaxTextSize = maxSize
    return constraint
end

local Box = Instance.new("TextBox", Main)
Box.Name, Box.PlaceholderText, Box.Text = "Box", "Player here", ""
Box.BackgroundColor3, Box.BorderColor3, Box.BorderSizePixel = Color3.fromRGB(95,95,95), Color3.fromRGB(0,0,0), 0
Box.Position, Box.Size = UDim2.new(0.1, 0, 0.22, 0), UDim2.new(0.8, 0, 0.365, 0)
Box.Font, Box.TextColor3 = Enum.Font.SourceSansSemibold, Color3.fromRGB(255,255,255)
Box.TextScaled, Box.TextSize, Box.TextWrapped = true, 30, true
createConstraint(Box, 30)

local Label = Instance.new("TextLabel", Main)
Label.Name, Label.Text = "Label", "Bring Parts | by Roun95"
Label.BackgroundColor3, Label.BorderColor3, Label.BorderSizePixel = Color3.fromRGB(95,95,95), Color3.fromRGB(0,0,0), 0
Label.Size = UDim2.new(1, 0, 0.16, 0)
Label.Font, Label.TextColor3 = Enum.Font.Nunito, Color3.fromRGB(255,255,255)
Label.TextScaled, Label.TextSize, Label.TextWrapped = true, 14, true
createConstraint(Label, 21)

local Button = Instance.new("TextButton", Main)
Button.Name, Button.Text = "Button", "Bring | Off"
Button.BackgroundColor3, Button.BorderColor3, Button.BorderSizePixel = Color3.fromRGB(95,95,95), Color3.fromRGB(0,0,0), 0
Button.Position, Button.Size = UDim2.new(0.18, 0, 0.65, 0), UDim2.new(0.63, 0, 0.27, 0)
Button.Font, Button.TextColor3 = Enum.Font.Nunito, Color3.fromRGB(255,255,255)
Button.TextScaled, Button.TextSize, Button.TextWrapped = true, 28, true
createConstraint(Button, 28)

local mainStatus = true
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.RightControl and not gameProcessed then
        mainStatus = not mainStatus
        Main.Visible = mainStatus
    end
end)

if not getgenv().Network then
    getgenv().Network = {
        BaseParts = {},
        Velocity = Vector3.new(14, 14, 14)
    }
    
    Network.RetainPart = function(Part)
        if Part:IsA("BasePart") and Part:IsDescendantOf(Workspace) then
            table.insert(Network.BaseParts, Part)
            Part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
            Part.CanCollide = false
        end
    end
    
    RunService.Heartbeat:Connect(function()
        LocalPlayer.ReplicationFocus = Workspace
        sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
        for _, Part in pairs(Network.BaseParts) do
            if Part:IsDescendantOf(Workspace) then
                Part.Velocity = Network.Velocity
            end
        end
    end)
end

local Folder = Instance.new("Folder", Workspace)
local Part = Instance.new("Part", Folder)
local Attachment1 = Instance.new("Attachment", Part)
Part.Anchored, Part.CanCollide, Part.Transparency = true, false, 1

local blackHoleActive = false
local DescendantAddedConnection
local character, humanoidRootPart
local selectedPlayer = nil

local function getPlayer(name)
    local lowerName = string.lower(name)
    for _, p in pairs(Players:GetPlayers()) do
        if string.find(string.lower(p.Name), lowerName) or 
           string.find(string.lower(p.DisplayName), lowerName) then
            return p
        end
    end
end

local function ForcePart(v)
    if v:IsA("BasePart") and not v.Anchored and 
       not v.Parent:FindFirstChildOfClass("Humanoid") and 
       not v.Parent:FindFirstChild("Head") and v.Name ~= "Handle" then
        
        for _, x in ipairs(v:GetChildren()) do
            if x:IsA("BodyMover") or x:IsA("RocketPropulsion") then
                x:Destroy()
            end
        end
        
        local unwanted = {"Attachment", "AlignPosition", "Torque"}
        for _, name in ipairs(unwanted) do
            local obj = v:FindFirstChild(name)
            if obj then obj:Destroy() end
        end
        
        v.CanCollide = false
        local Attachment2 = Instance.new("Attachment", v)
        local Torque = Instance.new("Torque", v)
        local AlignPosition = Instance.new("AlignPosition", v)
        
        Torque.Torque, Torque.Attachment0 = Vector3.new(100000, 100000, 100000), Attachment2
        AlignPosition.MaxForce, AlignPosition.MaxVelocity = math.huge, math.huge
        AlignPosition.Responsiveness, AlignPosition.Attachment0, AlignPosition.Attachment1 = 200, Attachment2, Attachment1
    end
end

local function toggleBlackHole()
    blackHoleActive = not blackHoleActive
    Button.Text = blackHoleActive and "Bring Parts | On" or "Bring Parts | Off"
    
    if blackHoleActive then
        for _, v in ipairs(Workspace:GetDescendants()) do
            ForcePart(v)
        end
        
        DescendantAddedConnection = Workspace.DescendantAdded:Connect(ForcePart)
        
        spawn(function()
            while blackHoleActive and RunService.RenderStepped:Wait() do
                if humanoidRootPart then
                    Attachment1.WorldCFrame = humanoidRootPart.CFrame
                end
            end
        end)
    elseif DescendantAddedConnection then
        DescendantAddedConnection:Disconnect()
    end
end

Box.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        selectedPlayer = getPlayer(Box.Text)
        Box.Text = selectedPlayer and selectedPlayer.Name or "Player not found"
    end
end)

Button.MouseButton1Click:Connect(function()
    if selectedPlayer then
        character = selectedPlayer.Character or selectedPlayer.CharacterAdded:Wait()
        humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        toggleBlackHole()
    end
end)