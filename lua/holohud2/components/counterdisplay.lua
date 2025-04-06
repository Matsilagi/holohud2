
local BaseClass = HOLOHUD2.component.Get( "MeterDisplay" )

local COMPONENT = {
    separator_on_background = false,
}

function COMPONENT:Init()

    BaseClass.Init( self )

    local color, color2 = self.Colors:GetColor(), self.Colors2:GetColor()

    local separator = HOLOHUD2.component.Create( "Separator" )
    separator:SetColor( color )
    self.Separator = separator

    local number2 = HOLOHUD2.component.Create( "Number" )
    number2:SetColor( color )
    number2:SetColor2( color2 )
    self.Number2 = number2

end

function COMPONENT:Think()

    BaseClass.Think( self )

    self.Separator:PerformLayout()
    self.Number2:PerformLayout()

end

function COMPONENT:SetMaxValue( max_value )

    BaseClass.SetMaxValue( self, max_value )

    self.Number2:SetValue( max_value )

end

function COMPONENT:SetDrawSeparatorOnBackground( on_background )

    if self.separator_on_background == on_background then return end

    self.Separator:SetColor( on_background and self.Colors2:GetColor() or self.Colors:GetColor() )

    self.separator_on_background = on_background

end

function COMPONENT:PaintBackground( x, y )

    BaseClass.PaintBackground( self, x, y )

    self.Number2:PaintBackground( x, y )

    if not self.separator_on_background then return end
        
    self.Separator:Paint( x, y )

end

function COMPONENT:Paint( x, y )

    BaseClass.Paint( self, x, y )

    self.Number2:Paint( x, y )

    if self.separator_on_background then return end
        
    self.Separator:Paint( x, y )

end

HOLOHUD2.component.Register( "CounterDisplay", COMPONENT, "MeterDisplay" )