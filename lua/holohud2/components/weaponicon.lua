
local IsValid = IsValid
local surface = surface
local scale_Get = HOLOHUD2.scale.Get

local BUCKET_W, BUCKET_H = 140, 100

local COMPONENT = {
    visible         = true,
    invalid_layout  = false,
    x               = 0,
    y               = 0,
    size            = 0,
    color           = color_white,
    weapon          = nil,
    infobox         = false,
    bounce          = false,
    texture         = surface.GetTextureID( "debug/debugempty" ),
    w               = 0,
    h               = 0,
    scale           = 1,
    _settexture     = surface.SetTexture,
    _x              = 0,
    _y              = 0,
    _w              = 0,
    _h              = 0,
    __w             = 0,
    __h             = 0
}

function COMPONENT:InvalidateLayout()

    self.invalid_layout = true

end

function COMPONENT:PerformLayout( force )

    if not force and ( not self.visible or not self.invalid_layout ) then return end

    local w, h = self.size * self.scale, self.size * (self.h / self.w) * self.scale
    self.__w, self.__h = w, h

    local scale = scale_Get()
    self._x, self._y = (self.x - w / 2) * scale, (self.y - h / 2) * scale
    self._w, self._h = w * scale, h * scale

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

function COMPONENT:SetWeapon( weapon )

    if self.weapon == weapon then return end

    if IsValid( weapon ) and not HOLOHUD2.weapon.Has( weapon:GetClass() ) and weapon.DrawWeaponSelection then

        self.texture = nil
        self.w = BUCKET_W
        self.h = BUCKET_H
        self.scale = 1

    else

        self:SetClass( IsValid( weapon ) and weapon:GetClass() or "" )
        
    end

    self.weapon = weapon
    self:InvalidateLayout()

end

function COMPONENT:SetClass( class )

    local icon = HOLOHUD2.weapon.Get( class ) 
        
    self.texture = icon.texture
    self.w = icon.w
    self.h = icon.h
    self.scale = icon.scale

end

function COMPONENT:SetDrawInfoBox( infobox )

    self.infobox = infobox

end

function COMPONENT:SetBounce( bounce )

    self.bounce = bounce

end

function COMPONENT:GetSize()

    return self.__w, self.__h

end

function COMPONENT:PaintFrame( x, y )

    if self.texture or not IsValid( self.weapon ) then return end

    local bounce, infobox = self.weapon.BounceWeaponIcon, self.weapon.DrawWeaponInfoBox

    if not self.infobox then self.weapon.DrawWeaponInfoBox = false end
    if not self.bounce then self.weapon.BounceWeaponIcon = false end

    self.weapon:DrawWeaponSelection( x + self._x, y + self._y, self._w, self._h, self.color.a )

    self.weapon.DrawWeaponInfoBox = infobox
    self.weapon.BounceWeaponIcon = bounce

end

function COMPONENT:Paint(x, y)

    if not self.texture then return end

    surface.SetTexture( self.texture )
    surface.SetDrawColor( self.color.r, self.color.g, self.color.b, self.color.a )
    surface.DrawTexturedRect( x + self._x, y + self._y, self._w, self._h )

end

HOLOHUD2.component.Register( "WeaponSelectionIcon", COMPONENT )