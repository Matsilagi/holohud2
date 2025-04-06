local math = math
local surface = surface
local scale_Get = HOLOHUD2.scale.Get

local GROWDIRECTION_DOWN                = HOLOHUD2.GROWDIRECTION_DOWN
local GROWDIRECTION_CENTER_HORIZONTAL   = HOLOHUD2.GROWDIRECTION_CENTER_HORIZONTAL
local GROWDIRECTION_CENTER_VERTICAL     = HOLOHUD2.GROWDIRECTION_CENTER_VERTICAL
local GROWDIRECTION_LEFT                = HOLOHUD2.GROWDIRECTION_LEFT
local GROWDIRECTION_RIGHT               = HOLOHUD2.GROWDIRECTION_RIGHT
local GROWDIRECTION_UP                  = HOLOHUD2.GROWDIRECTION_UP

local AMOUNT_FONT    = "holohud2_component_dotline"
HOLOHUD2.font.Register( AMOUNT_FONT, { font = "Tahoma", size = 6, weight = 1000, italic = false } )

local COMPONENT = {
    invalid_layout  = false,
    visible         = true,
    x               = 0,
    y               = 0,
    size            = 8,
    dots            = 0,
    direction       = GROWDIRECTION_LEFT,
    color           = color_white,
    _dots           = {},
    _amount         = "x0",
    _ax             = 0,
    _ay             = 0,
    __w             = 0,
    __h             = 0
}

local MAX_DOTS  = 10

function COMPONENT:InvalidateLayout()

    self.invalid_layout = true

end

function COMPONENT:PerformLayout(force)

    if not force and not ( self.visible and self.invalid_layout ) then return end
    
    local scale = scale_Get()
    local x, y = self.x * scale, self.y * scale
    local size = self.size * scale
    local margin = math.ceil( size / 8 )

    -- calculate amount label size and position
    self._amount = "x" .. HOLOHUD2.util.ShortenNumber( self.dots )
    surface.SetFont( AMOUNT_FONT )
    local ax, ay = 0, 0
    local aw, ah = surface.GetTextSize( self._amount )

    -- calculate direction to grow towards
    local u, v, w, h = 0, 0, 0, 0

    if self.direction == GROWDIRECTION_RIGHT then

        w = size
        ax, ay = size, size - margin - ah

    elseif self.direction == GROWDIRECTION_LEFT then

        w = -size
        ax, ay = -size - aw, size - margin - ah

    elseif self.direction == GROWDIRECTION_DOWN then

        h = size
        ax, ay = -size / 2 + aw / 2, size

    elseif self.direction == GROWDIRECTION_UP then

        h = -size
        ax, ay = -size / 2 + aw / 2, -ah

    elseif self.direction == GROWDIRECTION_CENTER_HORIZONTAL then

        u = -math.Round(size * self.dots / 2)
        w = size
        ax, ay = -size / 2 + aw / 2, -ah

    elseif self.direction == GROWDIRECTION_CENTER_VERTICAL then

        v = -math.Round(size * self.dots / 2)
        h = size
        ax, ay = size, size - margin - ah

    end

    -- place amount label
    self._ax = x + ax
    self._ay = y + ay

    -- generate dot positions
    self._dots = {}

    for i=1, math.min( self.dots, MAX_DOTS ) do -- NOTE: this is necessary to avoid crashes when there are too many dots

        self._dots[i] = {

            x       = x + u + w * ( i - 1 ),
            y       = y + v + h * ( i - 1 ),
            size    = size - margin * 2

        }

    end

    -- calculate size
    if self.direction < GROWDIRECTION_UP then
        
        self._w, self._h = size * ( self.dots - 1 ), size

    else

        self._w, self._h = size, size * ( self.dots - 1 )

    end

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

function COMPONENT:SetDots( dots )

    if self.dots == dots then return end

    self.dots = dots
    self:InvalidateLayout()

    return true

end

function COMPONENT:SetGrowDirection( direction )

    if self.direction == direction then return end

    self.direction = direction
    self:InvalidateLayout()
    
    return true

end

function COMPONENT:SetColor( color )

    self.color = color

end

function COMPONENT:Paint( x, y )

    if #self._dots == 0 then return end

    surface.SetDrawColor( self.color.r, self.color.g, self.color.b, self.color.a )

    if self.dots > MAX_DOTS then
        
        local dot = self._dots[ 1 ]
        surface.DrawRect( x + dot.x, y + dot.y, dot.size, dot.size )

        surface.SetFont( AMOUNT_FONT )
        surface.SetTextColor( self.color.r, self.color.g, self.color.b, self.color.a )
        surface.SetTextPos( x + self._ax, y + self._ay )
        surface.DrawText( self._amount )

        return

    end

    for i=1, #self._dots do

        local dot = self._dots [ i ]
        surface.DrawRect( x + dot.x, y + dot.y, dot.size, dot.size )

    end

end

HOLOHUD2.component.Register( "DotLine", COMPONENT )