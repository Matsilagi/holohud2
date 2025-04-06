local BaseClass = HOLOHUD2.component.Get( "HudZoomDisplay" )

local COMPONENT = {}

function COMPONENT:Init()

    BaseClass.Init( self )

    self.Unit:SetText( "X" )

end

function COMPONENT:InvalidateLayout()

    BaseClass.InvalidateLayout( self )
    self.Unit:InvalidateLayout()

end

function COMPONENT:ApplySettings( settings, fonts )

    self:SetColor( settings.zoom_color )
    self:SetColor2( settings.zoom_color2 )

    local num = self.Number
    num:SetVisible( settings.zoomnum )
    num:SetPos( settings.zoomnum_pos.x, settings.zoomnum_pos.y )
    num:SetFont( fonts.zoomnum_font )
    num:SetRenderMode( settings.zoomnum_rendermode )
    num:SetBackground( settings.zoomnum_background )
    num:SetAlign( settings.zoomnum_align )
    num:SetDigits( settings.zoomnum_digits )

    local unit = self.Unit
    unit:SetVisible( settings.zoomunit )
    unit:SetPos( settings.zoomunit_pos.x, settings.zoomunit_pos.y )
    unit:SetFont( fonts.zoomunit_font )
    self:SetDrawUnitOnBackground( settings.zoomunit_on_background )

    local text = self.Text
    text:SetVisible( settings.zoomtext )
    text:SetPos( settings.zoomtext_pos.x, settings.zoomtext_pos.y )
    text:SetFont( fonts.zoomtext_font )
    text:SetText( settings.zoomtext_text )
    text:SetAlign( settings.zoomtext_align )
    self:SetDrawTextOnBackground( settings.zoomtext_on_background )
    
    self:InvalidateLayout()

end

HOLOHUD2.component.Register( "HudZoom", COMPONENT, "HudZoomDisplay" )