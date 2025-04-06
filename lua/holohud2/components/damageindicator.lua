local math = math
local FrameTime = FrameTime
local scale_Get = HOLOHUD2.scale.Get

local RESOURCE = surface.GetTextureID( "holohud2/damage/side" )

local COMPONENT = {
    visible         = true,
    invalid_layout  = false,
    x               = 0,
    y               = 0,
    size            = 8,
    angle           = 0,
    color           = color_white,
    duration        = .8,
    animated        = false,
    _x              = 0,
    _y              = 0,
    _w              = 0,
    _h              = 0,
    _alpha          = 1,
    _elapsed        = 0
}

function COMPONENT:InvalidateLayout()

    self.invalid_layout = true

end

function COMPONENT:PerformLayout( force )

    if not force and not ( self.visible and self.invalid_layout ) then return end

    local scale = scale_Get()
    self._x, self._y = math.Round( self.x * scale ), math.Round( self.y * scale )
    self._w, self._h = math.Round( self.size * scale ), math.Round( self.size / 8 * scale )

    self.invalid_layout = false
    return true

end

function COMPONENT:SetVisible( visible )

    if self.visible == visible then return end

    self.visible = visible
    self:InvalidateLayout()

    return true

end

function COMPONENT:SetPos( x, y )

    if self.x == x and self.y == y then return end

    self.x = x
    self.y = y
    self:InvalidateLayout()

    return true

end

function COMPONENT:SetSize( size )

    if self.size == size then return end

    self.size = size
    self:InvalidateLayout()

    return true

end

function COMPONENT:SetAngle( angle )

    if self.angle == angle then return end

    self.angle = angle

end

function COMPONENT:SetColor( color )

    self.color = color

end

function COMPONENT:SetDuration( duration )

    self.duration = duration

end

function COMPONENT:SetAnimated( animated )

    self._elapsed = 0
    self.animated = animated

end

function COMPONENT:AnimationFinished()

    return self._elapsed >= self.duration

end

function COMPONENT:Think()

    self:PerformLayout()

    if not self.animated then return end

    self._elapsed = math.min( self._elapsed + FrameTime(), self.duration )
    self._alpha = 1 - ( self._elapsed / self.duration )

    if self._elapsed >= self.duration then self.animated = false end

end

function COMPONENT:Paint(x, y, scale)

    if not self.visible then return end

    surface.SetTexture( RESOURCE )
    surface.SetDrawColor( self.color.r, self.color.g, self.color.b, self.color.a * self._alpha )
    surface.DrawTexturedRectRotated( x + self._x, y + self._y, self._w, self._h, self.angle )

end

HOLOHUD2.component.Register( "DamageIndicator", COMPONENT )