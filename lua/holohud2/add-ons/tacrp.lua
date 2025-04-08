---
--- TacRP
--- https://steamcommunity.com/sharedfiles/filedetails/?id=2588031232
---

if SERVER then return end

if not TacRP then return end

local FIREMODE_SAFE     = HOLOHUD2.FIREMODE_SAFE
local FIREMODE_SEMI     = HOLOHUD2.FIREMODE_SEMI
local FIREMODE_AUTO     = HOLOHUD2.FIREMODE_AUTO
local FIREMODE_2BURST   = HOLOHUD2.FIREMODE_2BURST
local FIREMODE_3BURST   = HOLOHUD2.FIREMODE_3BURST

---
--- Fire mode
---
HOLOHUD2.hook.Add( "GetWeaponFiremode", "tacrp", function( weapon )

    if not weapon.ArcticTacRP then return end

    if weapon:GetSafe() then return FIREMODE_SAFE end

    if weapon:GetFiremodeAmount() <= 0 then return end

    local firemode = weapon:GetCurrentFiremode()

    if firemode == 1 then

        return FIREMODE_SEMI

    elseif firemode >= 2 then

        return FIREMODE_AUTO

    elseif firemode == -2 then

        return FIREMODE_2BURST

    elseif firemode < 0 then

        return FIREMODE_3BURST

    end

end)

---
--- Grenade ammo icons
---

HOLOHUD2.ammo.Register(
    "ti_flashbang",
    surface.GetTextureID( "tacrp/grenades/flashbang" ),
    32, 32,
    32, 32,
    {
        icon_scale = 1,
        tray_angle_x = 0,
        tray_margin_x = 0.75,
        tray_angle_y = -90,
        tray_margin_y = 0.75
    }
)

HOLOHUD2.ammo.Register(
    "ti_smoke",
    surface.GetTextureID( "tacrp/grenades/smoke" ),
    32, 32,
    32, 32,
    {
        icon_scale = 1,
        tray_angle_x = 0,
        tray_margin_x = 0.75,
        tray_angle_y = -90,
        tray_margin_y = 0.75
    }
)

HOLOHUD2.ammo.Register(
    "ti_gas",
    surface.GetTextureID( "tacrp/grenades/gas" ),
    32, 32,
    32, 32,
    {
        icon_scale = 1,
        tray_angle_x = 0,
        tray_margin_x = 0.75,
        tray_angle_y = -90,
        tray_margin_y = 0.75
    }
)

HOLOHUD2.ammo.Register(
    "ti_thermite",
    surface.GetTextureID( "tacrp/grenades/thermite" ),
    32, 32,
    32, 32,
    {
        icon_scale = 1,
        tray_angle_x = 0,
        tray_margin_x = 0.75,
        tray_angle_y = -90,
        tray_margin_y = 0.75
    }
)

HOLOHUD2.ammo.Register(
    "ti_c4",
    surface.GetTextureID( "tacrp/grenades/c4" ),
    32, 32,
    32, 32,
    {
        icon_scale = 1,
        tray_angle_x = 0,
        tray_margin_x = 0.75,
        tray_angle_y = -90,
        tray_margin_y = 0.75
    }
)

HOLOHUD2.ammo.Register(
    "ti_nuke",
    surface.GetTextureID( "tacrp/grenades/nuke" ),
    32, 32,
    32, 32,
    {
        icon_scale = 1,
        tray_angle_x = 0,
        tray_margin_x = 0.75,
        tray_angle_y = -90,
        tray_margin_y = 0.75
    }
)

HOLOHUD2.ammo.Register(
    "ti_charge",
    surface.GetTextureID( "tacrp/grenades/breach" ),
    32, 32,
    32, 32,
    {
        icon_scale = 1,
        tray_angle_x = 0,
        tray_margin_x = 0.75,
        tray_angle_y = -90,
        tray_margin_y = 0.75
    }
)

HOLOHUD2.ammo.Register(
    "ti_heal",
    surface.GetTextureID( "tacrp/grenades/heal" ),
    32, 32,
    32, 32,
    {
        icon_scale = 1,
        tray_angle_x = 0,
        tray_margin_x = 0.75,
        tray_angle_y = -90,
        tray_margin_y = 0.75
    }
)

---
--- Expanded ammo type icons
---

HOLOHUD2.ammo.Register(
    "ti_pistol_light",
    surface.GetTextureID( "holohud2/ammo/pistol" ),
    32, 32,
    27, 10,
    {
        tray_scale_x = .85,
        tray_margin_x = .7,
        tray_margin_y = .7
    }
)

HOLOHUD2.ammo.Register(
    "ti_pistol_heavy",
    surface.GetTextureID( "holohud2/ammo/pistol" ),
    32, 32,
    27, 10,
    {
        tray_scale_x = .85,
        tray_margin_x = .7,
        tray_margin_y = .7
    }
)

HOLOHUD2.ammo.Register(
    "ti_pdw",
    surface.GetTextureID( "holohud2/ammo/smg1" ),
    64, 32,
    44, 13,
    {
        tray_scale_x = .9,
        tray_margin_x = .5,
        tray_margin_y = .5
    }
)

HOLOHUD2.ammo.Register(
    "ti_rifle",
    surface.GetTextureID( "holohud2/ammo/ar2" ),
    64, 32,
    50, 11,
    {
        tray_margin_x = .5,
        tray_margin_y = .5
    }
)

HOLOHUD2.ammo.Register(
    "ti_sniper",
    surface.GetTextureID( "holohud2/ammo/357" ),
    64, 32,
    36, 13,
    {
        tray_scale_x = .9,
        tray_margin_x = .6,
        tray_margin_y = .6
    }
)