
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

        local topleft = buttons:AddButton( "↖", HOLOHUD2.DOCK.TOP_LEFT )
        topleft:SetPos( 0, 0 )
        topleft:SetSize( 20, 20 )

        local top = buttons:AddButton( "↑", HOLOHUD2.DOCK.TOP )
        top:SetPos( 20, 0 )
        top:SetSize( 20, 20 )

        local topright = buttons:AddButton( "↗", HOLOHUD2.DOCK.TOP_RIGHT )
        topright:SetPos( 40, 0 )
        topright:SetSize( 20, 20 )

        local left = buttons:AddButton( "←", HOLOHUD2.DOCK.LEFT )
        left:SetPos( 0, 20 )
        left:SetSize( 20, 20 )

        local center = buttons:AddButton( "", HOLOHUD2.DOCK.CENTER )
        center:SetPos( 20, 20 )
        center:SetSize( 20, 20 )

        local right = buttons:AddButton( "→", HOLOHUD2.DOCK.RIGHT )
        right:SetPos( 40, 20 )
        right:SetSize( 20, 20 )

        local bottomleft = buttons:AddButton( "↙", HOLOHUD2.DOCK.BOTTOM_LEFT )
        bottomleft:SetPos( 0, 40 )
        bottomleft:SetSize( 20, 20 )

        local bottom = buttons:AddButton( "↓", HOLOHUD2.DOCK.BOTTOM )
        bottom:SetPos( 20, 40 )
        bottom:SetSize( 20, 20 )

        local bottomright = buttons:AddButton( "↘", HOLOHUD2.DOCK.BOTTOM_RIGHT )
        bottomright:SetPos( 40, 40 )
        bottomright:SetSize( 20, 20 )
    
    self.Buttons = buttons

end

function PANEL:GetValue()

    return self.Value

end

function PANEL:SetValue( value )

    self.Buttons:SelectValue( value )

end

vgui.Register( "HOLOHUD2_DParameter_Dock", PANEL, "HOLOHUD2_DParameter" )