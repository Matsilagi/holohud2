local math = math
local surface = surface
local FrameTime = FrameTime
local scale_Get = HOLOHUD2.scale.Get

local DIRECTION_UP      = HOLOHUD2.DIRECTION_UP
local DIRECTION_DOWN    = HOLOHUD2.DIRECTION_DOWN
local DIRECTION_LEFT    = HOLOHUD2.DIRECTION_LEFT
local DIRECTION_RIGHT   = HOLOHUD2.DIRECTION_RIGHT

local COMPONENT = {
    visible         = true,
    invalid_layout  = false,
    x               = 0,
    y               = 0,
    w               = 0,
    h               = 0,
    value           = 0,
    max_value       = 1,
    ammotype        = 0,
    color           = color_white,
    color2          = color_white,
    direction       = DIRECTION_RIGHT,
    attack_time     = .06,
    reload_time     = .2,
    _x              = 0,
    _y              = 0,
    _w              = 0,
    _h              = 0,
    _iconw          = 0,
    _iconh          = 0,
    _dirx           = 0, -- horizontal direction of the bullets
    _diry           = 0, -- vertical direction of the bullets
    _marginx        = 0, -- horizontal margin kept between bullets
    _marginy        = 0, -- vertical margin kept between bullets
    _count          = 0, -- how many bullets fit
    _angle          = 0,
    _texture        = surface.GetTextureID('debug/debugempty'),
    _reload         = 0, -- reload animation
    _attack         = 0, -- attack animation
    _attacking      = false, -- attack animation is playing
    _singlereload   = false, -- single reload animation is playing
    _extrabullet    = 0, -- extra bullet to compensate certain animations
    _firstbullet    = 0 -- first bullet in tray
}

function COMPONENT:InvalidateLayout()

    self.invalid_layout = true

end


function COMPONENT:PerformLayout( force )

    if not force and not ( self.visible and self.invalid_layout ) then return end

    local is_vertical = self.direction < DIRECTION_LEFT

    local icon = HOLOHUD2.ammo.Get( self.ammotype )

    local angle = is_vertical and icon.tray_angle_y or icon.tray_angle_x -- angle in tray
    local scale = is_vertical and icon.tray_scale_y or icon.tray_scale_x -- scale of the icon

    -- calculate icon size
    local theta = math.rad( angle )
    local cos, sin = math.abs( math.cos( theta ) ), math.abs( math.sin( theta ) )
    local ratio = self.h / ( sin * icon.w + cos * icon.h ) -- size of the bounding box depending on tray height
    if is_vertical then ratio = self.w / ( sin * icon.h + cos * icon.w ) end
    local w0, h0 = icon.w * ratio * ( icon.filew / icon.w ) * scale, icon.h * ratio * ( icon.fileh / icon.h ) * scale -- texture dimensions
    local w1, h1 = icon.w * ratio * scale, icon.h * ratio * scale -- actual icon size
    
    -- get scaled sizes
    local scale = scale_Get()
    self._x, self._y = self.x * scale, self.y * scale
    self._w, self._h = self.w * scale, self.h * scale
    self._iconw, self._iconh = w0 * scale, h0 * scale
    local bx, by = ( w1 * cos + h1 * sin ) * scale, ( w1 * sin + h1 * cos ) * scale -- scaled bounding box
    self.bx, self.by = bx, by

    -- calculate direction and offset
    if self.direction == DIRECTION_RIGHT then

        self._dirx, self._diry = 1, 0
        self._x = self._x + bx / 2
        self._y = self._y + self._h / 2
        self._firstbullet = 0

    elseif self.direction == DIRECTION_LEFT then

        self._dirx, self._diry = -1, 0
        self._x = self._x - bx / 2
        self._y = self._y + self._h / 2
        self._firstbullet = 1

    elseif self.direction == DIRECTION_UP then

        self._dirx, self._diry = 0, -1
        self._x = self._x + self._w / 2
        self._y = self._y - by / 2
        self._firstbullet = 0

    elseif self.direction == DIRECTION_DOWN then

        self._dirx, self._diry = 0, 1
        self._x = self._x + self._w / 2
        self._y = self._y + by / 2
        self._firstbullet = 1

    end
    
    -- calculate how many bullets fit
    if not is_vertical then

        self._marginx, self._marginy = math.Round( bx * icon.tray_margin_x ), 0
        self._count = math.floor( ( self._w - ( bx - self._marginx ) ) / self._marginx )

    else

        self._marginx, self._marginy = 0, math.Round( by * icon.tray_margin_y )
        self._count = math.floor( ( self._h - ( by - self._marginy ) ) / self._marginy )

    end

    self._marginx, self._marginy = self._marginx * self._dirx, self._marginy * self._diry

    self._texture = icon.texture
    self._angle = angle

    self.invalid_layout = false
    return true

end

function COMPONENT:Think()

    if not self.visible then return end
    
    local frametime = FrameTime()

    -- reload animation
    self._reload = math.max( self._reload - frametime / self.reload_time, 0 )

    -- attack (or single reload) animation
    if self._attacking then

        self._attack = math.min( self._attack + frametime / self.attack_time, 1 )

        if self._attack >= 1 then

            self._attack = 0
            self._attacking = false
            self._extrabullet = 0

        else

            self._extrabullet = 1

        end

    elseif self._singlereload then

        self._attack = math.max( self._attack - frametime / self.reload_time, 0 )

        if self._attack <= 0 then
            
            self._singlereload = false
        
        end

    end

    self:PerformLayout()
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

function COMPONENT:SetSize( w, h )

    if self.w == w and self.h == h then return end

    self.w = w
    self.h = h
    self:InvalidateLayout()

    return true

end

function COMPONENT:SetValue( value )

    self.value = value

end

function COMPONENT:SetMaxValue( max_value )

    self.max_value = max_value

end

function COMPONENT:SetAmmoType(ammotype)

    if self.ammotype == ammotype then return end

    self.ammotype = ammotype
    self:InvalidateLayout()

    return true
end

function COMPONENT:SetColor(color)

    self.color = color

end

function COMPONENT:SetColor2(color2)

    self.color2 = color2

end

function COMPONENT:SetDirection( direction )

    if self.direction == direction then return end

    self.direction = direction
    self:InvalidateLayout()
    
    return true

end

function COMPONENT:SetAttackDuration( time )

    self.attack_time = time

end

function COMPONENT:SetReloadDuration( time )

    self.reload_time = time

end

function COMPONENT:Attack()

    self._singlereload = false -- cancel single reload animation
    self._attack = 0 -- reset animation for fast weapons
    self._attacking = true

end

function COMPONENT:Reload( single )

    if single then

        self._attacking = false -- cancel attack animation
        self._attack = 1 -- reverse animation
        self._singlereload = true
        return

    end

    self._reload = 1

end

function COMPONENT:PaintBackground( x, y )

    if not self.visible then return end

    x, y = x + self._x, y + self._y
    
    if self.direction < DIRECTION_LEFT then

        y = y + self._h * self._diry * self._reload

    else

        x = x + self._w * self._dirx * self._reload

    end
    
    surface.SetTexture( self._texture )
    surface.SetDrawColor( self.color2 )

    for i = self.max_value + 1, self._count do

        local i = i - 1
        surface.DrawTexturedRectRotated( x + self._marginx * i, y + self._marginy * i, self._iconw, self._iconh, self._angle )
    
    end

end

function COMPONENT:Paint( x, y )

    if not self.visible then return end

    x, y = x + self._x - self._marginx * self._attack, y + self._y - self._marginy * self._attack
    
    if self.direction < DIRECTION_LEFT then

        y = y + self._h * self._diry * self._reload

    else

        x = x + self._w * self._dirx * self._reload

    end

    local bullets = math.min( self._count, self.value ) + self._extrabullet
    local first = math.max( bullets * self._firstbullet, 0 )
    
    surface.SetTexture( self._texture )

    for i = 1, bullets do

        local i = i - 1
        surface.SetDrawColor( self.color.r, self.color.g, self.color.b, self.color.a * ( i == first and ( 1 - self._attack ) or 1 ) )
        surface.DrawTexturedRectRotated( x + self._marginx * i, y + self._marginy * i, self._iconw, self._iconh, self._angle )
    
    end

end

HOLOHUD2.component.Register( "AmmoTray", COMPONENT )