#!/bin/bash

# Mewayz Production Build Script
# This script builds the app for production deployment

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Starting Mewayz Production Build...${NC}"

# Check if .env file exists
if [ ! -f .env ]; then
    echo -e "${RED}❌ Error: .env file not found!${NC}"
    echo -e "${YELLOW}Please copy .env.example to .env and fill in your production values${NC}"
    exit 1
fi

# Load environment variables
source .env

# Validate environment variables
if [ -z "$SUPABASE_URL" ] || [ -z "$SUPABASE_ANON_KEY" ]; then
    echo -e "${RED}❌ Error: Supabase configuration missing in .env${NC}"
    exit 1
fi

if [ -z "$ENCRYPTION_KEY" ] || [ ${#ENCRYPTION_KEY} -lt 32 ]; then
    echo -e "${RED}❌ Error: Encryption key missing or too short in .env${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Environment configuration validated${NC}"

# Clean previous builds
echo -e "${BLUE}🧹 Cleaning previous builds...${NC}"
flutter clean
flutter pub get

# Generate build files
echo -e "${BLUE}🔧 Generating build files...${NC}"
flutter pub run build_runner build --delete-conflicting-outputs

# Build Android App Bundle
echo -e "${BLUE}🤖 Building Android App Bundle...${NC}"
flutter build appbundle --release \
    --dart-define=SUPABASE_URL="$SUPABASE_URL" \
    --dart-define=SUPABASE_ANON_KEY="$SUPABASE_ANON_KEY" \
    --dart-define=ENCRYPTION_KEY="$ENCRYPTION_KEY" \
    --dart-define=GOOGLE_CLIENT_ID="$GOOGLE_CLIENT_ID" \
    --dart-define=APPLE_CLIENT_ID="$APPLE_CLIENT_ID" \
    --dart-define=ENVIRONMENT="$ENVIRONMENT" \
    --dart-define=DEBUG_MODE="$DEBUG_MODE" \
    --dart-define=ENABLE_LOGGING="$ENABLE_LOGGING" \
    --dart-define=LOG_LEVEL="$LOG_LEVEL" \
    --dart-define=FIREBASE_PROJECT_ID="$FIREBASE_PROJECT_ID" \
    --dart-define=MIXPANEL_TOKEN="$MIXPANEL_TOKEN" \
    --dart-define=STRIPE_PUBLISHABLE_KEY="$STRIPE_PUBLISHABLE_KEY" \
    --dart-define=SENDGRID_API_KEY="$SENDGRID_API_KEY" \
    --dart-define=TWILIO_ACCOUNT_SID="$TWILIO_ACCOUNT_SID" \
    --dart-define=CLOUDINARY_CLOUD_NAME="$CLOUDINARY_CLOUD_NAME" \
    --dart-define=API_BASE_URL="$API_BASE_URL" \
    --dart-define=CDN_BASE_URL="$CDN_BASE_URL" \
    --dart-define=PRIVACY_POLICY_URL="$PRIVACY_POLICY_URL" \
    --dart-define=TERMS_OF_SERVICE_URL="$TERMS_OF_SERVICE_URL" \
    --dart-define=SUPPORT_URL="$SUPPORT_URL" \
    --obfuscate \
    --split-debug-info=build/app/outputs/symbols

echo -e "${GREEN}✅ Android App Bundle built successfully${NC}"

# Build Android APK (for testing)
echo -e "${BLUE}📱 Building Android APK...${NC}"
flutter build apk --release \
    --dart-define=SUPABASE_URL="$SUPABASE_URL" \
    --dart-define=SUPABASE_ANON_KEY="$SUPABASE_ANON_KEY" \
    --dart-define=ENCRYPTION_KEY="$ENCRYPTION_KEY" \
    --dart-define=GOOGLE_CLIENT_ID="$GOOGLE_CLIENT_ID" \
    --dart-define=APPLE_CLIENT_ID="$APPLE_CLIENT_ID" \
    --dart-define=ENVIRONMENT="$ENVIRONMENT" \
    --dart-define=DEBUG_MODE="$DEBUG_MODE" \
    --dart-define=ENABLE_LOGGING="$ENABLE_LOGGING" \
    --dart-define=LOG_LEVEL="$LOG_LEVEL" \
    --dart-define=FIREBASE_PROJECT_ID="$FIREBASE_PROJECT_ID" \
    --dart-define=MIXPANEL_TOKEN="$MIXPANEL_TOKEN" \
    --dart-define=STRIPE_PUBLISHABLE_KEY="$STRIPE_PUBLISHABLE_KEY" \
    --dart-define=SENDGRID_API_KEY="$SENDGRID_API_KEY" \
    --dart-define=TWILIO_ACCOUNT_SID="$TWILIO_ACCOUNT_SID" \
    --dart-define=CLOUDINARY_CLOUD_NAME="$CLOUDINARY_CLOUD_NAME" \
    --dart-define=API_BASE_URL="$API_BASE_URL" \
    --dart-define=CDN_BASE_URL="$CDN_BASE_URL" \
    --dart-define=PRIVACY_POLICY_URL="$PRIVACY_POLICY_URL" \
    --dart-define=TERMS_OF_SERVICE_URL="$TERMS_OF_SERVICE_URL" \
    --dart-define=SUPPORT_URL="$SUPPORT_URL" \
    --obfuscate \
    --split-debug-info=build/app/outputs/symbols

echo -e "${GREEN}✅ Android APK built successfully${NC}"

# Build iOS IPA (only on macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo -e "${BLUE}🍎 Building iOS IPA...${NC}"
    flutter build ipa --release \
        --dart-define=SUPABASE_URL="$SUPABASE_URL" \
        --dart-define=SUPABASE_ANON_KEY="$SUPABASE_ANON_KEY" \
        --dart-define=ENCRYPTION_KEY="$ENCRYPTION_KEY" \
        --dart-define=GOOGLE_CLIENT_ID="$GOOGLE_CLIENT_ID" \
        --dart-define=APPLE_CLIENT_ID="$APPLE_CLIENT_ID" \
        --dart-define=ENVIRONMENT="$ENVIRONMENT" \
        --dart-define=DEBUG_MODE="$DEBUG_MODE" \
        --dart-define=ENABLE_LOGGING="$ENABLE_LOGGING" \
        --dart-define=LOG_LEVEL="$LOG_LEVEL" \
        --dart-define=FIREBASE_PROJECT_ID="$FIREBASE_PROJECT_ID" \
        --dart-define=MIXPANEL_TOKEN="$MIXPANEL_TOKEN" \
        --dart-define=STRIPE_PUBLISHABLE_KEY="$STRIPE_PUBLISHABLE_KEY" \
        --dart-define=SENDGRID_API_KEY="$SENDGRID_API_KEY" \
        --dart-define=TWILIO_ACCOUNT_SID="$TWILIO_ACCOUNT_SID" \
        --dart-define=CLOUDINARY_CLOUD_NAME="$CLOUDINARY_CLOUD_NAME" \
        --dart-define=API_BASE_URL="$API_BASE_URL" \
        --dart-define=CDN_BASE_URL="$CDN_BASE_URL" \
        --dart-define=PRIVACY_POLICY_URL="$PRIVACY_POLICY_URL" \
        --dart-define=TERMS_OF_SERVICE_URL="$TERMS_OF_SERVICE_URL" \
        --dart-define=SUPPORT_URL="$SUPPORT_URL" \
        --obfuscate \
        --split-debug-info=build/ios/symbols

    echo -e "${GREEN}✅ iOS IPA built successfully${NC}"
else
    echo -e "${YELLOW}⚠️ iOS build skipped (not running on macOS)${NC}"
fi

# Generate build summary
echo -e "${BLUE}📊 Build Summary:${NC}"
echo "=================================="
echo "App Name: $APP_NAME"
echo "Version: $APP_VERSION"
echo "Build Number: $BUILD_NUMBER"
echo "Environment: $ENVIRONMENT"
echo "Build Date: $(date)"
echo "=================================="

# List generated files
echo -e "${BLUE}📁 Generated Files:${NC}"
if [ -f "build/app/outputs/bundle/release/app-release.aab" ]; then
    echo -e "${GREEN}✅ Android App Bundle: build/app/outputs/bundle/release/app-release.aab${NC}"
fi

if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
    echo -e "${GREEN}✅ Android APK: build/app/outputs/flutter-apk/app-release.apk${NC}"
fi

if [ -f "build/ios/ipa/mewayz.ipa" ]; then
    echo -e "${GREEN}✅ iOS IPA: build/ios/ipa/mewayz.ipa${NC}"
fi

echo -e "${GREEN}🎉 Production build completed successfully!${NC}"
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Test the builds on physical devices"
echo "2. Run './scripts/validate_production.sh' to validate"
echo "3. Deploy using './scripts/deploy_android.sh' and './scripts/deploy_ios.sh'"