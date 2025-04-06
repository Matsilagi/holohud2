local math = math
local surface = surface
local draw = draw
local scale_Get = HOLOHUD2.scale.Get

local COMPONENT = {
    visible         = true,
    invalid_layout  = false,
    x               = 0,
    y               = 0,
    text            = "",
    font            = "default",
    color           = color_white,
    align           = TEXT_ALIGN_LEFT,
    charsvisible    = -1,
    _text           = "",
    _x              = 0,
    _y              = 0,
    _w              = 0,
    _h              = 0,
    __w             = 0, -- unscaled width
    __h             = 0 -- unscaled height
}

function COMPONENT:InvalidateLayout()

    self.invalid_layout = true

end

function COMPONENT:PerformLayout( force )

    if not force and not ( self.visible and self.invalid_layout ) then return end

    local scale = scale_Get()
    local x, y = math.Round( self.x * scale ), math.Round( self.y * scale )

    surface.SetFont( self.font )
    local w, h = surface.GetTextSize( self.text )

    if self.align == TEXT_ALIGN_CENTER then
        
        x = x - math.Round( w / 2 )

    elseif self.align == TEXT_ALIGN_RIGHT then

        x = x - w

    end

    self._x, self._y = x, y
    self._w, self._h = w, h
    self.__w, self.__h = w / scale, h / scale
    -- self.__w, self.__h = math.Round( w / scale ), math.Round( h / scale )

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

function COMPONENT:SetText( text )

    if self.text == text then return end

    self.text = language.GetPhrase( text )
    self._text = self.text

    if self.charsvisible > -1 then
        
        self._text = utf8.sub( self.text, 1, self.charsvisible )
    
    end
    
    self:InvalidateLayout()
    
    return true

end

function COMPONENT:SetFont( font )

    if self.font == font then return end

    self.font = font
    self:InvalidateLayout()

    return true

end

function COMPONENT:SetColor( color )

    self.color = color

    return true

end

function COMPONENT:SetAlign( align )

    if self.align == align then return end

    self.align = align
    self:InvalidateLayout()

    return true

end

function COMPONENT:SetCharsVisible( charsvisible )

    if charsvisible == self.charsvisible then return end

    self.charsvisible = charsvisible

    if self.charsvisible <= -1 then
        
        self._text = self.text
        return true
    
    end

    self._text = utf8.sub( self.text, 1, self.charsvisible )

    return true

end

function COMPONENT:GetSize()

    return self.__w, self.__h

end

function COMPONENT:Paint( x, y )

    if not self.visible then return end

    x, y = x + self._x, y + self._y
    
    -- surface.SetTextColor( self.color.r, self.color.g, self.color.b, self.color.a )
    -- surface.SetFont( self.font )
    -- surface.SetTextPos( x, y )
    -- surface.DrawText( self._text )
    draw.DrawText( self._text, self.font, x, y, self.color )
    
end

HOLOHUD2.component.Register( "Text", COMPONENT )