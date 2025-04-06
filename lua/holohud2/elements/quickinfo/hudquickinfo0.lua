
local COMPONENT = {}

function COMPONENT:ApplySettings( settings )

    self.Colors:SetColors( settings.health_color )
    self.Colors2:SetColors( settings.suit_color )

    self:SetVisible( settings.health )
    self:SetSize( settings.size )
    self:SetDrawFrame( settings.frame0 )
    self:SetFrameColor( settings.frame0_color )
    self:SetWarningColor( settings.frame0_color2 )
    self:SetInverted( settings.inverted )

end

HOLOHUD2.component.Register( "HudQuickInfo0", COMPONENT, "HudQuickInfo" )