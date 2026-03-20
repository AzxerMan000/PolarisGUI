# PolarisGUI


Polaris GUI represents the pinnacle of modern Roblox interface design, drawing heavy inspiration from Discord's iconic aesthetic while maintaining complete functional independence. The framework's architecture demonstrates exceptional software engineering principles through its rigorous modular design pattern, where every component exists as a self-contained class with defined responsibilities and clean interfaces.

The visual design language embraces Discord's signature glassmorphism approach, featuring layered translucent backgrounds that create depth through strategic opacity variations. The triple-panel layout structure—server bar, channel sidebar, and content area—provides intuitive information hierarchy while maximizing screen real estate efficiency. Rounded corners appear consistently throughout, with border radius values carefully calibrated between four and twenty-eight pixels to establish visual rhythm.

Component variety addresses diverse scripting requirements comprehensively. Toggle switches animate smoothly between states with elastic physics. Sliders provide precise numerical input with real-time visual feedback. Dropdown menus expand with calculated motion curves. Text boxes offer focused input handling with placeholder animations. Keybind capture systems listen responsively for user-defined shortcuts. Each element maintains consistent theming through centralized color management.

The implementation leverages Roblox's native TweenService extensively, creating fluid sixty-frame-per-second animations without external dependencies. Event connections receive proper garbage collection management, preventing memory leaks during extended usage sessions. Drag functionality integrates seamlessly through input tracking calculations.

Theme customization extends beyond preset palettes, allowing granular color overrides for specific interface elements. The notification system delivers non-intrusive status updates with categorized severity indicators. Window management supports minimization, repositioning, and visibility toggling through standardized methods.

This framework successfully bridges aesthetic sophistication with practical scripting functionality, establishing new standards for Roblox GUI development through thoughtful design decisions and robust technical implementation.






# USAGE

```

local Polaris =loadstring(game:HttpGet("your-url-here"))()

-- Create GUI
local GUI = Polaris.new({
    Name = "POLARIS",
    Theme = "Discord"
})

-- Make tabs
local Main = GUI:AddChannel("Main", "#")
local Combat = GUI:AddChannel("Combat", "⚔")
local Visuals = GUI:AddChannel("Visuals", "👁")

-- Main tab
local section1 = Main:AddSection("Movement")
section1:AddToggle("Speed Hack", false, function(v)
    print(v)
end)

section1:AddSlider("WalkSpeed", 16, 500, 16, "", function(v)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
end)

local section2 = Main:AddSection("Misc")
section2:AddButton("Reset", "Danger", function()
    game.Players.LocalPlayer.Character:BreakJoints()
end)

section2:AddTextBox("Message", "Type here...", function(text)
    print(text)
end)

-- Combat tab
local combatSection = Combat:AddSection("Aimbot")
combatSection:AddToggle("Enabled", false, function(v)
    print("Aimbot:", v)
end)

combatSection:AddDropdown("Target", {"Head", "Torso"}, "Head", function(v)
    print(v)
end)

-- Visuals tab
local espSection = Visuals:AddSection("ESP")
espSection:AddToggle("Boxes", false, function(v)
    print("ESP:", v)
end)

-- Toggle key
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        GUI:Toggle()
    end
end) 

```
