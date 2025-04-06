
DEFINE_BASECLASS( "#holohud2.category.panel" )

local PANEL = {}

PANEL.Expanded      = false
PANEL._cheight      = 0
-- PANEL.ContentHeight = 0
PANEL.AnimTime      = .2
PANEL.PaintGuide    = false
PANEL.Margin        = 11
PANEL.Length        = 11

function PANEL:Init()

    self.anim_slide = Derma_Anim( "Anim", self, self.AnimSlide )
    self:SetExpanded( false )
    self.Branches = {}
    self:SetPaintGuide( true )

end

function PANEL:SetPaintGuide( paint )

    self.PaintGuide = paint
    self:DockPadding( paint and ( self.Margin + self.Length ) or 0, 0, 0, 0 )

end

function PANEL:SetExpanded( expanded )

    self.Expanded = expanded
    self:OnExpandChanged( expanded )

    if self:GetExpanded() then return end

    if not self.anim_slide.Finished and self.ContentHeight then return end

    self.ContentHeight = self:GetTall()

end

function PANEL:GetExpanded()

    return self.Expanded

end

function PANEL:Toggle()

    self:SetExpanded( not self:GetExpanded() )

    self.anim_slide:Start( self:GetAnimTime(), { From = self:GetTall() } )

    self:InvalidateLayout( true )

end

function PANEL:DoExpansion( expansion )

    if self:GetExpanded() == expansion then return end

    self:Toggle()

end

function PANEL:SetAnimTime( time )

    self.AnimTime = time

end

function PANEL:GetAnimTime()

    return self.AnimTime

end

function PANEL:AnimSlide( anim, delta, data )

    self:InvalidateLayout()

    if anim.Started then
        
        if self:GetExpanded() then
            
            data.To = math.max( self.ContentHeight, self:GetTall() )

        else

            data.To = self:GetTall()

        end

    end

    self:SetTall( Lerp( delta, data.From, data.To ) )

end

function PANEL:Paint(x, y)

    local color = self:GetSkin().Colours.Tree.Lines

    surface.SetDrawColor( color.r, color.g, color.b, color.a )

    for _, branch in ipairs( self.Branches ) do

        surface.DrawLine( self.Margin, branch, self.Margin + self.Length, branch )

    end

    surface.DrawLine( self.Margin, 0, self.Margin, self.Branches[ #self.Branches ] )

end

function PANEL:Think()

    self.anim_slide:Run()

    if not self.ContentHeight then return end
    if self.ContentHeight == self._cheight then return end

    self:RefreshGuide()
    self._cheight = self.ContentHeight

end

function PANEL:RefreshGuide()

    self.Branches = {}

    local y = 0

    for _, child in pairs( self:GetChildren() ) do

        if not child:IsVisible() then continue end

        local tall = child:GetTall()

        if child:GetName() ~= self:GetName() then
            
            table.insert( self.Branches, y + tall / 2 )

        end

        y = y + tall

    end

end

function PANEL:PerformLayout()
    
    if self:GetExpanded() then
        
        self:SizeToChildren( false, true )

    else

        self:SetTall( 0 )

    end

    self.anim_slide:Run()

end

function PANEL:OnExpandChanged( expanded ) end

vgui.Register( "HOLOHUD2_DCollapsiblePanel", PANEL, "Panel" )