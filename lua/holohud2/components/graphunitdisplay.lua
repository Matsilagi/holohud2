
local BaseClass = HOLOHUD2.component.Get( "GraphDisplay" )

local COMPONENT = {
    unit_on_background  = false
}

function COMPONENT:Init()

    BaseClass.Init( self )

    local unit = HOLOHUD2.component.Create( "Text" )
    unit:SetColor( self.Colors:GetColor() )
    self.Unit = unit

end

function COMPONENT:InvalidateLayout()

    BaseClass.InvalidateLayout( self )
    self.Unit:InvalidateLayout()

end


function COMPONENT:SetDrawUnitOnBackground( on_background )

    self.Unit:SetColor( on_background and self.Colors2:GetColor() or self.Colors:GetColor() )
    self.unit_on_background = on_background

end

function COMPONENT:Think()
    
    BaseClass.Think( self )

    self.Unit:PerformLayout()

end

function COMPONENT:PaintBackground( x, y )

    BaseClass.PaintBackground(self, x, y)

    if not self.unit_on_background then return end
        
    self.Unit:Paint(x, y)

end

function COMPONENT:Paint( x, y )

    BaseClass.Paint( self, x, y )

    if self.unit_on_background then return end
        
    self.Unit:Paint( x, y )

end

HOLOHUD2.component.Register( "GraphUnitDisplay", COMPONENT, "GraphDisplay" )