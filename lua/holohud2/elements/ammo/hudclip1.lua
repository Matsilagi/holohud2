
local COMPONENT = {}

function COMPONENT:ApplySettings( settings, fonts )

    -- undo current transforms
    self:RevertOversizeTransform()

    self.Colors:SetColors( settings.clip1_color or settings.clip1_color )
    self.Colors2:SetColors( settings.clip1_color2 or settings.clip1_color2 )
    local color, color2 = self.Colors:GetColor(), self.Colors2:GetColor()

    local num = self.Number
    num:SetVisible( settings.clip1num )
    num:SetPos( settings.clip1num_pos.x, settings.clip1num_pos.y )
    num:SetFont( fonts.clip1num_font )
    num:SetRenderMode( settings.clip1num_rendermode )
    num:SetBackground( settings.clip1num_background )
    num:SetAlign( settings.clip1num_align )
    num:SetDigits( settings.clip1num_digits )
    self:SetNumberLerp( settings.clip1num_lerp )

    -- get new number size
    num:PerformLayout( true )
    self._number_size = num.__defaultsize
    self._last_number_size = self._number_size

    local separator = self.Separator
    separator:SetVisible( settings.clip1separator )
    separator:SetPos( settings.clip1separator_pos.x, settings.clip1separator_pos.y )
    separator:SetDrawAsRectangle( settings.clip1separator_is_rect )
    separator:SetSize( settings.clip1separator_size.x, settings.clip1separator_size.y )
    separator:SetFont( fonts.clip1separator_font )

    local num2 = self.Number2
    num2:SetVisible( settings.clip1num2 )
    num2:SetPos( settings.clip1num2_pos.x, settings.clip1num2_pos.y )
    num2:SetFont( fonts.clip1num2_font )
    num2:SetRenderMode( settings.clip1num2_rendermode )
    num2:SetBackground( settings.clip1num2_background )
    num2:SetAlign( settings.clip1num2_align )
    num2:SetDigits( settings.clip1num2_digits )
    self:SetNumber2Lerp( settings.clip1num2_lerp )

    local ammotray = self.AmmoTray
    ammotray:SetVisible( settings.clip1tray )
    ammotray:SetPos( settings.clip1tray_pos.x, settings.clip1tray_pos.y )
    ammotray:SetSize( settings.clip1tray_size.x, settings.clip1tray_size.y )
    ammotray:SetDirection( settings.clip1tray_direction )

    local ammobarbackground = self.AmmoBarBackground
    ammobarbackground:SetVisible( settings.clip1bar and settings.clip1bar_background )
    ammobarbackground:SetPos( settings.clip1bar_pos.x, settings.clip1bar_pos.y )
    ammobarbackground:SetSize( settings.clip1bar_size.x, settings.clip1bar_size.y )
    ammobarbackground:SetStyle( settings.clip1bar_style )

    local ammobar = self.AmmoBar
    ammobar:SetVisible(settings.clip1bar)
    ammobar:SetGrowDirection(settings.clip1bar_growdirection)
    ammobar:Copy(ammobarbackground)

    local icon = self.Icon
    icon:SetVisible(settings.clip1icon)
    icon:SetPos(settings.clip1icon_pos.x, settings.clip1icon_pos.y)
    icon:SetSize(settings.clip1icon_size)
    icon:SetAngle(settings.clip1icon_angle)
    icon:SetAlign(settings.clip1icon_align)
    icon:SetColor( settings.clip1icon_on_background and self.Colors2:GetColor() or self.Colors:GetColor() )
    self:SetDrawIconOnBackground(settings.clip1icon_on_background)

    local text = self.Text
    text:SetVisible( settings.clip1text )
    text:SetPos( settings.clip1text_pos.x, settings.clip1text_pos.y )
    text:SetFont( fonts.clip1text_font )
    text:SetText( settings.clip1text_text )
    text:SetAlign( settings.clip1text_align )
    self:SetDrawTextOnBackground( settings.clip1text_on_background )

    --[[local firemode = self.FireMode
    firemode:SetVisible( self.firemode and FIREMODES[ self.firemode ] and settings.firemode )
    firemode:SetPos( settings.firemode_pos.x, settings.firemode_pos.y )
    firemode:SetSize( settings.firemode_size )
    firemode:SetColor( color )
    self.firemode_visible = settings.firemode
    self.transform_oversize.firemode_pos = settings.clip1_oversize_firemodepos]]
    
    self:InvalidateLayout()

end

HOLOHUD2.component.Register( "HudClip1", COMPONENT, "HudClip" )