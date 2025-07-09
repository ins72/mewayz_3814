# Mewayz Production Deployment Guide

This guide provides comprehensive instructions for deploying the Mewayz Flutter app to production on both Apple App Store and Google Play Store.

## 📋 Prerequisites

### Required Software
- Flutter SDK 3.16 or higher
- Dart SDK 3.2 or higher
- Android Studio (for Android builds)
- Xcode (for iOS builds, macOS only)
- Git for version control

### Required Accounts
- Google Play Console account (for Android deployment)
- Apple Developer Program account (for iOS deployment)
- Firebase/Google Cloud account (for analytics and notifications)
- Supabase account (for backend services)

## 🔧 Environment Setup

### 1. Clone the Repository
```bash
git clone https://github.com/your-org/mewayz.git
cd mewayz
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Configure Environment Variables
1. Copy the example environment file:
   ```bash
   cp .env.example .env
   ```

2. Edit `.env` file with your actual production values:
   - **Supabase Configuration**: Add your Supabase URL and anon key
   - **OAuth Configuration**: Add Google and Apple OAuth credentials
   - **Social Media APIs**: Add API keys for Instagram, Facebook, Twitter, etc.
   - **Payment Processing**: Add Stripe and PayPal credentials
   - **Analytics**: Add Firebase, Mixpanel, and other analytics tokens
   - **Push Notifications**: Add FCM server key and APNS certificates

### 4. Validate Configuration
Run the configuration validator:
```bash
flutter test test/config_validator_test.dart
```

## 🤖 Android Deployment

### 1. Prepare Android Build Environment

#### Generate Upload Key
```bash
cd android
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

#### Configure Key Properties
Create `android/key.properties`:
```properties
storePassword=your-store-password
keyPassword=your-key-password
keyAlias=upload
storeFile=upload-keystore.jks
```

#### Update Build Configuration
Ensure `android/app/build.gradle` includes signing configuration:
```gradle
signingConfigs {
    release {
        keyAlias keystoreProperties['keyAlias']
        keyPassword keystoreProperties['keyPassword']
        storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
        storePassword keystoreProperties['storePassword']
    }
}
```

### 2. Build for Production
```bash
./scripts/build_production.sh
```

This will generate:
- `build/app/outputs/bundle/release/app-release.aab` (App Bundle)
- `build/app/outputs/apk/release/app-release.apk` (APK)

### 3. Deploy to Google Play Store

#### Option 1: Automated Deployment (Recommended)
```bash
./scripts/deploy_android.sh
```

#### Option 2: Manual Upload
1. Go to [Google Play Console](https://play.google.com/console)
2. Select your app or create a new one
3. Go to "Production" > "Create new release"
4. Upload the App Bundle: `build/app/outputs/bundle/release/app-release.aab`
5. Fill in release notes and submit for review

### 4. Store Listing Requirements

#### Required Assets
- App icon (512x512 PNG)
- Feature graphic (1024x500 PNG)
- Screenshots (phone and tablet)
- App description (up to 4,000 characters)
- Short description (up to 80 characters)

#### Content Rating
Complete the content rating questionnaire based on your app's features.

#### Privacy Policy
Provide a link to your privacy policy: `https://mewayz.com/privacy-policy`

## 🍎 iOS Deployment

### 1. Prepare iOS Build Environment

#### Configure Xcode Project
1. Open `ios/Runner.xcworkspace` in Xcode
2. Select the Runner project and configure:
   - Team: Select your Apple Developer Team
   - Bundle Identifier: `com.mewayz.app`
   - Version: `1.0.0`
   - Build: `1`

#### Configure Signing & Capabilities
1. Go to Signing & Capabilities
2. Enable "Automatically manage signing"
3. Add required capabilities:
   - Push Notifications
   - Background Modes
   - Associated Domains (for deep linking)
   - App Groups (if needed)

### 2. Build for Production
```bash
./scripts/build_production.sh
```

This will generate:
- `build/ios/ipa/mewayz.ipa` (IPA file for App Store)

### 3. Deploy to App Store

#### Option 1: Automated Deployment (Recommended)
```bash
./scripts/deploy_ios.sh
```

#### Option 2: Manual Upload
1. Open Xcode and go to Window > Organizer
2. Select your app archive
3. Click "Distribute App" and select "App Store Connect"
4. Follow the prompts to upload the IPA
5. Go to [App Store Connect](https://appstoreconnect.apple.com) and submit for review

### 4. App Store Listing Requirements

#### Required Assets
- App icon (1024x1024 PNG)
- Screenshots for all device sizes
- App preview videos (optional but recommended)
- App description
- Keywords (up to 100 characters)

#### App Store Review Guidelines
Ensure your app complies with [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/).

## 🔒 Security Considerations

### 1. API Keys and Secrets
- Never commit API keys to version control
- Use environment variables for all sensitive data
- Implement proper key rotation strategies
- Use different keys for development and production

### 2. Code Obfuscation
Build with obfuscation enabled:
```bash
flutter build apk --obfuscate --split-debug-info=build/debug-info
flutter build ios --obfuscate --split-debug-info=build/debug-info
```

### 3. Certificate Pinning
Ensure certificate pinning is enabled in production builds for enhanced security.

## 📊 Monitoring and Analytics

### 1. Crash Reporting
- Firebase Crashlytics is configured for crash reporting
- Sentry integration for advanced error tracking
- Monitor crash rates and fix critical issues promptly

### 2. Performance Monitoring
- Firebase Performance Monitoring tracks app performance
- Monitor app startup time, network requests, and user interactions
- Set up alerts for performance degradation

### 3. User Analytics
- Firebase Analytics tracks user engagement
- Mixpanel integration for advanced user behavior analysis
- Monitor key metrics like DAU, retention, and conversion rates

## 🚀 Deployment Checklist

### Pre-Deployment
- [ ] All environment variables configured
- [ ] Tests passing (`flutter test`)
- [ ] Code obfuscation enabled
- [ ] API keys validated
- [ ] Privacy policy updated
- [ ] Terms of service updated
- [ ] App icons and screenshots ready
- [ ] Store listings prepared

### Android Deployment
- [ ] App Bundle generated
- [ ] Google Play Console configured
- [ ] Upload key generated and secured
- [ ] Content rating completed
- [ ] Privacy policy linked
- [ ] App uploaded and submitted

### iOS Deployment
- [ ] IPA generated
- [ ] App Store Connect configured
- [ ] Certificates and provisioning profiles valid
- [ ] App Store listing completed
- [ ] Privacy policy linked
- [ ] App uploaded and submitted

### Post-Deployment
- [ ] Monitor review process
- [ ] Respond to store feedback
- [ ] Monitor crash reports
- [ ] Track performance metrics
- [ ] Plan for future updates

## 🔄 Continuous Deployment

### GitHub Actions (Optional)
Set up automated builds and deployments using GitHub Actions:

```yaml
# .github/workflows/deploy.yml
name: Deploy to Stores
on:
  push:
    tags:
      - 'v*'
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-java@v2
        with:
          java-version: '11'
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
      - run: flutter pub get
      - run: flutter test
      - run: ./scripts/build_production.sh
      - run: ./scripts/deploy_android.sh
```

### Version Management
Use semantic versioning:
- Major version (1.0.0): Breaking changes
- Minor version (1.1.0): New features
- Patch version (1.0.1): Bug fixes

## 🆘 Troubleshooting

### Common Issues

#### Android Build Fails
1. Check Java version (Java 11 required)
2. Verify Android SDK installation
3. Clean and rebuild: `flutter clean && flutter pub get`

#### iOS Build Fails
1. Check Xcode version (latest stable required)
2. Verify Apple Developer account status
3. Check provisioning profiles and certificates

#### App Store/Play Store Rejection
1. Review store guidelines
2. Check app content and functionality
3. Verify privacy policy and terms of service
4. Test app thoroughly on different devices

### Getting Help
- Check the [Flutter documentation](https://flutter.dev/docs)
- Review platform-specific guidelines
- Contact support: [support@mewayz.com](mailto:support@mewayz.com)

## 📞 Support

If you encounter any issues during deployment, please:
1. Check this documentation first
2. Review the error logs
3. Contact our support team at [support@mewayz.com](mailto:support@mewayz.com)
4. Join our Discord community for quick help

---

**Note**: This guide assumes you have the necessary developer accounts and have completed the initial setup. For first-time deployment, allow extra time for store review processes.