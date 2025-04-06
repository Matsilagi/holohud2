local BaseClass = HOLOHUD2.component.Get( "IconMeterDisplay" )

local COMPONENT = {
    progressbar_lerp    = false
}

function COMPONENT:Init()

    BaseClass.Init( self )

    local color, color2 = self.Colors:GetColor(), self.Colors2:GetColor()

    local progressbarbackground = HOLOHUD2.component.Create( "Bar" )
    progressbarbackground:SetColor( color2 )
    self.ProgressBarBackground = progressbarbackground

    local progressbar = HOLOHUD2.component.Create( "ProgressBar" )
    progressbar:SetColor( color )
    self.ProgressBar = progressbar

end

function COMPONENT:SetProgressBarLerp( lerp )

    if self.progressbar_lerp == lerp then return end

    if not lerp then
        
        self.ProgressBar:SetValue( self.value / self.max_value )
    
    end

    self.progressbar_lerp = lerp

end

function COMPONENT:SetMaxValue( max_value )

    if not BaseClass.SetMaxValue( self, max_value ) then return end

    if not self.progressbar_lerp then
        
        self.ProgressBar:SetValue( self.value / max_value )
    
    end
    
    return true

end

function COMPONENT:SetValue( value )

    if not BaseClass.SetValue( self, value ) then return end

    if not self.progressbar_lerp then
        
        self.ProgressBar:SetValue( value / self.max_value )
    
    end
    
    return true

end

function COMPONENT:Think()

    BaseClass.Think( self )

    self.ProgressBarBackground:PerformLayout()
    self.ProgressBar:Think()
    if self.progressbar_lerp then self.ProgressBar:SetValue( math.Round( self._value ) / self.max_value ) end

end

function COMPONENT:PaintBackground( x, y )

    BaseClass.PaintBackground(self, x, y)

    self.ProgressBarBackground:Paint(x, y)

end

function COMPONENT:Paint(x, y)

    BaseClass.Paint(self, x, y)

    self.ProgressBar:Paint(x, y)

end

HOLOHUD2.component.Register( "MeterDisplay", COMPONENT, "IconMeterDisplay" )