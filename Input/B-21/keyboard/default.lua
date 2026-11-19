local cscripts = folder .. "../../../Cockpit/Scripts/"
dofile(cscripts .. "devices.lua")
dofile(cscripts .. "command_defs.lua")

local res = external_profile("Config/Input/Aircrafts/common_keyboard_binding.lua")

join(res.keyCommands, {

    -- ===== Controle de voo =====
    {combos = {{key = 'Up'}},     down = iCommandPlaneUpStart,    up = iCommandPlaneUpStop,    name = _('Aircraft Pitch Down'), category = _('Flight Control')},
    {combos = {{key = 'Down'}},   down = iCommandPlaneDownStart,  up = iCommandPlaneDownStop,  name = _('Aircraft Pitch Up'),   category = _('Flight Control')},
    {combos = {{key = 'Left'}},   down = iCommandPlaneLeftStart,  up = iCommandPlaneLeftStop,  name = _('Aircraft Bank Left'), category = _('Flight Control')},
    {combos = {{key = 'Right'}},  down = iCommandPlaneRightStart, up = iCommandPlaneRightStop, name = _('Aircraft Bank Right'), category = _('Flight Control')},
    {combos = {{key = 'Z'}},      down = iCommandPlaneLeftRudderStart,  up = iCommandPlaneLeftRudderStop,  name = _('Aircraft Rudder Left'),  category = _('Flight Control')},
    {combos = {{key = 'X'}},      down = iCommandPlaneRightRudderStart, up = iCommandPlaneRightRudderStop, name = _('Aircraft Rudder Right'), category = _('Flight Control')},

    -- ===== Manete =====
    {combos = {{key = 'Num+'}},   pressed = iCommandThrottleIncrease, up = iCommandThrottleStop, name = _('Throttle Up'),   category = _('Flight Control')},
    {combos = {{key = 'Num-'}},   pressed = iCommandThrottleDecrease, up = iCommandThrottleStop, name = _('Throttle Down'), category = _('Flight Control')},
    {combos = {{key = 'PageUp'}},   down = iCommandPlaneAUTIncreaseRegime, name = _('Throttle Step Up'),   category = _('Flight Control')},
    {combos = {{key = 'PageDown'}}, down = iCommandPlaneAUTDecreaseRegime, name = _('Throttle Step Down'), category = _('Flight Control')},

    -- ===== Trim (padrao DCS) =====
    {combos = {{key = '.', reformers = {'RCtrl'}}}, pressed = iCommandPlaneTrimUp,    up = iCommandPlaneTrimStop, name = _('Trim: Nose Up'),        category = _('Flight Control')},
    {combos = {{key = ';', reformers = {'RCtrl'}}}, pressed = iCommandPlaneTrimDown,  up = iCommandPlaneTrimStop, name = _('Trim: Nose Down'),      category = _('Flight Control')},
    {combos = {{key = ',', reformers = {'RCtrl'}}}, pressed = iCommandPlaneTrimLeft,  up = iCommandPlaneTrimStop, name = _('Trim: Left Wing Down'), category = _('Flight Control')},
    {combos = {{key = '/', reformers = {'RCtrl'}}}, pressed = iCommandPlaneTrimRight, up = iCommandPlaneTrimStop, name = _('Trim: Right Wing Down'), category = _('Flight Control')},
    {combos = {{key = 'Z', reformers = {'RCtrl'}}}, pressed = iCommandPlaneTrimLeftRudder,  up = iCommandPlaneTrimStop, name = _('Trim: Rudder Left'),  category = _('Flight Control')},
    {combos = {{key = 'X', reformers = {'RCtrl'}}}, pressed = iCommandPlaneTrimRightRudder, up = iCommandPlaneTrimStop, name = _('Trim: Rudder Right'), category = _('Flight Control')},

    -- ===== Trem de pouso (comando padrao do DCS que o EFM precisa receber) =====
    {combos = {{key = 'G'}},                         down = iCommandPlaneGear,     name = _('Landing Gear Up/Down'), category = _('Systems')},
    {combos = {{key = 'G', reformers = {'LCtrl'}}},  down = iCommandPlaneGearUp,   name = _('Landing Gear Up'),      category = _('Systems')},
    {combos = {{key = 'G', reformers = {'LShift'}}}, down = iCommandPlaneGearDown, name = _('Landing Gear Down'),    category = _('Systems')},

    -- ===== Freio aerodinamico (split rudders) =====
    {combos = {{key = 'B'}}, down = iCommandPlaneAirBrake, name = _('Airbrake'), category = _('Systems')},

    -- ===== Sistemas gerais =====
    {combos = {{key = 'L', reformers = {'RCtrl'}}}, down = iCommandPlaneLightsOnOff, name = _('Navigation lights'), category = _('Systems')},
    {combos = {{key = 'L'}},                        down = iCommandPlaneCockpitIllumination, name = _('Illumination Cockpit'), category = _('Systems')},
    {combos = {{key = 'E', reformers = {'LCtrl'}}}, down = iCommandPlaneEject, name = _('Eject (3 times)'), category = _('Systems')},
    {combos = {{key = 'Delete'}}, down = iCommandPlaneDropFlareOnce, name = _('Countermeasures Flares Dispense'), category = _('Countermeasures')},
    {combos = {{key = 'Insert'}}, down = iCommandPlaneDropChaffOnce, name = _('Countermeasures Chaff Dispense'), category = _('Countermeasures')},

    -- ===== Comandos customizados do B-21 (10001-10020, iguais ao Cmd:: do EFM) =====
    -- Motores
    {combos = {{key = 'Home', reformers = {'LAlt'}}},  down = Keys.EngStartAll, name = _('Engines Start - BOTH'),  category = _('Engine')},
    {combos = {{key = 'End',  reformers = {'LAlt'}}},  down = Keys.EngStopAll,  name = _('Engines Stop - BOTH'),   category = _('Engine')},
    {                                                  down = Keys.EngStartL,   name = _('Engine Start - LEFT'),    category = _('Engine')},
    {                                                  down = Keys.EngStartR,   name = _('Engine Start - RIGHT'),   category = _('Engine')},
    {                                                  down = Keys.EngStopL,    name = _('Engine Stop - LEFT'),     category = _('Engine')},
    {                                                  down = Keys.EngStopR,    name = _('Engine Stop - RIGHT'),    category = _('Engine')},
    -- Freios / solo
    {combos = {{key = 'W'}},                           down = Keys.BrakesOn, up = Keys.BrakesOff, name = _('Wheel Brakes - ON/OFF (hold)'), category = _('Systems')},
    {combos = {{key = 'W', reformers = {'LShift'}}},   down = Keys.ParkBrake,   name = _('Parking Brake - TOGGLE'),       category = _('Systems')},
    {combos = {{key = 'N', reformers = {'LAlt'}}},     down = Keys.NwsToggle,   name = _('Nosewheel Steering - TOGGLE'), category = _('Systems')},
    {combos = {{key = 'S', reformers = {'LCtrl', 'LAlt'}}}, down = Keys.StairsToggle, name = _('Crew Stairs - TOGGLE'), category = _('Systems')},
    -- Baia, REVO
    {combos = {{key = 'B', reformers = {'LCtrl'}}},    down = Keys.BayToggle,   name = _('Weapon Bay Doors - TOGGLE'),   category = _('Systems')},
    {combos = {{key = 'R', reformers = {'LCtrl'}}},    down = Keys.RevoToggle,  name = _('Air Refuel Receptacle - TOGGLE'), category = _('Systems')},
    -- Luzes
    {combos = {{key = 'L', reformers = {'LShift'}}},   down = Keys.LandLight,   name = _('Landing Light - TOGGLE'),     category = _('Lights')},
    {combos = {{key = 'T', reformers = {'LShift'}}},   down = Keys.TaxiLight,   name = _('Taxi Light - TOGGLE'),        category = _('Lights')},
    {combos = {{key = 'B', reformers = {'LShift'}}},   down = Keys.BeaconLight, name = _('Beacon - TOGGLE'),           category = _('Lights')},
    -- FBW / trim do EFM
    {combos = {{key = 'F', reformers = {'LAlt'}}},     down = Keys.SasToggle,   name = _('FBW/SAS - TOGGLE'),            category = _('Flight Control')},
    {combos = {{key = 'Up',   reformers = {'LCtrl'}}}, down = Keys.TrimDown,    name = _('EFM Trim Nose DOWN'),          category = _('Flight Control')},
    {combos = {{key = 'Down', reformers = {'LCtrl'}}}, down = Keys.TrimUp,      name = _('EFM Trim Nose UP'),            category = _('Flight Control')},
    {combos = {{key = 'T', reformers = {'LCtrl'}}},    down = Keys.TrimReset,   name = _('EFM Trim RESET'),              category = _('Flight Control')},
})
return res
