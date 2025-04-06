
local PANEL = {}

function PANEL:Init()

    self:SetTitle( "Export" )

    local text = vgui.Create( "DTextEntry", self )
    text:Dock( FILL )
    text:SetMultiline( true )
    self.Text = text

    local footer = vgui.Create( "Panel", self )
    footer:Dock( BOTTOM )
    footer:DockMargin( 4, 4, 0, 0 )
    footer:DockPadding( 1, 1, 1, 1 )
    
        local close = vgui.Create( "DButton", footer )
        close:Dock( RIGHT )
        close:SetText( "Close" )
        close.DoClick = function()

            self:Close()

        end

        local copied = vgui.Create( "DLabel", footer )
        copied:Dock( LEFT )
        copied:SetText( "#holohud2.derma.properties.export.clipboard_message" )
        copied:SizeToContents()
        copied:Hide()

        local copy = vgui.Create( "DButton", footer )
        copy:Dock( RIGHT )
        copy:DockMargin( 0, 0, 4, 0 )
        copy:SetWide( 132 )
        copy:SetText( "#holohud2.derma.properties.export.clipboard" )
        copy.DoClick = function()

            copied:Show()
            SetClipboardText( text:GetValue() )

        end

    self:DoModal()
    self:SetBackgroundBlur( true )
    self:MakePopup()

end

function PANEL:SetText( text )

    self.Text:SetValue( text )

end

vgui.Register( "HOLOHUD2_DExportWindow", PANEL, "DFrame" )