
local PANEL = {}

function PANEL:Init()
    
    self.Lines = {}

    local advanced = vgui.Create( "Panel", self )
    advanced:Dock( TOP )

        local checkbox = vgui.Create( "DCheckBoxLabel", advanced )
        checkbox:SetText( "#holohud2.derma.properties.parameters.advanced" )
        checkbox.OnChange = function( _, value )

            self:OnAdvancedToggle( value )

        end
        self.Advanced = checkbox

    local list = vgui.Create( "HOLOHUD2_DCheckBoxList", self )
    list:SetWide( 156 )
    list:Dock( LEFT )
    list:DockMargin( 0, 0, 4, 0 )
    list:SetHideHeaders( true )
    list:AddColumn( "" )
    list.OnRowSelected = function( _, _, line )

        local id = line:GetValue( 2 )

        self:OnSelected( id )

    end
    self.List = list

    local contents = vgui.Create( "Panel", self )
    contents:Dock( FILL )
    self.Contents = contents

    for _, id in ipairs( HOLOHUD2.element.Index() ) do

        local element = HOLOHUD2.element.Get( id )

        local line = list:AddLine( element.name, id )
        line:SetTooltip( element.helptext )
        line.OnChange = function( _, value )

            self:OnVisibilityChanged( id, value )

            if self.SelectedID ~= id then return end

            self.Selected:SetVisibility( value )

        end
        self.Lines[ id ] = line

    end

    self:UnSelect()

end

function PANEL:SetAdvancedToggle( advanced )

    self.Advanced:SetChecked( advanced )

end

function PANEL:UnSelect()

    self.Contents:Clear()
    self.List:ClearSelection()

    local hint = vgui.Create( "HOLOHUD2_DHint", self.Contents )
    hint:Dock( TOP )
    hint:SetText( "#holohud2.derma.properties.parameters.hint" )
    hint:SetIcon( "icon16/error.png" )

    local empty = vgui.Create( "DLabel", self.Contents )
    empty:Dock( FILL )
    empty:SetContentAlignment( 5 )
    empty:SetText( "#holohud2.derma.properties.parameters.empty" )

    self.SelectedID = nil
    self.Selected = nil

end

function PANEL:Select( id, advanced )
    
    local element = HOLOHUD2.element.Get( id )

    self.Lines[ id ]:SetSelected( true )
    self.Contents:Clear()

    local properties = vgui.Create( "HOLOHUD2_DElementProperties", self.Contents )
    properties:Dock( FILL )
    properties:SetHelpText( element.helptext )
    properties:SetVisibility( self:FetchElementVisibility( id, element ) )
    properties:SetPresets( id )
    properties:Populate( element, advanced )
    properties.OnVisibilityChanged = function( _, visible )

        local _, line = self.List:GetSelectedLine()
        line:SetChecked( visible )
        self:OnVisibilityChanged( id, visible )

    end
    properties.PaintPreview = function( _, x, y, w, h )

        self:PaintPreview( x, y, w, h )

    end
    properties.DeletePreset = function( _, filename )

        HOLOHUD2.preset.Delete( id, filename )

    end
    properties.RenamePreset = function( _, filename, name )

        HOLOHUD2.preset.Rename( id, filename, name )

    end

    self.SelectedID = id
    self.Selected = properties
    
    return properties

end

function PANEL:GetSelectedID()

    return self.SelectedID

end

function PANEL:GetSelectedPanel()

    return self.Selected

end

function PANEL:GetAdvancedToggle()

    return self.Advanced:GetChecked()

end

function PANEL:OnAdvancedToggle( advanced ) end
function PANEL:OnSelected( id ) end
function PANEL:OnVisibilityChanged( id, visible ) end
function PANEL:FetchElementVisibility( id, element ) return false end
function PANEL:PaintPreview( x, y, w, h ) end

vgui.Register( "HOLOHUD2_DProperties_Advanced", PANEL, "Panel" )