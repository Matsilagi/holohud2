local math = math
local surface = surface
local scale_Get = HOLOHUD2.scale.Get

local LABEL_FONT = "holohud2_component_gaugeguide"
HOLOHUD2.font.Register( LABEL_FONT, { font = "Tahoma", size = 6, weight = 1000, italic = false } )

local COMPONENT = {
    visible         = true,
    invalid_layout  = false,
    x               = 0,
    y               = 0,
    w               = 0,
    h               = 0,
    direction       = HOLOHUD2.DIRECTION_UP,
    color           = color_white,
    labels          = true,
    label1          = "E",
    label2          = "F",
    label3          = "1/2",
    graduation      = 3,
    _rects          = {},
    _labels         = {},
    _x              = 0,
    _y              = 0
}

function COMPONENT:InvalidateLayout()

    self.invalid_layout = true

end

function COMPONENT:PerformLayout()

    if not self.invalid_layout then return end

    local scale = scale_Get()
    self._x, self._y = math.Round( self.x * scale ), math.Round( self.y * scale )
    local w, h = math.Round( self.w * scale ), math.Round( self.h * scale )

    table.Empty( self._rects )
    table.Empty( self._labels )

    local top, bottom, left, right = self.direction == HOLOHUD2.DIRECTION_DOWN, self.direction == HOLOHUD2.DIRECTION_UP, self.direction == HOLOHUD2.DIRECTION_RIGHT, self.direction == HOLOHUD2.DIRECTION_LEFT
    
    surface.SetFont( LABEL_FONT )
    local size = math.max( math.Round( .5 * scale ), 1 )
    local w1, h1 = surface.GetTextSize( self.label1 )
    local w2, h2 = surface.GetTextSize( self.label2 )
    local w3, h3 = surface.GetTextSize( self.label3 )

    if top or bottom then

        local y = top and -h + size or size

        self._rects[ 1 ] = { x = 0, y = 0, w = w, h = size }
        self._rects[ 2 ] = { x = 0, y = y, w = size, h = h - size }
        self._rects[ 3 ] = { x = w - size, y = y, w = size, h = h - size }

        for i = 1, self.graduation do

            local h = h / 1.5 - size
            self._rects[ 3 + i ] = { x = i * w / ( self.graduation + 1 ), y = top and -h or size, w = size, h = h }
        
        end

        y = h + size
        if top then y = -y end

        self._labels[ self.label1 ] = { x = 1 - w1 / string.len( self.label1 ) / 2, y = y + ( top and -h1 or 0 ) }
        self._labels[ self.label2 ] = { x = w - w2 + w2 / string.len( self.label2 ) / 2, y = y + ( top and -h2 or 0 ) }
        self._labels[ self.label3 ]  = { x = w / 2 - w3 / 2, y = y + ( top and -h3 or 0 ) }
    
    elseif left or right then

        local x = left and -w + size or size

        self._rects[ 1 ] = { x = 0, y = 0, w = size, h = h }
        self._rects[ 2 ] = { x = x, y = 0, w = w - size, h = size }
        self._rects[ 3 ] = { x = x, y = h - size, w = w - size, h = size }

        for i = 1, self.graduation do

            local w = w / 1.5 - size
            self._rects[ 3 + i ] = { x = left and -w or size, y = i * h / ( self.graduation + 1 ), w = w, h = size }
        
        end

        x = w + size * 2
        if left then x = -x end

        self._labels[ self.label1 ] = { x = x + ( left and -w1 or 0 ), y = 1 - h1 / 2 }
        self._labels[ self.label2 ] = { x = x + ( left and -w2 or 0 ), y = h - 1 - h2 / 2 }
        self._labels[ self.label3 ] = { x = x + ( left and -w3 or 0 ), y = h / 2 - h3 / 2 }
    
    end

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

function COMPONENT:SetDirection( direction )

    if self.direction == direction then return end

    self.direction = direction
    self:InvalidateLayout()

    return true

end

function COMPONENT:SetColor( color )

    self.color = color

end

function COMPONENT:SetDrawLabels( labels )

    self.labels = labels

end

function COMPONENT:SetLabel1( label1 )

    if self.label1 == label1 then return end

    self.label1 = label1
    self:InvalidateLayout()

    return true

end

function COMPONENT:SetLabel2( label2 )

    if self.label2 == label2 then return end

    self.label2 = label2
    self:InvalidateLayout()

    return true

end

function COMPONENT:SetLabel3( label3 )

    if self.label3 == label3 then return end

    self.label3 = label3
    self:InvalidateLayout()

    return true

end

function COMPONENT:SetGraduation( graduation )

    if self.graduation == graduation then return end

    self.graduation = graduation
    self:InvalidateLayout()
    
    return true

end

function COMPONENT:Paint( x, y )

    if not self.visible then return end

    local x, y = x + self._x, y + self._y

    surface.SetDrawColor( self.color.r, self.color.g, self.color.b, self.color.a )
    
    for _, rect in ipairs( self._rects ) do
        surface.DrawRect( x + rect.x, y + rect.y, math.max( rect.w, 1 ), math.max( rect.h, 1 ) )
    end

    if not self.labels then return end

    surface.SetFont( LABEL_FONT )
    surface.SetTextColor( self.color.r, self.color.g, self.color.b, self.color.a )
    
    for text, label in pairs( self._labels ) do

        surface.SetTextPos( x + label.x, y + label.y )
        surface.DrawText( text )

    end
end

HOLOHUD2.component.Register( "Gauge", COMPONENT )