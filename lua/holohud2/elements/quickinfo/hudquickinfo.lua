local math = math
local CurTime = CurTime

local BaseClass = HOLOHUD2.component.Get( "QuickInfoBar" )

local COMPONENT = {
    warning         = false,
    warn_color      = color_white,
    _frame_color    = color_white,
    _color_alpha    = 1,
    _frame_alpha    = 1
}

function COMPONENT:Init()

    self.Colors = HOLOHUD2.component.Create( "ColorRanges" )
    self.Colors2 = HOLOHUD2.component.Create( "ColorRanges" )

    self:SetColor( self.Colors:GetColor() )
    self:SetColor2( self.Colors2:GetColor() )

end

function COMPONENT:SetWarningColor( color )

    if self.warning then

        self.frame_color:SetUnpacked( color.r, color.g, color.b, color.a )
        self._frame_alpha = color.a

    end

    self.warn_color = color

end

function COMPONENT:SetColor( color )

    BaseClass.SetColor( self, color )
    self._color_alpha = color.a

end

function COMPONENT:SetFrameColor( color )

    if not self.warning then

        self.frame_color:SetUnpacked( color.r, color.g, color.b, color.a )
        self._frame_alpha = color.a

    end

    self._frame_color = color

end

function COMPONENT:SetValue( value )
    
    if not BaseClass.SetValue( self, value ) then return end
    
    self.Colors:SetValue( value )

end

function COMPONENT:SetMaxValue( max_value )
    
    if not BaseClass.SetMaxValue( self, max_value ) then return end
    
    self.Colors:SetMaxValue( max_value )

end

function COMPONENT:SetValue2( value2 )
    
    if not BaseClass.SetValue2( self, value2 ) then return end

    self.Colors2:SetValue( value2 )

end

function COMPONENT:SetMaxValue2( max_value2 )
    
    if not BaseClass.SetMaxValue2( self, max_value2 ) then return end

    self.Colors2:SetMaxValue( max_value2 )

end

function COMPONENT:SetWarning( warning )

    if self.warning == warning then return end
    
    local color = warning and self.warn_color or self._frame_color
    self.frame_color:SetUnpacked( color.r, color.g, color.b, color.a )
    self._frame_alpha = self.frame_color.a

    self.warning = warning

end

function COMPONENT:Think()
    
    local warn = 1 - math.abs( math.sin( CurTime() * 6 ) * .4 )

    self.Colors:Think()
    self.Colors2:Think()

    BaseClass.Think( self )

    if self.warning then

        self.color.a = self._color_alpha * warn
        self.frame_color.a = self._frame_alpha * warn
        return

    end

    self.color.a = self._color_alpha
    self.frame_color.a = self._frame_alpha

end

HOLOHUD2.component.Register( "HudQuickInfo", COMPONENT, "QuickInfoBar" )