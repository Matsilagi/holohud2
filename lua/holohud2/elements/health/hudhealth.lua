local CurTime = CurTime
local FrameTime = FrameTime
local StartAlphaMultiplier = HOLOHUD2.render.StartAlphaMultiplier
local EndAlphaMultiplier = HOLOHUD2.render.EndAlphaMultiplier

-- TODO: improve look of blinking health warn (pulse, or at least brackets, on background)

local BaseClass = HOLOHUD2.component.Get( "LayeredMeterDisplay" )

local HEALTHWARN_NONE           = 1
local HEALTHWARN_PULSE          = 2
local HEALTHWARN_WAVEBLINK      = 3
local HEALTHWARN_HARDBLINK      = 4
local HEALTHWARN_SOFTBLINK      = 5
local HEALTHWARN_INVERSEBLINK   = 6
local HEALTHWARNANIMATIONS      = {
    "#holohud2.health.healthwarn_0",
    "#holohud2.health.healthwarn_1",
    "#holohud2.health.healthwarn_2",
    "#holohud2.health.healthwarn_3",
    "#holohud2.health.healthwarn_4",
    "#holohud2.health.healthwarn_5"
}

local ICONRENDERMODE_STATIC     = HOLOHUD2.ICONRENDERMODE_STATIC

local RESOURCES = {
    { surface.GetTextureID( "holohud2/health/cross" ), 64, 64 },
    { surface.GetTextureID( "holohud2/health/heart" ), 64, 64, 0, 4, 64, 60 },
    { surface.GetTextureID( "holohud2/health/pulse"), 64, 64 },
    { surface.GetTextureID( "holohud2/health/hl2" ), 64, 64 },
    { surface.GetTextureID( "holohud2/health/css" ), 64, 64 },
    { surface.GetTextureID( "holohud2/health/csd" ), 64, 64 },
    { surface.GetTextureID( "holohud2/health/webdings" ), 64, 64 }
}

local COMPONENT = {
    healthwarn              = HEALTHWARN_PULSE,
    healthwarn_threshold    = 25,
    healthwarn_rate         = .8,
    damage_delay            = 1,
    damage_speed            = 1,
    pulse_on_background     = false,
    transform_oversize      = {
        number_pos          = false,
        progressbar_pos     = false,
        progressbar_size    = true,
        icon_pos            = false,
        pulse_pos           = false,
        pulse_size          = false,
        text_pos            = false
    },
    transform_suit_oversize = {
        number_pos          = true,
        progressbar_pos     = false,
        progressbar_size    = true,
        icon_pos            = false,
        pulse_pos           = false,
        pulse_size          = false,
        text_pos            = false
    },
    transform_suit_depleted = {
        enabled             = false,
        number_pos          = { x = 0, y = 0 },
        progressbar_pos     = { x = 0, y = 0 },
        progressbar_size    = { x = 0, y = 0 },
        icon_pos            = { x = 0, y = 0 },
        pulse_pos           = { x = 0, y = 0 },
        pulse_size          = { x = 0, y = 0 },
        text_pos            = { x = 0, y = 0 }
    },
    damage                  = 0,
    _healthwarn_time        = 0,
    _alpha                  = 1,
    _damage_time            = 0,
    _number_size            = 0, -- number component default size
    _last_number_size       = 0,
    _last_offset            = 0, -- last oversize offset applied
    _last_suit_offset       = 0 -- last suit oversize offset applied
}

function COMPONENT:Init()

    BaseClass.Init( self )

    local damagebar = HOLOHUD2.component.Create( "DamageBar" )
    damagebar:SetParent( self.ProgressBar.ProgressBar )
    self.DamageBar = damagebar

    self.Pulse = HOLOHUD2.component.Create( "Electrocardiogram" )
    self.Bracket0 = HOLOHUD2.component.Create( "Bracket" )

    local bracket1 = HOLOHUD2.component.Create( "Bracket" )
    bracket1:SetReversed( true )
    self.Bracket1 = bracket1

    self.TextBackground = HOLOHUD2.component.Create( "Text" )

end

function COMPONENT:InvalidateLayout()

    BaseClass.InvalidateLayout( self )
    self.DamageBar:InvalidateLayout()
    self.Pulse:InvalidateLayout()
    self.Bracket0:InvalidateLayout()
    self.Bracket1:InvalidateLayout()
    self.TextBackground:InvalidateLayout()

end

function COMPONENT:SetHealthWarnAnimation( healthwarn )

    self.healthwarn = healthwarn

end

function COMPONENT:SetHealthWarnThreshold( healthwarn_threshold )

    self.healthwarn_threshold = healthwarn_threshold

end

function COMPONENT:SetHealthWarnRate( healthwarn_rate )

    self.healthwarn_rate = healthwarn_rate

end

function COMPONENT:SetDamageDelay( delay )

    self.damage_delay = delay

end

function COMPONENT:SetDamageSpeed( speed )

    self.damage_speed = speed

end

function COMPONENT:SetDrawPulseOnBackground( on_background )

    self.pulse_on_background = on_background

end

function COMPONENT:SetOversizeTransform( transform )

    self.transform_oversize = transform

end

function COMPONENT:SetSuitOversizeTransform( transform )

    self.transform_suit_oversize = transform

end

function COMPONENT:SetSuitDepletedTransform( transform )

    transform.enabled = self.transform_suit_depleted.enabled
    self.transform_suit_depleted = transform

end

function COMPONENT:SetDamage( damage )

    self.DamageBar:SetValue( damage )
    self.damage = damage

end

function COMPONENT:SetMaxValue( max_value )
    
    if not BaseClass.SetMaxValue( self, max_value ) then return end

    self.Pulse:SetValue( self.value / max_value )

    return true

end

function COMPONENT:SetValue( value )
    
    local cur = value / self.max_value
    local prev = self.value / self.max_value
    
    if not BaseClass.SetValue( self, value ) then return end

    self.Pulse:SetValue( cur )

    -- update damage bar
    if cur < prev then

        local damage = math.max( self.damage, math.min( prev - math.max( math.floor( prev - .01 ), 0 ), 1 ) )

        if not self.progressbar and self.ProgressBar.ProgressBar.value > damage then

            damage = 1

        end

        self:SetDamage( damage )
        self._damage_time = CurTime() + self.damage_delay

    elseif not self.progressbar and cur > prev and math.ceil( cur ) > math.ceil( prev ) then

        self:SetDamage( 0 )
        
    end

    return true

end

function COMPONENT:ApplyOversizeTransform( offset, silent )

    -- WARNING: remember to reset these transforms when applying a new configuration!

    if self.transform_oversize.number_pos then self.Number:SetPos( self.Number.x + offset, self.Number.y ) end
    if self.transform_oversize.progressbar_pos then self.ProgressBar:SetPos( self.ProgressBar.x + offset, self.ProgressBar.y ) end
    if self.transform_oversize.progressbar_size then

        self.ProgressBar:SetSize( self.ProgressBar.w + offset, self.ProgressBar.h )
        self.DamageBar:Copy( self.ProgressBar )

    end
    if self.transform_oversize.icon then
        
        self.IconBackground:SetPos( self.IconBackground.x + offset, self.IconBackground.y )
        self.Icon:Copy( self.IconBackground )
    
    end
    if self.transform_oversize.pulse_pos then self.Pulse:SetPos( self.Pulse.x + offset, self.Pulse.y ) end
    if self.transform_oversize.pulse_size then self.Pulse:SetSize( self.Pulse.w + offset, self.Pulse.h ) end
    if self.transform_oversize.text_pos then self.Text:SetPos( self.Text.x + offset, self.Text.y ) end

    self._last_offset = self._last_offset + offset

    if silent then return end

    self:OnOversizeTransformApplied( offset )

end

function COMPONENT:RevertOversizeTransform( silent )

    self:ApplyOversizeTransform( -self._last_offset, silent )

end

function COMPONENT:ApplySuitOversizeTransform( offset )

    -- WARNING: remember to reset these transforms when applying a new configuration!

    if self.transform_suit_oversize.number_pos then self.Number:SetPos( self.Number.x + offset, self.Number.y ) end
    if self.transform_suit_oversize.progressbar_pos then self.ProgressBar:SetPos( self.ProgressBar.x + offset, self.ProgressBar.y ) end
    if self.transform_suit_oversize.progressbar_size then self.ProgressBar:SetSize( self.ProgressBar.w + offset, self.ProgressBar.h ) end
    self.DamageBar:Copy( self.ProgressBar )
    if self.transform_suit_oversize.icon then
        
        self.IconBackground:SetPos( self.IconBackground.x + offset, self.IconBackground.y )
        self.Icon:Copy( self.IconBackground )
    
    end
    if self.transform_suit_oversize.pulse_pos then self.Pulse:SetPos( self.Pulse.x + offset, self.Pulse.y ) end
    if self.transform_suit_oversize.pulse_size then self.Pulse:SetSize( self.Pulse.w + offset, self.Pulse.h ) end
    if self.transform_suit_oversize.text_pos then self.Text:SetPos( self.Text.x + offset, self.Text.y ) end

    self._last_suit_offset = self._last_suit_offset + offset

end

function COMPONENT:RevertSuitOversizeTransform()

    self:ApplySuitOversizeTransform( -self._last_suit_offset )

end

function COMPONENT:SetSuitDepleted( depleted )

    -- WARNING: remember to reset these transforms when applying a new configuration!
    
    if self.transform_suit_depleted.enabled == depleted then return end

    local mul = depleted and 1 or -1

    self.Number:SetPos( self.Number.x + self.transform_suit_depleted.number_pos.x * mul, self.Number.y + self.transform_suit_depleted.number_pos.y * mul )
    self.ProgressBar:SetPos(self.ProgressBar.x + self.transform_suit_depleted.progressbar_pos.x * mul, self.ProgressBar.y + self.transform_suit_depleted.progressbar_pos.y * mul )
    self.ProgressBar:SetSize(self.ProgressBar.w + self.transform_suit_depleted.progressbar_size.x * mul, self.ProgressBar.h + self.transform_suit_depleted.progressbar_size.y * mul )
    self.DamageBar:Copy( self.ProgressBar )
    self.IconBackground:SetPos( self.IconBackground.x + self.transform_suit_depleted.icon_pos.x * mul, self.IconBackground.y + self.transform_suit_depleted.icon_pos.y * mul )
    self.Icon:Copy( self.IconBackground )
    self.Pulse:SetPos( self.Pulse.x + self.transform_suit_depleted.pulse_pos.x * mul, self.Pulse.y + self.transform_suit_depleted.pulse_pos.y * mul )
    self.Pulse:SetSize( self.Pulse.w + self.transform_suit_depleted.pulse_size.x * mul, self.Pulse.h + self.transform_suit_depleted.pulse_size.y * mul )
    self.Text:SetPos( self.Text.x + self.transform_suit_depleted.text_pos.x * mul, self.Text.y + self.transform_suit_depleted.text_pos.y * mul )

    self.transform_suit_depleted.enabled = depleted

end

function COMPONENT:GetOversizeOffset()

    return self._last_offset

end

function COMPONENT:OnOversizeTransformApplied( offset ) end

function COMPONENT:Think()

    local prev_bar = math.max( math.ceil( self._value / self.max_value ), 1 )

    BaseClass.Think( self )

    local cur_bar = math.max( math.ceil( self._value / self.max_value ), 1 )

    local curtime = CurTime()

    self.DamageBar:Think()
    self.Pulse:Think()
    self.Bracket0:PerformLayout()
    self.Bracket1:PerformLayout()
    self.TextBackground:PerformLayout()

    -- low health warning animation
    if self.healthwarn ~= HEALTHWARN_NONE and self.value <= self.healthwarn_threshold then
        
        local time = self._healthwarn_time - curtime

        if self.healthwarn == HEALTHWARN_PULSE then
            
            if self._healthwarn_time < curtime then
                
                self.Blur:Activate()

            end

        elseif self.healthwarn == HEALTHWARN_WAVEBLINK then
            
            self._alpha = math.abs( time / self.healthwarn_rate - .5 ) * 2
            self.TextBackground:SetVisible( self.Text.visible and self._alpha == 0 )

        else

            if self.healthwarn >= HEALTHWARN_SOFTBLINK then
                
                self._alpha = 1 - time  / self.healthwarn_rate

                if self.healthwarn == HEALTHWARN_INVERSEBLINK then
                    
                    self._alpha = 1 - self._alpha

                end

            else
                
                self._alpha = ( time > self.healthwarn_rate / 2 ) and 1 or 0

            end

            self.TextBackground:SetVisible( self.Text.visible )

        end

        if self._healthwarn_time < curtime then

            self._healthwarn_time = curtime + self.healthwarn_rate

        end
    
    else

        self._alpha = 1
        self.TextBackground:SetVisible( false )

    end

    -- damage bar animation
    if self._damage_time < curtime then

        self:SetDamage( math.max( self.damage - FrameTime() * self.damage_speed, 0 ) )

    end

    if self.progressbar_lerp and prev_bar ~= cur_bar then
        
        if prev_bar < cur_bar then

            self:SetDamage( 0 )

        else

            self:SetDamage( 1 )

        end

    end

    -- if number size changes apply an offset
    if self.Number.__w ~= self._last_number_size then
        
        self:ApplyOversizeTransform( self.Number.__w - self._last_number_size )
        self._last_number_size = self.Number.__w

    end

end

function COMPONENT:PaintBackground( x, y )

    BaseClass.PaintBackground( self, x, y )

    self.TextBackground:Paint( x, y )

    if self.icon_background and self.value <= self.healthwarn_threshold and self.healthwarn > HEALTHWARN_PULSE and self.icon_mode == ICONRENDERMODE_STATIC then
        
        self.IconBackground:Paint( x, y )
    
    end
    
    if self.pulse_on_background then
        
        self.Pulse:Paint( x, y )
        self.Bracket0:Paint( x, y )
        self.Bracket1:Paint( x, y )
    
    end

end

function COMPONENT:Paint( x, y )

    StartAlphaMultiplier( self._alpha )

    BaseClass.Paint( self, x, y )
    self.DamageBar:Paint( x, y )

    if not self.pulse_on_background then
        
        self.Pulse:Paint( x, y )
        self.Bracket0:Paint( x, y )
        self.Bracket1:Paint( x, y )
    
    end

    EndAlphaMultiplier()

end

function COMPONENT:PaintScanlines( x, y )

    StartAlphaMultiplier( self._alpha )
    BaseClass.PaintScanlines( self, x, y )
    EndAlphaMultiplier()

end

function COMPONENT:ApplySettings( settings, fonts )

    -- undo current transforms
    self:SetSuitDepleted( false )
    self:RevertOversizeTransform( true )
    self:RevertSuitOversizeTransform()

    self.Colors:SetColors( settings.health_color )
    self.Colors2:SetColors( settings.health_color2 )

    local color, color2 = self.Colors:GetColor(), self.Colors2:GetColor()

    self:SetHealthWarnAnimation( settings.healthwarn )
    self:SetHealthWarnThreshold( settings.healthwarn_threshold )
    self:SetHealthWarnRate( settings.healthwarn_rate )
    self._alpha = 1

    local num = self.Number
    num:SetVisible( settings.healthnum )
    num:SetPos( settings.healthnum_pos.x, settings.healthnum_pos.y )
    num:SetFont( fonts.healthnum_font )
    num:SetRenderMode( settings.healthnum_rendermode )
    num:SetBackground( settings.healthnum_background )
    num:SetAlign( settings.healthnum_align )
    num:SetDigits( settings.healthnum_digits )
    self:SetNumberLerp( settings.healthnum_lerp )
    
    -- get new number size
    num:PerformLayout( true )
    self._number_size = num.__defaultsize
    self._last_number_size = self._number_size

    local healthbar = self.ProgressBar
    healthbar:SetVisible( settings.healthbar )
    healthbar:SetPos( settings.healthbar_pos.x, settings.healthbar_pos.y )
    healthbar:SetSize( settings.healthbar_size.x, settings.healthbar_size.y )
    healthbar:SetStyle( settings.healthbar_style )
    healthbar:SetGrowDirection( settings.healthbar_growdirection )
    healthbar:SetLayered( settings.healthbar_layered )
    healthbar:SetDrawBackground( settings.healthbar_background )
    self:SetProgressBarLerp( settings.healthbar_lerp )
    
    local dotline = healthbar:GetDotLine()
    dotline:SetVisible( settings.healthbar_dotline )
    dotline:SetPos( settings.healthbar_dotline_pos.x, settings.healthbar_dotline_pos.y )
    dotline:SetSize( settings.healthbar_dotline_size )
    dotline:SetGrowDirection( settings.healthbar_dotline_growdirection )

    local damagebar = self.DamageBar
    damagebar:SetVisible( settings.healthbar and settings.healthbar_damage )
    damagebar:SetColor( settings.healthbar_damage_color )
    damagebar:SetGrowDirection( settings.healthbar_growdirection )
    self:SetDamageDelay( settings.healthbar_damage_delay )
    self:SetDamageSpeed( settings.healthbar_damage_speed )
    damagebar:Copy( healthbar )

    local icon = self.IconBackground
    icon:SetVisible( settings.healthicon )
    icon:SetPos( settings.healthicon_pos.x, settings.healthicon_pos.y )
    icon:SetSize( settings.healthicon_size )
    icon:SetTexture( RESOURCES[ settings.healthicon_style ] )

    self.Icon:SetVisible( settings.healthicon )
    self.Icon:Copy( icon )

    self:SetIconRenderMode( settings.healthicon_rendermode )
    self:SetDrawIconBackground( settings.healthicon_background )
    self:SetIconLerp( settings.healthbar_lerp )

    local pulse = self.Pulse
    pulse:SetVisible( settings.healthpulse )
    pulse:SetPos( settings.healthpulse_pos.x, settings.healthpulse_pos.y )
    pulse:SetSize( settings.healthpulse_size.x, settings.healthpulse_size.y )
    pulse:SetColor( settings.healthpulse_on_background and color2 or color )
    pulse:SetAnimation( settings.healthpulse_style )
    self:SetDrawPulseOnBackground( settings.healthpulse_on_background )

    local bracket0 = self.Bracket0
    bracket0:SetVisible( settings.healthpulse and settings.healthpulse_brackets )
    bracket0:SetPos( settings.healthpulse_pos.x - 1, settings.healthpulse_pos.y + settings.healthpulse_brackets_offset )
    bracket0:SetSize( 16, settings.healthpulse_size.y + settings.healthpulse_brackets_margin )
    bracket0:SetColor( self.Pulse.color )

    local bracket1 = self.Bracket1
    bracket1:SetVisible( settings.healthpulse and settings.healthpulse_brackets )
    bracket1:SetPos( settings.healthpulse_pos.x + settings.healthpulse_size.x - 15, settings.healthpulse_pos.y + settings.healthpulse_brackets_offset )
    bracket1:SetSize( 16, settings.healthpulse_size.y + settings.healthpulse_brackets_margin )
    bracket1:SetColor( self.Pulse.color )

    local text = self.Text
    text:SetVisible( settings.healthtext )
    text:SetPos( settings.healthtext_pos.x, settings.healthtext_pos.y )
    text:SetFont( fonts.healthtext_font )
    text:SetAlign( settings.healthtext_align )
    text:SetColor( settings.healthtext_on_background and color2 or color )
    text:SetText( settings.healthtext_text )
    self:SetDrawTextOnBackground( settings.healthtext_on_background )

    local text_background = self.TextBackground
    text_background:SetVisible( settings.healthtext and not settings.healthtext_on_background and self.value <= settings.healthwarn_threshold and settings.healthwarn > HEALTHWARN_PULSE )
    text_background:SetColor( color2 )
    text_background:Copy( text )

    self:SetOversizeTransform( {
        number_pos          = settings.health_oversize_numberpos,
        progressbar_pos     = settings.health_oversize_progressbarpos,
        progressbar_size    = settings.health_oversize_progressbarsize,
        icon_pos            = settings.health_oversize_iconpos,
        pulse_pos           = settings.health_oversize_pulsepos,
        pulse_size          = settings.health_oversize_pulsesize,
        text_pos            = settings.health_oversize_textpos
    } )

    self:SetSuitDepletedTransform( {
        number_pos          = settings.health_suit_depleted_numberpos,
        progressbar_pos     = settings.health_suit_depleted_progressbarpos,
        progressbar_size    = settings.health_suit_depleted_progressbarsize,
        icon_pos            = settings.health_suit_depleted_iconpos,
        pulse_pos           = settings.health_suit_depleted_pulsepos,
        pulse_size          = settings.health_suit_depleted_pulsesize,
        text_pos            = settings.health_suit_depleted_textpos
    } )
    
    self:InvalidateLayout()

end

HOLOHUD2.component.Register( "HudHealth", COMPONENT, "LayeredMeterDisplay" )

HOLOHUD2.HEALTHWARN_NONE            = HEALTHWARN_NONE
HOLOHUD2.HEALTHWARN_PULSE           = HEALTHWARN_PULSE
HOLOHUD2.HEALTHWARN_WAVEBLINK       = HEALTHWARN_WAVEBLINK
HOLOHUD2.HEALTHWARN_HARDBLINK       = HEALTHWARN_HARDBLINK
HOLOHUD2.HEALTHWARN_SOFTBLINK       = HEALTHWARN_SOFTBLINK
HOLOHUD2.HEALTHWARN_INVERSEBLINK    = HEALTHWARN_INVERSEBLINK
HOLOHUD2.HEALTHWARNANIMATIONS       = HEALTHWARNANIMATIONS

HOLOHUD2.RESOURCE_HEALTH            = RESOURCES

HOLOHUD2.HEALTHICON_CROSS           = 1
HOLOHUD2.HEALTHICON_HEART           = 2
HOLOHUD2.HEALTHICON_PULSE           = 3
HOLOHUD2.HEALTHICON_HL2             = 4
HOLOHUD2.HEALTHICON_CSS             = 5
HOLOHUD2.HEALTHICON_CSD             = 6
HOLOHUD2.HEALTHICON_WEBDINGS        = 7
HOLOHUD2.HEALTHICONS                = {
    "#holohud2.health.healthicon_0",
    "#holohud2.health.healthicon_1",
    "#holohud2.health.healthicon_2",
    "#holohud2.health.healthicon_3",
    "#holohud2.health.healthicon_4",
    "#holohud2.health.healthicon_5",
    "#holohud2.health.healthicon_6"
}