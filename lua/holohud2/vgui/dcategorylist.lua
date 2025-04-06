
local PANEL = {}

function PANEL:Init()

    local uncategorized = vgui.Create( "DSizeToContents", self:GetCanvas() )
    uncategorized:Dock( TOP )
    uncategorized:SetTall( 0 )
    uncategorized:SetSizeX( false )
    uncategorized:SetSizeY( true )
    uncategorized:InvalidateParent( true )
    self.Uncategorized = uncategorized

end

function PANEL:GetUncategorizedList()

    return self.Uncategorized

end

function PANEL:AddUncategorized( panel )

    local list = self.Uncategorized

    panel:SetParent( list )
    panel.m_bAlt = list:ChildCount() % 2 ~= 0

    list:SizeToChildren()
    list:InvalidateLayout()

end

vgui.Register( "HOLOHUD2_DCategoryList", PANEL, "DCategoryList" )