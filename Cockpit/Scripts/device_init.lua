dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.common_script_path.."tools.lua")

layoutGeometry = {}
MainPanel = {"ccMainPanel", LockOn_Options.script_path.."mainpanel_init.lua", {}}

creators = {}
-- Nenhum dispositivo por enquanto: o EFM (B21_EFM.dll) simula motores, trem, baia, luzes etc.

indicators = {}