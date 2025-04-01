--[[
    Window Component
    Part of the SystemUI library
    Creates a main window container that holds other UI elements
--]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Window = {}
Window.__index = Window

-- Load dependencies
        local Button = loadstring(game:HttpGet('https://raw.githubusercontent.com/KingTIM3R/UI_HUB_A4/refs/heads/main/Button.lua'))()
        local Toggle = loadstring(game:HttpGet('https://raw.githubusercontent.com/KingTIM3R/UI_HUB_A4/refs/heads/main/Toggle.lua'))()
        local Slider = loadstring(game:HttpGet('https://raw.githubusercontent.com/KingTIM3R/UI_HUB_A4/refs/heads/main/Slider.lua'))()
        local Input = loadstring(game:HttpGet('https://raw.githubusercontent.com/KingTIM3R/UI_HUB_A4/refs/heads/main/Input.lua'))()
        local Dropdown = loadstring(game:HttpGet('https://raw.githubusercontent.com/KingTIM3R/UI_HUB_A4/refs/heads/main/Dropdown.lua'))()
        local Keybind = loadstring(game:HttpGet('https://raw.githubusercontent.com/KingTIM3R/UI_HUB_A4/refs/heads/main/Keybind.lua'))()
        local ColorPicker = loadstring(game:HttpGet('https://raw.githubusercontent.com/KingTIM3R/UI_HUB_A4/refs/heads/main/ColorPicker.lua'))()
    }
    
    return Components
end

function Window.new(options)
    local self = setmetatable({}, Window)
    
    self.Library = options.Library
    self.Title = options.Title or "Window"
    self.Size = options.Size or UDim2.new(0, 550, 0, 400)
    self.Position = options.Position or UDim2.new(0.5, -275, 0.5, -200)
    self.Theme = self.Library.Theme
    self.Tabs = {}
    self.ActiveTab = nil
    self.Components = {}
    self.Minimized = false
    self.Dragging = false
    self.DragOffset = Vector2.new(0, 0)
    
    -- Create the window
    self:Create()
    
    return self
end

function Window:Create()
    -- Main frame
    self.Frame = Instance.new("Frame")
    self.Frame.Name = "Window_" .. self.Title
    self.Frame.Size = self.Size
    self.Frame.Position = self.Position
    self.Frame.BackgroundColor3 = self.Theme.Background
    self.Frame.BorderSizePixel = 0
    self.Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    self.Frame.Parent = self.Library.GUI
    
    -- Add corner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = self.Frame
    
    -- Add shadow
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.ZIndex = -1
    shadow.Image = "rbxassetid://6015897843"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.6
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    shadow.Parent = self.Frame
    
    -- Title bar
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.Size = UDim2.new(1, 0, 0, 40)
    self.TitleBar.BackgroundColor3 = self.Theme.Header
    self.TitleBar.BorderSizePixel = 0
    self.TitleBar.Parent = self.Frame
    
    -- Title bar corner
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = self.TitleBar
    
    -- Title bar bottom fix (to make it not rounded at bottom)
    local titleBarFix = Instance.new("Frame")
    titleBarFix.Name = "TitleBarFix"
    titleBarFix.Size = UDim2.new(1, 0, 0, 10)
    titleBarFix.Position = UDim2.new(0, 0, 1, -10)
    titleBarFix.BackgroundColor3 = self.Theme.Header
    titleBarFix.BorderSizePixel = 0
    titleBarFix.ZIndex = 0
    titleBarFix.Parent = self.TitleBar
    
    -- Title Text
    self.TitleText = Instance.new("TextLabel")
    self.TitleText.Name = "Title"
    self.TitleText.Size = UDim2.new(1, -100, 1, 0)
    self.TitleText.Position = UDim2.new(0, 15, 0, 0)
    self.TitleText.BackgroundTransparency = 1
    self.TitleText.Text = self.Title
    self.TitleText.Font = Enum.Font.SourceSansBold
    self.TitleText.TextSize = 18
    self.TitleText.TextColor3 = self.Theme.TextPrimary
    self.TitleText.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleText.Parent = self.TitleBar
    
    -- Close button
    self.CloseButton = Instance.new("ImageButton")
    self.CloseButton.Name = "CloseButton"
    self.CloseButton.Size = UDim2.new(0, 20, 0, 20)
    self.CloseButton.Position = UDim2.new(1, -30, 0, 10)
    self.CloseButton.BackgroundTransparency = 1
    self.CloseButton.Image = "rbxassetid://6031094678" -- X icon
    self.CloseButton.ImageColor3 = self.Theme.TextPrimary
    self.CloseButton.Parent = self.TitleBar
    
    -- Minimize button
    self.MinimizeButton = Instance.new("ImageButton")
    self.MinimizeButton.Name = "MinimizeButton"
    self.MinimizeButton.Size = UDim2.new(0, 20, 0, 20)
    self.MinimizeButton.Position = UDim2.new(1, -60, 0, 10)
    self.MinimizeButton.BackgroundTransparency = 1
    self.MinimizeButton.Image = "rbxassetid://6031068426" -- Minimize icon
    self.MinimizeButton.ImageColor3 = self.Theme.TextPrimary
    self.MinimizeButton.Parent = self.TitleBar
    
    -- Content container
    self.Container = Instance.new("Frame")
    self.Container.Name = "Container"
    self.Container.Size = UDim2.new(1, 0, 1, -40)
    self.Container.Position = UDim2.new(0, 0, 0, 40)
    self.Container.BackgroundTransparency = 1
    self.Container.ClipsDescendants = true
    self.Container.Parent = self.Frame
    
    -- Tab container
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Name = "TabContainer"
    self.TabContainer.Size = UDim2.new(0, 130, 1, 0)
    self.TabContainer.BackgroundColor3 = self.Theme.SideBar
    self.TabContainer.BorderSizePixel = 0
    self.TabContainer.Parent = self.Container
    
    -- Tab corner
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 8)
    tabCorner.Parent = self.TabContainer
    
    -- Tab corner fix (to make it not rounded at right side)
    local tabFix = Instance.new("Frame")
    tabFix.Name = "TabFix"
    tabFix.Size = UDim2.new(0, 10, 1, 0)
    tabFix.Position = UDim2.new(1, -10, 0, 0)
    tabFix.BackgroundColor3 = self.Theme.SideBar
    tabFix.BorderSizePixel = 0
    tabFix.ZIndex = 0
    tabFix.Parent = self.TabContainer
    
    -- Tab button container
    self.TabButtonContainer = Instance.new("ScrollingFrame")
    self.TabButtonContainer.Name = "TabButtonContainer"
    self.TabButtonContainer.Size = UDim2.new(1, 0, 1, 0)
    self.TabButtonContainer.BackgroundTransparency = 1
    self.TabButtonContainer.BorderSizePixel = 0
    self.TabButtonContainer.ScrollBarThickness = 2
    self.TabButtonContainer.ScrollBarImageColor3 = self.Theme.TextSecondary
    self.TabButtonContainer.CanvasSize = UDim2.new(0, 0, 0, 0) -- Will be updated as tabs are added
    self.TabButtonContainer.Parent = self.TabContainer
    
    -- Tab button layout
    self.TabButtonLayout = Instance.new("UIListLayout")
    self.TabButtonLayout.Padding = UDim.new(0, 5)
    self.TabButtonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    self.TabButtonLayout.SortOrder = Enum.SortOrder.LayoutOrder
    self.TabButtonLayout.Parent = self.TabButtonContainer
    
    -- Tab content container
    self.TabContentContainer = Instance.new("Frame")
    self.TabContentContainer.Name = "TabContentContainer"
    self.TabContentContainer.Size = UDim2.new(1, -130, 1, 0)
    self.TabContentContainer.Position = UDim2.new(0, 130, 0, 0)
    self.TabContentContainer.BackgroundTransparency = 1
    self.TabContentContainer.BorderSizePixel = 0
    self.TabContentContainer.ClipsDescendants = true
    self.TabContentContainer.Parent = self.Container
    
    -- Set up window dragging
    self:SetupDragging()
    
    -- Connect events
    self.CloseButton.MouseButton1Click:Connect(function()
        self:Close()
    end)
    
    self.MinimizeButton.MouseButton1Click:Connect(function()
        self:Minimize()
    end)
    
    -- Load component references
    self.Components = LoadDependencies(script)
end

function Window:SetupDragging()
    local dragging = false
    local dragInput
    local dragStart
    local startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        self.Frame.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X, 
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
    
    self.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self.Frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    self.TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

function Window:Minimize()
    self.Minimized = not self.Minimized
    
    local targetSize = self.Minimized 
        and UDim2.new(self.Size.X.Scale, self.Size.X.Offset, 0, 40) 
        or self.Size
    
    TweenService:Create(self.Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Size = targetSize
    }):Play()
end

function Window:Close()
    TweenService:Create(self.Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, self.Size.X.Offset, 0, 0),
        Position = UDim2.new(self.Position.X.Scale, self.Position.X.Offset, self.Position.Y.Scale, self.Position.Y.Offset + self.Size.Y.Offset/2)
    }):Play()
    
    wait(0.3)
    self.Frame:Destroy()
    
    -- Remove from library's windows list
    for i, window in pairs(self.Library.Windows) do
        if window == self then
            table.remove(self.Library.Windows, i)
            break
        end
    end
end

function Window:CreateTab(options)
    options = options or {}
    options.Name = options.Name or "Tab"
    options.Icon = options.Icon or nil
    
    -- Create tab button
    local tabButton = Instance.new("TextButton")
    tabButton.Name = "TabButton_" .. options.Name
    tabButton.Size = UDim2.new(0, 120, 0, 32)
    tabButton.BackgroundColor3 = self.Theme.TabInactive
    tabButton.BorderSizePixel = 0
    tabButton.Text = ""
    tabButton.AutoButtonColor = false
    tabButton.LayoutOrder = #self.Tabs + 1
    tabButton.Parent = self.TabButtonContainer
    
    -- Add corner to button
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = tabButton
    
    -- Tab button icon
    local icon = nil
    if options.Icon then
        icon = Instance.new("ImageLabel")
        icon.Name = "Icon"
        icon.Size = UDim2.new(0, 16, 0, 16)
        icon.Position = UDim2.new(0, 10, 0.5, -8)
        icon.BackgroundTransparency = 1
        icon.Image = options.Icon
        icon.ImageColor3 = self.Theme.TextSecondary
        icon.Parent = tabButton
    end
    
    -- Tab button text
    local text = Instance.new("TextLabel")
    text.Name = "Text"
    text.BackgroundTransparency = 1
    text.Text = options.Name
    text.Font = Enum.Font.SourceSans
    text.TextSize = 16
    text.TextColor3 = self.Theme.TextSecondary
    
    if options.Icon then
        text.Size = UDim2.new(1, -36, 1, 0)
        text.Position = UDim2.new(0, 36, 0, 0)
        text.TextXAlignment = Enum.TextXAlignment.Left
    else
        text.Size = UDim2.new(1, 0, 1, 0)
        text.Position = UDim2.new(0, 0, 0, 0)
        text.TextXAlignment = Enum.TextXAlignment.Center
    end
    
    text.Parent = tabButton
    
    -- Create tab content
    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Name = "TabContent_" .. options.Name
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.BorderSizePixel = 0
    tabContent.ScrollBarThickness = 4
    tabContent.ScrollBarImageColor3 = self.Theme.TextSecondary
    tabContent.Visible = false
    tabContent.Parent = self.TabContentContainer
    
    -- Content layout
    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingLeft = UDim.new(0, 15)
    contentPadding.PaddingRight = UDim.new(0, 15)
    contentPadding.PaddingTop = UDim.new(0, 15)
    contentPadding.PaddingBottom = UDim.new(0, 15)
    contentPadding.Parent = tabContent
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 8)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Parent = tabContent
    
    -- Automatically update CanvasSize when children are added
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 30)
    end)
    
    -- Create tab object
    local tab = {
        Name = options.Name,
        Button = tabButton,
        Content = tabContent,
        Window = self
    }
    
    -- Click event for tab button
    tabButton.MouseButton1Click:Connect(function()
        self:SelectTab(tab)
    end)
    
    table.insert(self.Tabs, tab)
    
    -- Update TabButtonContainer canvas size
    self.TabButtonContainer.CanvasSize = UDim2.new(
        0, 0, 
        0, self.TabButtonLayout.AbsoluteContentSize.Y + 10
    )
    
    -- If this is the first tab, select it automatically
    if #self.Tabs == 1 then
        self:SelectTab(tab)
    end
    
    -- Add component creation methods to the tab
    tab.CreateButton = function(_, options)
        return self.Components.Button.new(self, tab, options)
    end
    
    tab.CreateToggle = function(_, options)
        return self.Components.Toggle.new(self, tab, options)
    end
    
    tab.CreateSlider = function(_, options)
        return self.Components.Slider.new(self, tab, options)
    end
    
    tab.CreateInput = function(_, options)
        return self.Components.Input.new(self, tab, options)
    end
    
    tab.CreateDropdown = function(_, options)
        return self.Components.Dropdown.new(self, tab, options)
    end
    
    tab.CreateKeybind = function(_, options)
        return self.Components.Keybind.new(self, tab, options)
    end
    
    tab.CreateColorPicker = function(_, options)
        return self.Components.ColorPicker.new(self, tab, options)
    end
    
    tab.CreateSection = function(_, title)
        local section = Instance.new("Frame")
        section.Name = "Section_" .. title
        section.Size = UDim2.new(1, 0, 0, 40)
        section.BackgroundTransparency = 1
        section.Parent = tabContent
        
        local sectionTitle = Instance.new("TextLabel")
        sectionTitle.Name = "Title"
        sectionTitle.Size = UDim2.new(1, 0, 0, 30)
        sectionTitle.Position = UDim2.new(0, 0, 0, 5)
        sectionTitle.BackgroundTransparency = 1
        sectionTitle.Text = title
        sectionTitle.Font = Enum.Font.SourceSansBold
        sectionTitle.TextSize = 18
        sectionTitle.TextColor3 = self.Theme.TextPrimary
        sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
        sectionTitle.Parent = section
        
        local divider = Instance.new("Frame")
        divider.Name = "Divider"
        divider.Size = UDim2.new(1, 0, 0, 1)
        divider.Position = UDim2.new(0, 0, 0, 35)
        divider.BackgroundColor3 = self.Theme.Divider
        divider.BorderSizePixel = 0
        divider.Parent = section
        
        return section
    end
    
    return tab
end

function Window:SelectTab(tab)
    if self.ActiveTab == tab then return end
    
    -- Hide all tabs
    for _, t in pairs(self.Tabs) do
        t.Content.Visible = false
        
        TweenService:Create(t.Button, TweenInfo.new(0.2), {
            BackgroundColor3 = self.Theme.TabInactive
        }):Play()
        
        if t.Button:FindFirstChild("Text") then
            TweenService:Create(t.Button.Text, TweenInfo.new(0.2), {
                TextColor3 = self.Theme.TextSecondary
            }):Play()
        end
        
        if t.Button:FindFirstChild("Icon") then
            TweenService:Create(t.Button.Icon, TweenInfo.new(0.2), {
                ImageColor3 = self.Theme.TextSecondary
            }):Play()
        end
    end
    
    -- Show selected tab
    tab.Content.Visible = true
    
    TweenService:Create(tab.Button, TweenInfo.new(0.2), {
        BackgroundColor3 = self.Theme.TabActive
    }):Play()
    
    if tab.Button:FindFirstChild("Text") then
        TweenService:Create(tab.Button.Text, TweenInfo.new(0.2), {
            TextColor3 = self.Theme.TextPrimary
        }):Play()
    end
    
    if tab.Button:FindFirstChild("Icon") then
        TweenService:Create(tab.Button.Icon, TweenInfo.new(0.2), {
            ImageColor3 = self.Theme.TextPrimary
        }):Play()
    end
    
    self.ActiveTab = tab
end

function Window:Destroy()
    if self.Frame then
        self.Frame:Destroy()
    end
end

return Window
