local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- 1. CREACIÓN DE GUI CON DISEÑO FLYGUI
local Flymguiv2 = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local dragHandle = Instance.new("Frame")
local title = Instance.new("TextLabel")
local closebutton = Instance.new("TextButton")
local mini = Instance.new("TextButton")
local mini2 = Instance.new("TextButton")

-- Elementos de control
local FlyFrame = Instance.new("Frame")
local speedLabel = Instance.new("TextLabel")
local Speed = Instance.new("TextBox")
local statusLabel = Instance.new("TextLabel")
local Stat2 = Instance.new("TextLabel")
local FlyToggle = Instance.new("TextButton") -- Cambiado de Fly a FlyToggle
local Flyon = Instance.new("Frame")
local W = Instance.new("TextButton")
local S = Instance.new("TextButton")

-- Main GUI
Flymguiv2.Name = "VFlyGUI"
Flymguiv2.Parent = game.CoreGui
Flymguiv2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Flymguiv2.ResetOnSpawn = false

-- Main Frame
Frame.Parent = Flymguiv2
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.482, 0, 0.455, 0)
Frame.Size = UDim2.new(0, 280, 0, 180)
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
title.Text = "VFLY"
title.TextColor3 = Color3.fromRGB(0, 150, 191)
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left

-- Subtitle
local subtitle = Instance.new("TextLabel")
subtitle.Parent = dragHandle
subtitle.BackgroundTransparency = 1
subtitle.Position = UDim2.new(0, 60, 0, 0)
subtitle.Size = UDim2.new(0, 80, 1, 0)
subtitle.Font = Enum.Font.Gotham
subtitle.Text = "by Nova"
subtitle.TextColor3 = Color3.fromRGB(150, 150, 150)
subtitle.TextSize = 12
subtitle.TextXAlignment = Enum.TextXAlignment.Left

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

-- Fly Frame (contenido principal)
FlyFrame.Parent = Frame
FlyFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
FlyFrame.BorderSizePixel = 0
FlyFrame.Position = UDim2.new(0, 0, 0, 30)
FlyFrame.Size = UDim2.new(1, 0, 1, -30)

-- Función para crear labels estilizados
local function createStyledLabel(parent, posX, posY, sizeX, sizeY, text, textColor, bgColor)
    local lbl = Instance.new("TextLabel")
    lbl.Parent = parent
    lbl.BackgroundColor3 = bgColor or Color3.fromRGB(40, 40, 40)
    lbl.Position = UDim2.new(posX, 0, posY, 0)
    lbl.Size = UDim2.new(0, sizeX, 0, sizeY)
    lbl.Font = Enum.Font.Gotham
    lbl.Text = text
    lbl.TextColor3 = textColor or Color3.fromRGB(220, 220, 220)
    lbl.TextSize = 14
    
    local lblCorner = Instance.new("UICorner")
    lblCorner.CornerRadius = UDim.new(0, 6)
    lblCorner.Parent = lbl
    
    return lbl
end

-- Función para crear botones estilizados
local function createStyledButton(parent, posX, posY, sizeX, sizeY, text, color, textSize)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.BackgroundColor3 = color
    btn.Position = UDim2.new(posX, 0, posY, 0)
    btn.Size = UDim2.new(0, sizeX, 0, sizeY)
    btn.Font = Enum.Font.Gotham
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
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

-- Crear elementos de la interfaz
speedLabel = createStyledLabel(FlyFrame, 0.05, 0.15, 80, 35, "Speed:", Color3.fromRGB(220, 220, 220))

Speed = Instance.new("TextBox")
Speed.Parent = FlyFrame
Speed.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Speed.Position = UDim2.new(0.35, 0, 0.15, 0)
Speed.Size = UDim2.new(0, 80, 0, 35)
Speed.Font = Enum.Font.Gotham
Speed.Text = "50"
Speed.TextColor3 = Color3.fromRGB(255, 255, 255)
Speed.TextSize = 14
Speed.PlaceholderText = "Speed"
Speed.ClearTextOnFocus = false

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 6)
speedCorner.Parent = Speed

statusLabel = createStyledLabel(FlyFrame, 0.05, 0.4, 80, 30, "Status:", Color3.fromRGB(220, 220, 220))
Stat2 = createStyledLabel(FlyFrame, 0.35, 0.4, 50, 30, "Off", Color3.fromRGB(255, 50, 50))

-- Botón toggle (cambia entre ENABLE/DISABLE) - AHORA OCUPA TODO EL ANCHO
FlyToggle = createStyledButton(FlyFrame, 0.05, 0.65, 250, 40, "ENABLE", Color3.fromRGB(0, 150, 191), 16)

-- Frame de controles de vuelo (Flyon)
Flyon.Parent = Frame
Flyon.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Flyon.BorderSizePixel = 0
Flyon.Position = UDim2.new(1, 10, 0, 30)
Flyon.Size = UDim2.new(0, 100, 0, 100)
Flyon.Visible = false
Flyon.Active = true
Flyon.Draggable = true

-- Esquinas redondeadas para Flyon
local flyonCorner = Instance.new("UICorner")
flyonCorner.CornerRadius = UDim.new(0, 8)
flyonCorner.Parent = Flyon

-- Sombra para Flyon
local flyonShadow = Instance.new("UIStroke")
flyonShadow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
flyonShadow.Color = Color3.fromRGB(60, 60, 60)
flyonShadow.Thickness = 2
flyonShadow.Transparency = 0.7
flyonShadow.Parent = Flyon

-- Botones de dirección
W = createStyledButton(Flyon, 0.25, 0.1, 50, 40, "↑", Color3.fromRGB(0, 150, 191), 20)
S = createStyledButton(Flyon, 0.25, 0.5, 50, 40, "↓", Color3.fromRGB(0, 150, 191), 20)

-- Título pequeño para Flyon
local flyonTitle = Instance.new("TextLabel")
flyonTitle.Parent = Flyon
flyonTitle.BackgroundTransparency = 1
flyonTitle.Position = UDim2.new(0, 0, 0, 5)
flyonTitle.Size = UDim2.new(1, 0, 0, 20)
flyonTitle.Font = Enum.Font.Gotham
flyonTitle.Text = "Direction"
flyonTitle.TextColor3 = Color3.fromRGB(150, 150, 150)
flyonTitle.TextSize = 12

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
local uiElements = {FlyFrame}

mini.MouseButton1Click:Connect(function()
    minimized = true
    for _, element in ipairs(uiElements) do
        element.Visible = false
    end
    Flyon.Visible = false
    mini.Visible = false
    mini2.Visible = true
    Frame:TweenSize(UDim2.new(0, 280, 0, 30), "Out", "Quad", 0.3, true)
    Frame.BackgroundTransparency = 0.5
end)

mini2.MouseButton1Click:Connect(function()
    minimized = false
    for _, element in ipairs(uiElements) do
        element.Visible = true
    end
    if FlyToggle.Text == "DISABLE" then
        Flyon.Visible = true
    end
    mini.Visible = true
    mini2.Visible = false
    Frame:TweenSize(UDim2.new(0, 280, 0, 180), "Out", "Quad", 0.3, true)
    Frame.BackgroundTransparency = 0
end)

closebutton.MouseButton1Click:Connect(function()
    Flymguiv2:Destroy()
end)

-- 3. LÓGICA DE VUELO (FUNCIÓN ORIGINAL RESTAURADA)
local function applyVelocity(direction)
    local HumanoidRP = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if HumanoidRP and HumanoidRP:FindFirstChild("BodyVelocity") then
        local speedValue = tonumber(Speed.Text) or 50
        for i = 1, 10 do
            HumanoidRP.BodyVelocity.Velocity = workspace.CurrentCamera.CFrame.LookVector * (speedValue * direction)
            wait(0.1)
        end
        HumanoidRP.BodyVelocity.Velocity = workspace.CurrentCamera.CFrame.LookVector * 0
    end
end

local function flyConnect(btn, dir)
    btn.MouseButton1Click:Connect(function() applyVelocity(dir) end)
    btn.TouchLongPress:Connect(function() applyVelocity(dir) end)
end

flyConnect(W, 1)
flyConnect(S, -1)

-- Variable para controlar el estado del toggle
local flying = false
local bodyVelocity = nil
local bodyGyro = nil
local connection = nil

-- Función toggle (activar/desactivar vuelo)
local function toggleFly()
    if not flying then
        -- ACTIVAR VUELO
        local character = LocalPlayer.Character
        if not character then return end
        
        local HumanoidRP = character:FindFirstChild("HumanoidRootPart")
        if not HumanoidRP then return end
        
        flying = true
        FlyToggle.Text = "DISABLE"
        FlyToggle.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
        Flyon.Visible = true
        Stat2.Text = "On"
        Stat2.TextColor3 = Color3.fromRGB(50, 255, 50)
        
        -- Crear BodyVelocity (necesario para que applyVelocity funcione)
        local BV = Instance.new("BodyVelocity", HumanoidRP)
        BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVelocity = BV
        
        -- Crear BodyGyro
        local BG = Instance.new("BodyGyro", HumanoidRP)
        bodyGyro = BG
        
        -- Mantener orientación
        connection = RunService.RenderStepped:Connect(function()
            if flying and HumanoidRP and HumanoidRP.Parent then
                BG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                BG.D = 5000
                BG.P = 100000
                BG.CFrame = workspace.CurrentCamera.CFrame
            end
        end)
        
        -- Actualizar hover colors
        local originalColor = FlyToggle.BackgroundColor3
        local hoverColor = Color3.fromRGB(
            math.min(originalColor.R * 255 + 20, 255) / 255,
            math.min(originalColor.G * 255 + 20, 255) / 255,
            math.min(originalColor.B * 255 + 20, 255) / 255
        )
        
        FlyToggle.MouseEnter:Connect(function()
            FlyToggle.BackgroundColor3 = hoverColor
        end)
        
        FlyToggle.MouseLeave:Connect(function()
            FlyToggle.BackgroundColor3 = originalColor
        end)
        
    else
        -- DESACTIVAR VUELO
        local character = LocalPlayer.Character
        if not character then return end
        
        local HumanoidRP = character:FindFirstChild("HumanoidRootPart")
        
        flying = false
        FlyToggle.Text = "ENABLE"
        FlyToggle.BackgroundColor3 = Color3.fromRGB(0, 150, 191)
        Flyon.Visible = false
        Stat2.Text = "Off"
        Stat2.TextColor3 = Color3.fromRGB(255, 50, 50)
        
        -- Limpiar instancias
        if HumanoidRP then
            local bv = HumanoidRP:FindFirstChildOfClass("BodyVelocity")
            local bg = HumanoidRP:FindFirstChildOfClass("BodyGyro")
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
        end
        
        if connection then
            connection:Disconnect()
            connection = nil
        end
    end
end

-- Conectar el botón toggle
FlyToggle.MouseButton1Click:Connect(toggleFly)

-- Validación de entrada de velocidad
Speed.FocusLost:Connect(function()
    local num = tonumber(Speed.Text)
    if not num or num < 1 then
        Speed.Text = "50"
    end
end)

-- Limpiar cuando se destruye la GUI
Flymguiv2.Destroying:Connect(function()
    if connection then
        connection:Disconnect()
    end
end)
