---
--- MW Stims
--- https://steamcommunity.com/sharedfiles/filedetails/?id=3161191076
---

if SERVER then return end
if not _G.UseStim then return end

local LocalPlayer = LocalPlayer

local stims = 0

HOLOHUD2.hook.Add( "ShouldDrawStims", "mwstims", function()

    stims = LocalPlayer():GetStims()
    return stims > 0

end)

HOLOHUD2.hook.Add( "GetStims", "mwstims", function()

    return stims

end)

HOLOHUD2.item.Register( "mw_equipment_stim", surface.GetTextureID( "holohud2/stims" ), 64, 64 )