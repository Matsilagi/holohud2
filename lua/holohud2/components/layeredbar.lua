local math = math

local BaseClass = HOLOHUD2.component.Get( "Bar" )

local COMPONENT = {
    layered     = true,
    background  = true,
    color2      = color_white,
    value       = 0,
    _color      = color_white
}

function COMPONENT:Init()

    self.ProgressBar    = HOLOHUD2.component.Create( "ProgressBar" )
    self.DotLine        = HOLOHUD2.component.Create( "DotLine" )

end

function COMPONENT:PerformLayout( force )

    if not BaseClass.PerformLayout( self, force ) then return end

    self.ProgressBar:Copy( self )

end

function COMPONENT:SetLayered( layered )

    if self.layered == layered then return end

    if layered then

        self:SetValue( self.value )

    else

        self:SetValue( math.min( self.value, 1 ) )

    end
    
    self.layered = layered

end

function COMPONENT:SetDrawBackground( visible )

    self.background = visible

end

function COMPONENT:SetColor( color )

    self.ProgressBar:SetColor( color )
    self.DotLine:SetColor( color )

    self._color = color

end

function COMPONENT:SetColor2( color2 )

    self.color2 = color2

end

function COMPONENT:SetGrowDirection( growdirection )

    self.ProgressBar:SetGrowDirection( growdirection )

end

function COMPONENT:SetValue( value )

    if value and self.value == value then return end

    self.value = value -- store raw value

    value = math.max( self.layered and value or math.min( value, 1 ), 0 )
    local dots = math.max( math.floor( value - .01 ), 0 )

    self.ProgressBar:SetValue( value - dots )
    self.DotLine:SetDots( dots )

    return true

end

function COMPONENT:GetDotLine()

    return self.DotLine

end

function COMPONENT:Think()

    self:PerformLayout()
    self.ProgressBar:Think()
    self.DotLine:PerformLayout()
    
    if self.value <= 1 then
        
        self.color:SetUnpacked( self.color2.r, self.color2.g, self.color2.b, self.color2.a )
        return
    
    end
    
    self.color:SetUnpacked( self._color.r / 2, self._color.g / 2, self._color.b / 2, self._color.a )

end

function COMPONENT:PaintBackground( x, y )

    if not self.visible then return end
    if not self.background then return end

    BaseClass.Paint( self, x, y )

end

function COMPONENT:Paint( x, y )

    if not self.visible then return end

    self.ProgressBar:Paint( x, y )
    self.DotLine:Paint( x, y )

end

HOLOHUD2.component.Register( "LayeredBar", COMPONENT, "Bar" )