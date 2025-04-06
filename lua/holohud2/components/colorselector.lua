local math = math
local table = table

local COMPONENT = {
    color       = Color( 255, 255, 255, 255 ),
    colors      = {},
    fraction    = false,
    gradual     = false,
    value       = 0,
    max_value   = 1,
    _ranges     = {},
    _cur        = 0,
    _prev       = 0
}

function COMPONENT:SetColors( colors )

    self.colors     = colors.colors
    self.fraction   = colors.fraction
    self.gradual    = colors.gradual
    self._ranges    = table.GetKeys( self.colors )
    table.sort( self._ranges )

    self:FetchColor()

    if self.gradual then self:OnValueChanged() end

end

function COMPONENT:SetValue( value )

    if self.value == value then return end

    self.value = value

    self:OnValueChanged()

end

function COMPONENT:SetMaxValue( max_value )

    if self.max_value == max_value then return end

    self.max_value = max_value

    self:OnValueChanged()

end

function COMPONENT:FetchColor()
    
    local value = ( self.fraction and ( self.value / self.max_value ) * 100 ) or self.value

    for i, range in pairs( self._ranges ) do
        
        local color = self.colors[ range ]

        -- avoid going out of bounds
        if i <= 1 then
            
            self._cur = math.min( i + 1, #self._ranges )
            self._prev = i

        else

            self._cur = range
            self._prev = self._ranges[ math.max( i - 1, 1 ) ]

        end

        self.color:SetUnpacked( color.r, color.g, color.b, color.a )

        -- we found the range of this value
        if value <= range then break end

    end

    self:OnColorChanged( self.color )

end

function COMPONENT:OnValueChanged()
    
    local value = ( self.fraction and ( self.value / self.max_value ) * 100 ) or self.value

    -- if we changed ranges, fetch a new color
    if self._prev ~= self._cur and ( value <= self._prev or value > self._cur ) then
        
        self:FetchColor()

    end

    -- if it's a gradual selector, find a color in between of the two colors at the end of the current range
    if not self.gradual or not self.colors[ self._prev ] or not self.colors[ self._cur ] then return end

    local amount = math.Clamp( ( value - self._prev ) / ( self._cur - self._prev ), 0, 1 )

    for i, _ in pairs( self.color ) do
        
        self.color[ i ] = self.colors[ self._prev ][ i ] * ( 1 - amount ) + self.colors[ self._cur ][ i ] * amount

    end

    self:OnColorChanged( self.color )

end

function COMPONENT:GetColor()

    return self.color

end

function COMPONENT:OnColorChanged( color ) end

HOLOHUD2.component.Register( "ColorSelector", COMPONENT )