local surface = surface

local PANEL = {}

local RESOURCE_INVALID  = surface.GetTextureID( "debug/debugempty" )
local RESOURCE_GRADIENT = surface.GetTextureID( "gui/gradient" )

function PANEL:Init()

    self:SetText( "" )

end

function PANEL:SetColors( colors )

    self.Colors = {}

    for _, color in SortedPairs( colors ) do

        table.insert( self.Colors, color )

    end

end

function PANEL:Paint( w, h )

    if not self.Colors then return end

    self:GetSkin():PaintListBox( self, w, h )

    if #self.Colors <= 0 then

        surface.SetDrawColor( 255, 255, 255 )
        surface.SetTexture( RESOURCE_INVALID )
        surface.DrawTexturedRect( 1, 1, w - 2, h - 2 )
        return

    elseif #self.Colors == 1 then

        surface.SetDrawColor( self.Colors[ 1 ] )
        surface.DrawRect( 1, 1, w - 2, h - 2 )

    else

        surface.SetTexture( RESOURCE_GRADIENT )

        local count = #self.Colors - 1
        local size = math.floor( w / count )

        for i=1, count do

            local x = 1 + ( i - 1 ) * ( size - 2 )

            if i == count then

                size = w - x - 1

            end

            local color = self.Colors[ i ]

            surface.SetDrawColor( color.r, color.g, color.b, math.max( color.a, 64 ) )
            surface.DrawRect( x, 1, size, h - 2 )
            surface.SetDrawColor( self.Colors[ i + 1 ] )
            surface.DrawTexturedRectUV( x, 1, size, h - 2, 1, 0, 0, 1 )

        end

    end

    if not self:IsHovered() then return end

    surface.SetDrawColor( 255, 255, 255, 50 )
    surface.DrawRect( 1, 1, w - 2, h - 2 )

end

vgui.Register( "HOLOHUD2_DColorRangesViewer", PANEL, "DButton" )