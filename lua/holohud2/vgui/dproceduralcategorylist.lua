
local PANEL = {}

function PANEL:Init()

    self.Categories = {}

end

function PANEL:Clear()

    self.Uncategorized:Clear()

    for i, child in pairs( self.Categories ) do

        child:Remove()
        self.Categories[ i ] = nil

    end

end

function PANEL:FetchCategory( name )

    if not name or string.len( name ) == 0 then return self.Uncategorized end

    local category = self.Categories[ name ]

    if not category then

        category = self:Add( name )
        self.Categories[ name ] = category

    end

    return category

end

function PANEL:AddToCategory( panel, name )

    panel:SetParent( self:FetchCategory( name ) )

end

vgui.Register( "HOLOHUD2_DProceduralCategoryList", PANEL, "HOLOHUD2_DCategoryList" )