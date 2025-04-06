
local FrameTime = FrameTime
local StartAlphaMultiplier = HOLOHUD2.render.StartAlphaMultiplier
local EndAlphaMultiplier = HOLOHUD2.render.EndAlphaMultiplier

local COMPONENT = {
    lerp_speed          = 12,
    number_lerp         = false,
    text_on_background  = false,
    blur                = true,
    value               = 0,
    max_value           = 1,
    _value              = 0 -- lerped value
}

function COMPONENT:Init()

    self.Colors = HOLOHUD2.component.Create( "ColorRanges" )
    self.Colors2 = HOLOHUD2.component.Create( "ColorRanges" )

    local color, color2 = self.Colors:GetColor(), self.Colors2:GetColor()
    
    local number = HOLOHUD2.component.Create( "Number" )
    number:SetColor(color)
    number:SetColor2(color2)
    self.Number = number

    self.Text = HOLOHUD2.component.Create( "Text" )
    self.Blur = HOLOHUD2.component.Create( "Blur" )

end

function COMPONENT:InvalidateLayout()

    self.Number:InvalidateLayout()
    self.Text:InvalidateLayout()

end

function COMPONENT:SetLerpSpeed( speed )

    self.lerp_speed = speed

end

function COMPONENT:SetNumberLerp( lerp )

    if self.number_lerp == lerp then return end

    if not lerp then
        
        self.Number:SetValue( self.value )
    
    end

    self.number_lerp = lerp

end

function COMPONENT:SetDrawTextOnBackground( on_background )

    self.text_on_background = on_background

end

function COMPONENT:SetMaxValue( max_value )
    
    if self.max_value == max_value then return end
    
    self.Colors:SetMaxValue( max_value )
    self.Colors2:SetMaxValue( max_value )

    self.max_value = max_value

    return true

end

function COMPONENT:SetValue( value )
    
    if self.value == value then return end

    if self.blur then self.Blur:Activate() end

    self.Colors:SetValue( value )
    self.Colors2:SetValue( value )

    if not self.number_lerp then
        
        self.Number:SetValue( value )

    end

    self.value = value

    return true

end

function COMPONENT:Think()

    self.Blur:Think()
    self.Colors:Think()
    self.Colors2:Think()
    self.Number:PerformLayout()
    self.Text:PerformLayout()

    self._value = Lerp( FrameTime() * self.lerp_speed, self._value, self.value )

    if self.number_lerp then self.Number:SetValue( math.Round( self._value ) ) end

end

function COMPONENT:PaintBackground( x, y )

    self.Number:PaintBackground( x, y )

    if self.text_on_background then
        
        self.Text:Paint( x, y )
    
    end

end

function COMPONENT:Paint( x, y )

    self.Number:Paint( x, y )

    if not self.text_on_background then
        
        self.Text:Paint( x, y )
    
    end

end

function COMPONENT:PaintScanlines( x, y )

    StartAlphaMultiplier( self.Blur:GetAmount() )
    self:Paint( x, y )
    EndAlphaMultiplier()

end

HOLOHUD2.component.Register( "NumericDisplay", COMPONENT )