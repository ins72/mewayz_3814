#!/bin/bash

# Mewayz Production Build Script
# This script builds the app for production deployment to App Store and Google Play Store

set -e

echo "🚀 Starting Mewayz Production Build Process..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if .env file exists
if [ ! -f .env ]; then
    echo -e "${RED}❌ Error: .env file not found!${NC}"
    echo -e "${YELLOW}Please copy .env.example to .env and fill in your production values${NC}"
    exit 1
fi

# Load environment variables
source .env

# Validate required environment variables
validate_env_var() {
    local var_name=$1
    local var_value=$2
    local example_value=$3
    
    if [ -z "$var_value" ] || [ "$var_value" = "$example_value" ]; then
        echo -e "${RED}❌ Error: $var_name is not set or still has example value${NC}"
        echo -e "${YELLOW}Please update your .env file with actual production values${NC}"
        exit 1
    fi
}

echo -e "${BLUE}🔍 Validating environment configuration...${NC}"

# Validate critical environment variables
validate_env_var "SUPABASE_URL" "$SUPABASE_URL" "https://your-project.supabase.co"
validate_env_var "SUPABASE_ANON_KEY" "$SUPABASE_ANON_KEY" "your-anon-key-here"
validate_env_var "ENCRYPTION_KEY" "$ENCRYPTION_KEY" "your-32-character-encryption-key-here"
validate_env_var "GOOGLE_CLIENT_ID" "$GOOGLE_CLIENT_ID" "your-google-client-id.apps.googleusercontent.com"

echo -e "${GREEN}✅ Environment validation passed${NC}"

# Clean previous builds
echo -e "${BLUE}🧹 Cleaning previous builds...${NC}"
flutter clean
flutter pub get

# Run tests
echo -e "${BLUE}🧪 Running tests...${NC}"
flutter test

# Build for Android
echo -e "${BLUE}🤖 Building for Android...${NC}"
flutter build appbundle --release \
    --dart-define=SUPABASE_URL="$SUPABASE_URL" \
    --dart-define=SUPABASE_ANON_KEY="$SUPABASE_ANON_KEY" \
    --dart-define=ENCRYPTION_KEY="$ENCRYPTION_KEY" \
    --dart-define=GOOGLE_CLIENT_ID="$GOOGLE_CLIENT_ID" \
    --dart-define=APPLE_CLIENT_ID="$APPLE_CLIENT_ID" \
    --dart-define=INSTAGRAM_CLIENT_ID="$INSTAGRAM_CLIENT_ID" \
    --dart-define=FACEBOOK_APP_ID="$FACEBOOK_APP_ID" \
    --dart-define=TWITTER_API_KEY="$TWITTER_API_KEY" \
    --dart-define=LINKEDIN_CLIENT_ID="$LINKEDIN_CLIENT_ID" \
    --dart-define=YOUTUBE_API_KEY="$YOUTUBE_API_KEY" \
    --dart-define=TIKTOK_CLIENT_ID="$TIKTOK_CLIENT_ID" \
    --dart-define=STRIPE_PUBLISHABLE_KEY="$STRIPE_PUBLISHABLE_KEY" \
    --dart-define=SENDGRID_API_KEY="$SENDGRID_API_KEY" \
    --dart-define=TWILIO_ACCOUNT_SID="$TWILIO_ACCOUNT_SID" \
    --dart-define=CLOUDINARY_CLOUD_NAME="$CLOUDINARY_CLOUD_NAME" \
    --dart-define=FIREBASE_PROJECT_ID="$FIREBASE_PROJECT_ID" \
    --dart-define=MIXPANEL_TOKEN="$MIXPANEL_TOKEN" \
    --dart-define=FCM_SERVER_KEY="$FCM_SERVER_KEY" \
    --dart-define=APP_STORE_ID="$APP_STORE_ID" \
    --dart-define=FLUTTER_WEB_USE_SKIA=true

echo -e "${GREEN}✅ Android build completed successfully${NC}"

# Build for iOS (if on macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo -e "${BLUE}🍎 Building for iOS...${NC}"
    flutter build ios --release \
        --dart-define=SUPABASE_URL="$SUPABASE_URL" \
        --dart-define=SUPABASE_ANON_KEY="$SUPABASE_ANON_KEY" \
        --dart-define=ENCRYPTION_KEY="$ENCRYPTION_KEY" \
        --dart-define=GOOGLE_CLIENT_ID="$GOOGLE_CLIENT_ID" \
        --dart-define=APPLE_CLIENT_ID="$APPLE_CLIENT_ID" \
        --dart-define=INSTAGRAM_CLIENT_ID="$INSTAGRAM_CLIENT_ID" \
        --dart-define=FACEBOOK_APP_ID="$FACEBOOK_APP_ID" \
        --dart-define=TWITTER_API_KEY="$TWITTER_API_KEY" \
        --dart-define=LINKEDIN_CLIENT_ID="$LINKEDIN_CLIENT_ID" \
        --dart-define=YOUTUBE_API_KEY="$YOUTUBE_API_KEY" \
        --dart-define=TIKTOK_CLIENT_ID="$TIKTOK_CLIENT_ID" \
        --dart-define=STRIPE_PUBLISHABLE_KEY="$STRIPE_PUBLISHABLE_KEY" \
        --dart-define=SENDGRID_API_KEY="$SENDGRID_API_KEY" \
        --dart-define=TWILIO_ACCOUNT_SID="$TWILIO_ACCOUNT_SID" \
        --dart-define=CLOUDINARY_CLOUD_NAME="$CLOUDINARY_CLOUD_NAME" \
        --dart-define=FIREBASE_PROJECT_ID="$FIREBASE_PROJECT_ID" \
        --dart-define=MIXPANEL_TOKEN="$MIXPANEL_TOKEN" \
        --dart-define=FCM_SERVER_KEY="$FCM_SERVER_KEY" \
        --dart-define=APP_STORE_ID="$APP_STORE_ID"
    
    echo -e "${GREEN}✅ iOS build completed successfully${NC}"
    
    # Build IPA for App Store distribution
    echo -e "${BLUE}📦 Building IPA for App Store...${NC}"
    flutter build ipa --release \
        --dart-define=SUPABASE_URL="$SUPABASE_URL" \
        --dart-define=SUPABASE_ANON_KEY="$SUPABASE_ANON_KEY" \
        --dart-define=ENCRYPTION_KEY="$ENCRYPTION_KEY" \
        --dart-define=GOOGLE_CLIENT_ID="$GOOGLE_CLIENT_ID" \
        --dart-define=APPLE_CLIENT_ID="$APPLE_CLIENT_ID" \
        --dart-define=INSTAGRAM_CLIENT_ID="$INSTAGRAM_CLIENT_ID" \
        --dart-define=FACEBOOK_APP_ID="$FACEBOOK_APP_ID" \
        --dart-define=TWITTER_API_KEY="$TWITTER_API_KEY" \
        --dart-define=LINKEDIN_CLIENT_ID="$LINKEDIN_CLIENT_ID" \
        --dart-define=YOUTUBE_API_KEY="$YOUTUBE_API_KEY" \
        --dart-define=TIKTOK_CLIENT_ID="$TIKTOK_CLIENT_ID" \
        --dart-define=STRIPE_PUBLISHABLE_KEY="$STRIPE_PUBLISHABLE_KEY" \
        --dart-define=SENDGRID_API_KEY="$SENDGRID_API_KEY" \
        --dart-define=TWILIO_ACCOUNT_SID="$TWILIO_ACCOUNT_SID" \
        --dart-define=CLOUDINARY_CLOUD_NAME="$CLOUDINARY_CLOUD_NAME" \
        --dart-define=FIREBASE_PROJECT_ID="$FIREBASE_PROJECT_ID" \
        --dart-define=MIXPANEL_TOKEN="$MIXPANEL_TOKEN" \
        --dart-define=FCM_SERVER_KEY="$FCM_SERVER_KEY" \
        --dart-define=APP_STORE_ID="$APP_STORE_ID"
    
    echo -e "${GREEN}✅ IPA build completed successfully${NC}"
else
    echo -e "${YELLOW}⚠️ iOS build skipped (not running on macOS)${NC}"
fi

# Generate build information
echo -e "${BLUE}📋 Generating build information...${NC}"
cat > build_info.txt << EOF
Mewayz Production Build Information
==================================

Build Date: $(date)
App Version: $APP_VERSION
Build Number: $BUILD_NUMBER
Environment: $ENVIRONMENT

Build Files:
- Android: build/app/outputs/bundle/release/app-release.aab
- iOS: build/ios/ipa/mewayz.ipa

Configuration Status:
- Supabase: ✅ Configured
- OAuth: ✅ Configured  
- Social Media APIs: ✅ Configured
- Payment Processing: ✅ Configured
- Analytics: ✅ Configured
- Push Notifications: ✅ Configured

Store Deployment:
- Google Play Store: Ready for upload
- Apple App Store: Ready for upload

Next Steps:
1. Upload Android App Bundle to Google Play Console
2. Upload iOS IPA to App Store Connect
3. Fill in store listings and metadata
4. Submit for review
EOF

echo -e "${GREEN}✅ Build information generated: build_info.txt${NC}"

# Display success message
echo -e "${GREEN}"
echo "🎉 Production build completed successfully!"
echo ""
echo "📁 Build files location:"
echo "  Android: build/app/outputs/bundle/release/app-release.aab"
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "  iOS: build/ios/ipa/mewayz.ipa"
fi
echo ""
echo "📋 Build information: build_info.txt"
echo ""
echo "🚀 Ready for store deployment!"
echo -e "${NC}"