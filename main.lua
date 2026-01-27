-- CX Arsenal Main Script
-- Version: v1.3.0
-- Discord: cxscripts | discord.gg/ZSTPp2jTFG
-- Key: cx2026

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")
local LocalizationService = game:GetService("LocalizationService")

local player = Players.LocalPlayer

-- CONFIG
local SCRIPT_NAME = "CX Arsenal"
local SCRIPT_VERSION = "v1.3.0"
local SCRIPT_USER = "cxscripts"
local SCRIPT_STATUS = "🟢 Undetected"
local THEME_NAME = "CX Black / White Glow"

local startTime = os.clock()

-- PLATFORM
local platform = "Unknown"
pcall(function()
    platform = UserInputService:GetPlatform().Name
end)

-- REGION
local region = "Unknown"
pcall(function()
    region = LocalizationService:GetCountryRegionForPlayerAsync(player)
end)

-- WINDOW
local Window = Rayfield:CreateWindow({
    Name = SCRIPT_NAME .. " | 2026",
    LoadingTitle = SCRIPT_NAME,
    LoadingSubtitle = "Clean Interface",
    ConfigurationSaving = { Enabled = false },
    Discord = {
        Enabled = true,
        Invite = "ZSTPp2jTFG",
        RememberJoins = true
    },
    KeySystem = true,
    KeySettings = {
        Title = SCRIPT_NAME .. " | Key System",
        Subtitle = "Enter access key",
        Note = "Discord: cxscripts",
        FileName = "CXKey",
        SaveKey = false,
        GrabKeyFromSite = false,
        Key = { "cx2026" }
    }
})

------------------------------------------------
-- CHANGELOG TAB
------------------------------------------------
local ChangelogTab = Window:CreateTab("Changelog", 4483362458)
ChangelogTab:CreateParagraph({
    Title = "v1.3.0",
    Content =
        "- Renamed to CX Arsenal\n" ..
        "- Added visual-only Combat, Visual, Misc tabs\n" ..
        "- Added version changelog\n" ..
        "- Live status footer (FPS, Ping, Uptime, Platform, Region)\n" ..
        "- Loader + auto-update system"
})
ChangelogTab:CreateParagraph({
    Title = "v1.2.0",
    Content =
        "- Feature categories added\n" ..
        "- Status footer implemented\n" ..
        "- Key system added"
})

------------------------------------------------
-- COMBAT TAB (VISUAL ONLY)
------------------------------------------------
local CombatTab = Window:CreateTab("Combat", 6034509993)
CombatTab:CreateParagraph({
    Title = "Combat",
    Content = "Visual-only placeholders\nNo functionality"
})
CombatTab:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Callback = function(v)
        Rayfield:Notify({Title = SCRIPT_NAME, Content = "Aimbot toggled (visual only)", Duration = 2})
    end
})
CombatTab:CreateToggle({
    Name = "Silent Aim",
    CurrentValue = false,
    Callback = function(v)
        Rayfield:Notify({Title = SCRIPT_NAME, Content = "Silent Aim toggled (visual only)", Duration = 2})
    end
})
CombatTab:CreateSlider({
    Name = "FOV",
    Range = {60,120},
    Increment = 1,
    CurrentValue = 70,
    Callback = function(v)
        print("FOV slider (visual only):", v)
    end
})

------------------------------------------------
-- VISUAL TAB (VISUAL ONLY)
------------------------------------------------
local VisualTab = Window:CreateTab("Visuals", 7072725342)
VisualTab:CreateParagraph({
    Title = "Visuals",
    Content = "Display-only toggles"
})
VisualTab:CreateToggle({
    Name = "ESP",
    CurrentValue = false,
    Callback = function(v)
        Rayfield:Notify({Title = SCRIPT_NAME, Content = "ESP toggled (visual only)", Duration = 2})
    end
})
VisualTab:CreateToggle({
    Name = "Box ESP",
    CurrentValue = false,
    Callback = function(v)
        Rayfield:Notify({Title = SCRIPT_NAME, Content = "Box ESP toggled (visual only)", Duration = 2})
    end
})

------------------------------------------------
-- MISC TAB
------------------------------------------------
local MiscTab = Window:CreateTab("Misc", 7733715400)
MiscTab:CreateButton({
    Name = "Test Notification",
    Callback = function()
        Rayfield:Notify({Title = SCRIPT_NAME, Content = "Button pressed", Duration = 2})
    end
})

------------------------------------------------
-- STATUS TAB (FOOTER)
------------------------------------------------
local StatusTab = Window:CreateTab("Status", 7734068321)
local StatusFooter = StatusTab:CreateParagraph({Title = "Live Status", Content = "Loading..."})

-- FPS counter
local fps = 0
do
    local frames = 0
    local last = os.clock()
    RunService.RenderStepped:Connect(function()
        frames += 1
        if os.clock() - last >= 1 then
            fps = frames
            frames = 0
            last = os.clock()
        end
    end)
end

-- Update status every 1 second
task.spawn(function()
    while true do
        task.wait(1)
        local ping = 0
        pcall(function()
            ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        end)
        local uptime = math.floor(os.clock() - startTime)
        StatusFooter:Set({
            Title = "Live Status",
            Content =
                "User: " .. SCRIPT_USER .. "\n" ..
                "Version: " .. SCRIPT_VERSION .. "\n" ..
                "Status: " .. SCRIPT_STATUS .. "\n" ..
                "FPS: " .. fps .. "\n" ..
                "Ping: " .. ping .. " ms\n" ..
                "Uptime: " .. uptime .. "s\n" ..
                "Region: " .. region .. "\n" ..
                "Platform: " .. platform .. "\n" ..
                "Theme: " .. THEME_NAME
        })
    end
end)
