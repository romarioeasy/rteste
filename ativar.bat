@echo off
title Ativar Windows Defender Completo

echo Ativando servicos do Windows Defender...

sc config WinDefend start= auto
sc config WdNisSvc start= auto
sc config Sense start= auto

sc start WinDefend
sc start WdNisSvc
sc start Sense

echo Removendo politicas que desativam o Defender...

reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /f
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /f

echo Ativando protecoes...

powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $false"
powershell -Command "Set-MpPreference -DisableBehaviorMonitoring $false"
powershell -Command "Set-MpPreference -DisableBlockAtFirstSeen $false"
powershell -Command "Set-MpPreference -DisableIOAVProtection $false"
powershell -Command "Set-MpPreference -DisablePrivacyMode $false"
powershell -Command "Set-MpPreference -SignatureDisableUpdateOnStartupWithoutEngine $false"
powershell -Command "Set-MpPreference -DisableArchiveScanning $false"
powershell -Command "Set-MpPreference -DisableIntrusionPreventionSystem $false"
powershell -Command "Set-MpPreference -DisableScriptScanning $false"

echo Ativando protecao na nuvem...

powershell -Command "Set-MpPreference -MAPSReporting Advanced"
powershell -Command "Set-MpPreference -SubmitSamplesConsent 1"

echo Ativando Firewall...

netsh advfirewall set allprofiles state on

echo Atualizando definicoes...

powershell -Command "Update-MpSignature"

echo.
echo Windows Defender ativado completamente.
pause