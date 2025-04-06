
local BaseClass = HOLOHUD2.component.Get( "NumericDisplay" )

local ICONRENDERMODE_STATIC             = 1
local ICONRENDERMODE_PROGRESS           = 2
local ICONRENDERMODE_STATICBACKGROUND   = 3
local ICONRENDERMODE_PROGRESSBACKGROUND = 4

local COMPONENT = {
    icon_lerp           = false,
    icon_mode           = ICONRENDERMODE_PROGRESS,
    icon_background     = true, -- only usable when icon_mode is ICONRENDERMODE_PROGRESS
}

function COMPONENT:Init()

    BaseClass.Init( self )

    local iconbackground = HOLOHUD2.component.Create( "Icon" )
    iconbackground:SetColor( self.Colors2:GetColor() )
    self.IconBackground = iconbackground

    local icon = HOLOHUD2.component.Create( "ProgressIcon" )
    icon:SetColor( self.Colors:GetColor() )
    icon:SetGrowDirection( HOLOHUD2.GROWDIRECTION_UP )
    self.Icon = icon

end

function COMPONENT:InvalidateLayout()

    BaseClass.InvalidateLayout( self )
    self.IconBackground:InvalidateLayout()
    self.Icon:InvalidateLayout()

end


function COMPONENT:SetIconLerp( lerp )

    if self.icon_lerp == lerp then return end

    if not lerp then
        
        self.Icon:SetValue( ( self.icon_mode % 2 == 0 ) and ( self.value / self.max_value ) or 1 )
    
    end
    
    self.icon_lerp = lerp

end

function COMPONENT:SetIconRenderMode( mode )

    if self.icon_mode == mode then return end
    
    self.Icon:SetValue( ( mode % 2 == 0 ) and ( self.value / self.max_value ) or 1 )
    self.Icon:SetColor( ( mode <= ICONRENDERMODE_PROGRESS ) and self.Colors:GetColor() or self.Colors2:GetColor() )
    
    self.icon_mode = mode

end

function COMPONENT:SetDrawIconBackground( icon_background )

    self.icon_background = icon_background

end

function COMPONENT:SetMaxValue( max_value )

    if not BaseClass.SetMaxValue( self, max_value ) then return end

    if ( self.icon_mode % 2 == 0 ) and not self.icon_lerp then
        
        self.Icon:SetValue( self.value / max_value )
    
    end

    return true

end

function COMPONENT:SetValue( value )

    if not BaseClass.SetValue( self, value ) then return end

    if ( self.icon_mode % 2 == 0 ) and not self.icon_lerp then
        
        self.Icon:SetValue( value / self.max_value )

    end

    return true

end

function COMPONENT:Think()

    BaseClass.Think( self )

    self.IconBackground:PerformLayout()
    self.Icon:Think()

    if self.icon_lerp and ( self.icon_mode % 2 == 0 ) then self.Icon:SetValue( self._value / self.max_value ) end

end

function COMPONENT:PaintBackground( x, y )

    BaseClass.PaintBackground( self, x, y )

    if self.icon_mode >= ICONRENDERMODE_STATICBACKGROUND then

        self.Icon:Paint( x, y )

    else

        if self.icon_mode == ICONRENDERMODE_PROGRESS and self.icon_background then
            
            self.IconBackground:Paint( x, y )
        
        end

    end

end

function COMPONENT:Paint( x, y )
    
    BaseClass.Paint( self, x, y )

    if self.icon_mode > ICONRENDERMODE_PROGRESS then return end
        
    self.Icon:Paint( x, y )

end

HOLOHUD2.component.Register( "IconMeterDisplay", COMPONENT, "NumericDisplay" )

HOLOHUD2.ICONRENDERMODE_STATIC              = ICONRENDERMODE_STATIC
HOLOHUD2.ICONRENDERMODE_PROGRESS            = ICONRENDERMODE_PROGRESS
HOLOHUD2.ICONRENDERMODE_STATICBACKGROUND    = ICONRENDERMODE_STATICBACKGROUND
HOLOHUD2.ICONRENDERMODE_PROGRESSBACKGROUND  = ICONRENDERMODE_PROGRESSBACKGROUND