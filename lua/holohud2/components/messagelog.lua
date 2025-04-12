local surface = surface
local draw = draw
local render = render
local FrameTime = FrameTime
local scale_Get = HOLOHUD2.scale.Get

local COMPONENT = {
    invalid_layout  = false,
    visible         = true,
    x               = 0,
    y               = 0,
    w               = 0,
    h               = 0,
    margin          = 8,
    spacing         = 0,
    font            = "default",
    scroll_speed    = 128,
    letter_rate     = .01,
    messages        = {},
    bullet          = ">",
    color           = color_white,
    color2          = color_white,
    _x              = 0,
    _y              = 0,
    _w              = 0,
    _h              = 0,
    _margin         = 0,
    _messages       = {},
    _letteranim     = {},
    _scroll         = 0, -- calculated scrolling offset
    _anim           = 0, -- animation status
    _nextchar       = 0,
    _content_w      = 0, -- unscaled size of contents
    _content_h      = 0 -- unscaled size of contents
}

local STR_SPACE     = " "
local STR_LINEBREAK = "\n"

function COMPONENT:InvalidateLayout()

    self.invalid_layout = true

end

function COMPONENT:PerformLayout( force )

    if not force and not ( self.visible and self.invalid_layout ) then return end

    self._messages = {} -- reset cached messages
    self._content_w, self._content_h = 0, 0 -- reset content size

    local scale = scale_Get()
    self._x, self._y = math.Round( self.x * scale ), math.Round( self.y * scale )
    local w, h = math.Round( self.w * scale ), math.Round( self.h * scale )
    local spacing = math.Round( self.spacing * scale )
    self._margin = math.Round( self.margin * scale )
    self._w, self._h = w, h

    w = w - self._margin
    local y = 0

    -- parse messages
    surface.SetFont( self.font )
    for i=1, #self.messages do

        if i > 1 then y = y + spacing end

        local line = 0
        local words = string.Split( self.messages[ i ].message, " " )
        local message = ""

        -- cut message in different lines to fit the rectangle
        for i=1, #words do

            local word = words[ i ] .. STR_SPACE
            local size = surface.GetTextSize( word )
            line = line + size

            if line >= w then
                
                message = message .. STR_LINEBREAK
                line = size
                
            end

            message = message .. word

        end

        -- get the total height of the message
        local wide, tall = surface.GetTextSize( message )

        self._messages[ i ] = { message = message, y = y, h = tall }
        self._letteranim[ i ].len = utf8.len( message )
        
        self._content_w = math.max( self._content_w, math.Round( wide / scale ) )

        y = y + tall -- move next message

    end

    -- calculate how much do we need to scroll up
    self._scroll = math.max( y - h, 0 )

    self._content_w = math.min( self._content_w + self.margin, self.w )
    self._content_h = math.min( math.Round( y / scale ), self.h )

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

function COMPONENT:SetSize( w, h )

    if self.w == w and self.h == h then return end

    self.w = w
    self.h = h

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetMargin( margin )

    if self.margin == margin then return end

    self.margin = margin

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetSpacing( spacing )

    if self.spacing == spacing then return end

    self.spacing = spacing

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

function COMPONENT:SetDefaultBullet( bullet )

    self.bullet = bullet

end

function COMPONENT:SetLetterRate( letter_rate )

    self.letter_rate = letter_rate

end

function COMPONENT:SetScrollSpeed( scroll_speed )

    self.scroll_speed = scroll_speed

end

function COMPONENT:GetContentSize()

    return self._content_w, self._content_h

end

function COMPONENT:Think()

    local frametime = FrameTime()

    self._anim = math.min( self._anim + FrameTime() * self.scroll_speed, self._scroll )

    -- if the first message is hidden by scroll, remove it
    local first = self._messages[ 1 ]
    if first and self._anim >= first.h then

        self._anim = math.max( self._anim - first.h, 0 )
        self:RemoveMessage( 1 )

    end

    self:PerformLayout()

    -- do letter animation on all messages
    self._nextchar = self._nextchar - frametime
    if self._nextchar <= 0 then

        for i=1, #self.messages do

            local message = self._messages[ i ]
            local anim = self._letteranim[ i ]

            if anim.cur >= anim.len then continue end
            
            anim.cur = math.min( anim.cur + 1 + math.Round( -self._nextchar / self.letter_rate ), anim.len )
            anim.text = utf8.sub( message.message, 1, anim.cur )

        end

        self._nextchar = self._nextchar + self.letter_rate

    end

end

function COMPONENT:AddMessage( text, color, color2, bullet )

    if not text then return end

    local message = { message = language.GetPhrase( text ), color = color or self.color, color2 = color2 or self.color2, bullet = bullet or self.bullet, cur = 0 }

    table.insert( self.messages, message )
    table.insert( self._letteranim, { text = "", len = 0, cur = 0 } )
    self:InvalidateLayout()

    return message

end

function COMPONENT:SetMessage( i, text, color, color2, bullet )

    if not self.messages[ i ] then return end

    if text then

        self.messages[ i ].message = text

        local letteranim = self._letteranim[ i ]
        letteranim.text = ""
        letteranim.len = 0
        letteranim.cur = 0
        
        self:InvalidateLayout()

    end

    if color then self.messages[ i ].color = color end
    if color2 then self.messages[ i ].color2 = color2 end
    if bullet then self.messages[ i ].bullet = bullet end

end

function COMPONENT:RemoveMessage( i )

    table.remove( self.messages, i )
    table.remove( self._letteranim, i )
    self:InvalidateLayout()

end

function COMPONENT:Purge()

    if #self.messages <= 0 then return end

    self._anim = 0
    self._scroll = 0
    self._nextchar = 0
    table.Empty( self.messages )
    table.Empty( self._letteranim )
    self:InvalidateLayout()

end

function COMPONENT:Paint( x, y )

    if not self.visible then return end

    x, y = x + self._x, y + self._y

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
    surface.DrawRect( x, y, x + self._w, y + self._h )

    render.SetStencilCompareFunction( STENCIL_EQUAL )
    render.SetStencilFailOperation( STENCIL_KEEP )

    y = y - self._anim

    for i=1, #self._messages do

        local properties = self.messages[ i ]
        local message = self._messages[ i ]

        if not properties or not message then continue end

        local y = y + message.y
        
        draw.DrawText( properties.bullet, self.font, x, y, properties.color2 )
        draw.DrawText( self._letteranim[ i ].text, self.font, x + self._margin, y, properties.color )

    end

    render.SetStencilEnable( false )

end

HOLOHUD2.component.Register( "MessageLog", COMPONENT )