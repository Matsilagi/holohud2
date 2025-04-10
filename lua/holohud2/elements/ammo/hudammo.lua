
local FrameTime = FrameTime
local StartAlphaMultiplier = HOLOHUD2.render.StartAlphaMultiplier
local EndAlphaMultiplier = HOLOHUD2.render.EndAlphaMultiplier

local COMPONENT = {
    number_lerp         = false,
    number2_lerp        = false,
    ammobar_lerp        = false,
    icon_on_background  = false,
    text_on_background  = false,
    ammo                = 0,
    max_ammo            = 0,
    ammo2               = 0,
    ammotype            = 0,
    transform_oversize  = {
        number_pos      = false,
        number2_pos     = true,
        separator_pos   = true,
        ammobar_pos     = false,
        ammobar_size    = true,
        tray_pos        = false,
        tray_size       = true,
        icon_pos        = false,
        text_pos        = false
    },
    _ammo               = 0,
    _ammo2              = 0,
    _number_size        = 0,
    _last_number_size   = 0,
    _last_offset        = 0
}

function COMPONENT:Init()

    self.Colors = HOLOHUD2.component.Create( "ColorRanges" )
    self.Colors2 = HOLOHUD2.component.Create( "ColorRanges" )
    local color, color2 = self.Colors:GetColor(), self.Colors2:GetColor()

    local number = HOLOHUD2.component.Create( "Number" )
    number:SetColor( color )
    number:SetColor2( color2 )
    self.Number = number

    local number2 = HOLOHUD2.component.Create( "Number" )
    number2:SetColor( color )
    number2:SetColor2( color2 )
    self.Number2 = number2

    local ammobarbackground = HOLOHUD2.component.Create( "Bar" )
    ammobarbackground:SetColor( color2 )
    self.AmmoBarBackground = ammobarbackground

    local ammobar = HOLOHUD2.component.Create( "ProgressBar" )
    ammobar:SetColor( color )
    self.AmmoBar = ammobar

    local ammotray = HOLOHUD2.component.Create( "AmmoTray" )
    ammotray:SetColor( color )
    ammotray:SetColor2( color2 )
    self.AmmoTray = ammotray

    local separator = HOLOHUD2.component.Create( "Separator" )
    separator:SetColor( color )
    self.Separator = separator

    self.Icon = HOLOHUD2.component.Create( "AmmoIcon" )
    self.Text = HOLOHUD2.component.Create( "Text" )
    self.Blur = HOLOHUD2.component.Create( "Blur" )

end

function COMPONENT:InvalidateLayout()

    self.Number:InvalidateLayout()
    self.Number2:InvalidateLayout()
    self.AmmoBarBackground:InvalidateLayout()
    self.AmmoBar:InvalidateLayout()
    self.AmmoTray:InvalidateLayout()
    self.Separator:InvalidateLayout()
    self.Icon:InvalidateLayout()
    self.Text:InvalidateLayout()

end

function COMPONENT:SetNumberLerp( lerp )

    if self.number_lerp == lerp then return end

    if not lerp then
        
        self.Number:SetValue( self.ammo )
    
    end

    self.number_lerp = lerp

end

function COMPONENT:SetNumber2Lerp( lerp )

    if self.number2_lerp == lerp then return end

    if not lerp then
        
        self.Number2:SetValue( self.ammo2 )
    
    end

    self.number2_lerp = lerp

end

function COMPONENT:SetAmmoBarLerp( lerp )

    if self.ammobar_lerp == lerp then return end

    if not lerp then
        
        self.AmmoBar:SetValue( self.ammo / self.max_ammo )
    
    end

    self.ammobar_lerp = lerp

end

function COMPONENT:SetDrawIconOnBackground( on_background )

    self.icon_on_background = on_background

end

function COMPONENT:SetDrawTextOnBackground( on_background )

    self.Text:SetColor( on_background and self.Colors2:GetColor() or self.Colors:GetColor() )
    self.text_on_background = on_background

end

function COMPONENT:SetAmmoType( ammotype )

    if self.ammotype == ammotype then return end

    self.AmmoTray:SetAmmoType( ammotype )
    self.Icon:SetAmmoType( ammotype )

    self.ammotype = ammotype

end

function COMPONENT:SetMaxAmmo( max_ammo )

    if self.max_ammo == max_ammo then return end

    self.Colors:SetValue( self.ammo / max_ammo )
    self.Colors2:SetValue( self.ammo / max_ammo )
    self.AmmoTray:SetMaxValue( max_ammo )

    if not self.ammobar_lerp then
        
        self.AmmoBar:SetValue( self.ammo / max_ammo )

    end

    self.max_ammo = max_ammo

    return true

end

function COMPONENT:SetAmmo( ammo )

    if self.ammo == ammo then return end

    self.Blur:Activate()
    self.Colors:SetValue( ammo / self.max_ammo )
    self.Colors2:SetValue( ammo / self.max_ammo )
    self.AmmoTray:SetValue( ammo )

    if not self.number_lerp then
        
        self.Number:SetValue( ammo )
    
    end
    
    if not self.ammobar_lerp then
        
        self.AmmoBar:SetValue( ammo / self.max_ammo )
    
    end
    
    if ammo < self.ammo then
        
        self.AmmoTray:Attack()
    
    end

    self.ammo = ammo

end

function COMPONENT:SetAmmo2( ammo2 )

    if self.ammo2 == ammo2 then return end

    self.Blur:Activate()

    if not self.ammo2_lerp then
        
        self.Number2:SetValue( ammo2 )
    
    end

    self.ammo2 = ammo2

end

function COMPONENT:OnWeaponChanged()

    self.AmmoTray:Reload()
    self.Blur:Activate()

end

function COMPONENT:ApplyOversizeTransform( offset )

    -- WARNING: remember to reset these transforms when applying a new configuration!

    if self.transform_oversize.number_pos then self.Number:SetPos( self.Number.x + offset, self.Number.y ) end
    if self.transform_oversize.number2_pos then self.Number2:SetPos( self.Number2.x + offset, self.Number2.y ) end
    if self.transform_oversize.ammobar_pos then self.AmmoBarBackground:SetPos( self.AmmoBarBackground.x + offset, self.AmmoBarBackground.y ) end
    if self.transform_oversize.ammobar_size then self.AmmoBarBackground:SetSize( self.AmmoBarBackground.w + offset, self.AmmoBarBackground.h ) end
    self.AmmoBar:Copy( self.AmmoBarBackground )
    if self.transform_oversize.icon then self.Icon:SetPos( self.Icon.x + offset, self.Icon.y ) end
    if self.transform_oversize.tray_pos then self.AmmoTray:SetPos( self.AmmoTray.x + offset, self.AmmoTray.y ) end
    if self.transform_oversize.tray_size then self.AmmoTray:SetSize( self.AmmoTray.w + offset, self.AmmoTray.h ) end
    if self.transform_oversize.text_pos then self.Text:SetPos( self.Text.x + offset, self.Text.y ) end

    self._last_offset = self._last_offset + offset

end

function COMPONENT:RevertOversizeTransform()

    self:ApplyOversizeTransform( -self._last_offset )

end

function COMPONENT:GetOversizeOffset()

    return self._last_offset

end

local LERP_TIME = 12
function COMPONENT:Think()

    local speed = FrameTime() * LERP_TIME

    self.Blur:Think()
    self.Colors:Think()
    self.Colors2:Think()
    self.Number:PerformLayout()
    self.Number2:PerformLayout()
    self.AmmoBarBackground:PerformLayout()
    self.AmmoBar:Think()
    self.AmmoTray:Think()
    self.Separator:PerformLayout()
    self.Icon:PerformLayout()
    self.Text:PerformLayout()

    self._ammo = Lerp( speed, self._ammo, self.ammo )
    self._ammo2 = Lerp( speed, self._ammo2, self.ammo2 )

    if self.number_lerp then self.Number:SetValue( math.Round( self._ammo ) ) end
    if self.number2_lerp then self.Number2:SetValue( math.Round( self._ammo2 ) ) end
    if self.ammobar_lerp then self.AmmoBar:SetValue( self._ammo / self.max_ammo ) end

    -- if number size changes apply an offset
    if self.Number.__w ~= self._last_number_size then
        
        self:ApplyOversizeTransform( self.Number.__w - self._last_number_size )
        self._last_number_size = self.Number.__w

    end

end


function COMPONENT:PaintBackground( x, y )

    self.Number:PaintBackground( x, y )
    self.Number2:PaintBackground( x, y )
    self.AmmoBarBackground:Paint( x, y )
    self.AmmoTray:PaintBackground( x, y )

    if self.icon_on_background then
        
        self.Icon:Paint( x, y )
    
    end

    if self.text_on_background then
        
        self.Text:Paint( x, y )
    
    end

end

function COMPONENT:Paint( x, y )

    if self.ammotype <= 0 then return end

    self.Number:Paint( x, y )
    self.Number2:Paint( x, y )
    self.AmmoBar:Paint( x, y )
    self.AmmoTray:Paint( x, y )
    self.Separator:Paint( x, y )

    if not self.icon_on_background then
        
        self.Icon:Paint( x, y )
    
    end

    if not self.text_on_background then
        
        self.Text:Paint( x, y )
    
    end

end

function COMPONENT:PaintScanlines( x, y )

    StartAlphaMultiplier( self.Blur:GetAmount() )
    self:Paint( x, y )
    EndAlphaMultiplier()

end

HOLOHUD2.component.Register( "HudAmmo", COMPONENT )