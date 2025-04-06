
local PANEL = {}

function PANEL:Init()

    local slider = vgui.Create( "DNumSlider", self )
    slider:SetSize( 172, 14 )
    slider:Dock( RIGHT )
    slider:DockMargin( 0, 2, 2, 2 )
    slider:SetDark( true ) -- DEPRECATED: why though? :(
    slider.Label:Hide()
    slider.OnValueChanged = function( _, value )

        self:OnValueChanged( value )

    end
    self.Slider = slider

end

function PANEL:Populate( parameter )

    self.Slider:SetMin( parameter.min or -2147483647 )
    self.Slider:SetMax( parameter.max or 2147483647 )
    self.Slider:SetDecimals( parameter.decimals or 0 )

end

function PANEL:GetValue()

    return self.Slider:GetValue()

end

function PANEL:SetValue( value )

    self.Slider:SetValue( value )

end

vgui.Register( "HOLOHUD2_DParameter_Range", PANEL, "HOLOHUD2_DParameter" )