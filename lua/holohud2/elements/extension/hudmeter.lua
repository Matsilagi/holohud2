
local COMPONENT = {}

function COMPONENT:ApplySettings( settings, fonts )

    self.Colors:SetColors( settings.color )
    self.Colors2:SetColors( settings.color2 )
    
    local icon = self.IconBackground
    icon:SetVisible( settings.icon )
    icon:SetPos( settings.icon_pos.x, settings.icon_pos.y )
    icon:SetSize( settings.icon_size )

    self.Icon:SetVisible( settings.icon )
    self.Icon:Copy( icon )

    self:SetIconRenderMode( settings.icon_rendermode )
    self:SetDrawIconBackground( settings.icon_background )
    self:SetIconLerp( settings.icon_lerp )

    local number = self.Number
    number:SetVisible( settings.number )
    number:SetPos( settings.number_pos.x, settings.number_pos.y )
    number:SetFont( fonts.number_font )
    number:SetRenderMode( settings.number_rendermode )
    number:SetBackground( settings.number_background )
    number:SetAlign( settings.number_align )
    number:SetDigits( settings.number_digits )

    local progressbarbackground = self.ProgressBarBackground
    progressbarbackground:SetVisible( settings.progressbar )
    progressbarbackground:SetPos( settings.progressbar_pos.x, settings.progressbar_pos.y )
    progressbarbackground:SetSize( settings.progressbar_size.x, settings.progressbar_size.y )
    progressbarbackground:SetStyle( settings.progressbar_style )
    
    local progressbar = self.ProgressBar
    progressbar:SetVisible( settings.progressbar )
    progressbar:SetGrowDirection( settings.progressbar_growdirection )
    progressbar:Copy( progressbarbackground )
    self:SetProgressBarLerp( settings.progressbar_lerp )

    local text = self.Text
    text:SetVisible( settings.text )
    text:SetPos( settings.text_pos.x, settings.text_pos.y )
    text:SetFont( fonts.text_font )
    text:SetAlign( settings.text_align )
    text:SetText( settings.text_text )
    self:SetDrawTextOnBackground( settings.text_on_background )

end

HOLOHUD2.component.Register( "HudExtensionMeter", COMPONENT, "MeterDisplay" )