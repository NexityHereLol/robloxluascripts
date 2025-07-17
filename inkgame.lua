local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/NexityHereLol/skidware/refs/heads/main/lib_extension.lua"))()
local int = lib:CreateInterface("HongSengYongFromDaSquidGame🦑", "center")
local plr = int:CreateTab("player")
local misc = int:CreateTab("misc")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- === Player Sliders ===

-- JumpPower Slider
plr:CreateSlider("jumppower", 200, 50, function(value)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.JumpPower = value
    end
end)

-- WalkSpeed Slider with Persistent Behavior
plr:CreateSlider("walkspeed", 200, 16, function(value)
    _G.HackedWalkSpeed = value

    local function applyWalkSpeed(humanoid)
        if humanoid then
            humanoid.WalkSpeed = _G.HackedWalkSpeed
            humanoid.Changed:Connect(function(property)
                if property == "WalkSpeed" and humanoid.WalkSpeed ~= _G.HackedWalkSpeed then
                    humanoid.WalkSpeed = _G.HackedWalkSpeed
                end
            end)
        end
    end

    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        applyWalkSpeed(LocalPlayer.Character.Humanoid)
    end

    LocalPlayer.CharacterAdded:Connect(function(char)
        char:WaitForChild("Humanoid")
        applyWalkSpeed(char:FindFirstChild("Humanoid"))
    end)
end)

plr:CreateCheckBox("walkspeed toggle (50)",function(toggle)
    if toggle == true then 
    _G.HackedWalkSpeed = 50
        else
    _G.HackedWalkSpeed = 16
    end

    local function applyWalkSpeed(humanoid)
        if humanoid then
            humanoid.WalkSpeed = _G.HackedWalkSpeed
            humanoid.Changed:Connect(function(property)
                if property == "WalkSpeed" and humanoid.WalkSpeed ~= _G.HackedWalkSpeed then
                    humanoid.WalkSpeed = _G.HackedWalkSpeed
                end
            end)
        end
    end

    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        applyWalkSpeed(LocalPlayer.Character.Humanoid)
    end

    LocalPlayer.CharacterAdded:Connect(function(char)
        char:WaitForChild("Humanoid")
        applyWalkSpeed(char:FindFirstChild("Humanoid"))
    end)
end)

--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

--// CONFIG
local espTransparency = 0.4
local teamCheck = true

--// CUSTOM FONT
local customFont = Font.new("rbxassetid://16658246179", Enum.FontWeight.Regular, Enum.FontStyle.Normal)

--// STATE
local BillboardESPs = {}
local ChamsESPs = {}
local ESPConnections = {}

local ESPEnabled = false
local ChamsEnabled = false

--// HELPERS
local function round(num, decimals)
	return tonumber(string.format("%." .. (decimals or 0) .. "f", num))
end

local function getRoot(char)
	return char and char:FindFirstChild("HumanoidRootPart")
end

--// BILLBOARD ESP
local function createBillboardESP(plr)
	if BillboardESPs[plr] or plr == LocalPlayer then return end
	if not plr.Character or not plr.Character:FindFirstChild("Head") then return end

	local gui = Instance.new("BillboardGui")
	gui.Name = "Billboard_ESP"
	gui.Adornee = plr.Character.Head
	gui.Parent = plr.Character.Head
	gui.Size = UDim2.new(0, 100, 0, 40)
	gui.AlwaysOnTop = true
	gui.StudsOffset = Vector3.new(0, 2, 0)

	local label = Instance.new("TextLabel", gui)
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextStrokeTransparency = 0.5
	label.TextScaled = true
	label.FontFace = customFont

	local conn
	conn = RunService.RenderStepped:Connect(function()
		if not plr.Character or not plr.Character:FindFirstChild("Humanoid") then
			gui:Destroy()
			if conn then conn:Disconnect() end
			BillboardESPs[plr] = nil
			ESPConnections[plr] = nil
			return
		end

		local hp = math.floor(plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth * 100)
		label.Text = plr.Name .. " | " .. hp .. "%"
	end)

	BillboardESPs[plr] = gui
	ESPConnections[plr] = conn
end

--// CHAMS ESP (BoxHandleAdornment)
local function createChamsESP(plr)
	if ChamsESPs[plr] or plr == LocalPlayer then return end
	if not plr.Character or not getRoot(plr.Character) then return end

	local folder = Instance.new("Folder")
	folder.Name = "Chams_ESP"
	folder.Parent = CoreGui
	ChamsESPs[plr] = folder

	for _, part in pairs(plr.Character:GetChildren()) do
		if part:IsA("BasePart") then
			local box = Instance.new("BoxHandleAdornment")
			box.Name = "Cham_" .. plr.Name
			box.Adornee = part
			box.AlwaysOnTop = true
			box.ZIndex = 10
			box.Size = part.Size
			box.Transparency = espTransparency
			box.Color = BrickColor.new(
				teamCheck and (plr.TeamColor == LocalPlayer.TeamColor and "Bright green" or "Bright red") or tostring(plr.TeamColor)
			)
			box.Parent = folder
		end
	end
end

--// CLEANUP FUNCTIONS
local function cleanupBillboardESP()
	for _, gui in pairs(BillboardESPs) do
		if gui then gui:Destroy() end
	end
	for _, conn in pairs(ESPConnections) do
		if conn then conn:Disconnect() end
	end
	BillboardESPs = {}
	ESPConnections = {}
end

local function cleanupChamsESP()
	for _, folder in pairs(ChamsESPs) do
		if folder then folder:Destroy() end
	end
	ChamsESPs = {}
end

--// INITIALIZATION HANDLER
local function handlePlayerESP(plr)
	if ESPEnabled then createBillboardESP(plr) end
	if ChamsEnabled then createChamsESP(plr) end

	plr.CharacterAdded:Connect(function()
		task.wait(1)
		if ESPEnabled then createBillboardESP(plr) end
		if ChamsEnabled then createChamsESP(plr) end
	end)
end

--// GUI TOGGLES (INTEGRATE INTO YOUR UI)
misc:CreateCheckBox("ESP", function(state)
	ESPEnabled = state
	if not state then
		cleanupBillboardESP()
	else
		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer then
				createBillboardESP(plr)
			end
		end
	end
end)

misc:CreateCheckBox("Chams", function(state)
	ChamsEnabled = state
	if not state then
		cleanupChamsESP()
	else
		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer then
				createChamsESP(plr)
			end
		end
	end
end)

--// INIT ON CURRENT PLAYERS
for _, plr in pairs(Players:GetPlayers()) do
	if plr ~= LocalPlayer then
		handlePlayerESP(plr)
	end
end

Players.PlayerAdded:Connect(function(plr)
	handlePlayerESP(plr)
end)

--// FOV CIRCLE
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Transparency = 1
FOVCircle.Thickness = 1
FOVCircle.Filled = false
FOVCircle.ZIndex = 2

local FOVRadius = 100

RunService.RenderStepped:Connect(function()
	if FOVCircle.Visible then
		FOVCircle.Radius = FOVRadius
		FOVCircle.Position = UserInputService:GetMouseLocation()
	end
end)

misc:CreateCheckBox("FOV Circle", function(state)
	FOVCircle.Visible = state
end)


-- coords

-- Utility to convert "x, y, z" string to CFrame
local function stringToCFrame(str)
    local x, y, z = str:match("([^,]+),%s*([^,]+),%s*([^,]+)")
    return CFrame.new(tonumber(x), tonumber(y), tonumber(z))
end

-- Teleport function with optional tween duration
local function teleportToTarget(cf, duration)
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if duration and duration > 0 then
        local ts = game:GetService("TweenService")
        local info = TweenInfo.new(duration, Enum.EasingStyle.Linear)
        local goal = { CFrame = cf }
        local tween = ts:Create(hrp, info, goal)
        tween:Play()
    else
        hrp.CFrame = cf
    end
end

-- Ordered list of story-related teleports
local storyCoords = {
    { "[safe space] safe space", "197, 123, -186"},
    { "[1st game] beat first game", "-46, 1025, 137" },
  --  { "[1st game] tp back beginning", "-51, 1032, -558"},
  --  { "[1st game] tp house", "-212, 1061, 132" },
  --  { "[1st game] tp house 2", "110, 1060, 119" },
  --  { "[1st game] tp tree top", "-42, 1092, 126" },
  --  { "[after 1st] taking photo", "-209, 187, 339" },
  --  { "[after 1st] after taking photo", "-234, 232, 408" },
  --  { "[2nd game] hide n seek escape", "55, 1053, 67"},
    { "[pvp] lights out safespace", "197, 91, -91" },
    { "[glass game] glass ending", "-207, 522, -1534" },
}

-- Create dropdown for story teleports
local storyDropdown = misc:CreateDropDown("teleports", function() end)
for _, entry in ipairs(storyCoords) do
    local name, coord = entry[1], entry[2]
    storyDropdown:AddButton(name, function()
        teleportToTarget(stringToCFrame(coord), 0.1)
    end)
end

-- coords

-- kill aura 

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Configuration
local checkRadius = 25 -- Radius in studs to check for nearby players
local tweenTime = 0.001 -- Time in seconds for fast tweening to the target player
local orbitRadius = 3 -- Radius of the orbit
local orbitSpeed = 10000 -- Orbit speed in degrees per second

-- Initialize global control variable
_G.spam = false -- Default to false to prevent initial execution

local player = Players.LocalPlayer
local orbitConnection -- To store the connection for orbiting
local previousPlayer -- To track the previously targeted player

-- Function to move to a target player using TweenService
local function tweenToPlayer(character, targetPlayer)
    if not _G.spam then return false end -- Check if spam is enabled

    if character and targetPlayer and targetPlayer.Character then
        local targetRootPart = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        local characterRootPart = character:FindFirstChild("HumanoidRootPart")

        if targetRootPart and characterRootPart then
            local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
            local goal = {CFrame = targetRootPart.CFrame}
            local tween = TweenService:Create(characterRootPart, tweenInfo, goal)
            tween:Play()
            tween.Completed:Wait()
            return true
        end
    end
    return false
end

-- Function to get the closest player within the specified radius,
-- with conditional team check
local function getNearbyPlayer(character, radius)
    local closestPlayer = nil
    local characterRoot = character:FindFirstChild("HumanoidRootPart")
    if not characterRoot then return nil end
    local characterPosition = characterRoot.Position

    local localTeam = player.Team
    local teamsEnabled = localTeam ~= nil

    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p ~= player then
            -- If teams exist, skip players on the same team
            if not teamsEnabled or (teamsEnabled and p.Team ~= localTeam) then
                local playerPosition = p.Character.HumanoidRootPart.Position
                local dist = (playerPosition - characterPosition).magnitude
                if dist <= radius then
                    closestPlayer = p
                    break
                end
            end
        end
    end

    return closestPlayer
end

local function orbitAroundPlayer(character, targetPlayer)
    if not _G.spam then return end
    local targetRootPart = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRootPart then return end

    local angle = 0
    if orbitConnection then
        orbitConnection:Disconnect()
    end

    orbitConnection = RunService.RenderStepped:Connect(function(deltaTime)
        if not (_G.spam and character and targetPlayer and targetPlayer.Character) then
            orbitConnection:Disconnect()
            return
        end

        local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then
            previousPlayer = nil
            orbitConnection:Disconnect()
            return
        end

        local radian = math.rad(angle)
        local x = orbitRadius * math.cos(radian)
        local z = orbitRadius * math.sin(radian)

        local targetPos = targetRootPart.Position
        local newPosition = targetPos + Vector3.new(x, 0, z)

        -- Keep player's height level consistent
        local currentY = character.HumanoidRootPart.Position.Y
        character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(newPosition.X, currentY, newPosition.Z))

        angle = angle + orbitSpeed * deltaTime
        if angle >= 360 then
            angle = angle - 360
        end
    end)
end

-- Behavior based on spam flag
local function startBehavior()
    if not _G.spam then return end

    local currentCharacter = player.Character
    if not currentCharacter then return end

    -- If we already have a valid target, continue with them
    if previousPlayer and previousPlayer.Character then
        local humanoid = previousPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.Health > 0 then
            -- Already orbiting, no need to switch
            return
        else
            previousPlayer = nil -- Target is dead, allow switching
            if orbitConnection then
                orbitConnection:Disconnect()
                orbitConnection = nil
            end
        end
    end

    -- Only find a new target if we don't have one
    local newTarget = getNearbyPlayer(currentCharacter, checkRadius)
    if newTarget and newTarget ~= previousPlayer then
        local tweenDone = tweenToPlayer(currentCharacter, newTarget)
        if tweenDone then
            orbitAroundPlayer(currentCharacter, newTarget)
            previousPlayer = newTarget
        end
    end
end

-- Continuously check for new players and start behavior
local function checkAndOrbit()
    while _G.spam do
        startBehavior()
        wait(0.001)
    end

    if orbitConnection then
        orbitConnection:Disconnect()
    end
end

-- auto trace

misc:CreateButton("Auto Beat Dalgona", function()
    local Players = game:GetService("Players")
    local camera = workspace.CurrentCamera
    local vim = game:GetService("VirtualInputManager")

    local player = Players.LocalPlayer
    local outlinesFolder = workspace.Effects
    local outlinesNames = {
        "UmbrellaOutline",
        "CircleOutline",
        "TriangleOutline",
        "MonalisaOutline",
        "SackBoyOutline",
        "StarOutline"
    }

    local traceSpeed = 0.02 -- speed between parts
    local clickRepeats = 3   -- clicks per part
    local clickGap = 0   -- speed between repeated clicks

    local function worldToScreenPoint(worldPos)
        local screenPoint, onScreen = camera:WorldToViewportPoint(worldPos)
        return Vector2.new(screenPoint.X, screenPoint.Y), onScreen
    end

    local function getSortedParts(model)
        local parts = {}
        for _, obj in ipairs(model:GetChildren()) do
            if obj:IsA("BasePart") then
                table.insert(parts, obj)
            end
        end
        table.sort(parts, function(a, b)
            return a.Name < b.Name
        end)
        return parts
    end

    local function clickAtScreenPos(pos2d)
        for i = 1, clickRepeats do
            vim:SendMouseButtonEvent(pos2d.X, pos2d.Y, 0, true, game, 0)
            wait(clickGap)
            vim:SendMouseButtonEvent(pos2d.X, pos2d.Y, 0, false, game, 0)
            print(("[AutoTrace] Click %d at (%.2f, %.2f)"):format(i, pos2d.X, pos2d.Y))
        end
    end

    local function traceModel(model)
        local parts = getSortedParts(model)
        for _, part in ipairs(parts) do
            local screenPos, onScreen = worldToScreenPoint(part.Position)
            if onScreen then
                clickAtScreenPos(screenPos)
                wait(traceSpeed)
            else
                print("[AutoTrace] Skipped offscreen part:", part.Name)
            end
        end
    end

    print("[AutoTrace] Starting...")

    for _, outlineName in ipairs(outlinesNames) do
        local model = outlinesFolder:FindFirstChild(outlineName)
        if model and model:IsA("Model") then
            print("[AutoTrace] Tracing:", outlineName)
            traceModel(model)
        else
            warn("[AutoTrace] Not found:", outlineName)
        end
    end

    print("[AutoTrace] Done.")
end)

-- auto trace


-- Checkbox to toggle killaura with conditional team check
misc:CreateCheckBox("killaura (team check if available)", function(state)
    _G.spam = state
    if state then
        previousPlayer = nil
        task.spawn(checkAndOrbit)
    else
        if orbitConnection then
            orbitConnection:Disconnect()
        end
    end
end)


-- kill aura

-- hitbox

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local plr = Players.LocalPlayer

local toggle = false
local size = 5 -- fixed hitbox size

misc:CreateCheckBox("Toggle Hitbox Extender", function(state)
    toggle = state
    if not toggle then
        -- Reset all players when disabled
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= plr and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = player.Character.HumanoidRootPart
                hrp.Size = Vector3.new(2, 2, 1) -- default size, adjust if your game uses something else
                hrp.Transparency = 0
                hrp.BrickColor = BrickColor.new("Medium stone grey")
                hrp.Material = Enum.Material.Plastic
                hrp.CanCollide = true
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if toggle then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= plr and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = player.Character.HumanoidRootPart
                hrp.Size = Vector3.new(size, size, size)
                hrp.Transparency = 0.7
                hrp.BrickColor = BrickColor.new("Really black")
                hrp.Material = Enum.Material.Neon
                hrp.CanCollide = false
            end
        end
    end
end)


-- hitbox


-- extra scripts

local civDropdown2 = misc:CreateDropDown("extra scripts", function() end)

civDropdown2:AddButton("infinite yield",function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

-- extra scripts
