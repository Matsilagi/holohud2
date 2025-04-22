---
--- Modern Warfare Base
--- https://steamcommunity.com/sharedfiles/filedetails/?id=2459720887
---

if SERVER then return end

if not MWBLTL then return end

local FIREMODE_SAFE     = HOLOHUD2.FIREMODE_SAFE
local FIREMODE_SEMI     = HOLOHUD2.FIREMODE_SEMI
local FIREMODE_AUTO     = HOLOHUD2.FIREMODE_AUTO
local FIREMODE_3BURST   = HOLOHUD2.FIREMODE_3BURST
local FIREMODE_2BURST   = HOLOHUD2.FIREMODE_2BURST

---
--- Fire mode
---
HOLOHUD2.hook.Add( "GetWeaponFiremode", "mwbase", function( weapon )

    if not weapons.IsBasedOn( weapon:GetClass(), "mg_base" ) then return end

    if weapon:HasFlag( "Holstering" ) then return FIREMODE_SAFE end

    if not weapon.Firemodes or #weapon.Firemodes <= 1 then return end

    local firemode = weapon.Firemodes[ weapon:GetFiremode() ]

    if not firemode or not firemode.Name then return end

    firemode = string.lower( firemode.Name )

    if string.find( firemode, "semi" ) or string.find( firemode, "single" ) then

        return FIREMODE_SEMI

    elseif string.find( firemode, "burst" ) then

        if string.find( firemode, "2" ) then return FIREMODE_2BURST end

        return FIREMODE_3BURST

    else

        return FIREMODE_AUTO

    end

end)

---
--- ADS
---
HOLOHUD2.hook.Add( "ForceQuickInfoFadeOut", "arccw", function()

    local weapon = LocalPlayer():GetActiveWeapon()

    if not IsValid( weapon ) or not weapons.IsBasedOn( weapon:GetClass(), "mg_base" ) then return end

    return weapon:HasFlag( "Aiming" )

end)