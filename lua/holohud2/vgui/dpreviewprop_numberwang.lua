
local PANEL = {}

function PANEL:Init()

    local icon = vgui.Create( "DImage", self )
    icon:SetY( 2 )
    icon:SetSize( 16, 16 )
    self.Icon = icon

    local value = vgui.Create( "DNumberWang", self )
    value:SetPos( 20, 0 )
    value:SetWide( 48 )
    value.OnValueChanged = function( _, value )

        self:OnValueChanged( value )

    end
    self.Value = value
    
    local separator = vgui.Create( "DLabel", self )
    separator:SetText( "/" )
    separator:SetPos( value:GetX() + value:GetWide() + 4, 0 )

    local max_value = vgui.Create( "DNumberWang", self )
    max_value:SetPos( separator:GetX() + 6, 0 )
    max_value:SetWide( 48 )
    max_value.OnValueChanged = function( _, value )

        self:OnMaxValueChanged( value )

    end
    self.MaxValue = max_value

    --[[local reset = vgui.Create( "DImageButton", self )
    reset:SetPos( max_value:GetX() + max_value:GetWide() + 4, 2 )
    reset:SetSize( 16, 16 )
    reset:SetImage( "icon16/arrow_refresh.png" )
    reset.DoClick = function()

        self:OnValueReset()

    end]]

end

function PANEL:SetIcon( icon )

    self.Icon:SetImage( icon )

end

function PANEL:SetMinMax( min, max )

    self.Value:SetMinMax( min, max )
    self.MaxValue:SetMinMax( min, max )

end

function PANEL:SetValue( value )

    self.Value:SetValue( value )

end

function PANEL:SetMaxValue( value )

    self.MaxValue:SetValue( value )

end

function PANEL:OnValueChanged( value ) end
function PANEL:OnMaxValueChanged( max_value ) end
-- function PANEL:OnValueReset() end

vgui.Register( "HOLOHUD2_DPreviewProperty_NumberWang", PANEL, "Panel" )