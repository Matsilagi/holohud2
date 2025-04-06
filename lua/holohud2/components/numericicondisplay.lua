
local BaseClass = HOLOHUD2.component.Get( "NumericDisplay" )

local COMPONENT = {
    icon_on_background = false
}

function COMPONENT:Init()

    BaseClass.Init( self )

    local icon = HOLOHUD2.component.Create( "Icon" )
    icon:SetColor( self.Colors:GetColor() )
    self.Icon = icon

end

function COMPONENT:InvalidateLayout()

    BaseClass.InvalidateLayout( self )
    self.Icon:InvalidateLayout()

end

function COMPONENT:SetDrawIconOnBackground( on_background )

    if self.icon_on_background == on_background then return end

    self.Icon:SetColor( on_background and self.Colors2:GetColor() or self.Colors:GetColor() )
    self.icon_on_background = on_background

    return true

end

function COMPONENT:Think()

    BaseClass.Think( self )

    self.Icon:PerformLayout()

end

function COMPONENT:PaintBackground( x, y )

    BaseClass.PaintBackground( self, x, y )

    if not self.icon_on_background then return end

    self.Icon:Paint( x, y )

end

function COMPONENT:Paint( x, y )

    BaseClass.Paint( self, x, y )

    if self.icon_on_background then return end

    self.Icon:Paint( x, y )

end

HOLOHUD2.component.Register( "NumericIconDisplay", COMPONENT, "NumericDisplay" )