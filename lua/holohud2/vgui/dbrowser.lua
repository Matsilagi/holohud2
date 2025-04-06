
local PANEL = {}

function PANEL:Init()

    local list = vgui.Create( "DListView", self )
    list:Dock( FILL )
    list:SetMultiSelect( false )
    list.OnRowSelected = function( _, index, panel )

        self.Text:SetText( panel:GetValue( 1 ) )
        self.Action:SetEnabled( true )
        self.Delete:SetEnabled( string.len( panel:GetValue( 2 ) ) == 0 )

    end
    self.Column = list:AddColumn( "" )
    self.List = list

    local controls = vgui.Create( "Panel", self )
    controls:Dock( BOTTOM )
    controls:DockMargin( 0, 2, 0, 0 )

        local cancel = vgui.Create( "DButton", controls )
        cancel:Dock( RIGHT )
        cancel:DockMargin( 4, 0, 0, 0 )
        cancel:SetText( "#holohud2.derma.cancel" )
        cancel.DoClick = function()

            self:Close()

        end

        local action = vgui.Create( "DButton", controls )
        action:Dock( RIGHT )
        action:SetEnabled( false )
        action.DoClick = function()

            local _, line = list:GetSelectedLine()
            local hardcoded = line and line:GetValue( 2 ) or ""
            
            self:OnAction( self.Text:GetValue(), string.len( hardcoded ) ~= 0 and hardcoded )

        end
        list.DoDoubleClick = function()

            action:DoClick()

        end
        self.Action = action

        local delete = vgui.Create( "DButton", controls )
        delete:Dock( LEFT )
        delete:SetText( "#holohud2.derma.delete" )
        delete:SetEnabled( false )
        delete.DoClick = function()

            self:OnDelete( self.Text:GetValue() )

        end
        self.Delete = delete

    local name = vgui.Create( "Panel", self )
    name:Dock( BOTTOM )
    name:DockMargin( 4, 2, 0, 0 )

        local label = vgui.Create( "DLabel", name )
        label:Dock( LEFT )
        label:DockMargin( 0, 0, 4, 0 )
        label:SetText( "#holohud2.derma.dbrowser.name" )
        label:SizeToContents()

        local text = vgui.Create( "DTextEntry", name )
        text:Dock( FILL )
        text:DockMargin( 0, 2, 0, 2 )
        text.OnChange = function()

            action:SetEnabled( string.len( text:GetValue() ) ~= 0 )
            delete:SetEnabled( false )

        end
        self.Text = text

end

function PANEL:SetHeader( header )

    self.Column:SetName( header )

end

function PANEL:SetText( text )

    self.Text:SetText( text )

end

function PANEL:SetAction( action )

    self.Action:SetText( action )

end

function PANEL:SetEditable( edit )

    self.Text:SetEnabled( edit )

end

function PANEL:SetDeletable( delete )

    self.Delete:SetEnabled( delete )

end

function PANEL:SetContents( files, hardcoded )

    self.List:Clear()

    for i, preset in ipairs( hardcoded or {} ) do

        self.List:AddLine( preset.name, i )

    end

    for _, text in ipairs( files ) do

        self.List:AddLine( text )

    end

end

function PANEL:OnAction( selected, data ) end
function PANEL:OnDelete( selected ) end

vgui.Register( "HOLOHUD2_DBrowser", PANEL, "DFrame" )