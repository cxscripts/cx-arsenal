
local CombatTab = Window:CreateTab("Combat", 6034509993)

CombatTab:CreateParagraph({
    Title = "Combat",
    Content = "Visual-only placeholders\nNo functionality"
})

CombatTab:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Callback = function(v)
        Rayfield:Notify({
            Title = "CX Arsenal",
            Content = "Aimbot toggled (visual only)",
            Duration = 2
        })
    end
})

CombatTab:CreateToggle({
    Name = "Silent Aim",
    CurrentValue = false,
    Callback = function(v)
        Rayfield:Notify({
            Title = "CX Arsenal",
            Content = "Silent Aim toggled (visual only)",
            Duration = 2
        })
    end
})

CombatTab:CreateSlider({
    Name = "FOV",
    Range = {60, 120},
    Increment = 1,
    CurrentValue = 70,
    Callback = function(v)
        print("FOV slider (visual only):", v)
    end
})

------------------------------------------------
-- 👁 VISUALS (VISUAL ONLY)
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
        Rayfield:Notify({
            Title = "CX Arsenal",
            Content = "ESP toggled (visual only)",
            Duration = 2
        })
    end
})

VisualTab:CreateToggle({
    Name = "Box ESP",
    CurrentValue = false,
    Callback = function(v)
        Rayfield:Notify({
            Title = "CX Arsenal",
            Content = "Box ESP toggled (visual only)",
            Duration = 2
        })
    end
})
