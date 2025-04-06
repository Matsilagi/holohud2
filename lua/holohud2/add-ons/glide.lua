---
--- Glide
--- https://steamcommunity.com/sharedfiles/filedetails/?id=3389728250
---

if SERVER then return end

if not Glide then return end

-- NOTE: I can't just hide Glide's speedometer and I don't want to screw with the weapon system.

-- local IsEnabled = HOLOHUD2.IsEnabled
-- local element_speedometer = HOLOHUD2.element.Get( "speedometer" )

-- hook.Add( "Glide_CanDrawHUD", "holohud2", function( vehicle )

--     if not IsEnabled() or not element_speedometer:IsVisible() then return end

--     return false

-- end)

HOLOHUD2.hook.Add( "GetVehicleHealth", "glide", function( vehicle )

    if not vehicle.IsGlideVehicle then return end

    return vehicle:GetChassisHealth() / vehicle.MaxChassisHealth

end)

HOLOHUD2.hook.Add( "GetVehicleRPM", "glide", function( vehicle )

    if not vehicle.IsGlideVehicle or not vehicle.GetEngineRPM then return end

    return vehicle:GetEngineRPM(), vehicle:GetMaxRPM()

end)

HOLOHUD2.hook.Add( "GetVehicleGear", "glide", function( vehicle )

    if not vehicle.IsGlideVehicle or not vehicle.GetGear then return end
    
    return vehicle:GetGear()

end)