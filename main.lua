-- CX Arsenal
-- Version: v1.1
-- Discord: cxscripts | discord.gg/ZSTPp2jTFG
-- Key: cx2026

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

local SCRIPT_NAME = "CX Arsenal"
local SCRIPT_VERSION = "v1.1"
local startTime = os.clock()

-- Window
local Window = Rayfield:CreateWindow({
    Name = SCRIPT_NAME .. " | 2026",
    LoadingTitle = SCRIPT_NAME,
    LoadingSubtitle = "v1.1",
    ConfigurationSaving = { Enabled = false },
    Discord = {
        Enabled = true,
        Invite = "ZSTPp2jTFG",
        RememberJoins = true
    },
    KeySystem = true,
    KeySettings = {
        Title = SCRIPT_NAME .. " | Key System",
        Subtitle = "Enter key",
        Note = "Discord: cxscripts",
        FileName = "CXKey",
        SaveKey = false,
        GrabKeyFromSite = false,
        Key = { "cx2026" }
    }
})

-- Changelog
local Changelog = Window:CreateTab("Changelog", 4483362458)
Changelog:CreateParagraph({
    Title = "v1.1",
    Content =
        "- GitHub loader working\n" ..
        "- CX Arsenal branding\n" ..
        "- Status tab added\n" ..
        "- Visual-only feature tabs"
})

-- Combat (visual only)
local Combat = Window:CreateTab("Combat", 6034509993)
Combat:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Callback = function()
        Rayfield:Notify({Title=SCRIPT_NAME, Content="Visual only", Duration=2})
    end
})

-- Visuals
local Visuals = Window:CreateTab("Visuals", 7072725342)
Visuals:CreateToggle({
    Name = "ESP",
    CurrentValue = false,
    Callback = function()
        Rayfield:Notify({Title=SCRIPT_NAME, Content="Visual only", Duration=2})
    end
})

-- Status
local Status = Window:CreateTab("Status", 7734068321)
local StatusText = Status:CreateParagraph({
    Title = "Live Status",
    Content = "Loading..."
})

-- FPS Counter
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

task.spawn(function()
    while true do
        task.wait(1)
        local ping = 0
        pcall(function()
            ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        end)

        StatusText:Set({
            Title = "Live Status",
            Content =
                "Version: " .. SCRIPT_VERSION .. "\n" ..
                "FPS: " .. fps .. "\n" ..
                "Ping: " .. ping .. " ms\n" ..
                "Uptime: " .. math.floor(os.clock() - startTime) .. "s"
        })
    end
end)
