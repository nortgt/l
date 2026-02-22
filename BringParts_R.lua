local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

pcall(function() LocalPlayer.PlayerGui:FindFirstChild("BringParts"):Destroy() end)

-- 1. CREACIÓN DE GUI CON DISEÑO FLYGUI
local Gui = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local dragHandle = Instance.new("Frame")
local title = Instance.new("TextLabel")
local closebutton = Instance.new("TextButton")
local mini = Instance.new("TextButton")
local mini2 = Instance.new("TextButton")

-- Elementos de control
local Box = Instance.new("TextBox")
local Button = Instance.new("TextButton")
local creditLabel = Instance.new("TextLabel")

-- Main GUI
Gui.Name = "BringPartsGUI"
Gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.ResetOnSpawn = false

-- Main Frame (ligeramente más alto para mejor distribución)
Main.Parent = Gui
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.3, 0, 0.5, 0)
Main.Size = UDim2.new(0, 280, 0, 180) -- Aumentado de 160 a 180
Main.Active = true

-- Add rounded corners
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = Main

-- Add subtle drop shadow
local shadow = Instance.new("UIStroke")
shadow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
shadow.Color = Color3.fromRGB(60, 60, 60)
shadow.Thickness = 2
shadow.Transparency = 0.7
shadow.Parent = Main

-- Drag Handle
dragHandle.Name = "DragHandle"
dragHandle.Parent = Main
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
title.Text = "BRING PARTS"
title.TextColor3 = Color3.fromRGB(255, 153, 51)
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left

-- Credit Label en drag handle
creditLabel.Name = "Credit"
creditLabel.Parent = dragHandle
creditLabel.BackgroundTransparency = 1
creditLabel.Position = UDim2.new(0, 120, 0, 0)
creditLabel.Size = UDim2.new(0, 120, 1, 0)
creditLabel.Font = Enum.Font.Gotham
creditLabel.Text = "by Roun95"
creditLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
creditLabel.TextSize = 12
creditLabel.TextXAlignment = Enum.TextXAlignment.Left

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

-- Instrucción label (más espaciado)
local instructionLabel = createStyledLabel(Main, 0.1, 0.1, 220, 20, "Enter player name:", Color3.fromRGB(200, 200, 200), Color3.fromRGB(30, 30, 30))
instructionLabel.BackgroundTransparency = 1
instructionLabel.TextXAlignment = Enum.TextXAlignment.Left
instructionLabel.TextSize = 14

-- TextBox para nombre del jugador
Box = Instance.new("TextBox")
Box.Parent = Main
Box.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Box.Position = UDim2.new(0.1, 0, 0.2, 0)
Box.Size = UDim2.new(0, 220, 0, 35)
Box.Font = Enum.Font.Gotham
Box.Text = ""
Box.PlaceholderText = "Player name..."
Box.TextColor3 = Color3.fromRGB(255, 255, 255)
Box.TextSize = 14
Box.ClearTextOnFocus = false

local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0, 6)
boxCorner.Parent = Box

-- Status label para feedback (más espacio)
local statusLabel = createStyledLabel(Main, 0.1, 0.4, 220, 20, "", Color3.fromRGB(150, 150, 150), Color3.fromRGB(30, 30, 30))
statusLabel.BackgroundTransparency = 1
statusLabel.TextSize = 13
statusLabel.TextXAlignment = Enum.TextXAlignment.Center

-- Botón principal
Button = createStyledButton(Main, 0.1, 0.5, 220, 40, "BRING | OFF", Color3.fromRGB(80, 60, 60), 16)

-- Hotkey info (más espaciado y mejor posicionado)
local hotkeyLabel = createStyledLabel(Main, 0.1, 0.75, 220, 20, "Press RightCtrl to toggle GUI", Color3.fromRGB(180, 180, 180), Color3.fromRGB(30, 30, 30))
hotkeyLabel.BackgroundTransparency = 1
hotkeyLabel.TextSize = 12
hotkeyLabel.TextXAlignment = Enum.TextXAlignment.Center

-- Crédito adicional (opcional, para dar más estilo)
local versionLabel = createStyledLabel(Main, 0.1, 0.85, 220, 15, "v1.0", Color3.fromRGB(100, 100, 100), Color3.fromRGB(30, 30, 30))
versionLabel.BackgroundTransparency = 1
versionLabel.TextSize = 10
versionLabel.TextXAlignment = Enum.TextXAlignment.Right

-- 2. LÓGICA DE INTERFAZ (Arrastrar y minimizar)
local minimized, dragging, dragInput, dragStart, startPos = false, false, nil, nil, nil

local function update(input)
    if not dragging then return end
    local delta = input.Position - dragStart
    Main.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

local function startDrag(input)
    dragging = true
    dragStart = input.Position
    startPos = Main.Position
    
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

-- Minimizar/Restaurar (actualizado con los nuevos elementos)
local uiElements = {Box, Button, instructionLabel, statusLabel, hotkeyLabel, versionLabel}

mini.MouseButton1Click:Connect(function()
    minimized = true
    for _, element in ipairs(uiElements) do
        element.Visible = false
    end
    mini.Visible = false
    mini2.Visible = true
    Main:TweenSize(UDim2.new(0, 280, 0, 30), "Out", "Quad", 0.3, true)
    Main.BackgroundTransparency = 0.5
end)

mini2.MouseButton1Click:Connect(function()
    minimized = false
    for _, element in ipairs(uiElements) do
        element.Visible = true
    end
    mini.Visible = true
    mini2.Visible = false
    Main:TweenSize(UDim2.new(0, 280, 0, 180), "Out", "Quad", 0.3, true) -- Actualizado al nuevo tamaño
    Main.BackgroundTransparency = 0
end)

closebutton.MouseButton1Click:Connect(function()
    Gui:Destroy()
end)

-- Hotkey para mostrar/ocultar GUI
local mainStatus = true
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.RightControl and not gameProcessed then
        mainStatus = not mainStatus
        Main.Visible = mainStatus
    end
end)

-- 3. LÓGICA ORIGINAL DE BRING PARTS (adaptada)

-- Sistema de bypass de red
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

-- Elementos para el "agujero negro"
local Folder = Instance.new("Folder", Workspace)
local Part = Instance.new("Part", Folder)
local Attachment1 = Instance.new("Attachment", Part)
Part.Anchored, Part.CanCollide, Part.Transparency = true, false, 1

local blackHoleActive = false
local DescendantAddedConnection
local character, humanoidRootPart
local selectedPlayer = nil

-- Función para obtener jugador por nombre
local function getPlayer(name)
    local lowerName = string.lower(name)
    for _, p in pairs(Players:GetPlayers()) do
        if string.find(string.lower(p.Name), lowerName) or 
           string.find(string.lower(p.DisplayName), lowerName) then
            return p
        end
    end
end

-- Función para forzar partes hacia el jugador
local function ForcePart(v)
    if v:IsA("BasePart") and not v.Anchored and 
       not v.Parent:FindFirstChildOfClass("Humanoid") and 
       not v.Parent:FindFirstChild("Head") and v.Name ~= "Handle" then
        
        -- Eliminar BodyMovers existentes
        for _, x in ipairs(v:GetChildren()) do
            if x:IsA("BodyMover") or x:IsA("RocketPropulsion") then
                x:Destroy()
            end
        end
        
        -- Eliminar attachments no deseados
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

-- Toggle del sistema
local function toggleBlackHole()
    blackHoleActive = not blackHoleActive
    Button.Text = blackHoleActive and "BRING | ON" or "BRING | OFF"
    Button.BackgroundColor3 = blackHoleActive and Color3.fromRGB(60, 80, 60) or Color3.fromRGB(80, 60, 60)
    
    if blackHoleActive then
        statusLabel.Text = "✓ Active - Bringing parts to " .. selectedPlayer.Name
        statusLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
        
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
    else
        statusLabel.Text = "○ Inactive"
        statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        if DescendantAddedConnection then
            DescendantAddedConnection:Disconnect()
        end
    end
end

-- Eventos de la GUI
Box.FocusLost:Connect(function(enterPressed)
    if enterPressed and Box.Text ~= "" then
        selectedPlayer = getPlayer(Box.Text)
        if selectedPlayer then
            Box.Text = selectedPlayer.Name
            statusLabel.Text = "✓ Player selected: " .. selectedPlayer.Name
            statusLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
            Button.BackgroundColor3 = Color3.fromRGB(80, 60, 60) -- Reset to OFF color
            Button.Text = "BRING | OFF"
        else
            Box.Text = "Player not found"
            statusLabel.Text = "✗ Player not found"
            statusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
            wait(1.5)
            Box.Text = ""
            statusLabel.Text = ""
        end
    end
end)

Button.MouseButton1Click:Connect(function()
    if selectedPlayer then
        -- Asegurar que el personaje existe
        character = selectedPlayer.Character or selectedPlayer.CharacterAdded:Wait()
        humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        toggleBlackHole()
    else
        statusLabel.Text = "✗ Select a player first!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        wait(1.5)
        statusLabel.Text = ""
    end
end)

-- Limpiar al cerrar
Gui.Destroying:Connect(function()
    if DescendantAddedConnection then
        DescendantAddedConnection:Disconnect()
    end
    Folder:Destroy()
end)
