--[[
    ColorPicker Component
    Part of the SystemUI library
    Creates a color picker control with RGB and HSV support
--]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local ColorPicker = {}
ColorPicker.__index = ColorPicker

-- Utility functions for color conversion
local function RGBToHSV(r, g, b)
    r, g, b = r / 255, g / 255, b / 255
    local max, min = math.max(r, g, b), math.min(r, g, b)
    local h, s, v
    v = max
    
    local d = max - min
    if max == 0 then
        s = 0
    else
        s = d / max
    end
    
    if max == min then
        h = 0
    else
        if max == r then
            h = (g - b) / d
            if g < b then h = h + 6 end
        elseif max == g then
            h = (b - r) / d + 2
        elseif max == b then
            h = (r - g) / d + 4
        end
        h = h / 6
    end
    
    return h, s, v
end

local function HSVToRGB(h, s, v)
    local r, g, b
    
    local i = math.floor(h * 6)
    local f = h * 6 - i
    local p = v * (1 - s)
    local q = v * (1 - f * s)
    local t = v * (1 - (1 - f) * s)
    
    i = i % 6
    
    if i == 0 then r, g, b = v, t, p
    elseif i == 1 then r, g, b = q, v, p
    elseif i == 2 then r, g, b = p, v, t
    elseif i == 3 then r, g, b = p, q, v
    elseif i == 4 then r, g, b = t, p, v
    elseif i == 5 then r, g, b = v, p, q
    end
    
    return math.floor(r * 255 + 0.5), math.floor(g * 255 + 0.5), math.floor(b * 255 + 0.5)
end

function ColorPicker.new(window, tab, options)
    local self = setmetatable({}, ColorPicker)
    
    self.Window = window
    self.Tab = tab
    self.Theme = window.Theme
    self.Text = options.Text or "ColorPicker"
    self.Default = options.Default or Color3.fromRGB(255, 0, 0)
    self.Callback = options.Callback or function() end
    self.Value = self.Default
    self.Open = false
    
    -- Extract HSV from default color
    local r, g, b = self.Default.R * 255, self.Default.G * 255, self.Default.B * 255
    self.H, self.S, self.V = RGBToHSV(r, g, b)
    
    self:Create()
    
    return self
end

function ColorPicker:Create()
    -- Main container
    self.Container = Instance.new("Frame")
    self.Container.Name = "ColorPicker_" .. self.Text
    self.Container.Size = UDim2.new(1, 0, 0, 40)
    self.Container.BackgroundTransparency = 1
    self.Container.ClipsDescendants = true
    self.Container.Parent = self.Tab.Content
    
    -- Background
    self.Instance = Instance.new("Frame")
    self.Instance.Name = "ColorPickerInstance"
    self.Instance.Size = UDim2.new(1, 0, 0, 40)
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
    self.TextLabel.Size = UDim2.new(1, -120, 1, 0)
    self.TextLabel.Position = UDim2.new(0, 15, 0, 0)
    self.TextLabel.BackgroundTransparency = 1
    self.TextLabel.Text = self.Text
    self.TextLabel.Font = Enum.Font.SourceSans
    self.TextLabel.TextSize = 16
    self.TextLabel.TextColor3 = self.Theme.TextPrimary
    self.TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TextLabel.Parent = self.Instance
    
    -- Color display
    self.ColorDisplay = Instance.new("Frame")
    self.ColorDisplay.Name = "ColorDisplay"
    self.ColorDisplay.Size = UDim2.new(0, 70, 0, 26)
    self.ColorDisplay.Position = UDim2.new(1, -85, 0.5, -13)
    self.ColorDisplay.BackgroundColor3 = self.Value
    self.ColorDisplay.BorderSizePixel = 0
    self.ColorDisplay.Parent = self.Instance
    
    -- Corner for color display
    local displayCorner = Instance.new("UICorner")
    displayCorner.CornerRadius = UDim.new(0, 4)
    displayCorner.Parent = self.ColorDisplay
    
    -- Create the color picker panel
    self:CreateColorPanel()
    
    -- Connect events
    self:ConnectEvents()
end

function ColorPicker:CreateColorPanel()
    -- Color picker panel
    self.ColorPanel = Instance.new("Frame")
    self.ColorPanel.Name = "ColorPanel"
    self.ColorPanel.Size = UDim2.new(1, 0, 0, 200)
    self.ColorPanel.Position = UDim2.new(0, 0, 0, 40)
    self.ColorPanel.BackgroundColor3 = self.Theme.ComponentBackground
    self.ColorPanel.BorderSizePixel = 0
    self.ColorPanel.Visible = false
    self.ColorPanel.ZIndex = 10
    self.ColorPanel.Parent = self.Container
    
    -- Corner for color panel
    local panelCorner = Instance.new("UICorner")
    panelCorner.CornerRadius = UDim.new(0, 6)
    panelCorner.Parent = self.ColorPanel
    
    -- Color saturation/value picker (2D)
    self.SatValPicker = Instance.new("ImageButton")
    self.SatValPicker.Name = "SatValPicker"
    self.SatValPicker.Size = UDim2.new(0, 180, 0, 180)
    self.SatValPicker.Position = UDim2.new(0, 10, 0, 10)
    self.SatValPicker.BackgroundColor3 = Color3.new(1, 0, 0) -- Red (will be updated based on hue)
    self.SatValPicker.BorderSizePixel = 0
    self.SatValPicker.ZIndex = 11
    self.SatValPicker.AutoButtonColor = false
    
    -- Instead of using an image, we'll create a gradient effect
    local satGradient = Instance.new("UIGradient")
    satGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
        ColorSequenceKeypoint.new(1, Color3.new(1, 0, 0))
    })
    satGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 0)
    })
    satGradient.Rotation = 90
    satGradient.Parent = self.SatValPicker
    
    -- Value (brightness) gradient overlay
    local valGradient = Instance.new("Frame")
    valGradient.Name = "ValueGradient"
    valGradient.Size = UDim2.new(1, 0, 1, 0)
    valGradient.BackgroundColor3 = Color3.new(0, 0, 0)
    valGradient.BorderSizePixel = 0
    valGradient.ZIndex = 12
    valGradient.Parent = self.SatValPicker
    
    local valUIGradient = Instance.new("UIGradient")
    valUIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))
    })
    valUIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    valUIGradient.Rotation = 0
    valUIGradient.Parent = valGradient
    
    -- Corner for sat/val picker
    local svCorner = Instance.new("UICorner")
    svCorner.CornerRadius = UDim.new(0, 4)
    svCorner.Parent = self.SatValPicker
    
    -- Selection cursor for sat/val picker
    self.SVCursor = Instance.new("Frame")
    self.SVCursor.Name = "SVCursor"
    self.SVCursor.Size = UDim2.new(0, 10, 0, 10)
    self.SVCursor.AnchorPoint = Vector2.new(0.5, 0.5)
    self.SVCursor.Position = UDim2.new(self.S, 0, 1 - self.V, 0)
    self.SVCursor.BackgroundColor3 = Color3.new(1, 1, 1)
    self.SVCursor.BorderSizePixel = 0
    self.SVCursor.ZIndex = 15
    self.SVCursor.Parent = self.SatValPicker
    
    -- Circle shape for cursor
    local cursorCorner = Instance.new("UICorner")
    cursorCorner.CornerRadius = UDim.new(1, 0)
    cursorCorner.Parent = self.SVCursor
    
    -- Hue slider
    self.HueSlider = Instance.new("Frame")
    self.HueSlider.Name = "HueSlider"
    self.HueSlider.Size = UDim2.new(0, 20, 0, 180)
    self.HueSlider.Position = UDim2.new(0, 200, 0, 10)
    self.HueSlider.BackgroundColor3 = Color3.new(1, 1, 1)
    self.HueSlider.BorderSizePixel = 0
    self.HueSlider.ZIndex = 11
    self.HueSlider.Parent = self.ColorPanel
    
    -- Corner for hue slider
    local hueCorner = Instance.new("UICorner")
    hueCorner.CornerRadius = UDim.new(0, 4)
    hueCorner.Parent = self.HueSlider
    
    -- Hue gradient
    local hueGradient = Instance.new("UIGradient")
    hueGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new(1, 0, 0)), -- Red
        ColorSequenceKeypoint.new(0.167, Color3.new(1, 1, 0)), -- Yellow
        ColorSequenceKeypoint.new(0.333, Color3.new(0, 1, 0)), -- Green
        ColorSequenceKeypoint.new(0.5, Color3.new(0, 1, 1)), -- Cyan
        ColorSequenceKeypoint.new(0.667, Color3.new(0, 0, 1)), -- Blue
        ColorSequenceKeypoint.new(0.833, Color3.new(1, 0, 1)), -- Magenta
        ColorSequenceKeypoint.new(1, Color3.new(1, 0, 0)) -- Back to Red
    })
    hueGradient.Rotation = 90
    hueGradient.Parent = self.HueSlider
    
    -- Hue slider button (for interaction)
    self.HueSliderButton = Instance.new("TextButton")
    self.HueSliderButton.Name = "HueSliderButton"
    self.HueSliderButton.Size = UDim2.new(1, 0, 1, 0)
    self.HueSliderButton.BackgroundTransparency = 1
    self.HueSliderButton.Text = ""
    self.HueSliderButton.ZIndex = 12
    self.HueSliderButton.Parent = self.HueSlider
    
    -- Hue selection cursor
    self.HueCursor = Instance.new("Frame")
    self.HueCursor.Name = "HueCursor"
    self.HueCursor.Size = UDim2.new(1, 6, 0, 8)
    self.HueCursor.AnchorPoint = Vector2.new(0.5, 0.5)
    self.HueCursor.Position = UDim2.new(0.5, 0, self.H, 0)
    self.HueCursor.BackgroundColor3 = Color3.new(1, 1, 1)
    self.HueCursor.BorderSizePixel = 0
    self.HueCursor.ZIndex = 13
    self.HueCursor.Parent = self.HueSlider
    
    -- Corner for hue cursor
    local hueCursorCorner = Instance.new("UICorner")
    hueCursorCorner.CornerRadius = UDim.new(0, 2)
    hueCursorCorner.Parent = self.HueCursor
    
    -- RGB input section
    self.RGBContainer = Instance.new("Frame")
    self.RGBContainer.Name = "RGBContainer"
    self.RGBContainer.Size = UDim2.new(1, -240, 0, 180)
    self.RGBContainer.Position = UDim2.new(0, 230, 0, 10)
    self.RGBContainer.BackgroundTransparency = 1
    self.RGBContainer.ZIndex = 11
    self.RGBContainer.Parent = self.ColorPanel
    
    -- Create RGB inputs
    self:CreateRGBInputs()
    
    -- Create buttons section (Apply/Cancel)
    self:CreateButtons()
    
    -- Update display based on current color
    self:UpdateColorDisplay()
end

function ColorPicker:CreateRGBInputs()
    local colors = {"R", "G", "B"}
    local startY = 20
    
    for i, color in ipairs(colors) do
        -- Label
        local label = Instance.new("TextLabel")
        label.Name = color .. "Label"
        label.Size = UDim2.new(0, 20, 0, 30)
        label.Position = UDim2.new(0, 0, 0, startY + (i-1) * 40)
        label.BackgroundTransparency = 1
        label.Text = color
        label.Font = Enum.Font.SourceSansBold
        label.TextSize = 16
        label.TextColor3 = self.Theme.TextPrimary
        label.ZIndex = 12
        label.Parent = self.RGBContainer
        
        -- Input background
        local inputBg = Instance.new("Frame")
        inputBg.Name = color .. "InputBg"
        inputBg.Size = UDim2.new(0, 60, 0, 30)
        inputBg.Position = UDim2.new(0, 30, 0, startY + (i-1) * 40)
        inputBg.BackgroundColor3 = self.Theme.InputBackground
        inputBg.BorderSizePixel = 0
        inputBg.ZIndex = 12
        inputBg.Parent = self.RGBContainer
        
        -- Corner
        local inputCorner = Instance.new("UICorner")
        inputCorner.CornerRadius = UDim.new(0, 4)
        inputCorner.Parent = inputBg
        
        -- Input box
        local input = Instance.new("TextBox")
        input.Name = color .. "Input"
        input.Size = UDim2.new(1, -10, 1, 0)
        input.Position = UDim2.new(0, 5, 0, 0)
        input.BackgroundTransparency = 1
        input.Text = "255"
        input.Font = Enum.Font.SourceSans
        input.TextSize = 16
        input.TextColor3 = self.Theme.TextPrimary
        input.ZIndex = 13
        input.Parent = inputBg
        
        -- Store reference
        self[color .. "Input"] = input
        
        -- Connect input event
        input.FocusLost:Connect(function(enterPressed)
            if enterPressed then
                local num = tonumber(input.Text)
                if num then
                    num = math.clamp(math.floor(num), 0, 255)
                    input.Text = tostring(num)
                    
                    -- Update color from RGB inputs
                    local r = tonumber(self.RInput.Text) or 0
                    local g = tonumber(self.GInput.Text) or 0
                    local b = tonumber(self.BInput.Text) or 0
                    
                    self:SetFromRGB(r, g, b)
                else
                    -- Revert to current value
                    self:UpdateRGBInputs()
                end
            end
        end)
    end
end

function ColorPicker:CreateButtons()
    -- Apply button
    self.ApplyButton = Instance.new("TextButton")
    self.ApplyButton.Name = "ApplyButton"
    self.ApplyButton.Size = UDim2.new(0, 80, 0, 30)
    self.ApplyButton.Position = UDim2.new(0, 230, 0, 160)
    self.ApplyButton.BackgroundColor3 = self.Theme.ButtonPrimary
    self.ApplyButton.BorderSizePixel = 0
    self.ApplyButton.Text = "Apply"
    self.ApplyButton.Font = Enum.Font.SourceSansBold
    self.ApplyButton.TextSize = 16
    self.ApplyButton.TextColor3 = self.Theme.TextPrimary
    self.ApplyButton.ZIndex = 12
    self.ApplyButton.Parent = self.ColorPanel
    
    -- Apply button corner
    local applyCorner = Instance.new("UICorner")
    applyCorner.CornerRadius = UDim.new(0, 4)
    applyCorner.Parent = self.ApplyButton
    
    -- Cancel button
    self.CancelButton = Instance.new("TextButton")
    self.CancelButton.Name = "CancelButton"
    self.CancelButton.Size = UDim2.new(0, 80, 0, 30)
    self.CancelButton.Position = UDim2.new(0, 320, 0, 160)
    self.CancelButton.BackgroundColor3 = self.Theme.ButtonSecondary
    self.CancelButton.BorderSizePixel = 0
    self.CancelButton.Text = "Cancel"
    self.CancelButton.Font = Enum.Font.SourceSansBold
    self.CancelButton.TextSize = 16
    self.CancelButton.TextColor3 = self.Theme.TextSecondary
    self.CancelButton.ZIndex = 12
    self.CancelButton.Parent = self.ColorPanel
    
    -- Cancel button corner
    local cancelCorner = Instance.new("UICorner")
    cancelCorner.CornerRadius = UDim.new(0, 4)
    cancelCorner.Parent = self.CancelButton
    
    -- Connect button events
    self.ApplyButton.MouseButton1Click:Connect(function()
        self:ApplyColor()
    end)
    
    self.CancelButton.MouseButton1Click:Connect(function()
        self:CancelSelection()
    end)
end

function ColorPicker:ConnectEvents()
    -- Toggle color picker panel on color display click
    self.ColorDisplay.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self:Toggle()
        end
    end)
    
    -- Saturation/Value picker events
    self.SatValPicker.MouseButton1Down:Connect(function()
        self.SVDragging = true
        self:UpdateSatVal(self.SatValPicker.AbsolutePosition, self.SatValPicker.AbsoluteSize)
    end)
    
    -- Hue slider events
    self.HueSliderButton.MouseButton1Down:Connect(function()
        self.HueDragging = true
        self:UpdateHue(self.HueSlider.AbsolutePosition, self.HueSlider.AbsoluteSize)
    end)
    
    -- Global mouse events
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            if self.SVDragging then
                self:UpdateSatVal(self.SatValPicker.AbsolutePosition, self.SatValPicker.AbsoluteSize)
            end
            
            if self.HueDragging then
                self:UpdateHue(self.HueSlider.AbsolutePosition, self.HueSlider.AbsoluteSize)
            end
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.SVDragging = false
            self.HueDragging = false
        end
    end)
    
    -- Close dropdown when clicking elsewhere
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local guiObjects = game:GetService("Players").LocalPlayer:GetGuiObjectsAtPosition(input.Position.X, input.Position.Y)
            local isOutside = true
            
            for _, obj in pairs(guiObjects) do
                if obj:IsDescendantOf(self.Container) then
                    isOutside = false
                    break
                end
            end
            
            if isOutside and self.Open then
                self:Toggle(false)
            end
        end
    end)
end

function ColorPicker:UpdateSatVal(absPos, absSize)
    if not absPos or not absSize then return end
    
    local mousePos = UserInputService:GetMouseLocation()
    local relativeX = math.clamp((mousePos.X - absPos.X) / absSize.X, 0, 1)
    local relativeY = math.clamp((mousePos.Y - absPos.Y) / absSize.Y, 0, 1)
    
    -- Update internal values (S = X, V = 1-Y because Y is inverted in UI coordinates)
    self.S = relativeX
    self.V = 1 - relativeY
    
    -- Update cursor position
    self.SVCursor.Position = UDim2.new(relativeX, 0, relativeY, 0)
    
    -- Update colors
    self:UpdateTempColor()
end

function ColorPicker:UpdateHue(absPos, absSize)
    if not absPos or not absSize then return end
    
    local mousePos = UserInputService:GetMouseLocation()
    local relativeY = math.clamp((mousePos.Y - absPos.Y) / absSize.Y, 0, 1)
    
    -- Update internal value
    self.H = relativeY
    
    -- Update cursor position
    self.HueCursor.Position = UDim2.new(0.5, 0, relativeY, 0)
    
    -- Update saturation/value picker's base color based on hue
    local r, g, b = HSVToRGB(self.H, 1, 1)
    self.SatValPicker.BackgroundColor3 = Color3.fromRGB(r, g, b)
    
    -- Update colors
    self:UpdateTempColor()
end

function ColorPicker:UpdateTempColor()
    -- Convert HSV to RGB
    local r, g, b = HSVToRGB(self.H, self.S, self.V)
    
    -- Store temporary color
    self.TempColor = Color3.fromRGB(r, g, b)
    
    -- Update preview display
    self.ColorDisplay.BackgroundColor3 = self.TempColor
    
    -- Update RGB inputs
    self:UpdateRGBInputs()
end

function ColorPicker:UpdateRGBInputs()
    local col = self.TempColor or self.Value
    
    -- Get RGB values
    local r = math.floor(col.R * 255 + 0.5)
    local g = math.floor(col.G * 255 + 0.5)
    local b = math.floor(col.B * 255 + 0.5)
    
    -- Update input fields
    self.RInput.Text = tostring(r)
    self.GInput.Text = tostring(g)
    self.BInput.Text = tostring(b)
end

function ColorPicker:SetFromRGB(r, g, b)
    -- Clamp values
    r = math.clamp(r, 0, 255)
    g = math.clamp(g, 0, 255)
    b = math.clamp(b, 0, 255)
    
    -- Convert to HSV
    local h, s, v = RGBToHSV(r, g, b)
    
    -- Update internal values
    self.H = h
    self.S = s
    self.V = v
    
    -- Update UI
    self.HueCursor.Position = UDim2.new(0.5, 0, h, 0)
    self.SVCursor.Position = UDim2.new(s, 0, 1 - v, 0)
    
    -- Update saturation/value picker's base color
    local hr, hg, hb = HSVToRGB(h, 1, 1)
    self.SatValPicker.BackgroundColor3 = Color3.fromRGB(hr, hg, hb)
    
    -- Update color
    self.TempColor = Color3.fromRGB(r, g, b)
    self.ColorDisplay.BackgroundColor3 = self.TempColor
end

function ColorPicker:ApplyColor()
    -- Apply the temporary color
    if self.TempColor then
        self.Value = self.TempColor
        self.Callback(self.Value)
    end
    
    -- Close the picker
    self:Toggle(false)
end

function ColorPicker:CancelSelection()
    -- Reset to current value
    self:UpdateColorDisplay()
    
    -- Close the picker
    self:Toggle(false)
end

function ColorPicker:UpdateColorDisplay()
    -- Update color display with current value
    self.ColorDisplay.BackgroundColor3 = self.Value
    
    -- Convert RGB to HSV for internal tracking
    local r, g, b = self.Value.R * 255, self.Value.G * 255, self.Value.B * 255
    self.H, self.S, self.V = RGBToHSV(r, g, b)
    
    -- Update UI positions
    if self.HueCursor then
        self.HueCursor.Position = UDim2.new(0.5, 0, self.H, 0)
    end
    
    if self.SVCursor then
        self.SVCursor.Position = UDim2.new(self.S, 0, 1 - self.V, 0)
    end
    
    if self.SatValPicker then
        -- Update saturation/value picker's base color
        local hr, hg, hb = HSVToRGB(self.H, 1, 1)
        self.SatValPicker.BackgroundColor3 = Color3.fromRGB(hr, hg, hb)
    end
    
    -- Update RGB inputs
    if self.RInput then
        self:UpdateRGBInputs()
    end
    
    -- Store temp color
    self.TempColor = self.Value
end

function ColorPicker:Toggle(state)
    if state ~= nil then
        self.Open = state
    else
        self.Open = not self.Open
    end
    
    if self.Open then
        -- Update color display before showing
        self:UpdateColorDisplay()
        
        -- Show panel
        self.ColorPanel.Visible = true
        
        -- Expand container
        TweenService:Create(self.Container, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
            Size = UDim2.new(1, 0, 0, 240)
        }):Play()
    else
        -- Shrink container
        TweenService:Create(self.Container, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
            Size = UDim2.new(1, 0, 0, 40)
        }):Play()
        
        -- Hide panel after animation
        spawn(function()
            wait(0.3)
            if not self.Open then
                self.ColorPanel.Visible = false
            end
        end)
    end
end

function ColorPicker:Set(color, skipCallback)
    if typeof(color) ~= "Color3" then return end
    
    self.Value = color
    self:UpdateColorDisplay()
    
    if not skipCallback then
        self.Callback(self.Value)
    end
end

function ColorPicker:SetVisible(visible)
    self.Container.Visible = visible
end

function ColorPicker:UpdateText(text)
    self.Text = text
    self.TextLabel.Text = text
end

function ColorPicker:Destroy()
    if self.Container then
        self.Container:Destroy()
    end
end

return ColorPicker
