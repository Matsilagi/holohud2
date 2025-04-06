
local Lerp = Lerp
local FrameTime = FrameTime
local StartAlphaMultiplier = HOLOHUD2.render.StartAlphaMultiplier
local EndAlphaMultiplier = HOLOHUD2.render.EndAlphaMultiplier

local COMPONENT = {
    color                   = color_white,
    color2                  = color_white,
    currency_on_background  = false,
    text_on_background      = false,
    lerp                    = false,
    value                   = 0,
    _value                  = 0
}

function COMPONENT:Init()

    self.Blur = HOLOHUD2.component.Create( "Blur" )
    self.Currency = HOLOHUD2.component.Create( "Text" )
    self.Text = HOLOHUD2.component.Create( "Text" )

    local number = HOLOHUD2.component.Create( "Number" )
    number:SetOverrideAbbreviation( true )
    self.Number = number

end

function COMPONENT:InvalidateLayout()

    self.Currency:InvalidateLayout()
    self.Text:InvalidateLayout()
    self.Number:InvalidateLayout()

end

function COMPONENT:SetColor( color )

    self.Number:SetColor( color )

    if not self.currency_on_background then

        self.Currency:SetColor( color )

    end

    if not self.text_on_background then

        self.Text:SetColor( color )

    end

    self.color = color

end

function COMPONENT:SetColor2( color2 )

    self.Number:SetColor2( color2 )

    if self.currency_on_background then

        self.Currency:SetColor( color2 )

    end

    if self.text_on_background then

        self.Text:SetColor( color2 )

    end

    self.color2 = color2

end

function COMPONENT:SetDrawCurrencyOnBackground( on_background )

    self.Currency:SetColor( on_background and self.color2 or self.color )
    self.currency_on_background = on_background

end

function COMPONENT:SetDrawTextOnBackground( on_background )

    self.Text:SetColor( on_background and self.color2 or self.color )
    self.text_on_background = on_background

end

function COMPONENT:SetLerp( lerp )

    if self.lerp == lerp then return end

    self.lerp = lerp

    if not lerp then

        self.Number:SetValue( self.value )

    end

end

function COMPONENT:SetValue( value )

    if self.value == value then return end

    self.Blur:Activate()
    self.value = value

    if self.lerp then return end

    self.Number:SetValue( value )

end

function COMPONENT:Think()

    self.Blur:Think()
    self.Currency:PerformLayout()
    self.Number:PerformLayout()
    self.Text:PerformLayout()

    if not self.lerp then return end

    self._value = Lerp( FrameTime() * 12, self._value, self.value )

    self.Number:SetValue( math.Round( self._value ) )

end

function COMPONENT:PaintBackground( x, y )

    if self.currency_on_background then

        self.Currency:Paint( x, y )

    end

    self.Number:PaintBackground( x, y )

    if self.text_on_background then

        self.Text:Paint( x, y )

    end

end

function COMPONENT:Paint( x, y )

    if not self.currency_on_background then

        self.Currency:Paint( x, y )

    end

    self.Number:Paint( x, y )

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

    self:SetColor( settings.color )
    self:SetColor2( settings.color2 )
    
    local currency = self.Currency
    currency:SetVisible( settings.currency )
    currency:SetPos( settings.currency_pos.x, settings.currency_pos.y )
    currency:SetFont( fonts.currency_font )
    currency:SetAlign( settings.currency_align )
    currency:SetText( settings.currency_text )
    self:SetDrawTextOnBackground( settings.currency_on_background )

    local number = self.Number
    number:SetVisible( settings.number )
    number:SetPos( settings.number_pos.x, settings.number_pos.y )
    number:SetFont( fonts.number_font )
    number:SetRenderMode( settings.number_rendermode )
    number:SetBackground( settings.number_background )
    number:SetAlign( settings.number_align )
    number:SetDigits( settings.number_digits )
    number:InvalidateLayout()
    self:SetLerp( settings.number_lerp )

    local text = self.Text
    text:SetVisible( settings.text )
    text:SetPos( settings.text_pos.x, settings.text_pos.y )
    text:SetFont( fonts.text_font )
    text:SetAlign( settings.text_align )
    text:SetText( settings.text_text )
    self:SetDrawTextOnBackground( settings.text_on_background )

end

HOLOHUD2.component.Register( "HudExtensionMoney", COMPONENT )