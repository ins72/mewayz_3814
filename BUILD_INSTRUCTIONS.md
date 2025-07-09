# Mewayz Production Build Instructions

## 🚀 Quick Start for Production Deployment

### Prerequisites
- Flutter 3.16+ installed
- Dart 3.2+ installed
- Android Studio (for Android builds)
- Xcode (for iOS builds, macOS only)
- All required API keys and credentials

### Step 1: Environment Configuration
1. Copy the environment template:
   ```bash
   cp .env.example .env
   ```

2. Edit `.env` file with your actual production values:
   - **SUPABASE_URL**: Your Supabase project URL
   - **SUPABASE_ANON_KEY**: Your Supabase anonymous key
   - **ENCRYPTION_KEY**: 32+ character encryption key
   - **GOOGLE_CLIENT_ID**: Google OAuth client ID
   - **APPLE_CLIENT_ID**: Apple OAuth client ID (com.mewayz.app)
   - **Social Media API Keys**: Instagram, Facebook, Twitter, LinkedIn, YouTube, TikTok
   - **Payment Keys**: Stripe, PayPal credentials
   - **Communication Services**: SendGrid, Twilio credentials
   - **Analytics**: Firebase, Mixpanel tokens
   - **Push Notifications**: FCM server key, APNS credentials

### Step 2: Validation
Run the production validation script:
```bash
chmod +x scripts/validate_production.sh
./scripts/validate_production.sh
```

### Step 3: Build for Production
Run the production build script:
```bash
chmod +x scripts/build_production.sh
./scripts/build_production.sh
```

### Step 4: Deploy to Stores
For Android:
```bash
chmod +x scripts/deploy_android.sh
./scripts/deploy_android.sh
```

For iOS (macOS only):
```bash
chmod +x scripts/deploy_ios.sh
./scripts/deploy_ios.sh
```

## 📋 Required Environment Variables

### Core Configuration
```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
ENCRYPTION_KEY=your-32-character-key
GOOGLE_CLIENT_ID=your-google-client-id
APPLE_CLIENT_ID=com.mewayz.app
```

### Social Media APIs
```env
INSTAGRAM_CLIENT_ID=your-instagram-client-id
FACEBOOK_APP_ID=your-facebook-app-id
TWITTER_API_KEY=your-twitter-api-key
LINKEDIN_CLIENT_ID=your-linkedin-client-id
YOUTUBE_API_KEY=your-youtube-api-key
TIKTOK_CLIENT_ID=your-tiktok-client-id
```

### Payment Processing
```env
STRIPE_PUBLISHABLE_KEY=pk_live_your-stripe-key
PAYPAL_CLIENT_ID=your-paypal-client-id
```

### Communication Services
```env
SENDGRID_API_KEY=SG.your-sendgrid-key
TWILIO_ACCOUNT_SID=your-twilio-sid
```

### Analytics & Monitoring
```env
FIREBASE_PROJECT_ID=your-firebase-project
MIXPANEL_TOKEN=your-mixpanel-token
FCM_SERVER_KEY=your-fcm-server-key
```

## 🔧 Manual Build Process

### Android Build
```bash
flutter build appbundle --release \
  --dart-define=SUPABASE_URL=$SUPABASE_URL \
  --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY \
  --dart-define=ENCRYPTION_KEY=$ENCRYPTION_KEY \
  --dart-define=GOOGLE_CLIENT_ID=$GOOGLE_CLIENT_ID \
  --dart-define=APPLE_CLIENT_ID=$APPLE_CLIENT_ID
```

### iOS Build
```bash
flutter build ipa --release \
  --dart-define=SUPABASE_URL=$SUPABASE_URL \
  --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY \
  --dart-define=ENCRYPTION_KEY=$ENCRYPTION_KEY \
  --dart-define=GOOGLE_CLIENT_ID=$GOOGLE_CLIENT_ID \
  --dart-define=APPLE_CLIENT_ID=$APPLE_CLIENT_ID
```

## 🏪 Store Deployment

### Google Play Store
1. Generate upload key and configure signing
2. Upload AAB file to Google Play Console
3. Complete store listing with screenshots and descriptions
4. Submit for review

### Apple App Store
1. Configure provisioning profiles and certificates
2. Upload IPA file to App Store Connect
3. Complete store listing with screenshots and descriptions
4. Submit for review

## ✅ Production Checklist

- [ ] Environment variables configured
- [ ] API keys obtained and tested
- [ ] Supabase project set up
- [ ] OAuth applications configured
- [ ] Payment processing tested
- [ ] Push notifications configured
- [ ] App icons and screenshots prepared
- [ ] Store listings completed
- [ ] Privacy policy and terms updated
- [ ] All tests passing
- [ ] Security audit completed
- [ ] Performance optimization verified

## 🆘 Troubleshooting

### Common Issues

1. **Environment Variables Not Loading**
   - Ensure .env file is in project root
   - Check variable names match exactly
   - Verify no spaces around = signs

2. **Build Failures**
   - Run `flutter clean && flutter pub get`
   - Check Flutter and Dart versions
   - Verify all dependencies are compatible

3. **API Integration Issues**
   - Validate API keys are correct
   - Check API endpoints are accessible
   - Verify OAuth redirect URIs match

4. **Store Submission Issues**
   - Review store guidelines
   - Check app content and permissions
   - Verify privacy policy compliance

### Getting Help
- Check logs for detailed error messages
- Review Flutter documentation
- Contact support at support@mewayz.com

## 📊 Performance Optimization

The app is optimized for production with:
- Code obfuscation enabled
- Asset compression
- Tree shaking for unused code
- Efficient image loading and caching
- Minimal app size through bundle splitting

## 🔒 Security Features

- End-to-end encryption for sensitive data
- Secure API key management
- Certificate pinning for network requests
- Biometric authentication support
- Two-factor authentication
- Regular security audits

## 📈 Monitoring & Analytics

Production monitoring includes:
- Real-time crash reporting
- Performance metrics tracking
- User behavior analytics
- Error logging and alerting
- App store review monitoring

---

**Ready for Production**: Once all steps are completed, your Mewayz app will be fully ready for distribution on Apple App Store and Google Play Store with all features working perfectly and comprehensive accessibility support.