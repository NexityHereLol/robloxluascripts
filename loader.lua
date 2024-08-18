-- URL of the GitHub raw text file
local githubURL = "https://raw.githubusercontent.com/NexityHereLol/skidware/main/whitelisted.lua"

-- Function to fetch the file contents from the GitHub URL
local function fetchWhitelistedIDs()
    local success, response = pcall(function()
        return game:HttpGet(githubURL)
    end)
    
    if not success then
        print("Failed to fetch data. Error: " .. response)
        return {}
    end

    local ids = {}
    -- Split response into lines
    for id in response:gmatch("[^\r\n]+") do
        table.insert(ids, id)
    end
    return ids
end

-- Fetch and store the whitelisted IDs
local whitelistedIDs = fetchWhitelistedIDs()

-- Function to check if a player ID is whitelisted
local function isWhitelisted(playerID)
    for _, id in ipairs(whitelistedIDs) do
        if playerID == id then
            return true
        end
    end
    return false
end

-- Example: Automatic playerID retrieval
-- In Roblox, you would get the player's UserId
local function getPlayerID()
    local player = game.Players.LocalPlayer
    if player then
        return tostring(player.UserId) -- Return as string
    else
        return nil
    end
end

local playerID = getPlayerID() -- Automatically get the player ID

if playerID and isWhitelisted(playerID) then
    print("Player is whitelisted!")
    local placeID = game.PlaceId

    print("Current Place ID: " .. tostring(placeID))
    
    if placeID == 18629053284 then
        print('survival odyssey loadstring:loaded')
        local scriptSource = game:HttpGet("https://raw.githubusercontent.com/NexityHereLol/skidware/main/soddysey.lua")
        print("Script source length: " .. tostring(#scriptSource))
        local func, err = loadstring(scriptSource)
        if func then
            local success, execErr = pcall(func)
            if not success then
                print("Error executing script: " .. execErr)
            end
        else
            print("Failed to load script: " .. err)
        end
    else
        print("Not the correct Place ID.")
    end
else
    print("Player is not whitelisted or player ID not available.")
end
