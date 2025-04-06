
local COMPONENT = {}

function COMPONENT:ApplySettings( settings )

    self.Colors:SetColors( settings.ammo_color )
    self.Colors2:SetColors( settings.ammo2_color )

    self:SetVisible( settings.ammo )
    self:SetSize( settings.size )
    self:SetDrawFrame( settings.frame1 )
    self:SetFrameColor( settings.frame1_color )
    self:SetWarningColor( settings.frame1_color2 )
    self:SetInverted( not settings.inverted )

end

HOLOHUD2.component.Register( "HudQuickInfo1", COMPONENT, "HudQuickInfo" )