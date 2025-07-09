#!/bin/bash

# Mewayz Production Build Script
# This script builds the Flutter app for production deployment

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Starting Mewayz Production Build Process...${NC}"

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Flutter could not be found. Please install Flutter first.${NC}"
    exit 1
fi

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo -e "${RED}❌ .env file not found. Please create .env file with production values.${NC}"
    exit 1
fi

# Validate environment variables
echo -e "${YELLOW}🔍 Validating environment configuration...${NC}"
source .env

# Check critical environment variables
if [ -z "$SUPABASE_URL" ] || [ -z "$SUPABASE_ANON_KEY" ]; then
    echo -e "${RED}❌ Supabase configuration missing in .env file${NC}"
    exit 1
fi

if [ -z "$ENCRYPTION_KEY" ] || [ ${#ENCRYPTION_KEY} -lt 32 ]; then
    echo -e "${RED}❌ Encryption key missing or too short (minimum 32 characters)${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Environment configuration validated${NC}"

# Clean previous builds
echo -e "${YELLOW}🧹 Cleaning previous builds...${NC}"
flutter clean
flutter pub get

# Run tests
echo -e "${YELLOW}🧪 Running tests...${NC}"
flutter test --coverage

# Generate code coverage report
if command -v genhtml &> /dev/null; then
    echo -e "${YELLOW}📊 Generating coverage report...${NC}"
    genhtml coverage/lcov.info -o coverage/html
fi

# Check code quality
echo -e "${YELLOW}🔍 Analyzing code quality...${NC}"
flutter analyze

# Build for Android
echo -e "${YELLOW}🤖 Building Android production release...${NC}"

# Check if Android keystore exists
if [ ! -f "android/keystore/mewayz-upload-keystore.jks" ]; then
    echo -e "${RED}❌ Android keystore not found. Please generate keystore first.${NC}"
    echo -e "${YELLOW}Run: keytool -genkey -v -keystore android/keystore/mewayz-upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias mewayz-upload-key${NC}"
    exit 1
fi

# Build Android App Bundle (recommended for Play Store)
flutter build appbundle \
    --release \
    --obfuscate \
    --split-debug-info=build/debug-info \
    --dart-define=ENVIRONMENT=production \
    --dart-define=FLUTTER_BUILD_MODE=release \
    --target-platform android-arm,android-arm64,android-x64

# Build Android APK (for direct distribution)
flutter build apk \
    --release \
    --obfuscate \
    --split-debug-info=build/debug-info \
    --dart-define=ENVIRONMENT=production \
    --dart-define=FLUTTER_BUILD_MODE=release \
    --target-platform android-arm,android-arm64,android-x64

echo -e "${GREEN}✅ Android builds completed successfully${NC}"

# Build for iOS (only on macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo -e "${YELLOW}🍎 Building iOS production release...${NC}"
    
    # Check if iOS provisioning is set up
    if [ ! -d "ios/Runner.xcworkspace" ]; then
        echo -e "${RED}❌ iOS workspace not found. Please run 'flutter create --platforms=ios .' first.${NC}"
        exit 1
    fi
    
    # Build iOS IPA
    flutter build ios \
        --release \
        --obfuscate \
        --split-debug-info=build/debug-info \
        --dart-define=ENVIRONMENT=production \
        --dart-define=FLUTTER_BUILD_MODE=release
    
    # Archive iOS app
    xcodebuild -workspace ios/Runner.xcworkspace \
        -scheme Runner \
        -configuration Release \
        -archivePath build/ios/archive/Runner.xcarchive \
        archive
    
    # Export IPA
    xcodebuild -exportArchive \
        -archivePath build/ios/archive/Runner.xcarchive \
        -exportPath build/ios/ipa \
        -exportOptionsPlist ios/ExportOptions.plist
    
    echo -e "${GREEN}✅ iOS build completed successfully${NC}"
else
    echo -e "${YELLOW}⚠️ iOS build skipped (not running on macOS)${NC}"
fi

# Build for Web (optional)
echo -e "${YELLOW}🌐 Building Web production release...${NC}"
flutter build web \
    --release \
    --web-renderer canvaskit \
    --dart-define=ENVIRONMENT=production \
    --dart-define=FLUTTER_BUILD_MODE=release

echo -e "${GREEN}✅ Web build completed successfully${NC}"

# Create build summary
echo -e "${YELLOW}📋 Creating build summary...${NC}"
BUILD_DATE=$(date '+%Y-%m-%d %H:%M:%S')
BUILD_VERSION=$(grep "version:" pubspec.yaml | sed 's/version: //')
BUILD_COMMIT=$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")

cat > build/BUILD_SUMMARY.md << EOF
# Mewayz Production Build Summary

## Build Information
- **Build Date**: $BUILD_DATE
- **Version**: $BUILD_VERSION
- **Commit**: $BUILD_COMMIT
- **Environment**: production

## Build Artifacts

### Android
- **App Bundle**: \`build/app/outputs/bundle/release/app-release.aab\`
- **APK**: \`build/app/outputs/flutter-apk/app-release.apk\`

### iOS
- **IPA**: \`build/ios/ipa/mewayz.ipa\`
- **Archive**: \`build/ios/archive/Runner.xcarchive\`

### Web
- **Build**: \`build/web/\`

## Build Settings
- **Obfuscation**: Enabled
- **Debug Info**: Removed (stored in build/debug-info)
- **Optimization**: Enabled
- **Code Signing**: Enabled

## Next Steps
1. Test the build thoroughly
2. Upload to respective app stores
3. Monitor deployment for issues
4. Update version numbers for next release

## Store Deployment
- **Google Play**: Upload \`app-release.aab\`
- **App Store**: Upload \`mewayz.ipa\`
- **Web**: Deploy \`build/web/\` to hosting service

---
Generated by Mewayz Build Script
EOF

# Display build summary
echo -e "${GREEN}🎉 Build completed successfully!${NC}"
echo -e "${BLUE}📋 Build Summary:${NC}"
echo -e "   Version: $BUILD_VERSION"
echo -e "   Commit: $BUILD_COMMIT"
echo -e "   Date: $BUILD_DATE"
echo ""
echo -e "${BLUE}📦 Build Artifacts:${NC}"
echo -e "   Android Bundle: build/app/outputs/bundle/release/app-release.aab"
echo -e "   Android APK: build/app/outputs/flutter-apk/app-release.apk"
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo -e "   iOS IPA: build/ios/ipa/mewayz.ipa"
fi
echo -e "   Web Build: build/web/"
echo ""
echo -e "${GREEN}✅ Ready for deployment to app stores!${NC}"

# Create deployment package
echo -e "${YELLOW}📦 Creating deployment package...${NC}"
mkdir -p build/deployment
cp build/app/outputs/bundle/release/app-release.aab build/deployment/
cp build/app/outputs/flutter-apk/app-release.apk build/deployment/
if [[ "$OSTYPE" == "darwin"* ]] && [ -f "build/ios/ipa/mewayz.ipa" ]; then
    cp build/ios/ipa/mewayz.ipa build/deployment/
fi
cp build/BUILD_SUMMARY.md build/deployment/
cp PRODUCTION_CHECKLIST.md build/deployment/

# Create deployment archive
cd build/deployment
zip -r "../mewayz-production-${BUILD_VERSION}-${BUILD_COMMIT}.zip" .
cd ../..

echo -e "${GREEN}🎉 Deployment package created: build/mewayz-production-${BUILD_VERSION}-${BUILD_COMMIT}.zip${NC}"
echo -e "${BLUE}🚀 Ready for store submission!${NC}"