local math = math
local surface = surface
local scale_Get = HOLOHUD2.scale.Get

local COMPONENT = {
    visible         = true,
    invalid_layout  = false,
    x               = 0,
    y               = 0,
    size            = 0,
    color           = color_white,
    texture         = surface.GetTextureID( "debug/debugempty" ),
    w               = 0,
    h               = 0,
    u0              = 0,
    v0              = 0,
    u1              = 0,
    v1              = 0,
    _settexture     = surface.SetTexture,
    _x              = 0,
    _y              = 0,
    _w              = 0,
    _h              = 0,
    _u0             = 0,
    _v0             = 0,
    _u1             = 0,
    _v1             = 0,
    __w             = 0,
    __h             = 0
}

function COMPONENT:InvalidateLayout()

    self.invalid_layout = true

end

function COMPONENT:PerformLayout( force )

    if not force and not ( self.visible and self.invalid_layout ) then return end

    local u0, v0, u1, v1 = self.u0, self.v0, self.u1, self.v1

    -- local du = 0.5 / 32 -- half pixel anticorrection
    -- local dv = 0.5 / 32 -- half pixel anticorrection
    -- local u0, v0 = ( u0 - du ) / ( 1 - 2 * du ), ( v0 - dv ) / ( 1 - 2 * dv )
    -- local u1, v1 = ( u1 - du ) / ( 1 - 2 * du ), ( v1 - dv ) / ( 1 - 2 * dv )

    local w, h = self.size * ( u1 - u0 ) / ( v1 - v0 ), self.size

    local scale = scale_Get()
    self._x, self._y = self.x * scale, self.y * scale
    self._w, self._h = w * scale, h * scale

    self._u0, self._v0, self._u1, self._v1 = u0 / self.w, v0 / self.h, u1 / self.w, v1 / self.h
    self.__w, self.__h = w, h

    self._settexture = type( self.texture ) == "IMaterial" and surface.SetMaterial or surface.SetTexture

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

function COMPONENT:SetColor( color )

    self.color = color

end

function COMPONENT:SetTexture( texture, w, h, u0, v0, u1, v1 )

    if istable( texture ) then texture, w, h, u0, v0, u1, v1 = unpack( texture ) end

    self.texture    = texture
    self.w          = w
    self.h          = h
    self.u0         = u0 or 0
    self.v0         = v0 or 0
    self.u1         = u1 or w
    self.v1         = v1 or h

    self:InvalidateLayout()

end

function COMPONENT:GetSize()

    return self.__w, self.__h

end

function COMPONENT:Copy( parent )

    self:SetPos( parent.x, parent.y )
    self:SetSize( parent.size )
    self:SetTexture( parent.texture, parent.w, parent.h, parent.u0, parent.v0, parent.u1, parent.v1 )

end

function COMPONENT:Paint(x, y)

    if not self.visible then return end

    self._settexture( self.texture )
    surface.SetDrawColor( self.color.r, self.color.g, self.color.b, self.color.a )
    surface.DrawTexturedRectUV( x + self._x, y + self._y, self._w, self._h, self._u0, self._v0, self._u1, self._v1 )

end

HOLOHUD2.component.Register( "Icon", COMPONENT )