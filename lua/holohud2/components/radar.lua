local math = math
local surface = surface
local CurTime = CurTime
local FrameTime = FrameTime
local scale_Get = HOLOHUD2.scale.Get
local hook_Call = HOLOHUD2.hook.Call

local RES_GRID      = surface.GetTextureID( "holohud2/radar/grid" )
local RES_FOV       = surface.GetTextureID( "holohud2/radar/fov" )
local RES_DOT       = surface.GetTextureID( "holohud2/radar/dot" )
local RES_DOT_ABOVE = surface.GetTextureID( "holohud2/radar/dot0" )
local RES_DOT_UNDER = surface.GetTextureID( "holohud2/radar/dot1" )

local DOT_SCALE = 8 / 128
local HEIGHT_DIFFERENCE = 128

local COMPONENT = {
    visible             = true,
    invalid_layout      = false,
    invalid_entities    = false,
    x                   = 0,
    y                   = 0,
    w                   = 0,
    h                   = 0,
    drawfov             = true,
    drawgrid            = true,
    drawcross           = true,
    origin              = Vector( 0, 0, 0 ),
    yaw                 = 0,
    range               = 1024,
    color               = color_white,
    color2              = color_white,
    colorfoe            = color_white,
    colorfriend         = color_white,
    entities            = {},
    drawsweep           = false,
    sweepdelay          = 1,
    sweeptime           = 1,
    sweepcolor          = color_white,
    _x                  = 0,
    _y                  = 0,
    _w                  = 0,
    _h                  = 0,
    _dotsize            = 8,
    _crossthickness     = 1,
    _entities           = {},
    _rangesqr           = 0,
    _sweepanim          = 0,
    _sweepsize          = 0,
    _lastsweep          = 0
}

function COMPONENT:InvalidateLayout()

    self.invalid_layout = true

end

function COMPONENT:InvalidateEntities()

    self.invalid_entities = true

end

function COMPONENT:PerformLayout( force )

    if not force and not ( self.visible and self.invalid_layout ) then return end

    local scale = scale_Get()
    self._x, self._y = math.Round( self.x * scale ), math.Round( self.y * scale )
    self._w, self._h = math.Round( self.w * scale ), math.Round( self.h * scale )
    self._dotsize = math.min( self._w, self._h ) * DOT_SCALE
    self._crossthickness = scale

    self.invalid_layout = false
    return true

end

function COMPONENT:AddBlip( pos, color )

    return table.insert( self._entities, { pos = pos or Vector( 0, 0, 0 ), x = 0, y = 0, color = color or color_white, texture = RES_DOT, alpha = 0 } )

end

local _cache = Vector( 0, 0, 0 )
function COMPONENT:RefreshBlips()

    if not self.invalid_entities then return end

    self._entities = {}

    for _, ent in ipairs( self.entities ) do

        if not IsValid( ent ) then continue end

        -- apply a certain height to the target
        local pos = ent:GetPos()
        _cache:SetUnpacked( pos.x, pos.y, pos.z + 32 )

        -- do nothing if it's too far away
        if self.origin:DistToSqr( _cache ) > self._rangesqr then continue end

        -- store position and colour
        local class = ent:GetClass()
        local color = hook_Call( "GetRadarBlipColor", ent ) or ( ent:IsPlayer() and team.GetColor( ent:Team() ) ) or ( IsEnemyEntityName( class ) and self.colorfoe ) or ( IsFriendEntityName( class ) and self.colorfriend ) or self.color
        self:AddBlip( pos, color )
    
    end

    self.invalid_entities = false

end

function COMPONENT:Think()

    if not self.visible then return end

    self:PerformLayout()
    self:RefreshBlips()

    -- do sweep animation
    if self.sweep and self.sweepdelay > 0 then

        self._sweepanim = math.min( self._sweepanim + FrameTime() / self.sweeptime, 1 )
        self._sweepsize = math.max( self._w, self._h ) / 2 * self._sweepanim

        -- reset animation
        local curtime = CurTime()
        if self._lastsweep < curtime then

            self._sweepanim = 0
            self._sweepsize = 0
            self._lastsweep = curtime + self.sweepdelay

        end

    end

    -- read entities
    local radius = math.max( self._w, self._h ) / 2
    local angle = math.rad( self.yaw - 90 )
    local cos, sin = math.cos( angle ), math.sin( angle )

    for _, blip in ipairs( self._entities ) do

        local pos = blip.pos
        local heightdiff = pos.z - self.origin.z

        pos = ( self.origin - pos ) / self.range

        blip.x = -(cos * pos.x * radius + sin * pos.y * radius)
        blip.y = cos * pos.y * radius - sin * pos.x * radius
        blip.texture = (heightdiff < -HEIGHT_DIFFERENCE and RES_DOT_UNDER) or (heightdiff > HEIGHT_DIFFERENCE and RES_DOT_ABOVE) or RES_DOT
        blip.alpha = math.abs(heightdiff) > HEIGHT_DIFFERENCE and .8 * (1 - math.abs(heightdiff / math.max(self.range - HEIGHT_DIFFERENCE, 1))) or 1

    end

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

function COMPONENT:SetOrigin( origin )

    self.origin = origin

end

function COMPONENT:SetYaw( yaw )

    self.yaw = yaw

end

function COMPONENT:SetRange( range )

    self.range = range
    self._rangesqr = range * range

end

function COMPONENT:SetColor( color )

    self.color = color

end

function COMPONENT:SetColor2( color2 )

    self.color2 = color2

end

function COMPONENT:SetDrawFOV( drawfov )

    self.drawfov = drawfov

end

function COMPONENT:SetDrawGrid( drawgrid )

    self.drawgrid = drawgrid

end

function COMPONENT:SetDrawCross( drawcross )

    self.drawcross = drawcross

end

function COMPONENT:SetFoeColor( colorfoe )

    self.colorfoe = colorfoe

end

function COMPONENT:SetFriendColor( colorfriend )

    self.colorfriend = colorfriend

end

function COMPONENT:SetEntities( entities )

    self.entities = entities
    self:InvalidateEntities()

end

function COMPONENT:SetDrawSweep( sweep )

    self.sweep = sweep

end

function COMPONENT:SetSweepDelay( sweepdelay )

    self.sweepdelay = sweepdelay

end

function COMPONENT:SetSweepTime( sweeptime )

    self.sweeptime = sweeptime

end

function COMPONENT:SetSweepColor( sweepcolor )

    self.sweepcolor = sweepcolor

end

function COMPONENT:PaintBackground( x, y )

    if not self.visible then return end

    local x, y = x + self._x, y + self._y
    local w, h = self._w, self._h
    
    -- draw grid
    if self.drawgrid then

        surface.SetDrawColor( self.color2.r, self.color2.g, self.color2.b, self.color2.a * .3 )
        surface.SetTexture( RES_GRID )
        surface.DrawTexturedRectUV( x, y, w, h, 0, 0, w / 8, h / 8 )

    end

    -- draw cross
    if self.drawcross then

        surface.SetDrawColor( self.color2.r, self.color2.g, self.color2.b, self.color2.a * .6 )
        surface.DrawRect( x + w / 2, y, self._crossthickness, h )
        surface.DrawRect( x, y + h / 2, w, self._crossthickness )
        
    end

    -- draw fov
    if self.drawfov then

        surface.SetDrawColor( self.color2.r, self.color2.g, self.color2.b, self.color2.a )
        surface.SetTexture( RES_FOV )
        surface.DrawTexturedRect( x, y, w, h )

    end

    if not self.sweep or self.sweepdelay <= 0 then return end

    -- draw sweep circle
    surface.DrawCircle( x + w / 2, y + h / 2, self._sweepsize, self.sweepcolor.r, self.sweepcolor.g, self.sweepcolor.b, self.sweepcolor.a * ( 1 - self._sweepanim ) )

end

function COMPONENT:Paint( x, y )
    
    if not self.visible then return end
    
    local w, h = self._w, self._h
    local x, y = x + self._x + w / 2, y + self._y + h / 2 -- centered blips
    local size = self._dotsize

    for _, blip in ipairs(self._entities) do

        local x, y = x + blip.x - size / 2, y + blip.y - size / 2

        surface.SetDrawColor( blip.color.r, blip.color.g, blip.color.b, blip.color.a * blip.alpha )
        surface.SetTexture( blip.texture )
        surface.DrawTexturedRect( x, y, size, size )

    end

end

HOLOHUD2.component.Register( "Radar", COMPONENT )