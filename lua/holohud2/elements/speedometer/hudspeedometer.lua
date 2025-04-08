local Lerp = Lerp
local FrameTime = FrameTime
local StartAlphaMultiplier = HOLOHUD2.render.StartAlphaMultiplier
local EndAlphaMultiplier = HOLOHUD2.render.EndAlphaMultiplier
local GetMinimumGlow = HOLOHUD2.render.GetMinimumGlow

local COMPONENT = {
    damagebar_lerp      = true,
    unit_on_background  = false,
    text_on_background  = false,
    damage_inverted     = false,
    lerp_speed          = 12,
    value               = 0,
    damage              = 0,
    gear                = 0,
    color               = color_white,
    color2              = color_white,
    _damage             = 0,
    _conversion         = 1
}

local HUS_TO_KPH    = .09142
local HUS_TO_MPH    = .05681

local UNIT_HAMMER       = "HU/S"
local UNIT_METRIC       = "KM/H"
local UNIT_IMPERIAL     = "MPH"

function COMPONENT:Init()

    self.DamageColors = HOLOHUD2.component.Create( "ColorRanges" )
    self.DamageColors2 = HOLOHUD2.component.Create( "ColorRanges" )
    
    self.RevCounter = HOLOHUD2.component.Create( "RevCounter" )
    self.Speed = HOLOHUD2.component.Create( "Number" )
    self.Unit = HOLOHUD2.component.Create( "Text" )

    local damagebarbackground = HOLOHUD2.component.Create( "Bar" )
    damagebarbackground:SetColor( self.DamageColors2:GetColor() )
    self.DamageBarBackground = damagebarbackground

    local damagebar = HOLOHUD2.component.Create( "ProgressBar" )
    damagebar:SetColor( self.DamageColors:GetColor() )
    self.DamageBar = damagebar

    local gear = HOLOHUD2.component.Create( "Number" )
    gear:SetDigits( 1 )
    gear:SetAlign( TEXT_ALIGN_RIGHT )
    self.Gear = gear

    self.Text = HOLOHUD2.component.Create( "Text" )

end

function COMPONENT:InvalidateLayout()

    self.RevCounter:InvalidateLayout()
    self.Speed:InvalidateLayout()
    self.Unit:InvalidateLayout()
    self.DamageBarBackground:InvalidateLayout()
    self.DamageBar:InvalidateLayout()
    self.Gear:InvalidateLayout()
    self.Text:InvalidateLayout()

end

function COMPONENT:SetUnit( unit )

    if unit == HOLOHUD2.DISTANCE_METRIC then
        
        self.Unit:SetText( UNIT_METRIC )
        self._conversion = HUS_TO_KPH
    
    elseif unit == HOLOHUD2.DISTANCE_IMPERIAL then

        self.Unit:SetText( UNIT_IMPERIAL )
        self._conversion = HUS_TO_MPH

    else

        self.Unit:SetText( UNIT_HAMMER )
        self._conversion = 1

    end

    self.Speed:SetValue( math.Round( self.value * self._conversion ) )

end

function COMPONENT:SetDamageBarLerp( lerp )

    if self.damagebar_lerp == lerp then return end

    if not lerp then self.DamageBar:SetValue( self.damage ) end

    self.damagebar_lerp = lerp

end

function COMPONENT:SetDrawUnitOnBackground( on_background )

    self.unit_on_background = on_background
    self.Unit:SetColor( on_background and self.color2 or self.color )

end

function COMPONENT:SetDrawTextOnBackground( on_background )

    self.text_on_background = on_background
    self.Text:SetColor( on_background and self.color2 or self.color )

end

function COMPONENT:SetSpeed( speed )

    if self.value == speed then return end

    self.Speed:SetValue( math.Round( speed * self._conversion ) )

    self.value = speed

end

function COMPONENT:SetSegments( segments )

    self.RevCounter:SetSegments( segments )

end

function COMPONENT:SetRPMValue( value )

    self.RevCounter:SetValue( value )

end

function COMPONENT:SetMaxRPM( maxrpm, converted )

    if converted then maxrpm = maxrpm * self._conversion end

    self.RevCounter:SetMaxRPM( maxrpm )

end

function COMPONENT:SetInvertedDamage( inverted )

    if self.damage_inverted == inverted then return end

    if not self.damagebar_lerp then self.DamageBar:SetValue( inverted and ( 1 - self.damage ) or self.damage ) end

    self.damage_inverted = inverted

end

function COMPONENT:SetDamage( damage )

    if self.damage == damage then return end

    if not self.damagebar_lerp then self.DamageBar:SetValue( self.damage_inverted and ( 1 - damage ) or damage ) end
    self.DamageColors:SetValue( damage )
    self.DamageColors2:SetValue( damage )

    self.damage = damage

end

function COMPONENT:SetGear( gear )

    gear = math.Round( gear or -2 )

    self.Gear:SetValue( math.max( gear, 0 ) )
    self.gear = gear

end

function COMPONENT:Think()

    self._damage = Lerp( FrameTime() * self.lerp_speed, self._damage, self.damage )

    if self.damagebar_lerp then
    
        self.DamageBar:SetValue( self._damage )
    
    end

    self.DamageColors:Think()
    self.DamageColors2:Think()
    self.RevCounter:PerformLayout()
    self.Speed:PerformLayout()
    self.Unit:PerformLayout()
    self.DamageBarBackground:PerformLayout()
    self.DamageBar:Think()
    self.Text:PerformLayout()
    self.Gear:PerformLayout()

end

function COMPONENT:PaintBackground( x, y )

    self.RevCounter:PaintBackground( x, y )
    self.Speed:PaintBackground( x, y )
    
    if self.unit_on_background then

        self.Unit:Paint( x, y )

    end

    if self.text_on_background then
        
        self.Text:Paint( x, y )
        
    end

    self.DamageBarBackground:Paint( x, y )
    self.Gear:PaintBackground( x, y )

end

function COMPONENT:Paint( x, y )

    self.RevCounter:Paint( x, y )
    self.Speed:Paint( x, y )
    
    if not self.unit_on_background then

        self.Unit:Paint( x, y )
        
    end

    if not self.text_on_background then
        
        self.Text:Paint( x, y )
        
    end

    self.DamageBar:Paint( x, y )

    if self.gear > 0 then

        self.Gear:Paint( x, y )
        return

    end

    if self.gear <= -2 then return end
    
    draw.SimpleText( self.gear == 0 and "N" or "R", self.Gear.font, x + self.Gear._x0 + self.Gear._w * .5, y + self.Gear._y, self.Gear.color, TEXT_ALIGN_CENTER )

end

function COMPONENT:PaintScanlines( x, y )
    
    StartAlphaMultiplier( GetMinimumGlow() )

    self:Paint( x, y )

    EndAlphaMultiplier()

end

function COMPONENT:ApplySettings( settings, fonts )

    self.color = settings.color
    self.color2 = settings.color2

    self.DamageColors:SetColors( settings.damagebar_color )
    self.DamageColors2:SetColors( settings.damagebar_color2 )

    local speed = self.Speed
    speed:SetVisible( settings.num )
    speed:SetColor( self.color )
    speed:SetColor2( self.color2 )
    speed:SetPos( settings.num_pos.x, settings.num_pos.y )
    speed:SetFont( fonts.num_font )
    speed:SetRenderMode( settings.num_rendermode )
    speed:SetBackground( settings.num_background )
    speed:SetAlign( settings.num_align )
    speed:SetDigits( settings.num_digits )

    local unit = self.Unit
    unit:SetVisible( settings.label )
    unit:SetPos( settings.label_pos.x, settings.label_pos.y )
    -- unit:SetColor( settings.label_color )
    unit:SetFont( fonts.label_font )
    unit:SetAlign( settings.label_align )
    self:SetDrawUnitOnBackground( settings.label_on_background )
    self:SetUnit( settings.unit )

    local revcounter = self.RevCounter
    revcounter:SetVisible( settings.revcounter )
    revcounter:SetPos( settings.revcounter_pos.x, settings.revcounter_pos.y )
    revcounter:SetSize( settings.revcounter_size.x, settings.revcounter_size.y )
    revcounter:SetMargin( settings.revcounter_margin )
    revcounter:SetColor( settings.revcounter_color )
    revcounter:SetColor2( settings.revcounter_color2 )
    revcounter:SetShowRPM( settings.revcounter_num )
    revcounter:SetFont( fonts.revcounter_num_font )
    revcounter:SetRPMOffset( settings.revcounter_num_offset )
    revcounter:SetRedLine( 1 - settings.revcounter_redline )
    revcounter:SetColorMax( settings.revcounter_colormax )
    revcounter:SetColorMax2( settings.revcounter_colormax2 )
    revcounter:SetNegativeArea( settings.revcounter_negative )
    revcounter:SetNegativeOffset( 1 - settings.revcounter_negative_size )
    revcounter:SetSegments( settings.revcounter_segments )

    local damagebarbackground = self.DamageBarBackground
    damagebarbackground:SetVisible( settings.damagebar and settings.damagebar_background )
    damagebarbackground:SetPos( settings.damagebar_pos.x, settings.damagebar_pos.y )
    damagebarbackground:SetSize( settings.damagebar_size.x, settings.damagebar_size.y )
    damagebarbackground:SetStyle( settings.damagebar_style )

    local damagebar = self.DamageBar
    damagebar:Copy( damagebarbackground )
    damagebar:SetVisible( settings.damagebar )
    damagebar:SetGrowDirection( settings.damagebar_growdirection )
    self:SetDamageBarLerp( settings.damagebar_lerp )
    self:SetInvertedDamage( settings.damagebar_inverted )

    local gear = self.Gear
    gear:SetColor( settings.color )
    gear:SetColor2( settings.color2 )
    gear:SetVisible( settings.gearcounter )
    gear:SetPos( settings.gearcounter_pos.x, settings.gearcounter_pos.y )
    gear:SetRenderMode( settings.gearcounter_rendermode )
    gear:SetBackground( settings.gearcounter_background )
    gear:SetFont( fonts.gearcounter_font )

    local text = self.Text
    text:SetVisible( settings.text )
    text:SetPos( settings.text_pos.x, settings.text_pos.y )
    -- text:SetColor( settings.text_color )
    text:SetFont( fonts.text_font )
    text:SetText( settings.text_text )
    text:SetAlign( settings.text_align )
    self:SetDrawTextOnBackground( settings.text_on_background )
    
    self:InvalidateLayout()

end

HOLOHUD2.component.Register( "HudSpeedometer", COMPONENT )