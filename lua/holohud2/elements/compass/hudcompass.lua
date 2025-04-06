local StartAlphaMultiplier = HOLOHUD2.render.StartAlphaMultiplier
local EndAlphaMultiplier = HOLOHUD2.render.EndAlphaMultiplier
local GetMinimumGlow = HOLOHUD2.render.GetMinimumGlow

local BaseClass = HOLOHUD2.component.Get( "Compass" )

local COMPONENT = {}

function COMPONENT:PaintScanlines( x, y )

    StartAlphaMultiplier( GetMinimumGlow() )
    BaseClass.Paint( self, x, y )
    EndAlphaMultiplier()

end

function COMPONENT:ApplySettings( settings, fonts )

    self:SetPos( settings.padding, settings.padding )
    self:SetSize( settings.size.x - settings.padding * 2, settings.size.y - settings.padding * 2 )
    self:SetMode( settings.mode )
    self:SetEightWind( settings.eightwind )
    self:SetThreeSixty( settings.threesixty )
    self:SetCompassSize( settings.scale )
    self:SetColor( settings.color )
    self:SetColor2( settings.color2 )
    self:SetFont( fonts.font )
    self:SetDrawOnBackground( settings.on_background )
    self:SetGraduation( settings.graduation )
    self:SetGraduationSegments( settings.graduation_segments )
    self:SetGraduationSize( settings.graduation_size )
    self:SetGraduationFont( fonts.graduation_font )
    self:SetDrawGraduationOnBackground( settings.graduation_on_background )
    self:SetDrawAxis( settings.axis )
    self:SetAxisColor1( settings.axis_colorx )
    self:SetAxisColor2( settings.axis_colory )
    self:SetAxisFont( fonts.axis_font )
    self:SetOffset( settings.northzero and 0 or 1 )
    
    self:InvalidateLayout()

end

HOLOHUD2.component.Register( "HudCompass", COMPONENT, "Compass" )