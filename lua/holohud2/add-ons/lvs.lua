---
--- [LVS] Framework
--- https://steamcommunity.com/workshop/filedetails/?id=2912816023
---

if SERVER then return end

if not LVS then return end

local LocalPlayer = LocalPlayer

HOLOHUD2.hook.Add( "GetVehicleHealth", "lvs", function( _ )

    local vehicle = LocalPlayer():lvsGetVehicle()

    if not vehicle or not IsValid( vehicle ) then return end

    if not vehicle.GetEngine then
        
        return vehicle:GetHP() / vehicle:GetMaxHP()

    end
    
    local engine = vehicle:GetEngine()

    if not IsValid( engine ) then return end

    return engine:GetHP() / engine:GetMaxHP()

end)

HOLOHUD2.hook.Add( "GetVehicleRPM", "lvs", function( _ )

    local vehicle = LocalPlayer():lvsGetVehicle()

    if not vehicle or not IsValid( vehicle ) or not vehicle.GetEngine then return end

    local engine = vehicle:GetEngine()

    if not IsValid( engine ) or not engine.GetRPM then return end

    return engine:GetRPM(), vehicle.EngineMaxRPM

end)

HOLOHUD2.hook.Add( "GetVehicleGear", "lvs", function( _ )

    local vehicle = LocalPlayer():lvsGetVehicle()

    if not vehicle or not IsValid( vehicle ) or not vehicle.GetEngine then return end

    local engine = vehicle:GetEngine()

    if not IsValid( engine ) or not engine.GetGear then return end

    if not vehicle:GetEngineActive() then return 0 end -- N
    if vehicle:GetReverse() then return -1 end -- R

    return engine:GetGear()

end)