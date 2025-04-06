
local PANEL = {}

function PANEL:Init()

    self:SetTall( 128 )

    local control = vgui.Create( "Panel", self )
    control:Dock( RIGHT )
    control:DockMargin( 4, 4, 4, 4 )
    control:SetWide( 256 )

    local listview = vgui.Create( "DListView", control )
    listview:Dock( FILL )
    listview:SetSortable( false )
    listview:SetHideHeaders( true )
    listview:AddColumn( "#holohud2.derma.stringtable.strings" )
    listview.OnRowSelected = function()
        
        local multiselect = #listview:GetSelected()

        self.Up:SetEnabled( multiselect == 1 )
        self.Down:SetEnabled( multiselect == 1 )
        self.Delete:SetEnabled( true )

    end
    listview:SetTooltip( "#holohud2.derma.stringtable.tooltip" )
    listview.DoDoubleClick = function( _, _, line )

        Derma_StringRequest( "#holohud2.derma.stringtable.edit", "#holohud2.derma.stringtable.edit.dialog", line:GetValue( 1 ), function( value )
        
            if string.len( value ) <= 0 then
                
                Derma_Message( "#holohud2.derma.stringtable.error", "#holohud2.derma.error", "#holohud2.derma.ok" )
                return

            end

            line:SetValue( 1, value )
            self:OnValueChanged( self:GetValue() )

        end)

    end
    self.ListView = listview

    local buttons = vgui.Create( "Panel", control )
    buttons:SetTall( 22 )
    buttons:Dock( BOTTOM )
    buttons:DockMargin( 0, 4, 0, 0 )

    local down = vgui.Create( "DButton", buttons )
    down:SetWide( 22 )
    down:SetText( "↓" )
    down:Dock( RIGHT )
    down:DockMargin( 2, 0, 0, 0 )
    down:SetEnabled( false )
    down.DoClick = function()

        local id, line = listview:GetSelectedLine()

        if id >= #listview:GetLines() then return end

        local next = listview:GetLine( id + 1 )
        local value = line:GetValue( 1 )
        line:SetValue( 1, next:GetValue( 1 ) )
        next:SetValue( 1, value )
        listview:ClearSelection()
        listview:SelectItem( next )
        self:OnValueChanged( self:GetValue() )

    end
    self.Down = down

    local up = vgui.Create( "DButton", buttons )
    up:SetWide( 22 )
    up:SetText( "↑" )
    up:Dock( RIGHT )
    up:DockMargin( 4, 0, 0, 0 )
    up:SetEnabled( false )
    up.DoClick = function()

        local id, line = listview:GetSelectedLine()

        if id <= 1 then return end

        local prev = listview:GetLine( id - 1 )
        local value = line:GetValue( 1 )
        line:SetValue( 1, prev:GetValue( 1 ) )
        prev:SetValue( 1, value )
        listview:ClearSelection()
        listview:SelectItem( prev )
        self:OnValueChanged( self:GetValue() )

    end
    self.Up = up

    local delete = vgui.Create( "DButton", buttons )
    delete:SetWide( 101 )
    delete:Dock( RIGHT )
    delete:SetText( "#holohud2.derma.stringtable.remove" )
    delete:SetImage( "icon16/bin.png" )
    delete:DockMargin( 4, 0, 0, 0 )
    delete:SetEnabled( false )
    delete.DoClick = function()

        for _, line in ipairs( listview:GetSelected() ) do

            listview:RemoveLine( line:GetID() )

        end

        delete:SetEnabled( false )
        self.Add:SetEnabled( true )
        self:OnValueChanged( self:GetValue() )
        self.Up:SetEnabled( false )
        self.Down:SetEnabled( false )

    end
    self.Delete = delete

    local add = vgui.Create( "DButton", buttons )
    add:SetWide( 101 )
    add:Dock( RIGHT )
    add:SetText( "#holohud2.derma.stringtable.new" )
    add:SetImage( "icon16/add.png" )
    add.DoClick = function()

        Derma_StringRequest( "#holohud2.derma.stringtable.new", "#holohud2.derma.stringtable.dialog", "", function( value )
        
            if string.len( value ) <= 0 then

                Derma_Message( "#holohud2.derma.stringtable.error", "#holohud2.derma.error", "#holohud2.derma.ok" )
                return

            end

            listview:AddLine( value )
            add:SetEnabled( #listview:GetLines() < 32 )
            self:OnValueChanged( self:GetValue() )

        end, nil, "#holohud2.derma.ok", "#holohud2.derma.cancel")

    end
    self.Add = add

end

function PANEL:GetValue()

    local list = {}

    for _, line in pairs( self.ListView:GetLines() ) do
        
        table.insert( list, line:GetValue( 1 ) )

    end

    return list

end

function PANEL:SetValue( value )

    self.ListView:Clear()

    for _, line in ipairs( value ) do

        self.ListView:AddLine( line )

    end

    self.Add:SetEnabled( #value < 32 )
    self.Delete:SetEnabled( false )
    self.Up:SetEnabled( false )
    self.Down:SetEnabled( false )
    self.ListView:ClearSelection()

end

vgui.Register( "HOLOHUD2_DParameter_StringList", PANEL, "HOLOHUD2_DParameter" )