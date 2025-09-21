local CurTime = CurTime
local FrameTime = FrameTime

local COMPONENT = {
    dmgcolor    = color_white,
    blinkamount = .4,
    blinkrate   = .6,
    damagetime  = 1,
    fadetime    = 1,
    fading      = false,
    _fade       = 0,
    _damage     = 0,
    _color      = color_white
}

function COMPONENT:Think()

    self:PerformLayout()

    local frametime = FrameTime()

    local blink = 1 - ( self.blinkamount * ( math.cos( CurTime() * math.pi / self.blinkrate ) + 1 ) / 2 )

    self._damage = math.max( self._damage - frametime / self.damagetime, 0 )

    self.color.r = self._color.r * ( 1 - self._damage ) * blink + self.dmgcolor.r * self._damage
    self.color.g = self._color.g * ( 1 - self._damage ) * blink + self.dmgcolor.g * self._damage
    self.color.b = self._color.b * ( 1 - self._damage ) * blink + self.dmgcolor.b * self._damage
    self.color.a = ( self._color.a * ( 1 - self._damage ) * blink + self.dmgcolor.a * self._damage ) * ( 1 - self._fade )

    if not self.fading then return end

    self._fade = math.min( self._fade + frametime / self.fadetime, 1 )

end

function COMPONENT:SetColor( color )

    self.color = Color( color.r, color.g, color.b, color.a )
    self._color = color

end

function COMPONENT:SetHazard( hazard )

    local icon = HOLOHUD2.hazard.Get( hazard )

    if not icon then return end

    self:SetTexture( { icon.texture, icon.filew, icon.fileh, icon.x, icon.y, icon.w, icon.h } )

end

function COMPONENT:SetDamageColor( dmgcolor )

    self.dmgcolor = dmgcolor

end

function COMPONENT:SetDamageTime( dmgtime )

    self.damagetime = dmgtime

end

function COMPONENT:SetBlinkAmount( blinkamount )

    self.blinkamount = blinkamount

end

function COMPONENT:SetBlinkRate( blinkrate )

    self.blinkrate = blinkrate

end

function COMPONENT:Damage()

    self._damage = 1

end

function COMPONENT:SetFadeTime( fadetime )

    self.fadetime = fadetime

end

function COMPONENT:SetFading( fading )

    if self.fading == fading then return end

    if not fading then self._fade = 0 end

    self.fading = fading

end

function COMPONENT:IsFaded()

    return self._fade >= 1

end

HOLOHUD2.component.Register( "Hazard", COMPONENT, "Icon")
