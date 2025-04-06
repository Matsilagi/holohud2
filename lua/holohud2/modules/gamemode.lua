---
--- Hardcoded overrides. Useful when adding compatibility with a game mode.
---

HOLOHUD2.gamemode = {}

local default   = {}
local settings  = {}

HOLOHUD2.settings.Register( default, HOLOHUD2.SETTINGS_LUADEFAULT )
HOLOHUD2.settings.Register( settings, HOLOHUD2.SETTINGS_LUA )

--- Sets a single parameter's default.
--- @param element string
--- @param parameter string
--- @param value any
function HOLOHUD2.gamemode.SetDefaultValue( element, parameter, value )

    if not default[ element ] then default[ element ] = {} end
    default[ element ][ parameter ] = value
    HOLOHUD2.settings.Merge()

end

--- Sets the default values of an element.
--- @param element string
--- @param values table
--- @param force boolean|nil
function HOLOHUD2.gamemode.SetElementDefaults( element, values, force )

    if force then

        default[ element ] = values

    else

        if not default[ element ] then default[ element ] = {} end

        table.Merge( default[ element ], values, true )

    end
    
    HOLOHUD2.settings.Merge()

end

--- Submits a table as the default settings.
--- @param values table
--- @param force boolean|nil
function HOLOHUD2.gamemode.SubmitDefaults( values, force )

    if force then

        table.CopyFromTo( values, default )

    else

        table.Merge( default, values, true )

    end

    HOLOHUD2.settings.Merge()

end

--- Clears the current default settings.
function HOLOHUD2.gamemode.ClearDefaults()

    table.Empty( default )
    HOLOHUD2.settings.Merge()

end

--- Sets a single parameter's override value.
--- @param element string
--- @param parameter string
--- @param value any
function HOLOHUD2.gamemode.SetParameterOverride( element, parameter, value )

    if not settings[ element ] then settings[ element ] = {} end
    settings[ element ][ parameter ] = value
    HOLOHUD2.settings.Merge()

end

--- Sets the values override on an element.
--- @param element string
--- @param values table
--- @param force boolean|nil
function HOLOHUD2.gamemode.SetElementOverride( element, values, force )

    if force then

        settings[ element ] = values

    else

        if not settings[ element ] then settings[ element ] = {} end

        table.Merge( settings[ element ], values )

    end

    HOLOHUD2.settings.Merge()

end

--- Submits a table as the settings override.
--- @param values table
--- @param force boolean|nil
function HOLOHUD2.gamemode.SubmitOverride( values, force )

    if force then

        table.CopyFromTo( values, settings )

    else

        table.Merge( settings, values )

    end

    HOLOHUD2.settings.Merge()

end

--- Clears the current settings override.
function HOLOHUD2.gamemode.ClearOverride()

    table.Empty( default )
    HOLOHUD2.settings.Merge()

end