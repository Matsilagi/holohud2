
local surface = surface
local scale_Get = HOLOHUD2.scale.Get

local COMPONENT = {
    visible         = true,
    invalid_layout  = false,
    x               = 0,
    y               = 0,
    w               = 0,
    h               = 0,
    color           = color_white,
    reversed        = false,
    _pieces         = {
        {
            x       = 0,
            y       = 0,
            w       = 0,
            h       = 0,
            u0      = 0,
            v0      = 0,
            u1      = 0,
            v1      = 0
        },
        {
            x       = 0,
            y       = 0,
            w       = 0,
            h       = 0,
            u0      = 0,
            v0      = 0,
            u1      = 0,
            v1      = 0
        },
        {
            x       = 0,
            y       = 0,
            w       = 0,
            h       = 0,
            u0      = 0,
            v0      = 0,
            u1      = 0,
            v1      = 0
        }
    },
    _count          = 2
}

local RESOURCE                      = surface.GetTextureID( "holohud2/bracket" )
local TEXTURE_WIDTH, TEXTURE_HEIGHT = 64, 128
local CORNER, HEIGHT                = 46, 108

function COMPONENT:InvalidateLayout()

    self.invalid_layout = true

end

function COMPONENT:PerformLayout( force )

    if not force and ( not self.visible or not self.invalid_layout ) then return end

    local scale = scale_Get()
    local ratio = self.w / TEXTURE_WIDTH
    local half = math.min( self.h, HEIGHT * ratio ) / 2
    local u0, u1 = 0, 1

    if self.reversed then

        u0, u1 = 1, 0

    end

    local x, y, w, h = math.Round( self.x * scale ), math.Round( self.y * scale ), math.Round( self.w * scale ), math.Round( self.h * scale )
    local half_scaled = math.Round( half * scale )

    local top = self._pieces[ 1 ]
    top.x, top.y = x, y
    top.w, top.h = w, half_scaled
    top.u0, top.v0, top.u1, top.v1 = u0, 0, u1, half / ( TEXTURE_HEIGHT * ratio )

    local bottom = self._pieces[ 2 ]
    bottom.x, bottom.y = x, y + ( h - half_scaled )
    bottom.w, bottom.h = w, half_scaled
    bottom.u0, bottom.v0, bottom.u1, bottom.v1 = u0, ( ( HEIGHT * ratio ) - half ) / ( TEXTURE_HEIGHT * ratio ), u1, HEIGHT / TEXTURE_HEIGHT

    if self.h < HEIGHT * ratio then

        self._count = 2
        self.invalid_layout = false
        return

    end

    local center = self._pieces[ 3 ]
    center.x, center.y = x, y + half_scaled
    center.w, center.h = w, h - ( half_scaled * 2 )
    center.u0, center.v0, center.u1, center.v1 = u0, CORNER / HEIGHT, u1, ( CORNER + 1 ) / HEIGHT

    self._count = 3
    self.invalid_layout = false

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

function COMPONENT:SetReversed( reversed )

    if self.reversed == reversed then return end

    self.reversed = reversed

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetColor( color )

    self.color = color

end

function COMPONENT:Paint( x, y )

    if not self.visible then return end

    surface.SetDrawColor( self.color.r, self.color.g, self.color.b, self.color.a )
    surface.SetTexture( RESOURCE )
    
    for i=1, self._count do

        local piece = self._pieces[ i ]

        surface.DrawTexturedRectUV( x + piece.x, y + piece.y, piece.w, piece.h, piece.u0, piece.v0, piece.u1, piece.v1 )

    end

end

HOLOHUD2.component.Register( "Bracket", COMPONENT )