---
--- TFA Base
--- https://steamcommunity.com/sharedfiles/filedetails/?id=2840031720
---

if SERVER then return end

if not TFA then return end

local IsValid = IsValid
local LocalPlayer = LocalPlayer

local FIREMODE_SAFE     = HOLOHUD2.FIREMODE_SAFE
local FIREMODE_SEMI     = HOLOHUD2.FIREMODE_SEMI
local FIREMODE_AUTO     = HOLOHUD2.FIREMODE_AUTO
local FIREMODE_3BURST   = HOLOHUD2.FIREMODE_3BURST
local FIREMODE_2BURST   = HOLOHUD2.FIREMODE_2BURST

local FIREMODE_TRANSLATE = {
    [ "auto" ] = FIREMODE_AUTO,
    [ "automatic" ] = FIREMODE_AUTO,
    [ "semi" ] = FIREMODE_SEMI,
    [ "single" ] = FIREMODE_SEMI,
    [ "2burst" ] = FIREMODE_2BURST,
    [ "3burst" ] = FIREMODE_3BURST
}

---
--- Alternate fire
---
HOLOHUD2.hook.Add( "CanZoom", "tfa", function()

    local weapon = LocalPlayer():GetActiveWeapon()

    if not IsValid( weapon ) or not weapon.IsTFAWeapon or not weapon.AltAttack then return end

    return false

end)

---
--- Fire mode
---
HOLOHUD2.hook.Add( "GetWeaponFiremode", "tfa", function( weapon )

    if not weapon.IsTFAWeapon then return end

    local firemodes = weapon:GetStat( "FireModes" )

    if weapon:IsSafety() then return FIREMODE_SAFE end
    
    if #firemodes <= 2 then return end

	local firemode = string.lower( firemodes[ weapon:GetFireMode() ] )
    local bpos = string.find( firemode, "burst" )
    
    if bpos then
        
        local btype = string.sub( firemode, 1, bpos - 1 )

        if btype and btype == "2" then
        
            return FIREMODE_2BURST

        else

            return FIREMODE_3BURST

        end

    else

        return FIREMODE_TRANSLATE[ firemode ]

    end


end)

---
--- Inspecting
---
HOLOHUD2.hook.Add( "IsInspectingWeapon", "tfa", function( weapon )

    if not weapon.IsTFAWeapon then return end
    
    return weapon.Inspecting or weapon:GetStatus() == TFA.GetStatus( "fidget" )

end)

---
--- ADS
---
HOLOHUD2.hook.Add( "ForceQuickInfoFadeOut", "tfa", function()

    local weapon = LocalPlayer():GetActiveWeapon()

    if not IsValid( weapon ) or not weapon.IsTFAWeapon then return end

    return weapon:GetIronSightsRaw()

end)