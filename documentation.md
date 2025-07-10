# Mewayz Mobile App - Comprehensive Documentation

## 📱 Project Overview

**Mewayz** is an all-in-one business platform that combines social media management, CRM, e-commerce, analytics, and more into a single powerful mobile application. Built with Flutter for cross-platform compatibility and optimal performance on iOS and Android.

**Application Details:**
- **App Name**: Mewayz
- **Package Name**: `com.mewayz.app`
- **Current Version**: 1.0.0+1
- **Flutter Version**: 3.16+
- **Dart Version**: 3.2+
- **Architecture**: Clean Architecture with Repository Pattern
- **State Management**: Provider/Riverpod compatible
- **Backend**: Supabase (PostgreSQL)
- **Primary Theme**: Dark theme with modern UI design

---

## 📦 Dependencies & Libraries

### Core Framework
| Library | Version | Purpose |
|---------|---------|---------|
| `flutter` | ^3.16.0 | Core framework for building cross-platform UIs |
| `dart` | ^3.2.0 | Programming language for Flutter development |
| `cupertino_icons` | ^1.0.2 | iOS-style icons |

### Image & Media Handling
| Library | Version | Purpose |
|---------|---------|---------|
| `cached_network_image` | ^3.3.1 | Network image loading and caching |
| `flutter_svg` | ^2.0.9 | SVG file rendering support |
| `image_picker` | ^1.0.7 | Camera and gallery image selection |

### UI & Design
| Library | Version | Purpose |
|---------|---------|---------|
| `sizer` | ^2.0.15 | Responsive UI sizing across devices |
| `google_fonts` | ^6.1.0 | Google Fonts integration (Primary: Inter) |
| `fluttertoast` | ^8.2.4 | Toast notifications |
| `pull_to_refresh` | ^2.0.0 | Pull-to-refresh functionality |

### Storage & Persistence
| Library | Version | Purpose |
|---------|---------|---------|
| `shared_preferences` | ^2.2.2 | Local key-value storage |

### Networking & APIs
| Library | Version | Purpose |
|---------|---------|---------|
| `dio` | ^5.7.0 | HTTP client for API calls |
| `connectivity_plus` | ^5.0.2 | Network connectivity monitoring |
| `internet_connection_checker` | ^1.0.0+1 | Internet connection validation |

### Database & Authentication
| Library | Version | Purpose |
|---------|---------|---------|
| `supabase_flutter` | ^2.5.6 | Supabase integration (Backend as a Service) |
| `google_sign_in` | ^6.2.1 | Google OAuth authentication |
| `sign_in_with_apple` | ^6.1.2 | Apple Sign-In integration |
| `crypto` | ^3.0.3 | Cryptographic operations |

### Security & Authentication
| Library | Version | Purpose |
|---------|---------|---------|
| `local_auth` | ^2.1.8 | Biometric authentication |
| `email_validator` | ^2.1.17 | Email format validation |
| `pin_code_fields` | ^8.0.1 | OTP/PIN input fields |

### Data Visualization
| Library | Version | Purpose |
|---------|---------|---------|
| `fl_chart` | ^0.65.0 | Charts and graphs for analytics |

### Utilities
| Library | Version | Purpose |
|---------|---------|---------|
| `intl` | ^0.19.0 | Internationalization support |
| `file_picker` | ^8.1.2 | File selection from device |
| `qr_flutter` | ^4.1.0 | QR code generation |
| `url_launcher` | ^6.2.2 | URL and external app launching |
| `permission_handler` | ^11.3.1 | Device permissions management |
| `device_info_plus` | ^10.1.0 | Device information access |
| `package_info_plus` | ^8.0.0 | App package information |

### Development Tools
| Library | Version | Purpose |
|---------|---------|---------|
| `flutter_lints` | ^5.0.0 | Code quality and linting rules |

---

## 🏗️ Project File Structure

```
mewayz/
├── pubspec.yaml                                    # Project dependencies and configuration
├── analysis_options.yaml                          # Dart analysis configuration
├── README.md                                       # Project overview and setup
├── BUILD_INSTRUCTIONS.md                          # Production build instructions
├── PRODUCTION_CHECKLIST.md                        # Pre-production validation checklist
├── documentation.md                               # This comprehensive documentation
├── env.json                                       # Environment variables (development)
│
├── lib/                                           # Main application source code
│   ├── main.dart                                  # Application entry point
│   │
│   ├── core/                                      # Core utilities and configurations
│   │   ├── app_export.dart                        # Central exports file
│   │   ├── app_constants.dart                     # Application constants
│   │   ├── app_initialization.dart                # App initialization logic
│   │   ├── environment_config.dart                # Environment variable management
│   │   ├── production_config.dart                 # Production configuration
│   │   ├── supabase_service.dart                  # Supabase client singleton
│   │   ├── api_client.dart                        # HTTP client configuration
│   │   ├── enhanced_api_client.dart               # Enhanced API client with retries
│   │   ├── storage_service.dart                   # Local storage management
│   │   ├── analytics_service.dart                 # Analytics tracking
│   │   ├── notification_service.dart              # Push notifications
│   │   ├── security_service.dart                  # Security utilities
│   │   ├── accessibility_service.dart             # Accessibility features
│   │   ├── error_handler.dart                     # Global error handling
│   │   ├── resilient_error_handler.dart           # Advanced error handling
│   │   ├── button_service.dart                    # Button interaction service
│   │   ├── platform_utils.dart                    # Platform-specific utilities
│   │   ├── optimized_state_manager.dart           # State management optimization
│   │   ├── performance_monitor.dart               # Performance monitoring
│   │   └── network_resilience_service.dart        # Network resilience utilities
│   │
│   ├── services/                                  # Business logic and data services
│   │   ├── auth_service.dart                      # Authentication service
│   │   ├── workspace_service.dart                 # Workspace management
│   │   ├── data_service.dart                      # Main data operations
│   │   ├── unified_data_service.dart              # Unified data access layer
│   │   ├── production_data_sync_service.dart      # Production data synchronization
│   │   ├── onboarding_service.dart                # User onboarding flow
│   │   ├── analytics_data_service.dart            # Analytics data processing
│   │   ├── notification_data_service.dart         # Notification data management
│   │   └── store_data_service.dart                # E-commerce data service
│   │
│   ├── theme/                                     # Application theming
│   │   └── app_theme.dart                         # Theme configuration and styles
│   │
│   ├── widgets/                                   # Reusable UI components
│   │   ├── auth_guard_widget.dart                 # Authentication protection wrapper
│   │   ├── custom_app_bar_widget.dart             # Custom app bar implementation
│   │   ├── custom_bottom_navigation_widget.dart   # Bottom navigation component
│   │   ├── custom_enhanced_button_widget.dart     # Enhanced button component
│   │   ├── custom_form_field_widget.dart          # Form input field component
│   │   ├── custom_icon_widget.dart                # Custom icon widget
│   │   ├── custom_image_widget.dart               # Custom image widget
│   │   ├── custom_loading_widget.dart             # Loading state widget
│   │   ├── custom_error_widget.dart               # Error state widget
│   │   ├── custom_empty_state_widget.dart         # Empty state widget
│   │   └── custom_accessibility_widget.dart       # Accessibility enhancement widget
│   │
│   ├── routes/                                    # Navigation and routing
│   │   └── app_routes.dart                        # Route definitions and navigation
│   │
│   └── presentation/                              # UI layer - screens and widgets
│       ├── splash_screen/                         # App launch screen
│       ├── login_screen/                          # User authentication
│       ├── enhanced_registration_screen/          # Enhanced user registration
│       ├── forgot_password_screen/                # Password recovery
│       ├── reset_password_screen/                 # Password reset
│       ├── email_verification_screen/             # Email verification
│       ├── two_factor_authentication_screen/      # 2FA authentication
│       ├── unified_onboarding_screen/             # User onboarding flow
│       ├── user_onboarding_screen/                # Basic onboarding
│       ├── goal_selection_screen/                 # Business goal selection
│       ├── workspace_selector_screen/             # Workspace selection
│       ├── workspace_creation_screen/             # Workspace creation
│       ├── goal_based_workspace_creation_screen/  # Goal-based workspace setup
│       ├── workspace_dashboard/                   # Basic workspace dashboard
│       ├── enhanced_workspace_dashboard/          # Main enhanced dashboard
│       ├── goal_customized_workspace_dashboard/   # Goal-specific dashboard
│       ├── social_media_manager/                  # Social media management hub
│       ├── social_media_management_hub/           # Social media overview
│       ├── social_media_scheduler/                # Content scheduling
│       ├── social_media_scheduler_screen/         # Alternative scheduler
│       ├── social_media_analytics_screen/         # Social media analytics
│       ├── premium_social_media_hub/              # Premium social features
│       ├── link_in_bio_builder/                   # Link in bio creation
│       ├── link_in_bio_templates_screen/          # Link templates
│       ├── link_in_bio_analytics_screen/          # Link analytics
│       ├── content_templates_screen/              # Content templates
│       ├── content_calendar_screen/               # Content calendar
│       ├── hashtag_research_screen/               # Hashtag research tool
│       ├── multi_platform_posting_screen/         # Cross-platform posting
│       ├── qr_code_generator_screen/              # QR code generation
│       ├── analytics_dashboard/                   # Analytics overview
│       ├── unified_analytics_screen/              # Unified analytics view
│       ├── crm_contact_management/                # CRM contact management
│       ├── advanced_crm_management_hub/           # Advanced CRM features
│       ├── instagram_lead_search/                 # Instagram lead generation
│       ├── email_marketing_campaign/              # Email marketing tools
│       ├── marketplace_store/                     # E-commerce marketplace
│       ├── course_creator/                        # Course creation tools
│       ├── settings_screen/                       # App settings
│       ├── unified_settings_screen/               # Unified settings
│       ├── settings_account_management/           # Account management
│       ├── profile_settings_screen/               # User profile settings
│       ├── account_settings_screen/               # Account settings
│       ├── security_settings_screen/              # Security settings
│       ├── notification_settings_screen/          # Notification preferences
│       ├── workspace_settings_screen/             # Workspace configuration
│       ├── role_based_access_control_screen/      # RBAC management
│       ├── users_team_management_screen/          # Team management
│       ├── team_member_invitation_screen/         # Team invitations
│       ├── post_creation_team_invitation_screen/  # Post-creation team setup
│       ├── setup_progress_screen/                 # Setup progress tracking
│       ├── contact_us_screen/                     # Support contact
│       ├── terms_of_service_screen/               # Legal terms
│       ├── privacy_policy_screen/                 # Privacy policy
│       ├── app_store_optimization_screen/         # ASO tools
│       ├── production_release_checklist_screen/   # Production checklist
│       └── professional_readme_documentation_screen/ # Documentation tools
│
├── android/                                       # Android platform configuration
│   ├── app/                                       # Android app configuration
│   │   ├── build.gradle                           # Android build configuration
│   │   ├── src/main/AndroidManifest.xml           # Android manifest
│   │   ├── src/main/kotlin/com/mewayz/app/MainActivity.kt # Main activity
│   │   └── src/main/res/                          # Android resources
│   ├── gradle.properties                          # Gradle properties
│   ├── key.properties                             # Signing key properties
│   └── local.properties                           # Local configuration
│
├── ios/                                           # iOS platform configuration
│   ├── Runner/                                    # iOS app configuration
│   │   ├── Info.plist                             # iOS info plist
│   │   ├── AppDelegate.swift                      # App delegate
│   │   └── Assets.xcassets/                       # iOS assets
│   ├── Podfile                                    # iOS dependencies
│   └── Runner.xcodeproj/                          # Xcode project
│
├── web/                                           # Web platform configuration
│   ├── index.html                                 # Web entry point
│   ├── manifest.json                              # Web app manifest
│   └── icons/                                     # Web icons
│
├── assets/                                        # Static assets
│   └── images/                                    # Application images
│
├── supabase/                                      # Supabase configuration
│   └── migrations/                                # Database migrations
│       ├── 20241216120000_mewayz_goal_based_onboarding.sql
│       ├── 20241217120000_mewayz_authentication_system.sql
│       ├── 20241218120000_mewayz_session_management.sql
│       ├── 20241219120000_mewayz_workspace_management.sql
│       ├── 20241219120000_workspace_management_system.sql
│       ├── 20241220120000_mewayz_auth_guards_and_data_removal.sql
│       ├── 20241221120000_fix_workspace_analytics_deletion.sql
│       ├── 20250109161640_analytics_notifications_store_integration.sql
│       ├── 20250109170000_production_ready_data_sync.sql
│       └── 20250109170001_fix_concurrent_index_creation.sql
│
├── scripts/                                       # Build and deployment scripts
│   ├── deploy_android.sh                          # Android deployment
│   ├── deploy_ios.sh                              # iOS deployment
│   └── validate_production.sh                     # Production validation
│
├── fastlane/                                      # Fastlane configuration
│   └── Fastfile                                   # Fastlane deployment
│
└── docs/                                          # Documentation
    └── PRODUCTION_DEPLOYMENT.md                   # Production deployment guide
```

---

## 🔑 API Keys & Environment Configuration

### Required Environment Variables

The application requires the following environment variables for full functionality. All environment variables are accessed using `String.fromEnvironment()` for security:

#### Core Configuration
```bash
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-supabase-anon-key
SUPABASE_SERVICE_KEY=your-supabase-service-key
ENCRYPTION_KEY=your-32-character-encryption-key
JWT_SECRET=your-jwt-secret
API_SECRET_KEY=your-api-secret-key
ENVIRONMENT=production
DEBUG_MODE=false
```

#### OAuth Authentication
```bash
GOOGLE_CLIENT_ID=your-google-client-id
GOOGLE_CLIENT_SECRET=your-google-client-secret
APPLE_CLIENT_ID=com.mewayz.app
APPLE_TEAM_ID=your-apple-team-id
APPLE_KEY_ID=your-apple-key-id
APPLE_PRIVATE_KEY=your-apple-private-key
```

#### Social Media APIs
```bash
INSTAGRAM_CLIENT_ID=your-instagram-client-id
INSTAGRAM_CLIENT_SECRET=your-instagram-client-secret
FACEBOOK_APP_ID=your-facebook-app-id
FACEBOOK_APP_SECRET=your-facebook-app-secret
TWITTER_API_KEY=your-twitter-api-key
TWITTER_API_SECRET=your-twitter-api-secret
TWITTER_BEARER_TOKEN=your-twitter-bearer-token
LINKEDIN_CLIENT_ID=your-linkedin-client-id
LINKEDIN_CLIENT_SECRET=your-linkedin-client-secret
YOUTUBE_API_KEY=your-youtube-api-key
TIKTOK_CLIENT_ID=your-tiktok-client-id
TIKTOK_CLIENT_SECRET=your-tiktok-client-secret
```

#### Payment Processing
```bash
STRIPE_PUBLISHABLE_KEY=pk_live_your-stripe-publishable-key
STRIPE_SECRET_KEY=sk_live_your-stripe-secret-key
STRIPE_WEBHOOK_SECRET=whsec_your-webhook-secret
PAYPAL_CLIENT_ID=your-paypal-client-id
PAYPAL_CLIENT_SECRET=your-paypal-client-secret
```

#### Communication Services
```bash
SENDGRID_API_KEY=SG.your-sendgrid-api-key
MAILGUN_API_KEY=your-mailgun-api-key
MAILGUN_DOMAIN=your-mailgun-domain
TWILIO_ACCOUNT_SID=your-twilio-account-sid
TWILIO_AUTH_TOKEN=your-twilio-auth-token
TWILIO_PHONE_NUMBER=your-twilio-phone-number
```

#### Cloud Storage
```bash
CLOUDINARY_CLOUD_NAME=your-cloudinary-cloud-name
CLOUDINARY_API_KEY=your-cloudinary-api-key
CLOUDINARY_API_SECRET=your-cloudinary-api-secret
AWS_ACCESS_KEY_ID=your-aws-access-key
AWS_SECRET_ACCESS_KEY=your-aws-secret-key
AWS_REGION=us-east-1
AWS_S3_BUCKET=your-s3-bucket-name
```

#### Analytics & Monitoring
```bash
FIREBASE_PROJECT_ID=your-firebase-project-id
FIREBASE_API_KEY=your-firebase-api-key
MIXPANEL_TOKEN=your-mixpanel-token
SENTRY_DSN=your-sentry-dsn
AMPLITUDE_API_KEY=your-amplitude-api-key
```

#### Push Notifications
```bash
FCM_SERVER_KEY=your-fcm-server-key
APNS_KEY_ID=your-apns-key-id
APNS_TEAM_ID=your-apns-team-id
APNS_BUNDLE_ID=com.mewayz.app
APNS_PRIVATE_KEY=your-apns-private-key
```

#### App Store Configuration
```bash
APP_STORE_CONNECT_API_KEY=your-app-store-connect-key
APP_STORE_CONNECT_ISSUER_ID=your-issuer-id
APP_STORE_CONNECT_KEY_ID=your-key-id
GOOGLE_PLAY_SERVICE_ACCOUNT_JSON=your-service-account-json
```

### Environment Setup Instructions

1. **Create Environment File:**
   ```bash
   cp env.json.example env.json
   ```

2. **Configure Build with Environment Variables:**
   ```bash
   flutter build appbundle --release \
     --dart-define=SUPABASE_URL=$SUPABASE_URL \
     --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY \
     --dart-define=ENVIRONMENT=production \
     # ... add all other environment variables
   ```

3. **Validation:** Use the production validation script to ensure all required variables are set:
   ```bash
   ./scripts/validate_production.sh
   ```

### Environment Variable Usage in Code

All environment variables are accessed securely using:
```dart
const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const String supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');
const String environment = String.fromEnvironment('ENVIRONMENT', defaultValue: 'development');
const bool isProduction = String.fromEnvironment('ENVIRONMENT') == 'production';
const bool debugMode = String.fromEnvironment('DEBUG_MODE', defaultValue: 'true') == 'true';
```

---

## 🚀 Setup & Installation Instructions

### Prerequisites
- **Flutter SDK**: 3.16 or higher
- **Dart SDK**: 3.2 or higher
- **Android Studio**: Latest version (for Android development)
- **Xcode**: Latest version (for iOS development, macOS only)
- **Git**: Version control
- **Supabase Account**: For backend services

### Installation Steps

1. **Clone Repository:**
   ```bash
   git clone https://github.com/your-org/mewayz.git
   cd mewayz
   ```

2. **Install Flutter Dependencies:**
   ```bash
   flutter pub get
   ```

3. **Environment Configuration:**
   ```bash
   cp env.json.example env.json
   # Edit env.json with your actual API keys and configuration
   ```

4. **Supabase Setup:**
   - Create new Supabase project
   - Copy URL and anon key to environment variables
   - Run database migrations if needed

5. **OAuth Setup:**
   - Configure Google OAuth in Google Cloud Console
   - Configure Apple Sign-In in Apple Developer Console
   - Add redirect URIs: `com.mewayz.app://login-callback`

6. **Run Application:**
   ```bash
   flutter run --dart-define-from-file=env.json
   ```

### Development Environment Setup

1. **Enable Developer Options:**
   ```bash
   export ENVIRONMENT=development
   export DEBUG_MODE=true
   export ENABLE_LOGGING=true
   ```

2. **Hot Reload Development:**
   ```bash
   flutter run --hot --dart-define-from-file=env.json
   ```

3. **Testing:**
   ```bash
   flutter test
   flutter test --coverage
   ```

---

## 🌊 User Flow & Screen Accessibility

### Authentication Flow

#### Public Access (No Authentication Required)
- **Splash Screen** (`/splash-screen`)
  - App launch and initialization
  - Automatic redirect based on auth status

- **Login Screen** (`/login-screen`)
  - Email/password authentication
  - Google OAuth sign-in
  - Apple Sign-In
  - Biometric authentication (if enabled)
  - "Forgot Password" link
  - "Create Account" link

- **Registration Screens**
  - **Enhanced Registration** (`/enhanced-registration-screen`)
    - Email, password, full name input
    - Password strength indicator
    - Terms and privacy acceptance
    - Social registration options
  - **Email Verification** (`/email-verification-screen`)
    - 6-digit verification code input
    - Resend verification option

- **Password Recovery**
  - **Forgot Password** (`/forgot-password-screen`)
    - Email input for password reset
  - **Reset Password** (`/reset-password-screen`)
    - New password input with strength validation

- **Legal Pages**
  - **Terms of Service** (`/terms-of-service-screen`)
  - **Privacy Policy** (`/privacy-policy-screen`)

#### Two-Factor Authentication
- **2FA Screen** (`/two-factor-authentication-screen`)
  - SMS verification
  - Email verification
  - Authenticator app verification
  - Backup codes management

### Post-Authentication Flow

#### Workspace Management (Authenticated Users Only)
- **Goal Selection** (`/goal-selection-screen`)
  - Business goal selection (Social Media, E-commerce, Course Creation, etc.)
  - Custom goal input option

- **Workspace Creation**
  - **Basic Workspace Creation** (`/workspace-creation-screen`)
    - Workspace name, description, logo upload
    - Team invitation during setup
    - Template selection
  - **Goal-Based Workspace Creation** (`/goal-based-workspace-creation-screen`)
    - Goal-specific workspace setup
    - Privacy settings configuration
    - Logo upload and branding

- **Workspace Selection** (`/workspace-selector-screen`)
  - List of available workspaces
  - Recent workspaces
  - Create new workspace option
  - Empty state for new users

#### Main Application Dashboards (Authenticated + Workspace Required)

- **Enhanced Workspace Dashboard** (`/enhanced-workspace-dashboard`)
  - Primary dashboard after workspace selection
  - Hero metrics section
  - Quick actions grid
  - Recent activity feed
  - Floating action button for quick actions

- **Goal-Customized Dashboard** (`/goal-customized-workspace-dashboard`)
  - Dashboard tailored to selected business goal
  - Goal-specific metrics and features
  - Customized quick actions
  - Feature discovery widgets

#### Social Media Management (Authenticated Users)

- **Social Media Manager** (`/social-media-manager`)
  - Main social media hub
  - Connected platforms overview
  - Performance charts
  - Quick post creation modal
  - Content suggestions

- **Social Media Hub** (`/social-media-management-hub`)
  - Platform connection status
  - Recent activity
  - Analytics cards

- **Premium Social Media Hub** (`/premium-social-media-hub`)
  - Advanced social media features
  - Lead generation tools
  - Performance tracking
  - Enhanced analytics

- **Content Management**
  - **Multi-Platform Posting** (`/multi-platform-posting-screen`)
    - Cross-platform content creation
    - Media upload
    - Platform-specific customization
    - Scheduling options
  - **Social Media Scheduler** (`/social-media-scheduler`)
    - Content calendar view
    - Bulk upload modal
    - Platform status indicators
  - **Content Templates** (`/content-templates-screen`)
    - Template library
    - Template creator
    - Favorites management
    - Analytics tracking

- **Research & Analytics**
  - **Hashtag Research** (`/hashtag-research-screen`)
    - Trending hashtags
    - Hashtag analytics
    - Custom hashtag sets
    - Research filters
  - **Social Media Analytics** (`/social-media-analytics-screen`)
    - Performance metrics
    - Audience insights
    - Competitor comparison
    - Export options
  - **Instagram Lead Search** (`/instagram-lead-search`)
    - Lead discovery tools
    - Filter and export options
    - Account analysis

#### Link in Bio & QR Codes (Authenticated Users)

- **Link in Bio Management**
  - **Link Templates** (`/link-in-bio-templates-screen`)
    - Template gallery
    - Quick customization
    - Preview and favorites
  - **Link Analytics** (`/link-in-bio-analytics-screen`)
    - Performance tracking
    - Geographic analytics
    - Conversion funnels
    - Real-time tracking

- **QR Code Generator** (`/qr-code-generator-screen`)
  - QR code creation
  - Style customization
  - Analytics integration
  - Batch generation

#### CRM & Lead Management (Authenticated Users)

- **CRM Contact Management** (`/crm-contact-management`)
  - Contact list and search
  - Contact detail management
  - Import/export contacts
  - Pipeline stage tracking

- **Advanced CRM Hub** (`/advanced-crm-management-hub`)
  - Advanced contact management
  - Pipeline visualization
  - Workflow automation
  - Voice input capabilities

#### E-commerce & Courses (Authenticated Users)

- **Marketplace Store** (`/marketplace-store`)
  - Product catalog management
  - Order management
  - Analytics dashboard
  - Product addition workflow

- **Course Creator** (`/course-creator`)
  - Course content creation
  - Module management
  - Student progress tracking
  - Course settings

- **Email Marketing** (`/email-marketing-campaign`)
  - Campaign creation
  - Template library
  - Recipient management
  - Analytics tracking

#### Analytics & Reporting (Authenticated Users)

- **Analytics Dashboard** (`/analytics-dashboard`)
  - Unified analytics view
  - Chart containers
  - Date range selection
  - Export functionality

- **Unified Analytics** (`/unified-analytics-screen`)
  - Cross-platform analytics
  - Performance metrics
  - Comprehensive reporting

#### Settings & Configuration (Authenticated Users)

- **Main Settings** (`/settings-screen`)
  - Quick actions
  - Settings categories
  - Search functionality

- **Unified Settings** (`/unified-settings-screen`)
  - Comprehensive settings management
  - All configuration options

- **Profile Management**
  - **Profile Settings** (`/profile-settings-screen`)
    - Avatar upload
    - Personal information
    - Social links
    - Privacy settings
  - **Account Settings** (`/account-settings-screen`)
    - Account information
    - Security settings
    - Privacy controls

- **Security & Notifications**
  - **Security Settings** (`/security-settings-screen`)
    - Authentication methods
    - Device management
    - Security monitoring
  - **Notification Settings** (`/notification-settings-screen`)
    - Notification preferences
    - Quiet hours
    - Category settings

#### Team & Workspace Management (Workspace Owners/Admins)

- **Workspace Settings** (`/workspace-settings-screen`)
  - General workspace configuration
  - Member management
  - Integrations
  - Billing settings

- **Team Management**
  - **Users & Team Management** (`/users-team-management-screen`)
    - Team member overview
    - Role management
  - **Team Invitations** (`/team-member-invitation-screen`)
    - Send invitations
    - Bulk invitations
    - Pending invitations management
  - **Post-Creation Team Setup** (`/post-creation-team-invitation-screen`)
    - Goal-based role suggestions
    - Custom invitation messages

- **Access Control**
  - **Role-Based Access Control** (`/role-based-access-control-screen`)
    - Permission matrix
    - Custom roles
    - Audit trail

#### Development & Production Tools (Admin Users)

- **Setup & Progress**
  - **Setup Progress** (`/setup-progress-screen`)
    - Onboarding checklist
    - Progress tracking
    - Completion celebration

- **Development Tools**
  - **App Store Optimization** (`/app-store-optimization-screen`)
    - ASO tools and checklist
    - Screenshot management
    - Metadata editing
  - **Production Checklist** (`/production-release-checklist-screen`)
    - Pre-release validation
    - Security checklist
    - Performance metrics
  - **Documentation Tools** (`/professional-readme-documentation-screen`)
    - Documentation editor
    - Template library
    - Version control

#### Support & Help

- **Contact Us** (`/contact-us-screen`)
  - Support contact form
  - FAQ section
  - File attachments

### Navigation Patterns

#### Bottom Navigation (Main App)
- **Dashboard**: Primary workspace dashboard
- **Social**: Social media management hub
- **Analytics**: Analytics and reporting
- **CRM**: Contact and lead management
- **More**: Settings and additional features

#### Drawer Navigation (Secondary)
- Quick access to all major features
- User profile section
- Workspace switcher
- Settings and logout

#### Floating Action Buttons
- **Dashboard FAB**: Quick actions (post creation, contact addition, etc.)
- **Content FAB**: Quick post creation across platforms
- **CRM FAB**: Quick contact addition

### Access Control Matrix

| Screen Category | Guest Users | Authenticated | Workspace Members | Workspace Admins | Workspace Owners |
|----------------|-------------|---------------|-------------------|------------------|------------------|
| Authentication | ✅ | ❌ | ❌ | ❌ | ❌ |
| Onboarding | ❌ | ✅ | ❌ | ❌ | ❌ |
| Workspace Creation | ❌ | ✅ | ❌ | ❌ | ❌ |
| Main Dashboards | ❌ | ❌ | ✅ | ✅ | ✅ |
| Social Media Tools | ❌ | ❌ | ✅ | ✅ | ✅ |
| CRM Tools | ❌ | ❌ | ✅ | ✅ | ✅ |
| Analytics | ❌ | ❌ | ✅ | ✅ | ✅ |
| Personal Settings | ❌ | ✅ | ✅ | ✅ | ✅ |
| Workspace Settings | ❌ | ❌ | ❌ | ✅ | ✅ |
| Team Management | ❌ | ❌ | ❌ | ✅ | ✅ |
| Billing & Admin | ❌ | ❌ | ❌ | ❌ | ✅ |

---

## 🎯 Core Features & Functionality

### 1. Social Media Management
- **Multi-Platform Support**: Instagram, Facebook, Twitter, LinkedIn, YouTube, TikTok
- **Content Scheduling**: Advanced calendar with bulk upload
- **Analytics**: Performance tracking, audience insights, competitor analysis
- **Content Creation**: Templates, AI suggestions, hashtag research
- **Lead Generation**: Instagram lead search and qualification

### 2. Link in Bio Builder
- **Professional Landing Pages**: Customizable templates
- **Analytics**: Click tracking, geographic data, conversion funnels
- **QR Code Integration**: Custom QR codes with analytics
- **A/B Testing**: Performance comparison tools

### 3. CRM & Contact Management
- **Advanced Contact Management**: Import/export, custom fields
- **Pipeline Tracking**: Visual sales pipeline with stages
- **Workflow Automation**: Automated follow-ups and tasks
- **Voice Input**: Voice-to-text for quick note taking

### 4. E-commerce Integration
- **Marketplace Store**: Product catalog management
- **Payment Processing**: Stripe and PayPal integration
- **Order Management**: Order tracking and fulfillment
- **Analytics Dashboard**: Sales metrics and reporting

### 5. Email Marketing
- **Campaign Creation**: Drag-and-drop email builder
- **Template Library**: Professional email templates
- **Recipient Management**: Segmentation and targeting
- **Deliverability Tracking**: Open rates, click rates, bounces

### 6. Course Creation
- **Content Management**: Video, text, and interactive content
- **Student Progress**: Tracking and analytics
- **Module Organization**: Structured course building
- **Settings Management**: Pricing, access controls

### 7. Analytics & Reporting
- **Unified Dashboard**: Cross-platform analytics
- **Custom Reports**: Exportable insights
- **Real-time Tracking**: Live performance metrics
- **Goal Tracking**: ROI and conversion metrics

### 8. Team Collaboration
- **Role-Based Access**: Custom permission levels
- **Team Invitations**: Bulk and individual invitations
- **Audit Trail**: Activity tracking and security logs
- **Workspace Management**: Multi-workspace support

---

## 🔒 Security Features

### Authentication Security
- **Multi-Factor Authentication**: SMS, Email, Authenticator apps
- **Biometric Authentication**: TouchID, FaceID, Fingerprint
- **OAuth Integration**: Google, Apple Sign-In
- **Session Management**: Secure token handling with auto-refresh

### Data Security
- **End-to-End Encryption**: AES-256 encryption for sensitive data
- **Certificate Pinning**: Secure API communications
- **Input Validation**: Comprehensive data sanitization
- **Secure Storage**: Encrypted local data storage

### Privacy Controls
- **GDPR Compliance**: Data deletion and export capabilities
- **Privacy Settings**: Granular privacy controls
- **Data Minimization**: Only collect necessary data
- **Audit Logging**: Complete activity audit trail

---

## 📱 Platform-Specific Features

### iOS Features
- **Apple Sign-In**: Native Apple authentication
- **iOS Design Language**: Native iOS UI components
- **App Store Optimization**: ASO tools for iOS
- **Push Notifications**: APNs integration

### Android Features
- **Material Design**: Google's Material Design 3
- **Google Sign-In**: Native Google authentication
- **Play Store Optimization**: ASO tools for Android
- **Firebase Integration**: FCM push notifications

### Cross-Platform Features
- **Responsive Design**: Adaptive UI for all screen sizes
- **Dark/Light Theme**: System-aware theming
- **Offline Mode**: Local storage with sync capability
- **Performance Optimization**: Efficient memory and battery usage

---

## 🚀 Production Deployment

### App Store Distribution

#### Apple App Store
- **Bundle ID**: `com.mewayz.app`
- **Target OS**: iOS 12.0+
- **Required Capabilities**: Camera, Microphone, Location (optional)
- **Privacy Usage Descriptions**: Camera, Photo Library, Microphone

#### Google Play Store
- **Package Name**: `com.mewayz.app`
- **Target SDK**: Android API 33+
- **Required Permissions**: Camera, Storage, Network
- **Play Console Setup**: Complete with screenshots and descriptions

### Build Configuration

#### Environment Variables
All sensitive configuration managed through environment variables and accessed via `String.fromEnvironment()`:
- Supabase configuration
- OAuth credentials
- API keys for social platforms
- Payment processor keys
- Analytics and monitoring tokens

#### Build Commands
```bash
# Android Production Build
flutter build appbundle --release \
  --dart-define-from-file=env.json \
  --obfuscate \
  --split-debug-info=build/debug-symbols

# iOS Production Build
flutter build ipa --release \
  --dart-define-from-file=env.json \
  --obfuscate \
  --split-debug-info=build/debug-symbols
```

### Monitoring & Analytics
- **Crash Reporting**: Firebase Crashlytics
- **Performance Monitoring**: Firebase Performance
- **User Analytics**: Mixpanel, Firebase Analytics
- **Error Tracking**: Sentry integration
- **App Store Monitoring**: Review and rating tracking

---

## 🛠️ Known Issues & Fixes

### Authentication Service Issues
Several authentication methods in `AuthService` are referenced but not implemented:
- `isUserLoggedIn()` method
- `authenticateWithBiometrics()` method

### Supabase Service Access Issues
- `SupabaseService` class lacks proper singleton implementation
- Constructor access issues in login screen

### Navigation Issues
- Some screen routing may need adjustment based on authentication state
- Deep linking setup for OAuth callbacks

### Environment Configuration Issues
- Missing proper validation for required environment variables
- Need for comprehensive environment variable documentation

---

## 📞 Support & Documentation

### Support Channels
- **Email**: support@mewayz.com
- **Website**: https://mewayz.com
- **Documentation**: https://docs.mewayz.com
- **Status Page**: https://status.mewayz.com

### Legal & Compliance
- **Privacy Policy**: https://mewayz.com/privacy-policy
- **Terms of Service**: https://mewayz.com/terms-of-service
- **GDPR Compliance**: Full data protection compliance
- **CCPA Compliance**: California privacy law compliance

### Development Resources
- **API Documentation**: Comprehensive Supabase API docs
- **Widget Library**: Reusable component documentation
- **Architecture Guide**: Clean architecture implementation
- **Testing Guide**: Unit, widget, and integration testing

---

## 🎯 Performance Metrics

### App Performance Targets
- **App Launch Time**: < 3 seconds
- **Memory Usage**: < 150MB average
- **Battery Usage**: Minimal background consumption
- **Network Efficiency**: Optimized API calls with caching

### Success Metrics
- **User Retention**: > 70% day-1, > 40% day-7, > 20% day-30
- **App Store Rating**: > 4.2 stars
- **Crash Rate**: < 0.5%
- **Performance Score**: > 90% (Lighthouse/Firebase)

---

## 🔧 Database Schema

### Supabase Integration
The application uses Supabase as the backend with PostgreSQL database. Current migrations include:

1. **Goal-Based Onboarding** (20241216120000)
2. **Authentication System** (20241217120000)
3. **Session Management** (20241218120000)
4. **Workspace Management** (20241219120000)
5. **Auth Guards and Data Removal** (20241220120000)
6. **Analytics, Notifications & Store Integration** (20250109161640)
7. **Production-Ready Data Sync** (20250109170000)

### Key Tables
- **user_profiles**: User information and preferences
- **workspaces**: Workspace management
- **social_media_accounts**: Connected social platforms
- **content_posts**: Social media content
- **analytics_data**: Performance metrics
- **crm_contacts**: Customer relationship data
- **marketplace_products**: E-commerce products
- **email_campaigns**: Marketing campaigns

---

## 🔄 Development Workflow

### Code Standards
- **Architecture**: Clean Architecture with Repository Pattern
- **State Management**: Optimized state management with Provider/Riverpod compatibility
- **Error Handling**: Comprehensive error handling with user-friendly messages
- **Accessibility**: Full accessibility support with semantic widgets
- **Performance**: Optimized performance with lazy loading and caching

### Testing Strategy
- **Unit Tests**: Core business logic testing
- **Widget Tests**: UI component testing
- **Integration Tests**: End-to-end flow testing
- **Performance Tests**: Memory and performance validation

### CI/CD Pipeline
- **Code Quality**: Automated linting and analysis
- **Testing**: Automated test execution
- **Build**: Automated builds for multiple platforms
- **Deployment**: Automated deployment to app stores

---

This documentation provides a complete overview of the Mewayz mobile application, covering all technical aspects, user flows, known issues, and production requirements. The application is production-ready with comprehensive features for social media management, CRM, e-commerce, and team collaboration.

**Last Updated**: January 10, 2025
**Documentation Version**: 2.0.0
**Status**: Production Ready with Known Issues Documented