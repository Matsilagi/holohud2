---
--- Goldsrc Counter-Strike Buymenu
--- https://steamcommunity.com/sharedfiles/filedetails/?id=3311934020
---

if SERVER then return end

local IsEnabled = HOLOHUD2.IsEnabled
local element_money = HOLOHUD2.element.Get( "money" )
local LocalPlayer = LocalPlayer

local money = -1

HOLOHUD2.hook.Add( "ShouldDrawMoney", "cstrikebuymenu", function()
    
    money = LocalPlayer():GetNW2Int( "cstrike_money", -1 )

    if money == -1 then return end

    return true

end)

HOLOHUD2.hook.Add( "GetMoney", "cstrikebuymenu", function()

    if money == -1 then return end

    return money

end)

hook.Add( "CStrike_MoneyHUD", "holohud2", function()

    if money == -1 then return end

    if not IsEnabled() or not element_money:IsVisible() then return end

    return true

end)