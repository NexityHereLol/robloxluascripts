local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/NexityHereLol/robloxluascripts/refs/heads/main/simplistic_lib"))()
local int = lib:CreateInterface("99 Nights in the Forest","script made by lohjc","https://discord.gg/ZNTHTWx7KE","bottom left","ocean")
local main = int:CreateTab("Main","main functions/script utilities","default")
local itemtp = int:CreateTab("Item TP/ESP","bring items to you","item")
local gametp = int:CreateTab("Game TP","goto in-game locations","info")
local charactertp = int:CreateTab("Mob TP","bring mobs to you","npc")
local plr = int:CreateTab("Player","modify your localplayer","player")
local vis = int:CreateTab("Visuals","modify your visuals","visuals")
local misc = int:CreateTab("Misc","miscellaneous","misc")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")


-- === Main Configurations === 

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Safe zone setup
local baseplate = Instance.new("Part")
baseplate.Name = "SafeZoneBaseplate"
baseplate.Size = Vector3.new(20, 1, 20)
baseplate.Position = Vector3.new(0, 38, 0)
baseplate.Anchored = true
baseplate.CanCollide = true
baseplate.Transparency = 1
baseplate.Color = Color3.fromRGB(255, 255, 255)
baseplate.Parent = workspace

-- Checkbox to toggle visibility
main:CreateCheckbox("Show Safe Zone", function(enabled)
	if enabled == true then
	   baseplate.Transparency = 0.8
		else
	   baseplate.Transparency = 1
	end
	baseplate.CanCollide = enabled
end)

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


local storyCoords = {
    { "[campsite] camp site", "0, 8, -0"},
    { "[safezone] safe zone", "0, 41, -0" },
    { "[stronghold] cultist stronghold", "546, 4, 263"}
}

local storyDropdown = gametp:CreateDropDown("Teleports")

-- Create dropdown for story teleports
for _, entry in ipairs(storyCoords) do
    local name, coord = entry[1], entry[2]
    storyDropdown:AddButton(name, function()
        teleportToTarget(stringToCFrame(coord), 0.1)
    end)
end


itemtp:CreateCheckbox("Item ESP", function(state)
    local itemFolder = workspace:FindFirstChild("Items")
    if not itemFolder then
        warn("workspace.Items folder not found")
        return
    end

    local itemNames = {
        ["Revolver"] = true, ["Oil Barrel"] = true, ["Chainsaw"] = true, ["Giant Sack"] = true, ["Bunny Foot"] = true,["MedKit"] = true, ["Alien Chest"] = true, ["Berry"] = true,
        ["Bolt"] = true, ["Broken Fan"] = true, ["Carrot"] = true, ["Coal"] = true,
        ["Coin Stack"] = true, ["Hologram Emitter"] = true, ["Item Chest"] = true,
        ["Laser Fence Blueprint"] = true, ["Log"] = true, ["Old Flashlight"] = true,
        ["Old Radio"] = true, ["Sheet Metal"] = true, ["Bandage"] = true, ["Rifle"] = true
    }

    local connections = {}

    local function createESP(model)
        if not model:IsA("Model") or not itemNames[model.Name] then return end
        if not model.PrimaryPart or model:FindFirstChild("ESP") then return end

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP"
        billboard.Size = UDim2.new(0, 100, 0, 30)
        billboard.Adornee = model.PrimaryPart
        billboard.AlwaysOnTop = true
        billboard.StudsOffset = Vector3.new(0, 3, 0)
	
	local customFont = Font.new("rbxassetid://16658246179", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
	local label = Instance.new("TextLabel")
	
	label.Size = UDim2.new(1, 0, 1, 0)
	label.TextSize = 17
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextStrokeTransparency = 0.5
	label.TextScaled = false
	label.FontFace = customFont
	label.Text = model.Name
	
        label.Parent = billboard

        billboard.Parent = model
    end

    local function removeAllESP()
        for _, model in itemFolder:GetChildren() do
            local esp = model:FindFirstChild("ESP")
            if esp then esp:Destroy() end
        end
    end

    if state then
        -- Create ESPs for all current items
        for _, model in itemFolder:GetChildren() do
            createESP(model)
        end

        -- Add ESPs for any new items added
        local connection = itemFolder.ChildAdded:Connect(function(model)
            if model:IsA("Model") and itemNames[model.Name] then
                model:GetPropertyChangedSignal("PrimaryPart"):Wait()
                createESP(model)
            end
        end)

        table.insert(connections, connection)
    else
        -- Disable ESPs
        removeAllESP()

        -- Disconnect any listeners
        for _, conn in connections do
            if conn.Disconnect then conn:Disconnect() end
        end
        table.clear(connections)
    end
end)

-- tp to item


local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

local itemFolder = workspace:WaitForChild("Items")

local itemNames = {
    "Revolver", "Medkit", "Alien Chest", "Berry", "Bolt", "Broken Fan",
    "Carrot", "Coal", "Coin Stack", "Hologram Emitter", "Item Chest",
    "Laser Fence Blueprint", "Log", "Old Flashlight", "Old Radio",
    "Sheet Metal", "Bandage", "Rifle"
}

local function getModelPart(model)
    if model.PrimaryPart then
        return model.PrimaryPart
    end
    for _, part in pairs(model:GetChildren()) do
        if part:IsA("BasePart") then
            return part
        end
    end
    return nil
end

local dropdown = itemtp:CreateDropDown("Teleport to Item")

for _, itemName in ipairs(itemNames) do
    dropdown:AddButton("TP to " .. itemName, function()
        -- Find all models with this name inside Items folder
        local candidates = {}
        for _, model in pairs(itemFolder:GetChildren()) do
            if model:IsA("Model") and model.Name == itemName then
                local part = getModelPart(model)
                if part then
                    table.insert(candidates, part)
                end
            end
        end

        if #candidates == 0 then
            warn("No '" .. itemName .. "' found to teleport to.")
            return
        end

        -- Pick a random part and teleport
        local targetPart = candidates[math.random(1, #candidates)]
        local character = localPlayer.Character
        if character then
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = targetPart.CFrame + Vector3.new(0, 5, 0)
            end
        end
    end)
end



-- tp to item




-- tp item to you  

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

local itemsFolder = workspace:WaitForChild("Items")
local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")

local possibleItems = {
    "Alien Chest",
    "Alpha Wolf Pelt",
    "Anvil Front",
    "Apple",
    "Bandage",
    "Bear Corpse",
    "Bear Pelt",
    "Berry",
    "Biofuel",
    "Bolt",
    "Broken Fan",
    "Bunny Foot",
    "Carrot",
    "Coal",
    "Coin Stack",
    "Cooked Morsel",
    "Cooked Steak",
    "Chainsaw",
    "Cultist",
    "Cultist Gem",
    "Flower",
    "Fuel Canister",
    "Hologram Emitter",
    "Item Chest",
    "Laser Fence Blueprint",
    "Leather Body",
    "Log",
    "MedKit",
    "Morsel",
    "Old Flashlight",
    "Old Radio",
    "Good Sack",
    "Good Axe",
    "Raygun",
    "Giant Sack",
    "Strong Axe",
    "Oil Barrel",
    "Old Car Engine",
    "Rifle",
    "Rifle Ammo",
    "Revolver",
    "Revolver Ammo",
    "Sapling",
    "Sheet Metal",
    "Steak",
    "Wolf Pelt"
}

local bringitemtoyou = itemtp:CreateDropDown("Teleport Item:")

local function teleportItem(itemName)
    local stackOffsetY = 2 -- Height between stacked items
    local count = 0

    for _, item in ipairs(itemsFolder:GetChildren()) do
        if item.Name == itemName then
            local targetPart = nil

            if itemName == "Berry" then
                targetPart = item:FindFirstChild("Handle")
                if not targetPart then
                    for _, child in ipairs(item:GetDescendants()) do
                        if child:IsA("MeshPart") or child:IsA("Part") or child:IsA("UnionOperation") then
                            targetPart = child
                            break
                        end
                    end
                end
            else
                for _, child in ipairs(item:GetDescendants()) do
                    if child:IsA("MeshPart") or child:IsA("Part") then
                        targetPart = child
                        break
                    end
                end
            end

            if targetPart then
                remoteEvents.RequestStartDraggingItem:FireServer(item)

                -- Stack vertically at player's position
                local offset = Vector3.new(0, count * stackOffsetY, 0)
                targetPart.CFrame = rootPart.CFrame + offset

                remoteEvents.StopDraggingItem:FireServer(item)
                print("Moved", itemName, ":", item:GetFullName())

                count = count + 1
            else
                warn(itemName .. " found, but no MeshPart or Part inside:", item:GetFullName())
            end
        end
    end
end

for _, itemName in ipairs(possibleItems) do
    bringitemtoyou:AddButton(itemName, function()
        teleportItem(itemName)
    end)
end


-- tp item to you 

-- tp char to you

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

local characterFolder = workspace:WaitForChild("Characters")

local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents") -- if needed

-- List of character names to teleport (your tags)
local possibleCharacters = {
    "Alpha Wolf",
    "Lost Child",
    "Lost Child2",
    "Lost Child3",
    "Lost Child4",
    "Wolf",
    "Bunny",
    "Cultist",
    "Alien"
}

local bringCharacterToYou = charactertp:CreateDropDown("Teleport Mob:")

-- Helper to find main part (similar to your getModelPart)
local function getMainPart(model)
    if model.PrimaryPart then
        return model.PrimaryPart
    end
    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") then
            return part
        end
    end
    return nil
end

local function teleportCharacter(characterName)
    local stackOffsetY = 3
    local count = 0

    for _, model in ipairs(characterFolder:GetChildren()) do
        if model.Name == characterName then
            local mainPart = getMainPart(model)
            if mainPart and rootPart then
                -- Move the whole model so mainPart aligns above player, stacked
                local targetCFrame = rootPart.CFrame + Vector3.new(0, count * stackOffsetY, 0)
                -- Use SetPrimaryPartCFrame if PrimaryPart exists, else move mainPart directly
                if model.PrimaryPart then
                    model:SetPrimaryPartCFrame(targetCFrame)
                else
                    mainPart.CFrame = targetCFrame
                end
                count = count + 1
            else
                warn("No main part found for character:", model:GetFullName())
            end
        end
    end
end

for _, characterName in ipairs(possibleCharacters) do
    bringCharacterToYou:AddButton(characterName, function()
        teleportCharacter(characterName)
    end)
end


-- tp char to you 


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

plr:CreateCheckbox("walkspeed toggle (50)",function(toggle)
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
vis:CreateCheckbox("ESP", function(state)
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

vis:CreateCheckbox("Chams", function(state)
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

vis:CreateCheckbox("FOV Circle", function(state)
	FOVCircle.Visible = state
end)


-- extra scripts

local civDropdown2 = misc:CreateDropDown("Extra Scripts", function() end)

civDropdown2:AddButton("infinite yield",function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

civDropdown2:AddButton("turtle spy",function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Turtle-Brand/Turtle-Spy/main/source.lua", true))()
end)

civDropdown2:AddButton("ink game 2 (extra script)",function()
    loadstring(game:HttpGet('https://api.exploitingis.fun/loader', true))()
end)


-- extra scripts


-- loop distance

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local player = Players.LocalPlayer

local killAuraToggle = false
local radius = 200
-- Script generated by TurtleSpy, made by Intrer#0421

-- Supported tools and their damage IDs
local toolsDamageIDs = {
    ["Old Axe"] = "1_8982038982",
    ["Good Axe"] = "112_8982038982",
    ["Strong Axe"] = "116_8982038982" ,
    ["Chainsaw"] = "647_8992824875"
}

-- Try to find any supported tool in inventory with damageID
local function getAnyToolWithDamageID()
    for toolName, damageID in pairs(toolsDamageIDs) do
        local tool = player.Inventory:FindFirstChild(toolName)
        if tool then
            return tool, damageID
        end
    end
    return nil, nil
end

-- Equip a given tool
local function equipTool(tool)
    if tool then
        RemoteEvents.EquipItemHandle:FireServer("FireAllClients", tool)
    end
end

-- Unequip a given tool
local function unequipTool(tool)
    if tool then
        RemoteEvents.UnequipItemHandle:FireServer("FireAllClients", tool)
    end
end

-- Kill Aura main loop
local function killAuraLoop()
    while killAuraToggle do
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local tool, damageID = getAnyToolWithDamageID()
            if tool and damageID then
                equipTool(tool)

                for _, mob in ipairs(Workspace.Characters:GetChildren()) do
                    if mob:IsA("Model") then
                        local part = mob:FindFirstChildWhichIsA("BasePart")
                        if part and (part.Position - hrp.Position).Magnitude <= radius then
                            pcall(function()
                                RemoteEvents.ToolDamageObject:InvokeServer(
                                    mob,
                                    tool,
                                    damageID,
                                    CFrame.new(part.Position)
                                )
                            end)
                        end
                    end
                end

                task.wait(0.1)
            else
                warn("No supported tool found in inventory")
                task.wait(1)
            end
        else
            task.wait(0.5)
        end
    end
end

-- UI checkbox toggle
main:CreateCheckbox("Kill Aura", function(state)
    killAuraToggle = state
    if state then
        task.spawn(killAuraLoop)
    else
        local tool, _ = getAnyToolWithDamageID()
        unequipTool(tool)
    end
end)

-- UI slider for radius, with clamping and updating
main:CreateSlider("Kill Aura Radius", 1000, 20, function(value)
    radius = math.clamp(value, 20, 1000)
end)


-- loop distance
