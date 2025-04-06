
local PANEL = {}

function PANEL:Init()

    self:SetTall( 68 )

    local buttons = vgui.Create( "HOLOHUD2_DButtonGroup", self )
    buttons:Dock( RIGHT )
    buttons:DockMargin( 0, 4, 4, 4 )
    buttons:SetSize( 60, 60 )
    buttons.OnValueSelected = function( _, value )

        self.Value = value
        self:OnValueChanged( value )

    end

        local up = buttons:AddButton( "↑", HOLOHUD2.DIRECTION_UP )
        up:SetPos( 20, 0 )
        up:SetSize( 20, 20 )

        local left = buttons:AddButton( "←", HOLOHUD2.DIRECTION_LEFT )
        left:SetPos( 0, 20 )
        left:SetSize( 20, 20 )

        local right = buttons:AddButton( "→", HOLOHUD2.DIRECTION_RIGHT )
        right:SetPos( 40, 20 )
        right:SetSize( 20, 20 )

        local down = buttons:AddButton( "↓", HOLOHUD2.DIRECTION_DOWN )
        down:SetPos( 20, 40 )
        down:SetSize( 20, 20 )
    
    self.Buttons = buttons

end

function PANEL:GetValue()

    return self.Value

end

function PANEL:SetValue( value )

    self.Buttons:SelectValue( value )

end

vgui.Register( "HOLOHUD2_DParameter_Direction", PANEL, "HOLOHUD2_DParameter" )