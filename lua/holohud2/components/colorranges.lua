
local COMPONENT = {}

function COMPONENT:Init()

    self.Color = HOLOHUD2.component.Create( "Color" )

    local colors = HOLOHUD2.component.Create( "ColorSelector" )
    colors.OnColorChanged = function(_, color) self.Color:FadeTo( color ) end
    self.Colors = colors

end

function COMPONENT:SetValue( value )

    self.Colors:SetValue( value )

end

function COMPONENT:SetMaxValue( max_value )

    self.Colors:SetMaxValue( max_value )

end

function COMPONENT:SetColors( colors )

    self.Colors:SetColors( colors )
    self.Color:SetColor( self.Colors:GetColor() )

end

function COMPONENT:GetColor()

    return self.Color:GetColor()

end

function COMPONENT:Think()

    self.Color:Think()

end

function COMPONENT:Refresh()

    self.Colors:FetchColor()

end

HOLOHUD2.component.Register( "ColorRanges", COMPONENT )