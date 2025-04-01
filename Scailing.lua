--[[
    Scaling Utility
    Part of the SystemUI library
    Handles responsive scaling for different screen sizes
--]]

local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")

local Scaling = {}

-- Get device information
Scaling.IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled
Scaling.IsTablet = Scaling.IsMobile and (workspace.CurrentCamera.ViewportSize.X > 800 or workspace.CurrentCamera.ViewportSize.Y > 800)
Scaling.IsPhone = Scaling.IsMobile and not Scaling.IsTablet
Scaling.IsPC = not Scaling.IsMobile

-- Scale factors
Scaling.DefaultScale = 1
Scaling.MobileScale = 1.2
Scaling.TabletScale = 1.1
Scaling.SmallScreenScale = 0.9

-- Get viewport size
function Scaling.GetViewportSize()
    return workspace.CurrentCamera.ViewportSize
end

-- Get inset (notch area) on mobile devices
function Scaling.GetGuiInset()
    return GuiService:GetGuiInset()
end

-- Check if viewport is under a certain size (small screen)
function Scaling.IsSmallScreen()
    local viewportSize = Scaling.GetViewportSize()
    return viewportSize.X < 1000 or viewportSize.Y < 600
end

-- Get appropriate scale based on device and screen size
function Scaling.GetScale()
    if Scaling.IsPhone then
        return Scaling.MobileScale
    elseif Scaling.IsTablet then
        return Scaling.TabletScale
    elseif Scaling.IsSmallScreen() then
        return Scaling.SmallScreenScale
    else
        return Scaling.DefaultScale
    end
end

-- Scale a UDim2 value
function Scaling.ScaleUDim2(udim2, scale)
    scale = scale or Scaling.GetScale()
    
    return UDim2.new(
        udim2.X.Scale,
        udim2.X.Offset * scale,
        udim2.Y.Scale,
        udim2.Y.Offset * scale
    )
end

-- Scale a UDim value
function Scaling.ScaleUDim(udim, scale)
    scale = scale or Scaling.GetScale()
    
    return UDim.new(
        udim.Scale,
        udim.Offset * scale
    )
end

-- Scale a number value
function Scaling.ScaleNumber(number, scale)
    scale = scale or Scaling.GetScale()
    
    return number * scale
end

-- Scale a Vector2 value
function Scaling.ScaleVector2(vector2, scale)
    scale = scale or Scaling.GetScale()
    
    return Vector2.new(
        vector2.X * scale,
        vector2.Y * scale
    )
end

-- Get the safe area for UI elements (accounting for notches/insets on mobile)
function Scaling.GetSafeArea()
    local viewport = Scaling.GetViewportSize()
    local inset = Scaling.GetGuiInset()
    
    return {
        TopLeft = Vector2.new(0, inset.Y),
        TopRight = Vector2.new(viewport.X, inset.Y),
        BottomLeft = Vector2.new(0, viewport.Y - inset.W),
        BottomRight = Vector2.new(viewport.X, viewport.Y - inset.W),
        Width = viewport.X,
        Height = viewport.Y - inset.Y - inset.W,
        InsetTop = inset.Y,
        InsetBottom = inset.W
    }
end

-- Apply scaling to a GUI element
function Scaling.ApplyScale(guiObject, scale)
    scale = scale or Scaling.GetScale()
    
    if not guiObject or not guiObject:IsA("GuiObject") then return end
    
    -- Scale position and size
    if guiObject.Position.X.Offset ~= 0 or guiObject.Position.Y.Offset ~= 0 then
        guiObject.Position = Scaling.ScaleUDim2(guiObject.Position, scale)
    end
    
    if guiObject.Size.X.Offset ~= 0 or guiObject.Size.Y.Offset ~= 0 then
        guiObject.Size = Scaling.ScaleUDim2(guiObject.Size, scale)
    end
    
    -- Scale text size if it's a text object
    if guiObject:IsA("TextLabel") or guiObject:IsA("TextButton") or guiObject:IsA("TextBox") then
        guiObject.TextSize = Scaling.ScaleNumber(guiObject.TextSize, scale)
    end
    
    -- Scale image elements like icon sizes
    if guiObject:IsA("ImageLabel") or guiObject:IsA("ImageButton") then
        if guiObject.ImageRectSize ~= Vector2.new(0, 0) then
            guiObject.ImageRectSize = Scaling.ScaleVector2(guiObject.ImageRectSize, scale)
        end
        
        if guiObject.ImageRectOffset ~= Vector2.new(0, 0) then
            guiObject.ImageRectOffset = Scaling.ScaleVector2(guiObject.ImageRectOffset, scale)
        end
    end
    
    -- Scale UI corners
    local uiCorner = guiObject:FindFirstChildOfClass("UICorner")
    if uiCorner and uiCorner.CornerRadius.Offset ~= 0 then
        uiCorner.CornerRadius = Scaling.ScaleUDim(uiCorner.CornerRadius, scale)
    end
    
    -- Scale UI padding
    local uiPadding = guiObject:FindFirstChildOfClass("UIPadding")
    if uiPadding then
        if uiPadding.PaddingTop.Offset ~= 0 then
            uiPadding.PaddingTop = Scaling.ScaleUDim(uiPadding.PaddingTop, scale)
        end
        if uiPadding.PaddingBottom.Offset ~= 0 then
            uiPadding.PaddingBottom = Scaling.ScaleUDim(uiPadding.PaddingBottom, scale)
        end
        if uiPadding.PaddingLeft.Offset ~= 0 then
            uiPadding.PaddingLeft = Scaling.ScaleUDim(uiPadding.PaddingLeft, scale)
        end
        if uiPadding.PaddingRight.Offset ~= 0 then
            uiPadding.PaddingRight = Scaling.ScaleUDim(uiPadding.PaddingRight, scale)
        end
    end
    
    -- Scale UI list layout
    local uiListLayout = guiObject:FindFirstChildOfClass("UIListLayout")
    if uiListLayout and uiListLayout.Padding.Offset ~= 0 then
        uiListLayout.Padding = Scaling.ScaleUDim(uiListLayout.Padding, scale)
    end
    
    -- Scale UI grid layout
    local uiGridLayout = guiObject:FindFirstChildOfClass("UIGridLayout")
    if uiGridLayout then
        if uiGridLayout.CellPadding.X.Offset ~= 0 or uiGridLayout.CellPadding.Y.Offset ~= 0 then
            uiGridLayout.CellPadding = Scaling.ScaleUDim2(uiGridLayout.CellPadding, scale)
        end
        if uiGridLayout.CellSize.X.Offset ~= 0 or uiGridLayout.CellSize.Y.Offset ~= 0 then
            uiGridLayout.CellSize = Scaling.ScaleUDim2(uiGridLayout.CellSize, scale)
        end
    end
end

-- Apply scaling to all children of a GUI element
function Scaling.ApplyScaleToChildren(guiObject, scale)
    scale = scale or Scaling.GetScale()
    
    if not guiObject then return end
    
    -- Scale the parent object
    if guiObject:IsA("GuiObject") then
        Scaling.ApplyScale(guiObject, scale)
    end
    
    -- Scale all children recursively
    for _, child in ipairs(guiObject:GetChildren()) do
        if child:IsA("GuiObject") then
            Scaling.ApplyScale(child, scale)
            Scaling.ApplyScaleToChildren(child, scale)
        end
    end
end

-- Detect orientation changes (portrait/landscape)
function Scaling.OnOrientationChanged(callback)
    local lastOrientation = workspace.CurrentCamera.ViewportSize.X > workspace.CurrentCamera.ViewportSize.Y
    
    local connection = RunService.RenderStepped:Connect(function()
        local viewport = workspace.CurrentCamera.ViewportSize
        local currentOrientation = viewport.X > viewport.Y
        
        if currentOrientation ~= lastOrientation then
            lastOrientation = currentOrientation
            callback(currentOrientation)
        end
    end)
    
    return connection
end

-- Get orientation info
function Scaling.GetOrientation()
    local viewport = workspace.CurrentCamera.ViewportSize
    local isLandscape = viewport.X > viewport.Y
    
    return {
        IsLandscape = isLandscape,
        IsPortrait = not isLandscape,
        AspectRatio = viewport.X / viewport.Y
    }
end

-- Position elements for safe areas (e.g., respecting notches on phones)
function Scaling.AdjustForSafeArea(guiObject)
    if not guiObject or not guiObject:IsA("GuiObject") then return end
    
    local safeArea = Scaling.GetSafeArea()
    local guiPosition = guiObject.Position
    
    -- Top adjustment
    if guiPosition.Y.Scale < 0.1 then
        guiObject.Position = UDim2.new(
            guiPosition.X.Scale,
            guiPosition.X.Offset,
            guiPosition.Y.Scale,
            guiPosition.Y.Offset + safeArea.InsetTop
        )
    end
    
    -- Bottom adjustment
    if guiPosition.Y.Scale > 0.9 then
        guiObject.Position = UDim2.new(
            guiPosition.X.Scale,
            guiPosition.X.Offset,
            guiPosition.Y.Scale,
            guiPosition.Y.Offset - safeArea.InsetBottom
        )
    end
end

return Scaling
