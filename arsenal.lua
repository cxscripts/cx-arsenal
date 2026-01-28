-- CX Arsenal
-- Version: v1.1 - Main Menu Fix
-- Key: cx2026

-- =============================================
-- ARSENAL GAME CHECK (ONLY WORKS IN ARSENAL!)
-- =============================================
if game.PlaceId ~= 286090429 then
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
    LocalPlayer:Kick("❌ CX Arsenal only works in Arsenal! Join Arsenal to use this script.")
    return
end

local success, Rayfield = pcall(loadstring(game:HttpGet("https://sirius.menu/rayfield")))
if not success or not Rayfield then
    warn("Rayfield load failed")
    return
end

print("========================================")
print("Loaded CX Arsenal v1.1")
print("Game: Arsenal (Verified)")
print("========================================")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local SCRIPT_NAME = "CX Arsenal"
local SCRIPT_VERSION = "v1.1"

-- Name Protect Vars
local NameProtectEnabled = false
local NameProtectConnections = {}
local RealName = LocalPlayer.Name
local RealDisplay = LocalPlayer.DisplayName
local CONFIG = {
    FakeName = "CX",
    FakeDisplay = "CX",
    MatchColor = true
}

-- Function that instantly replaces text
local function SpoofText(obj)
    if not obj or not obj.Text then return end
    if not obj.Text:find(RealName) and not obj.Text:find(RealDisplay) then return end
    
    local originalText = obj.Text
    local newText = originalText:gsub(RealName, CONFIG.FakeName)
    newText = newText:gsub(RealDisplay, CONFIG.FakeDisplay)
    
    if originalText ~= newText then
        obj.Text = newText
    end
end

-- Function to process an object
local function MonitorObject(obj)
    if not obj then return end
    if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
        pcall(function()
            SpoofText(obj)
        end)
        
        pcall(function()
            local conn = obj:GetPropertyChangedSignal("Text"):Connect(function()
                SpoofText(obj)
            end)
            table.insert(NameProtectConnections, conn)
        end)
    end
end

-- Handle character
local function MonitorCharacter(char)
    if not char then return end
    local humanoid = char:WaitForChild("Humanoid", 10)
    if humanoid then
        humanoid.DisplayName = CONFIG.FakeDisplay
        
        pcall(function()
            local conn = humanoid:GetPropertyChangedSignal("DisplayName"):Connect(function()
                if humanoid.DisplayName ~= CONFIG.FakeDisplay then
                    humanoid.DisplayName = CONFIG.FakeDisplay
                end
            end)
            table.insert(NameProtectConnections, conn)
        end)
    end
end

local function EnableNameProtect()
    for _, conn in ipairs(NameProtectConnections) do
        pcall(function() conn:Disconnect() end)
    end
    NameProtectConnections = {}
    
    pcall(function()
        for _, v in ipairs(LocalPlayer.PlayerGui:GetDescendants()) do
            MonitorObject(v)
        end
    end)
    
    pcall(function()
        local conn1 = LocalPlayer.PlayerGui.DescendantAdded:Connect(MonitorObject)
        table.insert(NameProtectConnections, conn1)
    end)
    
    pcall(function()
        local CoreGui = game:GetService("CoreGui")
        for _, v in ipairs(CoreGui:GetDescendants()) do
            MonitorObject(v)
        end
        local conn2 = CoreGui.DescendantAdded:Connect(MonitorObject)
        table.insert(NameProtectConnections, conn2)
    end)
    
    if LocalPlayer.Character then
        MonitorCharacter(LocalPlayer.Character)
    end
    
    pcall(function()
        local conn3 = LocalPlayer.CharacterAdded:Connect(MonitorCharacter)
        table.insert(NameProtectConnections, conn3)
    end)
    
    Rayfield:Notify({
        Title = "Streamer Mode ON",
        Content = "Your name is now protected across all UI elements",
        Duration = 4
    })
end

-- ESP Vars
local ESP_ENABLED = false
local TEAM_CHECK = true
local RAINBOW_ESP = false
local ESP_COLOR = Color3.fromRGB(255, 50, 50)
local ESP_OBJECTS = {}
local espUpdateConn

local function CreateESP(player)
    if not player or player == LocalPlayer or ESP_OBJECTS[player] then return end
    
    pcall(function()
        local box = Drawing.new("Square")
        box.Thickness = 2
        box.Filled = false
        box.Transparency = 1
        box.Color = ESP_COLOR
        box.Visible = false

        local tracer = Drawing.new("Line")
        tracer.Thickness = 1.5
        tracer.Color = ESP_COLOR
        tracer.Transparency = 0.8
        tracer.Visible = false

        ESP_OBJECTS[player] = {box = box, tracer = tracer}
    end)
end

local function RemoveESP(player)
    local esp = ESP_OBJECTS[player]
    if esp then
        pcall(function()
            esp.box:Remove()
            esp.tracer:Remove()
        end)
        ESP_OBJECTS[player] = nil
    end
end

local function UpdateESP()
    if not ESP_ENABLED then return end
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
    for _, player in Players:GetPlayers() do
        pcall(function()
            local esp = ESP_OBJECTS[player]
            if not esp then return end

            local char = player.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Head") then
                esp.box.Visible = false
                esp.tracer.Visible = false
                return
            end

            local hum = char:FindFirstChild("Humanoid")
            if not hum or hum.Health <= 0 then
                esp.box.Visible = false
                esp.tracer.Visible = false
                return
            end

            -- Ignore players below the map (main menu)
            if char.HumanoidRootPart.Position.Y < -50 then
                esp.box.Visible = false
                esp.tracer.Visible = false
                return
            end

            if TEAM_CHECK and LocalPlayer.Team == player.Team then
                esp.box.Visible = false
                esp.tracer.Visible = false
                return
            end

            local rootPos, vis = Camera:WorldToViewportPoint(char.HumanoidRootPart.Position)
            if not vis then
                esp.box.Visible = false
                esp.tracer.Visible = false
                return
            end

            local headPos = Camera:WorldToViewportPoint(char.Head.Position + Vector3.new(0,0.5,0))
            local legPos = Camera:WorldToViewportPoint(char.HumanoidRootPart.Position - Vector3.new(0,3,0))
            local h = math.clamp((headPos.Y - legPos.Y) * 1.2, 20, 500)
            local w = h * 0.5

            esp.box.Size = Vector2.new(w, h)
            esp.box.Position = Vector2.new(rootPos.X - w/2, rootPos.Y - h/2)
            esp.box.Visible = true

            esp.tracer.From = center
            esp.tracer.To = Vector2.new(rootPos.X, rootPos.Y)
            esp.tracer.Visible = true

            local color = RAINBOW_ESP and Color3.fromHSV(tick() * 0.2 % 1, 1, 1) or ESP_COLOR
            esp.box.Color = color
            esp.tracer.Color = color
        end)
    end
end

-- Aimbot Vars
local AIMBOT_ENABLED = false
local AIM_SMOOTHNESS = 0.4
local AIM_FOV = 150
local AIM_FOV_VISIBLE = false
local AIM_FOV_RAINBOW = false
local AIM_FOV_COLOR = Color3.fromRGB(255, 255, 255)

local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 2
fovCircle.NumSides = 60
fovCircle.Radius = AIM_FOV
fovCircle.Filled = false
fovCircle.Transparency = 0.7
fovCircle.Visible = AIM_FOV_VISIBLE
fovCircle.Color = AIM_FOV_COLOR

local aimConn

local function GetClosestTarget()
    local closest, minDist = nil, AIM_FOV
    local mouse = UserInputService:GetMouseLocation()
    for _, p in Players:GetPlayers() do
        pcall(function()
            if p == LocalPlayer or not p.Character then return end
            local head = p.Character:FindFirstChild("Head")
            local hum = p.Character:FindFirstChild("Humanoid")
            if not head or not hum or hum.Health <= 0 then return end
            
            -- Ignore players below the map (main menu)
            if head.Position.Y < -50 then return end
            
            if TEAM_CHECK and LocalPlayer.Team == p.Team then return end
            local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
            if not onScreen then return end
            local d = (Vector2.new(pos.X, pos.Y) - mouse).Magnitude
            if d < minDist then
                minDist = d
                closest = p
            end
        end)
    end
    return closest
end

local function StartAimbot()
    if aimConn then aimConn:Disconnect() end
    aimConn = RunService.RenderStepped:Connect(function(dt)
        pcall(function()
            if not AIMBOT_ENABLED or not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end
            local target = GetClosestTarget()
            if not target or not target.Character or not target.Character:FindFirstChild("Head") then return end
            local tgtPos = target.Character.Head.Position
            local cf = Camera.CFrame
            local tgtCf = CFrame.new(cf.Position, tgtPos)
            local alpha = 1 - (1 - AIM_SMOOTHNESS)^(dt * 60)
            Camera.CFrame = cf:Lerp(tgtCf, alpha)
        end)
    end)
end

-- Window
local Window = Rayfield:CreateWindow({
    Name = SCRIPT_NAME .. " | 2026",
    LoadingTitle = SCRIPT_NAME,
    LoadingSubtitle = "v1.1",
    ConfigurationSaving = {Enabled = false},
    Discord = {Enabled = false},
    KeySystem = true,
    KeySettings = {
        Title = SCRIPT_NAME .. " | Key System",
        Subtitle = "Enter key to continue",
        Note = "Key: cx2026",
        FileName = "CXKey",
        SaveKey = false,
        GrabKeyFromSite = false,
        Key = {"cx2026"}
    }
})

Rayfield:Notify({
    Title = "CX Arsenal v1.1",
    Content = "Welcome! Script loaded successfully",
    Duration = 5
})

-- Create tabs
local Updates = Window:CreateTab("Updates", 7733955511)
local Combat = Window:CreateTab("Combat", 7072725342)
local Visuals = Window:CreateTab("Visuals", 4483362458)
local Player = Window:CreateTab("Player", 7734068321)
local Misc = Window:CreateTab("Misc", 7734021231)
local Server = Window:CreateTab("Server", 7743875529)

-- =============================================
-- UPDATES TAB
-- =============================================
Updates:CreateParagraph({
    Title = "CX Arsenal - Version History",
    Content = "All major updates and changes to the script"
})

Updates:CreateSection("🎉 v1.1 - Current Version")

Updates:CreateParagraph({
    Title = "v1.1 Updates (Latest)",
    Content = [[
- yo fixed that annoying aimbot bug
- it kept locking onto people in the lobby lmao
- esp was doing the same thing so i fixed that too
- basically if ur below the map it ignores u now
- way better aiming trust
]]
})

Updates:CreateSection("📜 Previous Versions")

Updates:CreateParagraph({
    Title = "v1.0",
    Content = "• first version lol\n• had some bugs but whatever\n• worked most of the time"
})

-- Server Info Vars
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

-- Performance monitor vars
local pingLabel
local fpsLabel
local currentPing = 0
local currentFPS = 0

-- Calculate FPS
local lastUpdate = tick()
local frameCount = 0

RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    local now = tick()
    if now - lastUpdate >= 1 then
        currentFPS = frameCount
        frameCount = 0
        lastUpdate = now
    end
end)

-- Calculate Ping
task.spawn(function()
    while true do
        pcall(function()
            local success, ping = pcall(function()
                return Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
            end)
            if success then
                currentPing = math.floor(ping)
            end
        end)
        task.wait(1)
    end
end)

-- Hitbox Expander Vars
local HITBOX_ENABLED = false
local HITBOX_TRANSPARENCY = 1
local hitboxExpanderConnection

local function EnableHitboxExpander()
    if hitboxExpanderConnection then
        hitboxExpanderConnection:Disconnect()
    end
    
    hitboxExpanderConnection = RunService.Heartbeat:Connect(function()
        if not HITBOX_ENABLED then
            if hitboxExpanderConnection then
                hitboxExpanderConnection:Disconnect()
                hitboxExpanderConnection = nil
            end
            return
        end
        
        for _, v in pairs(Players:GetPlayers()) do
            pcall(function()
                if v.Name ~= LocalPlayer.Name and v.Character then
                    if v.Character:FindFirstChild("RightUpperLeg") then
                        v.Character.RightUpperLeg.CanCollide = false
                        v.Character.RightUpperLeg.Transparency = HITBOX_TRANSPARENCY
                        v.Character.RightUpperLeg.Size = Vector3.new(13, 13, 13)
                    end
                    
                    if v.Character:FindFirstChild("LeftUpperLeg") then
                        v.Character.LeftUpperLeg.CanCollide = false
                        v.Character.LeftUpperLeg.Transparency = HITBOX_TRANSPARENCY
                        v.Character.LeftUpperLeg.Size = Vector3.new(13, 13, 13)
                    end
                    
                    if v.Character:FindFirstChild("HeadHB") then
                        v.Character.HeadHB.CanCollide = false
                        v.Character.HeadHB.Transparency = HITBOX_TRANSPARENCY
                        v.Character.HeadHB.Size = Vector3.new(13, 13, 13)
                    end
                    
                    if v.Character:FindFirstChild("HumanoidRootPart") then
                        v.Character.HumanoidRootPart.CanCollide = false
                        v.Character.HumanoidRootPart.Transparency = HITBOX_TRANSPARENCY
                        v.Character.HumanoidRootPart.Size = Vector3.new(13, 13, 13)
                    end
                end
            end)
        end
    end)
    
    Rayfield:Notify({Title = "Hitbox Expander", Content = "Enabled! Enemy hitboxes expanded", Duration = 3})
end

local function DisableHitboxExpander()
    if hitboxExpanderConnection then
        hitboxExpanderConnection:Disconnect()
        hitboxExpanderConnection = nil
    end
    
    Rayfield:Notify({Title = "Hitbox Expander", Content = "Disabled!", Duration = 3})
end

-- WALKSPEED SYSTEM
local WALKSPEED_ENABLED = false
local WALKSPEED = 16
local walkspeedConnection

local function ApplyWalkSpeed()
    pcall(function()
        local character = LocalPlayer.Character
        if not character then return end
        
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        
        if WALKSPEED_ENABLED then
            humanoid.WalkSpeed = WALKSPEED
        else
            humanoid.WalkSpeed = 16
        end
    end)
end

local function StartWalkSpeedLoop()
    if walkspeedConnection then walkspeedConnection:Disconnect() end
    
    walkspeedConnection = RunService.Heartbeat:Connect(function()
        if WALKSPEED_ENABLED then
            pcall(function()
                local character = LocalPlayer.Character
                if character then
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid and humanoid.WalkSpeed ~= WALKSPEED then
                        humanoid.WalkSpeed = WALKSPEED
                    end
                end
            end)
        end
    end)
end

local function StopWalkSpeedLoop()
    if walkspeedConnection then
        walkspeedConnection:Disconnect()
        walkspeedConnection = nil
    end
    
    pcall(function()
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16
            end
        end
    end)
end

-- INFINITE JUMP SYSTEM
local INFINITE_JUMP_ENABLED = false
local infJumpConnection

local function StartInfiniteJump()
    if infJumpConnection then infJumpConnection:Disconnect() end
    
    infJumpConnection = UserInputService.JumpRequest:Connect(function()
        pcall(function()
            if not INFINITE_JUMP_ENABLED then return end
            
            local character = LocalPlayer.Character
            if not character then return end
            
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end)
end

local function StopInfiniteJump()
    if infJumpConnection then
        infJumpConnection:Disconnect()
        infJumpConnection = nil
    end
end

-- FLY SYSTEM
local FLY_ENABLED = false
local FLY_SPEED = 50
local flyConnection

local function StartFly()
    pcall(function()
        local character = LocalPlayer.Character
        if not character then return end
        
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end
        
        if flyConnection then flyConnection:Disconnect() end
        
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = true
        end
        
        flyConnection = RunService.Heartbeat:Connect(function()
            pcall(function()
                if not FLY_ENABLED or not character or not character.Parent then
                    if flyConnection then 
                        flyConnection:Disconnect() 
                        flyConnection = nil 
                    end
                    if humanoid then
                        humanoid.PlatformStand = false
                    end
                    return
                end
                
                if not rootPart or not rootPart.Parent then return end
                
                rootPart.Velocity = Vector3.new(0, 0, 0)
                rootPart.RotVelocity = Vector3.new(0, 0, 0)
                
                local moveDirection = Vector3.new(0, 0, 0)
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    moveDirection = moveDirection + Camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    moveDirection = moveDirection - Camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    moveDirection = moveDirection - Camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    moveDirection = moveDirection + Camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    moveDirection = moveDirection + Vector3.new(0, 1, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    moveDirection = moveDirection - Vector3.new(0, 1, 0)
                end
                
                if moveDirection.Magnitude > 0 then
                    moveDirection = moveDirection.Unit
                    rootPart.CFrame = rootPart.CFrame + (moveDirection * FLY_SPEED * 0.016)
                end
                
                rootPart.CFrame = CFrame.new(rootPart.Position) * CFrame.Angles(0, math.rad(Camera.CFrame:ToEulerAnglesYXZ()), 0)
            end)
        end)
    end)
end

local function StopFly()
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    
    pcall(function()
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.PlatformStand = false
            end
            
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                rootPart.Velocity = Vector3.new(0, 0, 0)
                rootPart.RotVelocity = Vector3.new(0, 0, 0)
            end
        end
    end)
end

-- =============================================
-- RAINBOW GUN SYSTEM (MOVED TO VISUALS)
-- =============================================
local RAINBOW_GUN_ENABLED = false
local rainbowGunConnection
local coloredParts = {}

local rainbowSpeed = 0.13
local function zigzag(X)
    return math.acos(math.cos(X * math.pi)) / math.pi
end

local function StartRainbowGun()
    if rainbowGunConnection then rainbowGunConnection:Disconnect() end
    
    coloredParts = {}
    
    rainbowGunConnection = RunService.RenderStepped:Connect(function()
        pcall(function()
            if not RAINBOW_GUN_ENABLED then return end
            
            local arms = workspace.CurrentCamera:FindFirstChild("Arms")
            if arms then
                local hue = zigzag(tick() * rainbowSpeed)
                for _, v in pairs(arms:GetDescendants()) do
                    if v:IsA("BasePart") then
                        if not coloredParts[v] then
                            coloredParts[v] = {
                                OriginalColor = v.Color,
                                OriginalMaterial = v.Material
                            }
                        end
                        
                        v.Color = Color3.fromHSV(hue, 1, 1)
                    end
                end
            end
        end)
    end)
    
    Rayfield:Notify({
        Title = "Rainbow Gun",
        Content = "Enabled! Your gun is rainbow",
        Duration = 3
    })
end

local function StopRainbowGun()
    if rainbowGunConnection then
        rainbowGunConnection:Disconnect()
        rainbowGunConnection = nil
    end
    
    for part, data in pairs(coloredParts) do
        pcall(function()
            if part and part.Parent then
                part.Color = data.OriginalColor
                part.Material = data.OriginalMaterial
            end
        end)
    end
    coloredParts = {}
    
    Rayfield:Notify({
        Title = "Rainbow Gun",
        Content = "Disabled - colors restored",
        Duration = 2
    })
end

-- Handle character respawn
LocalPlayer.CharacterAdded:Connect(function(character)
    task.wait(0.5)
    
    coloredParts = {}
    
    if WALKSPEED_ENABLED then
        ApplyWalkSpeed()
    end
    if FLY_ENABLED then
        StartFly()
    end
    if INFINITE_JUMP_ENABLED then
        StartInfiniteJump()
    end
    if RAINBOW_GUN_ENABLED then
        StartRainbowGun()
    end
end)

-- =============================================
-- PLAYER TAB UI
-- =============================================
Player:CreateToggle({
    Name = "Fly (WASD + Space/Shift)",
    CurrentValue = false,
    Callback = function(v)
        FLY_ENABLED = v
        if v then
            StartFly()
            Rayfield:Notify({Title = "Fly", Content = "Enabled!", Duration = 3})
        else
            StopFly()
        end
    end
})

Player:CreateSlider({
    Name = "Fly Speed",
    Range = {10, 200},
    Increment = 5,
    Suffix = " speed",
    CurrentValue = 50,
    Callback = function(v)
        FLY_SPEED = v
    end
})

Player:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Callback = function(v)
        INFINITE_JUMP_ENABLED = v
        if v then
            StartInfiniteJump()
            Rayfield:Notify({Title = "Infinite Jump", Content = "Enabled!", Duration = 3})
        else
            StopInfiniteJump()
        end
    end
})

Player:CreateToggle({
    Name = "Custom WalkSpeed",
    CurrentValue = false,
    Callback = function(v)
        WALKSPEED_ENABLED = v
        if v then
            StartWalkSpeedLoop()
            ApplyWalkSpeed()
            Rayfield:Notify({Title = "WalkSpeed", Content = "Enabled!", Duration = 3})
        else
            StopWalkSpeedLoop()
        end
    end
})

Player:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 200},
    Increment = 1,
    Suffix = " speed",
    CurrentValue = 16,
    Callback = function(v)
        WALKSPEED = v
        if WALKSPEED_ENABLED then
            ApplyWalkSpeed()
        end
    end
})

-- Misc Tab UI
Misc:CreateButton({
    Name = "Kill GUI",
    Callback = function()
        print("========================================")
        print("Killed CX Arsenal v1.1")
        print("========================================")
        
        Rayfield:Notify({Title = "Destroying GUI...", Content = "Goodbye!", Duration = 2})
        
        task.wait(0.5)
        
        ESP_ENABLED = false
        AIMBOT_ENABLED = false
        FLY_ENABLED = false
        WALKSPEED_ENABLED = false
        HITBOX_ENABLED = false
        INFINITE_JUMP_ENABLED = false
        RAINBOW_GUN_ENABLED = false
        NameProtectEnabled = false
        
        if espUpdateConn then espUpdateConn:Disconnect() end
        if aimConn then aimConn:Disconnect() end
        if flyConnection then flyConnection:Disconnect() end
        if walkspeedConnection then walkspeedConnection:Disconnect() end
        if infJumpConnection then infJumpConnection:Disconnect() end
        if rainbowGunConnection then rainbowGunConnection:Disconnect() end
        for _, conn in ipairs(NameProtectConnections) do pcall(function() conn:Disconnect() end) end
        
        for p in pairs(ESP_OBJECTS) do RemoveESP(p) end
        
        pcall(function() fovCircle:Remove() end)
        
        StopFly()
        StopInfiniteJump()
        StopRainbowGun()
        
        if HITBOX_ENABLED then
            DisableHitboxExpander()
        end
        
        StopWalkSpeedLoop()
        
        task.wait(0.5)
        Rayfield:Destroy()
    end
})

-- Combat Tab UI
Combat:CreateToggle({
    Name = "Aimbot (Hold RMB - Head)",
    CurrentValue = false,
    Callback = function(v)
        AIMBOT_ENABLED = v
        if v then StartAimbot() else if aimConn then aimConn:Disconnect() aimConn = nil end end
    end
})

Combat:CreateSlider({
    Name = "Smoothness (%)",
    Range = {0, 100},
    Increment = 1,
    Suffix = "%",
    CurrentValue = 40,
    Callback = function(v) AIM_SMOOTHNESS = v / 100 end
})

Combat:CreateSlider({
    Name = "FOV Size",
    Range = {50, 800},
    Increment = 10,
    Suffix = "px",
    CurrentValue = 150,
    Callback = function(v) AIM_FOV = v fovCircle.Radius = v end
})

Combat:CreateToggle({
    Name = "Show FOV Circle",
    CurrentValue = false,
    Callback = function(v) AIM_FOV_VISIBLE = v fovCircle.Visible = v end
})

Combat:CreateToggle({
    Name = "Rainbow FOV",
    CurrentValue = false,
    Callback = function(v) AIM_FOV_RAINBOW = v end
})

Combat:CreateColorPicker({
    Name = "FOV Color",
    Color = AIM_FOV_COLOR,
    Callback = function(c) AIM_FOV_COLOR = c if not AIM_FOV_RAINBOW then fovCircle.Color = c end end
})

Combat:CreateToggle({
    Name = "Hitbox Expander",
    CurrentValue = false,
    Callback = function(v)
        HITBOX_ENABLED = v
        if v then
            EnableHitboxExpander()
        else
            DisableHitboxExpander()
        end
    end
})

Combat:CreateSlider({
    Name = "Hitbox Transparency",
    Range = {0, 100},
    Increment = 1,
    Suffix = "%",
    CurrentValue = 100,
    Callback = function(v)
        HITBOX_TRANSPARENCY = v / 100
    end
})

-- Visuals Tab UI
Visuals:CreateButton({
    Name = "Hide YOUR Name",
    Callback = function()
        if not NameProtectEnabled then
            NameProtectEnabled = true
            EnableNameProtect()
        else
            Rayfield:Notify({Title = "Streamer Mode", Content = "Already enabled!", Duration = 2})
        end
    end
})

Visuals:CreateSection("Gun Modifications")

Visuals:CreateToggle({
    Name = "Rainbow Gun",
    CurrentValue = false,
    Callback = function(v)
        RAINBOW_GUN_ENABLED = v
        if v then
            StartRainbowGun()
        else
            StopRainbowGun()
        end
    end
})

Visuals:CreateSection("ESP Options")

Visuals:CreateToggle({
    Name = "ESP (Boxes + Tracers)",
    CurrentValue = false,
    Callback = function(v)
        ESP_ENABLED = v
        if v then
            for _, p in Players:GetPlayers() do if p ~= LocalPlayer then CreateESP(p) end end
            if not espUpdateConn then espUpdateConn = RunService.RenderStepped:Connect(UpdateESP) end
        else
            if espUpdateConn then espUpdateConn:Disconnect() espUpdateConn = nil end
            for p in pairs(ESP_OBJECTS) do RemoveESP(p) end
        end
    end
})

Visuals:CreateToggle({Name = "Team Check", CurrentValue = true, Callback = function(v) TEAM_CHECK = v end})
Visuals:CreateToggle({Name = "Rainbow ESP", CurrentValue = false, Callback = function(v) RAINBOW_ESP = v end})
Visuals:CreateColorPicker({Name = "ESP Color", Color = ESP_COLOR, Callback = function(c) ESP_COLOR = c end})

-- =============================================
-- SERVER TAB UI
-- =============================================
Server:CreateLabel("🟢 Status: Undetected")

Server:CreateSection("Performance Monitor")

pingLabel = Server:CreateLabel("Ping: Calculating...")
fpsLabel = Server:CreateLabel("FPS: Calculating...")

task.spawn(function()
    while true do
        pcall(function()
            if pingLabel then
                pingLabel:Set("Ping: " .. currentPing .. " ms")
            end
            if fpsLabel then
                fpsLabel:Set("FPS: " .. currentFPS)
            end
        end)
        task.wait(0.5)
    end
end)

Server:CreateSection("Server Options")

Server:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        Rayfield:Notify({Title = "Rejoining...", Content = "Teleporting back", Duration = 2})
        task.wait(1)
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end
})

Server:CreateButton({
    Name = "Join New Server",
    Callback = function()
        Rayfield:Notify({Title = "Finding Server...", Content = "Searching", Duration = 2})
        task.wait(1)
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
})

-- FOV follow + rainbow
RunService.RenderStepped:Connect(function()
    pcall(function()
        fovCircle.Position = UserInputService:GetMouseLocation()
        if AIM_FOV_RAINBOW and AIM_FOV_VISIBLE then
            fovCircle.Color = Color3.fromHSV((tick() * 0.3) % 1, 1, 1)
        end
    end)
end)

-- Player handlers
Players.PlayerAdded:Connect(function(p)
    if ESP_ENABLED and p ~= LocalPlayer then task.delay(1, function() CreateESP(p) end) end
end)
Players.PlayerRemoving:Connect(RemoveESP)

-- UI toggle
UserInputService.InputBegan:Connect(function(input)
    pcall(function()
        if input.KeyCode == Enum.KeyCode.Insert then
            Rayfield:ToggleUI()
        end
    end)
end)

if INFINITE_JUMP_ENABLED then
    StartInfiniteJump()
end

-- Cleanup
game:BindToClose(function()
    print("========================================")
    print("Killed CX Arsenal v1.1")
    print("========================================")
    
    if espUpdateConn then espUpdateConn:Disconnect() end
    if aimConn then aimConn:Disconnect() end
    if flyConnection then flyConnection:Disconnect() end
    if hitboxExpanderConnection then hitboxExpanderConnection:Disconnect() end
    if walkspeedConnection then walkspeedConnection:Disconnect() end
    if infJumpConnection then infJumpConnection:Disconnect() end
    if rainbowGunConnection then rainbowGunConnection:Disconnect() end
    for p in pairs(ESP_OBJECTS) do RemoveESP(p) end
    for _, conn in ipairs(NameProtectConnections) do pcall(function() conn:Disconnect() end) end
    pcall(function() fovCircle:Remove() end)
    StopFly()
    StopInfiniteJump()
    StopRainbowGun()
end)
