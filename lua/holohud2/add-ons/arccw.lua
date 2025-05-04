---
--- ArcCW
--- https://steamcommunity.com/workshop/filedetails/?id=2131057232
---

if SERVER then return end

if not ArcCW then return end

local IsValid = IsValid
local LocalPlayer = LocalPlayer

local FIREMODE_SAFE     = HOLOHUD2.FIREMODE_SAFE
local FIREMODE_SEMI     = HOLOHUD2.FIREMODE_SEMI
local FIREMODE_AUTO     = HOLOHUD2.FIREMODE_AUTO
local FIREMODE_2BURST   = HOLOHUD2.FIREMODE_2BURST
local FIREMODE_3BURST   = HOLOHUD2.FIREMODE_3BURST

---
--- Fire mode
---
HOLOHUD2.hook.Add( "GetWeaponFiremode", "arccw", function( weapon )

    if not weapon.ArcCW then return end
    
    local firemode = weapon:GetCurrentFiremode().Mode

    if firemode == 0 then return FIREMODE_SAFE end

    if #weapon.Firemodes <= 2 then return end
        
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
--- Inspecting
---
HOLOHUD2.hook.Add( "IsInspectingWeapon", "arccw", function( weapon )

    if not weapon.ArcCW then return end
    
    return weapon:GetState() == ArcCW.STATE_CUSTOMIZE

end)

---
--- ADS
---
HOLOHUD2.hook.Add( "ForceQuickInfoFadeOut", "arccw", function()

    local weapon = LocalPlayer():GetActiveWeapon()

    if not IsValid( weapon ) or not weapon.ArcCW then return end

    return weapon.Sighted

end)