local StartAlphaMultiplier = HOLOHUD2.render.StartAlphaMultiplier
local EndAlphaMultiplier = HOLOHUD2.render.EndAlphaMultiplier
local GetMinimumGlow = HOLOHUD2.render.GetMinimumGlow

local BaseClass = HOLOHUD2.component.Get( "Radar" )

local UNITS_HAMMER      = HOLOHUD2.DISTANCE_HAMMER
local UNITS_METRIC      = HOLOHUD2.DISTANCE_METRIC
local UNITS_IMPERIAL    = HOLOHUD2.DISTANCE_IMPERIAL

local COMPONENT = {
    units = UNITS_HAMMER,
    range_on_background = false,
    text_on_background = false,
    _conversion = 1,
    _units = "%d ?"
}

function COMPONENT:Init()

    self.Range = HOLOHUD2.component.Create( "Text" )
    self.Text = HOLOHUD2.component.Create( "Text" )

end

function COMPONENT:InvalidateLayout()

    BaseClass.InvalidateLayout( self )
    self.Range:InvalidateLayout()
    self.Text:InvalidateLayout()

end

function COMPONENT:SetUnits( units )

    if self.units == units then return end

    if units == UNITS_METRIC then

        self._conversion = HOLOHUD2.HU_TO_M
        self._units = "%d " .. language.GetPhrase( HOLOHUD2.UNIT_METRIC )

    elseif units == UNITS_IMPERIAL then

        self._conversion = HOLOHUD2.HU_TO_FT
        self._units = "%d " .. language.GetPhrase( HOLOHUD2.UNIT_IMPERIAL )

    else

        self._conversion = 1
        self._units = "%d " .. language.GetPhrase( HOLOHUD2.UNIT_HAMMER )

    end

    self.units = units
    self._RefreshRange(self)

    return true

end

function COMPONENT:SetDrawRangeOnBackground( on_background )

    self.range_on_background = on_background

end

function COMPONENT:SetDrawTextOnBackground( on_background )

    self.text_on_background = on_background

end

function COMPONENT:SetRange( range )

    BaseClass.SetRange( self, range )

    self._RefreshRange( self )

end

function COMPONENT._RefreshRange( self )

    self.Range:SetText( string.format( self._units, math.Round( self.range * self._conversion ) ) )

end

function COMPONENT:Think()

    BaseClass.Think( self )

    self.Range:PerformLayout()
    self.Text:PerformLayout()

end

function COMPONENT:PaintBackground( x, y )

    BaseClass.PaintBackground( self, x, y )

    if self.range_on_background then
        
        self.Range:Paint( x, y )
    
    end

    if self.text_on_background then
        
        self.Text:Paint( x, y )
    
    end

end

function COMPONENT:Paint( x, y )

    BaseClass.Paint( self, x, y )

    if not self.range_on_background then
        
        self.Range:Paint( x, y )
    
    end

    if not self.text_on_background then
        
        self.Text:Paint( x, y )
    
    end

end

function COMPONENT:PaintScanlines(x, y)

    StartAlphaMultiplier( GetMinimumGlow() )
    self:Paint( x, y )
    EndAlphaMultiplier()

end

function COMPONENT:ApplySettings( settings, fonts )

    self._sweepanim = 0
    self._sweepsize = 0
    self._lastsweep = 0

    self:SetSize( settings.size.x, settings.size.y )

    local range = self.Range
    range:SetVisible( settings.rangelabel )
    range:SetPos( settings.rangelabel_pos.x, settings.rangelabel_pos.y )
    range:SetFont( fonts.rangelabel_font )
    range:SetAlign( settings.rangelabel_align )
    range:SetColor( settings.rangelabel_color )
    self:SetDrawRangeOnBackground( settings.rangelabel_on_background )
    self:SetUnits( settings.rangelabel_unit )

    local text = self.Text
    text:SetVisible( settings.text )
    text:SetPos( settings.text_pos.x, settings.text_pos.y )
    text:SetFont( fonts.text_font )
    text:SetAlign( settings.text_align )
    text:SetColor( settings.text_color )
    text:SetText( settings.text_text )
    self:SetDrawTextOnBackground( settings.text_on_background )

    self:SetColor2( settings.overlay_color )
    self:SetDrawFOV( settings.overlay_fov )
    self:SetDrawGrid( settings.overlay_grid )
    self:SetDrawCross( settings.overlay_cross )

    self:SetColor( settings.color )
    self:SetFoeColor( settings.color_foe )
    self:SetFriendColor( settings.color_friend )

    self:SetDrawSweep( settings.sweep )
    self:SetSweepColor( settings.sweep_color )
    self:SetSweepDelay( settings.sweep_delay )
    self:SetSweepTime( settings.sweep_time )
    
    self:InvalidateLayout()
    self:SetRange( settings.range / self._conversion )

end

HOLOHUD2.component.Register( "HudRadar", COMPONENT, "Radar" )