--[[
    Input Component
    Part of the SystemUI library
    Creates a text input box
--]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Input = {}
Input.__index = Input

function Input.new(window, tab, options)
    local self = setmetatable({}, Input)
    
    self.Window = window
    self.Tab = tab
    self.Theme = window.Theme
    self.Text = options.Text or "Input"
    self.PlaceholderText = options.PlaceholderText or "Enter text..."
    self.Default = options.Default or ""
    self.Callback = options.Callback or function() end
    self.ClearOnFocus = options.ClearOnFocus ~= nil and options.ClearOnFocus or false
    self.Value = self.Default
    
    self:Create()
    
    return self
end

function Input:Create()
    -- Main container
    self.Container = Instance.new("Frame")
    self.Container.Name = "Input_" .. self.Text
    self.Container.Size = UDim2.new(1, 0, 0, 60)
    self.Container.BackgroundTransparency = 1
    self.Container.Parent = self.Tab.Content
    
    -- Background
    self.Instance = Instance.new("Frame")
    self.Instance.Name = "InputInstance"
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
    
    -- Input background
    self.InputBackground = Instance.new("Frame")
    self.InputBackground.Name = "InputBackground"
    self.InputBackground.Size = UDim2.new(1, -30, 0, 30)
    self.InputBackground.Position = UDim2.new(0, 15, 0, 30)
    self.InputBackground.BackgroundColor3 = self.Theme.InputBackground
    self.InputBackground.BorderSizePixel = 0
    self.InputBackground.Parent = self.Instance
    
    -- Corner for input background
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 4)
    inputCorner.Parent = self.InputBackground
    
    -- Input text box
    self.InputBox = Instance.new("TextBox")
    self.InputBox.Name = "InputBox"
    self.InputBox.Size = UDim2.new(1, -20, 1, 0)
    self.InputBox.Position = UDim2.new(0, 10, 0, 0)
    self.InputBox.BackgroundTransparency = 1
    self.InputBox.Text = self.Default
    self.InputBox.PlaceholderText = self.PlaceholderText
    self.InputBox.Font = Enum.Font.SourceSans
    self.InputBox.TextSize = 16
    self.InputBox.TextColor3 = self.Theme.TextPrimary
    self.InputBox.PlaceholderColor3 = self.Theme.TextPlaceholder
    self.InputBox.TextXAlignment = Enum.TextXAlignment.Left
    self.InputBox.ClearTextOnFocus = self.ClearOnFocus
    self.InputBox.ClipsDescendants = true
    self.InputBox.Parent = self.InputBackground
    
    -- Connect events
    self:ConnectEvents()
end

function Input:ConnectEvents()
    -- Focus gained
    self.InputBox.Focused:Connect(function()
        -- Change background color when focused
        TweenService:Create(self.InputBackground, TweenInfo.new(0.2), {
            BackgroundColor3 = self.Theme.InputBackgroundFocused
        }):Play()
    end)
    
    -- Focus lost
    self.InputBox.FocusLost:Connect(function(enterPressed)
        -- Change background color back
        TweenService:Create(self.InputBackground, TweenInfo.new(0.2), {
            BackgroundColor3 = self.Theme.InputBackground
        }):Play()
        
        -- Update value and call callback
        self.Value = self.InputBox.Text
        
        if enterPressed then
            self.Callback(self.Value)
        end
    end)
end

function Input:Set(value, skipCallback)
    self.Value = value
    self.InputBox.Text = value
    
    if not skipCallback then
        self.Callback(self.Value)
    end
end

function Input:SetVisible(visible)
    self.Container.Visible = visible
end

function Input:UpdateText(text)
    self.Text = text
    self.TextLabel.Text = text
end

function Input:UpdatePlaceholderText(text)
    self.PlaceholderText = text
    self.InputBox.PlaceholderText = text
end

function Input:Destroy()
    if self.Container then
        self.Container:Destroy()
    end
end

return Input
