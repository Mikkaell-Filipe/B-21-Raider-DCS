B-21 RAIDER (DCS EFM) - v0.2.0
================================
INSTALAR: copie a pasta "B-21 RAIDER" para Saved Games\DCS\Mods\aircraft\

1) COMPILAR A DLL (obrigatorio - bin/ vem vazio):
   - Visual Studio: ExternalFM\build_msvc.bat  (x64 Native Tools prompt)
   - MinGW-w64:     ExternalFM/build_mingw.sh
   - CMake:         cmake -S ExternalFM -B build -A x64 && cmake --build build --config Release
   Saida: bin\B21_EFM.dll

2) ARQUIVOS
   ExternalFM/B21_EFM/B21_Aerodata.h  aerodinamica (area 300 m2, tabelas M x alpha)
   ExternalFM/B21_EFM/B21_EFM.cpp     EFM: FBW, 2 motores, combustivel, trem, baia, luzes, args
   entry.lua / B-21.lua / Entry/Suspension.lua / Views.lua
   Cockpit/Scripts/command_defs.lua   IDs 10001-10020 (devem bater com Cmd:: no .cpp)
   Input/B-21/...                     teclas e botoes (rebindaveis no menu do DCS)
   Sounds/...                         sounder de 2 motores + sons de motor sinteticos

3) PONTOS A AJUSTAR EM VOO
   - Sinais de animacao dos elevons: Arg::AILERON_SIGN / ELEVATOR_SIGN no .cpp
   - Autoridade do manche: kPitchAuthority / kRollAuthority
   - Coeficientes [N3] em B21_Aerodata.h sao estimativas parametricas
   - Cockpit: scripts minimos (sem instrumentos animados); mainpanel_init.lua usa Cockpit_B-21.edm
   - Skins/1 e icones sao os do seu zip original; ImagesGUI/B-21.png nao incluso (Picture em B-21.lua)
