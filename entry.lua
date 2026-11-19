-- =============================================================================
--  entry.lua - B-21 Raider  (refatorado v3)
--
--  ORDEM IMPORTANTE (igual ao RV-7A e ao A-29B, que funcionam):
--    1) declare_plugin
--    2) mounts (texturas, modelos, liveries, sons)
--    3) B-21.lua            -> define o aviao (add_aircraft)
--    4) Views.lua + make_view_settings
--    5) make_flyable        -> precisa do aviao ja definido; registra Cockpit\Scripts\
--    6) plugin_done
--
--  Se o make_flyable roda ANTES do B-21.lua, o DCS nao registra o cockpit e nao
--  escreve erro nenhum no log (so o externo aparece).
--
--  Pastas:
--    Shapes\B-21.edm            externo
--    Cockpit\Shapes\Cockpit_B-21.edm   cockpit (shape_name em mainpanel_init.lua)
--    Cockpit\Scripts\           command_defs, devices, device_init, mainpanel_init
--    bin\B21_EFM.dll            modelo de voo externo
-- =============================================================================

local self_ID    = "B-21"                 -- igual ao Name em B-21.lua
local AFMenabled = true
local MOD        = current_mod_path

local bin = {}
if AFMenabled then
    bin = { 'B21_EFM' }                   -- nome da DLL em /bin (sem .dll)
end

declare_plugin(self_ID,
{
    installed         = true,
    dirName           = MOD,
    displayName       = _("B-21 Raider"),
    fileMenuName      = _("B-21"),
    update_id         = "B-21",
    version           = "0.2.0",
    state             = "installed",
    info              = _("Northrop Grumman B-21 Raider\n\nBombardeiro estratégico furtivo de longo alcance (asa voadora) com Modelo de Voo Externo (EFM)."),
    encyclopedia_path = MOD .. '/Encyclopedia',
    binaries          = bin,

    Skins         = { { name = _("B-21 Raider"), dir = "Skins/1" }, },
    Missions      = { { name = _("B-21 Raider"), dir = "Missions" }, },
    LogBook       = { { name = _("B-21 Raider"), type = "B-21" }, },
    InputProfiles = { ["B-21"] = MOD .. '/Input/B-21', },
})

-- 2) Caminhos VFS ------------------------------------------------------------
mount_vfs_texture_path  (MOD .. "/Skins/1/ME")          -- telas do ME
mount_vfs_model_path    (MOD .. "/Shapes")              -- externo
mount_vfs_model_path    (MOD .. "/Cockpit/Shapes")      -- cockpit (sem isso o cockpit nao e achado)
mount_vfs_liveries_path (MOD .. "/Liveries")
mount_vfs_texture_path  (MOD .. "/Textures")
mount_vfs_texture_path  (MOD .. "/Cockpit/Textures")
mount_vfs_sound_path    (MOD .. "/Sounds")

-- 3) Views ANTES do B-21.lua (o B-21.lua usa "ViewSettings = ViewSettings") ----
dofile(MOD .. '/Views.lua')

-- 4) Define o aviao (ANTES do make_flyable) ----------------------------------
dofile(MOD .. '/B-21.lua')
make_view_settings('B-21', ViewSettings, SnapViews)

-- 5) Modelo de voo + cockpit -------------------------------------------------
local cockpit_scripts = MOD .. '/Cockpit/Scripts/'    -- barra final obrigatoria
local comm_path       = MOD .. '/comm.lua'

if AFMenabled then
    dofile(MOD .. '/Entry/Suspension.lua')            -- define a global "suspension"

    local FM =
    {
        [1] = self_ID,
        [2] = 'B21_EFM',                              -- mesmo nome da DLL em bin
        center_of_mass    = {0.0, 0.0, 0.0},          -- relativo a origem do B-21.edm
        moment_of_inertia = {3.2e6, 4.1e6, 1.1e6, 0.0}, -- Ix, Iy, Iz, Ixy
        suspension        = suspension,
    }
    make_flyable(self_ID, cockpit_scripts, FM, comm_path)
else
    make_flyable(self_ID, cockpit_scripts, nil, comm_path)
end

-- 6) Fim ---------------------------------------------------------------------
plugin_done()