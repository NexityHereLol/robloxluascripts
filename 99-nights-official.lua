local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/NexityHereLol/robloxluascripts/refs/heads/main/simplistic_lib"))()
local int = lib:CreateInterface("99 Nights in the Forest","script made by lohjc","https://discord.gg/ZNTHTWx7KE","bottom left","royal")
local main = int:CreateTab("Main","main functions/script utilities","default")
local autofarmss = int:CreateTab("Auto","auto farm utilities (OP)","op")
local itemtp = int:CreateTab("Item TP/ESP","bring items to you","item")
local gametp = int:CreateTab("Game TP","goto in-game locations","info")
local charactertp = int:CreateTab("Mob TP","bring mobs to you","npc")
local plr = int:CreateTab("Player","modify your localplayer","player")
local vis = int:CreateTab("Visuals","modify autoyour visuals","visuals")
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
baseplate.Position = Vector3.new(0, 100, 0)
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
    { "[safezone] safe zone", "0, 110, -0" },
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
    "Anvil Back",
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
    "Iron Body",
    "Thorn Body",
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

local bringitemtoyou = itemtp:CreateDropDown("Teleport Item (Bulk):")

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
    "Bear",
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
plr:CreateSlider("jumppower", 700, 50, function(value)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.JumpPower = value
    end
end)

-- WalkSpeed Slider with Persistent Behavior
plr:CreateSlider("walkspeed", 700, 16, function(value)
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

civDropdown2:AddButton("emote gui",function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/dimension-sources/random-scripts-i-found/refs/heads/main/r6%20animations"))()
end)

civDropdown2:AddButton("anti afk",function()
    
    wait(0.5)local ba=Instance.new("ScreenGui")
local ca=Instance.new("TextLabel")local da=Instance.new("Frame")
local _b=Instance.new("TextLabel")local ab=Instance.new("TextLabel")ba.Parent=game.CoreGui
ba.ZIndexBehavior=Enum.ZIndexBehavior.Sibling;ca.Parent=ba;ca.Active=true
ca.BackgroundColor3=Color3.new(0.176471,0.176471,0.176471)ca.Draggable=true
ca.Position=UDim2.new(0.698610067,0,0.098096624,0)ca.Size=UDim2.new(0,370,0,52)
ca.Font=Enum.Font.SourceSansSemibold;ca.Text="anti afk"ca.TextColor3=Color3.new(0,1,1)
ca.TextSize=22;da.Parent=ca
da.BackgroundColor3=Color3.new(0.196078,0.196078,0.196078)da.Position=UDim2.new(0,0,1.0192306,0)
da.Size=UDim2.new(0,370,0,107)_b.Parent=da
_b.BackgroundColor3=Color3.new(0.176471,0.176471,0.176471)_b.Position=UDim2.new(0,0,0.800455689,0)
_b.Size=UDim2.new(0,370,0,21)_b.Font=Enum.Font.Arial;_b.Text="anti afk"
_b.TextColor3=Color3.new(0,1,1)_b.TextSize=20;ab.Parent=da
ab.BackgroundColor3=Color3.new(0.176471,0.176471,0.176471)ab.Position=UDim2.new(0,0,0.158377,0)
ab.Size=UDim2.new(0,370,0,44)ab.Font=Enum.Font.ArialBold;ab.Text="status: active"
ab.TextColor3=Color3.new(0,1,1)ab.TextSize=20;local bb=game:service'VirtualUser'
game:service'Players'.LocalPlayer.Idled:connect(function()
bb:CaptureController()bb:ClickButton2(Vector2.new())
ab.Text="roblox tried to kick you but failed to do so!"wait(2)ab.Text="status : active"end)

    
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
main:CreateSlider("Kill Aura Radius", 700, 50, function(value)
    radius = math.clamp(value, 20, 700)
end)


-- loop distance



-- extra item automation

itemtp:CreateComment("remaining specific item teleports:")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

local itemsFolder = workspace:WaitForChild("Items")
local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")

local bracket = {
    weapons = {
        -- Removed Good Axe and Strong Axe
        "Laser Sword", "Raygun", "Kunai", "Katana" -- moved to misc tools, but you wanted it here too?
    },
    minifoods = {
        "Apple", "Berry", "Carrot"
    },
    meat = {
        "Steak", "Cooked Steak", "Cooked Morsel" , "Morsel"
    },
    armor = {
        "Leather Body", "Iron Body", "Thorn Body"
    },
    ["guns/ammo"] = {
        "Rifle", "Revolver", "Raygun", "Tactical Shotgun", "Revolver Ammo", "Rifle Ammo"
    },
    materials = {
        "Log", "Coal", "Fuel Canister", "UFO Junk", "UFO Component", "Bandage", "MedKit",
        "Old Car Engine", "Broken Fan", "Old Microwave", "Old Radio", "Sheet Metal"
    },
    pelts = {
        "Alpha Wolf Pelt", "Bear Pelt", "Wolf Pelt", "Bunny Foot"
    },
    misc_tools = {  -- changed to misc_tools for consistency with no spaces
        "Good Sack", "Old Flashlight", "Old Radio", "Giant Sack", "Strong Flashlight", "Chainsaw"
    }
}

-- Finds the first suitable BasePart to teleport
local function findTeleportablePart(item)
    for _, descendant in ipairs(item:GetDescendants()) do
        if descendant:IsA("BasePart") then
            return descendant
        end
        if descendant:IsA("Model") then
            for _, sub in ipairs(descendant:GetDescendants()) do
                if sub:IsA("BasePart") then
                    return sub
                end
            end
        end
    end
    return nil
end

local function teleportItem(itemName)
    local stackOffsetY = 2 -- offset per stacked item
    local count = 0

    for _, item in ipairs(itemsFolder:GetChildren()) do
        if item.Name == itemName then
            local targetPart = findTeleportablePart(item)
            if targetPart then
                remoteEvents.RequestStartDraggingItem:FireServer(item)
                local offset = Vector3.new(0, count * stackOffsetY, 0)
                targetPart.CFrame = rootPart.CFrame + offset
                remoteEvents.StopDraggingItem:FireServer(item)

                print("Moved", itemName, ":", item:GetFullName())
                count = count + 1
            else
                warn("Couldn't find part for:", item:GetFullName())
            end
        end
    end
end

-- Create one dropdown per bracket
for groupName, itemList in pairs(bracket) do
    -- Make dropdown label nicer: replace underscores and slashes, capitalize words
    local label = groupName:gsub("_", " "):gsub("/", "/")
    label = label:gsub("(%a)([%w_']*)", function(first, rest)
        return first:upper() .. rest:lower()
    end)
    local dropdown = itemtp:CreateDropDown(label)
    for _, itemName in ipairs(itemList) do
        dropdown:AddButton(itemName, function()
            teleportItem(itemName)
        end)
    end
end

-- separation for the automation

-- auto 

-- SERVICES
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

-- PLAYER REFERENCES
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")
local itemsFolder = Workspace:WaitForChild("Items")
local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local remoteConsume = remoteEvents:WaitForChild("RequestConsumeItem")

-- DROP POSITIONS
local campfireDropPos = Vector3.new(0, 19, 0)
local machineDropPos = Vector3.new(21, 16, -5)
local biofuelDropOffset = Vector3.new(0, 3, 0)  -- drop above processor

-- ITEM LISTS
local campfireFuelItems = {"Log", "Coal", "Fuel Canister", "Oil Barrel", "Biofuel"}
local autocookItems = {"Morsel", "Steak"}
local autoGrindItems = {"UFO Junk", "UFO Component", "Old Car Engine", "Broken Fan", "Old Microwave", "Bolt", "Log", "Cultist Gem", "Sheet Metal", "Old Radio"}
local autoEatFoods = {"Cooked Steak", "Cooked Morsel", "Berry", "Carrot", "Apple"}
local biofuelItems = {"Carrot", "Cooked Morsel", "Morsel", "Steak", "Cooked Steak"}

-- STATE TABLES
local autoFuelEnabledItems, autoCookEnabledItems, autoGrindEnabledItems = {}, {}, {}
local autoEatEnabled = false
local autoBreakEnabled = false  -- tree bring
local autoBiofuelEnabledItems = {}

-- UTILITY: toggle housekeeping
local function handleToggle(tbl, name, checked)
    if checked then tbl[name] = true else tbl[name] = nil end
end

-- UI: create dropdowns (replace `autofarmss` with your UI instance)
local fuelDropdown = autofarmss:CreateDropDown("Auto Campfire (Fuel)")
for _, n in ipairs(campfireFuelItems) do
  fuelDropdown:AddCheckbox(n, function(c) handleToggle(autoFuelEnabledItems, n, c) end)
end

local cookDropdown = autofarmss:CreateDropDown("Auto Cook Food")
for _, n in ipairs(autocookItems) do
  cookDropdown:AddCheckbox(n, function(c) handleToggle(autoCookEnabledItems, n, c) end)
end

local grindDropdown = autofarmss:CreateDropDown("Auto Machine Grind")
for _, n in ipairs(autoGrindItems) do
  grindDropdown:AddCheckbox(n, function(c) handleToggle(autoGrindEnabledItems, n, c) end)
end

local eatDropdown = autofarmss:CreateDropDown("Auto Eat")
eatDropdown:AddCheckbox("Enable Auto Eat", function(c)
  autoEatEnabled = c
  print("Auto Eat toggled:", c)
end)

local biofuelDropdown = autofarmss:CreateDropDown("Auto Biofuel")
for _, n in ipairs(biofuelItems) do
  biofuelDropdown:AddCheckbox(n, function(c)
    handleToggle(autoBiofuelEnabledItems, n, c)
  end)
end

local miscdropdown = autofarmss:CreateDropDown("Auto Misc Features")
miscdropdown:AddCheckbox("Auto Bring All Small Trees", function(checked)
  autoBreakEnabled = checked
  print("Auto Bring Trees toggled:", checked)
  if checked then
    bringAllTrees()
  else
    restoreTrees()
  end
end)

-- MOVE FUNCTION
local function moveItemToPos(item, pos)
  local part = item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart") or item:FindFirstChild("Handle")
  if not part then return end
  if (part.Position - pos).Magnitude > 0.5 then
    local ok, err = pcall(function()
      remoteEvents.RequestStartDraggingItem:FireServer(item)
      task.wait()
      part.CFrame = CFrame.new(pos)
      task.wait()
      remoteEvents.StopDraggingItem:FireServer(item)
    end)
    if not ok then warn("Error moving", item.Name, err) end
  end
end

-- SHARED DROPPER
local function handleAutoDrop(tbl, pos)
  for name in pairs(tbl) do
    for _, item in ipairs(itemsFolder:GetChildren()) do
      if item.Name == name then moveItemToPos(item, pos) end
    end
  end
end

-- COROUTINES
coroutine.wrap(function()
  while true do
    handleAutoDrop(autoFuelEnabledItems, campfireDropPos)
    task.wait(1.5)
  end
end)()

coroutine.wrap(function()
  while true do
    handleAutoDrop(autoCookEnabledItems, campfireDropPos)
    task.wait(1.5)
  end
end)()

coroutine.wrap(function()
  while true do
    handleAutoDrop(autoGrindEnabledItems, machineDropPos)
    task.wait(1.5)
  end
end)()

coroutine.wrap(function()
  while true do
    if autoEatEnabled then
      for _, item in ipairs(itemsFolder:GetChildren()) do
        if table.find(autoEatFoods, item.Name) then
          print("Auto‑eating:", item.Name)
          local ok, res = pcall(function() return remoteConsume:InvokeServer(item) end)
          if not ok then warn("Eat failed", item.Name, res) end
          break
        end
      end
    end
    task.wait(2.5)
  end
end)()

coroutine.wrap(function()
  while true do
    local proc = Workspace.Structures:FindFirstChild("Biofuel Processor")
    local part = proc and proc:FindFirstChild("Part")
    if part then
      local dropPos = part.Position + biofuelDropOffset
      handleAutoDrop(autoBiofuelEnabledItems, dropPos)
    end
    task.wait(1.5)
  end
end)()

-- === FIXED TREE SYSTEM ===
local originalTreeCFrames = {}
local treesBrought = false

local function getAllSmallTrees()
    local trees = {}

    local function collect(folder)
        for _, obj in ipairs(folder:GetChildren()) do
            if obj:IsA("Model") and obj.Name == "Small Tree" then
                table.insert(trees, obj)
            end
        end
    end

    if Workspace:FindFirstChild("Map") then
        if Workspace.Map:FindFirstChild("Foliage") then
            collect(Workspace.Map.Foliage)
        end
        if Workspace.Map:FindFirstChild("Landmarks") then
            collect(Workspace.Map.Landmarks)
        end
    end

    return trees
end

local function findTrunk(treeModel)
    for _, part in ipairs(treeModel:GetDescendants()) do
        if part:IsA("BasePart") and part.Name == "Trunk" then
            return part
        end
    end
    return nil
end

local function bringAllTrees()
    local trees = getAllSmallTrees()
    local targetCFrame = CFrame.new(rootPart.Position + rootPart.CFrame.LookVector * 10)

    for _, tree in ipairs(trees) do
        local trunk = findTrunk(tree)
        if trunk then
            -- Cache original position
            if not originalTreeCFrames[tree] then
                originalTreeCFrames[tree] = trunk.CFrame
            end

            -- Ensure tree has a PrimaryPart set
            tree.PrimaryPart = trunk

            -- Unanchor before move (helps with CFrame replication issues)
            trunk.Anchored = false
            trunk.CanCollide = false

            -- Teleport tree trunk
            task.wait()
            tree:SetPrimaryPartCFrame(targetCFrame + Vector3.new(math.random(-5, 5), 0, math.random(-5, 5)))

            -- Anchor after move
            task.wait()
            trunk.Anchored = true

            print("Moved tree:", tree:GetFullName())
        end
    end

    treesBrought = true
end

local function restoreTrees()
    for tree, cframe in pairs(originalTreeCFrames) do
        local trunk = findTrunk(tree)
        if trunk then
            tree.PrimaryPart = trunk
            tree:SetPrimaryPartCFrame(cframe)
            trunk.Anchored = false
            task.delay(0.2, function()
                if trunk then
                    trunk.CanCollide = true
                end
            end)
        end
    end
    originalTreeCFrames = {}
    treesBrought = false
end


-- auto 

-- extra item automation
