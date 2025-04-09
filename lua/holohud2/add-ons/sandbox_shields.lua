---
--- Sandbox Shields
--- https://steamcommunity.com/sharedfiles/filedetails/?id=2808893375
---

if not Draconic then return end

if SERVER then return end

local LocalPlayer = LocalPlayer

local shields, max_shields = 0, 100

HOLOHUD2.hook.Add( "ShouldDrawShields", "sandbox_shields", function()

    if not LocalPlayer():GetNWBool( "DRC_Shielded" ) then return end

    shields, max_shields = DRC:GetShield( LocalPlayer() )

    return true

end)

HOLOHUD2.hook.Add( "GetShields", "sandbox_shields", function()

    return shields

end)

HOLOHUD2.hook.Add( "GetMaxShields", "sandbox_shields", function()

    return max_shields

end)