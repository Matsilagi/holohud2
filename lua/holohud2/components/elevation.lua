local math = math
local surface = surface
local scale_Get = HOLOHUD2.scale.Get

local BEARINGS = {}
for i = 0, 9 do

    BEARINGS[ i + 1 ]   = i * 10
    BEARINGS[ i + 10 ]  = 90 - i * 10
    BEARINGS[ i + 19 ]  = -i * 10
    BEARINGS[ i + 28 ]  = i * 10 - 90

end

local COMPONENT = {
    visible         = true,
    invalid_layout  = false,
    x               = 0,
    y               = 0,
    w               = 0,
    h               = 0,
    size            = 1,
    font            = "default",
    gap             = 3,
    color           = color_white,
    color2          = color_white,
    inverted        = false,
    angle           = 0,
    _bearings       = {},
    _thick          = 0,
    _len            = 0,
    _spacing        = 0, -- space between bearings
    _size           = 1, -- height of the visible compass
    _top            = 0, -- top of the visible compass
    _bottom         = 0, -- bottom of the visible compass
    _offset         = 0
}

function COMPONENT:InvalidateLayout()

    self.invalid_layout = true

end

function COMPONENT:PerformLayout( force )

    if not force and not ( self.visible and self.invalid_layout ) then return end

    local scale = scale_Get()
    local x, y = math.Round( self.x * scale ), math.Round( self.y * scale )
    local w, h = math.Round( self.w * scale ), math.Round( self.h * scale )
    local thick = math.max( math.Round( scale ), 1 ) -- dash size
    local gap = math.Round( self.gap * scale ) -- gap between number and dash
    local size = h / self.size -- height of the compass
    local spacing = size / #BEARINGS -- space between bearings

    surface.SetFont(self.font)
    local len = w - gap - math.Round( surface.GetTextSize( "-99" ) )

    self._top, self._bottom = y - spacing, y + h + spacing
    self._len, self._thick = len, thick
    self._size, self._spacing = size, spacing

    self._bearings = {}

    for i=1, #BEARINGS do

        local x, y = self.inverted and ( x + w - len ) or x, y + spacing * i - thick / 2
        
        -- in between graduation
        local between = {}
        if i < #BEARINGS then

            local spacing = spacing / 5

            for j = 1, 5 do

                between[ j ] = { x = x, y = y + spacing * j - thick / 2 }
                
            end

        end

        -- bearing
        local text = BEARINGS[ i ]
        local w, h = surface.GetTextSize( text )
        self._bearings[ i ] = { x = x, y = y, between = between, text = text, text_x = x + ( self.inverted and ( -gap - w ) or ( len + gap ) ), text_y = y - h / 2 }

    end

    self.invalid_layout = false
    return true

end

function COMPONENT:Think()

    self:PerformLayout()

    self._offset = self._spacing / 2 + self._size * ( self.angle + 180 * ( 1 - self.size ) ) / 360

end

function COMPONENT:SetVisible( visible )

    if self.visible == visible then return end

    self.visible = visible
    self:InvalidateLayout()

    return true

end

function COMPONENT:SetAngle( angle )

    self.angle = angle

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

function COMPONENT:SetCompassSize( size )

    if self.size == size then return end

    self.size = size
    self:InvalidateLayout()

    return true

end

function COMPONENT:SetFont( font )

    if self.font == font then return end

    self.font = font
    self:InvalidateLayout()

    return true

end

function COMPONENT:SetGap( gap )

    if self.gap == gap then return end

    self.gap = gap
    self:InvalidateLayout()

    return true

end

function COMPONENT:SetColor( color )

    self.color = color

end

function COMPONENT:SetColor2( color2 )

    self.color2 = color2

end

function COMPONENT:SetInverted( inverted )

    if self.inverted == inverted then return end

    self.inverted = inverted
    self:InvalidateLayout()
    
    return true

end

function COMPONENT:PaintBackground( x, y )

    local top, bottom = y + self._top, y + self._bottom
    local w, h = self._len, self._thick

    y = y - self._offset

    surface.SetDrawColor( self.color2 )

    for _, bearing in ipairs( self._bearings ) do

        if y + bearing.y < top or y + bearing.y > bottom then continue end

        for _, graduation in ipairs( bearing.between ) do

            surface.DrawRect( x + graduation.x, y + graduation.y, w, h )

        end

    end

end

function COMPONENT:Paint(x, y)

    local top, bottom = y + self._top, y + self._bottom
    local w, h = self._len, self._thick

    y = y - self._offset
    
    surface.SetFont( self.font )
    surface.SetTextColor( self.color )
    surface.SetDrawColor( self.color )

    for _, bearing in ipairs( self._bearings ) do

        if y + bearing.y < top or y + bearing.y > bottom then continue end

        surface.SetTextPos( x + bearing.text_x, y + bearing.text_y )
        surface.DrawText( bearing.text )
        surface.DrawRect( x + bearing.x, y + bearing.y, w, h )

    end

end

HOLOHUD2.component.Register( "Elevation", COMPONENT )