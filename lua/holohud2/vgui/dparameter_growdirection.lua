
local PANEL = {}

function PANEL:Init()

    self:SetTall( 68 )

    local buttons = vgui.Create( "HOLOHUD2_DButtonGroup", self )
    buttons:Dock( RIGHT )
    buttons:DockMargin( 0, 4, 4, 4 )
    buttons:SetSize( 96, 60 )
    buttons.OnValueSelected = function( _, value )

        self.Value = value
        self:OnValueChanged( value )

    end

        local up = buttons:AddButton( "↑", HOLOHUD2.GROWDIRECTION_UP )
        up:SetPos( 56, 0 )
        up:SetSize( 20, 20 )

        local left = buttons:AddButton( "←", HOLOHUD2.GROWDIRECTION_LEFT )
        left:SetPos( 36, 20 )
        left:SetSize( 20, 20 )

        local right = buttons:AddButton( "→", HOLOHUD2.GROWDIRECTION_RIGHT )
        right:SetPos( 76, 20 )
        right:SetSize( 20, 20 )

        local down = buttons:AddButton( "↓", HOLOHUD2.GROWDIRECTION_DOWN )
        down:SetPos( 56, 40 )
        down:SetSize( 20, 20 )

        local centervert = buttons:AddButton( "↕", HOLOHUD2.GROWDIRECTION_CENTER_VERTICAL )
        centervert:SetPos( 0, 6 )
        centervert:SetSize( 30, 20 )

        local centerhor = buttons:AddButton( "↔", HOLOHUD2.GROWDIRECTION_CENTER_HORIZONTAL )
        centerhor:SetPos( 0, 34 )
        centerhor:SetSize( 30, 20 )
    
    self.Buttons = buttons

end

function PANEL:GetValue()

    return self.Value

end

function PANEL:SetValue( value )

    self.Buttons:SelectValue( value )

end

vgui.Register( "HOLOHUD2_DParameter_GrowDirection", PANEL, "HOLOHUD2_DParameter" )