local CurTime = CurTime

local COMPONENT = {

    label_animated      = false,
    label_anim_speed    = 1,
    label_anim_delay    = 1,
    name_animted        = false,
    name_anim_speed     = 1,
    name_anim_delay     = 1,
    _next_label_char    = 0,
    _next_name_char     = 0

}

function COMPONENT:Init()

    self.Icon = HOLOHUD2.component.Create( "WeaponSelectionIcon" )
    self.Label = HOLOHUD2.component.Create( "Text" )
    self.Name = HOLOHUD2.component.Create( "Text" )

end

function COMPONENT:Think()

    self.Icon:PerformLayout()
    self.Label:PerformLayout()
    self.Name:PerformLayout()

    local curtime = CurTime()

    if self.label_animated then

        local label_len = utf8.len( self.Label.text )

        if self.Label.charsvisible < label_len then

            if self._next_label_char < curtime then

                if self.Label.charsvisible == label_len - 1 then

                    self.Label:SetCharsVisible( label_len )
                    self._next_name_char = curtime + self.name_anim_delay

                else

                    self.Label:SetCharsVisible( self.Label.charsvisible + 1 )
                    self._next_label_char = curtime + 1 / self.label_anim_speed

                end

            end

            return

        end

    end

    if not self.name_animated then return end

    local name_len = utf8.len( self.Name.text )

    if self.Name.charsvisible >= name_len then return end
    if self._next_name_char > curtime then return end

    self.Name:SetCharsVisible( self.Name.charsvisible + 1 )
    self._next_name_char = curtime + 1 / self.name_anim_speed

end

function COMPONENT:SetLabelAnimated( animated )

    if self.label_animated == animated then return end

    if animated then

        self.Label:SetCharsVisible( 0 )
        self._next_label_char = CurTime() + self.label_anim_delay

    else

        self.Label:SetCharsVisible( -1 )

    end

    self.label_animated = animated

    return true

end

function COMPONENT:SetLabelAnimationSpeed( speed )

    self.label_anim_speed = speed

end

function COMPONENT:SetLabelAnimationDelay( delay )

    self.label_anim_delay = delay

end

function COMPONENT:SetNameAnimated( animated )

    if self.name_animated == animated then return end

    if animated then

        self.Name:SetCharsVisible( 0 )
        self._next_name_char = CurTime() + self.name_anim_delay

    else

        self.Name:SetCharsVisible( -1 )

    end

    self.name_animated = animated

    return true

end

function COMPONENT:SetNameAnimationSpeed( speed )

    self.name_anim_speed = speed

end

function COMPONENT:SetNameAnimationDelay( delay )

    self.name_anim_delay = delay

end

function COMPONENT:SetWeapon( weapon )

    self.Icon:SetWeapon( weapon )
    self.Name:SetText( IsValid( weapon ) and ( weapon.GetPrintName and weapon:GetPrintName() or weapon.PrintName or weapon:GetClass() ) or "#Weapon_Name" )

end

function COMPONENT:PaintFrame( x, y )

    self.Icon:PaintFrame( x, y )

end

function COMPONENT:PaintBackground( x, y )

    self.Label:Paint( x, y )

end

function COMPONENT:Paint( x, y )

    self.Name:Paint( x, y )
    self.Icon:Paint( x, y )

end

HOLOHUD2.component.Register( "WeaponPickup", COMPONENT )