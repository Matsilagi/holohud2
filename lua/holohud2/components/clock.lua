
local COMPONENT = {
    visible                 = true,
    color                   = color_white,
    color2                  = color_white,
    separator_background    = true,
    blinking                = false,
    _blinking               = false
}

local SEPARATOR = ":"

function COMPONENT:Init()

    local hours = HOLOHUD2.component.Create( "Number" )
    hours:SetDigits(2)
    hours:SetRenderMode(HOLOHUD2.NUMBERRENDERMODE_LEADINGZEROS)
    self.Hours = hours

    local minutes = HOLOHUD2.component.Create( "Number")
    minutes:SetDigits(2)
    minutes:SetRenderMode(HOLOHUD2.NUMBERRENDERMODE_LEADINGZEROS)
    self.Minutes = minutes

    local seconds = HOLOHUD2.component.Create( "Number")
    seconds:SetDigits(2)
    seconds:SetRenderMode(HOLOHUD2.NUMBERRENDERMODE_LEADINGZEROS)
    self.Seconds = seconds

    local separator = HOLOHUD2.component.Create( "Text")
    separator:SetText(SEPARATOR)
    self.Separator = separator

    local separator2 = HOLOHUD2.component.Create( "Text")
    separator2:SetText(SEPARATOR)
    self.Separator2 = separator2

end

function COMPONENT:InvalidateLayout()

    self.Hours:InvalidateLayout()
    self.Minutes:InvalidateLayout()
    self.Seconds:InvalidateLayout()
    self.Separator:InvalidateLayout()
    self.Separator2:InvalidateLayout()

end

function COMPONENT:Think()

    local mod = CurTime() % 1

    self.Hours:PerformLayout()
    self.Minutes:PerformLayout()
    self.Seconds:PerformLayout()
    self.Separator:PerformLayout()
    self.Separator2:PerformLayout()

    self._blinking = self.blinking and mod > .25 and mod < .75

    self.Separator:SetColor(self._blinking and self.color2 or self.color)

end

function COMPONENT:SetVisible( visible )

    self.visible = visible

end

function COMPONENT:SetColor( color )

    self.Hours:SetColor( color )
    self.Minutes:SetColor( color )
    self.Seconds:SetColor( color )
    self.Separator2:SetColor( color )

    self.color = color

end

function COMPONENT:SetColor2( color2 )

    self.Hours:SetColor2( color2 )
    self.Minutes:SetColor2( color2 )
    self.Seconds:SetColor2( color2 )

    self.color2 = color2

end

function COMPONENT:SetDrawSeparatorBackground( background )

    self.separator_background = background

end

function COMPONENT:SetBlinking( blinking )

    self.blinking = blinking

end

function COMPONENT:SetHour( hour )

    self.Hours:SetValue( hour )

end

function COMPONENT:SetMinutes( minute )

    self.Minutes:SetValue( minute )

end

function COMPONENT:SetSeconds( second )

    self.Seconds:SetValue( second )

end

function COMPONENT:SetTime(time)

    local hour = math.floor( time / 3600 )
    local minute = math.floor( time / 60 ) - hour * 3600

    self:SetHour( hour )
    self:SetMinutes( minute )
    self:SetSeconds( math.floor( time ) - minute * 60 - hour * 3600 )

end

function COMPONENT:PaintBackground( x, y )

    if not self.visible then return end

    self.Hours:PaintBackground( x, y )
    self.Minutes:PaintBackground( x, y )
    self.Seconds:PaintBackground( x, y )

    if not self._blinking or not self.separator_background then return end

    self.Separator:Paint( x, y )

end

function COMPONENT:Paint(x, y)

    if not self.visible then return end

    self.Hours:Paint( x, y )
    self.Minutes:Paint( x, y )
    self.Seconds:Paint( x, y )

    if not self._blinking then self.Separator:Paint( x, y ) end

    self.Separator2:Paint( x, y )
end

HOLOHUD2.component.Register( "Clock", COMPONENT )