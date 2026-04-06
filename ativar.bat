@echo off
setlocal EnableDelayedExpansion

:: --- Auto-Elevacao silenciosa ---
net session >nul 2>&1 || (powershell -Command "Start-Process '%~f0' -Verb RunAs" & exit /b)

:: --- Configuracao visual do CMD ---
title Reativar Defender
mode con: cols=60 lines=12
color 0F
cls

:: =============================================
:: OPCAO 1: Protecao em Tempo Real
:: =============================================
cls
echo.
echo.
echo        Reativando protecoes...
echo.
echo        [                              ] 0%%
powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $false" >nul 2>&1
powershell -Command "Set-MpPreference -DisableBehaviorMonitoring $false" >nul 2>&1
powershell -Command "Set-MpPreference -DisableIOAVProtection $false" >nul 2>&1
cls
echo.
echo.
echo        Reativando protecoes...
echo.
echo        [#####                         ] 15%%
powershell -Command "Set-MpPreference -DisableBlockAtFirstSeen $false" >nul 2>&1
powershell -Command "Set-MpPreference -DisableScriptScanning $false" >nul 2>&1
powershell -Command "Set-MpPreference -DisableIntrusionPreventionSystem $false" >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableBehaviorMonitoring" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableOnAccessProtection" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableScanOnRealtimeEnable" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableIOAVProtection" /f >nul 2>&1
cls
echo.
echo.
echo        Reativando protecoes...
echo.
echo        [##########                    ] 30%%

:: =============================================
:: OPCAO 2: Protecao Fornecida pela Nuvem
:: =============================================
powershell -Command "Set-MpPreference -MAPSReporting 2" >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SpynetReporting" /f >nul 2>&1
cls
echo.
echo.
echo        Restaurando nuvem e amostras...
echo.
echo        [###############               ] 50%%

:: =============================================
:: OPCAO 3: Envio Automatico de Amostras
:: =============================================
powershell -Command "Set-MpPreference -SubmitSamplesConsent 1" >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SubmitSamplesConsent" /f >nul 2>&1
cls
echo.
echo.
echo        Restaurando nuvem e amostras...
echo.
echo        [####################          ] 65%%

:: =============================================
:: OPCAO 4: Protecao contra Alteracoes
:: =============================================
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Features" /v "TamperProtection" /t REG_DWORD /d 5 /f >nul 2>&1
cls
echo.
echo.
echo        Restaurando configuracoes gerais...
echo.
echo        [########################      ] 80%%

:: =============================================
:: REATIVACAO GERAL DO DEFENDER
:: =============================================
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiVirus" /f >nul 2>&1
powershell -Command "Set-MpPreference -HighThreatDefaultAction 0 -Force" >nul 2>&1
powershell -Command "Set-MpPreference -ModerateThreatDefaultAction 0" >nul 2>&1
powershell -Command "Set-MpPreference -LowThreatDefaultAction 0" >nul 2>&1
powershell -Command "Set-MpPreference -SevereThreatDefaultAction 0" >nul 2>&1
cls
echo.
echo.
echo        Finalizando...
echo.
echo        [############################  ] 95%%
timeout /t 1 >nul

cls
echo.
echo.
echo        Defender reativado com sucesso!
echo.
echo        [##############################] 100%%
timeout /t 2 >nul
exit
