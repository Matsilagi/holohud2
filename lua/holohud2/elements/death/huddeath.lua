local COMPONENT = {}

function COMPONENT:ApplySettings( settings, fonts )

    local w, h = HOLOHUD2.layout.GetScreenSize()

    self:SetVisible( settings.text )
    self:SetPos( settings.text_pos.x, settings.text_pos.y )
    self:SetSize( w - settings.text_pos.x * 2, h - settings.text_pos.y * 2 )
    self:SetMargin( settings.text_margin )
    self:SetSpacing( settings.text_spacing )
    self:SetFont( fonts.text_font )
    self:SetColor( settings.color )
    self:SetColor2( settings.color )
    self:SetLetterRate( .018 / settings.text_speed )

end

HOLOHUD2.component.Register( "HudDeath", COMPONENT, "MessageLog" )