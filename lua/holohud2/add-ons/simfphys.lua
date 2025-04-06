---
--- simfphys
--- https://steamcommunity.com/workshop/filedetails/?id=771487490
---

if SERVER then return end

if not simfphys then return end

HOLOHUD2.hook.Add( "GetVehicleHealth", "simfphys", function( vehicle )

    if not vehicle.IsSimfphyscar then return end

    return vehicle:GetCurHealth() / vehicle:GetMaxHealth()

end)

HOLOHUD2.hook.Add( "GetVehicleRPM", "simfphys", function( vehicle )

    if not vehicle.IsSimfphyscar then return end

    return vehicle:GetRPM(), vehicle:GetLimitRPM()

end)

HOLOHUD2.hook.Add( "GetVehicleGear", "simfphys", function( vehicle )

    if not vehicle.IsSimfphyscar then return end

    return vehicle:GetGear() - 2

end)