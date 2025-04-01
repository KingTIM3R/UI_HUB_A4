--[[
    Toggle Component
    Part of the SystemUI library
    Creates a toggle switch with animation
--]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Toggle = {}
Toggle.__index = Toggle

function Toggle.new(window, tab, options)
    local self = setmetatable({}, Toggle)
    
    self.Window = window
    self.Tab = tab
    self.Theme = window.Theme
    self.Text = options.Text or "Toggle"
    self.Default = options.Default or false
    self.Callback = options.Callback or function() end
    self.Value = self.Default
    
    self:Create()
    
    return self
end

function Toggle:Create()
    -- Main container
    self.Container = Instance.new("Frame")
    self.Container.Name = "Toggle_" .. self.Text
    self.Container.Size = UDim2.new(1, 0, 0, 40)
    self.Container.BackgroundTransparency = 1
    self.Container.Parent = self.Tab.Content
    
    -- Button
    self.Instance = Instance.new("TextButton")
    self.Instance.Name = "ToggleInstance"
    self.Instance.Size = UDim2.new(1, 0, 1, 0)
    self.Instance.BackgroundColor3 = self.Theme.ComponentBackground
    self.Instance.BorderSizePixel = 0
    self.Instance.Text = ""
    self.Instance.AutoButtonColor = false
    self.Instance.Parent = self.Container
    
    -- Corner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = self.Instance
    
    -- Text
    self.TextLabel = Instance.new("TextLabel")
    self.TextLabel.Name = "Text"
    self.TextLabel.Size = UDim2.new(1, -60, 1, 0)
    self.TextLabel.BackgroundTransparency = 1
    self.TextLabel.Text = self.Text
    self.TextLabel.Font = Enum.Font.SourceSans
    self.TextLabel.TextSize = 16
    self.TextLabel.TextColor3 = self.Theme.TextPrimary
    self.TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TextLabel.Position = UDim2.new(0, 15, 0, 0)
    self.TextLabel.Parent = self.Instance
    
    -- Toggle background
    self.ToggleBackground = Instance.new("Frame")
    self.ToggleBackground.Name = "ToggleBackground"
    self.ToggleBackground.Size = UDim2.new(0, 40, 0, 20)
    self.ToggleBackground.Position = UDim2.new(1, -50, 0.5, -10)
    self.ToggleBackground.BorderSizePixel = 0
    self.ToggleBackground.BackgroundColor3 = self.Theme.ToggleBackgroundOff
    self.ToggleBackground.Parent = self.Instance
    
    -- Corner for toggle background
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 10)
    toggleCorner.Parent = self.ToggleBackground
    
    -- Toggle knob
    self.ToggleKnob = Instance.new("Frame")
    self.ToggleKnob.Name = "ToggleKnob"
    self.ToggleKnob.Size = UDim2.new(0, 16, 0, 16)
    self.ToggleKnob.Position = UDim2.new(0, 2, 0.5, -8)
    self.ToggleKnob.BorderSizePixel = 0
    self.ToggleKnob.BackgroundColor3 = self.Theme.ToggleKnob
    self.ToggleKnob.Parent = self.ToggleBackground
    
    -- Corner for toggle knob
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = self.ToggleKnob
    
    -- Shadow for knob
    local knobShadow = Instance.new("ImageLabel")
    knobShadow.Name = "Shadow"
    knobShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    knobShadow.BackgroundTransparency = 1
    knobShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    knobShadow.Size = UDim2.new(1.2, 0, 1.2, 0)
    knobShadow.ZIndex = -1
    knobShadow.Image = "rbxassetid://6015897843"
    knobShadow.ImageColor3 = Color3.new(0, 0, 0)
    knobShadow.ImageTransparency = 0.6
    knobShadow.ScaleType = Enum.ScaleType.Slice
    knobShadow.SliceCenter = Rect.new(49, 49, 450, 450)
    knobShadow.Parent = self.ToggleKnob
    
    -- Connect events
    self:ConnectEvents()
    
    -- Set initial state
    if self.Value then
        self:Set(true, true)
    end
end

function Toggle:ConnectEvents()
    -- Mouse enter (hover)
    self.Instance.MouseEnter:Connect(function()
        TweenService:Create(self.Instance, TweenInfo.new(0.2), {
            BackgroundColor3 = self.Theme.ComponentBackgroundHover
        }):Play()
    end)
    
    -- Mouse leave
    self.Instance.MouseLeave:Connect(function()
        TweenService:Create(self.Instance, TweenInfo.new(0.2), {
            BackgroundColor3 = self.Theme.ComponentBackground
        }):Play()
    end)
    
    -- Click
    self.Instance.MouseButton1Click:Connect(function()
        self:Set(not self.Value)
    end)
end

function Toggle:Set(value, skipCallback)
    self.Value = value
    
    -- Update visuals
    if value then
        -- Toggle on
        TweenService:Create(self.ToggleBackground, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
            BackgroundColor3 = self.Theme.ToggleBackgroundOn
        }):Play()
        
        TweenService:Create(self.ToggleKnob, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
            Position = UDim2.new(0, 22, 0.5, -8)
        }):Play()
    else
        -- Toggle off
        TweenService:Create(self.ToggleBackground, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
            BackgroundColor3 = self.Theme.ToggleBackgroundOff
        }):Play()
        
        TweenService:Create(self.ToggleKnob, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
            Position = UDim2.new(0, 2, 0.5, -8)
        }):Play()
    end
    
    -- Call callback if applicable
    if not skipCallback then
        self.Callback(self.Value)
    end
end

function Toggle:SetVisible(visible)
    self.Container.Visible = visible
end

function Toggle:UpdateText(text)
    self.Text = text
    self.TextLabel.Text = text
end

function Toggle:Destroy()
    if self.Container then
        self.Container:Destroy()
    end
end

return Toggle
