
local COMPONENT = {}

function COMPONENT:Init()

    self.Header = HOLOHUD2.component.Create( "Text" )
    self.Contents = HOLOHUD2.component.Create( "Text" )

    local separator = HOLOHUD2.component.Create( "Separator" )
    separator:SetDrawAsRectangle( true )
    self.Separator = separator
end

function COMPONENT:SetTitle( title )

    self.Header:SetText( title )

end

function COMPONENT:SetAgenda( agenda )

    self.Contents:SetText( agenda )

end

function COMPONENT:Think()

    self.Header:PerformLayout()
    self.Separator:PerformLayout()
    self.Contents:PerformLayout()

end

function COMPONENT:Paint( x, y )

    self.Header:Paint( x, y )
    self.Separator:Paint( x, y )
    self.Contents:Paint( x, y )

end

function COMPONENT:ApplySettings( settings, fonts )

    local header = self.Header
    header:SetVisible( settings.title )
    header:SetPos( settings.title_pos.x, settings.title_pos.y )
    header:SetColor( settings.tint )
    header:SetFont( fonts.title_font )

    local separator = self.Separator
    separator:SetVisible( settings.separator )
    separator:SetPos( settings.separator_pos.x, settings.separator_pos.y )
    separator:SetSize( settings.separator_size.x, settings.separator_size.y )
    separator:SetColor( settings.tint )

    local agenda = self.Contents
    agenda:SetPos( settings.agenda_pos.x, settings.agenda_pos.y )
    agenda:SetFont( fonts.agenda_font )

end

HOLOHUD2.component.Register( "DarkRP_HudAgenda", COMPONENT )