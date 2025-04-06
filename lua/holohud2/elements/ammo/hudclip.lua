local BaseClass = HOLOHUD2.component.Get( "HudAmmo" )

local COMPONENT = {}

function COMPONENT:SetAmmo( ammo )

    if ammo > self.ammo then self.AmmoTray:Reload( ammo - self.ammo == 1 ) end

    BaseClass.SetAmmo( self, ammo )

end

HOLOHUD2.component.Register( "HudClip", COMPONENT, "HudAmmo" )