
local PANEL = {}

Derma_Hook( PANEL, "Paint", "Paint", "Tooltip" )

function PANEL:Init()

  local icon = vgui.Create( "DImage", self )
  icon:SetSize( 16, 16 )
  icon:SetPos( 4, 4 )
  icon:SetImage( "icon16/information.png" )
  self.Icon = icon

  local label = vgui.Create( "DLabel", self )
  label:SetPos( 24, 6 )
  label:SetFont( "default" )
  label:SetTextColor( self:GetSkin().Colours.TooltipText )
  self.Label = label

end

function PANEL:SetText( text )

  self.Label:SetText( text )
  self.Label:SizeToContents()

end

function PANEL:SetIcon( icon )

  self.Icon:SetImage( icon )

end

vgui.Register( "HOLOHUD2_DHint", PANEL, "Panel" )