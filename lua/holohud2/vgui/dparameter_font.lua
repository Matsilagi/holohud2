
DEFINE_BASECLASS( "HOLOHUD2_DParameter" )

local PANEL = {}

function PANEL:Init()

    local italic = vgui.Create( "DButton", self )
    italic:Dock( RIGHT )
    italic:DockMargin( 0, 2, 2, 2 )
    italic:SetWide( 20 )
    italic:SetIsToggle( true )
    italic:SetImage( "icon16/text_italic.png" )
    italic:SetText( "" )
    italic:SetTooltip( "Italic" )
    italic.OnToggled = function() self:OnFontChanged() end
    italic:SetZPos( 1 )
    self.Italic = italic

    local bold = vgui.Create( "DButton", self )
    bold:Dock( RIGHT )
    bold:DockMargin( 0, 2, 4, 2 )
    bold:SetWide( 20 )
    bold:SetIsToggle( true )
    bold:SetImage( "icon16/text_bold.png" )
    bold:SetText( "" )
    bold:SetTooltip( "Bold" )
    bold:SetZPos( 2 )
    bold.OnToggled = function() self:OnFontChanged() end
    self.Bold = bold
    
    local numwang = vgui.Create( "DNumberWang", self )
    numwang:SetSize( 42, 14 )
    numwang:Dock( RIGHT )
    numwang:DockMargin( 0, 2, 4, 2 )
    numwang:SetMinMax( 1, 256 )
    numwang:SetTooltip( "Font size" )
    numwang:SetZPos( 3 )
    numwang.OnValueChanged = function() self:OnFontChanged() end
    self.Size = numwang

    local textentry = vgui.Create( "DTextEntry", self )
    textentry:SetSize( 156, 14 )
    textentry:Dock( RIGHT )
    textentry:DockMargin( 0, 2, 4, 2 )
    textentry:SetTooltip( "Font family" )
    textentry:SetPlaceholderText( "Font family" )
    textentry:SetZPos( 4 )
    textentry.OnEnter = function() self:OnFontChanged() end
    textentry.OnLoseFocus = function() self:OnFontChanged() end
    self.Font = textentry

end

function PANEL:Populate( parameter )

    BaseClass.Populate( self, parameter )
    self:SetPreviewFont( parameter.previewfont )

end

function PANEL:SetPreviewFont( font )

    self.PreviewFont = font

end

function PANEL:OnFontChanged()

    if self.PreventUpdate then return end

    local font = { font = self.Font:GetValue(), size = self.Size:GetValue(), weight = self.Bold:GetToggle() and 1000 or 0, italic = self.Italic:GetToggle() }

    self.Value = font

    if self.PreviewFont then
        
        HOLOHUD2.font.Register( self.PreviewFont, font )
        HOLOHUD2.font.Create( self.PreviewFont )

    end
    
    self:OnValueChanged( font )

end

function PANEL:GetValue()

    return self.Value

end

function PANEL:SetValue( value )

    self.PreventUpdate = true

    self.Font:SetValue( value.font )
    self.Size:SetValue( value.size )
    self.Bold:SetToggle( value.weight > 500 )
    self.Italic:SetToggle( value.italic )
    self.Value = value

    self.PreventUpdate = false

end

vgui.Register( "HOLOHUD2_DParameter_Font", PANEL, "HOLOHUD2_DParameter" )