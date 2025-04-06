
local PANEL = {}

function PANEL:Init()

    local list = vgui.Create( "DListView", self )
    list:Dock( FILL )
    list:SetMultiSelect( false )
    self.Column = list:AddColumn( "" )
    self.List = list

    local controls = vgui.Create( "Panel", self )
    controls:Dock( BOTTOM )
    controls:DockMargin( 0, 4, 0, 0 )
    controls:SetTall( 20 )

    local delete = vgui.Create( "DButton", controls )
    delete:Dock( RIGHT )
    delete:DockMargin( 4, 0, 0, 0 )
    delete:SetWide( 84 )
    delete:SetText( "#holohud2.derma.delete" )
    delete:SetImage( "icon16/bin.png" )
    delete:SetEnabled( false )
    self.Delete = delete

    local rename = vgui.Create( "DButton", controls )
    rename:Dock( RIGHT )
    rename:SetWide( 84 )
    rename:SetText( "#holohud2.derma.rename" )
    rename:SetImage( "icon16/pencil.png" )
    rename:SetEnabled( false )
    self.Rename = rename

end

function PANEL:Populate( group )

    self.List:Clear()

    self.Column:SetName( HOLOHUD2.DIR .. "/" .. HOLOHUD2.presets.Location( group ) )

    for _, preset in pairs( HOLOHUD2.presets.Find( group ) ) do

        self.List:AddLine( preset.name, preset.filename )

    end

    self.List.OnRowSelected = function( _, index, line )

        self.Delete.DoClick = function()

            Derma_Query( "#holohud2.derma.preset_dialog.delete", "#holohud2.derma.warning", "#holohud2.derma.ok", function()
            
                self:OnDeletePreset( line:GetValue( 2 ) )

            end, "Cancel")
            self.Delete:SetEnabled( false )
            self.Rename:SetEnabled( false )

        end
        self.Delete:SetEnabled( true )

        self.Rename.DoClick = function()

            Derma_StringRequest( "#holohud2.derma.rename", "#holohud2.derma.preset_dialog.rename", line:GetValue( 1 ), function( name )
            
                self:OnRenamePreset( line:GetValue( 2 ), name )

            end)
            self.Delete:SetEnabled( false )
            self.Rename:SetEnabled( false )

        end
        self.Rename:SetEnabled( true )

    end

end

function PANEL:OnDeletePreset( filename ) end
function PANEL:OnRenamePreset( filename, name ) end

vgui.Register( "HOLOHUD2_DPresetEditor", PANEL, "DFrame" )