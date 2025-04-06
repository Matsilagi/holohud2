
local PANEL = {}

function PANEL:Init()

    self.Buttons = {}

end

function PANEL:AddButton( label, value )

    local button = vgui.Create( "DButton", self )
    button:SetIsToggle( true )
    button:SetText( label )
    button.DoClick = function()

        for _, neighbour in pairs( self.Buttons ) do

            neighbour:SetToggle( false )

        end

        button:SetToggle( true )
        self:OnValueSelected( value )

    end

    self.Buttons[ value ] = button

    return button

end

function PANEL:SelectValue( value )

    if not self.Buttons[ value ] then return end

    self.Buttons[ value ]:DoClick()

end

function PANEL:OnValueSelected( value ) end

vgui.Register( "HOLOHUD2_DButtonGroup", PANEL, "Panel" )