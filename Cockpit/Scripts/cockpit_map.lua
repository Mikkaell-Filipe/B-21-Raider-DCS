-- Cockpit\Scripts\cockpit_map.lua  (GERADO a partir da tabela do interno.blend)
-- arg   = numero do argumento no Cockpit_B-21.edm (tambem o nome do conector PNT_<arg> e o ID do comando)
-- kind  = btn (botao, sem curso) | tumb2 (2 posicoes) | multi (n posicoes) | axis (rotativo continuo)
-- n     = numero de posicoes (frames do .blend, sem os negativos) ; arg anda de 0 a 1 em passos de 1/(n-1)
-- Para mudar um nome ou o tipo de um botao, edite so a linha dele.
B21_COCKPIT_MAP = {
    {arg=500, kind="tumb2", n=2, hint="AS3X Joystick Down/Up"},  -- AS3X_Joystick_DN_UP_1 frames 0..1
    {arg=501, kind="axis", n=29, hint="AS3X Joystick Knob"},  -- AS3X_Joystick_Knob_1 frames 0..28
    {arg=502, kind="tumb2", n=2, hint="AS3X Joystick Left/Right"},  -- AS3X_Joystick_L_R_1 frames 0..1
    {arg=503, kind="btn", n=1, hint="AS3X Joystick Push"},  -- AS3X_Joystick_Push_1 frames 0..2
    {arg=504, kind="btn", n=1, hint="AS3X Clear"},  -- AS3X_Push_Clear frames 0..0
    {arg=505, kind="btn", n=1, hint="AS3X Direct To"},  -- AS3X_Push_Direct To frames 0..0
    {arg=506, kind="btn", n=1, hint="AS3X Enter"},  -- AS3X_Push_Enter frames 0..0
    {arg=507, kind="btn", n=1, hint="AS3X Flight Plan"},  -- AS3X_Push_Flight Plan frames 0..0
    {arg=508, kind="btn", n=1, hint="AS3X Menu"},  -- AS3X_Push_Menu frames 0..0
    {arg=509, kind="btn", n=1, hint="AS3X Nearest"},  -- AS3X_Push_Nearest frames 0..0
    {arg=510, kind="btn", n=1, hint="AS3X Range"},  -- AS3X_Push_Range frames 0..0
    {arg=511, kind="btn", n=1, hint="AS3X Softkey 1"},  -- AS3X_Push_Softkey_1 frames 0..0
    {arg=512, kind="btn", n=1, hint="AS3X Softkey 2"},  -- AS3X_Push_Softkey_2 frames 0..0
    {arg=513, kind="btn", n=1, hint="AS3X Softkey 3"},  -- AS3X_Push_Softkey_3 frames 0..0
    {arg=514, kind="btn", n=1, hint="AS3X Softkey 4"},  -- AS3X_Push_Softkey_4 frames 0..0
    {arg=515, kind="btn", n=1, hint="AS3X Softkey 5"},  -- AS3X_Push_Softkey_5 frames 0..0
    {arg=516, kind="multi", n=3, hint="Crew Door"},  -- B21DOOR_ANIM frames 0..2
    {arg=517, kind="tumb2", n=2, hint="Weapon Bay LEFT (Open/Close)"},  -- BAY_ANIMLBD frames 0..2
    {arg=518, kind="tumb2", n=2, hint="Weapon Bay RIGHT (Open/Close)"},  -- BAY_ANIMRBD frames 0..2
    {arg=519, kind="btn", n=1, hint="Copilot Trigger"},  -- COPILOT_TRIGGER frames 1..2
    {arg=520, kind="multi", n=3, hint="Cover 1"},  -- COVER1_ANIM frames 0..2
    {arg=521, kind="multi", n=3, hint="Cover 2"},  -- COVER2_ANIM frames 0..2
    {arg=522, kind="multi", n=3, hint="Cover"},  -- COVER_ANIM frames 0..2
    {arg=523, kind="btn", n=1, hint="DDI 1 Push 10"},  -- DDI_Push_10_MFD_1 frames 0..0
    {arg=524, kind="btn", n=1, hint="DDI 2 Push 10"},  -- DDI_Push_10_MFD_2 frames 0..0
    {arg=525, kind="btn", n=1, hint="DDI 3 Push 10"},  -- DDI_Push_10_MFD_3 frames 0..0
    {arg=526, kind="btn", n=1, hint="DDI 1 Push 11"},  -- DDI_Push_11_MFD_1 frames 0..0
    {arg=527, kind="btn", n=1, hint="DDI 2 Push 11"},  -- DDI_Push_11_MFD_2 frames 0..0
    {arg=528, kind="btn", n=1, hint="DDI 3 Push 11"},  -- DDI_Push_11_MFD_3 frames 0..0
    {arg=529, kind="btn", n=1, hint="DDI 1 Push 12"},  -- DDI_Push_12_MFD_1 frames 0..0
    {arg=530, kind="btn", n=1, hint="DDI 2 Push 12"},  -- DDI_Push_12_MFD_2 frames 0..0
    {arg=531, kind="btn", n=1, hint="DDI 3 Push 12"},  -- DDI_Push_12_MFD_3 frames 0..0
    {arg=532, kind="btn", n=1, hint="DDI 1 Push 13"},  -- DDI_Push_13_MFD_1 frames 0..0
    {arg=533, kind="btn", n=1, hint="DDI 2 Push 13"},  -- DDI_Push_13_MFD_2 frames 0..0
    {arg=534, kind="btn", n=1, hint="DDI 3 Push 13"},  -- DDI_Push_13_MFD_3 frames 0..0
    {arg=535, kind="btn", n=1, hint="DDI 1 Push 14"},  -- DDI_Push_14_MFD_1 frames 0..0
    {arg=536, kind="btn", n=1, hint="DDI 2 Push 14"},  -- DDI_Push_14_MFD_2 frames 0..0
    {arg=537, kind="btn", n=1, hint="DDI 3 Push 14"},  -- DDI_Push_14_MFD_3 frames 0..0
    {arg=538, kind="btn", n=1, hint="DDI 1 Push 15"},  -- DDI_Push_15_MFD_1 frames 0..0
    {arg=539, kind="btn", n=1, hint="DDI 2 Push 15"},  -- DDI_Push_15_MFD_2 frames 0..0
    {arg=540, kind="btn", n=1, hint="DDI 3 Push 15"},  -- DDI_Push_15_MFD_3 frames 0..0
    {arg=541, kind="btn", n=1, hint="DDI 1 Push 16"},  -- DDI_Push_16_MFD_1 frames 0..0
    {arg=542, kind="btn", n=1, hint="DDI 2 Push 16"},  -- DDI_Push_16_MFD_2 frames 0..0
    {arg=543, kind="btn", n=1, hint="DDI 3 Push 16"},  -- DDI_Push_16_MFD_3 frames 0..0
    {arg=544, kind="btn", n=1, hint="DDI 1 Push 17"},  -- DDI_Push_17_MFD_1 frames 0..0
    {arg=545, kind="btn", n=1, hint="DDI 2 Push 17"},  -- DDI_Push_17_MFD_2 frames 0..0
    {arg=546, kind="btn", n=1, hint="DDI 3 Push 17"},  -- DDI_Push_17_MFD_3 frames 0..0
    {arg=547, kind="btn", n=1, hint="DDI 1 Push 18"},  -- DDI_Push_18_MFD_1 frames 0..0
    {arg=548, kind="btn", n=1, hint="DDI 2 Push 18"},  -- DDI_Push_18_MFD_2 frames 0..0
    {arg=549, kind="btn", n=1, hint="DDI 3 Push 18"},  -- DDI_Push_18_MFD_3 frames 0..0
    {arg=550, kind="btn", n=1, hint="DDI 1 Push 19"},  -- DDI_Push_19_MFD_1 frames 0..0
    {arg=551, kind="btn", n=1, hint="DDI 2 Push 19"},  -- DDI_Push_19_MFD_2 frames 0..0
    {arg=552, kind="btn", n=1, hint="DDI 3 Push 19"},  -- DDI_Push_19_MFD_3 frames 0..0
    {arg=553, kind="btn", n=1, hint="DDI 1 Push 1"},  -- DDI_Push_1_MFD_1 frames 0..0
    {arg=554, kind="btn", n=1, hint="DDI 2 Push 1"},  -- DDI_Push_1_MFD_2 frames 0..0
    {arg=555, kind="btn", n=1, hint="DDI 3 Push 1"},  -- DDI_Push_1_MFD_3 frames 0..0
    {arg=556, kind="btn", n=1, hint="DDI 1 Push 20"},  -- DDI_Push_20_MFD_1 frames 0..0
    {arg=557, kind="btn", n=1, hint="DDI 2 Push 20"},  -- DDI_Push_20_MFD_2 frames 0..0
    {arg=558, kind="btn", n=1, hint="DDI 3 Push 20"},  -- DDI_Push_20_MFD_3 frames 0..0
    {arg=559, kind="btn", n=1, hint="DDI 2 Push 2"},  -- DDI_Push_2_MFD_2 frames 0..0
    {arg=560, kind="btn", n=1, hint="DDI 3 Push 2"},  -- DDI_Push_2_MFD_3 frames 0..0
    {arg=561, kind="btn", n=1, hint="DDI 1 Push 3"},  -- DDI_Push_3_MFD_1 frames 0..0
    {arg=562, kind="btn", n=1, hint="DDI 2 Push 3"},  -- DDI_Push_3_MFD_2 frames 0..0
    {arg=563, kind="btn", n=1, hint="DDI 3 Push 3"},  -- DDI_Push_3_MFD_3 frames 0..0
    {arg=564, kind="btn", n=1, hint="DDI 1 Push 4"},  -- DDI_Push_4_MFD_1 frames 0..0
    {arg=565, kind="btn", n=1, hint="DDI 2 Push 4"},  -- DDI_Push_4_MFD_2 frames 0..0
    {arg=566, kind="btn", n=1, hint="DDI 3 Push 4"},  -- DDI_Push_4_MFD_3 frames 0..0
    {arg=567, kind="btn", n=1, hint="DDI 1 Push 5"},  -- DDI_Push_5_MFD_1 frames 0..0
    {arg=568, kind="btn", n=1, hint="DDI 2 Push 5"},  -- DDI_Push_5_MFD_2 frames 0..0
    {arg=569, kind="btn", n=1, hint="DDI 3 Push 5"},  -- DDI_Push_5_MFD_3 frames 0..0
    {arg=570, kind="btn", n=1, hint="DDI 1 Push 6"},  -- DDI_Push_6_MFD_1 frames 0..0
    {arg=571, kind="btn", n=1, hint="DDI 2 Push 6"},  -- DDI_Push_6_MFD_2 frames 0..0
    {arg=572, kind="btn", n=1, hint="DDI 3 Push 6"},  -- DDI_Push_6_MFD_3 frames 0..0
    {arg=573, kind="btn", n=1, hint="DDI 1 Push 7"},  -- DDI_Push_7_MFD_1 frames 0..0
    {arg=574, kind="btn", n=1, hint="DDI 2 Push 7"},  -- DDI_Push_7_MFD_2 frames 0..0
    {arg=575, kind="btn", n=1, hint="DDI 3 Push 7"},  -- DDI_Push_7_MFD_3 frames 0..0
    {arg=576, kind="btn", n=1, hint="DDI 1 Push 8"},  -- DDI_Push_8_MFD_1 frames 0..0
    {arg=577, kind="btn", n=1, hint="DDI 2 Push 8"},  -- DDI_Push_8_MFD_2 frames 0..0
    {arg=578, kind="btn", n=1, hint="DDI 3 Push 8"},  -- DDI_Push_8_MFD_3 frames 0..0
    {arg=579, kind="btn", n=1, hint="DDI 1 Push 9"},  -- DDI_Push_9_MFD_1 frames 0..0
    {arg=580, kind="btn", n=1, hint="DDI 2 Push 9"},  -- DDI_Push_9_MFD_2 frames 0..0
    {arg=581, kind="btn", n=1, hint="DDI 3 Push 9"},  -- DDI_Push_9_MFD_3 frames 0..0
    {arg=582, kind="multi", n=5, hint="EFD Brightness"},  -- EFD_Knob_BRT frames 0..4
    {arg=583, kind="axis", n=35, hint="EFD Bingo Fuel"},  -- EFD_Knob_Bingo frames 0..34
    {arg=584, kind="btn", n=1, hint="EFD Bingo Push"},  -- EFD_Knob_Bingo_Push frames 0..1
    {arg=585, kind="btn", n=1, hint="EFD Mode (Push)"},  -- EFD_Push_Mode frames 0..2
    {arg=586, kind="tumb2", n=2, hint="EFD CRS"},  -- EFD_Switch_CRS frames 0..1
    {arg=587, kind="tumb2", n=2, hint="EFD HDG/TK"},  -- EFD_Switch_HDG_TK frames 0..1
    {arg=588, kind="btn", n=1, hint="EFD HUD"},  -- EFD_Switch_HUD frames 0..0
    {arg=589, kind="tumb2", n=2, hint="EFD REC"},  -- EFD_Switch_Rec frames 0..1
    {arg=590, kind="tumb2", n=2, hint="EFD VID"},  -- EFD_Switch_Vid frames 0..1
    {arg=591, kind="tumb2", n=2, hint="Avionics Bus (On/Off)"},  -- ELECTRICAL_Switch_Avionics_Bus_1 frames 1..2
    {arg=594, kind="axis", n=101, hint="GBU-39 Handle"},  -- GBU39_ANIM frames 0..100
    {arg=595, kind="multi", n=7, hint="Rudder Trim Knob"},  -- HANDLING_Knob_RudderTrim frames 1..7
    {arg=596, kind="btn", n=1, hint="Rudder Trim Push"},  -- HANDLING_Push_RudderTrim frames 0..2
    {arg=602, kind="tumb2", n=2, hint="HUD Panel AOA"},  -- Knob_AOA_HudPanel frames 0..1
    {arg=603, kind="tumb2", n=2, hint="HUD Panel BFL"},  -- Knob_BFL_HudPanel frames 0..1
    {arg=604, kind="multi", n=4, hint="HUD Panel Black Level"},  -- Knob_BLK_LVL_HudPanel frames 0..3
    {arg=605, kind="multi", n=4, hint="Bottom Comp Brightness"},  -- Knob_BRT_BotComp frames 0..3
    {arg=606, kind="multi", n=5, hint="Top Comp Brightness"},  -- Knob_BRT_TopComp frames -1..4
    {arg=607, kind="multi", n=3, hint="Camera 1"},  -- Knob_CAMERA_1 frames 0..2
    {arg=608, kind="multi", n=3, hint="Chart Light (Right Panel)"},  -- Knob_CHART_RightPanel frames 0..2
    {arg=609, kind="multi", n=5, hint="COMM 1 (Top Comp)"},  -- Knob_COMM1_TopComp frames -1..4
    {arg=610, kind="btn", n=1, hint="COMM 1 Push (Top Comp)"},  -- Knob_COMM1_TopComp_Push frames 0..0
    {arg=611, kind="multi", n=5, hint="COMM 2 (Top Comp)"},  -- Knob_COMM2_TopComp frames -1..4
    {arg=612, kind="btn", n=1, hint="COMM 2 Push (Top Comp)"},  -- Knob_COMM2_TopComp_Push frames 0..0
    {arg=613, kind="multi", n=4, hint="Bottom Comp Contrast"},  -- Knob_CONT_BotComp frames 0..3
    {arg=614, kind="multi", n=5, hint="Top Comp Contrast"},  -- Knob_CONT_TopComp frames -1..4
    {arg=615, kind="multi", n=3, hint="Display Brightness LEFT"},  -- Knob_DISPLAY_BRIGHT_L frames 0..2
    {arg=616, kind="multi", n=3, hint="Display Brightness RIGHT"},  -- Knob_DISPLAY_BRIGHT_R frames 0..2
    {arg=617, kind="tumb2", n=2, hint="Flood Light (Right Panel)"},  -- Knob_FLOOD_RightPanel frames 1..2
    {arg=618, kind="multi", n=5, hint="Formation Lights (Left Panel)"},  -- Knob_FORM_LeftPanel frames 1..5
    {arg=619, kind="multi", n=5, hint="Instrument Panel Light (Right Panel)"},  -- Knob_INSTPNL_RightPanel frames 1..5
    {arg=620, kind="axis", n=14, hint="Night/Day RIGHT Comp"},  -- Knob_NIGHT-DAY_RightComp frames 0..13
    {arg=621, kind="axis", n=14, hint="Night/Day LEFT Comp"},  -- Knob_NIGHT_DAY_LeftComp frames 0..13
    {arg=622, kind="multi", n=5, hint="Position Lights (Left Panel)"},  -- Knob_POS_LeftPanel frames 1..5
    {arg=623, kind="multi", n=3, hint="Range 1"},  -- Knob_RANGE1 frames 0..2
    {arg=624, kind="btn", n=1, hint="HUD Panel REJ 1"},  -- Knob_REJ1_HudPanel frames 0..0
    {arg=625, kind="multi", n=5, hint="Symbology (Top Comp)"},  -- Knob_SYM_TopComp frames -1..4
    {arg=626, kind="multi", n=5, hint="Volume 2 (Top Comp)"},  -- Knob_VOL2_TopComp frames -1..4
    {arg=627, kind="multi", n=5, hint="Volume (Top Comp)"},  -- Knob_VOL_TopComp frames -1..4
    {arg=628, kind="tumb2", n=2, hint="Landing Gear (Up/Down)"},  -- LANDING_GEAR_Lever_Gear frames 1..2
    {arg=629, kind="tumb2", n=2, hint="Parking Brake (On/Off)"},  -- LANDING_GEAR_Switch_ParkingBrake frames 1..2
    {arg=630, kind="btn", n=1, hint="Pilot Trigger"},  -- PILOT_TRIGGER frames 1..2
    {arg=631, kind="btn", n=1, hint="Push 008"},  -- Push_008 frames 0..0
    {arg=632, kind="btn", n=1, hint="Push 009"},  -- Push_009 frames 0..0
    {arg=633, kind="btn", n=1, hint="Push 010"},  -- Push_010 frames 0..0
    {arg=634, kind="btn", n=1, hint="Push 011"},  -- Push_011 frames 0..0
    {arg=635, kind="btn", n=1, hint="Push 012"},  -- Push_012 frames 0..0
    {arg=636, kind="btn", n=1, hint="Push 030"},  -- Push_030 frames 0..0
    {arg=637, kind="btn", n=1, hint="Push 031"},  -- Push_031 frames 0..0
    {arg=638, kind="btn", n=1, hint="Push 032"},  -- Push_032 frames 0..0
    {arg=639, kind="btn", n=1, hint="Push 033"},  -- Push_033 frames 0..0
    {arg=640, kind="btn", n=1, hint="Push 034"},  -- Push_034 frames 0..0
    {arg=641, kind="btn", n=1, hint="Push 035"},  -- Push_035 frames 0..0
    {arg=642, kind="btn", n=1, hint="Push 037"},  -- Push_037 frames 0..0
    {arg=643, kind="btn", n=1, hint="Push 038"},  -- Push_038 frames 0..0
    {arg=644, kind="btn", n=1, hint="Push 039"},  -- Push_039 frames 0..0
    {arg=645, kind="btn", n=1, hint="Push 040"},  -- Push_040 frames 0..0
    {arg=646, kind="btn", n=1, hint="Push 041"},  -- Push_041 frames 0..0
    {arg=647, kind="btn", n=1, hint="Push 042"},  -- Push_042 frames 0..0
    {arg=648, kind="btn", n=1, hint="Push 043"},  -- Push_043 frames 0..0
    {arg=649, kind="btn", n=1, hint="Push 049"},  -- Push_049 frames 0..0
    {arg=650, kind="btn", n=1, hint="Push 050"},  -- Push_050 frames 0..0
    {arg=651, kind="btn", n=1, hint="Push 053"},  -- Push_053 frames 0..0
    {arg=652, kind="btn", n=1, hint="Push 054"},  -- Push_054 frames 0..0
    {arg=653, kind="btn", n=1, hint="Push 055"},  -- Push_055 frames 0..0
    {arg=654, kind="btn", n=1, hint="Push 057"},  -- Push_057 frames 0..0
    {arg=655, kind="btn", n=1, hint="Push 058"},  -- Push_058 frames 0..0
    {arg=656, kind="btn", n=1, hint="Push 059"},  -- Push_059 frames 0..0
    {arg=657, kind="btn", n=1, hint="Push 060"},  -- Push_060 frames 0..0
    {arg=658, kind="btn", n=1, hint="Yoke Push 1"},  -- Push_1_Yoke frames 0..3
    {arg=659, kind="btn", n=1, hint="AFT"},  -- Push_AFT frames 0..0
    {arg=660, kind="btn", n=1, hint="Airport"},  -- Push_ARPT_1 frames 0..0
    {arg=661, kind="btn", n=1, hint="Auto Throttle (Push)"},  -- Push_AutoThrottle frames 0..2
    {arg=662, kind="btn", n=1, hint="Camera Vision"},  -- Push_CAM_VISION_1 frames 0..0
    {arg=663, kind="btn", n=1, hint="Caution/Warning"},  -- Push_CAUTION_WARNING frames 0..0
    {arg=664, kind="btn", n=1, hint="Fire Warning"},  -- Push_FIRE_WARNING frames 0..0
    {arg=665, kind="btn", n=1, hint="FM CON (Top Comp)"},  -- Push_FM_CON_TopComp frames 0..0
    {arg=666, kind="btn", n=1, hint="FWD"},  -- Push_FWD frames 0..0
    {arg=667, kind="btn", n=1, hint="ID (Top Comp)"},  -- Push_ID_TopComp frames 0..0
    {arg=668, kind="btn", n=1, hint="LDG"},  -- Push_LDG frames 0..0
    {arg=669, kind="btn", n=1, hint="Master Avionics"},  -- Push_MSTR_AVIONICS frames 0..0
    {arg=670, kind="btn", n=1, hint="Master Battery"},  -- Push_MSTR_BATTERY frames 0..0
    {arg=671, kind="btn", n=1, hint="Master Generator"},  -- Push_MSTR_GENERATOR frames 0..0
    {arg=672, kind="btn", n=1, hint="Master Warning"},  -- Push_MSTR_WARNING frames 0..0
    {arg=673, kind="btn", n=1, hint="Nav Aids"},  -- Push_NAV_AIDS_1 frames 0..0
    {arg=674, kind="btn", n=1, hint="Radar Map"},  -- Push_RADAR_MAP_1 frames 0..0
    {arg=675, kind="btn", n=1, hint="Synthetic Vision"},  -- Push_SYNT_VISION_1 frames 0..0
    {arg=676, kind="btn", n=1, hint="Spoiler (Push)"},  -- Push_Spoiler frames 1..3
    {arg=677, kind="btn", n=1, hint="Terrain"},  -- Push_TERRAIN_1 frames 0..0
    {arg=678, kind="btn", n=1, hint="Traffic"},  -- Push_TFC_1 frames 0..0
    {arg=679, kind="btn", n=1, hint="Weather Radar"},  -- Push_WXR_1 frames 0..0
    {arg=680, kind="btn", n=1, hint="Waypoint"},  -- Push_WYPT_1 frames 0..0
    {arg=681, kind="tumb2", n=2, hint="Air Refuel Receptacle (Open/Close)"},  -- REFUEL_switch frames 0..100
    {arg=682, kind="btn", n=1, hint="Switch 000"},  -- Switch_000 frames 0..0
    {arg=683, kind="btn", n=1, hint="Switch 001"},  -- Switch_001 frames 0..0
    {arg=684, kind="btn", n=1, hint="Switch 003"},  -- Switch_003 frames 0..0
    {arg=685, kind="btn", n=1, hint="Switch 004"},  -- Switch_004 frames 0..0
    {arg=686, kind="btn", n=1, hint="Switch 005"},  -- Switch_005 frames 0..0
    {arg=687, kind="btn", n=1, hint="Switch 016"},  -- Switch_016 frames 0..0
    {arg=688, kind="btn", n=1, hint="Switch 017"},  -- Switch_017 frames 0..0
    {arg=689, kind="btn", n=1, hint="Switch 018"},  -- Switch_018 frames 0..0
    {arg=690, kind="btn", n=1, hint="Switch 019"},  -- Switch_019 frames 0..0
    {arg=691, kind="btn", n=1, hint="Switch 020"},  -- Switch_020 frames 0..0
    {arg=692, kind="btn", n=1, hint="Switch 021"},  -- Switch_021 frames 0..0
    {arg=693, kind="btn", n=1, hint="Switch 022"},  -- Switch_022 frames 0..0
    {arg=694, kind="btn", n=1, hint="Switch 023"},  -- Switch_023 frames 0..0
    {arg=695, kind="btn", n=1, hint="Switch 046"},  -- Switch_046 frames 0..0
    {arg=696, kind="btn", n=1, hint="Switch 050"},  -- Switch_050 frames 0..0
    {arg=697, kind="btn", n=1, hint="Switch 051"},  -- Switch_051 frames 0..0
    {arg=698, kind="btn", n=1, hint="Switch 055"},  -- Switch_055 frames 0..0
    {arg=699, kind="btn", n=1, hint="Airlock"},  -- Switch_AIRLOCK frames 0..0
    {arg=700, kind="btn", n=1, hint="HUD Panel ALT"},  -- Switch_ALT_HudPanel frames 0..0
    {arg=701, kind="btn", n=1, hint="Anti-Ice"},  -- Switch_ANTI_ICE frames 0..0
    {arg=702, kind="tumb2", n=2, hint="HUD Panel ATT"},  -- Switch_ATT_HudPanel frames 0..1
    {arg=703, kind="btn", n=1, hint="Left Comp Gain"},  -- Switch_Gain_LeftComp frames 0..0
    {arg=704, kind="btn", n=1, hint="Cargo Door"},  -- Switch_CARGO_DOOR frames 0..0
    {arg=705, kind="btn", n=1, hint="Left Comp Contrast"},  -- Switch_CONT_LeftComp frames 0..0
    {arg=706, kind="multi", n=3, hint="Exterior Lights (Beacon)"},  -- Switch_EXT_Lights frames 0..2
    {arg=707, kind="tumb2", n=2, hint="Anti-Skid (On/Off)"},  -- Switch_FULL_ANTISKID_LeftPanel frames 1..2
    {arg=708, kind="tumb2", n=2, hint="Landing Light (On/Off)"},  -- Switch_LDG_Light_LeftPanel frames 1..2
    {arg=709, kind="btn", n=1, hint="Loadout"},  -- Switch_LOADOUT frames 0..0
    {arg=710, kind="multi", n=3, hint="Light Test"},  -- Switch_LTTEST_RightPanel frames 0..2
    {arg=711, kind="btn", n=1, hint="Magnetic Attach"},  -- Switch_MAGNETIC_ATTACH frames 0..0
    {arg=712, kind="multi", n=3, hint="Interior Light Mode"},  -- Switch_MODE_INTRLT_RightPanel frames 0..2
    {arg=713, kind="btn", n=1, hint="HUD Panel Night/Day"},  -- Switch_NIGHT_DAY_HudPanel frames 0..0
    {arg=714, kind="btn", n=1, hint="Pitot Heat"},  -- Switch_PITOT frames 0..0
    {arg=715, kind="tumb2", n=2, hint="Pitot Heat (Right Panel)"},  -- Switch_PITOT_RightPanel frames 1..2
    {arg=716, kind="btn", n=1, hint="Paddle Switch"},  -- Switch_Paddle frames 0..2
    {arg=717, kind="btn", n=1, hint="HUD Panel REJ 2"},  -- Switch_REJ2_HudPanel frames 0..0
    {arg=718, kind="btn", n=1, hint="HUD Panel WB"},  -- Switch_WB_HudPanel frames 0..0
    {arg=719, kind="btn", n=1, hint="Windshield Heat"},  -- Switch_WINDSHIELD_HEAT frames 0..0
    {arg=720, kind="tumb2", n=2, hint="Windshield Deice (On/Off)"},  -- Switch_Windshield_Deice frames 1..2
    {arg=721, kind="btn", n=1, hint="Yoke Trim Nose Down/Up"},  -- YOKE_L_PUSH_NOSE_DN_UP frames 1..3
    {arg=722, kind="btn", n=1, hint="Yoke Trim Nose Left/Right"},  -- YOKE_L_PUSH_NOSE_L_R frames 1..3
}

-- Pecas animadas pelo SIMULADOR (nao clicaveis): manete, manche, pedais
B21_COCKPIT_DRIVEN = { 592, 593, 597, 598, 599, 600, 601 }
