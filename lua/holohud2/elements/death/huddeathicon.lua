
local BaseClass = HOLOHUD2.component.Get( "Icon" )

local CurTime = CurTime

local COMPONENT = {
    anchor      = false
}

function COMPONENT:Init()

    self:SetTexture( surface.GetTextureID( "holohud2/emergency" ), 64, 64, 0, 0, 64, 64 )

end

function COMPONENT:SetAnchoredToScreen( anchor )

    if self.anchor == anchor then return end

    self.anchor = anchor
    self:InvalidateLayout()

end

function COMPONENT:Paint( x, y )

    if CurTime() % .7 > .35 then return end

    BaseClass.Paint( self, x, y )

end

function COMPONENT:PerformLayout( force )

    if not BaseClass.PerformLayout( self, force ) then return end
    if not self.anchor then return end

    self._x = ( HOLOHUD2.layout.GetScreenSize() * HOLOHUD2.scale.Get() ) - self._w - self._x

end

function COMPONENT:ApplySettings( settings )

    self:SetVisible( settings.icon )
    self:SetPos( settings.icon_pos.x, settings.icon_pos.y )
    self:SetColor( settings.color )
    self:SetSize( settings.icon_size )

end

HOLOHUD2.component.Register( "HudDeathIcon", COMPONENT, "Icon" )