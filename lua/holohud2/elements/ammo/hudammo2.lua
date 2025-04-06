
local COMPONENT = {}

function COMPONENT:ApplySettings( settings, fonts )

    local ammo_color = settings.ammo2_color
    local ammo_color2 = settings.ammo2_color2
    local ammonum = settings.ammo2num
    local ammonum_pos = settings.ammo2num_pos
    local ammonum_font = fonts.ammo2num_font
    local ammonum_rendermode = settings.ammo2num_rendermode
    local ammonum_background = settings.ammo2num_background
    local ammonum_align = settings.ammo2num_align
    local ammonum_digits = settings.ammo2num_digits
    local ammonum_lerp = settings.ammo2num_lerp
    local ammotray_visible = settings.ammo2tray
    local ammotray_pos = settings.ammo2tray_pos
    local ammotray_size = settings.ammo2tray_size
    local ammotray_direction = settings.ammo2tray_direction
    local ammobar_visible = settings.ammo2bar
    local ammobar_background = settings.ammo2bar_background
    local ammobar_pos = settings.ammo2bar_pos
    local ammobar_size = settings.ammo2bar_size
    local ammobar_style = settings.ammo2bar_style
    local ammobar_growdirection = settings.ammo2bar_growdirection
    local ammoicon = settings.ammo2icon
    local ammoicon_pos = settings.ammo2icon_pos
    local ammoicon_size = settings.ammo2icon_size
    local ammoicon_angle = settings.ammo2icon_angle
    local ammoicon_align = settings.ammo2icon_align
    local ammoicon_on_background = settings.ammo2icon_on_background
    local ammotext = settings.ammo2text
    local ammotext_pos = settings.ammo2text_pos
    local ammotext_font = fonts.ammo2text_font
    local ammotext_align = settings.ammo2text_align
    local ammotext_on_background = settings.ammo2text_on_background

    if settings.ammo2_copy then

        ammo_color = settings.ammo1_color
        ammo_color2 = settings.ammo1_color2
        ammonum = settings.ammo1num
        ammonum_pos = settings.ammo1num_pos
        ammonum_font = fonts.ammo1num_font
        ammonum_rendermode = settings.ammo1num_rendermode
        ammonum_background = settings.ammo1num_background
        ammonum_align = settings.ammo1num_align
        ammonum_digits = settings.ammo1num_digits
        ammonum_lerp = settings.ammo1num_lerp
        ammotray_visible = settings.ammo1tray
        ammotray_pos = settings.ammo1tray_pos
        ammotray_size = settings.ammo1tray_size
        ammotray_direction = settings.ammo1tray_direction
        ammobar_visible = settings.ammo1bar
        ammobar_background = settings.ammo1bar_background
        ammobar_pos = settings.ammo1bar_pos
        ammobar_size = settings.ammo1bar_size
        ammobar_style = settings.ammo1bar_style
        ammobar_growdirection = settings.ammo1bar_growdirection
        ammoicon = settings.ammo1icon
        ammoicon_pos = settings.ammo1icon_pos
        ammoicon_size = settings.ammo1icon_size
        ammoicon_angle = settings.ammo1icon_angle
        ammoicon_align = settings.ammo1icon_align
        ammoicon_on_background = settings.ammo1icon_on_background
        ammotext = settings.ammo1text
        ammotext_pos = settings.ammo1text_pos
        ammotext_font = fonts.ammo1text_font
        ammotext_align = settings.ammo1text_align
        ammotext_on_background = settings.ammo1text_on_background

    end

    -- undo current transforms
    self:RevertOversizeTransform()

    self.Colors:SetColors( settings.ammo2_separate and ammo_color or settings.clip2_color )
    self.Colors2:SetColors( settings.ammo2_separate and ammo_color2 or settings.clip2_color2 )
    local color, color2 = self.Colors:GetColor(), self.Colors2:GetColor()

    local num = self.Number
    num:SetVisible( ammonum )
    num:SetPos( ammonum_pos.x, ammonum_pos.y )
    num:SetFont( ammonum_font )
    num:SetRenderMode( ammonum_rendermode )
    num:SetBackground( ammonum_background )
    num:SetAlign( ammonum_align )
    num:SetDigits( ammonum_digits )
    self:SetNumberLerp( ammonum_lerp )

    -- get new number size
    num:PerformLayout( true )
    self._number_size = num.__defaultsize
    self._last_number_size = self._number_size

    local ammotray = self.AmmoTray
    ammotray:SetVisible( ammotray_visible )
    ammotray:SetPos( ammotray_pos.x, ammotray_pos.y )
    ammotray:SetSize( ammotray_size.x, ammotray_size.y )
    ammotray:SetDirection( ammotray_direction )

    local ammobarbackground = self.AmmoBarBackground
    ammobarbackground:SetVisible( ammobar_visible and ammobar_background )
    ammobarbackground:SetPos( ammobar_pos.x, ammobar_pos.y )
    ammobarbackground:SetSize( ammobar_size.x, ammobar_size.y )
    ammobarbackground:SetStyle( ammobar_style )

    local ammobar = self.AmmoBar
    ammobar:SetVisible( ammobar_visible )
    ammobar:SetGrowDirection( ammobar_growdirection )
    ammobar:Copy( ammobarbackground )

    local icon = self.Icon
    icon:SetVisible( ammoicon )
    icon:SetPos( ammoicon_pos.x, ammoicon_pos.y )
    icon:SetSize( ammoicon_size )
    icon:SetAngle( ammoicon_angle )
    icon:SetAlign( ammoicon_align )
    icon:SetColor( ammoicon_on_background and color2 or color )
    self:SetDrawIconOnBackground( ammoicon_on_background )

    local text = self.Text
    text:SetVisible( ammotext )
    text:SetPos( ammotext_pos.x, ammotext_pos.y )
    text:SetFont( ammotext_font )
    text:SetAlign( ammotext_align )
    self:SetDrawTextOnBackground( ammotext_on_background )
    
    self:InvalidateLayout()

end

HOLOHUD2.component.Register( "HudAmmo2", COMPONENT, "HudAmmo1" )