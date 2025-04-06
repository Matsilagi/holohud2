
local COMPONENT = {}

local BaseClass = HOLOHUD2.component.Get( "HudAmmo" )

function COMPONENT:Init()

    BaseClass.Init( self )

    self.Separator:SetVisible( false )
    self.Number2:SetVisible( false )

end

function COMPONENT:ApplySettings( settings, fonts )

    -- undo current transforms
    self:RevertOversizeTransform()
    
    self.Colors:SetColors( settings.ammo1_separate and settings.ammo1_color or settings.clip1_color )
    self.Colors2:SetColors( settings.ammo1_separate and settings.ammo1_color2 or settings.clip1_color2 )
    local color, color2 = self.Colors:GetColor(), self.Colors2:GetColor()

    local num = self.Number
    num:SetVisible( settings.ammo1num )
    num:SetPos( settings.ammo1num_pos.x, settings.ammo1num_pos.y )
    num:SetFont( fonts.ammo1num_font )
    num:SetRenderMode( settings.ammo1num_rendermode )
    num:SetBackground( settings.ammo1num_background )
    num:SetAlign( settings.ammo1num_align )
    num:SetDigits( settings.ammo1num_digits )
    self:SetNumberLerp( settings.ammo1num_lerp )

    -- get new number size
    num:PerformLayout( true )
    self._number_size = num.__defaultsize
    self._last_number_size = self._number_size

    local ammotray = self.AmmoTray
    ammotray:SetVisible( settings.ammo1tray )
    ammotray:SetPos( settings.ammo1tray_pos.x, settings.ammo1tray_pos.y )
    ammotray:SetSize( settings.ammo1tray_size.x, settings.ammo1tray_size.y )
    ammotray:SetDirection( settings.ammo1tray_direction )

    local ammobarbackground = self.AmmoBarBackground
    ammobarbackground:SetVisible( settings.ammo1bar and settings.ammo1bar_background )
    ammobarbackground:SetPos( settings.ammo1bar_pos.x, settings.ammo1bar_pos.y )
    ammobarbackground:SetSize( settings.ammo1bar_size.x, settings.ammo1bar_size.y )
    ammobarbackground:SetStyle( settings.ammo1bar_style )

    local ammobar = self.AmmoBar
    ammobar:SetVisible( settings.ammo1bar )
    ammobar:SetGrowDirection( settings.ammo1bar_growdirection )
    ammobar:Copy( ammobarbackground )

    local icon = self.Icon
    icon:SetVisible( settings.ammo1icon )
    icon:SetPos( settings.ammo1icon_pos.x, settings.ammo1icon_pos.y )
    icon:SetSize( settings.ammo1icon_size )
    icon:SetAngle( settings.ammo1icon_angle )
    icon:SetAlign( settings.ammo1icon_align )
    icon:SetColor( settings.ammo1icon_on_background and color2 or color )
    self:SetDrawIconOnBackground( settings.ammo1icon_on_background )

    local text = self.Text
    text:SetVisible( settings.ammo1text )
    text:SetPos( settings.ammo1text_pos.x, settings.ammo1text_pos.y )
    text:SetFont( fonts.ammo1text_font )
    text:SetAlign( settings.ammo1text_align )
    self:SetDrawTextOnBackground( settings.ammo1text_on_background )
    
    self:InvalidateLayout()

end

HOLOHUD2.component.Register( "HudAmmo1", COMPONENT, "HudAmmo" )