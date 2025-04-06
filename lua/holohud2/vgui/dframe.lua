
local PANEL = {}

function PANEL:Init()

    self:SetTitle( "#holohud2.properties" )

    local menubar = vgui.Create( "DMenuBar", self )
    menubar:Dock( TOP )
    self.MenuBar = menubar

    local footer = vgui.Create( "Panel", self )
    footer:Dock( BOTTOM )

        local apply = vgui.Create( "DButton", footer )
        apply:Dock( RIGHT )
        apply:SetSize( 72, 24 )
        apply:SetText( "#holohud2.derma.apply" )
        apply.DoClick = function( _ )

            self:DoApply()

        end

        local cancel = vgui.Create( "DButton", footer )
        cancel:DockMargin( 0, 0, 4, 0 )
        cancel:Dock( RIGHT )
        cancel:SetSize( 72, 24 )
        cancel:SetText( "#holohud2.derma.cancel" )
        cancel.DoClick = function( _ )

            self:Close()

        end

        local ok = vgui.Create( "DButton", footer )
        ok:DockMargin( 0, 0, 4, 0 )
        ok:Dock( RIGHT )
        ok:SetSize( 72, 24 )
        ok:SetText( "#holohud2.derma.ok" )
        ok.DoClick = function( _ )

            self:DoApply()
            self:Close()

        end

end

function PANEL:AddMenu( menu )

    return self.MenuBar:AddMenu( menu )

end

function PANEL:DoApply() end

vgui.Register( "HOLOHUD2_DFrame", PANEL, "DFrame" )