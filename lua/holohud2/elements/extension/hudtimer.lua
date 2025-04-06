
local BaseClass = HOLOHUD2.component.Get( "Clock" )

local StartAlphaMultiplier = HOLOHUD2.render.StartAlphaMultiplier
local EndAlphaMultiplier = HOLOHUD2.render.EndAlphaMultiplier
local GetMinimumGlow = HOLOHUD2.render.GetMinimumGlow

local COMPONENT = {
    color               = color_white,
    color2              = color_white,
    text_on_background  = false
}

function COMPONENT:Init()

    BaseClass.Init( self )

    self.Hours:SetVisible( false )
    self.Separator2:SetVisible( false )

    self.Text = HOLOHUD2.component.Create( "Text" )

end

function COMPONENT:InvalidateLayout()

    BaseClass.InvalidateLayout( self )
    self.Text:InvalidateLayout()

end

function COMPONENT:SetColor( color )

    BaseClass.SetColor( self, color )

    if self.text_on_background then return end

    self.Text:SetColor( color )

end

function COMPONENT:SetColor2( color2 )

    BaseClass.SetColor2( self, color2 )

    if not self.text_on_background then return end

    self.Text:SetColor( color2 )

end

function COMPONENT:SetDrawTextOnBackground( on_background )

    self.Text:SetColor( on_background and self.color2 or self.color )
    self.text_on_background = on_background

end

function COMPONENT:PaintBackground( x, y )

    BaseClass.PaintBackground( self, x, y )

    if not self.text_on_background then return end

    self.Text:Paint( x, y )

end

function COMPONENT:PaintScanlines( x, y )

    StartAlphaMultiplier( GetMinimumGlow() )
    self:Paint( x, y )
    EndAlphaMultiplier()
    
end

function COMPONENT:ApplySettings( settings, fonts )

    self:SetColor( settings.color )
    self:SetColor2( settings.color2 )
    self:SetBlinking( settings.blinking )

    local minutes = self.Minutes
    minutes:SetVisible( settings.minutes )
    minutes:SetFont( fonts.minutes_font )
    minutes:SetRenderMode( settings.minutes_rendermode )
    minutes:SetBackground( settings.minutes_background )
    minutes:SetAlign( settings.minutes_align )

    local separator = self.Separator
    separator:SetVisible( settings.separator )
    separator:SetFont( fonts.separator_font )
    self:SetDrawSeparatorBackground( settings.separator_background )

    local seconds = self.Seconds
    seconds:SetVisible( settings.seconds )
    seconds:SetFont( fonts.seconds_font )
    seconds:SetRenderMode( settings.seconds_rendermode )
    seconds:SetBackground( settings.seconds_background )
    seconds:SetAlign( settings.seconds_align )

    local text = self.Text
    text:SetVisible( settings.text )
    text:SetText( settings.text_text )
    text:SetPos( settings.text_pos.x, settings.text_pos.y )
    text:SetFont( fonts.text_font )
    text:SetAlign( settings.text_align )
    self:SetDrawTextOnBackground( settings.text_on_background )
    text:InvalidateLayout()

    minutes:PerformLayout( true )
    separator:PerformLayout( true )
    seconds:PerformLayout( true )

    local minutes_w, separator_w, seconds_w = 0, 0, 0
    local spacings = 0

    if settings.minutes then

        minutes_w = minutes.__w
        spacings = spacings + 1

        if settings.separator then

            separator_w = separator.__w
            spacings = spacings + 1

        end

    end

    if settings.seconds then

        seconds_w = seconds.__w

    end
    
    local w = minutes_w + separator_w + seconds_w + settings.spacing * spacings
    local x, y = settings.origin.x, settings.origin.y

    if settings.align == TEXT_ALIGN_CENTER then

        x = x - w / 2

    elseif settings.align == TEXT_ALIGN_RIGHT then
    
        x = x - w

    end

    
    minutes:SetPos( x + settings.minutes_offset.x, y + settings.minutes_offset.y )

    x = x + minutes_w + settings.spacing
    separator:SetPos( x + settings.separator_offset.x, y + settings.separator_offset.y )

    x = x + separator_w + settings.spacing
    seconds:SetPos( x + settings.seconds_offset.x, y + settings.seconds_offset.y )

end

HOLOHUD2.component.Register( "HudExtensionTimer", COMPONENT, "Clock" )