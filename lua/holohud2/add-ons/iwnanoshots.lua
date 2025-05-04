---
--- CoD:IW Nano Shot
--- https://steamcommunity.com/sharedfiles/filedetails/?id=3210905644
---

if SERVER then return end

if not ConVarExists( "iw_nanoshots_hud" ) then return end

local LocalPlayer = LocalPlayer
local IsVisible = HOLOHUD2.IsVisible
local element_stims = HOLOHUD2.element.Get( "stims" )

local nanoshots = 0

HOLOHUD2.hook.Add( "ShouldDrawStims", "iwnanoshots", function()

    nanoshots = LocalPlayer():GetNanoShots()
    return nanoshots > 0

end)

HOLOHUD2.hook.Add( "GetStims", "iwnanoshots", function()

    return nanoshots

end)

hook.Add( "HUDShouldDraw", "holohud2_iwnanoshots", function( name )
  
    if name ~= "IWNanoShots" then return end
    if not IsVisible() then return end
    if not element_stims:IsVisible() then return end
    
    return false
  
end)

HOLOHUD2.item.Register( "item_iw7_equipment_nanoshot", surface.GetTextureID( "holohud2/stims" ), 64, 64 )