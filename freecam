local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")

while not Players.LocalPlayer or not Players.LocalPlayer:FindFirstChild("PlayerScripts") do
    RunService.Heartbeat:Wait()
end

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled

local ControlModule
pcall(function()
    ControlModule = require(LocalPlayer.PlayerScripts:WaitForChild("PlayerModule")):GetControls()
end)

-- ========== GLOBAL STATE ==========
local freecamEnabled = false
local cameraSpeed = 1.0
local walkSpeed = 16
local lookSensitivity = 50
local isMovingUp_Mobile, isMovingDown_Mobile = false, false
local cameraRotation = Vector2.new()
local isInteractingWithGUI = false
local lookInput = nil
local guiHidden = false
local mouseLocked = true 
local minimized = false

-- Backup Lighting
local originalLighting = {
    Time = Lighting.ClockTime,
    Brightness = Lighting.Brightness,
    FogEnd = Lighting.FogEnd
}

local freecamConnection = nil
local createdObjects = {} 

-- ========== VIGNETTE SYSTEM ==========
local vignetteLayer = nil
local vignetteImage = nil

local function createVignetteOverlay()
    if CoreGui:FindFirstChild("VcineVignetteGui") then CoreGui.VcineVignetteGui:Destroy() end

    vignetteLayer = Instance.new("ScreenGui")
    vignetteLayer.Name = "VcineVignetteGui"
    vignetteLayer.Parent = CoreGui
    vignetteLayer.IgnoreGuiInset = true
    vignetteLayer.ResetOnSpawn = false
    vignetteLayer.Enabled = false
    table.insert(createdObjects, vignetteLayer)

    vignetteImage = Instance.new("ImageLabel")
    vignetteImage.Parent = vignetteLayer
    vignetteImage.Size = UDim2.new(1, 0, 1, 0)
    vignetteImage.BackgroundTransparency = 1
    vignetteImage.Image = "rbxassetid://4576475446"
    vignetteImage.ImageColor3 = Color3.new(0, 0, 0)
    vignetteImage.ImageTransparency = 0.3
    vignetteImage.ZIndex = 0
end

local function updateVignette(val)
    if not vignetteLayer then createVignetteOverlay() end
    if val > 0 then
        vignetteLayer.Enabled = true
        vignetteImage.ImageTransparency = 1 - (val / 100)
    else
        vignetteLayer.Enabled = false
    end
end

-- ========== CORE FUNCTIONS ==========
local function safeDestroy(obj)
    if obj and obj.Parent then obj:Destroy() end
end

local function cleanup()
    if freecamConnection then
        freecamConnection:Disconnect()
        freecamConnection = nil
    end
    
    pcall(function()
        if CoreGui:FindFirstChild("VcineControlGui") then CoreGui.VcineControlGui:Destroy() end
        if CoreGui:FindFirstChild("VcineUtilityGui") then CoreGui.VcineUtilityGui:Destroy() end
        if CoreGui:FindFirstChild("VcineVignetteGui") then CoreGui.VcineVignetteGui:Destroy() end
    end)
    
    Camera.CameraType = Enum.CameraType.Custom
    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
    
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
    
    Lighting.ClockTime = originalLighting.Time
    Lighting.Brightness = originalLighting.Brightness
    Lighting.FogEnd = originalLighting.FogEnd
    
    for _, obj in ipairs(createdObjects) do
        pcall(safeDestroy, obj)
    end
    table.clear(createdObjects)
end

local function getLightingEffect(className, name)
    local effect = Lighting:FindFirstChild(name)
    if not effect then
        effect = Instance.new(className)
        effect.Name = name
        effect.Parent = Lighting
        effect.Enabled = false
        table.insert(createdObjects, effect)
    end
    return effect
end

local function toggleChatUI(hide)
    pcall(function() StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, not hide) end)
end

local function updateFreecam(dt)
    if not freecamEnabled then return end
    
    if mouseLocked and not isInteractingWithGUI then
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
    else
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    end
    
    local moveSpeed = cameraSpeed * 50 
    local moveVector = Vector3.new()

    if ControlModule then moveVector = ControlModule:GetMoveVector() end

    if isMobile then
        if isMovingUp_Mobile then moveVector += Vector3.new(0, 1, 0) end
        if isMovingDown_Mobile then moveVector += Vector3.new(0, -1, 0) end
    else
        if UserInputService:IsKeyDown(Enum.KeyCode.E) then moveVector += Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.Q) then moveVector += Vector3.new(0, -1, 0) end
    end
    
    local canRotate = (not isInteractingWithGUI) and mouseLocked
    if isMobile then canRotate = (lookInput ~= nil) end 

    if canRotate then
        local mouseDelta = UserInputService:GetMouseDelta()
        local sensitivity = lookSensitivity * 0.004
        cameraRotation += Vector2.new(-math.rad(mouseDelta.Y * sensitivity), -math.rad(mouseDelta.X * sensitivity))
        cameraRotation = Vector2.new(math.clamp(cameraRotation.X, -math.pi/2, math.pi/2), cameraRotation.Y)
    end
    
    local rotation = CFrame.fromEulerAnglesYXZ(cameraRotation.X, cameraRotation.Y, 0)
    local position = Camera.CFrame.Position
    
    if moveVector.Magnitude > 0.01 then
        position += rotation:VectorToWorldSpace(moveVector.Unit) * moveSpeed * dt
    end
    
    Camera.CFrame = CFrame.new(position) * rotation
end

local function toggleFreecam(enable, mobileBtns)
    freecamEnabled = enable
    if enable then
        local _, y, x = Camera.CFrame:toEulerAnglesYXZ()
        cameraRotation = Vector2.new(x, y)
        Camera.CameraType = Enum.CameraType.Scriptable
        mouseLocked = true
        freecamConnection = RunService.RenderStepped:Connect(updateFreecam)
        if isMobile and mobileBtns then for _, btn in pairs(mobileBtns) do btn.Visible = true end end
    else
        if freecamConnection then freecamConnection:Disconnect(); freecamConnection = nil end
        Camera.CameraType = Enum.CameraType.Custom
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        if isMobile and mobileBtns then
            for _, btn in pairs(mobileBtns) do btn.Visible = false end
            isMovingUp_Mobile = false; isMovingDown_Mobile = false; lookInput = nil
        end
    end
end

-- ========== SETTERS ==========
local function setWalkspeed(val)
    walkSpeed = tonumber(val) or 16
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = walkSpeed
    end
end

local function setCameraSpeed(val)
    cameraSpeed = math.max(0, tonumber(val) or 1)
end

-- Visual Effects
local function updateBloom(val)
    local bloom = getLightingEffect("BloomEffect", "VCine_Bloom")
    if val > 0 then
        bloom.Enabled = true
        bloom.Intensity = (val / 100) * 1.5
        bloom.Size = 24 + ((val/100)*30)
    else
        bloom.Enabled = false
    end
end

local function updateSunRays(val)
    local rays = getLightingEffect("SunRaysEffect", "VCine_SunRays")
    if val > 0 then
        rays.Enabled = true
        rays.Intensity = (val / 100) * 0.5
        rays.Spread = (val / 100)
    else
        rays.Enabled = false
    end
end

local function updateColorCorrection(sat, cont)
    local cc = getLightingEffect("ColorCorrectionEffect", "VCine_CC")
    cc.Enabled = true
    if sat then cc.Saturation = (sat - 50) / 50 end 
    if cont then cc.Contrast = (cont - 50) / 100 end
end

local dofSettings = {Dist = 100, Radius = 30, Near = 0, Far = 0}
local function updateDoF()
    local dof = getLightingEffect("DepthOfFieldEffect", "VCine_DoF")
    local active = (dofSettings.Near > 0 or dofSettings.Far > 0 or dofSettings.Radius < 50)
    dof.Enabled = active
    
    if active then
        dof.FocusDistance = dofSettings.Dist
        dof.InFocusRadius = dofSettings.Radius
        
        dof.NearIntensity = (dofSettings.Near / 100) * 1.5 
        dof.FarIntensity = (dofSettings.Far / 100) * 3     
    end
end

-- ========== GUI CREATION ==========
local function createMainGUI()
    cleanup()
    createVignetteOverlay()

    local controlGui = Instance.new("ScreenGui"); controlGui.Name = "VcineControlGui"; controlGui.Parent = CoreGui; controlGui.ResetOnSpawn = false
    table.insert(createdObjects, controlGui)
    local utilityGui = Instance.new("ScreenGui"); utilityGui.Name = "VcineUtilityGui"; utilityGui.Parent = CoreGui; utilityGui.ResetOnSpawn = false
    table.insert(createdObjects, utilityGui)
    
    local mainFrame = Instance.new("Frame")
    local originalSize = UDim2.new(0, 320, 0, 520)
    mainFrame.Size = originalSize; mainFrame.Position = UDim2.new(0, 20, 0.5, -260)
    mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18); mainFrame.BorderSizePixel = 0
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)
    mainFrame.ClipsDescendants = true; mainFrame.Parent = controlGui

    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40); titleBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10); titleBar.Parent = mainFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = "Vcine - v2"; titleLabel.Font = Enum.Font.GothamBlack; titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Size = UDim2.new(1, -90, 1, 0); titleLabel.Position = UDim2.new(0, 15, 0, 0); titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.BackgroundTransparency = 1; titleLabel.TextSize = 16; titleLabel.Parent = titleBar

    -- Window Controls
    local function makeWinBtn(txt, col, off, cb)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 40, 1, 0); b.Position = UDim2.new(1, off, 0, 0)
        b.BackgroundColor3 = col; b.Text = txt; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold
        b.Parent = titleBar; b.MouseButton1Click:Connect(cb)
    end
    makeWinBtn("X", Color3.fromRGB(200, 40, 40), -40, function() cleanup(); script:Destroy() end)
    makeWinBtn("_", Color3.fromRGB(40, 40, 40), -80, function()
        minimized = not minimized
        mainFrame:TweenSize(minimized and UDim2.new(0, 320, 0, 40) or originalSize, "Out", "Quad", 0.3, true)
    end)

    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Size = UDim2.new(1, 0, 1, -40); contentFrame.Position = UDim2.new(0, 0, 0, 40)
    contentFrame.BackgroundTransparency = 1; contentFrame.BorderSizePixel = 0; contentFrame.ScrollBarThickness = 4
    contentFrame.Parent = mainFrame

    -- Dragging
    local isDragging, dragStart, startPos
    titleBar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then isDragging=true; dragStart=i.Position; startPos=mainFrame.Position end end)
    UserInputService.InputChanged:Connect(function(i) if isDragging and i.UserInputType == Enum.UserInputType.MouseMovement then local d=i.Position-dragStart; mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+d.X, startPos.Y.Scale, startPos.Y.Offset+d.Y) end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then isDragging=false end end)

    -- Mobile Toggle
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 40, 0, 40); toggleBtn.Position = UDim2.new(1, -50, 0, 10)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30); toggleBtn.BackgroundTransparency = 0.3
    toggleBtn.Text = "UI"; toggleBtn.TextColor3 = Color3.new(1,1,1); toggleBtn.Font = Enum.Font.GothamBold; toggleBtn.Parent = utilityGui
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 8)
    toggleBtn.MouseButton1Click:Connect(function() mainFrame.Visible = not mainFrame.Visible end)
    
    local mobileBtns = {}
    if isMobile then
        local function mb(txt, pos, down, up)
            local b = Instance.new("TextButton"); b.Size = UDim2.new(0,50,0,50); b.Position = pos; b.Text=txt; b.BackgroundTransparency=0.5; b.BackgroundColor3=Color3.new(0,0,0); b.TextColor3=Color3.new(1,1,1); b.Visible=false; b.Parent=utilityGui; b.InputBegan:Connect(down); b.InputEnded:Connect(up)
            Instance.new("UICorner", b).CornerRadius = UDim.new(1,0); table.insert(mobileBtns, b)
        end
        mb("Up", UDim2.new(1,-60,1,-140), function() isMovingUp_Mobile=true end, function() isMovingUp_Mobile=false end)
        mb("Down", UDim2.new(1,-60,1,-80), function() isMovingDown_Mobile=true end, function() isMovingDown_Mobile=false end)
    end

    local yOff = 10
    local function header(txt)
        local l = Instance.new("TextLabel"); l.Size = UDim2.new(1,-20,0,25); l.Position = UDim2.new(0,10,0,yOff); l.BackgroundTransparency=1; l.Text=txt; l.Font=Enum.Font.GothamBlack; l.TextColor3=Color3.fromRGB(0, 150, 255); l.TextXAlignment=Enum.TextXAlignment.Left; l.TextSize=14; l.Parent=contentFrame; yOff=yOff+30
    end

    local function createHybrid(title, min, max, default, callback, decimalPlaces)
        decimalPlaces = decimalPlaces or 0
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, -20, 0, 50)
        container.Position = UDim2.new(0, 10, 0, yOff)
        container.BackgroundTransparency = 1
        container.Parent = contentFrame

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.6, 0, 0, 20); label.Position = UDim2.new(0, 0, 0, 0); label.BackgroundTransparency = 1; label.Text = title; label.TextColor3 = Color3.fromRGB(220, 220, 220); label.Font = Enum.Font.Gotham; label.TextXAlignment = Enum.TextXAlignment.Left; label.TextSize = 13; label.Parent = container

        local inputBox = Instance.new("TextBox")
        inputBox.Size = UDim2.new(0.3, 0, 0, 20); inputBox.Position = UDim2.new(0.7, 0, 0, 0); inputBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40); inputBox.TextColor3 = Color3.fromRGB(255, 255, 255); inputBox.Text = string.format("%."..decimalPlaces.."f", default); inputBox.Font = Enum.Font.GothamBold; inputBox.TextSize = 12; inputBox.Parent = container
        Instance.new("UICorner", inputBox).CornerRadius = UDim.new(0, 4)

        local track = Instance.new("Frame")
        track.Size = UDim2.new(1, 0, 0, 6); track.Position = UDim2.new(0, 0, 0, 30); track.BackgroundColor3 = Color3.fromRGB(50, 50, 50); track.Parent = container
        Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

        local fill = Instance.new("Frame")
        fill.Size = UDim2.new(math.clamp((default - min) / (max - min), 0, 1), 0, 1, 0); fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255); fill.BorderSizePixel = 0; fill.Parent = track
        Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

        local function updateValue(val)
            val = math.clamp(val, min, max)
            local percent = (val - min) / (max - min)
            fill.Size = UDim2.new(percent, 0, 1, 0)
            inputBox.Text = string.format("%."..decimalPlaces.."f", val)
            if callback then callback(val) end
        end

        local sliderBtn = Instance.new("TextButton")
        sliderBtn.Size = UDim2.new(1, 0, 2, 0); sliderBtn.Position = UDim2.new(0, 0, -0.5, 0); sliderBtn.BackgroundTransparency = 1; sliderBtn.Text = ""; sliderBtn.Parent = track
        
        local dragging = false
        local function moveSlider(input)
            local pos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            updateValue(min + (max - min) * pos)
        end

        sliderBtn.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then dragging=true; isInteractingWithGUI=true; moveSlider(inp) end end)
        UserInputService.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then dragging=false; isInteractingWithGUI=false end end)
        UserInputService.InputChanged:Connect(function(inp) if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then moveSlider(inp) end end)
        
        inputBox.FocusLost:Connect(function() 
            local num = tonumber(inputBox.Text)
            if num then 
                updateValue(num) 
            else 
                inputBox.Text = string.format("%."..decimalPlaces.."f", (min + (max-min) * (fill.Size.X.Scale))) 
            end 
        end)

        yOff = yOff + 55
    end

    local function createToggle(title, default, cb)
        local b = Instance.new("TextButton"); b.Size=UDim2.new(1,-20,0,25); b.Position=UDim2.new(0,10,0,yOff); b.BackgroundColor3=default and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(50,50,50); b.Text=title; b.TextColor3=Color3.new(1,1,1); b.Font=Enum.Font.GothamMedium; b.TextSize=12; b.Parent=contentFrame; Instance.new("UICorner", b).CornerRadius=UDim.new(0,4)
        b.MouseButton1Click:Connect(function() default=not default; b.BackgroundColor3=default and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(50,50,50); if cb then cb(default) end end)
        yOff = yOff + 35
    end
    
    header("PLAYER & CAMERA")
    createToggle("Enable Freecam", freecamEnabled, function(v) toggleFreecam(v, mobileBtns) end)
    
    createHybrid("Cam Speed (0.1 - 50)", 0, 50, cameraSpeed, setCameraSpeed, 3)
    createHybrid("Walk Speed", 0, 100, walkSpeed, setWalkspeed, 0)
    createHybrid("Look Sensitivity", 1, 200, lookSensitivity, function(v) lookSensitivity = v end, 0)
    createHybrid("Field of View (FOV)", 1, 120, Camera.FieldOfView, function(v) pcall(function() Camera.FieldOfView=v end) end, 0)

    header("FOCUS / DEPTH OF FIELD")
    createHybrid("Focus Distance", 0, 500, dofSettings.Dist, function(v) dofSettings.Dist = v; updateDoF() end, 1)
    createHybrid("Focus Radius", 0, 100, dofSettings.Radius, function(v) dofSettings.Radius = v; updateDoF() end, 1)
    createHybrid("Blur Near (Dekat)", 0, 100, dofSettings.Near, function(v) dofSettings.Near = v; updateDoF() end, 0)
    createHybrid("Blur Far (Jauh)", 0, 100, dofSettings.Far, function(v) dofSettings.Far = v; updateDoF() end, 0)

    header("COLOR GRADING")
    local curSat, curCont = 50, 50
    createHybrid("Saturation", 0, 100, 50, function(v) curSat = v; updateColorCorrection(curSat, curCont) end, 0)
    createHybrid("Contrast", 0, 100, 50, function(v) curCont = v; updateColorCorrection(curSat, curCont) end, 0)
    createHybrid("Brightness", 0, 100, Lighting.Brightness * 20, function(v) Lighting.Brightness = (v/100)*5 end, 0)
    createHybrid("Time of Day", 0, 24, Lighting.ClockTime, function(v) Lighting.ClockTime = v end, 1)

    header("EFFECTS & TOOLS")
    createHybrid("Bloom Intensity", 0, 100, 0, function(v) updateBloom(v) end, 0)
    createHybrid("Sun Rays", 0, 100, 0, function(v) updateSunRays(v) end, 0)
    
    createHybrid("Vignette Intensity", 0, 100, 0, function(v) updateVignette(v) end, 0)
    createToggle("Hide Chat", false, toggleChatUI)
    
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, yOff + 50)
    
    pcall(function()
        StarterGui:SetCore("SendNotification", {Title = "Vcine v2", Text = "Script by VLine | thanks for using this script", Duration = 5})
        delay(2, function() StarterGui:SetCore("SendNotification", {Title = "Feedback", Text = "Give feedback in scriptblox.com", Duration = 10}) end)
    end)
    
    UserInputService.InputBegan:Connect(function(input, gp)
        if input.KeyCode == Enum.KeyCode.F2 then
            mouseLocked = not mouseLocked
            if not freecamEnabled then
                UserInputService.MouseBehavior = mouseLocked and Enum.MouseBehavior.LockCenter or Enum.MouseBehavior.Default
            end
        elseif input.KeyCode == Enum.KeyCode.LeftAlt then
            guiHidden = not guiHidden
            controlGui.Enabled = not guiHidden; utilityGui.Enabled = not guiHidden; vignetteLayer.Enabled = (not guiHidden and vignetteImage.ImageTransparency < 1)
        end
    end)
end

-- Mobile Look Logic
UserInputService.InputBegan:Connect(function(input)
    if isMobile and freecamEnabled and input.UserInputType == Enum.UserInputType.Touch and input.Position.X > Camera.ViewportSize.X/2 then lookInput = input end
end)
UserInputService.InputEnded:Connect(function(input) if isMobile and input == lookInput then lookInput = nil end end)

createMainGUI()
