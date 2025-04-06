
DEFINE_BASECLASS( "HOLOHUD2_DParameter" )

local PANEL = {}

function PANEL:Init()

    local checkbox = vgui.Create( "DCheckBox", self )
    checkbox:SetWide( 15 )
    checkbox:Dock( RIGHT )
    checkbox:DockMargin( 0, 5, 4, 4 )
    checkbox.OnChange = function( _, value )

        self:OnValueChanged( value )

    end
    self.CheckBox = checkbox

end

function PANEL:GetValue()

    return self.CheckBox:GetChecked()

end

function PANEL:SetValue( value )

    self.CheckBox:SetChecked( value )

end

vgui.Register( "HOLOHUD2_DParameter_Bool", PANEL, "HOLOHUD2_DParameter" )