--[[
    SystemUI - A modern, system-like UI library for Roblox
    Inspired by Rayfield, but with a more minimalist and system-like appearance
    
    Features:
    - Modular component system
    - Smooth animations and transitions
    - Responsive design for all screen sizes
    - Customizable themes
    - Low performance impact
--]]

local SystemUI = {}
SystemUI.__index = SystemUI

-- Services
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

-- Constants
local TWEEN_SPEED = 0.2
local TWEEN_STYLE = Enum.EasingStyle.Quint
local TWEEN_DIRECTION = Enum.EasingDirection.Out

-- Load Components
local Components = {
    local Button = loadstring(game:HttpGet('https://raw.githubusercontent.com/KingTIM3R/UI_HUB_A4/refs/heads/main/Button.lua'))()
    local Toggle = loadstring(game:HttpGet('https://raw.githubusercontent.com/KingTIM3R/UI_HUB_A4/refs/heads/main/Toggle.lua'))()
    local Slider = loadstring(game:HttpGet('https://raw.githubusercontent.com/KingTIM3R/UI_HUB_A4/refs/heads/main/Slider.lua'))()
    local Input = loadstring(game:HttpGet('https://raw.githubusercontent.com/KingTIM3R/UI_HUB_A4/refs/heads/main/Input.lua'))()
    local Dropdown = loadstring(game:HttpGet('https://raw.githubusercontent.com/KingTIM3R/UI_HUB_A4/refs/heads/main/Dropdown.lua'))()
    local Keybind = loadstring(game:HttpGet('https://raw.githubusercontent.com/KingTIM3R/UI_HUB_A4/refs/heads/main/Keybind.lua'))()
    local ColorPicker = loadstring(game:HttpGet('https://raw.githubusercontent.com/KingTIM3R/UI_HUB_A4/refs/heads/main/ColorPicker.lua'))()
}

-- Load Utilities
local Theme = loadstring(game:HttpGet('https://raw.githubusercontent.com/KingTIM3R/UI_HUB_A4/refs/heads/main/Theme.lua'))()
local Animations = loadstring(game:HttpGet('https://raw.githubusercontent.com/KingTIM3R/UI_HUB_A4/refs/heads/main/Animations.lua'))()
local Scailing = loadstring(game:HttpGet('https://raw.githubusercontent.com/KingTIM3R/UI_HUB_A4/refs/heads/main/Scaling.lua'))()

-- Initialize variables
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local Library = {
    Windows = {},
    Theme = Theme.Default,
    Toggled = true,
    ActiveWindow = nil,
    ToggleKey = Enum.KeyCode.RightShift
}

-- Create SystemUI interface
function SystemUI.new(options)
    options = options or {}
    
    local self = setmetatable({}, SystemUI)
    
    -- Apply custom options
    self.Name = options.Name or "SystemUI"
    self.Theme = options.Theme or Theme.Default
    self.ToggleKey = options.ToggleKey or Enum.KeyCode.RightShift
    
    -- Create main GUI
    self:CreateMainGUI()
    
    -- Set up input handling
    self:SetupInputHandling()
    
    return self
end

function SystemUI:CreateMainGUI()
    -- Create ScreenGui
    local success, result = pcall(function()
        return CoreGui:FindFirstChild(self.Name) or Instance.new("ScreenGui")
    end)
    
    -- If exploits are not allowed to use CoreGui
    if not success then
        self.GUI = Instance.new("ScreenGui")
        self.GUI.Parent = Player:WaitForChild("PlayerGui")
    else
        self.GUI = result
        self.GUI.Name = self.Name
        
        -- Only set parent if it doesn't exist yet
        if self.GUI.Parent ~= CoreGui then
            self.GUI.Parent = CoreGui
        end
    end
    
    -- GUI properties
    self.GUI.DisplayOrder = 999
    self.GUI.ResetOnSpawn = false
    self.GUI.IgnoreGuiInset = true
    self.GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- If newer Roblox property exists, use it
    pcall(function()
        self.GUI.ScreenInsets = Enum.ScreenInsets.None
    end)
    
    -- Create container for notifications
    self.NotificationContainer = Instance.new("Frame")
    self.NotificationContainer.Name = "NotificationContainer"
    self.NotificationContainer.BackgroundTransparency = 1
    self.NotificationContainer.Position = UDim2.new(1, -30, 0, 30)
    self.NotificationContainer.Size = UDim2.new(0, 300, 1, -60)
    self.NotificationContainer.AnchorPoint = Vector2.new(1, 0)
    self.NotificationContainer.Parent = self.GUI
    
    -- Create UIListLayout for notifications
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 10)
    listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    listLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = self.NotificationContainer
end

function SystemUI:SetupInputHandling()
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == self.ToggleKey then
            self:ToggleUI()
        end
    end)
end

function SystemUI:ToggleUI()
    self.Toggled = not self.Toggled
    
    for _, window in pairs(self.Windows) do
        if window.Frame then
            Animations.FadeTransparency(window.Frame, self.Toggled and 0 or 1, TWEEN_SPEED)
        end
    end
end

function SystemUI:CreateWindow(options)
    options = options or {}
    options.Library = self
    
    local window = Components.Window.new(options)
    table.insert(self.Windows, window)
    
    return window
end

function SystemUI:Notification(options)
    options = options or {}
    
    -- Create notification frame
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.Size = UDim2.new(1, 0, 0, 80)
    notification.BackgroundColor3 = self.Theme.Background
    notification.BorderSizePixel = 0
    notification.Parent = self.NotificationContainer
    
    -- Add corner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = notification
    
    -- Add shadow
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.ZIndex = -1
    shadow.Image = "rbxassetid://6015897843"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.6
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    shadow.Parent = notification
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -20, 0, 30)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.Font = Enum.Font.SourceSansBold
    title.Text = options.Title or "Notification"
    title.TextColor3 = self.Theme.TextPrimary
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.BackgroundTransparency = 1
    title.Parent = notification
    
    -- Description
    local description = Instance.new("TextLabel")
    description.Name = "Description"
    description.Size = UDim2.new(1, -20, 0, 30)
    description.Position = UDim2.new(0, 10, 0, 40)
    description.Font = Enum.Font.SourceSans
    description.Text = options.Description or ""
    description.TextColor3 = self.Theme.TextSecondary
    description.TextSize = 16
    description.TextXAlignment = Enum.TextXAlignment.Left
    description.BackgroundTransparency = 1
    description.TextWrapped = true
    description.Parent = notification
    
    -- Animation
    notification.Position = UDim2.new(1, 500, 0, 0)
    notification.BackgroundTransparency = 1
    shadow.ImageTransparency = 1
    title.TextTransparency = 1
    description.TextTransparency = 1
    
    -- Animate in
    TweenService:Create(notification, TweenInfo.new(0.4, TWEEN_STYLE, TWEEN_DIRECTION), {
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 0
    }):Play()
    
    TweenService:Create(shadow, TweenInfo.new(0.4, TWEEN_STYLE, TWEEN_DIRECTION), {
        ImageTransparency = 0.6
    }):Play()
    
    TweenService:Create(title, TweenInfo.new(0.4, TWEEN_STYLE, TWEEN_DIRECTION), {
        TextTransparency = 0
    }):Play()
    
    TweenService:Create(description, TweenInfo.new(0.4, TWEEN_STYLE, TWEEN_DIRECTION), {
        TextTransparency = 0
    }):Play()
    
    -- Schedule destruction
    local duration = options.Duration or 5
    
    spawn(function()
        wait(duration)
        
        -- Animate out
        local outTween = TweenService:Create(notification, TweenInfo.new(0.4, TWEEN_STYLE, TWEEN_DIRECTION), {
            Position = UDim2.new(1, 500, 0, 0),
            BackgroundTransparency = 1
        })
        
        TweenService:Create(shadow, TweenInfo.new(0.4, TWEEN_STYLE, TWEEN_DIRECTION), {
            ImageTransparency = 1
        }):Play()
        
        TweenService:Create(title, TweenInfo.new(0.4, TWEEN_STYLE, TWEEN_DIRECTION), {
            TextTransparency = 1
        }):Play()
        
        TweenService:Create(description, TweenInfo.new(0.4, TWEEN_STYLE, TWEEN_DIRECTION), {
            TextTransparency = 1
        }):Play()
        
        outTween:Play()
        outTween.Completed:Wait()
        notification:Destroy()
    end)
end

function SystemUI:Destroy()
    for _, window in pairs(self.Windows) do
        if window.Destroy then
            window:Destroy()
        end
    end
    
    if self.GUI then
        self.GUI:Destroy()
    end
    
    self.Windows = {}
end

return SystemUI
