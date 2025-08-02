# Security Policy

## 🔐 API Key Management

### Important Security Notice

**NEVER commit API keys or sensitive credentials to version control!**

This project uses a secure template system for API configuration:

- `lib/config/api_config.dart` - Contains actual API keys (gitignored)
- `lib/config/api_config.dart.template` - Template file (committed to repo)

### Setting Up API Keys Securely

1. **Use the setup script:**
   ```bash
   # Windows
   setup_api_config.bat
   
   # Linux/Mac
   chmod +x setup_api_config.sh
   ./setup_api_config.sh
   ```

2. **Or manually copy the template:**
   ```bash
   cp lib/config/api_config.dart.template lib/config/api_config.dart
   ```

3. **Edit the configuration file:**
   - Open `lib/config/api_config.dart`
   - Replace `'your-openrouter-api-key-here'` with your actual API key
   - Save the file

### Best Practices

- ✅ Keep API keys in gitignored files
- ✅ Use environment variables in production
- ✅ Rotate API keys regularly
- ✅ Use least-privilege access for API keys
- ❌ Never commit API keys to version control
- ❌ Never share API keys in public channels
- ❌ Never hardcode API keys in source code

### If You Accidentally Commit an API Key

1. **Immediately revoke the exposed API key**
2. **Generate a new API key**
3. **Update your local configuration**
4. **Remove the key from git history** (if needed)
5. **Check security logs for unauthorized usage**

### Production Deployment

For production deployments, consider:

- Using environment variables
- Implementing secure key management services
- Setting up proper access controls
- Regular security audits
- Monitoring API usage

## 🚨 Reporting Security Issues

If you discover a security vulnerability, please:

1. **Do NOT create a public issue**
2. Email the maintainers directly
3. Provide detailed information about the vulnerability
4. Allow time for the issue to be addressed before public disclosure

## 📋 Security Checklist

- [ ] API keys are properly configured and gitignored
- [ ] Firebase security rules are implemented
- [ ] Input validation is in place
- [ ] Error messages don't expose sensitive information
- [ ] Authentication is properly implemented
- [ ] Regular security updates are applied
