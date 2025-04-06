local gui = gui

local PANEL = {}

function PANEL:Init()

    self._lastX     = 0
    self._lastY     = 0
    self.PreviewX   = 0
    self.PreviewY   = 0
    self.Dragged    = false

    self:SetKeepAspect( true )

    local reset = vgui.Create( "DButton", self )
    reset:SetPos( 32, 4 )
    reset:SetSize( 24, 24 )
    reset:SetText( "" )
    reset:SetImage( "icon16/arrow_in.png" )
    reset:SetTooltip( "#holohud2.derma.dpreview.center" )
    reset.DoClick = function()

        self.PreviewX, self.PreviewY = 0, 0

    end

    self:SetMouseInputEnabled( true )
    self:SetKeyboardInputEnabled( true )
    self:SetCursor( "sizeall" )

end

function PANEL:OnMousePressed( code )

    if self.Dragged then return end

    self.Dragged = true
    self._lastX, self._lastY = self:CursorPos()
    
end

function PANEL:OnMouseReleased( code )

    self.Dragged = false

end

function PANEL:Think()

    if not self.Dragged then return end

    local x, y = self:CursorPos()

    self.PreviewX = self.PreviewX + ( x - self._lastX )
    self.PreviewY = self.PreviewY + ( y - self._lastY )

    self._lastX = x
    self._lastY = y

    -- check if mouse has gone out of bounds
    if x < 0 or x > self:GetWide() or y < 0 or y > self:GetTall() then

        self.Dragged = false

    end

end

function PANEL:PaintOver( w, h )

    self:PaintPreview( self.PreviewX, self.PreviewY, w, h )

end

function PANEL:PaintPreview( x, y, w, h ) end

vgui.Register( "HOLOHUD2_DPreview", PANEL, "HOLOHUD2_DPreviewImage" )