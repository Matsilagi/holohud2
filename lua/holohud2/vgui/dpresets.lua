
local PANEL = {}

function PANEL:Init()

    local edit = vgui.Create( "DImageButton", self )
    edit:Dock( RIGHT )
    edit:DockMargin( 4, 0, 0, 0 )
    edit:SetWide( 16 )
    edit:SetStretchToFit( false )
    edit:SetImage( "icon16/wrench.png" )
    edit:SetTooltip( "#holohud2.derma.presets.edit" )
    edit.DoClick = function()

        self:OpenPresetsEditor()

    end

    local add = vgui.Create( "DImageButton", self )
    add:Dock( RIGHT )
    add:DockMargin( 4, 0, 0, 0 )
    add:SetWide( 16 )
    add:SetStretchToFit( false )
    add:SetImage( "icon16/add.png" )
    add:SetTooltip( "#holohud2.derma.presets.add" )
    add.DoClick = function()

        Derma_StringRequest( "#holohud2.derma.presets.save", "#holohud2.derma.presets.save_dialog", "", function( name )
                
            self:OnAddPreset( name )

        end)

    end

    local combobox = vgui.Create( "DComboBox", self )
    combobox:Dock( RIGHT )
    combobox:SetWide( 256 )
    combobox:DockMargin( 0, 2, 0, 2 )
    combobox:SetSortItems( false )
    combobox.OnSelect = function( _, i, value, data )

        self:SelectPreset( data )

    end
    self.Presets = combobox

end

function PANEL:Fetch( group )

    local presets = self.Presets
    local hardcoded, files = HOLOHUD2.presets.Get( group )
    
    presets:Clear()

    if #hardcoded ~= 0 then

        for _, preset in ipairs( hardcoded ) do

            presets:AddChoice( preset.name, preset.values )

        end

        if not table.IsEmpty( files ) then

            presets:AddSpacer()

        end

    end

    for _, preset in ipairs( files ) do

        presets:AddChoice( preset.name, preset.values )

    end

end

function PANEL:OpenPresetsEditor() end
function PANEL:OnAddPreset( name ) end
function PANEL:SelectPreset( values ) end

vgui.Register( "HOLOHUD2_DPresets", PANEL, "Panel" )