--- 
--- HUD element registration.
---

HOLOHUD2.element = {}

local hook_Call = HOLOHUD2.hook.Call

local default   = {} -- all default values
local elements  = {}
local index     = {}

local inspecting = false
local minimized = false

---
--- Define ELEMENT structure.
---
local ELEMENT = {}

--- Called during registration.
--- You can define parameters here.
function ELEMENT:Init() end

--- Sets the default visibility.
--- @param visible boolean
function ELEMENT:SetDefaultVisibility( visible )

    self.visible = visible

end

--- Sets the name of the element.
--- @param name string
function ELEMENT:SetName( name )

    self.name = name

end

--- Sets the description of the element.
--- @param helptext string
function ELEMENT:SetDescription( helptext )

    self.helptext = helptext

end

--- Sets the list of CHud elements hidden when this element is visible.
--- @param hide table|string CHud elements to hide
function ELEMENT:SetCHudOverridden( hide )

    self.hide = istable( hide ) and hide or { hide }

end

--- Sets whether this element should draw on DrawOverlay.
--- @param on_overlay boolean
function ELEMENT:SetDrawOnOverlay( on_overlay )

    self.on_overlay = on_overlay

end

--- Adds a parameter.
--- @param id string
--- @param parameter table
function ELEMENT:DefineParameter( id, parameter )

    parameter.id = id
    self.parameters[ id ] = parameter

    hook_Call( "OnParameterDefined", self, parameter )

    self.values[ id ] = parameter.value
    default[ self.id ][ id ] = parameter.value

end

--- Parses the parameters.
--- @param parameters table
function ELEMENT:ParseParameters( parameters )

    for id, parameter in pairs( parameters ) do
        
        self:DefineParameter( id, parameter )

    end

end

--- Adds a tab to a menu.
--- @param menu table
--- @param name string
--- @param tab table
--- @return number i order in list
function ELEMENT:DefineMenuTab( menu, name, tab )

    local i = table.insert( menu.tabs, { name = name or tab.name, icon = tab.icon, helptext = tab.helptext } )

    if not tab.parameters or table.IsEmpty( tab.parameters ) then return i end

    self:ParseMenuParameters( menu, tab.parameters, { tab = i } )

    return i

end

--- Adds a category to a menu.
--- @param menu table
--- @param name string
--- @param category table
--- @return number i order in list
function ELEMENT:DefineMenuCategory( menu, name, category )

    local i = table.insert( menu.categories, { name = name, tab = category.tab, helptext = category.helptext } )

    if not category.parameters or table.IsEmpty( category.parameters ) then return i end

    self:ParseMenuParameters( menu, category.parameters, { category = i } )

    return i

end

--- Adds a parameter parameter to a menu.
--- @param menu table
--- @param parameter table
--- @return number i order in list
function ELEMENT:DefineMenuParameter( menu, parameter )

    local i = table.insert( menu.parameters, parameter )

    if not parameter.parameters or table.IsEmpty( parameter.parameters ) then return i end

    parameter.parameters = self:ParseMenuParameters( menu, parameter.parameters, { parent = i } )

    return i

end

--- Parses a list of menu parameters.
--- @param menu table
--- @param parameters table
--- @param parent table
--- "parent" can contain three different types of parents: "tab", "category" or "parent" (the latter for parameters or groups)
function ELEMENT:ParseMenuParameters( menu, parameters, parent )

    parent = parent or {}

    local result = {} -- added parameters

    for _, parameter in ipairs( parameters ) do

        if parameter.tab then

            if parent and not table.IsEmpty( parent ) then
                
                ErrorNoHaltWithStack( "Attempted adding nested tab '" .. parameter.tab .. "' into '" .. self.id .. "'! Skipping..." )
                continue

            end

            self:DefineMenuTab( menu, parameter.tab, {
                icon        = parameter.icon,
                parameters  = parameter.parameters
            } )

            continue

        end

        if parameter.category then

            if parent and parent.category then
                
                ErrorNoHaltWithStack( "Attempted adding a nested category '" .. parameter.category .. "' into '" .. self.id .. "' ! Skipping..." )
                continue

            end

            self:DefineMenuCategory( menu, parameter.category, {
                tab         = parent.tab,
                helptext    = parameter.helptext,
                parameters  = parameter.parameters
            } )

            continue

        end

        parameter.tab       = parent.tab
        parameter.category  = parent.category
        parameter.parent    = parent.parent

        table.insert( result, self:DefineMenuParameter( menu, parameter ) )

    end

    return result

end

--- Returns the current menu structure.
--- @return table menu
function ELEMENT:GetMenu()

    return self.menu

end

--- Finds a quick menu tab with the given name.
--- @param name string
--- @return number
function ELEMENT:FindMenuTab( name )

    for i, tab in ipairs( self.menu.tabs ) do

        if tab.name ~= name then continue end

        return i

    end

end

--- Adds a menu tab.
--- @param name string
--- @param tab table
--- @return number i order in list
function ELEMENT:AddMenuTab( name, tab )

    return self:DefineMenuTab( self.menu, name, tab )

end

--- Adds a menu category.
--- @param name string
--- @param category table
--- @return number i order in list
function ELEMENT:AddMenuCategory( name, category )

    return self:DefineMenuCategory( self.menu, name, category )

end

--- Adds a menu parameter.
--- @param parameter table
--- @return number i order in list
function ELEMENT:AddMenuParameter( parameter )

    return self:DefineMenuParameter( self.menu, parameter )

end

--- Returns the current quick menu structure.
--- @return table quickmenu
function ELEMENT:GetQuickMenu()

    return self.quickmenu

end

--- Finds a quick menu tab with the given name.
--- @param name string
--- @return number
function ELEMENT:FindQuickTab( name )

    for i, tab in ipairs( self.quickmenu.tabs ) do

        if tab.name ~= name then continue end

        return i

    end

end

--- Adds a quick menu tab.
--- @param name string
--- @param tab table
--- @return number i order in list
function ELEMENT:AddQuickTab( name, tab )

    return self:DefineMenuTab( self.quickmenu, name, tab )

end

--- Adds a quick menu category.
--- @param name string
--- @param category table
--- @return number i order in list
function ELEMENT:AddQuickCategory( name, category )

    return self:DefineMenuCategory( self.quickmenu, name, category )

end

--- Adds a quick menu parameter.
--- @param parameter table
--- @return number i order in list
function ELEMENT:AddQuickParameter( parameter )

    return self:DefineMenuParameter( self.quickmenu, parameter )

end

--- Returns the list of parameters.
--- @return table parameters
function ELEMENT:GetParameters()

    return self.parameters

end

--- Returns the list of the default values for each parameter.
--- @return table values
function ELEMENT:GetDefaultValues()

    return self.values

end

--- Returns the visibility of this element.
--- @return boolean visibility
function ELEMENT:IsVisible()

    return self.visible

end

--- Returns whether this element has a custom preview implemented.
--- @return boolean has_preview
function ELEMENT:HasPreview()

    return self.PreviewPaint ~= ELEMENT.PreviewPaint

end

--- Called during pre draw to run logic.
--- @param table settings
function ELEMENT:PreDraw( settings ) end

--- Called when drawing the frame layer.
--- @param settings table
--- @param x number
--- @param y number
function ELEMENT:PaintFrame( settings, x, y ) end

--- Called when drawing the background layer.
--- @param settings table
--- @param x number
--- @param y number
function ELEMENT:PaintBackground( settings, x, y ) end

--- Called when drawing the foreground layer.
--- @param settings table
--- @param x number
--- @param y number
function ELEMENT:Paint( settings, x, y ) end

--- Called when drawing the scanlines layer.
--- @param settings table
--- @param x number
--- @param y number
function ELEMENT:PaintScanlines( settings, x, y ) end

--- Called after having drawn everything ignoring post processing.
--- @param settings table
function ELEMENT:PaintOver( settings ) end

--- Called when the preview panel is created in case additional
--- controls must be added to change preview parameters.
--- @param panel Panel
function ELEMENT:PreviewInit( panel ) end

--- Called when the menu is open to draw a preview of this element.
--- @param x number
--- @param y number
--- @param w number
--- @param h number
--- @param settings table
function ELEMENT:PreviewPaint( x, y, w, h, settings ) end

--- Called when the preview settings changed.
--- @param settings table
function ELEMENT:OnPreviewChanged( settings ) end

--- Called before the startup sequence starts.
function ELEMENT:QueueStartup() end

--- Called when its this element's turn to run the startup animation.
--- If the function IsStartupOver does not return anything, it will be called at the end of the startup sequence.
function ELEMENT:Startup() end

--- Called when the HUD tried to cancel the startup animation.
function ELEMENT:CancelStartup() self:Startup() end

--- Returns the message shown on the log when this element starts its startup sequence.
--- @return string|nil message
function ELEMENT:GetStartupMessage() end

--- Called constantly during the suit startup to check whether this element's animation is over so it can proceed.
--- Return nothing so this element is skipped until the end.
--- @return boolean|nil is_over
function ELEMENT:IsStartupOver() end

--- Called when this element is forcefully supposed to show.
function ELEMENT:IsInspecting()

    return inspecting

end

--- Called when this element is forcefully supposed to hide.
function ELEMENT:IsMinimized()

    return minimized

end

--- Called after new settings have been applied.
--- @param settings table
function ELEMENT:OnSettingsChanged( settings ) end

--- Called after the screen size changes.
function ELEMENT:OnScreenSizeChanged() end

--- Registers a new element.
--- @param id string
--- @param element table
function HOLOHUD2.element.Register( id, element )

    local parameters = element.parameters or {}
    local menu = element.menu or {}
    local quickmenu = element.quickmenu or {}
    
    local visible = true
    if element.visible ~= nil then visible = element.visible end

    table.Inherit( element, ELEMENT )
    element.id = id
    element.hide = istable( element.hide ) and element.hide or { element.hide }

    element.parameters      = {}
    element.menu            = {
        tabs        = {},
        categories  = {},
        parameters  = {}
    }
    element.quickmenu       = {
        tabs        = {},
        categories  = {},
        parameters  = {}
    }

    -- NOTE: visibility parameter is ALWAYS present
    element.values          = { _visible = visible }
    default[ id ]           = { _visible = visible }

    -- parse parameters
    element:ParseParameters( parameters )
    element:ParseMenuParameters( element.menu, menu )
    element:ParseMenuParameters( element.quickmenu, quickmenu )

    -- initialize
    element:Init()

    -- register element
    elements[ id ] = element

    HOLOHUD2.hook.Call( "OnElementRegistered", element )
    
    return element, table.insert( index, id )

end

--- Returns the default values of an element or the entire HUD.
--- @param id string|nil element's identifier
--- @return table default
function HOLOHUD2.element.GetDefaultValues( id )

    if id then

        return elements[ id ].values

    end

    return default

end

--- Gets an element by identifier.
--- @param id string
--- @return table element
function HOLOHUD2.element.Get( id )

    return elements[ id ]

end

--- Returns all registered elements.
--- @return table elements
function HOLOHUD2.element.All()

    return elements

end

--- Returns the order of registration of elements.
--- @return table index
function HOLOHUD2.element.Index()

    return index

end

--- Calls the OnScreenSizeChanged event on all elements.
function HOLOHUD2.element.OnScreenSizeChanged()

    for _, element in pairs( elements ) do

        element:OnScreenSizeChanged()

    end

end

---
--- Running hooks on every element is pretty expensive so let's cache them instead.
---
hook.Add( "PreDrawHUD", "holohud2_element", function()

    if not HOLOHUD2.IsEnabled() then return end

    inspecting = hook_Call( "IsInspectingHUD" )
    minimized = hook_Call( "IsMinimized" )

end)