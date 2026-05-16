@echo off
setlocal

set "ENV_FILE=..\env.json"

echo Setting up API environment file for NeoChat...
echo.

if not exist "%ENV_FILE%" (
    (
        echo {
        echo   "OPENROUTER_API_KEY": "",
        echo   "OPENAI_API_KEY": ""
        echo }
    ) > "%ENV_FILE%"
    echo Created %ENV_FILE%.
    echo Edit it with your OpenRouter and/or OpenAI API key before running AI chat.
) else (
    echo %ENV_FILE% already exists.
)

echo.
echo Run from neo_chat with:
echo flutter run -d chrome --dart-define-from-file=../env.json

endlocal
