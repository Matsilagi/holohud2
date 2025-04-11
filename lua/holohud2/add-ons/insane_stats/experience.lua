
local Lerp = Lerp
local FrameTime = FrameTime
local StartAlphaMultiplier = HOLOHUD2.render.StartAlphaMultiplier
local EndAlphaMultiplier = HOLOHUD2.render.EndAlphaMultiplier

local COMPONENT = {
    color               = color_white,
    color2              = color_white,
    level_prefix        = "LEVEL ",
    level_on_background = false,
    level               = 0,
    value               = 0,
    max_value           = 0,
    _value              = 0,
    number_lerp         = false,
    progressbar_lerp    = true
}

function COMPONENT:Init()

    self.Blur = HOLOHUD2.component.Create( "Blur" )
    self.Numbers = HOLOHUD2.component.Create( "InlineCounter" )
    self.ProgressBarBackground = HOLOHUD2.component.Create( "Bar" )
    self.ProgressBar = HOLOHUD2.component.Create( "ProgressBar" )
    self.Level = HOLOHUD2.component.Create( "Text" )

end

function COMPONENT:InvalidateLayout()

    self.Numbers:InvalidateLayout()
    self.ProgressBarBackground:InvalidateLayout()
    self.ProgressBar:InvalidateLayout()
    self.Level:InvalidateLayout()

end

function COMPONENT:SetNumberLerp( lerp )

    if self.number_lerp == lerp then return end

    if not lerp then self.Numbers:SetValue( math.Round( self.value ) ) end

    self.number_lerp = lerp

end

function COMPONENT:SetProgressBarLerp( lerp )

    if self.progressbar_lerp == lerp then return end

    if not lerp then self.ProgressBar:SetValue( self.value / self.max_value ) end

    self.progressbar_lerp = lerp

end

function COMPONENT:SetExperience( value )

    if self.value == value then return end

    self.Blur:Activate()
    if not self.number_lerp then self.Numbers:SetValue( math.Round( value ) ) end
    if not self.progressbar_lerp then self.ProgressBar:SetValue( value / self.max_value ) end

    self.value = value

end

function COMPONENT:SetMaxExperience( max_value )

    if self.max_value == max_value then return end

    self.Numbers:SetMaxValue( max_value )
    if not self.progressbar_lerp then self.ProgressBar:SetValue( self.value / max_value ) end

    self.max_value = max_value

    return true

end

function COMPONENT:SetLevel( level )

    self.Level:SetText( self.level_prefix .. level )
    self.level = level

end

function COMPONENT:SetLevelPrefix( prefix )

    if self.level_prefix == prefix then return end

    self.Level:SetText( prefix .. self.level )
    self.level_prefix = prefix

    return true

end

function COMPONENT:SetDrawLevelOnBackground( on_background )

    self.Level:SetColor( on_background and self.color2 or self.color )

    self.level_on_background = on_background

end

function COMPONENT:SetColor( color )

    self.Numbers.Number:SetColor( color )
    self.Numbers.Separator:SetColor( color )
    self.Numbers.Number2:SetColor( color )
    self.ProgressBar:SetColor( color )

    if not self.level_on_background then

        self.Level:SetColor( color )

    end

    self.color = color

end

function COMPONENT:SetColor2( color2 )

    self.Numbers.Number:SetColor2( color2 )
    self.Numbers.Number2:SetColor2( color2 )
    self.ProgressBarBackground:SetColor( color2 )

    if self.level_on_background then

        self.Level:SetColor( color2 )

    end

    self.color2 = color2

end

function COMPONENT:Think()

    self._value = Lerp( FrameTime() * 12, self._value, self.value )

    if self.number_lerp then self.Numbers:SetValue( math.Round( self._value ) ) end
    if self.progressbar_lerp then self.ProgressBar:SetValue( self._value / self.max_value ) end

    self.Blur:Think()
    self.Numbers:Think()
    self.ProgressBarBackground:PerformLayout()
    self.ProgressBar:Think()
    self.Level:PerformLayout()

end

function COMPONENT:PaintBackground( x, y )

    self.Numbers:PaintBackground( x, y )
    self.ProgressBarBackground:Paint( x, y )

    if not self.level_on_background then return end

    self.Level:Paint( x, y )

end

function COMPONENT:Paint( x, y )

    self.Numbers:Paint(x, y )
    self.ProgressBar:Paint( x, y )

    if self.level_on_background then return end

    self.Level:Paint( x, y )

end

function COMPONENT:PaintScanlines( x, y )

    StartAlphaMultiplier( self.Blur:GetAmount() )
    self:Paint( x, y )
    EndAlphaMultiplier()

end

function COMPONENT:ApplySettings( settings, fonts )

    self:SetColor( settings.color )
    self:SetColor2( settings.color2 )

    local nums = self.Numbers
    nums:SetSpacing( settings.nums_spacing )
    nums:SetAlign( settings.nums_align )
    nums:SetPos( settings.nums_pos.x, settings.nums_pos.y )

    local num = self.Numbers.Number
    num:SetVisible( settings.nums and settings.num )
    num:SetFont( fonts.num_font )
    num:SetRenderMode( settings.num_rendermode )
    num:SetBackground( settings.num_background )
    num:SetAlign( settings.num_align )
    num:SetDigits( settings.num_digits )
    self:SetNumberLerp( settings.num_lerp )

    local separator = self.Numbers.Separator
    separator:SetVisible( settings.nums and settings.num and settings.separator and settings.num2 )
    nums:SetSeparatorOffset( settings.separator_offset )
    separator:SetDrawAsRectangle( settings.separator_is_rect )
    separator:SetSize( settings.separator_size.x, settings.separator_size.y )
    separator:SetFont( fonts.separator_font )

    local num2 = self.Numbers.Number2
    num2:SetVisible( settings.nums and settings.num2 )
    nums:SetNumber2Offset( settings.num2_offset )
    num2:SetFont( fonts.num2_font )
    num2:SetRenderMode( settings.num2_rendermode )
    num2:SetBackground( settings.num2_background )
    num2:SetAlign( settings.num2_align )
    num2:SetDigits( settings.num2_digits )

    local barbackground = self.ProgressBarBackground
    barbackground:SetVisible( settings.progressbar and settings.progressbar_background )
    barbackground:SetPos( settings.progressbar_pos.x, settings.progressbar_pos.y )
    barbackground:SetSize( settings.progressbar_size.x, settings.progressbar_size.y )
    barbackground:SetStyle( settings.progressbar_style )
    
    local bar = self.ProgressBar
    bar:SetVisible( settings.progressbar )
    bar:Copy( barbackground )
    bar:SetGrowDirection( settings.progressbar_growdirection )
    self:SetProgressBarLerp( settings.progressbar_lerp )

    local level = self.Level
    level:SetVisible( settings.level )
    level:SetPos( settings.level_pos.x, settings.level_pos.y )
    level:SetFont( fonts.level_font )
    level:SetAlign( settings.level_align )
    self:SetDrawLevelOnBackground( settings.level_on_background )

end

HOLOHUD2.component.Register( "InsaneStats_HudExperience", COMPONENT )