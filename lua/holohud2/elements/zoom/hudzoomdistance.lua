local BaseClass = HOLOHUD2.component.Get( "HudZoomDisplay" )

local COMPONENT = {}

function COMPONENT:ApplySettings( settings, fonts )

    self:SetColor( settings.distance_color )
    self:SetColor2( settings.distance_color2 )

    local num = self.Number
    num:SetVisible( settings.distancenum )
    num:SetPos( settings.distancenum_pos.x, settings.distancenum_pos.y )
    num:SetFont( fonts.distancenum_font )
    num:SetRenderMode( settings.distancenum_rendermode )
    num:SetBackground( settings.distancenum_background )
    num:SetAlign( settings.distancenum_align )
    num:SetDigits( settings.distancenum_digits )

    local unit = self.Unit
    unit:SetVisible( settings.distanceunit )
    unit:SetPos( settings.distanceunit_pos.x, settings.distanceunit_pos.y )
    unit:SetFont( fonts.distanceunit_font )
    unit:SetAlign( settings.distanceunit_align )
    unit:SetText( settings.distance_unit == HOLOHUD2.DISTANCE_METRIC and HOLOHUD2.UNIT_METRIC or ( settings.distance_unit == HOLOHUD2.DISTANCE_IMPERIAL and HOLOHUD2.UNIT_IMPERIAL ) or HOLOHUD2.UNIT_HAMMER )
    self:SetDrawUnitOnBackground( settings.distanceunit_on_background )

    local text = self.Text
    text:SetVisible( settings.distancetext )
    text:SetPos( settings.distancetext_pos.x, settings.distancetext_pos.y )
    text:SetFont( fonts.distancetext_font )
    text:SetText( settings.distancetext_text )
    text:SetAlign( settings.distancetext_align )
    self:SetDrawTextOnBackground( settings.distancetext_on_background )
    
    self:InvalidateLayout()

end

HOLOHUD2.component.Register( "HudZoomDistance", COMPONENT, "HudZoomDisplay" )