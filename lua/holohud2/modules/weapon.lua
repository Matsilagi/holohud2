---
--- Weapon icons
---

HOLOHUD2.weapon = {}

local NULL_WEAPONCLASS = "null"

local icons = {}

--- Registers a texture as a weapon icon.
--- @param weapon string weapon class
--- @param texture number|string texture (or weapon class to copy icon from)
--- @param w number
--- @param h number
--- @param scale number weapon selection render scale
--- @return table icon
function HOLOHUD2.weapon.Register( weapon, texture, w, h, scale )

    if isstring( texture ) then

        icons[ weapon ] = icons[ texture ]

        return icons[ weapon ]

    end

    icons[ weapon ] = {
        texture = texture,
        w       = w,
        h       = h,
        scale   = scale or 1
    }

    return icons[ weapon ]

end

--- Returns whether the given weapon class has a registered icon.
--- @param weapon string weapon class
--- @return boolean found has icon
local function has( weapon )

    return icons[ weapon ] ~= nil

end
HOLOHUD2.weapon.Has = has

--- Returns the null weapon icon.
--- @return table fallback
local function get_null()

    return icons[ NULL_WEAPONCLASS ]

end
HOLOHUD2.weapon.Empty = get_null

--- Returns a registered weapon class icon.
--- @param weapon string weapon class
--- @return table icon
function HOLOHUD2.weapon.Get( weapon )

    if not has( weapon ) then return get_null() end

    return icons[ weapon ]

end

HOLOHUD2.weapon.Register( NULL_WEAPONCLASS, surface.GetTextureID( "holohud2/weapons/null" ), 128, 128, .4 )