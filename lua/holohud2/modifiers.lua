--- Changes the font's properties.
--- @param value table
--- @param mod table
--- @return table
local function font_props( self, value, mod )

    local italic = value.italic

    if mod.italic ~= nil then

        italic = mod.italic

    end

    return { font = mod.font, size = value.size + ( mod.size or 0 ), weight = mod.weight or value.weight, italic = italic }

end

--- Applies an offset.
--- @param value table
--- @param mod table
--- @return table
local function offset( self, value, mod )

    if isnumber( value ) then

        return value + mod.y

    end

    return { x = value.x + mod.x, y = value.y + mod.y }

end

HOLOHUD2.modifier.Register( "color" )
HOLOHUD2.modifier.Register( "number_font", font_props )
HOLOHUD2.modifier.Register( "number_offset", offset )
HOLOHUD2.modifier.Register( "number2_font", font_props )
HOLOHUD2.modifier.Register( "number2_offset", offset )
HOLOHUD2.modifier.Register( "number3_font", font_props )
HOLOHUD2.modifier.Register( "number3_offset", offset )
HOLOHUD2.modifier.Register( "text_font", font_props )
HOLOHUD2.modifier.Register( "text_offset", offset )
HOLOHUD2.modifier.Register( "text2_font", font_props )
HOLOHUD2.modifier.Register( "text2_offset", offset )
HOLOHUD2.modifier.Register( "number_rendermode" )
HOLOHUD2.modifier.Register( "number_background" )
HOLOHUD2.modifier.Register( "background" )
HOLOHUD2.modifier.Register( "background_color" )
HOLOHUD2.modifier.Register( "panel_animation" )
HOLOHUD2.modifier.Register( "autohide" )


--- Replaces all secondary colours with a single one.
--- @param self table unused
--- @param mod table
--- @return table|nil
HOLOHUD2.modifier.Register( "color2", function( self, value, mod )

    if IsColor( value ) then

        return mod

    end

    return { colors = { [ 0 ] = mod }, fraction = true, gradual = false }

end)
