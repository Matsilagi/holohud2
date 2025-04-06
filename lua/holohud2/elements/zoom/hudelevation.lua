local StartAlphaMultiplier = HOLOHUD2.render.StartAlphaMultiplier
local EndAlphaMultiplier = HOLOHUD2.render.EndAlphaMultiplier
local GetMinimumGlow = HOLOHUD2.render.GetMinimumGlow

local COMPONENT = {}

function COMPONENT:PaintScanlines( x, y )

    StartAlphaMultiplier( GetMinimumGlow() )
    self:Paint( x, y )
    EndAlphaMultiplier()
    
end

function COMPONENT:ApplySettings( settings, fonts )

    self:SetPos( settings.elevation_padding, settings.elevation_padding )
    self:SetSize( settings.elevation_size.x - settings.elevation_padding * 2, settings.elevation_size.y - settings.elevation_padding * 2 )
    self:SetCompassSize( settings.elevation_scale )
    self:SetFont( fonts.elevation_font )
    self:SetGap( settings.elevation_gap )
    self:SetColor( settings.elevation_color )
    self:SetColor2( settings.elevation_color2 )
    
    self:InvalidateLayout()

end

HOLOHUD2.component.Register( "HudElevation", COMPONENT, "Elevation" )