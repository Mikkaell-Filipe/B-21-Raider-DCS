print("B21_COCKPIT: mainpanel_init.lua EXECUTADO")
-- =============================================================================
--  Cockpit\Scripts\mainpanel_init.lua - B-21 Raider  (refatorado v3)
--  Modelo 3D do cockpit: Cockpit\Shapes\Cockpit_B-21.edm
--  O nome em shape_name e o do arquivo SEM .edm, com a mesma capitalizacao.
-- =============================================================================

dofile(LockOn_Options.script_path .. "command_defs.lua")
dofile(LockOn_Options.script_path .. "devices.lua")

shape_name       = "Cockpit_B-21"
is_EDM           = true
new_model_format = true

-- Iluminacao (mesmos valores do RV-7A e do A-29B)
ambient_light                = {255, 255, 255}
ambient_color_day_texture    = {72, 100, 160}
ambient_color_night_texture  = {40, 60, 150}
ambient_color_from_devices   = {50, 50, 40}     -- tabela, nao false
ambient_color_from_panels    = {35, 25, 25}     -- tabela, nao false
dusk_border             = 0.4
day_texture_set_value   = 0.0
night_texture_set_value = 0.1

-- Piloto e vistas
draw_pilot         = false
use_external_views = false

-- Arg da capota do externo que o cockpit acompanha (igual ao A-29B)
external_model_canopy_arg = 38

-- Planos de recorte (distancia do olho em metros)
need_to_be_closed = true
Z_test = { near = 0.05, far = 4.0 }

-- Removidos (restos do A-4E-C, o B-21 nao usa):
--   attributes = {"support_for_cws"}
--   mainpanel_pages / page_subsets / init_pageID
-- Se o B-21 tiver um sistema de alerta (CWS) ou paginas de display, recoloque.
print("B21_COCKPIT: shape_name = " .. tostring(shape_name))
