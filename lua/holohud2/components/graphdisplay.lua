
local BaseClass = HOLOHUD2.component.Get( "NumericIconDisplay" )

local COMPONENT = {}

function COMPONENT:Init()

    BaseClass.Init( self )

    local color, color2 = self.Colors:GetColor(), self.Colors2:GetColor()

    local graph = HOLOHUD2.component.Create( "Graph" )
    graph:SetColor( color )
    self.Graph = graph

    local gauge = HOLOHUD2.component.Create( "Gauge" )
    gauge:SetColor( color2 )
    self.Gauge = gauge
end

function COMPONENT:InvalidateLayout()

    BaseClass.InvalidateLayout( self )
    self.Graph:InvalidateLayout()
    self.Gauge:InvalidateLayout()

end

function COMPONENT:SetMaxValue( max_value )

    if not BaseClass.SetMaxValue( self, max_value ) then return end

    self.Graph:SetValue( self.value / max_value )

    return true

end

function COMPONENT:SetValue( value )

    if not BaseClass.SetValue( self, value ) then return end

    self.Graph:SetValue( value / self.max_value )

    return true

end

function COMPONENT:Think()
    
    BaseClass.Think( self )

    self.Gauge:PerformLayout()
    self.Graph:Think()

end

function COMPONENT:PaintBackground( x, y )

    BaseClass.PaintBackground( self, x, y )

    self.Gauge:Paint( x, y )

end

function COMPONENT:Paint( x, y )

    BaseClass.Paint( self, x, y )

    self.Graph:Paint( x, y )

end

HOLOHUD2.component.Register( "GraphDisplay", COMPONENT, "NumericIconDisplay" )