-- TODO: consider using a different font for abbreviations

local math = math
local surface = surface
local scale_Get = HOLOHUD2.scale.Get

local NUMBERBACKGROUND_NONE         = 1
local NUMBERBACKGROUND_SIMPLE       = 2
local NUMBERBACKGROUND_DIGITAL      = 3
local NUMBERBACKGROUND_EXPENSIVE    = 4
local NUMBERBACKGROUNDS = {
    "#holohud2.option.number_background_0",
    "#holohud2.option.number_background_1",
    "#holohud2.option.number_background_2",
    "#holohud2.option.number_background_3"
}

local NUMBERRENDERMODE_STATIC       = 1
local NUMBERRENDERMODE_LEADINGZEROS = 2
local NUMBERRENDERMODE_MODERN       = 3
local NUMBERRENDERMODES = {
    "#holohud2.option.number_rendermode_0",
    "#holohud2.option.number_rendermode_1",
    "#holohud2.option.number_rendermode_2"
}

local BACKGROUND_SIMPLE, BACKGROUND_DIGITAL, BACKGROUND_EXPENSIVE = '0', '8', { '0', '1', '2', '3' }

local expensivedigits       = CreateClientConVar( "holohud2_draw_expensivedigits", 1, true, false, "Allow servers to enforce expensive digits background.", 0, 1 )
local shortnumbers_decimals = GetConVar( "holohud2_shortnumbers_decimals" )

local COMPONENT = {
    visible             = true,
    invalid_layout      = false,
    value               = 0,
    x                   = 0,
    y                   = 0,
    font                = "default",
    color               = color_white,
    color2              = color_white,
    align               = TEXT_ALIGN_RIGHT,
    digits              = 3,
    mode                = NUMBERRENDERMODE_STATIC,
    background          = NUMBERBACKGROUND_SIMPLE,
    abbr_override       = false,
    _value              = '',
    -- _abbreviation       = nil,
    _background         = '',
    _expensive          = {}, -- expensive background layers
    _x0                 = 0,
    _x1                 = 0,
    _x2                 = 0,
    _y                  = 0,
    _w                  = 0,
    _h                  = 0,
    _paintbackground    = function() end, -- function used when rendering the background
    __w                 = 0,
    __h                 = 0,
    __defaultsize       = 0,
}

function COMPONENT:InvalidateLayout()

    self.invalid_layout = true

end

local format = { "%0", 3, "d" }
function COMPONENT:PerformLayout( force )

    if not force and not ( self.visible and self.invalid_layout ) then return end
    
    local value, abbreviation = self.value, nil

    -- format number
    if not self.abbr_override then
        
        value, abbreviation = HOLOHUD2.util.ShortenNumber( self.value, true )
        self._abbreviation = abbreviation

    end

    -- add leading zeros
    if self.mode == NUMBERRENDERMODE_LEADINGZEROS and not abbreviation then

        format[ 2 ] = self.digits
        self._value = string.format( table.concat( format ), value )

    else

        self._value = value

    end

    -- build background
    local len = string.len( self._value )
    local char = self.background == NUMBERBACKGROUND_DIGITAL and BACKGROUND_DIGITAL or BACKGROUND_SIMPLE
    local digits = math.max( self.digits, len )
    local visible_digits = self.mode == NUMBERRENDERMODE_MODERN and math.max( self.digits - len, 0 ) or digits
    local decimals = shortnumbers_decimals:GetInt() -- if abbreviated, how many decimals are there
    local background = string.rep( char, digits )
    self._background = string.rep( char, visible_digits ) -- actual background

    -- if abbreviated it means it's decimal, so place a dot
    if abbreviation and digits > 0 then
        
        self._background = string.SetChar( self._background, visible_digits - decimals, "." )
        background = string.SetChar( background, digits - decimals, "." )

    end

    -- set paint function
    if self.background == NUMBERBACKGROUND_EXPENSIVE then

        self._expensive = {}

        for i=1, #BACKGROUND_EXPENSIVE do

            self._expensive[ i ] = string.rep( BACKGROUND_EXPENSIVE[ i ], visible_digits )

            -- apply decimal number dot for every layer
            if abbreviation and visible_digits > 0 then
                
                self._expensive[ i ] = string.SetChar( self._expensive[ i ], visible_digits - decimals, "." )
                
            end

        end

        self._paintbackground = self._PaintBackground2

    else

        self._paintbackground = self._PaintBackground

    end

    -- apply alignment
    surface.SetFont( self.font )

    local default_w = surface.GetTextSize( string.rep( char, self.digits ) )
    local w0, h = surface.GetTextSize( background )
    local w1 = surface.GetTextSize( self._value )

    self._x0 = 0 -- reset background offset

    if self.align == TEXT_ALIGN_LEFT then

        self._x1 = 0

        if self.mode == NUMBERRENDERMODE_MODERN then

            self._x0 = w1

        end

    elseif self.align == TEXT_ALIGN_RIGHT or self.mode == NUMBERRENDERMODE_MODERN then

        self._x1 = w0 - w1

    elseif self.align == TEXT_ALIGN_CENTER then

        self._x1 = w0 / 2 - w1 / 2

    end

    -- calculate offsets
    local scale = scale_Get()
    local x = math.Round( self.x * scale )
    self._y = math.Round( self.y * scale )
    self._x0, self._x1 = x + self._x0, x + self._x1

    -- calculate sizes
    self._w, self._h = w0, h
    self.__w, self.__h = w0 / scale, h / scale
    self.__defaultsize = default_w / scale

    -- take into account the abbreviation size
    if abbreviation then
        
        local w2 = surface.GetTextSize( abbreviation )
        self._x2 = x + w0
        self._w = self._w + w2
        self.__w = self._w / scale

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

function COMPONENT:SetOverrideAbbreviation( override )

    if self.abbr_override == override then return end

    self.abbr_override = override
    self:InvalidateLayout()

    return true

end

function COMPONENT:SetValue( value )

    if self.value == value then return end
    if not isnumber( value ) then return end

    self.value = value
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

function COMPONENT:SetFont( font )

    if self.font == font then return end

    self.font = font
    self:InvalidateLayout()

    return true

end

function COMPONENT:SetColor( color )

    self.color = color

end

function COMPONENT:SetColor2( color2 )

    self.color2 = color2

end

function COMPONENT:SetAlign( align )

    if self.align == align then return end

    self.align = align
    self:InvalidateLayout()

    return true

end

function COMPONENT:SetDigits( digits )

    if self.digits == digits then return end

    self.digits = digits
    self:InvalidateLayout()

    return true

end

function COMPONENT:SetRenderMode( mode )

    if self.mode == mode then return end

    self.mode = mode
    self:InvalidateLayout()

    return true

end

function COMPONENT:SetBackground( background )

    if self.background == background then return end

    self.background = background
    self:InvalidateLayout()
    
    return true

end

function COMPONENT:GetSize()

    return self.__w, self.__h

end

function COMPONENT._PaintBackground( self, x, y )

    surface.SetTextColor( self.color2.r, self.color2.g, self.color2.b, self.color2.a )
    surface.SetTextPos( x, y )
    surface.DrawText( self._background )

end

function COMPONENT._PaintBackground2( self, x, y )

    -- if expensive digits is not allowed just draw the regular background
    if not expensivedigits:GetBool() then
        
        self._PaintBackground( self, x, y )
        return

    end

    if #self._expensive <= 0 then return end -- skip steps if we're rendering nothing

    surface.SetTextColor(self.color2.r, self.color2.g, self.color2.b, self.color2.a * (self.color2.a < 255 and .36 or 1))
    
    for i=1, #self._expensive do

        surface.SetTextPos( x, y )
        surface.DrawText( self._expensive[ i ] )

    end

end

function COMPONENT:PaintBackground( x, y )

    if not self.visible or self.background == NUMBERBACKGROUND_NONE then return end

    surface.SetFont( self.font )
    self._paintbackground( self, x + self._x0, y + self._y )

end

function COMPONENT:Paint( x, y )

    if not self.visible then return end

    surface.SetFont( self.font )
    surface.SetTextColor( self.color.r, self.color.g, self.color.b, self.color.a )
    surface.SetTextPos( x + self._x1, y + self._y )
    surface.DrawText( self._value )

    if not self._abbreviation then return end

    surface.SetTextPos( x + self._x2, y + self._y )
    surface.DrawText( self._abbreviation )

end

HOLOHUD2.component.Register( "Number", COMPONENT )

HOLOHUD2.NUMBERBACKGROUND_NONE          = NUMBERBACKGROUND_NONE
HOLOHUD2.NUMBERBACKGROUND_SIMPLE        = NUMBERBACKGROUND_SIMPLE
HOLOHUD2.NUMBERBACKGROUND_DIGITAL       = NUMBERBACKGROUND_DIGITAL
HOLOHUD2.NUMBERBACKGROUND_EXPENSIVE     = NUMBERBACKGROUND_EXPENSIVE
HOLOHUD2.NUMBERBACKGROUNDS              = NUMBERBACKGROUNDS

HOLOHUD2.NUMBERRENDERMODE_STATIC        = NUMBERRENDERMODE_STATIC
HOLOHUD2.NUMBERRENDERMODE_LEADINGZEROS  = NUMBERRENDERMODE_LEADINGZEROS
HOLOHUD2.NUMBERRENDERMODE_MODERN        = NUMBERRENDERMODE_MODERN
HOLOHUD2.NUMBERRENDERMODES              = NUMBERRENDERMODES