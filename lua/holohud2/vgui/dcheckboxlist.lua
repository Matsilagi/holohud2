
DEFINE_BASECLASS( "DListView" )

local PANEL = {}

function PANEL:AddLine( ... )

    local line = BaseClass.AddLine( self, ... )

    local checkbox = vgui.Create( "DCheckBox", line )
    checkbox:Dock( RIGHT )
    checkbox:DockMargin( 1, 1, 1, 1 )
    checkbox:SetSize( 15, 15 )
    checkbox.OnChange = function( _, value )
        
        line:OnChange( value )

    end

    line.SetChecked = function( _, value )

        checkbox:SetChecked( value )

    end

    line.OnChange = function( _, value ) end

    self:SetMultiSelect( false )

    return line

end

function PANEL:PerformLayout()

    BaseClass.PerformLayout( self )

    for _, line in pairs( self.Lines ) do

        line:DockPadding( 0, 0, self.VBar:IsVisible() and 14 or 0, 0 )

    end

end

vgui.Register( "HOLOHUD2_DCheckBoxList", PANEL, "DListView" )
