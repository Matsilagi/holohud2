
local COMPONENT = {}

function COMPONENT:InvalidateLayout()

    self.Icon:InvalidateLayout()
    self.Label:InvalidateLayout()
    self.Name:InvalidateLayout()

end

function COMPONENT:ApplySettings( settings, fonts )

    self:SetLabelAnimationSpeed( 64 )
    self:SetLabelAnimationDelay( settings.animation ~= HOLOHUD2.PANELANIMATION_NONE and .26 or 0 )
    self:SetLabelAnimated( settings.weapon_label_animated )
    self:SetNameAnimationSpeed( 48 )
    self:SetNameAnimationDelay( .18 )
    self:SetNameAnimated( settings.weapon_name_animated )

    local icon = self.Icon
    icon:SetVisible( settings.weapon_icon )
    icon:SetPos( settings.weapon_icon_pos.x, settings.weapon_icon_pos.y )
    icon:SetSize( settings.weapon_icon_size )
    icon:SetColor( settings.weapon_icon_color )

    local name = self.Name
    name:SetVisible( settings.weapon_name )
    name:SetPos( settings.weapon_name_pos.x, settings.weapon_name_pos.y )
    name:SetFont( fonts.weapon_name_font )
    name:SetAlign( settings.weapon_name_align )
    name:SetColor( settings.weapon_name_color )

    local label = self.Label
    label:SetVisible( settings.weapon_label )
    label:SetText( settings.weapon_label_text )
    label:SetPos( settings.weapon_label_pos.x, settings.weapon_label_pos.y )
    label:SetFont( fonts.weapon_label_font )
    label:SetAlign( settings.weapon_label_align )
    label:SetColor( settings.weapon_label_color )
    
    self:InvalidateLayout()

end

HOLOHUD2.component.Register( "HudWeaponPickup", COMPONENT, "WeaponPickup" )