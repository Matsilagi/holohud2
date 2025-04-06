---
--- Support for nMoney2.
--- https://steamcommunity.com/sharedfiles/filedetails/?id=2430255692
---

if SERVER then return end

if not NMONEY2_MAXVALUE then return end

HOLOHUD2.hook.Add( "ShouldDrawMoney", "nmoney2", function()

    return true

end)

HOLOHUD2.hook.Add( "GetMoney", "nmoney2", function()

    return tonumber( LocalPlayer():GetNWString( "WalletMoney" ) ) or 0

end)