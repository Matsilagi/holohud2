
local PANEL = {}

function PANEL:Init()

    self:SetMouseInputEnabled( true )
    self:SetDark( true ) -- DEPRECATED
    
end

function PANEL:AddContribution( contribution )
    
    local data = HOLOHUD2.credits.Get( contribution )
    
    if not data then return end

    local image = vgui.Create( "DImageButton", self )
    image:Dock( RIGHT )
    image:DockMargin( 4, 0, 0, 0 )
    image:SetSize( 16, 16 )
    image:SetStretchToFit( false )
    image:SetImage( data.icon )
    image:SetTooltip( data.tooltip )
    image:SetDisabled( false )
    image:SetCursor( "arrow" )

end

function PANEL:SetCredits( credits )
    
    self:Clear()
    self:SetText( credits[ 1 ] )

    if not istable( credits[ 2 ] ) then

        self:AddContribution( credits[ 2 ] )
        return

    end

    local len = #credits[ 2 ]

    for i=1, len do

        self:AddContribution( credits[ 2 ][ len - ( i - 1 ) ] )

    end

end

vgui.Register( "HOLOHUD2_DCredits", PANEL, "DLabel" )