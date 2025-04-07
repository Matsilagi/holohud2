local PANEL = {}

local current

function PANEL:Init()

    if current and IsValid( current ) then

        self:Close()
    
    end

    self:SetTitle( "" )

    local colormixer = vgui.Create( "DColorMixer", self )
    colormixer:Dock( FILL )
    colormixer:DockMargin( 0, 0, 0, 4 )
    colormixer.ValueChanged = function( _, value )
        
        self:OnValueChanged( colormixer:GetColor() )

    end
    self.ColorMixer = colormixer

    current = self

end

function PANEL:Open()

    self:MakePopup()
    self:InvalidateLayout( true )

    local x, y = self:CursorPos()
    local w, h = self:GetSize()
    local scrw, scrh = ScrW(), ScrH()

    if x + w > scrw then x = scrw - w end
    if y + h > scrh then y = y - h end

    self:SetPos( x, y )

end

function PANEL:OnMousePressed( code )

    local x, y = self:LocalCursorPos()

    if x >= 0 and x <= self:GetWide() and y >= 0 and y <= self:GetTall() then return end

    self:Close()

end

function PANEL:SetValue( value )

    self.ColorMixer:SetColor( Color( value.r, value.g, value.b, value.a ) )

end

function PANEL:OnValueChanged(value) end

vgui.Register( "HOLOHUD2_DColorPopup", PANEL, "DFrame" )

---
--- Close colour popup window if it loses focus.
---
hook.Add( "VGUIMousePressed", "holohud2_dcolorpopup", function( panel )

    if not current or not IsValid( current ) then return end
    if not IsValid( panel ) or panel == current or panel:HasParent( current ) then return end

    current:Close()

end)