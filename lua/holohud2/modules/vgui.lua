
HOLOHUD2.vgui = {}

---
--- Define control classes for parameter types.
---
local controls = {}

--- Assigns a derma class to a parameter type.
--- @param type HOLOHUD2.PARAM parameter type
--- @param control string derma control class
function HOLOHUD2.vgui.DefineParameterControl( type, control )

    controls[ type ] = control

end

--- Returns the assigned derma control class for this parameter type.
--- @param type string
--- @return string class
function HOLOHUD2.vgui.GetParameterControl( type )

    return controls[ type ] or "HOLOHUD2_DParameter"

end

---
--- Populate the options menu.
---
local options

--- Stores a panel's reference as the active options menu container.
function HOLOHUD2.vgui.SetOptionsPanel( panel )

    options = panel

end

--- Adds the given controls to the options menu.
--- @param func function|Panel either a function to populate the category or a single panel
--- @param category string|nil
function HOLOHUD2.vgui.AddOptionControls( func, category )

    if isfunction( func ) then

        func( options:FetchCategory( category ), options )

    else

        options:AddToCategory( func, category )

    end

end