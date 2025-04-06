
local PANEL = {}

function PANEL:Init()

    local label = vgui.Create( "DLabel", self )
    label:Dock( LEFT )
    label:DockMargin( 8, 0, 0, 0 )
    label:SetTextColor( self:GetSkin().Colours.Label.Dark )
    self.Label = label

end

function PANEL:SetText( text )

    self.Label:SetText( text )
    self.Label:SizeToContents()

end

vgui.Register( "HOLOHUD2_DListLineLabel", PANEL, "HOLOHUD2_DListLine" )