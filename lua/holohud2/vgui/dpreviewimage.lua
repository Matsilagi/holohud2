
local PANEL = {}

local BACKGROUNDS = {
    "holohud2/preview0.png",
    "holohud2/preview1.png",
    "holohud2/preview2.png",
    "holohud2/preview3.png",
    "holohud2/preview4.png"
}

function PANEL:Init()

    self.Image = math.random( 1, #BACKGROUNDS )

    self:SetImage( BACKGROUNDS[ self.Image ] )

    local next = vgui.Create( "DButton", self )
    next:SetPos( 4, 4 )
    next:SetSize( 24, 24 )
    next:SetText( "" )
    next:SetImage( "icon16/photos.png" )
    next:SetTooltip( "#holohud2.derma.dpreview.next" )
    next.DoClick = function()

        self.Image = self.Image + 1

        if self.Image > #BACKGROUNDS then

            self.Image = 1

        end

        self:SetImage( BACKGROUNDS[ self.Image ] )

    end

end

vgui.Register( "HOLOHUD2_DPreviewImage", PANEL, "DImage" )