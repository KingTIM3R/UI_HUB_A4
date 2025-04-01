--[[
    Button Component
    Part of the SystemUI library
    Creates a clickable button with hover effects and optional icon
--]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Button = {}
Button.__index = Button

function Button.new(window, tab, options)
    local self = setmetatable({}, Button)
    
    self.Window = window
    self.Tab = tab
    self.Theme = window.Theme
    self.Text = options.Text or "Button"
    self.Icon = options.Icon or nil
    self.Callback = options.Callback or function() end
    self.Disabled = options.Disabled or false
    
    self:Create()
    
    return self
end

function Button:Create()
    -- Main container
    self.Container = Instance.new("Frame")
    self.Container.Name = "Button_" .. self.Text
    self.Container.Size = UDim2.new(1, 0, 0, 40)
    self.Container.BackgroundTransparency = 1
    self.Container.Parent = self.Tab.Content
    
    -- Button
    self.Instance = Instance.new("TextButton")
    self.Instance.Name = "ButtonInstance"
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
    
    -- Icon
    if self.Icon then
        self.IconInstance = Instance.new("ImageLabel")
        self.IconInstance.Name = "Icon"
        self.IconInstance.Size = UDim2.new(0, 20, 0, 20)
        self.IconInstance.Position = UDim2.new(0, 10, 0.5, -10)
        self.IconInstance.BackgroundTransparency = 1
        self.IconInstance.Image = self.Icon
        self.IconInstance.ImageColor3 = self.Theme.TextPrimary
        self.IconInstance.Parent = self.Instance
    end
    
    -- Text
    self.TextLabel = Instance.new("TextLabel")
    self.TextLabel.Name = "Text"
    self.TextLabel.BackgroundTransparency = 1
    self.TextLabel.Text = self.Text
    self.TextLabel.Font = Enum.Font.SourceSans
    self.TextLabel.TextSize = 16
    self.TextLabel.TextColor3 = self.Theme.TextPrimary
    
    if self.Icon then
        self.TextLabel.Size = UDim2.new(1, -40, 1, 0)
        self.TextLabel.Position = UDim2.new(0, 40, 0, 0)
        self.TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    else
        self.TextLabel.Size = UDim2.new(1, 0, 1, 0)
        self.TextLabel.Position = UDim2.new(0, 0, 0, 0)
        self.TextLabel.TextXAlignment = Enum.TextXAlignment.Center
    end
    
    self.TextLabel.Parent = self.Instance
    
    -- Ripple effect container
    self.RippleContainer = Instance.new("Frame")
    self.RippleContainer.Name = "RippleContainer"
    self.RippleContainer.BackgroundTransparency = 1
    self.RippleContainer.ClipsDescendants = true
    self.RippleContainer.Size = UDim2.new(1, 0, 1, 0)
    self.RippleContainer.ZIndex = 2
    self.RippleContainer.Parent = self.Instance
    
    -- Connect events
    self:ConnectEvents()
    
    -- Apply disabled state if needed
    if self.Disabled then
        self:SetDisabled(true)
    end
end

function Button:ConnectEvents()
    -- Mouse enter (hover)
    self.Instance.MouseEnter:Connect(function()
        if not self.Disabled then
            TweenService:Create(self.Instance, TweenInfo.new(0.2), {
                BackgroundColor3 = self.Theme.ComponentBackgroundHover
            }):Play()
        end
    end)
    
    -- Mouse leave
    self.Instance.MouseLeave:Connect(function()
        if not self.Disabled then
            TweenService:Create(self.Instance, TweenInfo.new(0.2), {
                BackgroundColor3 = self.Theme.ComponentBackground
            }):Play()
        end
    end)
    
    -- Mouse button down
    self.Instance.MouseButton1Down:Connect(function(x, y)
        if not self.Disabled then
            self:CreateRipple(x, y)
            
            TweenService:Create(self.Instance, TweenInfo.new(0.1), {
                BackgroundColor3 = self.Theme.ComponentBackgroundPress
            }):Play()
        end
    end)
    
    -- Mouse button up
    self.Instance.MouseButton1Up:Connect(function()
        if not self.Disabled then
            TweenService:Create(self.Instance, TweenInfo.new(0.1), {
                BackgroundColor3 = self.Theme.ComponentBackgroundHover
            }):Play()
        end
    end)
    
    -- Click
    self.Instance.MouseButton1Click:Connect(function()
        if not self.Disabled then
            self.Callback()
        end
    end)
end

function Button:CreateRipple(x, y)
    -- Create ripple effect when button is pressed
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.Position = UDim2.new(0, x - self.Instance.AbsolutePosition.X, 0, y - self.Instance.AbsolutePosition.Y)
    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = 0.8
    ripple.BorderSizePixel = 0
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.ZIndex = 2
    
    -- Make it a circle
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ripple
    
    ripple.Parent = self.RippleContainer
    
    -- Animate ripple
    local maxSize = math.max(self.Instance.AbsoluteSize.X, self.Instance.AbsoluteSize.Y) * 2
    
    -- Grow animation
    TweenService:Create(ripple, TweenInfo.new(0.5), {
        Size = UDim2.new(0, maxSize, 0, maxSize),
        BackgroundTransparency = 1
    }):Play()
    
    -- Remove after animation completes
    spawn(function()
        wait(0.5)
        ripple:Destroy()
    end)
end

function Button:SetDisabled(disabled)
    self.Disabled = disabled
    
    if disabled then
        TweenService:Create(self.Instance, TweenInfo.new(0.2), {
            BackgroundColor3 = self.Theme.ComponentBackgroundDisabled
        }):Play()
        
        TweenService:Create(self.TextLabel, TweenInfo.new(0.2), {
            TextColor3 = self.Theme.TextDisabled
        }):Play()
        
        if self.IconInstance then
            TweenService:Create(self.IconInstance, TweenInfo.new(0.2), {
                ImageColor3 = self.Theme.TextDisabled
            }):Play()
        end
    else
        TweenService:Create(self.Instance, TweenInfo.new(0.2), {
            BackgroundColor3 = self.Theme.ComponentBackground
        }):Play()
        
        TweenService:Create(self.TextLabel, TweenInfo.new(0.2), {
            TextColor3 = self.Theme.TextPrimary
        }):Play()
        
        if self.IconInstance then
            TweenService:Create(self.IconInstance, TweenInfo.new(0.2), {
                ImageColor3 = self.Theme.TextPrimary
            }):Play()
        end
    end
end

function Button:SetVisible(visible)
    self.Container.Visible = visible
end

function Button:UpdateText(text)
    self.Text = text
    self.TextLabel.Text = text
end

function Button:Destroy()
    if self.Container then
        self.Container:Destroy()
    end
end

return Button
