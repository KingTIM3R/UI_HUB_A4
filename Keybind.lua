--[[
    Keybind Component
    Part of the SystemUI library
    Creates a keybind input control
--]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Keybind = {}
Keybind.__index = Keybind

local BLACKLISTED_KEYS = {
    Enum.KeyCode.Unknown,
    Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D, -- Movement keys
    Enum.KeyCode.Up, Enum.KeyCode.Down, Enum.KeyCode.Left, Enum.KeyCode.Right -- Arrow keys
}

function Keybind.new(window, tab, options)
    local self = setmetatable({}, Keybind)
    
    self.Window = window
    self.Tab = tab
    self.Theme = window.Theme
    self.Text = options.Text or "Keybind"
    self.Default = options.Default or Enum.KeyCode.Unknown
    self.Callback = options.Callback or function() end
    self.Blacklist = options.Blacklist or BLACKLISTED_KEYS
    self.Value = self.Default
    self.Listening = false
    
    self:Create()
    
    return self
end

function Keybind:Create()
    -- Main container
    self.Container = Instance.new("Frame")
    self.Container.Name = "Keybind_" .. self.Text
    self.Container.Size = UDim2.new(1, 0, 0, 40)
    self.Container.BackgroundTransparency = 1
    self.Container.Parent = self.Tab.Content
    
    -- Background
    self.Instance = Instance.new("Frame")
    self.Instance.Name = "KeybindInstance"
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
    self.TextLabel.Size = UDim2.new(1, -170, 1, 0)
    self.TextLabel.Position = UDim2.new(0, 15, 0, 0)
    self.TextLabel.BackgroundTransparency = 1
    self.TextLabel.Text = self.Text
    self.TextLabel.Font = Enum.Font.SourceSans
    self.TextLabel.TextSize = 16
    self.TextLabel.TextColor3 = self.Theme.TextPrimary
    self.TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TextLabel.Parent = self.Instance
    
    -- Keybind button
    self.KeybindButton = Instance.new("TextButton")
    self.KeybindButton.Name = "KeybindButton"
    self.KeybindButton.Size = UDim2.new(0, 110, 0, 30)
    self.KeybindButton.Position = UDim2.new(1, -125, 0.5, -15)
    self.KeybindButton.BackgroundColor3 = self.Theme.KeybindButton
    self.KeybindButton.BorderSizePixel = 0
    self.KeybindButton.Text = ""
    self.KeybindButton.AutoButtonColor = false
    self.KeybindButton.Parent = self.Instance
    
    -- Corner for keybind button
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 4)
    buttonCorner.Parent = self.KeybindButton
    
    -- Keybind text
    self.KeybindText = Instance.new("TextLabel")
    self.KeybindText.Name = "KeybindText"
    self.KeybindText.Size = UDim2.new(1, 0, 1, 0)
    self.KeybindText.BackgroundTransparency = 1
    self.KeybindText.Font = Enum.Font.SourceSans
    self.KeybindText.TextSize = 16
    self.KeybindText.TextColor3 = self.Theme.TextPrimary
    self.KeybindText.Parent = self.KeybindButton
    
    -- Reset button
    self.ResetButton = Instance.new("ImageButton")
    self.ResetButton.Name = "ResetButton"
    self.ResetButton.Size = UDim2.new(0, 20, 0, 20)
    self.ResetButton.Position = UDim2.new(1, -25, 0.5, -10)
    self.ResetButton.BackgroundTransparency = 1
    self.ResetButton.Image = "rbxassetid://6031094678" -- X icon
    self.ResetButton.ImageColor3 = self.Theme.TextSecondary
    self.ResetButton.ImageTransparency = 0.5
    self.ResetButton.Parent = self.KeybindButton
    
    -- Connect events
    self:ConnectEvents()
    
    -- Set initial text
    self:UpdateValue()
    
    -- Setup input connection
    self:SetupInputConnection()
end

function Keybind:ConnectEvents()
    -- Button hover effects
    self.KeybindButton.MouseEnter:Connect(function()
        if not self.Listening then
            TweenService:Create(self.KeybindButton, TweenInfo.new(0.2), {
                BackgroundColor3 = self.Theme.KeybindButtonHover
            }):Play()
        end
    end)
    
    self.KeybindButton.MouseLeave:Connect(function()
        if not self.Listening then
            TweenService:Create(self.KeybindButton, TweenInfo.new(0.2), {
                BackgroundColor3 = self.Theme.KeybindButton
            }):Play()
        end
    end)
    
    -- Reset button hover effects
    self.ResetButton.MouseEnter:Connect(function()
        TweenService:Create(self.ResetButton, TweenInfo.new(0.2), {
            ImageTransparency = 0
        }):Play()
    end)
    
    self.ResetButton.MouseLeave:Connect(function()
        TweenService:Create(self.ResetButton, TweenInfo.new(0.2), {
            ImageTransparency = 0.5
        }):Play()
    end)
    
    -- Keybind button click (start listening)
    self.KeybindButton.MouseButton1Click:Connect(function()
        if not self.Listening then
            self:StartListening()
        end
    end)
    
    -- Reset button click
    self.ResetButton.MouseButton1Click:Connect(function()
        self:Set(Enum.KeyCode.Unknown)
    end)
end

function Keybind:StartListening()
    self.Listening = true
    
    -- Highlight button
    TweenService:Create(self.KeybindButton, TweenInfo.new(0.2), {
        BackgroundColor3 = self.Theme.KeybindButtonActive
    }):Play()
    
    -- Update text
    self.KeybindText.Text = "Press a key..."
end

function Keybind:StopListening()
    self.Listening = false
    
    -- Reset button color
    TweenService:Create(self.KeybindButton, TweenInfo.new(0.2), {
        BackgroundColor3 = self.Theme.KeybindButton
    }):Play()
    
    -- Update value text
    self:UpdateValue()
end

function Keybind:UpdateValue()
    if self.Value == Enum.KeyCode.Unknown then
        self.KeybindText.Text = "None"
    else
        local keyName = self.Value.Name
        self.KeybindText.Text = keyName
    end
end

function Keybind:IsKeyBlacklisted(key)
    for _, blacklistedKey in ipairs(self.Blacklist) do
        if key == blacklistedKey then
            return true
        end
    end
    return false
end

function Keybind:SetupInputConnection()
    -- Listen for key presses
    self.InputConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if self.Listening then
            -- Only accept KeyCode inputs
            if input.UserInputType == Enum.UserInputType.Keyboard then
                -- Check if key is blacklisted
                if not self:IsKeyBlacklisted(input.KeyCode) then
                    self:Set(input.KeyCode)
                end
                
                -- Stop listening regardless
                self:StopListening()
            end
        elseif input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == self.Value and self.Value ~= Enum.KeyCode.Unknown then
            -- Trigger callback when key is pressed
            self.Callback(self.Value)
        end
    end)
end

function Keybind:Set(value, skipCallback)
    self.Value = value
    self:UpdateValue()
    
    if not skipCallback then
        self.Callback(self.Value)
    end
end

function Keybind:SetVisible(visible)
    self.Container.Visible = visible
end

function Keybind:UpdateText(text)
    self.Text = text
    self.TextLabel.Text = text
end

function Keybind:Destroy()
    if self.InputConnection then
        self.InputConnection:Disconnect()
    end
    
    if self.Container then
        self.Container:Destroy()
    end
end

return Keybind
