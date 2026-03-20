# PolarisGUI


Polaris GUI is a Discord-inspired Roblox framework that dropped as open source. Anyone can grab the code, modify it, or contribute fixes. The modular design means you can rip out components you don't need or add your own custom elements. It's built by the community for the community with no paywalls or hidden garbage. The triple-panel layout, glass effects, and smooth animations are all there for anyone to use, study, or improve. Open source keeps it transparent and lets scripters learn from real production code instead of some locked down black box.






# USAGE

```
local Polaris=loadstring(game:HttpGet("https://raw.githubusercontent.com/AzxerMan000/PolarisGUI/refs/heads/main/Source/main.lua"))()

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
