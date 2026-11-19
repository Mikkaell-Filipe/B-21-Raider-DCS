# Patch B-21 RAIDER: renomeia texturas, instala DLL/livery/B-21.lua.
# Extraia este patch DENTRO da pasta "B-21 RAIDER" (sobrescrevendo) e rode APLICAR_PATCH.bat
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $root
if (-not (Test-Path "$root\entry.lua")) { throw "Rode dentro da pasta 'B-21 RAIDER' (entry.lua nao encontrado)." }
$tex = Join-Path $root 'Textures'
$n = 0
Get-ChildItem -LiteralPath $tex -File | Where-Object { $_.Name -match '\.png\.dds$' } | ForEach-Object {
    $new = ($_.Name -replace '\.png\.dds$', '.dds').ToLowerInvariant()
    $dest = Join-Path $tex $new
    if (Test-Path -LiteralPath $dest) { Remove-Item -LiteralPath $dest -Force }
    Rename-Item -LiteralPath $_.FullName -NewName $new
    $n++
}
Write-Host "Texturas renomeadas: $n"
Get-ChildItem -LiteralPath $tex -File | Where-Object { $_.Name -match '\.(flags|json)$' } | Remove-Item -Force
if (Test-Path "$root\bin\B21_EFM.dll") { Write-Host "bin\B21_EFM.dll OK" } else { Write-Warning "DLL ausente" }
Write-Host "Pronto. Abra o DCS e confira o dcs.log."
