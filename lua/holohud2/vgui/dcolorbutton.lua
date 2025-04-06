local surface = surface

local PANEL = {
    Color = color_white
}

function PANEL:Init()

    self:SetText( "" )
    self:SetTooltip( "Change colour" )

end

function PANEL:SetColor( color )

    self.Color = color

end

function PANEL:Paint( w, h )

    self:GetSkin():PaintListBox( self, w, h )

    local color = self.Color
    surface.SetDrawColor( color.r, color.g, color.b, math.max( color.a, 64 ) )
    surface.DrawRect( 1, 1, w - 2, h - 2 )

    if not self:IsHovered() then return end

    surface.SetDrawColor( 255, 255, 255, 50 )
    surface.DrawRect( 1, 1, w - 2, h - 2 )

end

vgui.Register( "HOLOHUD2_DColorButton", PANEL, "DButton" )