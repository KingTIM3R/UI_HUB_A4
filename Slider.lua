--[[
    Slider Component
    Part of the SystemUI library
    Creates a slider control for numeric values
--]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Slider = {}
Slider.__index = Slider

function Slider.new(window, tab, options)
    local self = setmetatable({}, Slider)
    
    self.Window = window
    self.Tab = tab
    self.Theme = window.Theme
    self.Text = options.Text or "Slider"
    self.Min = options.Min or 0
    self.Max = options.Max or 100
    self.Default = options.Default or self.Min
    self.Increment = options.Increment or 1
    self.Suffix = options.Suffix or ""
    self.Callback = options.Callback or function() end
    self.Value = self.Default
    self.Dragging = false
    
    -- Ensure default is within bounds and properly incremented
    self.Value = math.clamp(self.Default, self.Min, self.Max)
    self.Value = math.floor(self.Value / self.Increment + 0.5) * self.Increment
    self.Value = self:RoundToIncrement(self.Value)
    
    self:Create()
    
    return self
end

function Slider:RoundToIncrement(value)
    return math.floor(value / self.Increment + 0.5) * self.Increment
end

function Slider:Create()
    -- Main container
    self.Container = Instance.new("Frame")
    self.Container.Name = "Slider_" .. self.Text
    self.Container.Size = UDim2.new(1, 0, 0, 60)
    self.Container.BackgroundTransparency = 1
    self.Container.Parent = self.Tab.Content
    
    -- Background
    self.Instance = Instance.new("Frame")
    self.Instance.Name = "SliderInstance"
    self.Instance.Size = UDim2.new(1, 0, 1, 0)
    self.Instance.BackgroundColor3 = self.Theme.ComponentBackground
    self.Instance.BorderSizePixel = 0
    self.Instance.Parent = self.Container
    
    -- Corner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = self.Instance
    
    -- Text label
    self.TextLabel = Instance.new("TextLabel")
    self.TextLabel.Name = "Title"
    self.TextLabel.Size = UDim2.new(1, -15, 0, 20)
    self.TextLabel.Position = UDim2.new(0, 15, 0, 10)
    self.TextLabel.BackgroundTransparency = 1
    self.TextLabel.Text = self.Text
    self.TextLabel.Font = Enum.Font.SourceSans
    self.TextLabel.TextSize = 16
    self.TextLabel.TextColor3 = self.Theme.TextPrimary
    self.TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TextLabel.Parent = self.Instance
    
    -- Value label
    self.ValueLabel = Instance.new("TextLabel")
    self.ValueLabel.Name = "Value"
    self.ValueLabel.Size = UDim2.new(0, 50, 0, 20)
    self.ValueLabel.Position = UDim2.new(1, -65, 0, 10)
    self.ValueLabel.BackgroundTransparency = 1
    self.ValueLabel.Text = tostring(self.Value) .. self.Suffix
    self.ValueLabel.Font = Enum.Font.SourceSans
    self.ValueLabel.TextSize = 16
    self.ValueLabel.TextColor3 = self.Theme.TextSecondary
    self.ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    self.ValueLabel.Parent = self.Instance
    
    -- Slider background
    self.SliderBackground = Instance.new("Frame")
    self.SliderBackground.Name = "SliderBackground"
    self.SliderBackground.Size = UDim2.new(1, -30, 0, 6)
    self.SliderBackground.Position = UDim2.new(0, 15, 0, 40)
    self.SliderBackground.BorderSizePixel = 0
    self.SliderBackground.BackgroundColor3 = self.Theme.SliderBackground
    self.SliderBackground.Parent = self.Instance
    
    -- Corner for slider background
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 3)
    sliderCorner.Parent = self.SliderBackground
    
    -- Slider fill
    self.SliderFill = Instance.new("Frame")
    self.SliderFill.Name = "SliderFill"
    self.SliderFill.Size = UDim2.new(0, 0, 1, 0)
    self.SliderFill.BorderSizePixel = 0
    self.SliderFill.BackgroundColor3 = self.Theme.SliderFill
    self.SliderFill.Parent = self.SliderBackground
    
    -- Corner for slider fill
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 3)
    fillCorner.Parent = self.SliderFill
    
    -- Slider knob
    self.SliderKnob = Instance.new("Frame")
    self.SliderKnob.Name = "SliderKnob"
    self.SliderKnob.Size = UDim2.new(0, 16, 0, 16)
    self.SliderKnob.Position = UDim2.new(0, -8, 0.5, -8)
    self.SliderKnob.AnchorPoint = Vector2.new(0, 0)
    self.SliderKnob.BorderSizePixel = 0
    self.SliderKnob.BackgroundColor3 = self.Theme.SliderKnob
    self.SliderKnob.Parent = self.SliderFill
    
    -- Corner for slider knob
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = self.SliderKnob
    
    -- Shadow for knob
    local knobShadow = Instance.new("ImageLabel")
    knobShadow.Name = "Shadow"
    knobShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    knobShadow.BackgroundTransparency = 1
    knobShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    knobShadow.Size = UDim2.new(1.5, 0, 1.5, 0)
    knobShadow.ZIndex = -1
    knobShadow.Image = "rbxassetid://6015897843"
    knobShadow.ImageColor3 = Color3.new(0, 0, 0)
    knobShadow.ImageTransparency = 0.6
    knobShadow.ScaleType = Enum.ScaleType.Slice
    knobShadow.SliceCenter = Rect.new(49, 49, 450, 450)
    knobShadow.Parent = self.SliderKnob
    
    -- Hit box for slider (larger than the actual slider for better UX)
    self.SliderHitbox = Instance.new("TextButton")
    self.SliderHitbox.Name = "SliderHitbox"
    self.SliderHitbox.Size = UDim2.new(1, 0, 0, 20)
    self.SliderHitbox.Position = UDim2.new(0, 0, 0, -7)
    self.SliderHitbox.BackgroundTransparency = 1
    self.SliderHitbox.Text = ""
    self.SliderHitbox.Parent = self.SliderBackground
    
    -- Connect events
    self:ConnectEvents()
    
    -- Set initial position
    self:UpdateSliderPosition()
end

function Slider:ConnectEvents()
    -- Button down
    self.SliderHitbox.MouseButton1Down:Connect(function()
        self.Dragging = true
        
        -- Highlight the slider
        TweenService:Create(self.SliderKnob, TweenInfo.new(0.2), {
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(0, -10, 0.5, -10)
        }):Play()
        
        -- Update with initial position
        local inputPosition = UserInputService:GetMouseLocation().X
        local sliderPosition = self.SliderBackground.AbsolutePosition.X
        local sliderWidth = self.SliderBackground.AbsoluteSize.X
        
        local position = math.clamp((inputPosition - sliderPosition) / sliderWidth, 0, 1)
        local value = self.Min + ((self.Max - self.Min) * position)
        value = self:RoundToIncrement(value)
        
        self:Set(value)
    end)
    
    -- Mouse move
    UserInputService.InputChanged:Connect(function(input)
        if self.Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local inputPosition = UserInputService:GetMouseLocation().X
            local sliderPosition = self.SliderBackground.AbsolutePosition.X
            local sliderWidth = self.SliderBackground.AbsoluteSize.X
            
            local position = math.clamp((inputPosition - sliderPosition) / sliderWidth, 0, 1)
            local value = self.Min + ((self.Max - self.Min) * position)
            value = self:RoundToIncrement(value)
            
            self:Set(value)
        end
    end)
    
    -- Mouse up
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and self.Dragging then
            self.Dragging = false
            
            -- Return knob to normal size
            TweenService:Create(self.SliderKnob, TweenInfo.new(0.2), {
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(0, -8, 0.5, -8)
            }):Play()
        end
    end)
end

function Slider:UpdateSliderPosition()
    local percent = (self.Value - self.Min) / (self.Max - self.Min)
    local fillWidth = math.max(0, math.min(1, percent)) * self.SliderBackground.AbsoluteSize.X
    
    self.SliderFill.Size = UDim2.new(0, fillWidth, 1, 0)
    self.ValueLabel.Text = tostring(self.Value) .. self.Suffix
end

function Slider:Set(value, skipCallback)
    value = math.clamp(value, self.Min, self.Max)
    value = self:RoundToIncrement(value)
    
    -- Update internal value
    self.Value = value
    
    -- Update visuals
    self:UpdateSliderPosition()
    
    -- Call callback
    if not skipCallback then
        self.Callback(self.Value)
    end
end

function Slider:SetVisible(visible)
    self.Container.Visible = visible
end

function Slider:UpdateText(text)
    self.Text = text
    self.TextLabel.Text = text
end

function Slider:Destroy()
    if self.Container then
        self.Container:Destroy()
    end
end

return Slider
