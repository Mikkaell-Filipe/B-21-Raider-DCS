local cscripts = folder .. "../../../Cockpit/Scripts/"
dofile(cscripts .. "devices.lua")
dofile(cscripts .. "command_defs.lua")

local res = external_profile("Config/Input/Aircrafts/common_joystick_binding.lua")

join(res.keyCommands, {
    -- ===== Controle de voo =====
    {down = iCommandPlaneUpStart,    up = iCommandPlaneUpStop,    name = _('Aircraft Pitch Down'), category = _('Flight Control')},
    {down = iCommandPlaneDownStart,  up = iCommandPlaneDownStop,  name = _('Aircraft Pitch Up'),   category = _('Flight Control')},
    {down = iCommandPlaneLeftStart,  up = iCommandPlaneLeftStop,  name = _('Aircraft Bank Left'),  category = _('Flight Control')},
    {down = iCommandPlaneRightStart, up = iCommandPlaneRightStop, name = _('Aircraft Bank Right'), category = _('Flight Control')},
    {down = iCommandPlaneLeftRudderStart,  up = iCommandPlaneLeftRudderStop,  name = _('Aircraft Rudder Left'),  category = _('Flight Control')},
    {down = iCommandPlaneRightRudderStart, up = iCommandPlaneRightRudderStop, name = _('Aircraft Rudder Right'), category = _('Flight Control')},

    -- ===== Manete =====
    {pressed = iCommandThrottleIncrease, up = iCommandThrottleStop, name = _('Throttle Up'),   category = _('Flight Control')},
    {pressed = iCommandThrottleDecrease, up = iCommandThrottleStop, name = _('Throttle Down'), category = _('Flight Control')},
    {down = iCommandPlaneAUTIncreaseRegime, name = _('Throttle Step Up'),   category = _('Flight Control')},
    {down = iCommandPlaneAUTDecreaseRegime, name = _('Throttle Step Down'), category = _('Flight Control')},

    -- ===== Trim (padrao DCS) =====
    {pressed = iCommandPlaneTrimUp,    up = iCommandPlaneTrimStop, name = _('Trim: Nose Up'),        category = _('Flight Control')},
    {pressed = iCommandPlaneTrimDown,  up = iCommandPlaneTrimStop, name = _('Trim: Nose Down'),      category = _('Flight Control')},
    {pressed = iCommandPlaneTrimLeft,  up = iCommandPlaneTrimStop, name = _('Trim: Left Wing Down'), category = _('Flight Control')},
    {pressed = iCommandPlaneTrimRight, up = iCommandPlaneTrimStop, name = _('Trim: Right Wing Down'), category = _('Flight Control')},
    {pressed = iCommandPlaneTrimLeftRudder,  up = iCommandPlaneTrimStop, name = _('Trim: Rudder Left'),  category = _('Flight Control')},
    {pressed = iCommandPlaneTrimRightRudder, up = iCommandPlaneTrimStop, name = _('Trim: Rudder Right'), category = _('Flight Control')},

    -- ===== Trem de pouso =====
    {down = iCommandPlaneGear,     name = _('Landing Gear Up/Down'), category = _('Systems')},
    {down = iCommandPlaneGearUp,   name = _('Landing Gear Up'),      category = _('Systems')},
    {down = iCommandPlaneGearDown, name = _('Landing Gear Down'),    category = _('Systems')},

    -- ===== Sistemas =====
    {down = iCommandPlaneAirBrake, name = _('Airbrake'), category = _('Systems')},
    {down = iCommandPlaneLightsOnOff, name = _('Navigation lights'), category = _('Systems')},
    {down = iCommandPlaneCockpitIllumination, name = _('Illumination Cockpit'), category = _('Systems')},
    {down = iCommandPlaneEject, name = _('Eject (3 times)'), category = _('Systems')},
    {down = iCommandPlaneDropFlareOnce, name = _('Countermeasures Flares Dispense'), category = _('Countermeasures')},
    {down = iCommandPlaneDropChaffOnce, name = _('Countermeasures Chaff Dispense'), category = _('Countermeasures')},

    -- ===== Comandos customizados do B-21 =====
    {down = Keys.EngStartAll,   name = _('Engines Start - BOTH'),   category = _('Engine')},
    {down = Keys.EngStopAll,    name = _('Engines Stop - BOTH'),    category = _('Engine')},
    {down = Keys.EngStartL,     name = _('Engine Start - LEFT'),    category = _('Engine')},
    {down = Keys.EngStartR,     name = _('Engine Start - RIGHT'),   category = _('Engine')},
    {down = Keys.EngStopL,      name = _('Engine Stop - LEFT'),     category = _('Engine')},
    {down = Keys.EngStopR,      name = _('Engine Stop - RIGHT'),    category = _('Engine')},
    {down = Keys.BrakesOn, up = Keys.BrakesOff, name = _('Wheel Brakes - ON/OFF (hold)'), category = _('Systems')},
    {down = Keys.ParkBrake,     name = _('Parking Brake - TOGGLE'), category = _('Systems')},
    {down = Keys.NwsToggle,     name = _('Nosewheel Steering - TOGGLE'), category = _('Systems')},
    {down = Keys.StairsToggle,  name = _('Crew Stairs - TOGGLE'),   category = _('Systems')},
    {down = Keys.BayToggle,     name = _('Weapon Bay Doors - TOGGLE'), category = _('Systems')},
    {down = Keys.RevoToggle,    name = _('Air Refuel Receptacle - TOGGLE'), category = _('Systems')},
    {down = Keys.LandLight,     name = _('Landing Light - TOGGLE'), category = _('Lights')},
    {down = Keys.TaxiLight,     name = _('Taxi Light - TOGGLE'),    category = _('Lights')},
    {down = Keys.BeaconLight,   name = _('Beacon - TOGGLE'),        category = _('Lights')},
    {down = Keys.SasToggle,     name = _('FBW/SAS - TOGGLE'),       category = _('Flight Control')},
    {down = Keys.TrimUp,        name = _('EFM Trim Nose UP'),       category = _('Flight Control')},
    {down = Keys.TrimDown,      name = _('EFM Trim Nose DOWN'),     category = _('Flight Control')},
    {down = Keys.TrimReset,     name = _('EFM Trim RESET'),         category = _('Flight Control')},
})

-- ===== Eixos do joystick =====
join(res.axisCommands, {
    {action = iCommandPlaneRoll,         name = _('Roll')},
    {action = iCommandPlanePitch,        name = _('Pitch')},
    {action = iCommandPlaneRudder,       name = _('Rudder')},
    {action = iCommandPlaneThrustCommon, name = _('Thrust')},
    {action = iCommandWheelBrake,        name = _('Wheel Brake'),       category = {_('Systems')}},
    {action = iCommandLeftWheelBrake,    name = _('Wheel Brake Left'),  category = {_('Systems')}},
    {action = iCommandRightWheelBrake,   name = _('Wheel Brake Right'), category = {_('Systems')}},
})

return res
