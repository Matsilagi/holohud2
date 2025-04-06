
local COMPONENT = {}

function COMPONENT:ApplySettings( settings, fonts )

    self:SetNameAnimationDelay( .3 )
    self:SetNameAnimationSpeed( 48 )
    self:SetNameAnimated( settings.ammo_name_animated and settings.ammo_mode == HOLOHUD2.AMMOPICKUPMODE_FULL )

    self:SetPos( settings.ammo_padding * 2, settings.ammo_padding )
    self:SetColor( settings.ammo_color )
    self:SetColor2( settings.ammo_color2 )
    self:SetSpacing( settings.ammo_spacing )
    self:SetMode( settings.ammo_mode )

    self.Icon:SetSize( settings.ammo_icon_size )
    self.Name:SetFont( settings.ammo_mode == HOLOHUD2.AMMOPICKUPMODE_FULL and fonts.ammo_name_font or fonts.ammo_fallback_font )
    self:SetNamePos( settings.ammo_name_pos )

    if settings.ammo_mode == HOLOHUD2.AMMOPICKUPMODE_FULL then

        self.Name:SetColor( settings.ammo_name_color )

    end

    self:SetNameAlign( settings.ammo_name_align )
    self:SetNameSpacing( settings.ammo_name_spacing )
    self:SetAmountOffset( settings.ammo_amount_offset.x, settings.ammo_amount_offset.y )
    self.Amount:SetFont( fonts.ammo_amount_font )
    self.Amount:SetRenderMode( settings.ammo_amount_rendermode )
    self.Amount:SetBackground( settings.ammo_amount_background )
    self.Amount:SetAlign( settings.ammo_amount_align )
    self.Amount:SetDigits( settings.ammo_amount_digits )
    self:SetLerp( settings.ammo_amount_lerp )

    self:PerformLayout( true )

end

HOLOHUD2.component.Register( "HudAmmoPickup", COMPONENT, "AmmoPickup" )