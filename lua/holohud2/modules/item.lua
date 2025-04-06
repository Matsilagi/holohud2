---
--- Item class icons.
---

HOLOHUD2.item = {}

local icons = {}

--- Assigns an item class to an icon.
--- @param item string
--- @param texture number|string texture (or item class to copy icon from)
--- @param filew number texture width
--- @param fileh number texture height
--- @param x number|nil left corner
--- @param y number|nil top corner
--- @param w number|nil icon width
--- @param h number|nil icon height
--- @param color_func function|nil icon color override function
function HOLOHUD2.item.Register( item, texture, filew, fileh, x, y, w, h, color_func )

    -- mark item as ignored
    if texture == NULL then
        
        icons[ item ] = NULL
        return

    end

    -- copy icon from another item class
    if isstring( texture ) then
        
        icons[ item ] = icons[ texture ]
        return

    end

    icons[ item ] = {
        texture = texture,
        filew   = filew,
        fileh   = fileh,
        x       = x or 0,
        y       = y or 0,
        w       = w or filew,
        h       = h or fileh,
        color   = color_func
    }

end

--- Returns a registered item icon.
--- @param item string
--- @return table icon
function HOLOHUD2.item.Get( item )

    return icons[ item ]

end

--- Returns whether the given item has an icon.
--- @param item string
--- @return boolean found has icon
function HOLOHUD2.item.Has( item )

    return icons[ item ] ~= nil

end