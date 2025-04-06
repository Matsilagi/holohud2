local BaseClass = HOLOHUD2.component.Get( "MeterDisplay" )

local COMPONENT = {}

function COMPONENT:Init()

    BaseClass.Init( self )
    self.IconBackground:SetTexture( surface.GetTextureID( "holohud2/draconic/shields" ), 64, 64 )

end

function COMPONENT:ApplySettings( settings, fonts )

    self.Colors:SetColors( settings.color )
    self.Colors2:SetColors( settings.color2 )

    local number = self.Number
    number:SetVisible( settings.num )
    number:SetPos( settings.num_pos.x, settings.num_pos.y )
    number:SetFont( fonts.num_font )
    number:SetRenderMode( settings.num_rendermode )
    number:SetBackground( settings.num_background )
    number:SetDigits( settings.num_digits )
    self:SetNumberLerp( settings.num_lerp )

    local barbackground = self.ProgressBarBackground
    barbackground:SetVisible( settings.bar and settings.bar_background )
    barbackground:SetPos( settings.bar_pos.x, settings.bar_pos.y )
    barbackground:SetSize( settings.bar_size.x, settings.bar_size.y )
    barbackground:SetStyle( settings.bar_style )

    local bar = self.ProgressBar
    bar:Copy( barbackground )
    bar:SetVisible( settings.bar )
    bar:SetGrowDirection( settings.bar_growdirection )
    self:SetProgressBarLerp( settings.bar_lerp )

    local iconbackground = self.IconBackground
    iconbackground:SetPos( settings.icon_pos.x, settings.icon_pos.y )
    iconbackground:SetSize( settings.icon_size )

    local icon = self.Icon
    icon:SetVisible( settings.icon )
    icon:Copy( iconbackground )
    self:SetIconRenderMode( settings.icon_rendermode )
    self:SetDrawIconBackground( settings.icon_background )
    self:SetIconLerp( settings.icon_lerp )

    local text = self.Text
    text:SetVisible( settings.text )
    text:SetPos( settings.text_pos.x, settings.text_pos.y )
    text:SetFont( fonts.text_font )
    text:SetText( settings.text_text )
    text:SetAlign( settings.text_align )
    self:SetDrawTextOnBackground( settings.text_on_background )

end

HOLOHUD2.component.Register( "DRC_HudShields", COMPONENT, "MeterDisplay" )