--- 
--- Death notice inflictor icons.
--- 

HOLOHUD2.killicon = {}

local DEFAULT_KILLICON  = "generic"

local icons = {}

--- Assigns an entity to a kill icon.
--- @param class string entity class
--- @param texture number|string texture (or item class to copy icon from)
--- @param filew number texture width
--- @param fileh number texture height
--- @param x number|nil left corner
--- @param y number|nil top corner
--- @param w number|nil icon width
--- @param h number|nil icon height
function HOLOHUD2.killicon.Register( class, texture, filew, fileh, x, y, w, h )

    if isstring( texture ) then
        
        icons[ class ] = icons[ texture ]
        return

    end

    icons[ class ] = {
        texture = texture,
        filew   = filew,
        fileh   = fileh,
        x       = x or 0,
        y       = y or 0,
        w       = w or filew,
        h       = h or fileh
    }

end

--- Returns a registered kill icon.
--- @param class string
--- @return table icon
function HOLOHUD2.killicon.Get( class )

    if not icons[ class ] then return icons[ DEFAULT_KILLICON ] end
    return icons[ class ]

end

--- Returns whether the given entity has a killicon.
--- @param class string
--- @return boolean found has icon
function HOLOHUD2.killicon.Has(class)

    return icons[ class ] ~= nil

end

--- Returns the fallback killicon.
--- @return table fallback
function HOLOHUD2.killicon.Fallback()

    return icons[ DEFAULT_KILLICON ]

end