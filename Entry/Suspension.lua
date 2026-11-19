-- Entry/Suspension.lua - B-21 Raider
-- Coordenadas do trem (Frame 200, trem baixado) convertidas para eixos DCS (X=frente, Y=cima, Z=direita).
-- Dados do modelo: nariz roda Ø1.1383 m | principal Ø1.4907 m.
-- ORDEM: [1] nariz, [2] principal ESQUERDO, [3] principal DIREITO
-- (precisa bater com ED_FM_SUSPENSION_0/1/2 usados no B21_EFM.cpp)

local B21_REF_MASS = 55000.0
local GRAVITY      = 9.81

-- NARIZ
local nose_damper_force = 6.5e+04
-- PRINCIPAL
local main_damper_force = 2.2e+05

local wheel_static_friction_factor_COMMON = 0.90
local wheel_side_friction_factor_COMMON   = 0.55
local wheel_roll_friction_factor_COMMON   = 0.025
local wheel_glide_friction_factor_COMMON  = 0.25
local wheel_static_friction_factor_NOSE   = 0.75
local wheel_side_friction_factor_NOSE     = 0.50
local wheel_roll_friction_factor_NOSE     = 0.030
local wheel_glide_friction_factor_NOSE    = 0.35

local function main_gear(pos, damage_element, arg_post, arg_amort, arg_rot, shell)
    return {
        anti_skid_installed                  = true,
        mass                                 = 450.0,
        pos                                  = pos,
        damage_element                       = damage_element,
        moment_of_inertia                    = { 180.0, 30.0, 180.0 },
        wheel_axle_offset                    = 0.0,
        yaw_limit                            = 0.0,
        self_attitude                        = false,

        amortizer_min_length                 = 0.00,
        amortizer_max_length                 = 0.35,
        amortizer_basic_length               = 0.35,
        amortizer_reduce_length              = 0.08,
        amortizer_spring_force_factor        = 2.2e+07,
        amortizer_spring_force_factor_rate   = 2.5,
        amortizer_static_force               = B21_REF_MASS * GRAVITY * 0.45,
        amortizer_direct_damper_force_factor = main_damper_force * 0.75,
        amortizer_back_damper_force_factor   = main_damper_force,

        wheel_radius                         = 0.7454, -- Ø1.4907 m
        wheel_static_friction_factor         = wheel_static_friction_factor_COMMON,
        wheel_side_friction_factor           = wheel_side_friction_factor_COMMON,
        wheel_roll_friction_factor           = wheel_roll_friction_factor_COMMON,
        wheel_glide_friction_factor          = wheel_glide_friction_factor_COMMON,
        wheel_damage_force_factor            = 450.0,
        wheel_damage_speed                   = 110.0,
        wheel_brake_moment_max               = 62000.0,
        wheel_moment_of_inertia              = 33.3, -- 0.5*m*r^2 (m~120 kg)
        wheel_kz_factor                      = 0.52,
        noise_k                              = 0.40,
        damper_coeff                         = 150.0,

        arg_post                             = arg_post,
        arg_amortizer                        = arg_amort,
        arg_wheel_rotation                   = arg_rot,
        arg_wheel_yaw                        = -1,
        collision_shell_name                 = shell,
    }
end

suspension =
{
    -- [1] NARIZ (WHEEL_NOSE_BLURRED_KEY_1)
    {
        anti_skid_installed                  = true,
        mass                                 = 180.0,
        pos                                  = { 5.3098, -1.7832, 0.0 },
        damage_element                       = 83, -- WHEEL_F
        moment_of_inertia                    = { 25.0, 5.0, 25.0 },
        wheel_axle_offset                    = 0.0,
        self_attitude                        = false,   -- esterçamento comandado pelo EFM (NWS)
        yaw_limit                            = math.rad(45.0),

        amortizer_min_length                 = 0.00,
        amortizer_max_length                 = 0.25,
        amortizer_basic_length               = 0.25,
        amortizer_reduce_length              = 0.05,
        amortizer_spring_force_factor        = 6.0e+06,
        amortizer_spring_force_factor_rate   = 2.0,
        amortizer_static_force               = B21_REF_MASS * GRAVITY * 0.16,
        amortizer_direct_damper_force_factor = nose_damper_force * 0.75,
        amortizer_back_damper_force_factor   = nose_damper_force,

        wheel_radius                         = 0.5692, -- Ø1.1383 m
        wheel_static_friction_factor         = wheel_static_friction_factor_NOSE,
        wheel_side_friction_factor           = wheel_side_friction_factor_NOSE,
        wheel_roll_friction_factor           = wheel_roll_friction_factor_NOSE,
        wheel_glide_friction_factor          = wheel_glide_friction_factor_NOSE,
        wheel_damage_force_factor            = 450.0,
        wheel_damage_speed                   = 110.0,
        wheel_brake_moment_max               = 0.0,
        wheel_moment_of_inertia              = 5.7,
        wheel_kz_factor                      = 0.30,
        noise_k                              = 0.40,
        damper_coeff                         = 150.0,

        arg_post                             = 0,
        arg_amortizer                        = 1,
        arg_wheel_rotation                   = 76,
        arg_wheel_yaw                        = 2,
        collision_shell_name                 = "WHEEL_F",
    },
    -- [2] PRINCIPAL ESQUERDO (LEFT_WHEEL)  raw(3.7405, -1.8689, 1.6836) -> DCS(-1.6836, -1.8689, -3.7405)
    main_gear({ -1.6836, -1.8689, -3.7405 }, 84, 5, 6, 77, "WHEEL_L"),
    -- [3] PRINCIPAL DIREITO (RIGHT_WHEEL)  raw(-3.7359, -1.8231, 1.6915) -> DCS(-1.6915, -1.8231, 3.7359)
    main_gear({ -1.6915, -1.8231, 3.7359 }, 85, 3, 4, 78, "WHEEL_R"),
}
