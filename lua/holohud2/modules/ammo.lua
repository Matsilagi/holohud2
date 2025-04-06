---
--- Ammunition icons.
---

HOLOHUD2.ammo = {}

local DEFAULT_AMMOTYPE  = 1

local icons = {}

--- Registers a texture as an ammunition icon.
--- @param ammotype number|string ammunition type ID (or name)
--- @param texture number|string texture (or ammunition type to copy icon from)
--- @param filew number texture width
--- @param fileh number texture height
--- @param w number|nil icon width
--- @param h number|nil icon height
--- @param data table rendering specific properties
function HOLOHUD2.ammo.Register( ammotype, texture, filew, fileh, w, h, data )

    ammotype = isstring( ammotype ) and game.GetAmmoID( ammotype ) or ammotype
    data = data or {}

    if isstring( texture ) then
        
        icons[ ammotype ] = icons[ texture ]
        return

    end

    icons[ ammotype ] = {
        texture         = texture,
        filew           = filew,
        fileh           = fileh,
        w               = w or filew,
        h               = h or fileh,
        icon_scale      = data.icon_scale or 1,
        tray_scale_x    = data.tray_scale_x or 1,
        tray_angle_x    = data.tray_angle_x or -50,
        tray_margin_x   = math.max( data.tray_margin_x or 1, .01 ), -- WARNING: the life of your GMod depends on neither this nor tray_margin_y being 0
        tray_scale_y    = data.tray_scale_y or 1,
        tray_angle_y    = data.tray_angle_y or -50,
        tray_margin_y   = math.max( data.tray_margin_y or 1, .01 )
    }

end

--- Returns a registered ammo type's icon.
--- @param ammotype number ammunition type
--- @return table icon
function HOLOHUD2.ammo.Get( ammotype )

    if not icons[ ammotype ] then return icons[ DEFAULT_AMMOTYPE ] end

    return icons[ ammotype ]

end

--- Returns whether the given ammunition type has an icon.
--- @param ammotype number ammunition type
--- @return boolean found has icon
function HOLOHUD2.ammo.Has( ammotype )

    return icons[ ammotype ] ~= nil

end