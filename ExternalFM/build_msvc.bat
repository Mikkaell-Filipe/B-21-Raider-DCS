@echo off
REM Rode no "x64 Native Tools Command Prompt for VS"
cd /d "%~dp0"
cl /nologo /std:c++17 /O2 /EHsc /MT /LD /I B21_EFM /I include B21_EFM\B21_EFM.cpp /Fe:..\bin\B21_EFM.dll
