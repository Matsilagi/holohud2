
HOLOHUD2.scale = {}

local round = CreateClientConVar( "holohud2_roundscale", 0, true, false, "Whether the scale should get rounded.", 0, 1 )

---
--- The original HUD was designed on a 1280 x 800 resolution.
--- It was going to be designed for 640 x 480 like Half-Life 2, but proved to be too limiting.
---
HOLOHUD2.SCREEN_WIDTH   = 800
HOLOHUD2.SCREEN_HEIGHT  = 600

local scale = 1 -- cached HUD scale

--- Returns the current HUD scale.
--- @return number scale
function HOLOHUD2.scale.Get()
    
    return scale

end

--- Sets a new HUD scale based on the given screen dimensions.
--- @param w number
--- @param h number
local function refresh( w, h )

    local old = scale
    
    scale = w < h and w / HOLOHUD2.SCREEN_WIDTH or h / HOLOHUD2.SCREEN_HEIGHT

    HOLOHUD2.hook.Call( "OnScaleChanged", old, scale )

end
HOLOHUD2.scale.Refresh = refresh

---
--- Initialize scale according to current screen dimensions.
---
refresh( ScrW(), ScrH() )

---
--- Rescale HUD on screen size change.
---
hook.Add( "OnScreenSizeChanged", "holohud2", function( _, _, w, h )
    
    refresh( w, h )

end )