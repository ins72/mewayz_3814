# Mewayz - All-in-One Business Platform

<div align="center">
  <img src="assets/images/img_app_logo.svg" alt="Mewayz Logo" width="120" height="120">
  
  [![Flutter](https://img.shields.io/badge/Flutter-3.16+-blue.svg)](https://flutter.dev/)
  [![Dart](https://img.shields.io/badge/Dart-3.2+-blue.svg)](https://dart.dev/)
  [![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
  [![Play Store](https://img.shields.io/badge/Play%20Store-Available-success.svg)](https://play.google.com/store/apps/details?id=com.mewayz.app)
  [![App Store](https://img.shields.io/badge/App%20Store-Available-success.svg)](https://apps.apple.com/app/mewayz/id1234567890)
</div>

## 🚀 Overview

Mewayz is a comprehensive business platform that combines social media management, CRM, e-commerce, analytics, and more into a single powerful mobile application. Built with Flutter for cross-platform compatibility and optimal performance.

### ✨ Key Features

- **Social Media Management**: Schedule posts, manage multiple accounts, and analyze performance
- **Link in Bio Builder**: Create professional landing pages with analytics
- **CRM System**: Manage contacts, leads, and customer relationships
- **E-commerce Integration**: Marketplace store with payment processing
- **Analytics Dashboard**: Comprehensive insights and reporting
- **Email Marketing**: Campaign management and automation
- **Content Creation**: Templates, scheduling, and optimization tools
- **Team Collaboration**: Role-based access control and team management

## 📱 Screenshots

| Home Dashboard | Social Media Manager | Analytics | Link in Bio |
|---|---|---|---|
| ![Dashboard](screenshots/dashboard.png) | ![Social Media](screenshots/social-media.png) | ![Analytics](screenshots/analytics.png) | ![Link in Bio](screenshots/link-in-bio.png) |

## 🛠️ Technology Stack

- **Framework**: Flutter 3.16+
- **Language**: Dart 3.2+
- **Backend**: Supabase
- **Database**: PostgreSQL
- **Authentication**: Supabase Auth with OAuth
- **Storage**: Supabase Storage / Cloudinary
- **Analytics**: Firebase Analytics, Mixpanel
- **Push Notifications**: Firebase Cloud Messaging
- **Payment Processing**: Stripe, PayPal
- **State Management**: Provider/Riverpod
- **Architecture**: Clean Architecture with Repository Pattern

## 🚀 Quick Start

### Prerequisites

- Flutter SDK 3.16 or higher
- Dart SDK 3.2 or higher
- Android Studio / VS Code
- Xcode (for iOS development)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-org/mewayz.git
   cd mewayz
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure environment**
   ```bash
   cp .env.example .env
   # Edit .env with your configuration values
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 📋 Environment Configuration

The app requires environment configuration for production deployment. Copy `.env.example` to `.env` and configure the following:

### Required Configuration

```env
# Core
SUPABASE_URL=your-supabase-url
SUPABASE_ANON_KEY=your-supabase-anon-key
ENCRYPTION_KEY=your-32-character-encryption-key

# OAuth
GOOGLE_CLIENT_ID=your-google-client-id
APPLE_CLIENT_ID=com.mewayz.app

# Social Media APIs
INSTAGRAM_CLIENT_ID=your-instagram-client-id
FACEBOOK_APP_ID=your-facebook-app-id
TWITTER_API_KEY=your-twitter-api-key
LINKEDIN_CLIENT_ID=your-linkedin-client-id
YOUTUBE_API_KEY=your-youtube-api-key
TIKTOK_CLIENT_ID=your-tiktok-client-id

# Payment
STRIPE_PUBLISHABLE_KEY=pk_live_your-stripe-key
PAYPAL_CLIENT_ID=your-paypal-client-id

# Services
SENDGRID_API_KEY=your-sendgrid-api-key
TWILIO_ACCOUNT_SID=your-twilio-account-sid
CLOUDINARY_CLOUD_NAME=your-cloudinary-cloud-name

# Analytics
FIREBASE_PROJECT_ID=your-firebase-project-id
MIXPANEL_TOKEN=your-mixpanel-token
```

## 🏗️ Production Deployment

### Build for Production

```bash
# Build for both platforms
./scripts/build_production.sh

# Build Android only
flutter build appbundle --release

# Build iOS only (macOS required)
flutter build ipa --release
```

### Deploy to Stores

```bash
# Deploy to Google Play Store
./scripts/deploy_android.sh

# Deploy to Apple App Store
./scripts/deploy_ios.sh
```

### Pre-deployment Checklist

- [ ] Environment variables configured
- [ ] All tests passing
- [ ] Store listings prepared
- [ ] App icons and screenshots ready
- [ ] Privacy policy and terms updated
- [ ] App Store/Play Store accounts configured

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run integration tests
flutter test integration_test/
```

## 📊 Features Overview

### Social Media Management
- Multi-platform posting (Instagram, Facebook, Twitter, LinkedIn, YouTube, TikTok)
- Content scheduling and calendar
- Performance analytics and insights
- Hashtag research and trending topics
- Audience engagement tracking

### CRM & Lead Management
- Contact management and organization
- Lead scoring and qualification
- Sales pipeline tracking
- Customer communication history
- Integration with social media platforms

### E-commerce & Marketplace
- Product catalog management
- Order processing and fulfillment
- Payment integration (Stripe, PayPal)
- Inventory tracking
- Customer reviews and ratings

### Analytics & Reporting
- Real-time dashboard with KPIs
- Cross-platform performance metrics
- ROI tracking and attribution
- Custom report generation
- Data export capabilities

### Content Creation Tools
- Template library for posts and campaigns
- AI-powered content suggestions
- Brand kit management
- Media library and organization
- Collaboration tools for teams

## 🔧 Architecture

The app follows Clean Architecture principles:

```
lib/
├── core/                   # Core utilities and configurations
├── presentation/           # UI layer (screens and widgets)
├── services/              # Business logic and data access
├── widgets/               # Reusable UI components
├── theme/                 # App theming and styling
└── routes/                # Navigation and routing
```

## 🌐 API Integration

### Supported Platforms

- **Social Media**: Instagram, Facebook, Twitter, LinkedIn, YouTube, TikTok
- **Payment**: Stripe, PayPal
- **Email**: SendGrid, Mailgun
- **SMS**: Twilio
- **Storage**: Cloudinary, AWS S3
- **Analytics**: Firebase, Mixpanel, Amplitude

### Authentication

- Email/Password authentication
- OAuth (Google, Apple, Facebook)
- Two-factor authentication
- Biometric authentication (Touch ID/Face ID)

## 🔒 Security

- End-to-end encryption for sensitive data
- Secure token management
- Certificate pinning for API calls
- Biometric authentication support
- Regular security audits and updates

## 📄 Legal & Privacy

- [Privacy Policy](https://mewayz.com/privacy-policy)
- [Terms of Service](https://mewayz.com/terms-of-service)
- [Cookie Policy](https://mewayz.com/cookie-policy)
- GDPR and CCPA compliant

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

- **Email**: support@mewayz.com
- **Website**: https://mewayz.com
- **Documentation**: https://docs.mewayz.com
- **Discord**: https://discord.gg/mewayz

## 🎯 Roadmap

- [ ] AI-powered content creation
- [ ] Advanced automation workflows
- [ ] Multi-language support
- [ ] Desktop application
- [ ] API marketplace
- [ ] White-label solutions

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Supabase for backend infrastructure
- All contributors and beta testers
- Open source community for invaluable libraries

---

<div align="center">
  Made with ❤️ by the Mewayz Team
  
  [![Website](https://img.shields.io/badge/Website-mewayz.com-blue)](https://mewayz.com)
  [![Twitter](https://img.shields.io/badge/Twitter-@mewayz-blue)](https://twitter.com/mewayz)
  [![LinkedIn](https://img.shields.io/badge/LinkedIn-Mewayz-blue)](https://linkedin.com/company/mewayz)
</div>