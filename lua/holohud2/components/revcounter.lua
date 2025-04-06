local surface = surface
local scale_Get = HOLOHUD2.scale.Get

local COMPONENT = {
    invalid_layout  = false,
    visible         = true,
    x               = 0,
    y               = 0,
    w               = 0,
    h               = 0,
    segments        = 8,
    margin          = 0,
    redline         = .8,
    showrpm         = true,
    maxrpm          = 8,
    rpmoffset       = 0,
    negative        = .8,
    negative_h      = 0,
    font            = "default",
    color           = color_white,
    color2          = color_white,
    colormax        = color_white,
    colormax2       = color_white,
    value           = 0,
    _segments       = {},
    _labels         = {}
}

function COMPONENT:InvalidateLayout()

    self.invalid_layout = true

end

function COMPONENT:PerformLayout( force )

    if not force and not ( self.visible and self.invalid_layout ) then return end

    local scale = scale_Get()

    self._segments = {}
    self._labels = {}
    local rpms = {} -- already used RPM labels

    local x, y = self.x * scale, self.y * scale
    
    local segments = math.Round( self.segments )
    local segw = math.max( ( self.w - ( self.margin * ( segments - 1 ) ) ) / segments, 1 ) * scale
    local segh = self.h * scale
    local negsegh = segh * self.negative_h
    local segmargin = self.margin * scale

    surface.SetFont( self.font )

    local numsize = 0

    for i=1, segments do

        local redline = i > math.Round( segments * self.redline )

        self._segments[i] = {
            x = x,
            y = y,
            w = segw,
            h = ( i <= math.Round( segments * self.negative ) ) and negsegh or segh,
            color = redline and self.colormax or self.color,
            color2 = redline and self.colormax2 or self.color2
        }

        local rpm = math.Round( i / segments * math.Round( self.maxrpm ) )
        local w, h = surface.GetTextSize( rpm )

        self._labels[i] = {
            x = x + segw / 2 - w / 2,
            y = y - h - self.rpmoffset,
            text = not rpms[ rpm ] and rpm or '' -- avoid repeating RPM label
        }

        rpms[ rpm ] = true -- register used RPM label

        x = x + segw + segmargin

        if numsize < w then numsize = w end

    end

    -- check if we need to hide numbers for all of them to fit properly
    if numsize > segw then

        local num = math.Round( numsize / ( segw + segmargin / 2 ) )

        for i, label in ipairs( self._labels ) do
            
            if i % num == 1 then continue end

            label.text = ""

        end

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

function COMPONENT:SetSize( w, h )

    if self.w == w and self.h == h then return end

    self.w = w
    self.h = h

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetSegments( segments )

    if self.segments == segments then return end

    self.segments = segments
    
    self:InvalidateLayout()

    return true

end

function COMPONENT:SetMargin( margin )

    if self.margin == margin then return end

    self.margin = margin
    
    self:InvalidateLayout()

    return true

end

function COMPONENT:SetRedLine( redline )

    if self.redline == redline then return end

    self.redline = redline

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetShowRPM( showrpm )

    if self.showrpm == showrpm then return end

    self.showrpm = showrpm

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetRPMOffset( rpmoffset )

    if self.rpmoffset == rpmoffset then return end

    self.rpmoffset = rpmoffset

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetMaxRPM( maxrpm )

    if self.maxrpm == maxrpm then return end

    self.maxrpm = maxrpm

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetNegativeArea( negative )

    if self.negative == negative then return end

    self.negative = negative

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetNegativeOffset( negative_h )

    if self.negative_h == negative_h then return end

    self.negative_h = negative_h

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

    if self.color == color then return end

    self.color = color

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetColor2( color2 )

    if self.color2 == color2 then return end

    self.color2 = color2

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetColorMax( colormax )

    if self.colormax == colormax then return end

    self.colormax = colormax

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetColorMax2( colormax2 )

    if self.colormax2 == colormax2 then return end

    self.colormax2 = colormax2

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetValue( value )

    self.value = value

end

function COMPONENT:PaintBackground( x, y )

    if not self.visible then return end
    if #self._segments <= 0 then return end

    surface.SetFont( self.font )

    for i=1, #self._segments do

        local segment = self._segments[ i ]
        surface.SetDrawColor( segment.color2.r, segment.color2.g, segment.color2.b, segment.color2.a )
        surface.DrawRect( x + segment.x, y + segment.y, segment.w, segment.h )

        if not self.showrpm then continue end

        local label = self._labels[ i ]
        surface.SetTextPos( x + label.x, y + label.y )
        surface.SetTextColor( segment.color2.r, segment.color2.g, segment.color2.b, segment.color2.a )
        surface.DrawText( label.text )

    end

end

function COMPONENT:Paint( x, y )

    if not self.visible then return end
    if #self._segments <= 0 then return end
    
    local segments = math.Round( self.segments * self.value )

    for i=1, #self._segments do

        if i > segments then continue end

        local segment = self._segments[ i ]
        surface.SetDrawColor( segment.color.r, segment.color.g, segment.color.b, segment.color.a )
        surface.DrawRect( x + segment.x, y + segment.y, segment.w, segment.h )

    end

end

HOLOHUD2.component.Register( "RevCounter", COMPONENT )