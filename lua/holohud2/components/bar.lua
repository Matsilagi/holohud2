local math = math
local surface = surface
local scale_Get = HOLOHUD2.scale.Get

local PROGRESSBAR_SIMPLE            = 1
local PROGRESSBAR_ROUNDED           = 2
local PROGRESSBAR_TEXTURED          = 3
local PROGRESSBAR_DOT               = 4
local PROGRESSBAR_DOT_CONTINUOUS    = 5
local PROGRESSBARSTYLES             = {
    "#holohud2.option.progressbar_0",
    "#holohud2.option.progressbar_1",
    "#holohud2.option.progressbar_2",
    "#holohud2.option.progressbar_3",
    "#holohud2.option.progressbar_4"
}

local TEXTURED_CORNER   = surface.GetTextureID( "holohud2/corner" )
local GRADIENT_TEXTURE0 = surface.GetTextureID( "gui/gradient" )
local GRADIENT_TEXTURE1 = surface.GetTextureID( "gui/gradient" )
local GRADIENT_SHINE    = .1

local COMPONENT = {
    visible         = true,
    invalid_layout  = false,
    x               = 0,
    y               = 0,
    w               = 0,
    h               = 0,
    style           = PROGRESSBAR_SIMPLE,
    color           = color_white,
    shine           = false,
    _x              = 0,
    _y              = 0,
    _w              = 0,
    _h              = 0,
    __w             = 0,
    __h             = 0,
    _metadata       = {},
    _paint          = function() end
}

function COMPONENT:InvalidateLayout()

    self.invalid_layout = true

end

function COMPONENT:PerformLayout( force )

    if not force and not ( self.visible and self.invalid_layout ) then return end

    local w, h = self.w, self.h

    -- scale transform
    local scale = scale_Get()
    self._x, self._y = math.Round( self.x * scale ), math.Round( self.y * scale )
    self._w, self._h = math.Round( self.w * scale ), math.Round( self.h * scale )
    
    -- build bar data
    self._metadata = {}
    if self.style == PROGRESSBAR_SIMPLE then
        
        self._metadata.shine = h > w and GRADIENT_TEXTURE1 or GRADIENT_TEXTURE0
        self._paint = self._PaintSimple

    elseif self.style == PROGRESSBAR_ROUNDED then

        local is_vertical = h > w
        self._metadata.border = math.Round( 4 * scale )
        self._metadata.w, self._metadata.h = self._w / ( is_vertical and 2 or 1 ), self._h / ( vertical and 1 or 2 )
        self._paint = self._PaintRounded

    elseif self.style == PROGRESSBAR_TEXTURED then

        self._metadata.border = math.floor( math.min( 8 * scale, math.min( self._w, self._h ) ) / 2 )
        self._paint = self._PaintTextured

    else

        if w > 0 and h > 0 then
            
            -- generate dots and adjust bar projected size
            if w > h then
                
                local margin = self._h / 5
                local dots = math.Round( self._w / self._h )

                for i = 1, dots do
                    
                    self._metadata[ i ] = { x = margin + self._h * ( i - 1 ), y = margin, size = self._h - margin * 2 }

                end

                self._w = dots * self._h
                w = self._w / scale -- NOTE: take into account scaling precision loss

            else

                local margin = self._w / 5
                local dots = math.Round( self._h / self._w )

                for i = 1, dots do
                    
                    self._metadata[ i ] = { x = margin, y = margin + self._w * ( i - 1 ), size = self._w - margin * 2 }

                end

                self._h = dots * self._w
                h = self._h / scale -- NOTE: take into account scaling precision loss

            end

        end

        self._paint = self._PaintDot

    end

    self.__w, self.__h = w, h

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

    w = math.max( w, 1 )
    h = math.max( h, 1 )

    if self.w == w and self.h == h then return end

    self.w = w
    self.h = h
    self:InvalidateLayout()

    return true

end

function COMPONENT:SetStyle( style )

    if self.style == style then return end

    self.style = style
    self:InvalidateLayout()

    return true

end

function COMPONENT:Copy( parent )

    self:SetPos( parent.x, parent.y )
    self:SetSize( parent.w, parent.h )
    self:SetStyle( parent.style )

end

function COMPONENT:SetColor( color )

    self.color = color

end

function COMPONENT:SetDrawShine( shine )

    self.shine = shine

end

function COMPONENT:GetSize()

    return self.__w, self.__h

end

function COMPONENT._PaintSimple( self, x, y )

    local w, h = self._w, self._h
    surface.DrawRect( x, y, w, h )

    if not self.shine then return end

    surface.SetDrawColor( 255, 255, 255, 255 * GRADIENT_SHINE )
    surface.SetTexture( self._metadata.shine )
    surface.DrawTexturedRect( x, y, w, h )

end

function COMPONENT._PaintRounded( self, x, y )

    local border = self._metadata.border

    draw.RoundedBox( border, x, y, self._w, self._h, surface.GetDrawColor() )

    if not self.shine then return end

    surface.SetDrawColor( 255, 255, 255, 255 * GRADIENT_SHINE )
    draw.RoundedBox( border, x, y, self._metadata.shine_w, self._metadata.shine_h, surface.GetDrawColor() )

end

function COMPONENT._PaintTextured( self, x, y )

    -- round everything before drawing to avoid floating point shenanigans
    x = math.Round( x )
    y = math.Round( y )
    local w = math.Round( self._w )
    local h = math.Round( self._h )
    local border = math.Round( self._metadata.border )

    surface.DrawRect( x + border, y, w - border, border )
    surface.DrawRect( x, y + border, w, h - border * 2 )
    surface.DrawRect( x, y + h - border, w - border, border )
    surface.SetTexture( TEXTURED_CORNER )
    surface.DrawTexturedRect( x, y, border, border )
    surface.DrawTexturedRectUV( x + w - border, y + h - border, border, border, 1, 1, 0, 0 )

end

function COMPONENT._PaintDot( self, x, y )

    if #self._metadata <= 0 then return end

    for i=1, #self._metadata do

        local dot = self._metadata[ i ]
        surface.DrawRect( x + dot.x, y + dot.y, dot.size, dot.size )

    end

end

function COMPONENT:Paint( x, y )

    if not self.visible then return end

    surface.SetDrawColor( self.color.r, self.color.g, self.color.b, self.color.a )
    self._paint( self, x + self._x, y + self._y )

end

HOLOHUD2.component.Register( "Bar", COMPONENT )

HOLOHUD2.PROGRESSBAR_SIMPLE         = PROGRESSBAR_SIMPLE
HOLOHUD2.PROGRESSBAR_ROUNDED        = PROGRESSBAR_ROUNDED
HOLOHUD2.PROGRESSBAR_TEXTURED       = PROGRESSBAR_TEXTURED
HOLOHUD2.PROGRESSBAR_DOT            = PROGRESSBAR_DOT
HOLOHUD2.PROGRESSBAR_DOT_CONTINUOUS = PROGRESSBAR_DOT_CONTINUOUS
HOLOHUD2.PROGRESSBARSTYLES          = PROGRESSBARSTYLES