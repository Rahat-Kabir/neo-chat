#!/bin/bash

echo "Setting up API configuration for NeoChat..."
echo

if [ ! -f "lib/config/api_config.dart" ]; then
    echo "Creating api_config.dart from template..."
    cp "lib/config/api_config.dart.template" "lib/config/api_config.dart"
    echo
    echo "✅ API configuration file created!"
    echo
    echo "⚠️  IMPORTANT: Please edit lib/config/api_config.dart and replace 'your-openrouter-api-key-here' with your actual OpenRouter API key."
    echo
    echo "📝 To get your OpenRouter API key:"
    echo "   1. Go to https://openrouter.ai/"
    echo "   2. Sign up or log in"
    echo "   3. Go to API Keys section"
    echo "   4. Create a new API key"
    echo "   5. Copy the key and paste it in lib/config/api_config.dart"
    echo
else
    echo "✅ API configuration file already exists."
    echo
fi

echo "Setup complete! You can now run the app with: flutter run"
