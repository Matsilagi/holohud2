---
--- Damage type icons.
---

HOLOHUD2.hazard = {}

local icons = {}

--- Assigns a damage type to a hazard icon.
--- @param dmgtype DMG damage type
--- @param texture number|DMG texture (or damage type to copy icon from)
--- @param filew number file width (or if we are copying another damage type's icon)
--- @param fileh number file height
--- @param x number|nil horizontal offset
--- @param y number|nil vertical offset
--- @param w number|nil icon width
--- @param h number|nil icon height
function HOLOHUD2.hazard.Register( dmgtype, texture, filew, fileh, x, y, w, h )

    if filew and isbool( filew ) then
        
        icons[ dmgtype ] = icons[ texture ]
        return

    end

    icons[ dmgtype ] = {
        texture = texture,
        filew   = filew,
        fileh   = fileh,
        x       = x or 0,
        y       = y or 0,
        w       = w or filew,
        h       = h or fileh
    }

end

--- Returns a registered hazard icon.
--- @param dmgtype DMG damage type
--- @return table icon
function HOLOHUD2.hazard.Get( dmgtype )

    return icons[ dmgtype ]

end

--- Reads a damage object and returns the supported damage types.
--- @param dmgtype DMG damage type(s)
--- @return table supported damage types
function HOLOHUD2.hazard.Read( damage )

    local list = {}

    for dmgtype, _ in pairs( icons ) do

        if bit.band( damage, dmgtype ) == 0 then continue end

        list[ dmgtype ] = true -- NOTE: do we really care about order? this makes it easy to process later

    end

    return list

end