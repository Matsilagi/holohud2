
local COMPONENT = {
    item_color  = false
}

function COMPONENT:SetItem( item )

    local icon = HOLOHUD2.item.Get( item )

    if not icon then return end

    self:SetTexture( { icon.texture, icon.filew, icon.fileh, icon.x, icon.y, icon.w, icon.h } )

    if not icon.color then return end

    self.color = icon.color()
    self.item_color = true

end

function COMPONENT:SetColor( color )

    self.color = color
    self.item_color = false

end

function COMPONENT:IsUsingItemColor()

    return self.item_color

end

HOLOHUD2.component.Register( "ItemPickup", COMPONENT, "Icon" )