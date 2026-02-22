--// SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

game.StarterGui:SetCore("SendNotification", {
    Title = "Welcome to Hexagon",
    Text = "https://discord.gg/Q9R5FDapth, Join the official Discord server",
    Duration = 20,
})

local player = Players.LocalPlayer

pcall(function() player:WaitForChild("PlayerGui"):FindFirstChild("Hexagon"):Destroy() end)

--// CREATE GUI
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "Hexagon"
ScreenGui.ResetOnSpawn = false

--// MAIN FRAME
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 200, 0, 250)
MainFrame.Position = UDim2.new(0.1, 0, 0, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local frameCorner = Instance.new("UICorner", MainFrame)
frameCorner.CornerRadius = UDim.new(0, 12)

--// RGB STROKE
local RGBStroke = Instance.new("UIStroke", MainFrame)
RGBStroke.Thickness = 2
RGBStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

--// TITLE TEXT
local Title = Instance.new("TextLabel", MainFrame)
Title.Position = UDim2.new(0.3, 0, 0, 20)
Title.Text = "HEXAGON HUB"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextColor3 = Color3.fromRGB(255, 255, 255)

--// INFO TEXT
local Info = Instance.new("TextLabel", MainFrame)
Info.Position = UDim2.new(0.3, 0, 0, 32)
Info.Text = "by Roun95"
Info.Font = Enum.Font.GothamBold
Info.TextSize = 10
Info.TextColor3 = Color3.fromRGB(255, 255, 255)

--// CLOSE BUTTON
local CloseButton = Instance.new("TextButton", MainFrame)
CloseButton.Size = UDim2.new(0, 35, 0, 30)
CloseButton.Position = UDim2.new(1, -40, 0, 5)
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 14
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", CloseButton)

--// MINIMIZE BUTTON
local Minimize = Instance.new("TextButton", MainFrame)
Minimize.Text = "-"
Minimize.Font = Enum.Font.GothamBold
Minimize.TextSize = 18
Minimize.Size = UDim2.new(0, 35, 0, 30)
Minimize.Position = UDim2.new(1, -80, 0, 5)
Minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
Minimize.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", Minimize)

--// SCROLLING FRAME
local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(1, -20, 1, -50)
Scroll.Position = UDim2.new(0, 10, 0, 45)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.ScrollBarThickness = 2
Scroll.BackgroundTransparency = 1
Scroll.ScrollingDirection = Enum.ScrollingDirection.Y

local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 10)

--// MINIMIZED FLOATING BUTTON
local MiniBtn = Instance.new("ImageButton", ScreenGui)
MiniBtn.Size = UDim2.new(0, 40, 0, 40)
MiniBtn.Position = UDim2.new(0.1, 0, 0.6, 0)
MiniBtn.Image = "rbxassetid://108946066610871"
MiniBtn.ImageTransparency = 0.3
MiniBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MiniBtn.Visible = false
MiniBtn.Active = true
MiniBtn.Draggable = true

local miniCorner = Instance.new("UICorner", MiniBtn)
miniCorner.CornerRadius = UDim.new(0, 12)

-- RGB Stroke for minimized button
local MiniStroke = Instance.new("UIStroke", MiniBtn)
MiniStroke.Thickness = 2

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

--/// UI CREATOR FUNCTIONS

-- Update scroll size
Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	Scroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 20)
end)

--// MINIMIZE
Minimize.MouseButton1Click:Connect(function()
	MainFrame.Visible = false
	MiniBtn.Visible = true
end)

MiniBtn.MouseButton1Click:Connect(function()
	MainFrame.Visible = true
	MiniBtn.Visible = false
end)

--// CLOSE WINDOW
CloseButton.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
	Workspace.FloatingPlatform_player.Name:Destroy()
end)

local function Button(text)
	local b = Instance.new("TextButton", Scroll)
	b.Size = UDim2.new(1, -10, 0, 40)
	b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	b.TextColor3 = Color3.fromRGB(255, 255, 255)
	b.Font = Enum.Font.GothamBold
	b.TextSize = 14
	b.Text = text
	Instance.new("UICorner", b)

	-- Hover effect
	b.MouseEnter:Connect(function()
		TweenService:Create(b, TweenInfo.new(0.15), {Size = UDim2.new(1, -5, 0, 45), BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
	end)

	b.MouseLeave:Connect(function()
		TweenService:Create(b, TweenInfo.new(0.15), {Size = UDim2.new(1, -10, 0, 40), BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
	end)

	return b
end

local function Toggle(text)
	local frame = Instance.new("Frame", Scroll)
	frame.Size = UDim2.new(1, -10, 0, 40)
	frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	Instance.new("UICorner", frame)

	local label = Instance.new("TextLabel", frame)
	label.Size = UDim2.new(0.7, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = text .. ": OFF"
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Font = Enum.Font.GothamBold
	label.TextSize = 14

	local t = Instance.new("TextButton", frame)
	t.AnchorPoint = Vector2.new(1, 0.5)
	t.Position = UDim2.new(0.97, 0, 0.5, 0)
	t.Size = UDim2.new(0, 45, 0, 25)
	t.Text = ""
	t.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	t.AutoButtonColor = false
	Instance.new("UICorner", t).CornerRadius = UDim.new(1, 0)

	local c = Instance.new("Frame", t)
	c.Size = UDim2.new(0, 20, 0, 20)
	c.Position = UDim2.new(0, 3, 0.5, 0)
	c.AnchorPoint = Vector2.new(0, 0.5)
	c.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Instance.new("UICorner", c).CornerRadius = UDim.new(1, 0)

	return frame, label, t, c
end

--/// ADD BUTTONS
local NoclipFrame, NoclipLabel, NoclipToggle, NoclipCircle = Toggle("Noclip")
local FPFrame, FPLabel, FPToggle, FPCircle = Toggle("Floating Platform")
local InfJFrame, InfJLabel, InfJToggle, InfJCircle = Toggle("Infinite Jump")
local BFFrame, BFLabel, BFToggle, BFCircle = Toggle("Bubble Float")

local SaveP = Button("Save Position")
local TpPosition = Button("TP Position")
local FpsBooster = Button("Fps Booster")

--/// FEATURES

-- // Noclip
local noclipOn = false
NoclipToggle.MouseButton1Click:Connect(function()
	noclipOn = not noclipOn
	NoclipLabel.Text = "Noclip: " .. (noclipOn and "ON" or "OFF")
	local targetPos = noclipOn and UDim2.new(1, -24, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
	local targetColor = noclipOn and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(70, 70, 70)
	TweenService:Create(NoclipCircle, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos}):Play()
	TweenService:Create(NoclipToggle, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = targetColor}):Play()
end)

game:GetService("RunService").Stepped:Connect(function()
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

-- Mantener referencia al HumanoidRootPart y actualizar en respawn
local humanoidRootPart
local function onCharacterAdded(character)
    humanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)
	-- Si la plataforma está encendida recrearla debajo del nuevo spawn
    if platformEnabled and humanoidRootPart then
        -- Si no existe plataforma, crearla
        if not platform then
            -- Llamamos a la función de crear más abajo
            -- (la función createPlatform usa humanoidRootPart)
        end
    end
end

if player.Character then
    onCharacterAdded(player.Character)
end
player.CharacterAdded:Connect(onCharacterAdded)

-- Funciones para crear/eliminar y actualizar plataforma
local function createPlatform()
    if platform then return end
    platform = Instance.new("Part")
    platform.Name = "FloatingPlatform_" .. player.Name
    platform.Size = Vector3.new(6, 1, 6)
    platform.Anchored = true
    platform.Material = Enum.Material.Neon
    platform.Transparency = 0.3
    platform.Color = Color3.fromRGB(25, 25, 25)
    platform.CanCollide = true
    platform.TopSurface = Enum.SurfaceType.Smooth
    platform.BottomSurface = Enum.SurfaceType.Smooth
    platform.Parent = workspace

    -- Conexión para seguir la posición del jugador (RenderStepped para suavidad)
    if updateConn then updateConn:Disconnect() end
    updateConn = RunService.RenderStepped:Connect(function()
        if not platform or not platformEnabled or not humanoidRootPart then return end
        -- posición 3 studs debajo del HumanoidRootPart
        local targetPos = humanoidRootPart.Position - Vector3.new(0, 3, 0)
        -- para suavizar movimiento, interpolamos un poco
        local current = platform.Position
        local newPos = current:Lerp(targetPos, 0.35)
        platform.Position = newPos
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
    	-- Asegurarse de tener humanoidRootPart
        if not humanoidRootPart and player.Character then
            humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
        end
        createPlatform()
    else
        removePlatform()
    end

	player.AncestryChanged:Connect(function()
    	-- Si el player sale del juego, limpiar
    	if not player:IsDescendantOf(game) then
        	removePlatform()
    	end
	end)

	FPLabel.Text = "Floating Platform: " .. (platformEnabled and "ON" or "OFF")
	FPLabel.TextSize = 12

	local targetPos = platformEnabled and UDim2.new(1, -24, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
	local targetColor = platformEnabled and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(70, 70, 70)
	TweenService:Create(FPCircle, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos}):Play()
	TweenService:Create(FPToggle, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = targetColor}):Play()
end)

-- Infinite Jump
local infJump = false

InfJToggle.MouseButton1Click:Connect(function()
	infJump = not infJump
	InfJLabel.Text = "Infinite Jump: " .. (infJump and "ON" or "OFF")

	local targetPos = infJump and UDim2.new(1, -24, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
	local targetColor = infJump and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(70, 70, 70)
	TweenService:Create(InfJCircle, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos}):Play()
	TweenService:Create(InfJToggle, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = targetColor}):Play()
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
	if infJump then
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

-- FLOAT + ROTATION + FX
BFToggle.MouseButton1Click:Connect(function()
    toggled = not toggled

	BFLabel.Text = "Bubble Float: " .. (toggled and "ON" or "OFF")

	local targetPos = toggled and UDim2.new(1, -24, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
	local targetColor = toggled and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(70, 70, 70)
	TweenService:Create(BFCircle, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos}):Play()
	TweenService:Create(BFToggle, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = targetColor}):Play()

    if toggled then
        -- Crear fuerza para flotar
        floatForce = Instance.new("BodyVelocity")
        floatForce.Velocity = Vector3.new(0, 2, 0)
        floatForce.MaxForce = Vector3.new(0, 4000, 0)
        floatForce.Parent = hrp

        -- Crear rotación suave
        gyro = Instance.new("BodyGyro")
        gyro.MaxTorque = Vector3.new(4000, 4000, 4000)
        gyro.P = 3000
        gyro.Parent = hrp
-- Efecto de luz RGB
        light = Instance.new("PointLight")
        light.Brightness = 2
        light.Range = 12
        light.Color = Color3.fromRGB(255, 0, 0)
        light.Parent = hrp

        -- Partículas mágicas
        particleEmitter = Instance.new("ParticleEmitter")
        particleEmitter.Texture = "rbxassetid://241837157" -- partículas suaves blancas
        particleEmitter.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
        particleEmitter.LightEmission = 0.7
        particleEmitter.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(1, 0)})
        particleEmitter.Rate = 25
        particleEmitter.Lifetime = NumberRange.new(1, 2)
        particleEmitter.Speed = NumberRange.new(0, 1)
        particleEmitter.SpreadAngle = Vector2.new(360, 360)
        particleEmitter.Parent = hrp

        -- Movimiento + rotación + efectos
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
        -- Desactivar flotación y efectos
        if floatForce then floatForce:Destroy() floatForce = nil end
        if gyro then gyro:Destroy() gyro = nil end
        if particleEmitter then particleEmitter.Enabled = false particleEmitter:Destroy() particleEmitter = nil end
        if light then light:Destroy() light = nil end
    end
end)

-- RGB Border animation
task.spawn(function()
    while task.wait() do
        for i = 0, 1, 0.005 do
            local color = Color3.fromHSV(i, 1, 1)
            Outline.Color = color
            task.wait(0.02)
        end
    end
end)

-- // Teleport Player
local savedPos = nil
local moving = false

-- Smooth move with BodyVelocity
local function smoothMove(targetPos)
    if moving == true then return end
    moving = true

    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")

    -- BodyVelocity
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(400000, 400000, 400000)
    bv.Velocity = Vector3.zero
    bv.Parent = hrp

    -- Move loop
    while moving and (hrp.Position - targetPos).Magnitude > 3 do
        local direction = (targetPos - hrp.Position).Unit
        bv.Velocity = direction * 20 -- velocidad suave
        task.wait()
    end

    -- Remove velocity slowly (smooth stop)
    bv.Velocity = Vector3.zero
    task.wait(0.15)
    bv:Destroy()

    moving = false
end

SaveP.MouseButton1Click:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        savedPos = char.HumanoidRootPart.Position
        SaveP.Text = "¡Saved!"
        task.wait(0.8)
        SaveP.Text = "Save Position"
    end
end)

TpPosition.MouseButton1Click:Connect(function()
    if savedPos then
        smoothMove(savedPos)
    else
        TpPosition.Text = "You haven't saved!"
        task.wait(0.8)
        TpPosition.Text = "TP Position"
    end
end)

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
	w.DescendantAdded:Connect(function(child)
		task.spawn(function()
			if child:IsA('ForceField') or child:IsA('Sparkles') or child:IsA('Smoke') or child:IsA('Fire') or child:IsA('Beam') then
				g.RunService.Heartbeat:Wait()
				child:Destroy()
			end
		end)
	end)
	end
end)
