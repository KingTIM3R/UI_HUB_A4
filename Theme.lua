--[[
    Theme Utility
    Part of the SystemUI library
    Manages themes and color schemes for the UI
--]]

local Theme = {}

-- Color definitions
Theme.Default = {
    -- Main backgrounds
    Background = Color3.fromRGB(25, 25, 30),
    Header = Color3.fromRGB(35, 35, 40),
    SideBar = Color3.fromRGB(30, 30, 35),
    
    -- Component colors
    ComponentBackground = Color3.fromRGB(40, 40, 45),
    ComponentBackgroundHover = Color3.fromRGB(50, 50, 55),
    ComponentBackgroundPress = Color3.fromRGB(35, 35, 40),
    ComponentBackgroundDisabled = Color3.fromRGB(35, 35, 40),
    
    -- Button colors
    ButtonPrimary = Color3.fromRGB(66, 133, 244),
    ButtonSecondary = Color3.fromRGB(45, 45, 50),
    
    -- Dropdown colors
    DropdownButton = Color3.fromRGB(45, 45, 50),
    DropdownButtonHover = Color3.fromRGB(55, 55, 60),
    DropdownList = Color3.fromRGB(40, 40, 45),
    DropdownOption = Color3.fromRGB(45, 45, 50),
    DropdownOptionHover = Color3.fromRGB(55, 55, 60),
    
    -- Input colors
    InputBackground = Color3.fromRGB(35, 35, 40),
    InputBackgroundFocused = Color3.fromRGB(45, 45, 50),
    
    -- Toggle colors
    ToggleBackgroundOn = Color3.fromRGB(66, 133, 244),
    ToggleBackgroundOff = Color3.fromRGB(45, 45, 50),
    ToggleKnob = Color3.fromRGB(255, 255, 255),
    
    -- Slider colors
    SliderBackground = Color3.fromRGB(45, 45, 50),
    SliderFill = Color3.fromRGB(66, 133, 244),
    SliderKnob = Color3.fromRGB(255, 255, 255),
    
    -- Keybind colors
    KeybindButton = Color3.fromRGB(45, 45, 50),
    KeybindButtonHover = Color3.fromRGB(55, 55, 60),
    KeybindButtonActive = Color3.fromRGB(66, 133, 244),
    
    -- Tab colors
    TabInactive = Color3.fromRGB(35, 35, 40),
    TabActive = Color3.fromRGB(50, 50, 55),
    
    -- Text colors
    TextPrimary = Color3.fromRGB(240, 240, 245),
    TextSecondary = Color3.fromRGB(180, 180, 185),
    TextDisabled = Color3.fromRGB(120, 120, 125),
    TextPlaceholder = Color3.fromRGB(120, 120, 125),
    
    -- Other
    Divider = Color3.fromRGB(50, 50, 55),
    Accent = Color3.fromRGB(66, 133, 244),
    Shadow = Color3.fromRGB(0, 0, 0)
}

-- Light theme
Theme.Light = {
    -- Main backgrounds
    Background = Color3.fromRGB(240, 240, 245),
    Header = Color3.fromRGB(225, 225, 230),
    SideBar = Color3.fromRGB(230, 230, 235),
    
    -- Component colors
    ComponentBackground = Color3.fromRGB(220, 220, 225),
    ComponentBackgroundHover = Color3.fromRGB(210, 210, 215),
    ComponentBackgroundPress = Color3.fromRGB(200, 200, 205),
    ComponentBackgroundDisabled = Color3.fromRGB(210, 210, 215),
    
    -- Button colors
    ButtonPrimary = Color3.fromRGB(66, 133, 244),
    ButtonSecondary = Color3.fromRGB(200, 200, 205),
    
    -- Dropdown colors
    DropdownButton = Color3.fromRGB(210, 210, 215),
    DropdownButtonHover = Color3.fromRGB(200, 200, 205),
    DropdownList = Color3.fromRGB(230, 230, 235),
    DropdownOption = Color3.fromRGB(220, 220, 225),
    DropdownOptionHover = Color3.fromRGB(210, 210, 215),
    
    -- Input colors
    InputBackground = Color3.fromRGB(210, 210, 215),
    InputBackgroundFocused = Color3.fromRGB(200, 200, 205),
    
    -- Toggle colors
    ToggleBackgroundOn = Color3.fromRGB(66, 133, 244),
    ToggleBackgroundOff = Color3.fromRGB(180, 180, 185),
    ToggleKnob = Color3.fromRGB(255, 255, 255),
    
    -- Slider colors
    SliderBackground = Color3.fromRGB(180, 180, 185),
    SliderFill = Color3.fromRGB(66, 133, 244),
    SliderKnob = Color3.fromRGB(255, 255, 255),
    
    -- Keybind colors
    KeybindButton = Color3.fromRGB(210, 210, 215),
    KeybindButtonHover = Color3.fromRGB(200, 200, 205),
    KeybindButtonActive = Color3.fromRGB(66, 133, 244),
    
    -- Tab colors
    TabInactive = Color3.fromRGB(220, 220, 225),
    TabActive = Color3.fromRGB(210, 210, 215),
    
    -- Text colors
    TextPrimary = Color3.fromRGB(30, 30, 35),
    TextSecondary = Color3.fromRGB(80, 80, 85),
    TextDisabled = Color3.fromRGB(150, 150, 155),
    TextPlaceholder = Color3.fromRGB(150, 150, 155),
    
    -- Other
    Divider = Color3.fromRGB(200, 200, 205),
    Accent = Color3.fromRGB(66, 133, 244),
    Shadow = Color3.fromRGB(0, 0, 0)
}

-- Dark theme (higher contrast)
Theme.Dark = {
    -- Main backgrounds
    Background = Color3.fromRGB(20, 20, 25),
    Header = Color3.fromRGB(30, 30, 35),
    SideBar = Color3.fromRGB(25, 25, 30),
    
    -- Component colors
    ComponentBackground = Color3.fromRGB(35, 35, 40),
    ComponentBackgroundHover = Color3.fromRGB(45, 45, 50),
    ComponentBackgroundPress = Color3.fromRGB(30, 30, 35),
    ComponentBackgroundDisabled = Color3.fromRGB(30, 30, 35),
    
    -- Button colors
    ButtonPrimary = Color3.fromRGB(66, 133, 244),
    ButtonSecondary = Color3.fromRGB(40, 40, 45),
    
    -- Dropdown colors
    DropdownButton = Color3.fromRGB(40, 40, 45),
    DropdownButtonHover = Color3.fromRGB(50, 50, 55),
    DropdownList = Color3.fromRGB(35, 35, 40),
    DropdownOption = Color3.fromRGB(40, 40, 45),
    DropdownOptionHover = Color3.fromRGB(50, 50, 55),
    
    -- Input colors
    InputBackground = Color3.fromRGB(30, 30, 35),
    InputBackgroundFocused = Color3.fromRGB(40, 40, 45),
    
    -- Toggle colors
    ToggleBackgroundOn = Color3.fromRGB(66, 133, 244),
    ToggleBackgroundOff = Color3.fromRGB(40, 40, 45),
    ToggleKnob = Color3.fromRGB(255, 255, 255),
    
    -- Slider colors
    SliderBackground = Color3.fromRGB(40, 40, 45),
    SliderFill = Color3.fromRGB(66, 133, 244),
    SliderKnob = Color3.fromRGB(255, 255, 255),
    
    -- Keybind colors
    KeybindButton = Color3.fromRGB(40, 40, 45),
    KeybindButtonHover = Color3.fromRGB(50, 50, 55),
    KeybindButtonActive = Color3.fromRGB(66, 133, 244),
    
    -- Tab colors
    TabInactive = Color3.fromRGB(30, 30, 35),
    TabActive = Color3.fromRGB(45, 45, 50),
    
    -- Text colors
    TextPrimary = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(190, 190, 195),
    TextDisabled = Color3.fromRGB(100, 100, 105),
    TextPlaceholder = Color3.fromRGB(100, 100, 105),
    
    -- Other
    Divider = Color3.fromRGB(45, 45, 50),
    Accent = Color3.fromRGB(66, 133, 244),
    Shadow = Color3.fromRGB(0, 0, 0)
}

-- Nord theme (cold blue theme)
Theme.Nord = {
    -- Main backgrounds
    Background = Color3.fromRGB(46, 52, 64),
    Header = Color3.fromRGB(59, 66, 82),
    SideBar = Color3.fromRGB(67, 76, 94),
    
    -- Component colors
    ComponentBackground = Color3.fromRGB(59, 66, 82),
    ComponentBackgroundHover = Color3.fromRGB(67, 76, 94),
    ComponentBackgroundPress = Color3.fromRGB(59, 66, 82),
    ComponentBackgroundDisabled = Color3.fromRGB(59, 66, 82),
    
    -- Button colors
    ButtonPrimary = Color3.fromRGB(94, 129, 172),
    ButtonSecondary = Color3.fromRGB(67, 76, 94),
    
    -- Dropdown colors
    DropdownButton = Color3.fromRGB(67, 76, 94),
    DropdownButtonHover = Color3.fromRGB(76, 86, 106),
    DropdownList = Color3.fromRGB(59, 66, 82),
    DropdownOption = Color3.fromRGB(67, 76, 94),
    DropdownOptionHover = Color3.fromRGB(76, 86, 106),
    
    -- Input colors
    InputBackground = Color3.fromRGB(67, 76, 94),
    InputBackgroundFocused = Color3.fromRGB(76, 86, 106),
    
    -- Toggle colors
    ToggleBackgroundOn = Color3.fromRGB(136, 192, 208),
    ToggleBackgroundOff = Color3.fromRGB(76, 86, 106),
    ToggleKnob = Color3.fromRGB(236, 239, 244),
    
    -- Slider colors
    SliderBackground = Color3.fromRGB(76, 86, 106),
    SliderFill = Color3.fromRGB(129, 161, 193),
    SliderKnob = Color3.fromRGB(236, 239, 244),
    
    -- Keybind colors
    KeybindButton = Color3.fromRGB(67, 76, 94),
    KeybindButtonHover = Color3.fromRGB(76, 86, 106),
    KeybindButtonActive = Color3.fromRGB(94, 129, 172),
    
    -- Tab colors
    TabInactive = Color3.fromRGB(59, 66, 82),
    TabActive = Color3.fromRGB(76, 86, 106),
    
    -- Text colors
    TextPrimary = Color3.fromRGB(236, 239, 244),
    TextSecondary = Color3.fromRGB(216, 222, 233),
    TextDisabled = Color3.fromRGB(97, 110, 136),
    TextPlaceholder = Color3.fromRGB(97, 110, 136),
    
    -- Other
    Divider = Color3.fromRGB(76, 86, 106),
    Accent = Color3.fromRGB(129, 161, 193),
    Shadow = Color3.fromRGB(30, 33, 41)
}

-- Dracula theme
Theme.Dracula = {
    -- Main backgrounds
    Background = Color3.fromRGB(40, 42, 54),
    Header = Color3.fromRGB(58, 60, 78),
    SideBar = Color3.fromRGB(68, 71, 90),
    
    -- Component colors
    ComponentBackground = Color3.fromRGB(58, 60, 78),
    ComponentBackgroundHover = Color3.fromRGB(68, 71, 90),
    ComponentBackgroundPress = Color3.fromRGB(58, 60, 78),
    ComponentBackgroundDisabled = Color3.fromRGB(58, 60, 78),
    
    -- Button colors
    ButtonPrimary = Color3.fromRGB(98, 114, 164),
    ButtonSecondary = Color3.fromRGB(68, 71, 90),
    
    -- Dropdown colors
    DropdownButton = Color3.fromRGB(68, 71, 90),
    DropdownButtonHover = Color3.fromRGB(78, 82, 104),
    DropdownList = Color3.fromRGB(58, 60, 78),
    DropdownOption = Color3.fromRGB(68, 71, 90),
    DropdownOptionHover = Color3.fromRGB(78, 82, 104),
    
    -- Input colors
    InputBackground = Color3.fromRGB(68, 71, 90),
    InputBackgroundFocused = Color3.fromRGB(78, 82, 104),
    
    -- Toggle colors
    ToggleBackgroundOn = Color3.fromRGB(80, 250, 123),
    ToggleBackgroundOff = Color3.fromRGB(78, 82, 104),
    ToggleKnob = Color3.fromRGB(248, 248, 242),
    
    -- Slider colors
    SliderBackground = Color3.fromRGB(78, 82, 104),
    SliderFill = Color3.fromRGB(255, 121, 198),
    SliderKnob = Color3.fromRGB(248, 248, 242),
    
    -- Keybind colors
    KeybindButton = Color3.fromRGB(68, 71, 90),
    KeybindButtonHover = Color3.fromRGB(78, 82, 104),
    KeybindButtonActive = Color3.fromRGB(98, 114, 164),
    
    -- Tab colors
    TabInactive = Color3.fromRGB(58, 60, 78),
    TabActive = Color3.fromRGB(78, 82, 104),
    
    -- Text colors
    TextPrimary = Color3.fromRGB(248, 248, 242),
    TextSecondary = Color3.fromRGB(226, 226, 221),
    TextDisabled = Color3.fromRGB(98, 114, 164),
    TextPlaceholder = Color3.fromRGB(98, 114, 164),
    
    -- Other
    Divider = Color3.fromRGB(78, 82, 104),
    Accent = Color3.fromRGB(255, 121, 198),
    Shadow = Color3.fromRGB(20, 21, 27)
}

-- Modern theme
Theme.Modern = {
    -- Main backgrounds
    Background = Color3.fromRGB(245, 245, 250),
    Header = Color3.fromRGB(255, 255, 255),
    SideBar = Color3.fromRGB(250, 250, 255),
    
    -- Component colors
    ComponentBackground = Color3.fromRGB(255, 255, 255),
    ComponentBackgroundHover = Color3.fromRGB(246, 246, 251),
    ComponentBackgroundPress = Color3.fromRGB(235, 235, 240),
    ComponentBackgroundDisabled = Color3.fromRGB(240, 240, 245),
    
    -- Button colors
    ButtonPrimary = Color3.fromRGB(113, 93, 255),
    ButtonSecondary = Color3.fromRGB(240, 240, 245),
    
    -- Dropdown colors
    DropdownButton = Color3.fromRGB(250, 250, 255),
    DropdownButtonHover = Color3.fromRGB(240, 240, 245),
    DropdownList = Color3.fromRGB(255, 255, 255),
    DropdownOption = Color3.fromRGB(250, 250, 255),
    DropdownOptionHover = Color3.fromRGB(240, 240, 245),
    
    -- Input colors
    InputBackground = Color3.fromRGB(245, 245, 250),
    InputBackgroundFocused = Color3.fromRGB(240, 240, 245),
    
    -- Toggle colors
    ToggleBackgroundOn = Color3.fromRGB(113, 93, 255),
    ToggleBackgroundOff = Color3.fromRGB(200, 200, 205),
    ToggleKnob = Color3.fromRGB(255, 255, 255),
    
    -- Slider colors
    SliderBackground = Color3.fromRGB(230, 230, 235),
    SliderFill = Color3.fromRGB(113, 93, 255),
    SliderKnob = Color3.fromRGB(255, 255, 255),
    
    -- Keybind colors
    KeybindButton = Color3.fromRGB(250, 250, 255),
    KeybindButtonHover = Color3.fromRGB(240, 240, 245),
    KeybindButtonActive = Color3.fromRGB(113, 93, 255),
    
    -- Tab colors
    TabInactive = Color3.fromRGB(240, 240, 245),
    TabActive = Color3.fromRGB(113, 93, 255),
    
    -- Text colors
    TextPrimary = Color3.fromRGB(30, 30, 35),
    TextSecondary = Color3.fromRGB(110, 110, 115),
    TextDisabled = Color3.fromRGB(180, 180, 185),
    TextPlaceholder = Color3.fromRGB(180, 180, 185),
    
    -- Other
    Divider = Color3.fromRGB(230, 230, 235),
    Accent = Color3.fromRGB(113, 93, 255),
    Shadow = Color3.fromRGB(200, 200, 205)
}

-- Create a custom theme based on a primary accent color
function Theme.CreateCustom(accentColor)
    if typeof(accentColor) ~= "Color3" then
        accentColor = Color3.fromRGB(66, 133, 244) -- Default blue accent if invalid
    end
    
    -- Start with the default theme
    local customTheme = {}
    for k, v in pairs(Theme.Default) do
        customTheme[k] = v
    end
    
    -- Update accent color and related colors
    customTheme.Accent = accentColor
    customTheme.ButtonPrimary = accentColor
    customTheme.ToggleBackgroundOn = accentColor
    customTheme.SliderFill = accentColor
    customTheme.KeybindButtonActive = accentColor
    
    return customTheme
end

-- Get a theme by name
function Theme.GetTheme(themeName)
    themeName = themeName or "Default"
    
    if Theme[themeName] then
        return Theme[themeName]
    else
        return Theme.Default
    end
end

return Theme
