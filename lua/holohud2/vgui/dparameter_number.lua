
local PANEL = {}

function PANEL:Init()

    local numwang = vgui.Create( "DNumberWang", self )
    numwang:SetSize( 96, 14 )
    numwang:Dock( RIGHT )
    numwang:DockMargin( 0, 2, 2, 2 )
    numwang.OnValueChanged = function( _, value )

        self:OnValueChanged( value )

    end
    self.NumberWang = numwang

end

function PANEL:Populate( parameter )

    self.NumberWang:SetMin( parameter.min or -2147483647 )
    self.NumberWang:SetMax( parameter.max or 2147483647 )
    self.NumberWang:SetDecimals( parameter.decimals or 0 )

end

function PANEL:GetValue()

    return self.NumberWang:GetValue()

end

function PANEL:SetValue( value )

    self.NumberWang:SetValue( value )

end

vgui.Register( "HOLOHUD2_DParameter_Number", PANEL, "HOLOHUD2_DParameter" )