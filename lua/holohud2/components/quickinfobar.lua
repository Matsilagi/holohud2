local surface = surface
local render = render
local FrameTime = FrameTime
local Lerp = Lerp
local scale_Get = HOLOHUD2.scale.Get
local util_StartStencilScissor = HOLOHUD2.util.StartStencilScissor
local util_EndStencilScissor = HOLOHUD2.util.EndStencilScissor

local W, H              = 64, 128
local FOREGROUND_OFFSET = 14

local RESOURCE_FRAME    = surface.GetTextureID( "holohud2/quickinfo/frame" )
local RESOURCE_BAR      = surface.GetTextureID( "holohud2/quickinfo/bar" )
local RESOURCE_BAR2     = surface.GetTextureID( "holohud2/quickinfo/bar2" )

local COMPONENT = {
    visible             = true,
    invalid_layout      = false,
    x                   = 0,
    y                   = 0,
    size                = 4,
    inverted            = false,
    color               = color_white,
    color2              = color_white,
    frame               = true,
    frame_color         = color_white,
    lerp_speed          = 12,
    value               = 0,
    max_value           = 1,
    value2              = 0,
    max_value2          = 1,
    _value              = 0,
    _value2             = 0,
    _x                  = 0,
    _y                  = 0,
    _w                  = 0,
    _h                  = 0,
    _y0                 = 0,
    _h0                 = 0,
    _u0                 = 0,
    _v0                 = 0,
    _u1                 = 0,
    _v1                 = 0,
    _texture            = 0,
    _texture2           = 0,
    __w                 = 0,
    __h                 = 0
}

function COMPONENT:InvalidateLayout()

    self.invalid_layout = true

end

function COMPONENT:PerformLayout( force )

    if not force and not ( self.visible and self.invalid_layout ) then return end

    local scale = scale_Get()

    self._x, self._y = self.x * scale, self.y * scale

    local w, h = self.size * ( W / H ), self.size
    self._w, self._h = w * scale, h * scale
    self.__w, self.__h = w, h

    -- calculate size of the main foreground bar
    local offset = self._h * ( FOREGROUND_OFFSET / H )
    self._y0 = offset
    self._h0 = self._h - offset * 2

    if self.inverted then

        self._u0, self._v0, self._u1, self._v1 = 1, 0, 0, 1

    else

        self._u0, self._v0, self._u1, self._v1 = 0, 0, 1, 1

    end

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

function COMPONENT:SetInverted( inverted )

    if self.inverted == inverted then return end

    self.inverted = inverted

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetColor( color )

    self.color = color

end

function COMPONENT:SetColor2( color2 )

    self.color2 = color2

end

function COMPONENT:SetDrawFrame( frame )

    self.frame = frame

end

function COMPONENT:SetFrameColor( frame_color )

    self.frame_color = frame_color

end

function COMPONENT:SetValue( value )

    if self.value == value then return end

    self.value = value

    return true

end

function COMPONENT:SetMaxValue( max_value )

    if self.max_value == max_value then return end

    self.max_value = max_value

    return true

end

function COMPONENT:SetValue2( value2 )

    if self.value2 == value2 then return end

    self.value2 = value2

    return true

end

function COMPONENT:SetMaxValue2( max_value2 )

    if self.max_value2 == max_value2 then return end

    self.max_value2 = max_value2

    return true

end

function COMPONENT:Think()

    local speed = FrameTime() * self.lerp_speed

    self._value = Lerp( speed, self._value, math.Clamp( self.value / self.max_value, 0, 1 ) )
    self._value2 = Lerp( speed, self._value2, math.Clamp( self.value2 / self.max_value2, 0, 1 ) )

    self:PerformLayout()

end

function COMPONENT:PaintBackground( x, y )

    if not self.visible then return end
    if not self.frame then return end

    surface.SetTexture( RESOURCE_FRAME )
    surface.SetDrawColor( self.frame_color )
    surface.DrawTexturedRectUV( x + self._x, y + self._y, self._w, self._h, self._u0, self._v0, self._u1, self._v1 )

end

function COMPONENT:Paint( x, y )

    if not self.visible then return end

    local x, y = x + self._x, y + self._y
    local w, h = self._w, self._h

    util_StartStencilScissor( x, y + self._y0 + math.Round( self._h0 * ( 1 - self._value ) ), w, h )

    surface.SetTexture( RESOURCE_BAR )
    surface.SetDrawColor( self.color )
    surface.DrawTexturedRectUV( x, y, w, h, self._u0, self._v0, self._u1, self._v1 )

    util_EndStencilScissor()

    util_StartStencilScissor( x, y + math.Round( h * ( 1 - self._value2 ) ), w, h )

    surface.SetTexture( RESOURCE_BAR2 )
    surface.SetDrawColor( self.color2 )
    surface.DrawTexturedRectUV( x, y, w, h, self._u0, self._v0, self._u1, self._v1 )

    util_EndStencilScissor()

end

HOLOHUD2.component.Register( "QuickInfoBar", COMPONENT )