DEFINE_BASECLASS( "HOLOHUD2_DParameter" )

local PANEL = {}

function PANEL:Init()

    local color = self:GetSkin().Colours.Label.Dark

    self.Value = { x = 0, y = 0 }

    local ywang = vgui.Create( "DNumberWang", self )
    ywang:SetSize( 56, 14 )
    ywang:Dock( RIGHT )
    ywang:DockMargin( 0, 2, 2, 2 )
    ywang:SetMinMax( -2147483647, 2147483647 )
    ywang:SetTooltip( "Y-axis" )
    ywang:SetZPos( 0 )
    ywang.OnValueChanged = function( _, value )

        self.Value.y = value
        self:OnValueChanged( self.Value )

    end
    self.YWang = ywang

    local ylabel = vgui.Create( "DLabel", self )
    ylabel:SetText( "↕" )
    ylabel:SetFont( "Trebuchet24" )
    ylabel:Dock( RIGHT )
    ylabel:DockMargin( 0, -4, 8, 0 )
    ylabel:SetTextColor( color )
    ylabel:SizeToContents()
    ylabel:SetZPos( 1 )
    self.YLabel = ylabel

    local xwang = vgui.Create( "DNumberWang", self )
    xwang:SetSize( 56, 14 )
    xwang:Dock( RIGHT )
    xwang:DockMargin( 0, 2, 7, 2 )
    xwang:SetMinMax( -2147483647, 2147483647 )
    xwang:SetTooltip( "X-axis" )
    xwang:SetZPos( 2 )
    xwang.OnValueChanged = function( _, value )

        self.Value.x = value
        self:OnValueChanged( self.Value )

    end
    self.XWang = xwang

    local xlabel = vgui.Create( "DLabel", self )
    xlabel:SetText( "↔" )
    xlabel:SetFont( "Trebuchet24" )
    xlabel:Dock( RIGHT )
    xlabel:DockMargin( 0, -4, 6, 0 )
    xlabel:SetTextColor( color )
    xlabel:SizeToContents()
    xlabel:SetZPos( 3 )
    self.XLabel = xlabel

end

function PANEL:GetValue()

    return self.Value

end

function PANEL:Populate( parameter )

    BaseClass.Populate( self, parameter )

    if parameter.min_x then self.XWang:SetMin( parameter.min_x ) end
    if parameter.min_y then self.YWang:SetMin( parameter.min_y ) end
    if parameter.max_x then self.XWang:SetMax( parameter.min_x ) end
    if parameter.max_y then self.YWang:SetMax( parameter.max_y ) end

end

function PANEL:SetValue( value )

    self.Value.x = value.x
    self.XWang:SetValue( value.x )

    self.Value.y = value.y
    self.YWang:SetValue( value.y )

end

vgui.Register( "HOLOHUD2_DParameter_Vector", PANEL, "HOLOHUD2_DParameter" )