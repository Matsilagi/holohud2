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

    if not weapon.Firemodes or #weapon.Firemodes <= 0 then return end

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