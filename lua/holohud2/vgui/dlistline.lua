
local PANEL = {}

Derma_Hook( PANEL, "Paint", "Paint", "ListViewLine" )

function PANEL:SetIsAlt( alt )

    self.m_bAlt = alt

end

vgui.Register( "HOLOHUD2_DListLine", PANEL, "Panel" )