
local PANEL = {}

PANEL.presets = "options"

function PANEL:Init()

    local presets = vgui.Create( "HOLOHUD2_DPresets", self )
    presets:Dock( TOP )
    presets:DockMargin( 0, 0, 0, 4 )
    presets:Fetch( self.presets )
    presets.OnAddPreset = function( _, name )

        if not self:AddPreset( name ) then return end

        presets:Fetch( self.presets )

    end
    presets.OpenPresetsEditor = function( _ )

        local editor = vgui.Create( "HOLOHUD2_DPresetEditor" )
        editor:SetSize( 300, 400 )
        editor:Center()
        editor:MakePopup()
        editor:DoModal()
        editor:SetBackgroundBlur( true )
        editor:SetTitle( "#holohud2.derma.presets" )
        editor.OnDeletePreset = function( _, filename )

            HOLOHUD2.presets.Delete( self.presets, filename )
            editor:Populate( self.presets )
            presets:Fetch( self.presets )

        end
        editor.OnRenamePreset = function( _, filename, name )

            HOLOHUD2.presets.Rename( self.presets, filename, name )
            editor:Populate( self.presets )
            presets:Fetch( self.presets )

        end
        editor:Populate( self.presets )

    end
    presets.SelectPreset = function( _, values )

        self:OnPresetSelected( values )
        self:Populate( values )

    end
    self.Presets = presets

        local reset = vgui.Create( "DButton", presets )
        reset:Dock( LEFT )
        reset:SetWide( 212 )
        reset:SetImage( "icon16/bomb.png" )
        reset:SetText( "#holohud2.common.reset_to_default" )
        reset.DoClick = function()

            self:DoReset()

        end
        self.Reset = reset
    
    local parameters = vgui.Create( "HOLOHUD2_DProceduralCategoryList", self )
    parameters:Dock( FILL )
    parameters.OnChange = function()

        self:OnChange()

    end
    self.Parameters = parameters

end

function PANEL:Populate( modifiers )

    self.Parameters:Clear()
    HOLOHUD2.vgui.SetOptionsPanel( self.Parameters )
    HOLOHUD2.hook.Call( "PopulateOptionsMenu", modifiers )

end

function PANEL:OnChange() end
function PANEL:DoReset() end
function PANEL:OnPresetSelected( values ) end
function PANEL:AddPreset( name ) return false end

vgui.Register( "HOLOHUD2_DProperties_Options", PANEL, "Panel" )