
local PANEL = {}

function PANEL:Init()

    local expand = vgui.Create( "Panel", self )
    expand:SetWide( 14 )
    expand:Dock( LEFT )
    expand:DockMargin( 2, 0, 0, 0 )
    
    expand:Hide()

        local button = vgui.Create( "DExpandButton", expand )
        button:SetPos( 2, 4 )
        button.DoClick = function()
            
            self:Toggle()

        end
        self.ExpandButton = button
    
    self.ExpandContainer = expand

    local reset = vgui.Create( "DImageButton", self )
    reset:Dock( RIGHT )
    reset:SetZPos( 128 )
    reset:DockMargin( 0, 0, 5, 0 )
    reset:SetSize( 16, 16 )
    reset:SetStretchToFit( false )
    reset:SetImage( "icon16/arrow_refresh.png" )
    reset:SetTooltip( "#holohud2.common.reset_to_default" )
    reset:Hide()
    reset.DoClick = function()

        self:OnValueReset()

    end
    self.Reset = reset

    local name = vgui.Create( "DLabel", self )
    name:Dock( LEFT )
    name:DockMargin( 8, 0, 0, 0 )
    name:SetTextColor( self:GetSkin().Colours.Label.Dark )
    self.Name = name

    local presets = vgui.Create( "DImageButton", self )
    presets:Dock( RIGHT )
    presets:DockMargin( 0, 0, 4, 0 )
    presets:SetImage( "icon16/wrench.png" )
    presets:SetStretchToFit( false )
    presets:Hide()
    self.Presets = presets

end

function PANEL:SetExpanded( expanded )

    self.ExpandButton:SetExpanded( expanded )

    if not self.CollapsiblePanel then return end
    
    self.CollapsiblePanel:SetExpanded( expanded )

end

function PANEL:Toggle()

    self.ExpandButton:SetExpanded( not self.ExpandButton:GetExpanded() )
    self.CollapsiblePanel:Toggle()
    self:OnExpandChanged( self.ExpandButton:GetExpanded() )

end

function PANEL:SetCollapsiblePanel( panel )

    self.ExpandContainer:SetVisible( true )
    self:InvalidateLayout()

    self.CollapsiblePanel = panel

end

function PANEL:SetName( name )

    self.Name:SetText( name )
    self.Name:SizeToContents()

end

function PANEL:SetResettable( visible )

    self.Reset:SetVisible( visible )
    self:InvalidateLayout()

end

function PANEL:Populate( parameter ) end
function PANEL:SetValue( value ) end
function PANEL:GetValue() end

function PANEL:OnValueReset() end
function PANEL:OnValueChanged( value ) end
function PANEL:OnExpandChanged( expanded ) end

vgui.Register( "HOLOHUD2_DParameter", PANEL, "HOLOHUD2_DListLine" )