---
--- Ammunition icons.
---

HOLOHUD2.ammo = HOLOHUD2.ammo or {}

local DEFAULT_AMMOTYPE  = "AR2"

HOLOHUD2.ammo._icons = HOLOHUD2.ammo._icons or {}
local icons = HOLOHUD2.ammo._icons

--- Registers a texture as an ammunition icon.
--- @param ammotype number|string ammunition type ID (or name)
--- @param texture number|string texture (or ammunition name to copy icon from)
--- @param filew number texture width
--- @param fileh number texture height
--- @param w number|nil icon width
--- @param h number|nil icon height
--- @param data table rendering specific properties
function HOLOHUD2.ammo.Register( ammotype, texture, filew, fileh, w, h, data )

    local ammoName = ammotype
    if isnumber(ammotype) then
        if ammotype == -1 then
            return
        else
            ammoName = game.GetAmmoName( ammotype )
        end
    end

    data = data or {}

    if isstring( texture ) then

        icons[ ammoName ] = icons[ texture ]
        return

    end

    icons[ ammoName ] = {
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
--- @param ammotype number|string ammunition type
--- @return table icon
function HOLOHUD2.ammo.Get( ammotype )

    if isnumber( ammotype ) then
        if ammotype == -1 then return icons[ DEFAULT_AMMOTYPE ] end

        ammotype = game.GetAmmoName( ammotype )
    end

    return icons[ ammotype ] or icons[ DEFAULT_AMMOTYPE ]

end

--- Returns whether the given ammunition type has an icon.
--- @param ammotype number ammunition type
--- @return boolean found has icon
function HOLOHUD2.ammo.Has( ammotype )

    return icons[ ammotype ] ~= nil

end