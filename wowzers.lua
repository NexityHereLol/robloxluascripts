local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/NexityHereLol/skidware/refs/heads/main/lib_extension.lua"))()
local int = lib:CreateInterface("ink🦑: " .. tostring(game.Players.LocalPlayer), "center")
local plr = int:CreateTab("player")
local misc = int:CreateTab("misc")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- === Player Sliders ===

-- JumpPower Slider
plr:CreateSlider("jumppower", 500, 50, function(value)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.JumpPower = value
    end
end)

-- WalkSpeed Slider with Persistent Behavior
plr:CreateSlider("walkspeed", 500, 16, function(value)
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
local storyDropdown = misc:CreateDropDown("Teleports", function() end)
for _, entry in ipairs(storyCoords) do
    local name, coord = entry[1], entry[2]
    storyDropdown:AddButton(name, function()
        teleportToTarget(stringToCFrame(coord), 0.1)
    end)
end

-- coords

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
    local clickRepeats = 10   -- clicks per part
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


-- kill aura

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Configuration
local checkRadius = 25         -- Radius to check for nearby players
local lockDistance = 1        -- Distance behind the target to lock
local tweenTime = 0.001        -- Initial teleport speed
_G.spam = false                -- Toggle control

local player = Players.LocalPlayer
local orbitConnection          -- Active position updater
local previousPlayer           -- Last locked target

-- Tween to the target's position initially (optional)
local function tweenToPlayer(character, targetPlayer)
    if not _G.spam then return false end
    if character and targetPlayer and targetPlayer.Character then
        local targetRootPart = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        local characterRootPart = character:FindFirstChild("HumanoidRootPart")
        if targetRootPart and characterRootPart then
            local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Linear)
            local goal = {CFrame = targetRootPart.CFrame}
            local tween = TweenService:Create(characterRootPart, tweenInfo, goal)
            tween:Play()
            tween.Completed:Wait()
            return true
        end
    end
    return false
end

-- Get the closest valid target (excluding teammates, must be alive)
local function getNearbyPlayer(character, radius)
    local closestPlayer = nil
    local closestDistance = radius
    local characterRoot = character:FindFirstChild("HumanoidRootPart")
    if not characterRoot then return nil end

    local localTeam = player.Team
    local teamsEnabled = localTeam ~= nil

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local targetHRP = p.Character.HumanoidRootPart
            local humanoid = p.Character:FindFirstChildOfClass("Humanoid")
            local dist = (targetHRP.Position - characterRoot.Position).Magnitude

            if humanoid and humanoid.Health > 0 then
                local isEnemy = not teamsEnabled or (teamsEnabled and p.Team ~= localTeam)
                if isEnemy and dist < closestDistance then
                    closestDistance = dist
                    closestPlayer = p
                end
            end
        end
    end

    return closestPlayer
end

-- Continuously teleport behind the target player
local function lockBehindPlayer(character, targetPlayer)
    if not _G.spam then return end
    local targetRootPart = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRootPart then return end

    if orbitConnection then
        orbitConnection:Disconnect()
    end

    orbitConnection = RunService.RenderStepped:Connect(function()
        if not (_G.spam and character and targetPlayer and targetPlayer.Character) then
            orbitConnection:Disconnect()
            return
        end

        local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        local charHRP = character:FindFirstChild("HumanoidRootPart")
        if not targetHRP or not charHRP then
            orbitConnection:Disconnect()
            return
        end

        local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then
            previousPlayer = nil
            orbitConnection:Disconnect()
            return
        end

        -- Calculate position directly behind target and face them
        local behindOffset = -targetHRP.CFrame.LookVector * lockDistance
        local newPos = targetHRP.Position + behindOffset

        charHRP.CFrame = CFrame.new(
            Vector3.new(newPos.X, charHRP.Position.Y, newPos.Z),
            Vector3.new(targetHRP.Position.X, charHRP.Position.Y, targetHRP.Position.Z)
        )
    end)
end

-- Main behavior loop
local function startBehavior()
    if not _G.spam then return end
    local character = player.Character
    if not character then return end

    -- If current target is still valid and alive, continue
    if previousPlayer and previousPlayer.Character then
        local humanoid = previousPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.Health > 0 then
            return
        else
            previousPlayer = nil
            if orbitConnection then
                orbitConnection:Disconnect()
                orbitConnection = nil
            end
        end
    end

    -- Find new target
    local newTarget = getNearbyPlayer(character, checkRadius)
    if newTarget and newTarget ~= previousPlayer then
        local tweenDone = tweenToPlayer(character, newTarget)
        if tweenDone then
            lockBehindPlayer(character, newTarget)
            previousPlayer = newTarget
        end
    end
end

-- Continuously check and lock
local function checkAndFollow()
    while _G.spam do
        startBehavior()
        wait(0.001)
    end

    if orbitConnection then
        orbitConnection:Disconnect()
    end
end

-- UI Checkbox to toggle the script
misc:CreateCheckBox("Kill Aura", function(state)
    _G.spam = state
    if state then
        previousPlayer = nil
        if orbitConnection then
            orbitConnection:Disconnect()
            orbitConnection = nil
        end
        task.spawn(checkAndFollow)
    else
        if orbitConnection then
            orbitConnection:Disconnect()
            orbitConnection = nil
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

local civDropdown2 = misc:CreateDropDown("Extra Scripts", function() end)

civDropdown2:AddButton("infinite yield",function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

-- extra scripts

--glass ESP


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local misc = misc -- assuming misc UI lib is defined somewhere else

local glassHolder = workspace:WaitForChild("GlassBridge"):WaitForChild("GlassHolder")

local espActive = false
local espConnection

-- Store labels so we can clean them up on disable
local labels = {}

local function clearLabels()
    for _, label in pairs(labels) do
        if label and label.Parent then
            label:Destroy()
        end
    end
    labels = {}
end

local function createTextLabel(parentPart, text, color)
    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = parentPart
    billboard.Size = UDim2.new(0, 100, 0, 30)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Name = "GlassESPLabel"

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Text = text
    label.TextColor3 = color
    label.TextStrokeTransparency = 0
    label.Font = Enum.Font.SourceSansBold
    label.TextScaled = true
    label.Parent = billboard

    billboard.Parent = parentPart

    table.insert(labels, billboard)
end

local function updateESP()
    clearLabels()

    for i = 0, 11 do
        local panelName = "ClonedPanel"..i
        local panel = glassHolder:FindFirstChild(panelName)
        if not panel then
            print("[Glass ESP] Panel not found: "..panelName)
            continue
        end

        for _, glassModelName in pairs({"glassmodel1", "glassmodel2"}) do
            local glassModel = panel:FindFirstChild(glassModelName)
            if not glassModel then
                print("[Glass ESP] Glass model not found: "..glassModelName.." in "..panelName)
                continue
            end

            local glassPart = glassModel:FindFirstChild("glasspart")
            if not glassPart or not glassPart:IsA("BasePart") then
                print("[Glass ESP] No BasePart 'glasspart' found in "..glassModelName.." of "..panelName)
                continue
            end

            local actuallyKilling = glassPart:GetAttribute("ActuallyKilling")
            if actuallyKilling == nil then
                print("[Glass ESP] Attribute 'ActuallyKilling' missing in "..glassModelName.." of "..panelName)
                actuallyKilling = false
            end

            if actuallyKilling == true then
                -- Unsafe glass, color red
                glassPart.Color = Color3.fromRGB(255, 0, 0)
                createTextLabel(glassPart, "UNSAFE", Color3.fromRGB(255, 0, 0))
            else
                -- Safe glass, color green
                glassPart.Color = Color3.fromRGB(0, 255, 0)
                createTextLabel(glassPart, "SAFE", Color3.fromRGB(0, 255, 0))
            end
        end
    end
end

local function toggleESP(state)
    if state then
        if espActive then return end -- Already active, do nothing
        espActive = true
        print("[Glass ESP] Enabled.")
        updateESP()
        espConnection = RunService.Heartbeat:Connect(updateESP)
    else
        if not espActive then return end -- Already inactive
        espActive = false
        print("[Glass ESP] Disabled.")
        if espConnection then
            espConnection:Disconnect()
            espConnection = nil
        end
        clearLabels()

        -- Optional: Reset glass parts color to original (if you want)
        for i = 0, 11 do
            local panel = glassHolder:FindFirstChild("ClonedPanel"..i)
            if panel then
                for _, glassModelName in pairs({"glassmodel1", "glassmodel2"}) do
                    local glassModel = panel:FindFirstChild(glassModelName)
                    if glassModel then
                        local glassPart = glassModel:FindFirstChild("glasspart")
                        if glassPart and glassPart:IsA("BasePart") then
                            glassPart.Color = Color3.fromRGB(255, 255, 255) -- reset to white or original color
                        end
                    end
                end
            end
        end
    end
end

misc:CreateCheckBox("Glass ESP", function(state)
    toggleESP(state)
end)



--glass esp
