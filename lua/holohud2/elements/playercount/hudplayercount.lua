
local BaseClass = HOLOHUD2.component.Get( "CounterDisplay" )

local RESOURCE = { surface.GetTextureID( "holohud2/players" ), 64, 64 }

local COMPONENT = {}

function COMPONENT:Init()

    BaseClass.Init( self )

    self.IconBackground:SetTexture( RESOURCE )

end

function COMPONENT:ApplySettings( settings, fonts )

    local singleplayer = game.SinglePlayer() and not settings.singleplayer

    self.Colors:SetColors( settings.color )
    self.Colors2:SetColors( settings.color2 )

    local icon = self.IconBackground
    icon:SetVisible( settings.icon )
    icon:SetPos( settings.icon_pos.x, settings.icon_pos.y )
    icon:SetSize( settings.icon_size )

    self.Icon:SetVisible( settings.icon )
    self.Icon:Copy( icon )

    self:SetIconRenderMode( singleplayer and HOLOHUD2.ICONRENDERMODE_STATICBACKGROUND or settings.icon_rendermode )
    self:SetDrawIconBackground( settings.icon_background )
    self:SetIconLerp( settings.icon_lerp )

    local num = self.Number
    num:SetVisible( settings.number )
    num:SetPos( settings.number_pos.x, settings.number_pos.y )
    num:SetFont( fonts.number_font )
    num:SetAlign( settings.number_align )
    num:SetBackground( settings.number_background )
    num:SetRenderMode( settings.number_rendermode )
    num:SetDigits( settings.number_digits )
    self:SetNumberLerp( settings.number_lerp )

    local separator = self.Separator
    separator:SetVisible( settings.separator )
    separator:SetPos( settings.separator_pos.x, settings.separator_pos.y )
    separator:SetDrawAsRectangle( settings.separator_is_rect )
    separator:SetSize( settings.separator_size.x, settings.separator_size.y )
    separator:SetFont( fonts.separator_font )
    self:SetDrawSeparatorOnBackground( singleplayer )

    local num2 = self.Number2
    num2:SetVisible( settings.number2 )
    num2:SetPos( settings.number2_pos.x, settings.number2_pos.y )
    num2:SetFont( fonts.number2_font )
    num2:SetAlign( settings.number2_align )
    num2:SetBackground( settings.number2_background )
    num2:SetRenderMode( settings.number2_rendermode )
    num2:SetDigits( settings.number2_digits )

    local progressbarbackground = self.ProgressBarBackground
    progressbarbackground:SetVisible( settings.progressbar )
    progressbarbackground:SetPos( settings.progressbar_pos.x, settings.progressbar_pos.y )
    progressbarbackground:SetSize( settings.progressbar_size.x, settings.progressbar_size.y )
    progressbarbackground:SetStyle( settings.progressbar_style )

    local progressbar = self.ProgressBar
    progressbar:SetVisible( settings.progressbar )
    progressbar:Copy( progressbarbackground )
    progressbar:SetGrowDirection( settings.progressbar_growdirection )

    local text = self.Text
    text:SetVisible( settings.text )
    text:SetPos( settings.text_pos.x, settings.text_pos.y )
    text:SetFont( fonts.text_font )
    text:SetAlign( settings.text_align )
    text:SetText( settings.text_text )
    self:SetDrawTextOnBackground( singleplayer or settings.text_on_background )
    
    self:InvalidateLayout()

end

HOLOHUD2.component.Register( "HudPlayerCount", COMPONENT, "CounterDisplay" )