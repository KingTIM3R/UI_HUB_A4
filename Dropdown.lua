--[[
    Dropdown Component
    Part of the SystemUI library
    Creates a dropdown selection menu
--]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Dropdown = {}
Dropdown.__index = Dropdown

function Dropdown.new(window, tab, options)
    local self = setmetatable({}, Dropdown)
    
    self.Window = window
    self.Tab = tab
    self.Theme = window.Theme
    self.Text = options.Text or "Dropdown"
    self.Options = options.Options or {}
    self.Default = options.Default or nil
    self.Callback = options.Callback or function() end
    self.Value = self.Default
    self.Open = false
    self.MaxVisibleItems = options.MaxVisibleItems or 5
    
    self:Create()
    
    return self
end

function Dropdown:Create()
    -- Main container
    self.Container = Instance.new("Frame")
    self.Container.Name = "Dropdown_" .. self.Text
    self.Container.Size = UDim2.new(1, 0, 0, 60)
    self.Container.BackgroundTransparency = 1
    self.Container.ClipsDescendants = true
    self.Container.Parent = self.Tab.Content
    
    -- Background
    self.Instance = Instance.new("Frame")
    self.Instance.Name = "DropdownInstance"
    self.Instance.Size = UDim2.new(1, 0, 0, 60)
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
    
    -- Selection button
    self.SelectionButton = Instance.new("TextButton")
    self.SelectionButton.Name = "SelectionButton"
    self.SelectionButton.Size = UDim2.new(1, -30, 0, 30)
    self.SelectionButton.Position = UDim2.new(0, 15, 0, 30)
    self.SelectionButton.BackgroundColor3 = self.Theme.DropdownButton
    self.SelectionButton.BorderSizePixel = 0
    self.SelectionButton.Text = ""
    self.SelectionButton.AutoButtonColor = false
    self.SelectionButton.Parent = self.Instance
    
    -- Corner for selection button
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 4)
    buttonCorner.Parent = self.SelectionButton
    
    -- Selected value text
    self.SelectedText = Instance.new("TextLabel")
    self.SelectedText.Name = "SelectedText"
    self.SelectedText.Size = UDim2.new(1, -40, 1, 0)
    self.SelectedText.Position = UDim2.new(0, 10, 0, 0)
    self.SelectedText.BackgroundTransparency = 1
    self.SelectedText.Font = Enum.Font.SourceSans
    self.SelectedText.TextSize = 16
    self.SelectedText.TextColor3 = self.Theme.TextPrimary
    self.SelectedText.TextXAlignment = Enum.TextXAlignment.Left
    self.SelectedText.Text = "Select..."
    self.SelectedText.Parent = self.SelectionButton
    
    -- Arrow icon
    self.Arrow = Instance.new("ImageLabel")
    self.Arrow.Name = "Arrow"
    self.Arrow.Size = UDim2.new(0, 16, 0, 16)
    self.Arrow.Position = UDim2.new(1, -26, 0.5, -8)
    self.Arrow.BackgroundTransparency = 1
    self.Arrow.Image = "rbxassetid://6031091004" -- Arrow down icon
    self.Arrow.ImageColor3 = self.Theme.TextSecondary
    self.Arrow.Parent = self.SelectionButton
    
    -- Dropdown list container
    self.DropdownContainer = Instance.new("Frame")
    self.DropdownContainer.Name = "DropdownContainer"
    self.DropdownContainer.Size = UDim2.new(1, -30, 0, 0) -- Will be updated when opened
    self.DropdownContainer.Position = UDim2.new(0, 15, 0, 60)
    self.DropdownContainer.BackgroundColor3 = self.Theme.DropdownList
    self.DropdownContainer.BorderSizePixel = 0
    self.DropdownContainer.ClipsDescendants = true
    self.DropdownContainer.ZIndex = 2
    self.DropdownContainer.Visible = false
    self.DropdownContainer.Parent = self.Instance
    
    -- Corner for dropdown container
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 4)
    containerCorner.Parent = self.DropdownContainer
    
    -- Scrolling frame for options
    self.OptionList = Instance.new("ScrollingFrame")
    self.OptionList.Name = "OptionList"
    self.OptionList.Size = UDim2.new(1, 0, 1, 0)
    self.OptionList.BackgroundTransparency = 1
    self.OptionList.BorderSizePixel = 0
    self.OptionList.ScrollBarThickness = 4
    self.OptionList.ScrollBarImageColor3 = self.Theme.TextSecondary
    self.OptionList.ZIndex = 2
    self.OptionList.Parent = self.DropdownContainer
    
    -- Layout for option list
    local listPadding = Instance.new("UIPadding")
    listPadding.PaddingLeft = UDim.new(0, 5)
    listPadding.PaddingRight = UDim.new(0, 5)
    listPadding.PaddingTop = UDim.new(0, 5)
    listPadding.PaddingBottom = UDim.new(0, 5)
    listPadding.Parent = self.OptionList
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 2)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = self.OptionList
    
    -- Connect events
    self:ConnectEvents()
    
    -- Create option buttons
    self:CreateOptions()
    
    -- Automatically update CanvasSize when children are added
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.OptionList.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
    end)
    
    -- Set default value if provided
    if self.Default ~= nil and self.Options[self.Default] then
        self:Set(self.Default, true)
    elseif self.Default ~= nil and type(self.Default) == "string" then
        -- Find the option by string value
        for i, option in ipairs(self.Options) do
            if option == self.Default then
                self:Set(i, true)
                break
            end
        end
    end
end

function Dropdown:CreateOptions()
    -- Clear existing options
    for _, child in pairs(self.OptionList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    -- Create new option buttons
    for i, option in ipairs(self.Options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Name = "Option_" .. i
        optionButton.Size = UDim2.new(1, 0, 0, 30)
        optionButton.BackgroundColor3 = self.Theme.DropdownOption
        optionButton.BorderSizePixel = 0
        optionButton.Text = ""
        optionButton.AutoButtonColor = false
        optionButton.ZIndex = 2
        optionButton.LayoutOrder = i
        optionButton.Parent = self.OptionList
        
        -- Corner for option button
        local optionCorner = Instance.new("UICorner")
        optionCorner.CornerRadius = UDim.new(0, 4)
        optionCorner.Parent = optionButton
        
        -- Option text
        local optionText = Instance.new("TextLabel")
        optionText.Name = "Text"
        optionText.Size = UDim2.new(1, -10, 1, 0)
        optionText.Position = UDim2.new(0, 10, 0, 0)
        optionText.BackgroundTransparency = 1
        optionText.Font = Enum.Font.SourceSans
        optionText.TextSize = 16
        optionText.TextColor3 = self.Theme.TextPrimary
        optionText.TextXAlignment = Enum.TextXAlignment.Left
        optionText.Text = option
        optionText.ZIndex = 2
        optionText.Parent = optionButton
        
        -- Connect option button events
        optionButton.MouseEnter:Connect(function()
            TweenService:Create(optionButton, TweenInfo.new(0.2), {
                BackgroundColor3 = self.Theme.DropdownOptionHover
            }):Play()
        end)
        
        optionButton.MouseLeave:Connect(function()
            TweenService:Create(optionButton, TweenInfo.new(0.2), {
                BackgroundColor3 = self.Theme.DropdownOption
            }):Play()
        end)
        
        optionButton.MouseButton1Click:Connect(function()
            self:Set(i)
            self:Toggle(false)
        end)
    end
end

function Dropdown:ConnectEvents()
    -- Button click to toggle dropdown
    self.SelectionButton.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
    
    -- Button hover effects
    self.SelectionButton.MouseEnter:Connect(function()
        TweenService:Create(self.SelectionButton, TweenInfo.new(0.2), {
            BackgroundColor3 = self.Theme.DropdownButtonHover
        }):Play()
    end)
    
    self.SelectionButton.MouseLeave:Connect(function()
        TweenService:Create(self.SelectionButton, TweenInfo.new(0.2), {
            BackgroundColor3 = self.Theme.DropdownButton
        }):Play()
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

function Dropdown:Toggle(state)
    if state ~= nil then
        self.Open = state
    else
        self.Open = not self.Open
    end
    
    local maxHeight = 30 * math.min(#self.Options, self.MaxVisibleItems) + 10
    
    if self.Open then
        -- Show dropdown
        self.DropdownContainer.Visible = true
        
        -- Update container height
        TweenService:Create(self.Container, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
            Size = UDim2.new(1, 0, 0, 60 + maxHeight)
        }):Play()
        
        TweenService:Create(self.DropdownContainer, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
            Size = UDim2.new(1, -30, 0, maxHeight)
        }):Play()
        
        -- Rotate arrow
        TweenService:Create(self.Arrow, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
            Rotation = 180
        }):Play()
    else
        -- Rotate arrow back
        TweenService:Create(self.Arrow, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
            Rotation = 0
        }):Play()
        
        -- Shrink container
        TweenService:Create(self.Container, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
            Size = UDim2.new(1, 0, 0, 60)
        }):Play()
        
        TweenService:Create(self.DropdownContainer, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
            Size = UDim2.new(1, -30, 0, 0)
        }):Play()
        
        -- Hide after animation
        spawn(function()
            wait(0.3)
            if not self.Open then
                self.DropdownContainer.Visible = false
            end
        end)
    end
end

function Dropdown:Set(value, skipCallback)
    -- Check if value is in range
    if type(value) == "number" and (value < 1 or value > #self.Options) then
        return
    end
    
    self.Value = value
    
    -- Update text
    if type(value) == "number" then
        self.SelectedText.Text = self.Options[value]
    else
        self.SelectedText.Text = "Select..."
    end
    
    -- Call callback
    if not skipCallback then
        self.Callback(self.Value, type(value) == "number" and self.Options[value] or nil)
    end
end

function Dropdown:Refresh(options, keepSelection)
    self.Options = options or {}
    
    -- Recreate options
    self:CreateOptions()
    
    -- Try to keep current selection if requested
    if keepSelection and self.Value ~= nil then
        if type(self.Value) == "number" and self.Value <= #self.Options then
            self:Set(self.Value, true)
        else
            self:Set(nil, true)
        end
    else
        self:Set(nil, true)
    end
    
    -- Update container height if open
    if self.Open then
        local maxHeight = 30 * math.min(#self.Options, self.MaxVisibleItems) + 10
        
        TweenService:Create(self.Container, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
            Size = UDim2.new(1, 0, 0, 60 + maxHeight)
        }):Play()
        
        TweenService:Create(self.DropdownContainer, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
            Size = UDim2.new(1, -30, 0, maxHeight)
        }):Play()
    end
end

function Dropdown:SetVisible(visible)
    self.Container.Visible = visible
end

function Dropdown:UpdateText(text)
    self.Text = text
    self.TextLabel.Text = text
end

function Dropdown:Destroy()
    if self.Container then
        self.Container:Destroy()
    end
end

return Dropdown
