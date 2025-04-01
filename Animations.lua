--[[
    Animations Utility
    Part of the SystemUI library
    Handles animations and transitions for UI elements
--]]

local TweenService = game:GetService("TweenService")

local Animations = {}

-- Default tween settings
Animations.DefaultTweenInfo = TweenInfo.new(
    0.2,                       -- Time
    Enum.EasingStyle.Quint,    -- EasingStyle
    Enum.EasingDirection.Out   -- EasingDirection
)

-- Fade transparency (used for showing/hiding UI elements)
function Animations.FadeTransparency(instance, targetTransparency, duration, callback)
    if not instance or not instance:IsA("GuiObject") then return end
    
    duration = duration or Animations.DefaultTweenInfo.Time
    
    local tweenInfo = TweenInfo.new(
        duration,
        Animations.DefaultTweenInfo.EasingStyle,
        Animations.DefaultTweenInfo.EasingDirection
    )
    
    local tween = TweenService:Create(
        instance,
        tweenInfo,
        { BackgroundTransparency = targetTransparency }
    )
    
    if callback then
        tween.Completed:Connect(function()
            callback()
        end)
    end
    
    tween:Play()
    
    return tween
end

-- Fade text transparency
function Animations.FadeTextTransparency(instance, targetTransparency, duration, callback)
    if not instance or not (instance:IsA("TextLabel") or instance:IsA("TextButton") or instance:IsA("TextBox")) then
        return
    end
    
    duration = duration or Animations.DefaultTweenInfo.Time
    
    local tweenInfo = TweenInfo.new(
        duration,
        Animations.DefaultTweenInfo.EasingStyle,
        Animations.DefaultTweenInfo.EasingDirection
    )
    
    local tween = TweenService:Create(
        instance,
        tweenInfo,
        { TextTransparency = targetTransparency }
    )
    
    if callback then
        tween.Completed:Connect(function()
            callback()
        end)
    end
    
    tween:Play()
    
    return tween
end

-- Fade image transparency
function Animations.FadeImageTransparency(instance, targetTransparency, duration, callback)
    if not instance or not instance:IsA("ImageLabel") and not instance:IsA("ImageButton") then
        return
    end
    
    duration = duration or Animations.DefaultTweenInfo.Time
    
    local tweenInfo = TweenInfo.new(
        duration,
        Animations.DefaultTweenInfo.EasingStyle,
        Animations.DefaultTweenInfo.EasingDirection
    )
    
    local tween = TweenService:Create(
        instance,
        tweenInfo,
        { ImageTransparency = targetTransparency }
    )
    
    if callback then
        tween.Completed:Connect(function()
            callback()
        end)
    end
    
    tween:Play()
    
    return tween
end

-- Resize animation
function Animations.Resize(instance, targetSize, duration, callback)
    if not instance or not instance:IsA("GuiObject") then return end
    
    duration = duration or Animations.DefaultTweenInfo.Time
    
    local tweenInfo = TweenInfo.new(
        duration,
        Animations.DefaultTweenInfo.EasingStyle,
        Animations.DefaultTweenInfo.EasingDirection
    )
    
    local tween = TweenService:Create(
        instance,
        tweenInfo,
        { Size = targetSize }
    )
    
    if callback then
        tween.Completed:Connect(function()
            callback()
        end)
    end
    
    tween:Play()
    
    return tween
end

-- Move animation
function Animations.Move(instance, targetPosition, duration, callback)
    if not instance or not instance:IsA("GuiObject") then return end
    
    duration = duration or Animations.DefaultTweenInfo.Time
    
    local tweenInfo = TweenInfo.new(
        duration,
        Animations.DefaultTweenInfo.EasingStyle,
        Animations.DefaultTweenInfo.EasingDirection
    )
    
    local tween = TweenService:Create(
        instance,
        tweenInfo,
        { Position = targetPosition }
    )
    
    if callback then
        tween.Completed:Connect(function()
            callback()
        end)
    end
    
    tween:Play()
    
    return tween
end

-- Color change animation
function Animations.ChangeColor(instance, targetColor, duration, callback)
    if not instance or not instance:IsA("GuiObject") then return end
    
    duration = duration or Animations.DefaultTweenInfo.Time
    
    local tweenInfo = TweenInfo.new(
        duration,
        Animations.DefaultTweenInfo.EasingStyle,
        Animations.DefaultTweenInfo.EasingDirection
    )
    
    local tween = TweenService:Create(
        instance,
        tweenInfo,
        { BackgroundColor3 = targetColor }
    )
    
    if callback then
        tween.Completed:Connect(function()
            callback()
        end)
    end
    
    tween:Play()
    
    return tween
end

-- Text color change animation
function Animations.ChangeTextColor(instance, targetColor, duration, callback)
    if not instance or not (instance:IsA("TextLabel") or instance:IsA("TextButton") or instance:IsA("TextBox")) then
        return
    end
    
    duration = duration or Animations.DefaultTweenInfo.Time
    
    local tweenInfo = TweenInfo.new(
        duration,
        Animations.DefaultTweenInfo.EasingStyle,
        Animations.DefaultTweenInfo.EasingDirection
    )
    
    local tween = TweenService:Create(
        instance,
        tweenInfo,
        { TextColor3 = targetColor }
    )
    
    if callback then
        tween.Completed:Connect(function()
            callback()
        end)
    end
    
    tween:Play()
    
    return tween
end

-- Image color change animation
function Animations.ChangeImageColor(instance, targetColor, duration, callback)
    if not instance or not (instance:IsA("ImageLabel") or instance:IsA("ImageButton")) then
        return
    end
    
    duration = duration or Animations.DefaultTweenInfo.Time
    
    local tweenInfo = TweenInfo.new(
        duration,
        Animations.DefaultTweenInfo.EasingStyle,
        Animations.DefaultTweenInfo.EasingDirection
    )
    
    local tween = TweenService:Create(
        instance,
        tweenInfo,
        { ImageColor3 = targetColor }
    )
    
    if callback then
        tween.Completed:Connect(function()
            callback()
        end)
    end
    
    tween:Play()
    
    return tween
end

-- Scale animation (for when you need to use Scale rather than Offset)
function Animations.Scale(instance, targetScale, duration, callback)
    if not instance or not instance:IsA("GuiObject") then return end
    
    duration = duration or Animations.DefaultTweenInfo.Time
    
    local tweenInfo = TweenInfo.new(
        duration,
        Animations.DefaultTweenInfo.EasingStyle,
        Animations.DefaultTweenInfo.EasingDirection
    )
    
    local tween = TweenService:Create(
        instance,
        tweenInfo,
        { 
            Size = UDim2.new(
                targetScale.X.Scale, 
                instance.Size.X.Offset, 
                targetScale.Y.Scale, 
                instance.Size.Y.Offset
            ) 
        }
    )
    
    if callback then
        tween.Completed:Connect(function()
            callback()
        end)
    end
    
    tween:Play()
    
    return tween
end

-- Create a ripple effect (for buttons)
function Animations.CreateRipple(parent, x, y)
    if not parent or not parent:IsA("GuiObject") then return end
    
    -- Create ripple frame
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.Position = UDim2.new(0, x - parent.AbsolutePosition.X, 0, y - parent.AbsolutePosition.Y)
    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = 0.8
    ripple.BorderSizePixel = 0
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.ZIndex = parent.ZIndex + 1
    
    -- Make it a circle
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ripple
    
    ripple.Parent = parent
    
    -- Animate ripple
    local maxSize = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) * 2
    
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
    
    return ripple
end

-- Slide in from side animation
function Animations.SlideIn(instance, fromDirection, duration, callback)
    if not instance or not instance:IsA("GuiObject") then return end
    
    duration = duration or 0.5
    fromDirection = fromDirection or "Right"
    
    -- Save original position
    local originalPosition = instance.Position
    local targetPosition = originalPosition
    
    -- Set starting position based on direction
    if fromDirection == "Right" then
        instance.Position = UDim2.new(1, instance.AbsoluteSize.X, originalPosition.Y.Scale, originalPosition.Y.Offset)
    elseif fromDirection == "Left" then
        instance.Position = UDim2.new(-1, -instance.AbsoluteSize.X, originalPosition.Y.Scale, originalPosition.Y.Offset)
    elseif fromDirection == "Top" then
        instance.Position = UDim2.new(originalPosition.X.Scale, originalPosition.X.Offset, -1, -instance.AbsoluteSize.Y)
    elseif fromDirection == "Bottom" then
        instance.Position = UDim2.new(originalPosition.X.Scale, originalPosition.X.Offset, 1, instance.AbsoluteSize.Y)
    end
    
    -- Make instance visible
    instance.Visible = true
    
    -- Animate to original position
    local tween = TweenService:Create(
        instance,
        TweenInfo.new(duration, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        { Position = targetPosition }
    )
    
    if callback then
        tween.Completed:Connect(function()
            callback()
        end)
    end
    
    tween:Play()
    
    return tween
end

-- Slide out animation
function Animations.SlideOut(instance, toDirection, duration, callback)
    if not instance or not instance:IsA("GuiObject") then return end
    
    duration = duration or 0.5
    toDirection = toDirection or "Right"
    
    local originalPosition = instance.Position
    local targetPosition
    
    -- Set target position based on direction
    if toDirection == "Right" then
        targetPosition = UDim2.new(1, instance.AbsoluteSize.X, originalPosition.Y.Scale, originalPosition.Y.Offset)
    elseif toDirection == "Left" then
        targetPosition = UDim2.new(-1, -instance.AbsoluteSize.X, originalPosition.Y.Scale, originalPosition.Y.Offset)
    elseif toDirection == "Top" then
        targetPosition = UDim2.new(originalPosition.X.Scale, originalPosition.X.Offset, -1, -instance.AbsoluteSize.Y)
    elseif toDirection == "Bottom" then
        targetPosition = UDim2.new(originalPosition.X.Scale, originalPosition.X.Offset, 1, instance.AbsoluteSize.Y)
    end
    
    -- Animate to target position
    local tween = TweenService:Create(
        instance,
        TweenInfo.new(duration, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        { Position = targetPosition }
    )
    
    -- Hide instance after animation
    if callback then
        tween.Completed:Connect(function()
            instance.Visible = false
            instance.Position = originalPosition
            callback()
        end)
    else
        tween.Completed:Connect(function()
            instance.Visible = false
            instance.Position = originalPosition
        end)
    end
    
    tween:Play()
    
    return tween
end

return Animations
