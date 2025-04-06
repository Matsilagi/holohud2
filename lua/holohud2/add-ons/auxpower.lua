---
--- H.E.V. Mk V Auxiliary Power
--- https://steamcommunity.com/sharedfiles/filedetails/?id=1758584347
---

if SERVER then return end

if not AUXPOW then return end

local IsEnabled = HOLOHUD2.IsEnabled
local element_suitpower = HOLOHUD2.element.Get( "suitpower" )
local element_flashlight = HOLOHUD2.element.Get( "flashlight" )

---
--- Replace suit power
---
HOLOHUD2.hook.Add( "GetSuitPower", "auxpower", function()

    if not AUXPOW:IsEnabled() then return end

    return AUXPOW:GetPower() * 100

end)

---
--- Replace flashlight
---
HOLOHUD2.hook.Add( "GetFlashlight", "auxpower", function()

    if not AUXPOW:IsEnabled() or not AUXPOW:IsEP2Mode() then return end

    return AUXPOW:GetFlashlight() * 100

end)

HOLOHUD2.hook.Add( "ShouldDrawFlashlight", "auxpower", function()

    if not AUXPOW:IsEnabled() or not AUXPOW:IsEP2Mode() or AUXPOW:GetFlashlight() >= 1 then return end

    return true

end)

---
--- Hide flashlight from suit power indicator
---
HOLOHUD2.hook.Add( "ShouldHideSuitFlashlight", "auxpower", function()

    if not AUXPOW:IsEnabled() or not AUXPOW:IsEP2Mode() then return end

    return true

end)

---
--- Hide addon's HUD
---
hook.Add( "AuxPowerHUDPaint", "holohud2", function()

    if not IsEnabled() or not element_suitpower:IsVisible() then return end

    return true

end)

---
--- Hide addon's flashlight HUD
---
hook.Add( "EP2FlashlightHUDPaint", "holohud2", function()

    if not IsEnabled() or not element_flashlight:IsVisible() then return end

    return true

end)