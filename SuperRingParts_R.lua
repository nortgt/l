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

-- 2. CREACIÓN DE GUI CON DISEÑO FLYGUI
local main = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local dragHandle = Instance.new("Frame")
local title = Instance.new("TextLabel")
local closebutton = Instance.new("TextButton")
local mini = Instance.new("TextButton")
local mini2 = Instance.new("TextButton")

-- Elementos del SuperRing
local decRad = Instance.new("TextButton")
local incRad = Instance.new("TextButton")
local radDisp = Instance.new("TextLabel")
local decHeight = Instance.new("TextButton")
local incHeight = Instance.new("TextButton")
local heightDisp = Instance.new("TextLabel")
local decSpeed = Instance.new("TextButton")
local incSpeed = Instance.new("TextButton")
local speedDisp = Instance.new("TextLabel")
local decStrength = Instance.new("TextButton")
local incStrength = Instance.new("TextButton")
local strengthDisp = Instance.new("TextLabel")
local toggleBtn = Instance.new("TextButton")
local info = Instance.new("TextLabel")

-- Main GUI
main.Name = "SuperRingGUI"
main.Parent = LocalPlayer:WaitForChild("PlayerGui")
main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
main.ResetOnSpawn = false

-- Main Frame
Frame.Parent = main
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.100320168, 0, 0.379746825, 0)
Frame.Size = UDim2.new(0, 260, 0, 260) -- Aumentado ligeramente para dar más espacio
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
title.Text = "SUPER RING PARTS"
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

-- Función para crear botones con estilo FLYGUI
local function createStyledButton(parent, posX, posY, sizeX, sizeY, text, color, isToggle)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.BackgroundColor3 = color
    btn.Position = UDim2.new(posX, 0, posY, 0)
    btn.Size = UDim2.new(0, sizeX, 0, sizeY)
    btn.Font = Enum.Font.Gotham
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.TextSize = 14
    
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
    lbl.TextSize = 12
    
    local lblCorner = Instance.new("UICorner")
    lblCorner.CornerRadius = UDim.new(0, 6)
    lblCorner.Parent = lbl
    
    return lbl
end

-- Radius Controls
decRad = createStyledButton(Frame, 0.05, 0.15, 65, 30, "-", Color3.fromRGB(60, 60, 80), false)
incRad = createStyledButton(Frame, 0.7, 0.15, 65, 30, "+", Color3.fromRGB(60, 80, 60), false)
radDisp = createStyledLabel(Frame, 0.35, 0.15, 75, 30, "RAD: 50", Color3.fromRGB(40, 40, 40))

-- Height Controls
decHeight = createStyledButton(Frame, 0.05, 0.3, 65, 30, "-", Color3.fromRGB(60, 60, 80), false)
incHeight = createStyledButton(Frame, 0.7, 0.3, 65, 30, "+", Color3.fromRGB(60, 80, 60), false)
heightDisp = createStyledLabel(Frame, 0.35, 0.3, 75, 30, "HGT: 100", Color3.fromRGB(40, 40, 40))

-- Rotation Speed Controls
decSpeed = createStyledButton(Frame, 0.05, 0.45, 65, 30, "-", Color3.fromRGB(60, 60, 80), false)
incSpeed = createStyledButton(Frame, 0.7, 0.45, 65, 30, "+", Color3.fromRGB(60, 80, 60), false)
speedDisp = createStyledLabel(Frame, 0.35, 0.45, 75, 30, "SPD: 10", Color3.fromRGB(40, 40, 40))

-- Attraction Strength Controls
decStrength = createStyledButton(Frame, 0.05, 0.6, 65, 30, "-", Color3.fromRGB(60, 60, 80), false)
incStrength = createStyledButton(Frame, 0.7, 0.6, 65, 30, "+", Color3.fromRGB(60, 80, 60), false)
strengthDisp = createStyledLabel(Frame, 0.35, 0.6, 75, 30, "STR: 1000", Color3.fromRGB(40, 40, 40))

-- Toggle Button (abajo, ocupando todo el ancho)
toggleBtn = createStyledButton(Frame, 0.05, 0.75, 235, 35, "RING OFF", Color3.fromRGB(80, 60, 60), true)

-- Info Label
info.Parent = Frame
info.BackgroundTransparency = 1
info.Position = UDim2.new(0, 10, 1, -25)
info.Size = UDim2.new(1, -20, 0, 20)
info.Font = Enum.Font.Gotham
info.Text = "Super Ring GUI - By @Roun95"
info.TextColor3 = Color3.fromRGB(150, 150, 150)
info.TextSize = 11
info.TextXAlignment = Enum.TextXAlignment.Center

-- 3. LÓGICA DE INTERFAZ (Minimizar y Arrastrar)
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

-- Minimizar/Restaurar
local uiElements = {toggleBtn, decRad, incRad, radDisp, decHeight, incHeight, heightDisp, 
                    decSpeed, incSpeed, speedDisp, decStrength, incStrength, strengthDisp, info}

mini.MouseButton1Click:Connect(function()
    minimized = true
    for _, element in ipairs(uiElements) do
        element.Visible = false
    end
    mini.Visible = false
    mini2.Visible = true
    Frame:TweenSize(UDim2.new(0, 260, 0, 30), "Out", "Quad", 0.3, true)
    Frame.BackgroundTransparency = 0.5
end)

mini2.MouseButton1Click:Connect(function()
    minimized = false
    for _, element in ipairs(uiElements) do
        element.Visible = true
    end
    mini.Visible = true
    mini2.Visible = false
    Frame:TweenSize(UDim2.new(0, 260, 0, 260), "Out", "Quad", 0.3, true) -- Ajustado al nuevo tamaño
    Frame.BackgroundTransparency = 0
end)

closebutton.MouseButton1Click:Connect(function()
    main:Destroy()
end)

-- 4. VARIABLES Y LÓGICA DEL RING
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

-- Funciones de validación y manejo de partes
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

-- Funciones de actualización de displays
local function updateRadius(amount)
    config.radius = math.clamp(config.radius + amount, 5, 200)
    radDisp.Text = "RAD: " .. config.radius
    saveConfig()
end

local function updateHeight(amount)
    config.height = math.clamp(config.height + amount, 10, 500)
    heightDisp.Text = "HGT: " .. config.height
    saveConfig()
end

local function updateSpeed(amount)
    config.rotationSpeed = math.clamp(config.rotationSpeed + amount, 1, 100)
    speedDisp.Text = "SPD: " .. config.rotationSpeed
    saveConfig()
end

local function updateStrength(amount)
    config.attractionStrength = math.clamp(config.attractionStrength + amount, 100, 10000)
    strengthDisp.Text = "STR: " .. config.attractionStrength
    saveConfig()
end

-- Conectar botones
toggleBtn.MouseButton1Click:Connect(function()
    ringEnabled = not ringEnabled
    toggleBtn.Text = ringEnabled and "RING ON" or "RING OFF"
    toggleBtn.BackgroundColor3 = ringEnabled and Color3.fromRGB(60, 80, 60) or Color3.fromRGB(80, 60, 60)
end)

decRad.MouseButton1Click:Connect(function() updateRadius(-5) end)
incRad.MouseButton1Click:Connect(function() updateRadius(5) end)

decHeight.MouseButton1Click:Connect(function() updateHeight(-10) end)
incHeight.MouseButton1Click:Connect(function() updateHeight(10) end)

decSpeed.MouseButton1Click:Connect(function() updateSpeed(-1) end)
incSpeed.MouseButton1Click:Connect(function() updateSpeed(1) end)

decStrength.MouseButton1Click:Connect(function() updateStrength(-100) end)
incStrength.MouseButton1Click:Connect(function() updateStrength(100) end)

-- Inicializar displays
radDisp.Text = "RAD: " .. config.radius
heightDisp.Text = "HGT: " .. config.height
speedDisp.Text = "SPD: " .. config.rotationSpeed
strengthDisp.Text = "STR: " .. config.attractionStrength

-- 5. BUCLE PRINCIPAL
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
    -- Mantenimiento de Red
    sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
    for _, p in ipairs(network.BaseParts) do
        if p:IsDescendantOf(workspace) then p.Velocity = network.Velocity end
    end

    -- Tornado
    if ringEnabled and LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then processTornado(hrp.Position) end
    end
end)
