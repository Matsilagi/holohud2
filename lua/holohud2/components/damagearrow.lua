local math = math
local FrameTime = FrameTime
local scale_Get = HOLOHUD2.scale.Get

local RESOURCES = {
    surface.GetTextureID( "holohud2/damage/arrow0" ),
    surface.GetTextureID( "holohud2/damage/arrow1" ),
    surface.GetTextureID( "holohud2/damage/arrow2" )
}

local COMPONENT = {
    visible     = true,
    x           = 0,
    y           = 0,
    size        = 8,
    offset      = 0,
    angle       = 0,
    intensity   = 0,
    color       = color_white,
    duration    = 8,
    fadelength  = 4,
    stacked     = false,
    animated    = false,
    _x          = 0,
    _y          = 0,
    _u          = 0,
    _v          = 0,
    _size       = 0,
    _offset     = 0,
    _fadetime   = 0,
    _elapsed    = 0,
    _faded      = false,
    _anim       = 0,
    _alpha      = 1,
    _rad        = -math.pi / 2
}

function COMPONENT:InvalidateLayout()

    self.invalid_layout = true

end

function COMPONENT:PerformLayout( force )

    if not force and not ( self.visible and self.invalid_layout ) then return end

    local scale = scale_Get()
    self._x, self._y = math.Round( self.x * scale ), math.Round( self.y * scale )
    self._size = math.Round( self.size * scale )
    self._offset = math.Round( self.offset * scale )

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
    self._rad = math.rad(angle - 90)

end

function COMPONENT:SetOffset( offset )

    if self.offset == offset then return end

    self.offset = offset
    self:InvalidateLayout()

    return true

end

function COMPONENT:SetIntensity( intensity )

    self.intensity = math.Clamp( intensity, 0, 2 )

end

function COMPONENT:SetColor( color )

    self.color = color

end

function COMPONENT:SetStacked( stacked )

    self.stacked = stacked

end

function COMPONENT:SetDuration( duration )

    self.duration = duration
    self._fadetime = duration - self.fadelength

end

function COMPONENT:SetFadeDuration( fadelength )

    self.fadelength = fadelength
    self._fadetime = self.duration - fadelength

end

function COMPONENT:SetAnimated( animated )

    self._elapsed = 0
    self._faded = false
    self._anim = 0
    self._alpha = 0
    self.animated = animated

end

function COMPONENT:Skip()
    
    if self._elapsed >= self._fadetime then return end

    self:SetFadeDuration(.33) -- make the fading much shorter
    self._elapsed = self._fadetime

end

function COMPONENT:IsFading()

    return self._elapsed >= self._fadetime

end

function COMPONENT:Think()

    self:PerformLayout()

    self._u, self._v = self._x, self._y

    -- even if it isn't animated, calculate the offset
    self._u = self._u + math.cos( self._rad ) * ( self._offset + self._size * self._anim - self._size )
    self._v = self._v + math.sin( self._rad ) * ( self._offset + self._size * self._anim - self._size )

    if not self.animated then return end

    local delta = FrameTime()

    self._elapsed = math.min( self._elapsed + delta, self.duration )

    if not self._faded then

        self._anim = math.min( self._anim + delta / .1, 1.33 )
        self._alpha = self._anim

        if self._anim >= 1.33 then self._faded = true end

    else

        self._anim = math.max( self._anim - delta / .25, 1 )
        self._alpha = 1 - math.max( self._elapsed - self._fadetime, 0 ) / self.fadelength

    end

    if self._elapsed >= self.duration then self:SetAnimated( false ) end

end

function COMPONENT:Paint( x, y )

    if not self.visible then return end

    local x, y = x + self._u, y + self._v
    local size = self._size

    surface.SetDrawColor(self.color.r, self.color.g, self.color.b, self.color.a * self._alpha)

    if self.stacked then

        for i = 0, self.intensity do

            surface.SetTexture( RESOURCES[ i + 1 ] )
            surface.DrawTexturedRectRotated( x, y, size, size, -self.angle )

        end

        return

    end

    surface.SetTexture( RESOURCES[self.intensity + 1] )
    surface.DrawTexturedRectRotated(x, y, size, size, -self.angle)

end

HOLOHUD2.component.Register( "DamageArrow", COMPONENT )