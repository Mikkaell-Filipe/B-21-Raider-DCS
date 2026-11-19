-- B-21 Raider - Aircraft Definition & Model Lua
-- Shape: B-21.edm | Flight Model: EFM

-- Texturas: current_mod_path = Saved Games\DCS\Mods\aircraft\B-21 RAIDER  ->  ...\B-21 RAIDER\Textures
mount_vfs_texture_path(current_mod_path .. "/Textures")
mount_vfs_texture_path(current_mod_path .. "/Cockpit/Textures")

local KG_TO_POUNDS = 2.20462
local POUNDS_TO_KG = 1 / KG_TO_POUNDS
local FEET_TO_M    = 0.3048

-- Armamentos compatíveis com as baias internas do B-21 (JDAM / JSOW / Mk-82 / Mk-84)
local function get_bay_weapons(bay_arg)
    return {
        { CLSID = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}", arg = bay_arg, arg_value = 1.0 }, -- Mk-82 500lb
        { CLSID = "{7A44FF09-527C-4B7E-B42B-3F111CFE50FB}", arg = bay_arg, arg_value = 1.0 }, -- Mk-83 1000lb
        { CLSID = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}", arg = bay_arg, arg_value = 1.0 }, -- Mk-84 2000lb
        { CLSID = "{GBU-31}",                               arg = bay_arg, arg_value = 1.0 }, -- GBU-31 JDAM (2000lb)
        { CLSID = "{GBU-38}",                               arg = bay_arg, arg_value = 1.0 }, -- GBU-38 JDAM (500lb)
        { CLSID = "{AGM-154A}",                             arg = bay_arg, arg_value = 1.0 }, -- AGM-154A JSOW
        { CLSID = "<CLEAN>",                                arg = bay_arg, arg_value = 0.0 },
    }
end

B_21 = {
    Name            = 'B-21',
    DisplayName     = _('B-21 Raider'),
    ViewSettings    = ViewSettings,

    Countries = {
        "USA",
        "USAF Aggressors",
        "Brazil",
        "UK",
        "Australia",
    },

    HumanCockpit        = true,
    HumanCockpitPath    = current_mod_path .. '/Cockpit/',
    Picture             = "B-21.png",
    Rate                = 80,
    Shape               = "B-21", -- Carrega Shapes/B-21.edm

    shape_table_data =
    {
        {
            file        = 'B-21',
            life        = 28,
            vis         = 3,
            desrt       = 'Fighter-2-crush',
            fire        = {300, 4},
            username    = 'B-21',
            index       = WSTYPE_PLACEHOLDER,
            classname   = "lLandPlane",
            positioning = "BYNORMAL",
        },
    },

    ---------------------------------------------------------------------------
    -- ARGUMENTOS DE ANIMAÇÃO DO MODELO EXTERNO (B-21.edm) - Máx. 32 args
    -- Mapeados diretamente do seu externo.blend
    ---------------------------------------------------------------------------
    net_animation = {
        0, 2,           -- trem do nariz: retração, esterçamento
        3, 5,           -- trem principal D/E
        11, 12,         -- ailerons D/E
        15, 16,         -- profundores D/E
        17,             -- leme
        22,             -- receptáculo REVO
        500, 501,       -- baia esq/dir
        502, 503,       -- spoilers esq/dir
        504,            -- launch bar
        505, 506,       -- pneu nariz / roda nariz
        507, 508,       -- pneus esq/dir
        76, 77, 78,     -- rotação das rodas (padrão DCS, usado pelo EFM)
        193, 208, 209,  -- luzes
    },

    mapclasskey = "P0091000027", -- Ícone de bombardeiro estratégico no mapa F10
    attribute   = {wsType_Air, wsType_Airplane, wsType_Cruiser, WSTYPE_PLACEHOLDER, "Strategic bombers", "Refuelable"},
    Categories  = {"{78EFB7A2-FD52-4b57-A6A6-3BF0E1D6555F}", "Bomber"},

    ---------------------------------------------------------------------------
    -- MASSAS E DIMENSÕES DO B-21 RAIDER
    ---------------------------------------------------------------------------
    M_empty         = 31750,  -- ~70,000 lbs (peso vazio estimado)
    M_nominal       = 55000,  -- ~121,250 lbs (peso típico de missão)
    M_max           = 81650,  -- ~180,000 lbs (MTOW)
    M_fuel_max      = 36000,  -- ~79,360 lbs (combustível interno)
    H_max           = 15240,  -- 50,000 pés em metros

    length          = 16.5,   -- Comprimento aproximado (m)
    height          = 4.6,    -- Altura aproximada (m)
    wing_area       = 300.0,  -- Área alar da asa voadora (m²)
    wing_span       = 42.7,   -- Envergadura aproximada ~132 ft (m)
    wing_tip_pos    = {-5.2, 0.0, 21.35},
    wing_type       = 0,      -- Asa fixa
    flaps_maneuver  = 0.0,
    has_speedbrake  = true,   -- Split rudders atuam como freio aerodinâmico

    RCS                 = 0.001, -- Baixa assinatura radar (Stealth)
    IR_emission_coeff   = 0.25,  -- Baixa assinatura infravermelha (escapamentos embutidos)
    IR_emission_coeff_ab = 0.25,

    stores_number   = 2,      -- 2 baias internas (Esquerda e Direita)

    CAS_min         = 56.0,   -- ~110 kts
    V_opt           = 235.0,  -- Cruzeiro subsônico alto (~Mach 0.80)
    V_take_off      = 72.0,   -- ~140 kts
    V_land          = 64.0,   -- ~125 kts
    V_max_sea_level = 275.0,
    V_max_h         = 265.0,
    Vy_max          = 35.0,
    Mach_max        = 0.88,
    Ny_min          = -1.5,
    Ny_max          = 3.0,
    Ny_max_e        = 3.0,
    bank_angle_max  = 45,
    range           = 9600,   -- Alcance estratégico (km)

    -- Propulsão (2x Turbofans sem pós-combustor, classe F135 derivativo)
    thrust_sum_max              = 20400, -- kgf total (2 x 100 kN, = kThrustSLPerEngine no EFM)
    has_afteburner              = false,
    has_differential_stabilizer = false,
    thrust_sum_ab               = 20400,
    average_fuel_consumption    = 0.52,
    is_tanker                   = false,
    tanker_type                 = 2,
    air_refuel_receptacle_pos   = {1.2, 1.35, 0.0}, -- Ajuste para a posição de B21_REFUEL_RECEPTICLE

    ---------------------------------------------------------------------------
    -- TREM DE POUSO (Referência para IA / Solo)
    ---------------------------------------------------------------------------
    tand_gear_max = math.rad(45.0), -- Ângulo máximo de esterçamento (Arg 2 no EFM / 506 no modelo)

    nose_gear_pos                            = { 5.3098, -1.7832, 0.0000},
    main_gear_pos                            = {-1.6915, -1.8231, 3.7359},

    nose_gear_amortizer_direct_stroke        =  0.00,
    nose_gear_amortizer_reversal_stroke      = -0.25,
    main_gear_amortizer_direct_stroke        =  0.00,
    main_gear_amortizer_reversal_stroke      = -0.30,

    nose_gear_amortizer_normal_weight_stroke = -0.10,
    main_gear_amortizer_normal_weight_stroke = -0.12,

    nose_gear_wheel_diameter                 = 1.1383,
    main_gear_wheel_diameter                 = 1.4907,

    ---------------------------------------------------------------------------
    -- MOTORES (2x Turbofans)
    ---------------------------------------------------------------------------
    engines_count   = 2,
    engines_nozzles =
    {
        [1] =
        {
            pos                 = {-4.8, 0.45, -2.10}, -- Motor Esquerdo
            elevation           = 0.0,
            diameter            = 0.0, -- 0 oculta cone de AB
            exhaust_length_ab   = 0.01,
            exhaust_length_ab_K = 0.0,
            smokiness_level     = 0.05,
            afterburner_circles_count = 0,
        },
        [2] =
        {
            pos                 = {-4.8, 0.45, 2.10},  -- Motor Direito
            elevation           = 0.0,
            diameter            = 0.0,
            exhaust_length_ab   = 0.01,
            exhaust_length_ab_K = 0.0,
            smokiness_level     = 0.05,
            afterburner_circles_count = 0,
        },
    },

    sounderName = "Aircraft/Planes/B-21", -- Substitua pelo sounder próprio quando criar

    crew_size    = 2,
    crew_members =
    {
        [1] = -- Piloto (Esquerda)
        {
            ejection_seat_name  = 17,
            drop_canopy_name    = 0,
            pos                 = {4.85, 0.65, -0.55},
            canopy_pos          = {4.85, 1.15, -0.55},
            g_suit              = 3.0,
        },
        [2] = -- Comandante de Missão / WSO (Direita)
        {
            ejection_seat_name  = 17,
            drop_canopy_name    = 0,
            pos                 = {4.85, 0.65, 0.55},
            canopy_pos          = {4.85, 1.15, 0.55},
            g_suit              = 3.0,
        },
    },

    mechanimations = {
        Door0 = {
            {Transition = {"Close", "Open"},  Sequence = {{C = {{"Arg", 38, "to", 1.0, "in", 4.0}}}}, Flags = {"Reversible"}},
            {Transition = {"Open", "Close"},  Sequence = {{C = {{"Arg", 38, "to", 0.0, "in", 4.0}}}}, Flags = {"Reversible", "StepsBackwards"}},
            {Transition = {"Any", "Bailout"}, Sequence = {{C = {{"JettisonCanopy", 0}}}}},
        },
    },

    fires_pos =
    {
        [1] = {0.0,  0.5,  0.0},   -- Fuselagem central
        [2] = {-1.0, 0.2,  3.5},   -- Asa interna direita
        [3] = {-1.0, 0.2, -3.5},   -- Asa interna esquerda
        [4] = {-2.5, 0.1,  9.0},   -- Asa média direita
        [5] = {-2.5, 0.1, -9.0},   -- Asa média esquerda
        [6] = {-4.5, 0.0, 16.0},   -- Ponta de asa direita
        [7] = {-4.5, 0.0,-16.0},   -- Ponta de asa esquerda
        [8] = {-4.8, 0.45, 2.1},   -- Motor direito
        [9] = {-4.8, 0.45,-2.1},   -- Motor esquerdo
    },

    passivCounterm = {
        CMDS_Edit         = true,
        SingleChargeTotal = 120,
        chaff = {default = 60, increment = 30, chargeSz = 1},
        flare = {default = 60, increment = 30, chargeSz = 1},
    },

    chaff_flare_dispenser = {
        [1] = { dir = {0, -1, 0}, pos = {-3.5, -0.5, -1.8} },
        [2] = { dir = {0, -1, 0}, pos = {-3.5, -0.5,  1.8} },
    },

    detection_range_max   = 250,
    radar_can_see_ground  = true,
    CanopyGeometry = {
        azimuth   = {-130.0, 130.0},
        elevation = {-35.0, 75.0}
    },

    Sensors = {
        RWR = "Abstract RWR"
    },
    Countermeasures = {
        ECM = "AN/ALQ-126"
    },

    HumanRadio = {
        frequency    = 254.0,
        editable     = true,
        minFrequency = 225.000,
        maxFrequency = 399.900,
        modulation   = MODULATION_AM
    },

    panelRadio = {
        [1] = {
            name = _("UHF/VHF Radio"),
            range = {{min = 225.0, max = 399.9}},
            channels = {
                [1] = { name = _("Channel 1"), default = 254.0, modulation = _("AM"), connect = true},
                [2] = { name = _("Channel 2"), default = 264.0, modulation = _("AM")},
                [3] = { name = _("Channel 3"), default = 265.0, modulation = _("AM")},
                [4] = { name = _("Channel 4"), default = 256.0, modulation = _("AM")},
            }
        },
    },

    LandRWCategories    = {},
    TakeOffRWCategories = {},
    WorldID             = WSTYPE_PLACEHOLDER,

    ---------------------------------------------------------------------------
    -- BAIAS INTERNAS DE ARMAMENTO (Args 500 e 501)
    ---------------------------------------------------------------------------
    Pylons = {
        pylon(1, 2, 0.20, -0.55, -1.35, -- Baia Esquerda (Arg 500)
            {
                use_full_connector_position = false,
                arg       = 500,
                arg_value = 0,
            },
            get_bay_weapons(500)
        ),
        pylon(2, 2, 0.20, -0.55, 1.35,  -- Baia Direita (Arg 501)
            {
                use_full_connector_position = false,
                arg       = 501,
                arg_value = 0,
            },
            get_bay_weapons(501)
        ),
    },

    Tasks = {
        aircraft_task(GroundAttack),
        aircraft_task(PinpointStrike),
        aircraft_task(RunwayAttack),
        aircraft_task(SEAD),
        aircraft_task(Reconnaissance),
        aircraft_task(Refueling),
    },
    DefaultTask = aircraft_task(GroundAttack),

    ---------------------------------------------------------------------------
    -- SFM_Data (Necessário como fallback para IA e carregamento pelo DCS)
    ---------------------------------------------------------------------------
    SFM_Data = {
        aerodynamics =
        {
            Cy0         = 0.05,
            Mzalfa      = 4.5,
            Mzalfadt    = 0.8,
            kjx         = 2.85,
            kjz         = 0.00125,
            Czbe        = -0.014,
            cx_gear     = 0.035,
            cx_flap     = 0.02,
            cy_flap     = 0.10,
            cx_brk      = 0.09,
            table_data = {
            --   M       Cx0      Cya     B       B4      Omxmax  Aldop   Cymax
                {0.00,   0.012,   0.075,  0.055,  0.00,   0.8,    16.0,   1.25},
                {0.30,   0.012,   0.075,  0.055,  0.00,   1.5,    16.0,   1.20},
                {0.60,   0.013,   0.078,  0.058,  0.00,   2.2,    14.5,   1.10},
                {0.80,   0.015,   0.082,  0.065,  0.00,   2.4,    12.0,   0.95},
                {0.88,   0.024,   0.080,  0.110,  0.00,   2.0,    10.0,   0.85},
                {0.95,   0.042,   0.070,  0.220,  0.00,   1.5,     8.0,   0.75},
            }
        },
        engine =
        {
            Nmg     = 55.0,
            MinRUD  = 0,
            MaxRUD  = 1,
            MaksRUD = 1,
            ForsRUD = 1,
            typeng  = 4, -- E_TURBOFAN
            hMaxEng = 16,
            dcx_eng = 0.0085,
            cemax   = 0.030,
            cefor   = 0.030,
            dpdh_m  = 4500,
            dpdh_f  = 4500,
            table_data =
            {
            --   M      Pmax (kN)   Pfor (kN)
                {0.0,   200.0,      200.0},
                {0.5,   178.0,      178.0},
                {0.8,   166.0,      166.0},
                {1.0,   145.0,      145.0},
            },
        },
    },

    ---------------------------------------------------------------------------
    -- SISTEMA DE DANO (Asa voadora)
    ---------------------------------------------------------------------------
    Damage = {},

    DamageParts = {},

    lights_data = {
        typename = "collection",
        lights = {
            [1] = {}, -- Strobes
            [2] = {}, -- Taxi/Landing
            [3] = {}, -- Nav
            [4] = {}, -- Formation
            [5] = {}, -- Tips
            [6] = {}, -- Refuel
            [7] = {}, -- Anti-collision
        },
    },
}

add_aircraft(B_21)