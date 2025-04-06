local Lerp = Lerp
local FrameTime = FrameTime
local StartAlphaMultiplier = HOLOHUD2.render.StartAlphaMultiplier
local EndAlphaMultiplier = HOLOHUD2.render.EndAlphaMultiplier

local COMPONENT = {
    value               = 0,
    lerp                = false,
    tier_color          = true,
    color               = color_white,
    color2              = color_white,
    icon_on_background  = false,
    text_on_background  = false,
    transform_oversize  = {
        number_pos      = false,
        icon_pos        = false,
        text_pos        = false
    },
    _value              = 0,
    _last_tier          = 0,
    _number_size        = 0,
    _last_number_size   = 0,
    _last_offset        = 0
}

function COMPONENT:Init()

    self.Blur = HOLOHUD2.component.Create( "Blur" )
    self.Number = HOLOHUD2.component.Create( "Number" )
    self.Text = HOLOHUD2.component.Create( "Text" )

    local icon = HOLOHUD2.component.Create( "Icon" )
    icon:SetTexture( surface.GetTextureID( "holohud2/insane_stats/coins" ), 64, 64 )
    self.Icon = icon

end

function COMPONENT:InvalidateLayout()

    self.Number:InvalidateLayout()
    self.Icon:InvalidateLayout()
    self.Text:InvalidateLayout()

end

function COMPONENT:SetOversizeTransform( transform )

    self.transform_oversize = transform

end

function COMPONENT:ApplyOversizeTransform( offset )

    -- WARNING: remember to reset these transforms when applying a new configuration!

    if self.transform_oversize.number_pos then self.Number:SetPos( self.Number.x + offset, self.Number.y ) end
    if self.transform_oversize.icon then self.Icon:SetPos( self.Icon.x + offset, self.Icon.y ) end
    if self.transform_oversize.text_pos then self.Text:SetPos( self.Text.x + offset, self.Text.y ) end

    self._last_offset = self._last_offset + offset

end

function COMPONENT:GetOversizeOffset()

    return self._last_offset

end

function COMPONENT:RevertOversizeTransform()

    self:ApplyOversizeTransform( -self._last_offset )

end

function COMPONENT:SetLastCoinTier( tier )

    self._last_tier = tier

end

function COMPONENT:SetUseTierColor( tier_color )

    self.tier_color = tier_color

end

function COMPONENT:SetColor( color )

    self.Number:SetColor( color )

    if not self.icon_on_background then

        self.Icon:SetColor( color )

    end

    if not self.text_on_background then

        self.Text:SetColor( color )

    end

    self.color = color

end

function COMPONENT:SetColor2( color2 )

    self.Number:SetColor2( color2 )

    if self.icon_on_background then

        self.Icon:SetColor( color2 )

    end

    if self.text_on_background then

        self.Text:SetColor( color2 )

    end

    self.color2 = color2

end

function COMPONENT:SetValue( value )

    if self.value == value then return end

    self.Blur:Activate()

    if not self.lerp then

        self.Number:SetValue( value )

    end

    self.value = value

    return true

end

function COMPONENT:SetNumberLerp( lerp )

    if self.lerp == lerp then return end

    if not lerp then
        
        self.Number:SetValue( self.value )

    end
    
    self.lerp = lerp
    
    return true

end

function COMPONENT:SetDrawIconOnBackground( on_background )

    if self.icon_on_background == on_background then return end

    self.Icon:SetColor( on_background and self.color2 or self.color )
    self.icon_on_background = on_background

    return true

end

function COMPONENT:SetDrawTextOnBackground( on_background )

    if self.text_on_background == on_background then return end

    self.Text:SetColor( on_background and self.color2 or self.color )
    self.text_on_background = on_background

    return true

end

local cache = Color( 255, 255, 255 )
function COMPONENT:Think()

    if self.tier_color then

        local color = InsaneStats:GetCoinColor( self._last_tier )
        cache:SetUnpacked( color.r, color.g, color.b, self.icon_on_background and self.color2.a or self.color.a )
        self.Icon:SetColor( cache )

    end

    self.Blur:Think()
    self.Number:PerformLayout()
    self.Icon:PerformLayout()
    self.Text:PerformLayout()

    self._value = Lerp( FrameTime() * 12, self._value, self.value )

    if self.lerp then

        self.Number:SetValue( math.Round( self._value ) )

    end

    -- if number size changes apply an offset
    if self.Number.__w ~= self._last_number_size then
        
        self:ApplyOversizeTransform( self.Number.__w - self._last_number_size )
        self._last_number_size = self.Number.__w

    end

end

function COMPONENT:PaintBackground( x, y )

    self.Number:PaintBackground( x, y )

    if self.icon_on_background then

        self.Icon:Paint( x, y )

    end

    if self.text_on_background then

        self.Text:Paint( x, y )

    end

end

function COMPONENT:Paint( x, y )

    self.Number:Paint( x, y )

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

function COMPONENT:ApplySettings( settings, fonts )

    -- undo current transforms
    self:RevertOversizeTransform()

    self:SetColor( settings.color )
    self:SetColor2( settings.color2 )

    local number = self.Number
    number:SetVisible( settings.num )
    number:SetPos( settings.num_pos.x, settings.num_pos.y )
    number:SetFont( fonts.num_font )
    number:SetRenderMode( settings.num_rendermode )
    number:SetBackground( settings.num_background )
    number:SetDigits( settings.num_digits )
    self:SetNumberLerp( settings.num_lerp )

    -- get new number size
    number:PerformLayout( true )
    self._number_size = number.__defaultsize
    self._last_number_size = self._number_size

    local icon = self.Icon
    icon:SetVisible( settings.icon )
    icon:SetPos( settings.icon_pos.x, settings.icon_pos.y )
    icon:SetSize( settings.icon_size )
    self:SetUseTierColor( settings.icon_tier_color )
    self:SetDrawIconOnBackground( settings.icon_on_background )

    local text = self.Text
    text:SetVisible( settings.text )
    text:SetPos( settings.text_pos.x, settings.text_pos.y )
    text:SetFont( fonts.text_font )
    text:SetText( settings.text_text )
    text:SetAlign( settings.text_align )
    self:SetDrawTextOnBackground( settings.text_on_background )

    self:SetOversizeTransform( {
        number_pos          = settings.health_oversize_numberpos,
        icon_pos            = settings.health_oversize_iconpos,
        text_pos            = settings.health_oversize_textpos
    } )

    self:InvalidateLayout()

end

HOLOHUD2.component.Register( "InsaneStats_HudCoins", COMPONENT )