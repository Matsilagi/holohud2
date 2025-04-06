
local PANEL = {}

function PANEL:Init()

    local icon = vgui.Create( "DImage", self )
    icon:SetPos( 0, 2 )
    icon:SetSize( 16, 16 )
    self.Icon = icon

    local slider = vgui.Create( "DNumSlider", self )
    slider:SetPos( 16, -7 )
    slider:SetDecimals( 0 )
    slider:SetMinMax( 0, 100 )
    slider:SetValue( 0 )
    slider.Label:Hide()
    slider.OnValueChanged = function( _, value )

        self:OnValueChanged( value )

    end
    self.Slider = slider

    --[[local reset = vgui.Create( "DImageButton", self )
    reset:SetY( 2 )
    reset:SetSize( 16, 16 )
    reset:SetImage( "icon16/arrow_refresh.png" )
    reset.DoClick = function()

        self:OnValueReset()

    end
    self.Reset = reset]]

end

function PANEL:PerformLayout()

    self.Slider:SetWide( self:GetWide() )
    -- self.Reset:SetX( self:GetWide() - 16 )

end

function PANEL:SetIcon( icon )

    self.Icon:SetImage( icon )

end

function PANEL:SetMinMax( min, max )

    self.Slider:SetMinMax( min, max )

end

function PANEL:SetValue( value )

    self.Slider:SetValue( value )

end

function PANEL:OnValueChanged( value ) end
-- function PANEL:OnValueReset() end

vgui.Register( "HOLOHUD2_DPreviewProperty_NumSlider", PANEL, "Panel" )