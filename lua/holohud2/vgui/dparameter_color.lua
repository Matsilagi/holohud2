
DEFINE_BASECLASS( "HOLOHUD2_DParameter" )

local PANEL = {
    Value = color_white
}

function PANEL:Init()

    local button = vgui.Create( "HOLOHUD2_DColorButton", self )
    button:SetWide( 157 )
    button:Dock( RIGHT )
    button:DockMargin( 0, 2, 2, 2 )
    button.DoClick = function()

        local scrw, scrh = ScrW(), ScrH()
        local x, y = self:LocalToScreen( button:GetX(), button:GetY() + button:GetTall() )
        local w, h = 250, 300

        if x + w > scrw then x = scrw - w end
        if y + h > scrh then y = y - h end

        local window = vgui.Create( "HOLOHUD2_DColorPopup" )
        window:SetPos( x, y )
        window:SetSize( w, h )
        window:SetValue( self.Color )
        window:Open()

        window.OnValueChanged = function( _, value )

            self:SetValue( value )
            self:OnValueChanged( value )

        end

    end
    self.Button = button

end

function PANEL:GetValue()

    return self.Color

end

function PANEL:SetValue( value )

    self.Color = Color( value.r, value.g, value.b, value.a )
    self.Button:SetColor( self.Color )

end

vgui.Register( "HOLOHUD2_DParameter_Color", PANEL, "HOLOHUD2_DParameter" )