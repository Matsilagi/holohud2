local math = math
local surface = surface
local render = render
local FrameTime = FrameTime
local scale_Get = HOLOHUD2.scale.Get

local quality = CreateClientConVar( "holohud2_draw_graphquality", 1, true, false, "Sets the quality of graphs.", 0, 1 )

local COMPONENT = {
    visible         = true,
    invalid_layout  = false,
    x               = 0,
    y               = 0,
    w               = 0,
    h               = 0,
    color           = color_white,
    rate            = .15,
    margin          = 3,
    inverted        = false,
    value           = 0,
    random          = .1,
    _x              = 0,
    _y              = 0,
    _w              = 0,
    _h              = 0,
    _dir            = 1,
    _margin         = 0,
    _lastquality    = 1,
    _cache          = {}
}

function COMPONENT:Init()

    self._cache = {}

end

function COMPONENT:InvalidateLayout()

    self.invalid_layout = true

end

function COMPONENT:PerformLayout( force )

    if not force and not ( self.visible and self.invalid_layout ) then return end
    
    local scale = scale_Get()
    self._w, self._h = math.Round( self.w * scale ), math.Round( self.h * scale )
    self._x, self._y = math.Round( self.x * scale ), math.Round( self.y * scale )

    local margin = self.margin + ( self.w / 2 - self.margin ) * ( 1 - quality:GetFloat() )
    self._margin = math.Round( margin * scale )

    self._dir = self.inverted and -1 or 1

    return true
end

function COMPONENT:Add()

    local limit = self.random * 2
    local value = limit + self.value * ( 1 - limit * 2 ) + math.Rand( -self.random, self.random )
    table.insert( self._cache, { x = 0, y = self._h * ( 1 - value ) } )

end

function COMPONENT:Think()

    if not self.visible then return end

    self:PerformLayout()

    -- if empty, add the first point
    if #self._cache <= 0 then self:Add() return end

    -- if the last point has fully shown, add the next one
    if self._cache[ #self._cache ].x >= self._margin then self:Add() end

    -- move all points
    local delta = FrameTime()
    local speed = self.margin / self.rate * delta * scale_Get() -- NOTE: we can't use _margin here because it takes quality into account
    
    for i, point in ipairs(self._cache) do

        point.x = point.x + speed

        if point.x >= self._w + self._margin * 2 then

            table.remove(self._cache, i)

        end

    end

    -- invalidate layout if the quality changes
    local quality = quality:GetFloat()
    if self._lastquality ~= quality then

        self:InvalidateLayout()
        self._lastquality = quality

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

function COMPONENT:SetColor( color )

    self.color = color

end

function COMPONENT:SetRate( rate )

    self.rate = rate

end

function COMPONENT:SetMargin( margin )

    if self.margin == margin then return end

    self.margin = margin
    self:InvalidateLayout()
    
    return true

end

function COMPONENT:SetInverted( inverted )

    self.inverted = inverted

end

function COMPONENT:SetValue( value )

    self.value = value

end

function COMPONENT:SetRandom( random )

    self.random = random

end

function COMPONENT:Paint( x, y )
    
    if not self.visible then return end

    local w, h = self._w, self._h
    local x, y = x + self._x, y + self._y
    local dir = self._dir

    render.SetStencilWriteMask( 0xFF )
    render.SetStencilTestMask( 0xFF )
    render.SetStencilReferenceValue( 0 )
    render.SetStencilPassOperation( STENCIL_KEEP )
    render.SetStencilZFailOperation( STENCIL_KEEP )
    render.ClearStencil()

    render.SetStencilEnable( true )
    render.SetStencilReferenceValue( 1 )
    render.SetStencilCompareFunction( STENCIL_NEVER )
    render.SetStencilFailOperation( STENCIL_REPLACE )

    surface.SetDrawColor( 255, 255, 255 )
    surface.DrawRect( x, y, w, h )

    render.SetStencilCompareFunction( STENCIL_EQUAL )
    render.SetStencilFailOperation( STENCIL_KEEP )

    x = x + ( self.inverted and ( w + self._margin ) or -self._margin )

    surface.SetDrawColor( self.color.r, self.color.g, self.color.b, self.color.a )

    for i, point in ipairs( self._cache ) do

        if i == 1 then continue end

        local prev = self._cache[ i - 1 ]
        surface.DrawLine( x + point.x * dir, y + point.y, x + prev.x * dir, y + prev.y )
    
    end

    render.SetStencilEnable( false )

end

HOLOHUD2.component.Register( "Graph", COMPONENT )