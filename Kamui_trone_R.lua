local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer

-- Configuración original
local DIMENSION_ORIGIN = Vector3.new(0, 1000000, 0)
local RETURN_POSITION = nil
local IN_KAMUI = false
local WARP_TIME = 0.1
local WINDUP_TIME = 0.87

-- Variables de estado
local IN_THRONE = false
local throneModel
local throneSeat
local oldWalkSpeed
local oldJumpPower

-- 1. CREACIÓN DE GUI CON DISEÑO FLYGUI
local screenGui = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local dragHandle = Instance.new("Frame")
local title = Instance.new("TextLabel")
local closebutton = Instance.new("TextButton")
local mini = Instance.new("TextButton")
local mini2 = Instance.new("TextButton")

-- Elementos de control
local kamuiButton = Instance.new("TextButton")
local throneButton = Instance.new("TextButton")
local statusLabel = Instance.new("TextLabel")

-- Main GUI
screenGui.Name = "KamuiGUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 100
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
Main.Parent = screenGui
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.5, -150, 0.5, -100)
Main.Size = UDim2.new(0, 300, 0, 200)
Main.Active = true
Main.ZIndex = 5

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
dragHandle.ZIndex = 6

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
title.Text = "KAMUI & THRONE"
title.TextColor3 = Color3.fromRGB(255, 0, 0)
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 6

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
closebutton.ZIndex = 7

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
mini.ZIndex = 7

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
mini2.ZIndex = 7

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
    lbl.TextSize = 12
    lbl.ZIndex = 5
    
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
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = textSize or 14
    btn.ZIndex = 5
    
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

-- Status label
statusLabel = createStyledLabel(Main, 0.1, 0.15, 240, 25, "Ready", Color3.fromRGB(200, 200, 200), Color3.fromRGB(30, 30, 30))
statusLabel.BackgroundTransparency = 1
statusLabel.TextSize = 12

-- Kamui Button
kamuiButton = createStyledButton(Main, 0.1, 0.35, 240, 45, "ENTER KAMUI", Color3.fromRGB(180, 0, 0), 16)

-- Throne Button
throneButton = createStyledButton(Main, 0.1, 0.6, 240, 45, "SPAWN THRONE", Color3.fromRGB(80, 60, 80), 16)

-- Credit
local creditLabel = createStyledLabel(Main, 0.1, 0.85, 240, 20, "by Roun95", Color3.fromRGB(120, 120, 120), Color3.fromRGB(30, 30, 30))
creditLabel.BackgroundTransparency = 1
creditLabel.TextSize = 10
creditLabel.TextXAlignment = Enum.TextXAlignment.Center

-- Elementos visuales originales (mantenemos el sharingan effect)
local bg = Instance.new("ImageLabel")
bg.Parent = screenGui
bg.BackgroundTransparency = 1
bg.Size = UDim2.new(0, 700, 0, 700)
bg.Position = UDim2.new(0.5, 0, 0.5, 0)
bg.AnchorPoint = Vector2.new(0.5, 0.5)
bg.Image = "rbxassetid://135542686675252"
bg.ImageTransparency = 1
bg.ZIndex = 10

local flash = Instance.new("Frame")
flash.Size = UDim2.new(1, 0, 1, 0)
flash.Position = UDim2.new(0, 0, 0, 0)
flash.BackgroundColor3 = Color3.new(0, 0, 0)
flash.BackgroundTransparency = 1
flash.BorderSizePixel = 0
flash.ZIndex = 9
flash.Parent = screenGui

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

-- Minimizar/Restaurar
local uiElements = {kamuiButton, throneButton, statusLabel, creditLabel}

mini.MouseButton1Click:Connect(function()
    minimized = true
    for _, element in ipairs(uiElements) do
        element.Visible = false
    end
    mini.Visible = false
    mini2.Visible = true
    Main:TweenSize(UDim2.new(0, 300, 0, 30), "Out", "Quad", 0.3, true)
    Main.BackgroundTransparency = 0.5
end)

mini2.MouseButton1Click:Connect(function()
    minimized = false
    for _, element in ipairs(uiElements) do
        element.Visible = true
    end
    mini.Visible = true
    mini2.Visible = false
    Main:TweenSize(UDim2.new(0, 300, 0, 200), "Out", "Quad", 0.3, true)
    Main.BackgroundTransparency = 0
end)

closebutton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- 3. TODO EL CÓDIGO ORIGINAL DE KAMUI Y THRONE (sin cambios funcionales)

-- Sonidos
local kamuiMusic = Instance.new("Sound")
kamuiMusic.SoundId = "rbxassetid://9039981149"
kamuiMusic.Looped = true
kamuiMusic.Volume = 0.5

local soundThrone = Instance.new("Sound")
soundThrone.SoundId = "rbxassetid://7437785043"
soundThrone.Volume = 1

local soundKamui = Instance.new("Sound")
soundKamui.SoundId = "rbxassetid://132492029022208"
soundKamui.Volume = 1
soundKamui.Parent = screenGui

-- Funciones de iluminación
local function applyKamuiLighting()
    Lighting.Ambient = Color3.new(0,0,0)
    Lighting.OutdoorAmbient = Color3.new(0,0,0)
    Lighting.FogColor = Color3.new(0,0,0)
    Lighting.FogStart = 20
    Lighting.FogEnd = 180
end

local function restoreNormalLighting()
    Lighting.Ambient = Color3.fromRGB(127,127,127)
    Lighting.OutdoorAmbient = Color3.fromRGB(127,127,127)
    Lighting.FogEnd = 100000
end

-- Creación de la dimensión
local dimensionFolder = Instance.new("Folder")
dimensionFolder.Name = "KamuiDimension"
dimensionFolder.Parent = workspace

local AREA_SIZE, WALL_HEIGHT = 300, 150
local spawnPositions = {}
local centralStructurePosition

local floor = Instance.new("Part")
floor.Size = Vector3.new(AREA_SIZE,1,AREA_SIZE)
floor.Anchored = true
floor.Position = DIMENSION_ORIGIN
floor.Color = Color3.new(0,0,0)
floor.Material = Enum.Material.SmoothPlastic
floor.Parent = dimensionFolder

local wallData = {
    {Vector3.new(AREA_SIZE/2,WALL_HEIGHT/2,0), Vector3.new(1,WALL_HEIGHT,AREA_SIZE)},
    {Vector3.new(-AREA_SIZE/2,WALL_HEIGHT/2,0), Vector3.new(1,WALL_HEIGHT,AREA_SIZE)},
    {Vector3.new(0,WALL_HEIGHT/2,AREA_SIZE/2), Vector3.new(AREA_SIZE,WALL_HEIGHT,1)},
    {Vector3.new(0,WALL_HEIGHT/2,-AREA_SIZE/2), Vector3.new(AREA_SIZE,WALL_HEIGHT,1)}
}

for _, data in ipairs(wallData) do
    local wall = Instance.new("Part")
    wall.Position = DIMENSION_ORIGIN + data[1]
    wall.Size = data[2]
    wall.Anchored = true
    wall.Color = Color3.new(0,0,0)
    wall.Material = Enum.Material.SmoothPlastic
    wall.Parent = dimensionFolder
end

local ceiling = Instance.new("Part")
ceiling.Size = Vector3.new(AREA_SIZE,1,AREA_SIZE)
ceiling.Position = DIMENSION_ORIGIN + Vector3.new(0,WALL_HEIGHT,0)
ceiling.Anchored = true
ceiling.Color = Color3.new(0,0,0)
ceiling.Material = Enum.Material.SmoothPlastic
ceiling.Parent = dimensionFolder

-- Crear estructuras
local function createStructures()
    spawnPositions = {}
    local structureCount = 130
    local seed = 12345

    local function deterministicRandom(a, b)
        seed = (seed * 9301 + 49297) % 233280
        local rnd = seed / 233280
        return a + rnd * (b - a)
    end

    for i = 1, structureCount do
        local block = Instance.new("Part")
        block.Anchored = true
        block.Material = Enum.Material.SmoothPlastic
        block.Color = Color3.new(1,1,1)

        local sizeX = deterministicRandom(10, 20)
        local sizeY = deterministicRandom(18, 30)
        local sizeZ = deterministicRandom(10, 20)
        if i == 1 then sizeX, sizeY, sizeZ = 30, 25, 30 end
        block.Size = Vector3.new(sizeX, sizeY, sizeZ)

        local offsetX, offsetZ
        if i == 1 then
            offsetX, offsetZ = 0, 0
        else
            offsetX = deterministicRandom(-AREA_SIZE/2 + 8, AREA_SIZE/2 - 8)
            offsetZ = deterministicRandom(-AREA_SIZE/2 + 8, AREA_SIZE/2 - 8)
        end
        local baseY = sizeY / 2
        block.Position = DIMENSION_ORIGIN + Vector3.new(offsetX, baseY, offsetZ)
        block.Parent = dimensionFolder

        local glow = Instance.new("PointLight")
        glow.Brightness = 2
        glow.Range = 18
        glow.Color = Color3.new(1,1,1)
        glow.Parent = block

        local spawnPos = block.Position + Vector3.new(0, sizeY/2 + 3, 0)
        table.insert(spawnPositions, spawnPos)
        if i == 1 then centralStructurePosition = spawnPos end
    end
end
createStructures()

-- Funciones de efecto
local function warpEffect(callback)
    local blur = Instance.new("BlurEffect")
    blur.Size = 0
    blur.Parent = Lighting

    local tweenIn = TweenService:Create(blur,TweenInfo.new(WARP_TIME,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Size=24})
    tweenIn:Play()
    tweenIn.Completed:Wait()

    callback()

    local tweenOut = TweenService:Create(blur,TweenInfo.new(WARP_TIME,Enum.EasingStyle.Sine,Enum.EasingDirection.In),{Size=0})
    tweenOut:Play()
    tweenOut.Completed:Wait()

    blur:Destroy()
end

local function playWindup(char, humanoid, hrp, callback)
    local originalWalkSpeed = humanoid.WalkSpeed
    humanoid.WalkSpeed = 0
    hrp.Anchored = true

    local windupAnim = Instance.new("Animation")
    windupAnim.AnimationId = "rbxassetid://32729592"
    local animTrack = humanoid:LoadAnimation(windupAnim)
    animTrack:Play()

    local partsToFade = {}
    for _, obj in ipairs(char:GetDescendants()) do
        if obj:IsA("BasePart") and obj ~= hrp then
            table.insert(partsToFade, obj)
        elseif obj:IsA("Accessory") then
            local handle = obj:FindFirstChild("Handle")
            if handle then table.insert(partsToFade, handle) end
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            table.insert(partsToFade, obj)
        end
    end

    for _, part in ipairs(partsToFade) do
        if part:IsA("BasePart") then
            TweenService:Create(part, TweenInfo.new(WINDUP_TIME), {Transparency=1}):Play()
        elseif part:IsA("Decal") or part:IsA("Texture") then
            TweenService:Create(part, TweenInfo.new(WINDUP_TIME), {Transparency=1}):Play()
        end
    end

    task.wait(WINDUP_TIME)

    for _, part in ipairs(partsToFade) do
        if part:IsA("BasePart") then
            part.Transparency = 0
        elseif part:IsA("Decal") or part:IsA("Texture") then
            part.Transparency = 0
        end
    end

    animTrack:Stop()
    humanoid.WalkSpeed = originalWalkSpeed
    hrp.Anchored = false

    callback()
end

-- Efecto sharingan
local tweenInfo = TweenInfo.new(0.7,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
local function kamuisharingan()
    flash.BackgroundTransparency = 0.5
    bg.ImageTransparency = 0
    TweenService:Create(flash,tweenInfo,{BackgroundTransparency=1}):Play()
    TweenService:Create(bg,tweenInfo,{ImageTransparency=1}):Play()
    soundKamui:Play()
end

-- Funciones Kamui
local function goToKamui()
    local char = player.Character or player.CharacterAdded:Wait()
    local humanoid = char:WaitForChild("Humanoid")
    local hrp = char:WaitForChild("HumanoidRootPart")
    if IN_KAMUI then return end
    
    statusLabel.Text = "🔄 Entering Kamui..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
    kamuiButton.Text = "LEAVE KAMUI"
    
    RETURN_POSITION = hrp.CFrame
    playWindup(char, humanoid, hrp, function()
        warpEffect(function()
            applyKamuiLighting()
            hrp.CFrame = CFrame.new(centralStructurePosition)
            kamuiMusic.Parent = hrp
            kamuiMusic:Play()
            kamuisharingan()
        end)
        IN_KAMUI = true
        statusLabel.Text = "✓ In Kamui"
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    end)
end

local function leaveKamui()
    local char = player.Character or player.CharacterAdded:Wait()
    local humanoid = char:WaitForChild("Humanoid")
    local hrp = char:WaitForChild("HumanoidRootPart")
    if not IN_KAMUI then return end
    
    statusLabel.Text = "🔄 Leaving Kamui..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
    kamuiButton.Text = "ENTER KAMUI"
    
    playWindup(char, humanoid, hrp, function()
        warpEffect(function()
            restoreNormalLighting()
            if RETURN_POSITION then hrp.CFrame = RETURN_POSITION end
            kamuiMusic:Stop()
            kamuisharingan()
        end)
        IN_KAMUI = false
        statusLabel.Text = "✓ In normal world"
        statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    end)
end

-- Función Throne
local function createThrone()
    local char = player.Character or player.CharacterAdded:Wait()
    local rootPart = char:WaitForChild("HumanoidRootPart")
    local model = Instance.new("Model")
    model.Name = "Throne"

    local baseColor = Color3.fromRGB(35, 35, 35)
    local rootCFrame = rootPart.CFrame * CFrame.Angles(0, math.rad(180), 0)

    throneSeat = Instance.new("Seat")
    throneSeat.Name = "ThroneSeat"
    throneSeat.Size = Vector3.new(4, 2, 4)
    throneSeat.Anchored = true
    throneSeat.Color = baseColor
    throneSeat.Material = Enum.Material.Slate
    throneSeat.CFrame = rootCFrame * CFrame.new(0, -2.5, 0)
    throneSeat.Parent = model

    local back = Instance.new("Part")
    back.Size = Vector3.new(4, 7, 1.5)
    back.Anchored = true
    back.Color = baseColor
    back.Material = Enum.Material.Slate
    back.CFrame = throneSeat.CFrame * CFrame.new(0, 4, -1.75)
    back.Parent = model

    for _, offset in ipairs({-2, 2}) do
        local arm = Instance.new("Part")
        arm.Size = Vector3.new(1.5, 3.5, 4)
        arm.Anchored = true
        arm.Color = baseColor
        arm.Material = Enum.Material.Slate
        arm.CFrame = throneSeat.CFrame * CFrame.new(offset, 1.5, 0)
        arm.Parent = model
    end

    for _, offset in ipairs({-1.8, 1.8}) do
        local pillar = Instance.new("Part")
        pillar.Size = Vector3.new(1.5, 3, 1.5)
        pillar.Anchored = true
        pillar.Color = Color3.fromRGB(25, 25, 25)
        pillar.Material = Enum.Material.Slate
        pillar.CFrame = back.CFrame * CFrame.new(offset, 4, 0)
        pillar.Parent = model
    end

    model.Parent = workspace
    return model
end

local function toggleThrone()
    local char = player.Character or player.CharacterAdded:Wait()
    local humanoid = char:WaitForChild("Humanoid")
    local hrp = char:WaitForChild("HumanoidRootPart")
    
    soundThrone.Parent = hrp

    if not IN_THRONE then
        IN_THRONE = true
        _G.InPose = true
        oldWalkSpeed = humanoid.WalkSpeed
        oldJumpPower = humanoid.JumpPower
        humanoid.WalkSpeed = 0
        humanoid.JumpPower = 0
        humanoid.Sit = true
        throneModel = createThrone()
        soundThrone:Play()
        throneButton.Text = "REMOVE THRONE"
        throneButton.BackgroundColor3 = Color3.fromRGB(100, 40, 40)
        statusLabel.Text = "✓ Throne active"
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        IN_THRONE = false
        _G.InPose = false
        humanoid.Sit = false
        humanoid.WalkSpeed = oldWalkSpeed
        humanoid.JumpPower = oldJumpPower
        if throneModel then
            throneModel:Destroy()
            throneModel = nil
            throneSeat = nil
        end
        soundThrone:Stop()
        throneButton.Text = "SPAWN THRONE"
        throneButton.BackgroundColor3 = Color3.fromRGB(80, 60, 80)
        statusLabel.Text = "Ready"
        statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end

-- Conectar botones
kamuiButton.MouseButton1Click:Connect(function()
    if IN_KAMUI then
        leaveKamui()
    else
        goToKamui()
    end
end)

throneButton.MouseButton1Click:Connect(toggleThrone)

-- Limpieza al cerrar
screenGui.Destroying:Connect(function()
    if IN_KAMUI then
        leaveKamui()
    end
    if IN_THRONE then
        toggleThrone()
    end
    dimensionFolder:Destroy()
end)