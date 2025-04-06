
local PANEL = {}

function PANEL:Init()

    local slider = vgui.Create( "DNumSlider", self )
    slider:SetSize( 172, 14 )
    slider:Dock( RIGHT )
    slider:DockMargin( 0, 2, 2, 2 )
    slider:SetMinMax( TEXT_ALIGN_LEFT, TEXT_ALIGN_RIGHT )
    slider:SetDecimals( 0 )
    slider:SetDark( true ) -- DEPRECATED: why though? :(
    slider.TextArea:Hide()
    slider.OnValueChanged = function( _, value )

        value = math.Round( value )

        slider.Label:SetText( value == TEXT_ALIGN_LEFT and "#holohud2.derma.textalign.left" or ( value == TEXT_ALIGN_CENTER and "#holohud2.derma.textalign.center" ) or "#holohud2.derma.textalign.right" )
        self:OnValueChanged( value )

    end
    self.Slider = slider

end

function PANEL:GetValue()

    return self.Slider:GetValue()

end

function PANEL:SetValue( value )

    self.Slider:SetValue( value )

end

vgui.Register( "HOLOHUD2_DParameter_TextAlign", PANEL, "HOLOHUD2_DParameter" )