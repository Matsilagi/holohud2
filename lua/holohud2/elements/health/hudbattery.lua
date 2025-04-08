local BaseClass = HOLOHUD2.component.Get( "LayeredMeterDisplay" )

local NUMBERRENDERMODE_STATIC   = HOLOHUD2.NUMBERRENDERMODE_STATIC
local NUMBERRENDERMODE_MODERN   = HOLOHUD2.NUMBERRENDERMODE_MODERN
local ICONRENDERMODE_STATIC     = HOLOHUD2.ICONRENDERMODE_STATIC

local SUITDEPLETED_NONE     = 1
local SUITDEPLETED_TURNOFF  = 2
local SUITDEPLETED_HIDE     = 3
local SUITDEPLETED          = {
    "#holohud2.health.suit_depleted_0",
    "#holohud2.health.suit_depleted_1",
    "#holohud2.health.suit_depleted_2"
}

local RESOURCES = {
    { surface.GetTextureID( "holohud2/suit/silhouette1" ), 32, 128, 0, 0, 28, 66 },
    { surface.GetTextureID( "holohud2/suit/silhouette0" ), 32, 128, 0, 0, 28, 66 },
    { surface.GetTextureID( "holohud2/suit/kevlar" ), 64, 64 },
    { surface.GetTextureID( "holohud2/suit/shield" ), 64, 64 },
    { surface.GetTextureID( "holohud2/suit/hl2" ), 64, 64 },
    { surface.GetTextureID( "holohud2/suit/css0" ), 64, 64 },
    { surface.GetTextureID( "holohud2/suit/css1" ), 64, 64 },
    { surface.GetTextureID( "holohud2/suit/css2" ), 64, 64 },
    { surface.GetTextureID( "holohud2/suit/csd0" ), 64, 64 },
    { surface.GetTextureID( "holohud2/suit/csd1" ), 64, 64 },
    { surface.GetTextureID( "holohud2/suit/webdings" ), 64, 64 }
}

local COMPONENT = {
    on_depleted         = SUITDEPLETED_NONE,
    transform_oversize  = {
        number_pos          = false,
        progressbar_pos     = false,
        progressbar_size    = false,
        icon_pos            = false,
        text_pos            = false
    },
    transform_health_oversize = {
        number_pos          = false,
        progressbar_pos     = false,
        progressbar_size    = false,
        icon_pos            = false,
        text_pos            = false
    },
    _number_size        = 0,
    _last_number_size   = 0,
    _last_offset        = 0,
    _last_health_offset = 0,
    _num_rendermode     = NUMBERRENDERMODE_STATIC,
    _text_on_background = false
}

function COMPONENT:SetOnDepleted( on_depleted )

    self.on_depleted = on_depleted

end

function COMPONENT:SetOversizeTransform( transform )

    self.transform_oversize = transform

end

function COMPONENT:SetHealthOversizeTransform( transform )

    self.transform_health_oversize = transform

end

function COMPONENT:ApplyOversizeTransform( offset, silent )

    -- WARNING: remember to reset these transforms when applying a new configuration!

    if self.transform_oversize.number_pos then self.Number:SetPos( self.Number.x + offset, self.Number.y ) end
    if self.transform_oversize.progressbar_pos then self.ProgressBar:SetPos( self.ProgressBar.x + offset, self.ProgressBar.y ) end
    if self.transform_oversize.progressbar_size then self.ProgressBar:SetSize( self.ProgressBar.w + offset, self.ProgressBar.h ) end
    if self.transform_oversize.icon then
        
        self.IconBackground:SetPos( self.IconBackground.x + offset, self.IconBackground.y )
        self.Icon:Copy( self.IconBackground )
    
    end
    if self.transform_oversize.text_pos then self.Text:SetPos( self.Text.x + offset, self.Text.y ) end

    self._last_offset = self._last_offset + offset

    if silent then return end

    self:OnOversizeTransformApplied( offset )

end

function COMPONENT:RevertOversizeTransform( silent )

    self:ApplyOversizeTransform( -self._last_offset, silent )

end

function COMPONENT:ApplyHealthOversizeTransform( offset )

    -- WARNING: remember to reset these transforms when applying a new configuration!

    if self.transform_health_oversize.number_pos then self.Number:SetPos( self.Number.x + offset, self.Number.y ) end
    if self.transform_health_oversize.progressbar_pos then self.ProgressBar:SetPos( self.ProgressBar.x + offset, self.ProgressBar.y ) end
    if self.transform_health_oversize.progressbar_size then self.ProgressBar:SetSize( self.ProgressBar.w + offset, self.ProgressBar.h ) end
    if self.transform_health_oversize.icon then
        
        self.IconBackground:SetPos( self.IconBackground.x + offset, self.IconBackground.y )
        self.Icon:Copy( self.IconBackground )
    
    end
    if self.transform_health_oversize.text_pos then self.Text:SetPos( self.Text.x + offset, self.Text.y ) end

    self._last_health_offset = self._last_health_offset + offset

end

function COMPONENT:RevertHealthOversizeTransform()

    self:ApplyHealthOversizeTransform( -self._last_health_offset )

end

function COMPONENT:GetOversizeOffset()

    return self._last_offset

end

function COMPONENT:Think()

    BaseClass.Think( self )

    if self.on_depleted ~= SUITDEPLETED_NONE then

        -- show the last digit when turned off
        if self._num_rendermode == NUMBERRENDERMODE_MODERN then

            self.Number:SetRenderMode( self.value > 0 and NUMBERRENDERMODE_MODERN or NUMBERRENDERMODE_STATIC )

        end

        -- show the label on the background when turned off
        self:SetDrawTextOnBackground( self.value <= 0 or self._text_on_background )

    end

    -- if number size changes apply an offset
    if self.Number.__w ~= self._last_number_size then
        
        self:ApplyOversizeTransform( self.Number.__w - self._last_number_size )
        self._last_number_size = self.Number.__w

    end

end

function COMPONENT:PaintBackground( x, y )

    if self.value <= 0 and self.on_depleted >= SUITDEPLETED_HIDE then return end

    if self.icon_background and self.value <= 0 and self.on_depleted == SUITDEPLETED_TURNOFF and self.icon_mode == ICONRENDERMODE_STATIC then
            
        self.IconBackground:Paint( x, y )
    
    end

    BaseClass.PaintBackground( self, x, y )

end

function COMPONENT:Paint( x, y )

    if self.value <= 0 and self.on_depleted > SUITDEPLETED_NONE then return end

    BaseClass.Paint( self, x, y )

end

function COMPONENT:PaintScanlines( x, y )

    if self.value <= 0 and self.on_depleted > SUITDEPLETED_NONE then return end

    BaseClass.PaintScanlines( self, x, y )

end

function COMPONENT:OnOversizeTransformApplied( offset ) end

function COMPONENT:ApplySettings( settings, fonts )

    -- silently revert oversize transform
    self:RevertOversizeTransform( true )
    self:RevertHealthOversizeTransform()

    self.Colors:SetColors( settings.suit_color )
    self.Colors2:SetColors( settings.suit_color2 )

    local color, color2 = self.Colors:GetColor(), self.Colors:GetColor()

    self:SetOnDepleted( ( settings.suit_separate and settings.suit_depleted == SUITDEPLETED_HIDE and SUITDEPLETED_TURNOFF ) or settings.suit_depleted )

    local num = self.Number
    num:SetVisible( settings.suitnum )
    num:SetPos( settings.suitnum_pos.x, settings.suitnum_pos.y )
    num:SetFont( fonts.suitnum_font )
    num:SetRenderMode( settings.suitnum_rendermode )
    num:SetBackground( settings.suitnum_background )
    num:SetAlign( settings.suitnum_align )
    num:SetDigits( settings.suitnum_digits )
    self:SetNumberLerp( settings.suitnum_lerp )
    self._num_rendermode = settings.suitnum_rendermode

    -- get new number size
    num:PerformLayout( true )
    self._number_size = num.__defaultsize
    self._last_number_size = self._number_size

    local suitbar = self.ProgressBar
    suitbar:SetVisible( settings.suitbar )
    suitbar:SetPos( settings.suitbar_pos.x, settings.suitbar_pos.y )
    suitbar:SetSize( settings.suitbar_size.x, settings.suitbar_size.y )
    suitbar:SetStyle( settings.suitbar_style )
    suitbar:SetGrowDirection( settings.suitbar_growdirection )
    suitbar:SetLayered( settings.suitbar_layered )
    suitbar:SetDrawBackground( settings.suitbar_background )
    self:SetProgressBarLerp( settings.suitbar_lerp )
    
    local dotline = suitbar:GetDotLine()
    dotline:SetVisible( settings.suitbar_dotline )
    dotline:SetPos( settings.suitbar_dotline_pos.x, settings.suitbar_dotline_pos.y )
    dotline:SetSize( settings.suitbar_dotline_size )
    dotline:SetGrowDirection( settings.suitbar_dotline_growdirection )

    local icon = self.IconBackground
    icon:SetVisible( settings.suiticon )
    icon:SetPos( settings.suiticon_pos.x, settings.suiticon_pos.y )
    icon:SetSize( settings.suiticon_size )
    icon:SetTexture( RESOURCES[ settings.suiticon_style ] )

    self.Icon:SetVisible( settings.suiticon )
    self.Icon:Copy( icon )

    self:SetIconRenderMode( settings.suiticon_rendermode )
    self:SetDrawIconBackground( settings.suiticon_background )
    self:SetIconLerp( true )

    local text = self.Text
    text:SetVisible( settings.suittext )
    text:SetPos( settings.suittext_pos.x, settings.suittext_pos.y )
    text:SetFont( fonts.suittext_font )
    text:SetAlign( settings.suittext_align )
    text:SetText( settings.suittext_text )
    text:SetColor( settings.suittext_on_background and color2 or color )
    self:SetDrawTextOnBackground( settings.suittext_on_background )
    self._text_on_background = settings.suittext_on_background

    self:SetOversizeTransform( {
        number_pos          = settings.suit_oversize_numberpos,
        progressbar_pos     = settings.suit_oversize_progressbarpos,
        progressbar_size    = settings.suit_oversize_progressbarsize,
        icon_pos            = settings.suit_oversize_iconpos,
        pulse_pos           = settings.suit_oversize_pulsepos,
        pulse_size          = settings.suit_oversize_pulsesize,
        text_pos            = settings.suit_oversize_textpos
    } )

    self:SetHealthOversizeTransform( {
        number_pos          = settings.suit_health_oversize_numberpos,
        progressbar_pos     = settings.suit_health_oversize_progressbarpos,
        progressbar_size    = settings.suit_health_oversize_progressbarsize,
        icon_pos            = settings.suit_health_oversize_iconpos,
        pulse_pos           = settings.suit_health_oversize_pulsepos,
        pulse_size          = settings.suit_health_oversize_pulsesize,
        text_pos            = settings.suit_health_oversize_textpos
    } )
    
    self:InvalidateLayout()

end

HOLOHUD2.component.Register( "HudBattery", COMPONENT, "LayeredMeterDisplay" )

HOLOHUD2.SUITDEPLETED_NONE      = SUITDEPLETED_NONE
HOLOHUD2.SUITDEPLETED_TURNOFF   = SUITDEPLETED_TURNOFF
HOLOHUD2.SUITDEPLETED_HIDE      = SUITDEPLETED_HIDE
HOLOHUD2.SUITDEPLETED           = SUITDEPLETED

HOLOHUD2.RESOURCE_SUITBATTERY   = RESOURCES

HOLOHUD2.SUITBATTERYICON_SILHOUETTE     = 1
HOLOHUD2.SUITBATTERYICON_SILHOUETTEALT  = 2
HOLOHUD2.SUITBATTERYICON_KEVLAR         = 3
HOLOHUD2.SUITBATTERYICON_SHIELD         = 4
HOLOHUD2.SUITBATTERYICON_HL2            = 5
HOLOHUD2.SUITBATTERYICON_CSS            = 6
HOLOHUD2.SUITBATTERYICON_CSSHELMET      = 7
HOLOHUD2.SUITBATTERYICON_CSSEMPTY       = 8
HOLOHUD2.SUITBATTERYICON_CSD            = 9
HOLOHUD2.SUITBATTERYICON_CSDHELMET      = 10
HOLOHUD2.SUITBATTERYICON_WEBDINGS       = 11
HOLOHUD2.SUITBATTERYICONS               = {
    "#holohud2.health.suiticon_0",
    "#holohud2.health.suiticon_1",
    "#holohud2.health.suiticon_2",
    "#holohud2.health.suiticon_3",
    "#holohud2.health.suiticon_4",
    "#holohud2.health.suiticon_5",
    "#holohud2.health.suiticon_6",
    "#holohud2.health.suiticon_7",
    "#holohud2.health.suiticon_8",
    "#holohud2.health.suiticon_9",
    "#holohud2.health.suiticon_10"
}