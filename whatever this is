-- CX Arsenal Loader
-- Local Version: v1.0

local CURRENT_VERSION = "v1.0"

local VERSION_URL = "https://raw.githubusercontent.com/cxscripts/cx-arsenal/main/version.txt"
local MAIN_URL = "https://raw.githubusercontent.com/cxscripts/cx-arsenal/main/main.lua"

local StarterGui = game:GetService("StarterGui")

local function notify(msg)
    StarterGui:SetCore("SendNotification", {
        Title = "CX Arsenal",
        Text = msg,
        Duration = 5
    })
end

-- Get latest version
local latestVersion = CURRENT_VERSION
pcall(function()
    latestVersion = string.gsub(game:HttpGet(VERSION_URL), "%s+", "")
end)

if latestVersion ~= CURRENT_VERSION then
    notify("Version " .. latestVersion .. " found, loading...")
else
    notify("Up to date (" .. CURRENT_VERSION .. ")")
end

-- Load main script
loadstring(game:HttpGet(MAIN_URL))()
