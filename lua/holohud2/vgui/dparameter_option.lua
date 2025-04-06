
local PANEL = {}

function PANEL:Init()

    local combobox = vgui.Create( "DComboBox", self )
    combobox:SetSize( 156, 14 )
    combobox:Dock( RIGHT )
    combobox:DockMargin( 0, 2, 2, 2 )
    combobox:SetSortItems( false )
    combobox.OnSelect = function( _, i, value )

        self:OnValueChanged( i )

    end
    self.ComboBox = combobox

end

function PANEL:GetComboBox()

    return self.ComboBox

end

function PANEL:SetOptions( options )
    
    self.ComboBox:Clear()

    for _, option in ipairs( options ) do

        self.ComboBox:AddChoice( option )

    end

end

function PANEL:GetValue()

    return self.ComboBox:GetSelectedID()

end

function PANEL:SetValue( value )

    self.ComboBox:ChooseOptionID( value )

end

function PANEL:Populate( parameter )

    self:SetOptions( parameter.options )

end

vgui.Register( "HOLOHUD2_DParameter_Option", PANEL, "HOLOHUD2_DParameter" )