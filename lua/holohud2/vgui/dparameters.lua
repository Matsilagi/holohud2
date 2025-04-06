
local PANEL = {}

function PANEL:Init()

    self.Parameters = {}
    self.Collapsibles = {}
    self.Tabs = {}

end

function PANEL:Populate( element, advanced )

    self.Parameters = {}
    self:Clear()

    local menu = advanced and element.menu or element.quickmenu

    local fallback -- fallback parent

    local tabs = {}
    self.Tabs = {}

    -- if there are tabs, setup a property sheet
    if #menu.tabs ~= 0 then

        local sheet = vgui.Create( "DPropertySheet", self )
        sheet:Dock( FILL )
        sheet.OnActiveTabChanged = function( _, _, tab )
            
            self:OnTabChanged( tab.i )

        end
        self.PropertySheet = sheet

        for _, tab in ipairs( menu.tabs ) do

            local panel = vgui.Create( "HOLOHUD2_DCategoryList" )
            local tab = sheet:AddSheet( tab.name, panel, tab.icon, false, false, tab.helptext )
            table.insert( tabs, panel )
            tab.Tab.i = table.insert( self.Tabs, tab.Tab )

        end

        -- create a fallback panel for parameters without a tab
        local panel = vgui.Create( "DPanel", self )
        panel:Dock( TOP )
        panel:DockMargin( 0, 0, 0, 4 )
        panel:SetTall( 96 )
        panel:SetVisible( false ) -- if not populated, it'll stay hidden
        panel.Paint = function( self, w, h )

            derma.SkinHook( "Paint", "CategoryList", self, w, h )

        end

        fallback = vgui.Create( "DScrollPanel", panel )
        fallback:Dock( FILL )
    
    else

        fallback = vgui.Create( "HOLOHUD2_DCategoryList", self )
        fallback:Dock( FILL )

    end

    -- add categories to the list
    local categories = {}

    for _, category in ipairs( menu.categories ) do

        local control = ( tabs[ category.tab ] or fallback ):Add( category.name )
        control:SetTooltip( category.helptext )

        table.insert( categories, control )

    end

    -- parse parameters
    local parents   = {} -- child parameter containers
    local count     = {} -- parameter counting ignoring collapsible panels

    for i, parameter in ipairs( menu.parameters ) do

        local data = element.parameters[ parameter.id ]
        local parent = ( parameter.parent and parents[ parameter.parent ] ) or
                       ( parameter.category and categories[ parameter.category ] ) or
                       ( parameter.tab and tabs[ parameter.tab ].Uncategorized ) or
                       fallback.Uncategorized or fallback -- non-tabbed list

        parent:GetParent():SetVisible( true ) -- NOTE: I'll be honest, this is just in case we need to add this to the untabbed list and thus, make it appear
        
        local panel = vgui.Create( HOLOHUD2.vgui.GetParameterControl( data and data.type or "none" ), parent )
        panel:Dock( TOP )
        panel:SetName( parameter.name or ( data and data.name ) or parameter.id or "undefined" )
        panel:SetTooltip( parameter.helptext or ( data and data.helptext ) )
        panel:Populate( data )
        panel.OnValueChanged = function( _, value )

            if self.PreventUpdate then return end

            panel:SetResettable( true )
            self:OnValueChanged( parameter.id, value )

        end
        panel.OnValueReset = function( _ )

            self.PreventUpdate = true

            panel:SetResettable( false )
            panel:SetValue( data.value )

            self:OnValueReset( parameter.id )
            
            self.PreventUpdate = false

        end
        panel.OnExpandChanged = function( _, expanded )

            self:OnPanelExpanded( i, expanded )

        end
        self.Collapsibles[ i ] = panel

        -- paint the odd lines
        local amount = count[ parent ] or 0
        local is_alt = amount % 2 ~= 0
        panel:SetIsAlt( is_alt )
        count[ parent ] = amount + 1

        -- create container for child parameters
        if parameter.parameters then
            
            local children = vgui.Create( "HOLOHUD2_DCollapsiblePanel", parent )
            children:Dock( TOP )
            
            panel:SetCollapsiblePanel( children )
            count[ children ] = is_alt and 0 or 1

            parents[ i ] = children

        end

        if not data then continue end

        self.Parameters[ parameter.id ] = panel

    end

end

function PANEL:SetState( state, tab )
    
    if tab and self.Tabs[ tab ] then

        self.PropertySheet:SetActiveTab( self.Tabs[ tab ] )

    end

    for i, expanded in pairs( state ) do
        
        if not self.Collapsibles[ i ] then continue end

        self.Collapsibles[ i ]:SetExpanded( expanded )

    end

end

function PANEL:SetValues( default, values )

    self.PreventUpdate = true

    for parameter, control in pairs( self.Parameters ) do
        
        if default[ parameter ] == nil then continue end

        local value = default[ parameter ]
        local found = values and values[ parameter ] ~= nil -- user settings found
        
        -- use settings if found
        if found then

            value = values[ parameter ]

        end

        control:SetValue( value )
        control:SetResettable( found )

    end

    self.PreventUpdate = nil

end

function PANEL:OnValueChanged( parameter, value ) end
function PANEL:OnValueReset( parameter ) end
function PANEL:OnPanelExpanded( parameter, value ) end
function PANEL:OnTabChanged( tab ) end

vgui.Register( "HOLOHUD2_DParameters", PANEL, "Panel" )