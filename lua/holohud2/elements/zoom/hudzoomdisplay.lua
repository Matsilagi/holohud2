local StartAlphaMultiplier = HOLOHUD2.render.StartAlphaMultiplier
local EndAlphaMultiplier = HOLOHUD2.render.EndAlphaMultiplier
local GetMinimumGlow = HOLOHUD2.render.GetMinimumGlow

local COMPONENT = {
    color               = color_white,
    color2              = color_white,
    unit_on_background  = false,
    text_on_background  = false
}

function COMPONENT:Init()

    self.Number = HOLOHUD2.component.Create( "Number" )
    self.Unit = HOLOHUD2.component.Create( "Text" )
    self.Text = HOLOHUD2.component.Create( "Text" )

end

function COMPONENT:InvalidateLayout()

    self.Number:InvalidateLayout()
    self.Unit:InvalidateLayout()
    self.Text:InvalidateLayout()

end

function COMPONENT:SetColor( color )

    self.Number:SetColor( color )

    if not self.unit_on_background then self.Unit:SetColor( color ) end
    if not self.text_on_background then self.Text:SetColor( color ) end

    self.color = color

end

function COMPONENT:SetColor2( color2 )

    self.Number:SetColor2( color2 )

    if self.unit_on_background then self.Unit:SetColor( color2 ) end
    if self.text_on_background then self.Text:SetColor( color2 ) end

    self.color2 = color2

end

function COMPONENT:SetDrawUnitOnBackground( on_background )

    self.Unit:SetColor( on_background and self.color2 or self.color )
    self.unit_on_background = on_background

end

function COMPONENT:SetDrawTextOnBackground( on_background )

    self.Text:SetColor( on_background and self.color2 or self.color )
    self.text_on_background = on_background

end

function COMPONENT:SetValue( value )

    self.Number:SetValue( value )

end

function COMPONENT:Think()
    
    self.Number:PerformLayout()
    self.Unit:PerformLayout()
    self.Text:PerformLayout()

end

function COMPONENT:PaintBackground( x, y )

    self.Number:PaintBackground( x, y )

    if self.unit_on_background then self.Unit:Paint( x, y ) end
    if self.text_on_background then self.Text:Paint( x, y ) end

end

function COMPONENT:Paint( x, y )

    self.Number:Paint( x, y )

    if not self.unit_on_background then self.Unit:Paint( x, y ) end
    if not self.text_on_background then self.Text:Paint( x, y ) end

end

function COMPONENT:PaintScanlines( x, y )

    StartAlphaMultiplier( GetMinimumGlow() )
    self:Paint( x, y )
    EndAlphaMultiplier()
    
end

HOLOHUD2.component.Register( "HudZoomDisplay", COMPONENT )