-- Load the UI lib dynamically from GitHub
local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/NexityHereLol/skidware/refs/heads/main/lib_extension"))()

-- Create the interface using the loaded lib
local int = lib:CreateInterface("skidware: YBA", "bottom left")

local autofarm = int:CreateTab("autofarm")
local misc = int:CreateTab("misc")
local serverhop = int:CreateTab("server(s) hop")
local player = int:CreateTab("player")
local storymode = int:CreateTab("storymode tp(s)")

-- autofarm page --

autofarm:CreateLabel("autofarm coming soon..")

-- autofarm page --

-- misc page -- 

misc:CreateCheckBox("item esp",function(s)
    print("item esp: " .. s)
end)

-- misc page -- 

-- serverhop page -- 

local amt

serverhop:CreateSlider("player amount",16,3,function(s)
	amt = s 
	--print(fart)
end)

serverhop:CreateButton("server hop (adjust player amount)",function()
	local HttpService = game:GetService("HttpService")
	local TeleportService = game:GetService("TeleportService")
	local Players = game:GetService("Players")

	local player = Players.LocalPlayer
	local PlaceId = 2809202155
	local currentJobId = game.JobId
	local visitedServers = {
		[currentJobId] = true
	}

	local function serverHop()
		local servers = {}
		local cursor = ""

		local function fetchServers()
			local url = "https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
			if cursor and cursor ~= "" then
				url = url .. "&cursor=" .. cursor
			end

			local success, result = pcall(function()
				return HttpService:JSONDecode(game:HttpGet(url))
			end)

			if success and result and result.data then
				for _, server in ipairs(result.data) do
					local id = server.id
					local players = server.playing
					local max = server.maxPlayers
					if players >= amt and players < max and not visitedServers[id] then
						table.insert(servers, id)
					end
				end
				cursor = result.nextPageCursor
			else
				warn("Failed to fetch server list.")
			end
		end

		repeat
			fetchServers()
			task.wait(1)
		until #servers > 0 or not cursor

		if #servers > 0 then
			local target = servers[math.random(1, #servers)]
			visitedServers[target] = true
			TeleportService:TeleportToPlaceInstance(PlaceId, target, player)
		else
			warn("No suitable servers found (8+ players & not visited).")
		end
	end

	serverHop()

end)

-- serverhop page -- 

-- teleports page -- 

local teleportData = {
	{name = "talk to giorno 1", pos = Vector3.new(1, 1, -705)},
	{name = "talk to koichi", pos = Vector3.new(-122, 2, -463)},
	{name = "talk to giorno 2", pos = Vector3.new(-390, 1, -681)},
	{name = "defeat bruno (first battle)", pos = Vector3.new(-238, 23, 159)},
	{name = "talk to bruno (after battle)", pos = Vector3.new(-564, -23, -193)},
	{name = "talk to giorno 3 (post battle)", pos = Vector3.new(-371, 2, -122)},
	{name = "talk to fugo 1 (meet the gang)", pos = Vector3.new(-328, 2, 30)},
	{name = "talk to mista 1 (meet the gang)", pos = Vector3.new(150, 5, 79)},
	{name = "talk to narancia 1 (meet the gang)", pos = Vector3.new(261, 7, -240)},
	{name = "talk to abbachio 1 (meet the gang)", pos = Vector3.new(355, 1, -313)},
	{name = "talk to bruno 3 (begin the mission)", pos = Vector3.new(410, 1, -136)},
	{name = "talk to trish (begin the mission)", pos = Vector3.new(-58, -25, 593)},
	{name = "train station tp for npc battle quests", pos = Vector3.new(-264, 1, -82)},
	{name = "final talks (1) before beating diavolo", pos = Vector3.new(579, 1, -131)},
	{name = "final talks (2) before beating diavolo", pos = Vector3.new(1144, 118, -147)},
}

for _, data in ipairs(teleportData) do
	storymode:CreateButton(data.name, function()
		local character = game.Players.LocalPlayer.Character
		if character and character:FindFirstChild("Humanoid") then
			local rootPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
			if rootPart then
				rootPart.CFrame = CFrame.new(data.pos)
			end
		end
	end)
end



-- teleports page -- 

-- player page -- 

player:CreateCheckBox("walkspeed",function(enable)
	if enable == true then
		game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100
	else
		game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 15
	end
end)

player:CreateCheckBox("jumppower",function(enable)
	if enable == true then
		game.Players.LocalPlayer.Character.Humanoid.JumpPower = 150
	else
		game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
	end
end)

-- player page -- 
