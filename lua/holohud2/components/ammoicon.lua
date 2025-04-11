local math = math
local surface = surface
local scale_Get = HOLOHUD2.scale.Get

local COMPONENT = {
    visible         = true,
    invalid_layout  = false,
    x               = 0,
    y               = 0,
    size            = 8,
    align           = TEXT_ALIGN_LEFT,
    angle           = 0,
    ammotype        = "none",
    color           = color_white,
    _x              = 0,
    _y              = 0,
    _w              = 0,
    _h              = 0,
    _texture        = surface.GetTextureID( "debug/debugempty" ),
    _settexture     = surface.SetTexture,
    __w             = 0,
    __h             = 0
}

function COMPONENT:InvalidateLayout()

    self.invalid_layout = true

end

function COMPONENT:PerformLayout( force )

    if not force and not ( self.visible and self.invalid_layout ) then return end

    local scale = scale_Get()

    local icon = HOLOHUD2.ammo.Get( self.ammotype )
    self._texture = icon.texture
    self._settexture = type( self._texture ) == "IMaterial" and surface.SetMaterial or surface.SetTexture

    -- calculate size
    local h = self.size * icon.icon_scale * ( icon.fileh / icon.h )
    local w = icon.filew / icon.fileh * h

    self._w, self._h = w * scale, h * scale

    -- calculate alignment offset
    local theta = math.rad( self.angle )
    local cos, sin = math.abs( math.cos( theta ) ), math.abs( math.sin( theta ) )
    local u, v = ( icon.w / icon.filew ) * w, ( icon.h / icon.fileh ) * h -- actual icon size
    local bx, by = u * cos + v * sin, u * sin + v * cos
    local x = self.align == TEXT_ALIGN_LEFT and bx / 2 or ( self.align == TEXT_ALIGN_RIGHT and -bx / 2 ) or 0

    self.__w, self.__h = bx, by

    self._x, self._y = ( self.x + x ) * scale, self.y * scale
    
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

function COMPONENT:SetAlign( align )

    if self.align == align then return end

    self.align = align
    self:InvalidateLayout()

    return true

end

function COMPONENT:SetColor( color )

    self.color = color

end

function COMPONENT:SetAngle( angle )

    if self.angle == angle then return end

    self.angle = angle
    self:InvalidateLayout()

    return true

end

function COMPONENT:SetAmmoType( ammotype )

    if self.ammotype == ammotype then return end

    self.ammotype = ammotype
    self:InvalidateLayout()

    return true

end

function COMPONENT:Copy( parent )

    self:SetPos( parent.x, parent.y )
    self:SetSize( parent.size )
    self:SetAngle( parent.angle )
    self:SetAmmoType( parent.ammotype )

end

function COMPONENT:GetSize()

    return self.__w, self.__h

end

function COMPONENT:Paint( x, y )

    if not self.visible then return end

    self._settexture( self._texture )
    surface.SetDrawColor( self.color.r, self.color.g, self.color.b, self.color.a )
    surface.DrawTexturedRectRotated( x + self._x, y + self._y, self._w, self._h, self.angle )

end

HOLOHUD2.component.Register( "AmmoIcon", COMPONENT )