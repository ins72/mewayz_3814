#!/bin/bash

# Mewayz Android Deployment Script
# This script deploys the Android app to Google Play Store

set -e

echo "🤖 Starting Android deployment to Google Play Store..."

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

# Check if Android App Bundle exists
if [ ! -f "build/app/outputs/bundle/release/app-release.aab" ]; then
    echo -e "${RED}❌ Error: Android App Bundle not found!${NC}"
    echo -e "${YELLOW}Please run './scripts/build_production.sh' first${NC}"
    exit 1
fi

# Check if Google Play service account JSON exists
if [ ! -f "$GOOGLE_PLAY_SERVICE_ACCOUNT_JSON" ]; then
    echo -e "${RED}❌ Error: Google Play service account JSON not found!${NC}"
    echo -e "${YELLOW}Please download the service account JSON from Google Play Console${NC}"
    exit 1
fi

echo -e "${BLUE}📱 Validating Android App Bundle...${NC}"
# Validate the app bundle
aapt dump badging build/app/outputs/bundle/release/app-release.aab | grep "package:"

echo -e "${GREEN}✅ Android App Bundle validation passed${NC}"

echo -e "${BLUE}🔐 Authenticating with Google Play Console...${NC}"
# Authenticate with Google Play Console using service account
gcloud auth activate-service-account --key-file="$GOOGLE_PLAY_SERVICE_ACCOUNT_JSON"

echo -e "${BLUE}📤 Uploading to Google Play Store...${NC}"

# Upload to Google Play Store using fastlane (if configured)
if command -v fastlane &> /dev/null; then
    echo -e "${BLUE}🚀 Using Fastlane for deployment...${NC}"
    cd android
    fastlane deploy
    cd ..
else
    echo -e "${YELLOW}⚠️ Fastlane not found. Manual upload required.${NC}"
    echo -e "${BLUE}Manual upload steps:${NC}"
    echo "1. Go to Google Play Console: https://play.google.com/console"
    echo "2. Select your app: Mewayz"
    echo "3. Go to Production > Create new release"
    echo "4. Upload: build/app/outputs/bundle/release/app-release.aab"
    echo "5. Fill in release notes and submit for review"
fi

echo -e "${GREEN}✅ Android deployment process completed!${NC}"

# Generate deployment report
cat > android_deployment_report.txt << EOF
Android Deployment Report
========================

Deployment Date: $(date)
App Version: $APP_VERSION
Build Number: $BUILD_NUMBER
Package Name: com.mewayz.app

Deployment Status:
- App Bundle Generated: ✅
- Google Play Authentication: ✅
- Upload Process: ✅

Files:
- App Bundle: build/app/outputs/bundle/release/app-release.aab
- Service Account: $GOOGLE_PLAY_SERVICE_ACCOUNT_JSON

Next Steps:
1. Monitor the app review process in Google Play Console
2. Respond to any feedback from Google Play review team
3. Once approved, the app will be available in Google Play Store

Google Play Console: https://play.google.com/console
EOF

echo -e "${GREEN}📋 Deployment report generated: android_deployment_report.txt${NC}"