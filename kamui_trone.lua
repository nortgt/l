local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer

local DIMENSION_ORIGIN = Vector3.new(0, 1000000, 0)
local RETURN_POSITION = nil
local IN_KAMUI = false
local WARP_TIME = 0.1
local WINDUP_TIME = 0.87
local kamuiMusic = Instance.new("Sound")
kamuiMusic.SoundId = "rbxassetid://9039981149"
kamuiMusic.Looped = true
kamuiMusic.Volume = 0.5

local IN_THRONE = false
local throneModel
local throneSeat
local oldWalkSpeed
local oldJumpPower
local soundThrone = Instance.new("Sound")
soundThrone.SoundId = "rbxassetid://7437785043"
soundThrone.Volume = 1
soundThrone.Parent = player.Character:WaitForChild("HumanoidRootPart")

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

local screenGui = Instance.new("ScreenGui")
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 100
screenGui.Parent = player:WaitForChild("PlayerGui")

local bg = Instance.new("ImageLabel")
bg.Parent = screenGui
bg.BackgroundTransparency = 1
bg.Size = UDim2.new(0,700,0,700)
bg.Position = UDim2.new(0.5,0,0.5,0)
bg.AnchorPoint = Vector2.new(0.5,0.5)
bg.Image = "rbxassetid://135542686675252"
bg.ImageTransparency = 1

local flash = Instance.new("Frame")
flash.Size = UDim2.new(1,0,1,0)
flash.Position = UDim2.new(0,0,0,0)
flash.BackgroundColor3 = Color3.new(0,0,0)
flash.BackgroundTransparency = 1
flash.BorderSizePixel = 0
flash.ZIndex = 2
flash.Parent = screenGui

local soundKamui = Instance.new("Sound")
soundKamui.SoundId = "rbxassetid://132492029022208"
soundKamui.Volume = 1
soundKamui.Parent = screenGui

local tweenInfo = TweenInfo.new(0.7,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
local function kamuisharingan()
	flash.BackgroundTransparency = 0.5
	bg.ImageTransparency = 0
	TweenService:Create(flash,tweenInfo,{BackgroundTransparency=1}):Play()
	TweenService:Create(bg,tweenInfo,{ImageTransparency=1}):Play()
	soundKamui:Play()
end

local function goToKamui()
	local char = player.Character or player.CharacterAdded:Wait()
	local humanoid = char:WaitForChild("Humanoid")
	local hrp = char:WaitForChild("HumanoidRootPart")
	if IN_KAMUI then return end
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
	end)
end

local function leaveKamui()
	local char = player.Character or player.CharacterAdded:Wait()
	local humanoid = char:WaitForChild("Humanoid")
	local hrp = char:WaitForChild("HumanoidRootPart")
	if not IN_KAMUI then return end
	playWindup(char, humanoid, hrp, function()
		warpEffect(function()
			restoreNormalLighting()
			if RETURN_POSITION then hrp.CFrame = RETURN_POSITION end
			kamuiMusic:Stop()
			kamuisharingan()
		end)
		IN_KAMUI = false
	end)
end

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
	end
end

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 150)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -75)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.Active = true

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
title.BorderSizePixel = 0
title.Text = "Kamui & Trono"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Parent = mainFrame

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton.BorderSizePixel = 0
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 18
closeButton.Parent = mainFrame
closeButton.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

local kamuiButton = Instance.new("TextButton")
kamuiButton.Size = UDim2.new(0, 100, 0, 40)
kamuiButton.Position = UDim2.new(0.5, -50, 0.4, -20)
kamuiButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
kamuiButton.BorderSizePixel = 0
kamuiButton.Text = "Kamui"
kamuiButton.TextColor3 = Color3.fromRGB(255, 255, 255)
kamuiButton.Font = Enum.Font.SourceSansBold
kamuiButton.TextSize = 16
kamuiButton.Parent = mainFrame
kamuiButton.MouseButton1Click:Connect(function()
	if IN_KAMUI then
		leaveKamui()
	else
		goToKamui()
	end
end)

local throneButton = Instance.new("TextButton")
throneButton.Size = UDim2.new(0, 100, 0, 40)
throneButton.Position = UDim2.new(0.5, -50, 0.7, -20)
throneButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
throneButton.BorderSizePixel = 0
throneButton.Text = "Trono"
throneButton.TextColor3 = Color3.fromRGB(255, 255, 255)
throneButton.Font = Enum.Font.SourceSansBold
throneButton.TextSize = 16
throneButton.Parent = mainFrame
throneButton.MouseButton1Click:Connect(toggleThrone)

local dragging = false
local dragInput
local dragStart
local startPos

local function update(input)
	local delta = input.Position - dragStart
	mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
								   startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

mainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

mainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)