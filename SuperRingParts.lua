local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local workspace = game:GetService("Workspace")

-- 1. CONFIGURACIÓN INICIAL
local config = { radius = 50, height = 100, rotationSpeed = 10, attractionStrength = 1000 }
local file = "SuperRingPartsConfig.txt"

local function saveConfig() writefile(file, HttpService:JSONEncode(config)) end
if isfile(file) then config = HttpService:JSONDecode(readfile(file)) end

-- 2. CREACIÓN DE GUI (Optimizada con funciones auxiliares)
local function createUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name, ScreenGui.ResetOnSpawn = "SuperRingPartsGUI", false
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Size, MainFrame.Position, MainFrame.BorderSizePixel = UDim2.new(0, 300, 0, 500), UDim2.new(0.5, -150, 0.5, -250), 0
    MainFrame.BackgroundColor3 = Color3.fromRGB(47, 49, 54)
    MainFrame.Parent = ScreenGui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 20)
    
    local Title = Instance.new("TextLabel")
    Title.Size, Title.Text, Title.BackgroundColor3, Title.Font, Title.TextSize = UDim2.new(1, 0, 0, 40), "Super Ring Parts V6", Color3.fromRGB(41, 43, 47), Enum.Font.Fondamento, 22
    Title.TextColor3 = Color3.fromRGB(202, 178, 251)
    Title.Parent = MainFrame
    Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 20)
    
    return MainFrame, Title
end

local function createButton(parent, size, pos, text, color, font, textSize)
    local btn = Instance.new("TextButton")
    btn.Size, btn.Position, btn.Text, btn.BackgroundColor3, btn.Font, btn.TextSize = size, pos, text, color, font, textSize
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    return btn
end

local function createLabel(parent, size, pos, text, bgColor, textColor, font, textSize)
    local lbl = Instance.new("TextLabel")
    lbl.Size, lbl.Position, lbl.Text, lbl.BackgroundColor3, lbl.TextColor3, lbl.Font, lbl.TextSize = size, pos, text, bgColor, textColor, font, textSize
    lbl.Parent = parent
    Instance.new("UICorner", lbl).CornerRadius = UDim.new(0, 10)
    return lbl
end

local MainFrame, Title = createUI()
local ToggleBtn = createButton(MainFrame, UDim2.new(0.8, 0, 0, 40), UDim2.new(0.1, 0, 0.1, 0), "Ring Off", Color3.fromRGB(255, 0, 0), Enum.Font.Fondamento, 18)
local MinBtn = createButton(MainFrame, UDim2.new(0, 30, 0, 30), UDim2.new(1, -35, 0, 5), "-", Color3.fromRGB(255, 255, 0), Enum.Font.Fondamento, 15)
MinBtn.UICorner.CornerRadius = UDim.new(0, 15)

-- 3. CONTROLES REUTILIZABLES (Más eficientes)
local controls = {}
local function createControl(posY, color, label, key)
    local dec = createButton(MainFrame, UDim2.new(0.2, 0, 0, 40), UDim2.new(0.1, 0, posY, 0), "-", color, Enum.Font.Fondamento, 18)
    local inc = createButton(MainFrame, UDim2.new(0.2, 0, 0, 40), UDim2.new(0.7, 0, posY, 0), "+", color, Enum.Font.Fondamento, 18)
    local disp = createLabel(MainFrame, UDim2.new(0.4, 0, 0, 40), UDim2.new(0.3, 0, posY, 0), label..": "..config[key], Color3.fromRGB(255, 153, 51), Color3.new(1,1,1), Enum.Font.Fondamento, 18)
    
    local box = Instance.new("TextBox")
    box.Size, box.Position, box.PlaceholderText, box.BackgroundColor3, box.Font, box.TextSize = UDim2.new(0.8, 0, 0, 35), UDim2.new(0.1, 0, posY + 0.1, 0), "Enter "..label, Color3.fromRGB(0, 0, 255), Enum.Font.Fondamento, 18
    box.Parent = MainFrame
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 10)

    local function update(val)
        config[key] = math.clamp(val, 0, 10000)
        disp.Text = label .. ": " .. config[key]
        saveConfig()
    end

    dec.MouseButton1Click:Connect(function() update(config[key] - 10) end)
    inc.MouseButton1Click:Connect(function() update(config[key] + 10) end)
    box.FocusLost:Connect(function(enter)
        if enter then
            local num = tonumber(box.Text)
            if num then update(num) end
            box.Text = ""
        end
    end)
    
    controls[key] = {dec = dec, inc = inc, disp = disp, box = box}
end

createControl(0.2, Color3.fromRGB(153, 153, 0), "Radius", "radius")
createControl(0.4, Color3.fromRGB(153, 0, 153), "Height", "height")
createControl(0.6, Color3.fromRGB(0, 153, 153), "Rotation Speed", "rotationSpeed")
createControl(0.8, Color3.fromRGB(153, 0, 0), "Attraction Strength", "attractionStrength")

-- 4. LÓGICA DE INTERFAZ MEJORADA
local minimized, dragging, dragStart, startPos = false, false, nil, nil
local visibleElements = {}

for _, child in ipairs(MainFrame:GetChildren()) do
    if child:IsA("GuiObject") and child ~= Title and child ~= MinBtn then
        table.insert(visibleElements, child)
    end
end

MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    MainFrame:TweenSize(UDim2.new(0, 300, 0, minimized and 40 or 500), "Out", "Quad", 0.3, true)
    MinBtn.Text = minimized and "+" or "-"
    for _, element in ipairs(visibleElements) do
        element.Visible = not minimized
    end
end)

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging, dragStart, startPos = true, input.Position, MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- 5. SISTEMA DE PARTES OPTIMIZADO
local ringEnabled, parts = false, {}
local network = getgenv().Network

if not network then
    network = { BaseParts = {}, Velocity = Vector3.new(14.46, 14.46, 14.46) }
    network.RetainPart = function(p)
        if typeof(p) == "Instance" and p:IsA("BasePart") and p:IsDescendantOf(workspace) then
            table.insert(network.BaseParts, p)
            p.CustomPhysicalProperties, p.CanCollide = PhysicalProperties.new(0,0,0,0,0), false
        end
    end
    LocalPlayer.ReplicationFocus = workspace
    getgenv().Network = network
end

local function isValidPart(p)
    return p:IsA("BasePart") and not p.Anchored and p:IsDescendantOf(workspace) 
           and not (LocalPlayer.Character and p:IsDescendantOf(LocalPlayer.Character))
end

local function addPart(p)
    if isValidPart(p) and not table.find(parts, p) then
        p.CustomPhysicalProperties, p.CanCollide = PhysicalProperties.new(0,0,0,0,0), false
        table.insert(parts, p)
    end
end

local function removePart(p)
    local index = table.find(parts, p)
    if index then table.remove(parts, index) end
end

-- Inicializar partes existentes
for _, p in ipairs(workspace:GetDescendants()) do addPart(p) end

workspace.DescendantAdded:Connect(addPart)
workspace.DescendantRemoving:Connect(removePart)

ToggleBtn.MouseButton1Click:Connect(function()
    ringEnabled = not ringEnabled
    ToggleBtn.Text = ringEnabled and "Tornado On" or "Tornado Off"
    ToggleBtn.BackgroundColor3 = ringEnabled and Color3.fromRGB(50, 205, 50) or Color3.fromRGB(160, 82, 45)
end)

-- 6. BUCLE PRINCIPUL ALTAMENTE OPTIMIZADO
local function processTornado(center)
    local radius, height, rotSpeed, strength = config.radius, config.height, config.rotationSpeed, config.attractionStrength
    
    for _, part in ipairs(parts) do
        if part.Parent and not part.Anchored then
            local partPos = part.Position
            local dist = (Vector3.new(partPos.X, center.Y, partPos.Z) - center).Magnitude
            local angle = math.atan2(partPos.Z - center.Z, partPos.X - center.X) + math.rad(rotSpeed)
            
            local target = Vector3.new(
                center.X + math.cos(angle) * math.min(radius, dist),
                center.Y + height * math.abs(math.sin((partPos.Y - center.Y) / height)),
                center.Z + math.sin(angle) * math.min(radius, dist)
            )
            
            part.Velocity = (target - partPos).Unit * strength
        end
    end
end

RunService.Heartbeat:Connect(function()
    -- Mantenimiento de Red (optimizado)
    sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
    for _, p in ipairs(network.BaseParts) do
        if p:IsDescendantOf(workspace) then p.Velocity = network.Velocity end
    end

    -- Tornado (solo si está activo)
    if ringEnabled and LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then processTornado(hrp.Position) end
    end
end)