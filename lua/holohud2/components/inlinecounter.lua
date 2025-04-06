
local COMPONENT = {
    invalid_layout      = false,
    x                   = 0,
    y                   = 0,
    align               = TEXT_ALIGN_LEFT,
    num_offset          = 0,
    num2_offset         = 0,
    separator_offset    = 0,
    spacing             = 0,
    _last_num_size      = 0,
    _last_num2_size     = 0,
    __w                 = 0,
    __h                 = 0
}

function COMPONENT:Init()

    self.Number = HOLOHUD2.component.Create( "Number" )
    self.Separator = HOLOHUD2.component.Create( "Separator" )
    self.Number2 = HOLOHUD2.component.Create( "Number" )

end

function COMPONENT:InvalidateLayout()

    self.invalid_layout = true

end

function COMPONENT:PerformLayout( force )

    if not self.invalid_layout and not force then return end

    self.Number:PerformLayout()
    self.Separator:PerformLayout()
    self.Number2:PerformLayout()

    local w = 0

    if self.Number.visible then

        w = self.Number.__w

    end

    if self.Separator.visible then
    
        if self.Number.visible then
            
            w = w + self.spacing
            
        end

        w = w + self.Separator.__w
    
    end

    if self.Number2.visible then
    
        if self.Separator.visible then
        
            w = w + self.spacing
        
        end

        w = w + self.Number2.__w
    
    end

    local x = self.x

    if self.align == TEXT_ALIGN_RIGHT then

        x = x - w

    elseif self.align == TEXT_ALIGN_CENTER then

        x = x - w / 2

    end

    self.Number:SetPos( x, self.y + self.num_offset )
    self.Separator:SetPos( self.Number.x + self.Number.__w + self.spacing, self.y + self.separator_offset )
    self.Number2:SetPos( self.Separator.x + self.Separator.__w + self.spacing, self.y + self.num2_offset )

    self._last_num_size = self.Number.__w
    self._last_num2_size = self.Number2.__w

    self.__w, self.__h = w, math.max( self.Number.visible and ( self.Number.y + self.Number.__h ) or 0, self.Separator.visible and ( self.Separator.y + self.Separator.h ) or 0, self.Number2.visible and ( self.Number2.y + self.Number2.__h ) or 0 ) - math.min( self.Number.visible and self.Number.y or 0, self.Number.visible and self.Separator.y or 0, self.Number.visible and self.Number2.y or 0 )

    return true

end

function COMPONENT:SetPos( x, y )

    if self.x == x and self.y == y then return end

    self.x = x
    self.y = y
    self:InvalidateLayout()

    return true

end

function COMPONENT:SetNumberOffset( offset )

    if self.num_offset == offset then return end

    self.num_offset = offset
    self:InvalidateLayout()

    return true

end

function COMPONENT:SetNumber2Offset( offset )

    if self.num2_offset == offset then return end

    self.num2_offset = offset
    self:InvalidateLayout()

    return true

end

function COMPONENT:SetSeparatorOffset( offset )

    if self.separator_offset == offset then return end

    self.separator_offset = offset
    self:InvalidateLayout()

    return true

end

function COMPONENT:SetSpacing( spacing )

    if self.spacing == spacing then return end

    self.spacing = spacing
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

    self.Number:SetColor( color )
    self.Number2:SetColor( color )
    self.Separator:SetColor( color )

end

function COMPONENT:SetColor2( color2 )

    self.Number:SetColor2( color2 )
    self.Number2:SetColor2( color2 )

end

function COMPONENT:SetValue( value )

    self.Number:SetValue( value )

end

function COMPONENT:SetMaxValue( value )

    self.Number2:SetValue( value )

end

function COMPONENT:Think()

    self.Number:PerformLayout()
    self.Separator:PerformLayout()
    self.Number2:PerformLayout()
    self:PerformLayout()

    if self.Number.__w ~= self._last_num_size or self.Number2.__w ~= self._last_num2_size then

        self:InvalidateLayout()

    end

end

function COMPONENT:PaintBackground( x, y )

    self.Number:PaintBackground( x, y )
    self.Number2:PaintBackground( x, y )

end

function COMPONENT:Paint( x, y )

    self.Number:Paint( x, y )
    self.Separator:Paint( x, y )
    self.Number2:Paint( x, y )

end

HOLOHUD2.component.Register( "InlineCounter", COMPONENT )