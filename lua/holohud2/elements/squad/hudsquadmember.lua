local surface = surface
local FrameTime = FrameTime
local Lerp = Lerp
local scale_Get = HOLOHUD2.scale.Get
local StartAlphaMultiplier = HOLOHUD2.render.StartAlphaMultiplier
local EndAlphaMultiplier = HOLOHUD2.render.EndAlphaMultiplier

local COMPONENT = {
    invalid_layout      = false,
    is_medic            = false,
    outlined            = false,
    x                   = 0,
    y                   = 0,
    color               = color_white,
    fade_offset         = 0,
    fade_time           = 0,
    fade_color          = color_white,
    highlight_offset    = 0,
    highlight_time      = 0,
    highlight_color     = color_white,
    background          = true,
    fade                = true,
    highlight           = false,
    health              = 0,
    _health             = 0,
    _fanim              = 0,
    _hanim              = 0,
    _animoffset         = 0,
    _x0                 = 0,
    _y0                 = 0,
    _x1                 = 0,
    _y1                 = 0
}

local TEXTURE_DIMENSIONS        = { 32, 128, 0, 0, 28, 84 }

local TEXTURE_MEMBER            = surface.GetTextureID( "holohud2/squad/member" )
local TEXTURE_MEDIC             = surface.GetTextureID( "holohud2/squad/medic" )

local TEXTURE_OUTLINE           = surface.GetTextureID( "holohud2/squad/outline" )
local TEXTURE_MEDIC_OUTLINE     = surface.GetTextureID( "holohud2/squad/outline_medic" )
local RESOURCE_HEALTH           = { surface.GetTextureID( "holohud2/squad/outline_health" ), 32, 128, 0, 18, 28, 84 }

function COMPONENT:Init()

    self.Color = HOLOHUD2.component.Create( "Color" )
    self.Colors = HOLOHUD2.component.Create( "ColorRanges" )
    self.Colors2 = HOLOHUD2.component.Create( "ColorRanges" )

    local color = self.Color:GetColor()

    local icon = HOLOHUD2.component.Create( "Icon" )
    icon:SetColor( color )
    self.Icon = icon

    local healthicon = HOLOHUD2.component.Create( "ProgressIcon" )
    healthicon:SetTexture( RESOURCE_HEALTH )
    healthicon:SetGrowDirection( HOLOHUD2.GROWDIRECTION_UP )
    healthicon:SetColor( color )
    self.HealthIcon = healthicon
    
    local healthbarbackground = HOLOHUD2.component.Create( "Bar" )
    healthbarbackground:SetColor( self.Colors2:GetColor() )
    self.HealthBarBackground = healthbarbackground

    local healthbar = HOLOHUD2.component.Create( "ProgressBar" )
    healthbar:SetColor( self.Colors:GetColor() )
    self.HealthBar = healthbar

end

function COMPONENT:InvalidateLayout()

    self.invalid_layout = true

end

function COMPONENT:PerformLayout( force )

    if force or self.invalid_layout then

        if self.outlined then

            self.Icon:SetTexture( self.is_medic and TEXTURE_MEDIC_OUTLINE or TEXTURE_OUTLINE, unpack( TEXTURE_DIMENSIONS ) )

        else

            self.Icon:SetTexture( self.is_medic and TEXTURE_MEDIC or TEXTURE_MEMBER, unpack( TEXTURE_DIMENSIONS ) )

        end

        self.invalid_layout = false

    end

    self.Icon:PerformLayout( force )
    self.HealthIcon:PerformLayout( force )
    self.HealthBarBackground:PerformLayout( force )
    self.HealthBar:PerformLayout( force )

end

function COMPONENT:SetOutlined( outlined )

    if self.outlined == outlined then return end

    self.outlined = outlined

    self:InvalidateLayout()

end

function COMPONENT:SetPos( x, y )

    if self.x == x and self.y == y then return end

    local scale = scale_Get()

    self.x = x
    self.y = y

    self._x0 = math.Round( self.x * scale )
    self._y0 = math.Round( self.y * scale )

    if self._fanim > 0 then return end -- if invisible, move immediately

    self._x1 = self._x0
    self._y1 = self._y0

end

function COMPONENT:SetIsMedic( is_medic )

    if self.is_medic == is_medic then return end

    self.is_medic = is_medic

    self:InvalidateLayout()

end

function COMPONENT:SetColor( color )

    if self.color == color then return end
    
    if self.fade and not self.highlight then

        self.Color:SetColor( color )

    end

    self.color = color

end

function COMPONENT:SetFadeOffset( offset )

    self.fade_offset = offset

end

function COMPONENT:SetFadeTime( time )

    self.fade_time = time

end

function COMPONENT:SetFadeColor( color )

    if self.fade_color == color then return end
    
    if not self.fade and not self.highlight then

        self.Color:FadeTo( color )

    end

    self.fade_color = color

end

function COMPONENT:SetHighlightOffset( offset )

    self.highlight_offset = offset

end

function COMPONENT:SetHighlightTime( time )

    self.highlight_time = time

end

function COMPONENT:SetHighlightColor( color )

    if self.highlight_color == color then return end
    
    if self.highlight then

        self.Color:FadeTo( color )

    end

    self.highlight_color = color

end

function COMPONENT:SetDrawBackground( background )

    self.background = background

end

function COMPONENT:SetDrawHealth( visible )

    self.HealthBarBackground:SetVisible( visible )
    self.HealthBar:SetVisible( visible )

end

function COMPONENT:SetHealth( health )

    self.Colors:SetValue( health )
    self.Colors2:SetValue( health )

    self.health = health

end

function COMPONENT:SetFading( fade, died )

    if self.fade == fade then return end

    if died then

        self.Color:FadeTo( self.fade_color )

    end

    self.fade = false

end

function COMPONENT:SetHighlighted( highlight )

    if self.highlight == highlight then return end
    if not self.fade then return end -- fading out animation has more priority
    
    self.Color:FadeTo( highlight and self.highlight_color or self.color )

    self.highlight = highlight

end

function COMPONENT:SetSize( size )

    self.Icon:SetSize( size )
    self.HealthIcon:SetPos( 0, size * .22 )
    self.HealthIcon:SetSize( size  * .77 )

end

function COMPONENT:GetSize()

    return self.Icon:GetSize()

end

function COMPONENT:Think()

    self.Color:Think()

    local frametime = FrameTime()
    local lerp_speed = frametime * 12

    -- lerp health
    self._health = Lerp( lerp_speed, self._health, self.health )

    -- reposition smoothly
    self._x1 = Lerp( lerp_speed, self._x1, self._x0 )
    self._y1 = Lerp( lerp_speed, self._y1, self._y0 )

    -- do fading animation
    if self.fade then

        self._fanim = math.min( self._fanim + frametime / self.fade_time, 1 )

    else

        self._fanim = math.max( self._fanim - frametime / self.fade_time, 0 )

    end

    -- do highlight animation
    if self.highlight then

        self._hanim = math.min( self._hanim + frametime / self.highlight_time, 1 )

    else

        self._hanim = math.max( self._hanim - frametime / self.highlight_time, 0 )

    end

    self._animoffset = ( 1 - self._fanim ) * self.fade_offset + self._hanim * self.highlight_offset

    if self.outlined then

        self.HealthIcon:SetValue( self._health )
        self.HealthIcon:Think()
        
    else

        self.Colors:Think()
        self.Colors2:Think()
        self.HealthBar:SetValue( self._health )
        self.HealthBar:Think()

    end
    
    self:PerformLayout()

end

function COMPONENT:PaintBackground( x, y )

    if self.outlined then return end
    if not self.background then return end
    
    x = x + self._x1
    y = y + self._y1 + self._animoffset

    StartAlphaMultiplier( self._fanim )

    self.HealthBarBackground:Paint( x, y )

    EndAlphaMultiplier()

end

function COMPONENT:Paint( x, y )

    x = x + self._x1
    y = y + self._y1 + self._animoffset
    
    StartAlphaMultiplier( self._fanim )

    self.Icon:Paint( x, y )

    if self.outlined then

        self.HealthIcon:Paint( x, y )

    else

        self.HealthBar:Paint( x, y )

    end

    EndAlphaMultiplier()

end

HOLOHUD2.component.Register( "HudSquadMember", COMPONENT )