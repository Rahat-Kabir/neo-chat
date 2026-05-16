#!/usr/bin/env bash
set -euo pipefail

env_file="../env.json"

echo "Setting up API environment file for NeoChat..."
echo

if [ ! -f "$env_file" ]; then
  cat > "$env_file" <<'JSON'
{
  "OPENROUTER_API_KEY": "",
  "OPENAI_API_KEY": ""
}
JSON
  echo "Created $env_file."
  echo "Edit it with your OpenRouter and/or OpenAI API key before running AI chat."
else
  echo "$env_file already exists."
fi

echo
echo "Run from neo_chat with:"
echo "flutter run -d chrome --dart-define-from-file=../env.json"
