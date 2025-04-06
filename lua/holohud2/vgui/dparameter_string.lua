
local PANEL = {}

function PANEL:Init()

    local textentry = vgui.Create( "DTextEntry", self )
    textentry:SetSize( 156, 14 )
    textentry:Dock( RIGHT )
    textentry:DockMargin( 0, 2, 2, 2 )
    textentry.OnChange = function( _ )
        
        self:OnValueChanged( textentry:GetValue() )

    end
    self.TextEntry = textentry

end

function PANEL:GetValue()

    return self.TextEntry:GetValue()

end

function PANEL:SetValue( value )

    self.TextEntry:SetValue( value )

end

vgui.Register( "HOLOHUD2_DParameter_String", PANEL, "HOLOHUD2_DParameter" )