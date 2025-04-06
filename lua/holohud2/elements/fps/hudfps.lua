local BaseClass = HOLOHUD2.component.Get( "GraphUnitDisplay" )

local RESOURCE = { surface.GetTextureID( "holohud2/fps" ), 64, 64, 0, 0, 64, 64 }

local COMPONENT = {}

function COMPONENT:Init()

    BaseClass.Init( self )

    self:SetLerpSpeed( .5 )
    self.Icon:SetTexture( RESOURCE )
    self.Unit:SetText( "FPS" )
    self.Graph:SetRate( .8 )

end

function COMPONENT:ApplySettings( settings, fonts )

    self.Colors:SetColors( settings.color )
    self.Colors2:SetColors( settings.color2 )

    self.Icon:SetVisible( settings.icon )
    self.Icon:SetPos( settings.icon_pos.x, settings.icon_pos.y )
    self.Icon:SetSize( settings.icon_size )
    self:SetDrawIconOnBackground( settings.icon_on_background )

    self.Number:SetVisible( settings.number )
    self.Number:SetPos( settings.number_pos.x, settings.number_pos.y )
    self.Number:SetAlign( settings.number_align )
    self.Number:SetFont( fonts.number_font )
    self.Number:SetRenderMode( settings.number_rendermode )
    self.Number:SetBackground( settings.number_background )
    self:SetNumberLerp( settings.smooth )

    self.Unit:SetVisible( settings.unit )
    self.Unit:SetPos( settings.unit_pos.x, settings.unit_pos.y )
    self.Unit:SetAlign( settings.unit_align )
    self.Unit:SetFont( fonts.unit_font )
    self:SetDrawUnitOnBackground( settings.unit_on_background )

    self.Graph:SetVisible( settings.graph )
    self.Graph:SetPos( settings.graph_pos.x, settings.graph_pos.y )
    self.Graph:SetSize( settings.graph_size.x, settings.graph_size.y )
    self.Graph:SetInverted( settings.graph_inverted )

    self.Gauge:SetVisible( settings.graph_guide )
    self.Gauge:SetPos( settings.graph_pos.x + ( settings.graph_inverted and settings.graph_size.x or -3 ), settings.graph_pos.y - 1 )
    self.Gauge:SetSize( 2, settings.graph_size.y + 2 )
    self.Gauge:SetDirection( settings.graph_inverted and HOLOHUD2.DOCK.LEFT or HOLOHUD2.DOCK.RIGHT )

    self.Text:SetVisible( settings.text )
    self.Text:SetPos( settings.text_pos.x, settings.text_pos.y )
    self.Text:SetAlign( settings.text_align )
    self.Text:SetFont( fonts.text_font )
    self.Text:SetText( settings.text_text )
    self:SetDrawTextOnBackground( settings.text_on_background )
    
    self:InvalidateLayout()

end

HOLOHUD2.component.Register( "HudFramerate", COMPONENT, "GraphUnitDisplay" )