--// Polaris GUI Framework
--// Discord-inspired modular design
--// Glassmorphism, rounded aesthetics, smooth animations
-- and give credit because open sourced. made by azxerman000

local Polaris = {}
Polaris.__index = Polaris

--// Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")

--// Utility Module
local Utility = {}
Utility.__index = Utility

function Utility.new()
    local self = setmetatable({}, Utility)
    self.Connections = {}
    return self
end

function Utility:Create(className, properties)
    local instance = Instance.new(className)
    for prop, value in pairs(properties or {}) do
        if prop ~= "Parent" then
            instance[prop] = value
        end
    end
    if properties and properties.Parent then
        instance.Parent = properties.Parent
    end
    return instance
end

function Utility:Tween(instance, properties, duration, easingStyle, easingDirection, delay)
    local tween = TweenService:Create(
        instance,
        TweenInfo.new(
            duration or 0.25, 
            easingStyle or Enum.EasingStyle.Quart, 
            easingDirection or Enum.EasingDirection.Out,
            0,
            false,
            delay or 0
        ),
        properties
    )
    tween:Play()
    return tween
end

function Utility:Round(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = instance
    return corner
end

function Utility:Stroke(instance, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Color3.fromRGB(255, 255, 255)
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0.8
    stroke.Parent = instance
    return stroke
end

function Utility:Padding(instance, top, left, bottom, right)
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, top or 0)
    padding.PaddingLeft = UDim.new(0, left or 0)
    padding.PaddingBottom = UDim.new(0, bottom or 0)
    padding.PaddingRight = UDim.new(0, right or 0)
    padding.Parent = instance
    return padding
end

function Utility:ListLayout(instance, padding, direction)
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, padding or 0)
    layout.FillDirection = direction or Enum.FillDirection.Vertical
    layout.Parent = instance
    return layout
end

function Utility:Shadow(instance, offset, blur, color)
    local shadow = self:Create("ImageLabel", {
        Name = "Shadow",
        Parent = instance,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, -offset or 15, 0, -offset or 15),
        Size = UDim2.new(1, (offset or 15) * 2, 1, (offset or 15) * 2),
        Image = "rbxassetid://6015897843",
        ImageColor3 = color or Color3.new(0, 0, 0),
        ImageTransparency = blur or 0.5,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450),
        ZIndex = instance.ZIndex - 1
    })
    return shadow
end

function Utility:MakeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragStart, startPos
    
    local inputBegan = handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    
    local inputEnded = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    local inputChanged = UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            self:Tween(frame, {
                Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y
                )
            }, 0.05, Enum.EasingStyle.Linear)
        end
    end)
    
    table.insert(self.Connections, inputBegan)
    table.insert(self.Connections, inputEnded)
    table.insert(self.Connections, inputChanged)
end

function Utility:Ripple(button, color)
    button.ClipsDescendants = true
    button.AutoButtonColor = false
    
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local ripple = self:Create("Frame", {
                Parent = button,
                BackgroundColor3 = color or Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 0.6,
                BorderSizePixel = 0,
                Position = UDim2.new(0, input.Position.X - button.AbsolutePosition.X - 5, 0, input.Position.Y - button.AbsolutePosition.Y - 5),
                Size = UDim2.new(0, 10, 0, 10),
                ZIndex = button.ZIndex + 1
            })
            self:Round(ripple, 50)
            
            self:Tween(ripple, {
                Size = UDim2.new(0, 200, 0, 200),
                Position = UDim2.new(0, input.Position.X - button.AbsolutePosition.X - 100, 0, input.Position.Y - button.AbsolutePosition.Y - 100),
                BackgroundTransparency = 1
            }, 0.5):Completed:Wait()
            
            ripple:Destroy()
        end
    end)
end

--// Theme System - Discord Inspired
local Theme = {}
Theme.__index = Theme

Theme.Presets = {
    Discord = {
        -- Backgrounds
        BackgroundPrimary = Color3.fromRGB(54, 57, 63),      -- Main bg
        BackgroundSecondary = Color3.fromRGB(47, 49, 54),    -- Channels sidebar
        BackgroundTertiary = Color3.fromRGB(32, 34, 37),     -- Server sidebar
        BackgroundFloating = Color3.fromRGB(24, 25, 28),     -- Floating elements
        
        -- Text
        TextNormal = Color3.fromRGB(220, 221, 222),
        TextMuted = Color3.fromRGB(185, 187, 190),
        TextLink = Color3.fromRGB(0, 176, 244),
        
        -- Interactive
        InteractiveNormal = Color3.fromRGB(185, 187, 190),
        InteractiveHover = Color3.fromRGB(220, 221, 222),
        InteractiveActive = Color3.fromRGB(255, 255, 255),
        
        -- Brand/Accent
        Brand = Color3.fromRGB(88, 101, 242),                -- Discord blurple
        BrandHover = Color3.fromRGB(71, 82, 196),
        
        -- Status
        Online = Color3.fromRGB(59, 165, 93),
        Idle = Color3.fromRGB(250, 166, 26),
        Dnd = Color3.fromRGB(237, 66, 69),
        Offline = Color3.fromRGB(185, 187, 190),
        
        -- Misc
        Mention = Color3.fromRGB(250, 166, 26),
        Spoiler = Color3.fromRGB(32, 34, 37),
        Border = Color3.fromRGB(32, 34, 37)
    },
    
    Dark = {
        BackgroundPrimary = Color3.fromRGB(30, 30, 30),
        BackgroundSecondary = Color3.fromRGB(25, 25, 25),
        BackgroundTertiary = Color3.fromRGB(20, 20, 20),
        BackgroundFloating = Color3.fromRGB(15, 15, 15),
        TextNormal = Color3.fromRGB(255, 255, 255),
        TextMuted = Color3.fromRGB(150, 150, 150),
        Brand = Color3.fromRGB(114, 137, 218),
        BrandHover = Color3.fromRGB(90, 110, 180)
    },
    
    Midnight = {
        BackgroundPrimary = Color3.fromRGB(20, 20, 35),
        BackgroundSecondary = Color3.fromRGB(15, 15, 30),
        BackgroundTertiary = Color3.fromRGB(10, 10, 25),
        BackgroundFloating = Color3.fromRGB(5, 5, 20),
        TextNormal = Color3.fromRGB(240, 240, 255),
        TextMuted = Color3.fromRGB(150, 150, 180),
        Brand = Color3.fromRGB(147, 51, 234),
        BrandHover = Color3.fromRGB(120, 40, 200)
    }
}

function Theme.new(presetName, customColors)
    local self = setmetatable({}, Theme)
    local base = Theme.Presets[presetName or "Discord"]
    
    self.Colors = setmetatable({}, {
        __index = function(_, key)
            return (customColors and customColors[key]) or base[key] or Color3.fromRGB(255, 255, 255)
        end
    })
    
    self.Font = Enum.Font.Gotham
    self.FontBold = Enum.Font.GothamBold
    self.FontMedium = Enum.Font.GothamMedium
    
    return self
end

--// Component Base
local Component = {}
Component.__index = Component

function Component.new(name, parent)
    local self = setmetatable({}, Component)
    self.Name = name or "Component"
    self.Parent = parent
    self.Instance = nil
    self.Utilities = Utility.new()
    self.Theme = parent and parent.Theme or Theme.new()
    return self
end

function Component:SetTheme(theme)
    self.Theme = theme
    self:UpdateTheme()
    return self
end

function Component:UpdateTheme() end

function Component:Destroy()
    for _, conn in pairs(self.Utilities.Connections) do
        if typeof(conn) == "RBXScriptConnection" then
            conn:Disconnect()
        end
    end
    if self.Instance then
        self.Instance:Destroy()
    end
end

--// Polaris Button Component
local PButton = setmetatable({}, {__index = Component})
PButton.__index = PButton

function PButton.new(parent, text, style, callback)
    local self = setmetatable(Component.new("Button", parent), PButton)
    self.Text = text or "Button"
    self.Style = style or "Primary" -- Primary, Secondary, Danger, Ghost
    self.Callback = callback or function() end
    
    self:Build()
    return self
end

function PButton:Build()
    local colors = {
        Primary = {bg = self.Theme.Colors.Brand, text = Color3.fromRGB(255, 255, 255), hover = self.Theme.Colors.BrandHover},
        Secondary = {bg = self.Theme.Colors.BackgroundFloating, text = self.Theme.Colors.TextNormal, hover = self.Theme.Colors.BackgroundSecondary},
        Danger = {bg = Color3.fromRGB(237, 66, 69), text = Color3.fromRGB(255, 255, 255), hover = Color3.fromRGB(200, 50, 50)},
        Ghost = {bg = Color3.fromRGB(0, 0, 0), text = self.Theme.Colors.TextMuted, hover = self.Theme.Colors.BackgroundFloating}
    }
    
    local style = colors[self.Style]
    
    self.Instance = self.Utilities:Create("TextButton", {
        Name = "PButton_" .. self.Text,
        Parent = self.Parent.Instance or self.Parent,
        BackgroundColor3 = style.bg,
        BackgroundTransparency = self.Style == "Ghost" and 1 or 0,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 32),
        Font = self.Theme.FontMedium,
        Text = self.Text,
        TextColor3 = style.text,
        TextSize = 14,
        AutoButtonColor = false
    })
    
    self.Utilities:Round(self.Instance, 4)
    
    -- Hover effects
    local originalBg = style.bg
    
    self.Instance.MouseEnter:Connect(function()
        self.Utilities:Tween(self.Instance, {
            BackgroundColor3 = style.hover,
            BackgroundTransparency = 0
        }, 0.2)
    end)
    
    self.Instance.MouseLeave:Connect(function()
        self.Utilities:Tween(self.Instance, {
            BackgroundColor3 = originalBg,
            BackgroundTransparency = self.Style == "Ghost" and 1 or 0
        }, 0.2)
    end)
    
    self.Instance.MouseButton1Click:Connect(function()
        self.Callback()
    end)
    
    self.Utilities:Ripple(self.Instance, Color3.fromRGB(255, 255, 255))
end

--// Polaris Toggle Component (Discord style)
local PToggle = setmetatable({}, {__index = Component})
PToggle.__index = PToggle

function PToggle.new(parent, text, default, callback)
    local self = setmetatable(Component.new("Toggle", parent), PToggle)
    self.Text = text or "Toggle"
    self.Value = default or false
    self.Callback = callback or function() end
    
    self:Build()
    return self
end

function PToggle:Build()
    self.Container = self.Utilities:Create("Frame", {
        Name = "PToggle_" .. self.Text,
        Parent = self.Parent.Instance or self.Parent,
        BackgroundColor3 = self.Theme.Colors.BackgroundFloating,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 44)
    })
    
    self.Utilities:Round(self.Container, 8)
    
    -- Label
    self.Label = self.Utilities:Create("TextLabel", {
        Parent = self.Container,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, 0),
        Size = UDim2.new(1, -70, 1, 0),
        Font = self.Theme.Font,
        Text = self.Text,
        TextColor3 = self.Theme.Colors.TextNormal,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Toggle Switch Container
    self.SwitchBg = self.Utilities:Create("Frame", {
        Name = "Switch",
        Parent = self.Container,
        BackgroundColor3 = self.Value and self.Theme.Colors.Brand or self.Theme.Colors.BackgroundSecondary,
        Position = UDim2.new(1, -50, 0.5, -10),
        Size = UDim2.new(0, 40, 0, 20)
    })
    
    self.Utilities:Round(self.SwitchBg, 10)
    
    -- Knob
    self.Knob = self.Utilities:Create("Frame", {
        Parent = self.SwitchBg,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Position = self.Value and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
        Size = UDim2.new(0, 16, 0, 16)
    })
    
    self.Utilities:Round(self.Knob, 8)
    
    -- Invisible button for clicking
    self.Button = self.Utilities:Create("TextButton", {
        Parent = self.Container,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = ""
    })
    
    self.Button.MouseButton1Click:Connect(function()
        self:SetValue(not self.Value)
    end)
    
    self.Instance = self.Container
end

function PToggle:SetValue(value)
    self.Value = value
    self.Callback(value)
    
    local targetPos = value and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    local targetColor = value and self.Theme.Colors.Brand or self.Theme.Colors.BackgroundSecondary
    
    self.Utilities:Tween(self.Knob, {Position = targetPos}, 0.2, Enum.EasingStyle.Quart)
    self.Utilities:Tween(self.SwitchBg, {BackgroundColor3 = targetColor}, 0.2)
end

--// Polaris Slider Component
local PSlider = setmetatable({}, {__index = Component})
PSlider.__index = PSlider

function PSlider.new(parent, text, min, max, default, suffix, callback)
    local self = setmetatable(Component.new("Slider", parent), PSlider)
    self.Text = text or "Slider"
    self.Min = min or 0
    self.Max = max or 100
    self.Value = default or min
    self.Suffix = suffix or ""
    self.Callback = callback or function() end
    self.Dragging = false
    
    self:Build()
    return self
end

function PSlider:Build()
    self.Container = self.Utilities:Create("Frame", {
        Name = "PSlider_" .. self.Text,
        Parent = self.Parent.Instance or self.Parent,
        BackgroundColor3 = self.Theme.Colors.BackgroundFloating,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 60)
    })
    
    self.Utilities:Round(self.Container, 8)
    self.Utilities:Padding(self.Container, 10, 12, 10, 12)
    
    -- Header with label and value
    self.Header = self.Utilities:Create("Frame", {
        Parent = self.Container,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 20)
    })
    
    self.Label = self.Utilities:Create("TextLabel", {
        Parent = self.Header,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.7, 0, 1, 0),
        Font = self.Theme.Font,
        Text = self.Text,
        TextColor3 = self.Theme.Colors.TextNormal,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    self.ValueLabel = self.Utilities:Create("TextLabel", {
        Parent = self.Header,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.7, 0, 0, 0),
        Size = UDim2.new(0.3, 0, 1, 0),
        Font = self.Theme.FontBold,
        Text = tostring(self.Value) .. self.Suffix,
        TextColor3 = self.Theme.Colors.Brand,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Right
    })
    
    -- Slider track
    self.Track = self.Utilities:Create("Frame", {
        Parent = self.Container,
        BackgroundColor3 = self.Theme.Colors.BackgroundSecondary,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 12, 0, 38),
        Size = UDim2.new(1, -24, 0, 6)
    })
    
    self.Utilities:Round(self.Track, 3)
    
    -- Fill
    local percent = (self.Value - self.Min) / (self.Max - self.Min)
    self.Fill = self.Utilities:Create("Frame", {
        Parent = self.Track,
        BackgroundColor3 = self.Theme.Colors.Brand,
        BorderSizePixel = 0,
        Size = UDim2.new(percent, 0, 1, 0)
    })
    
    self.Utilities:Round(self.Fill, 3)
    
    -- Handle/Knob
    self.Handle = self.Utilities:Create("Frame", {
        Parent = self.Track,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Position = UDim2.new(percent, -8, 0.5, -8),
        Size = UDim2.new(0, 16, 0, 16),
        ZIndex = 2
    })
    
    self.Utilities:Round(self.Handle, 8)
    
    -- Interaction area
    self.Interact = self.Utilities:Create("TextButton", {
        Parent = self.Track,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, -10),
        Size = UDim2.new(1, 0, 1, 20),
        Text = ""
    })
    
    -- Slider logic
    local function update(input)
        local pos = math.clamp((input.Position.X - self.Track.AbsolutePosition.X) / self.Track.AbsoluteSize.X, 0, 1)
        local value = self.Min + (self.Max - self.Min) * pos
        self:SetValue(value)
    end
    
    self.Interact.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.Dragging = true
            update(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.Dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if self.Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            update(input)
        end
    end)
    
    self.Instance = self.Container
end

function PSlider:SetValue(value)
    self.Value = math.clamp(math.round(value * 10) / 10, self.Min, self.Max)
    local percent = (self.Value - self.Min) / (self.Max - self.Min)
    
    self.Utilities:Tween(self.Fill, {Size = UDim2.new(percent, 0, 1, 0)}, 0.1)
    self.Utilities:Tween(self.Handle, {Position = UDim2.new(percent, -8, 0.5, -8)}, 0.1)
    self.ValueLabel.Text = string.format("%.1f", self.Value) .. self.Suffix
    
    self.Callback(self.Value)
end

--// Polaris Dropdown Component
local PDropdown = setmetatable({}, {__index = Component})
PDropdown.__index = PDropdown

function PDropdown.new(parent, text, options, default, callback)
    local self = setmetatable(Component.new("Dropdown", parent), PDropdown)
    self.Text = text or "Select"
    self.Options = options or {}
    self.Value = default or self.Options[1] or "None"
    self.Callback = callback or function() end
    self.Open = false
    
    self:Build()
    return self
end

function PDropdown:Build()
    self.Container = self.Utilities:Create("Frame", {
        Name = "PDropdown_" .. self.Text,
        Parent = self.Parent.Instance or self.Parent,
        BackgroundColor3 = self.Theme.Colors.BackgroundFloating,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 44),
        ClipsDescendants = true
    })
    
    self.Utilities:Round(self.Container, 8)
    
    -- Header button
    self.Header = self.Utilities:Create("TextButton", {
        Parent = self.Container,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 44),
        Font = self.Theme.Font,
        Text = "",
        TextColor3 = self.Theme.Colors.TextNormal,
        TextSize = 14
    })
    
    
