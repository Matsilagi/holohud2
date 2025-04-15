local StartAlphaMultiplier = HOLOHUD2.render.StartAlphaMultiplier
local EndAlphaMultiplier = HOLOHUD2.render.EndAlphaMultiplier

local COMPONENT = {
    text_on_background  = false,
    value               = 0
}

function COMPONENT:Init()

    self.Blur = HOLOHUD2.component.Create( "Blur" )
    self.Icon = HOLOHUD2.component.Create( "Icon" )
    self.Number = HOLOHUD2.component.Create( "Number" )
    self.Text = HOLOHUD2.component.Create( "Text" )

end

function COMPONENT:InvalidateLayout()

    self.Icon:InvalidateLayout()
    self.Number:InvalidateLayout()
    self.Text:InvalidateLayout()

end

function COMPONENT:Think()

    self.Blur:Think()
    self.Icon:PerformLayout()
    self.Number:PerformLayout()
    self.Text:PerformLayout()

end

function COMPONENT:SetDrawTextOnBackground( on_background )

    self.text_on_background = on_background

end

function COMPONENT:SetValue( value )

    if self.value == value then return end

    self.Blur:Activate()
    self.Number:SetValue( math.ceil( value ) )
    self.value = value

    return true

end

function COMPONENT:PaintBackground( x, y )

    self.Number:PaintBackground( x, y )

    if not self.text_on_background then return end

    self.Text:Paint( x, y )
    
end

function COMPONENT:Paint( x, y )

    self.Icon:Paint( x, y )
    self.Number:Paint( x, y )

    if self.text_on_background then return end

    self.Text:Paint( x, y )
    
end

function COMPONENT:PaintScanlines( x, y )

    StartAlphaMultiplier( self.Blur:GetAmount() )
    self:Paint( x, y )
    EndAlphaMultiplier()

end

HOLOHUD2.component.Register( "HudExtensionCounter", COMPONENT )