
local COMPONENT = {}

function COMPONENT:ApplySettings( settings, fonts )

    local clip_color = settings.clip2_color
    local clip_color2 = settings.clip2_color2
    local clipnum = settings.clip2num
    local clipnum_pos = settings.clip2num_pos
    local clipnum_font = fonts.clip2num_font
    local clipnum_rendermode = settings.clip2num_rendermode
    local clipnum_background = settings.clip2num_background
    local clipnum_align = settings.clip2num_align
    local clipnum_digits = settings.clip2num_digits
    local clipnum_lerp = settings.clip2num_lerp
    local clipseparator = settings.clip2separator
    local clipseparator_pos = settings.clip2separator_pos
    local clipseparator_is_rect = settings.clip2separator_is_rect
    local clipseparator_size = settings.clip2separator_size
    local clipseparator_font = fonts.clip2separator_font
    local clipnum2 = settings.clip2num2
    local clipnum2_pos = settings.clip2num2_pos
    local clipnum2_font = fonts.clip2num2_font
    local clipnum2_rendermode = settings.clip2num2_rendermode
    local clipnum2_background = settings.clip2num2_background
    local clipnum2_align = settings.clip2num2_align
    local clipnum2_digits = settings.clip2num2_digits
    local clipnum2_lerp = settings.clip2num2_lerp
    local cliptray = settings.clip2tray
    local cliptray_pos = settings.clip2tray_pos
    local cliptray_size = settings.clip2tray_size
    local cliptray_direction = settings.clip2tray_direction
    local clipbar = settings.clip2bar
    local clipbar_background = settings.clip2bar_background
    local clipbar_pos = settings.clip2bar_pos
    local clipbar_size = settings.clip2bar_size
    local clipbar_style = settings.clip2bar_style
    local clipbar_growdirection = settings.clip2bar_growdirection
    local clipicon = settings.clip2icon
    local clipicon_pos = settings.clip2icon_pos
    local clipicon_size = settings.clip2icon_size
    local clipicon_align = settings.clip2icon_align
    local clipicon_angle = settings.clip2icon_angle
    local clipicon_on_background = settings.clip2icon_on_background
    local cliptext = settings.clip2text
    local cliptext_pos = settings.clip2text_pos
    local cliptext_font = fonts.clip2text_font
    local cliptext_align = settings.clip2text_align
    local cliptext_on_background = settings.clip2text_on_background

    if settings.clip2_copy then

        clip_color = settings.clip1_color
        clip_color2 = settings.clip1_color2
        clipnum = settings.clip1num
        clipnum_pos = settings.clip1num_pos
        clipnum_font = fonts.clip1num_font
        clipnum_rendermode = settings.clip1num_rendermode
        clipnum_background = settings.clip1num_background
        clipnum_align = settings.clip1num_align
        clipnum_digits = settings.clip1num_digits
        clipnum_lerp = settings.clip1num_lerp
        clipseparator = settings.clip1separator
        clipseparator_pos = settings.clip1separator_pos
        clipseparator_is_rect = settings.clip1separator_is_rect
        clipseparator_size = settings.clip1separator_size
        clipseparator_font = fonts.clip1separator_font
        clipnum2 = settings.clip1num2
        clipnum2_pos = settings.clip1num2_pos
        clipnum2_font = fonts.clip1num2_font
        clipnum2_rendermode = settings.clip1num2_rendermode
        clipnum2_background = settings.clip1num2_background
        clipnum2_align = settings.clip1num2_align
        clipnum2_digits = settings.clip1num2_digits
        clipnum2_lerp = settings.clip1num2_lerp
        cliptray = settings.clip1tray
        cliptray_pos = settings.clip1tray_pos
        cliptray_size = settings.clip1tray_size
        cliptray_direction = settings.clip1tray_direction
        clipbar = settings.clip1bar
        clipbar_background = settings.clip1bar_background
        clipbar_pos = settings.clip1bar_pos
        clipbar_size = settings.clip1bar_size
        clipbar_style = settings.clip1bar_style
        clipbar_growdirection = settings.clip1bar_growdirection
        clipicon = settings.clip1icon
        clipicon_pos = settings.clip1icon_pos
        clipicon_size = settings.clip1icon_size
        clipicon_align = settings.clip1icon_align
        clipicon_angle = settings.clip1icon_angle
        clipicon_on_background = settings.clip1icon_on_background
        cliptext = settings.clip1text
        cliptext_pos = settings.clip1text_pos
        cliptext_font = fonts.clip1text_font
        cliptext_align = settings.clip1text_align
        cliptext_on_background = settings.clip1text_on_background

    end

    -- undo current transforms
    self:RevertOversizeTransform()

    self.Colors:SetColors( clip_color )
    self.Colors2:SetColors( clip_color2 )
    local color, color2 = self.Colors:GetColor(), self.Colors2:GetColor()

    local num = self.Number
    num:SetVisible( clipnum )
    num:SetPos( clipnum_pos.x, clipnum_pos.y )
    num:SetFont( clipnum_font )
    num:SetRenderMode( clipnum_rendermode )
    num:SetBackground( clipnum_background )
    num:SetAlign( clipnum_align )
    num:SetDigits( clipnum_digits )
    self:SetNumberLerp( clipnum_lerp )

    -- get new number size
    num:PerformLayout( true )
    self._number_size = num.__defaultsize
    self._last_number_size = self._number_size

    local separator = self.Separator
    separator:SetVisible( clipseparator )
    separator:SetPos( clipseparator_pos.x, clipseparator_pos.y )
    separator:SetDrawAsRectangle( clipseparator_is_rect )
    separator:SetSize( clipseparator_size.x, clipseparator_size.y )
    separator:SetFont( clipseparator_font )

    local num2 = self.Number2
    num2:SetVisible( clipnum2 )
    num2:SetPos( clipnum2_pos.x, clipnum2_pos.y )
    num2:SetFont( clipnum2_font )
    num2:SetRenderMode( clipnum2_rendermode )
    num2:SetBackground( clipnum2_background )
    num2:SetAlign( clipnum2_align )
    num2:SetDigits( clipnum2_digits )
    self:SetNumber2Lerp( clipnum2_lerp )

    local ammotray = self.AmmoTray
    ammotray:SetVisible( cliptray )
    ammotray:SetPos( cliptray_pos.x, cliptray_pos.y )
    ammotray:SetSize( cliptray_size.x, cliptray_size.y )
    ammotray:SetDirection( cliptray_direction )

    local ammobarbackground = self.AmmoBarBackground
    ammobarbackground:SetVisible( clipbar and clipbar_background )
    ammobarbackground:SetPos( clipbar_pos.x, clipbar_pos.y )
    ammobarbackground:SetSize( clipbar_size.x, clipbar_size.y )
    ammobarbackground:SetStyle( clipbar_style )

    local ammobar = self.AmmoBar
    ammobar:SetVisible( clipbar )
    ammobar:SetGrowDirection( clipbar_growdirection )
    ammobar:Copy(ammobarbackground)

    local icon = self.Icon
    icon:SetVisible( clipicon )
    icon:SetPos( clipicon_pos.x, clipicon_pos.y )
    icon:SetSize( clipicon_size )
    icon:SetAngle( clipicon_angle )
    icon:SetAlign( clipicon_align )
    icon:SetColor( clipicon_on_background and color or color )
    self:SetDrawIconOnBackground( clipicon_on_background )

    local text = self.Text
    text:SetVisible( cliptext )
    text:SetPos( cliptext_pos.x, cliptext_pos.y )
    text:SetFont( cliptext_font )
    text:SetAlign( cliptext_align )
    self:SetDrawTextOnBackground( cliptext_on_background )
    
    self:InvalidateLayout()

end

HOLOHUD2.component.Register( "HudClip2", COMPONENT, "HudClip" )