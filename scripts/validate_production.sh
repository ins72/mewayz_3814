#!/bin/bash

# Mewayz Production Validation Script
# This script validates the app for production readiness

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔍 Starting Mewayz Production Validation...${NC}"

# Initialize counters
TOTAL_CHECKS=0
PASSED_CHECKS=0
FAILED_CHECKS=0
WARNINGS=0

# Function to log check result
log_check() {
    local status=$1
    local message=$2
    local is_warning=${3:-false}
    
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    
    if [ "$status" = "PASS" ]; then
        echo -e "${GREEN}✅ $message${NC}"
        PASSED_CHECKS=$((PASSED_CHECKS + 1))
    elif [ "$status" = "FAIL" ]; then
        echo -e "${RED}❌ $message${NC}"
        FAILED_CHECKS=$((FAILED_CHECKS + 1))
    elif [ "$status" = "WARN" ]; then
        echo -e "${YELLOW}⚠️ $message${NC}"
        WARNINGS=$((WARNINGS + 1))
    fi
}

# Check Flutter installation
echo -e "${YELLOW}🔍 Checking Flutter installation...${NC}"
if command -v flutter &> /dev/null; then
    FLUTTER_VERSION=$(flutter --version | head -n 1)
    log_check "PASS" "Flutter installed: $FLUTTER_VERSION"
else
    log_check "FAIL" "Flutter not installed"
fi

# Check Dart version
DART_VERSION=$(dart --version 2>&1 | head -n 1)
log_check "PASS" "Dart version: $DART_VERSION"

# Check environment file
echo -e "${YELLOW}🔍 Checking environment configuration...${NC}"
if [ -f ".env" ]; then
    log_check "PASS" ".env file exists"
    
    # Source environment variables
    source .env
    
    # Check critical environment variables
    if [ -n "$SUPABASE_URL" ] && [ -n "$SUPABASE_ANON_KEY" ]; then
        log_check "PASS" "Supabase configuration present"
    else
        log_check "FAIL" "Supabase configuration missing"
    fi
    
    if [ -n "$ENCRYPTION_KEY" ] && [ ${#ENCRYPTION_KEY} -ge 32 ]; then
        log_check "PASS" "Encryption key configured properly"
    else
        log_check "FAIL" "Encryption key missing or too short"
    fi
    
    if [ -n "$JWT_SECRET" ] && [ ${#JWT_SECRET} -ge 32 ]; then
        log_check "PASS" "JWT secret configured properly"
    else
        log_check "FAIL" "JWT secret missing or too short"
    fi
    
    if [ "$ENVIRONMENT" = "production" ]; then
        log_check "PASS" "Environment set to production"
    else
        log_check "WARN" "Environment not set to production"
    fi
    
    if [ "$DEBUG_MODE" = "false" ]; then
        log_check "PASS" "Debug mode disabled"
    else
        log_check "FAIL" "Debug mode enabled in production"
    fi
    
    # Check API keys
    if [ -n "$GOOGLE_CLIENT_ID" ]; then
        log_check "PASS" "Google OAuth configured"
    else
        log_check "WARN" "Google OAuth not configured"
    fi
    
    if [ -n "$FIREBASE_PROJECT_ID" ]; then
        log_check "PASS" "Firebase configured"
    else
        log_check "WARN" "Firebase not configured"
    fi
    
    if [ -n "$STRIPE_PUBLISHABLE_KEY" ]; then
        log_check "PASS" "Stripe payment configured"
    else
        log_check "WARN" "Stripe payment not configured"
    fi
    
else
    log_check "FAIL" ".env file not found"
fi

# Check pubspec.yaml
echo -e "${YELLOW}🔍 Checking pubspec.yaml...${NC}"
if [ -f "pubspec.yaml" ]; then
    log_check "PASS" "pubspec.yaml exists"
    
    # Check version
    VERSION=$(grep "version:" pubspec.yaml | sed 's/version: //')
    if [ -n "$VERSION" ]; then
        log_check "PASS" "Version defined: $VERSION"
    else
        log_check "FAIL" "Version not defined"
    fi
    
    # Check dependencies
    if grep -q "flutter:" pubspec.yaml; then
        log_check "PASS" "Flutter dependency present"
    else
        log_check "FAIL" "Flutter dependency missing"
    fi
    
    # Check for dev dependencies
    if grep -q "flutter_test:" pubspec.yaml; then
        log_check "PASS" "Test framework configured"
    else
        log_check "WARN" "Test framework not configured"
    fi
    
else
    log_check "FAIL" "pubspec.yaml not found"
fi

# Check Android configuration
echo -e "${YELLOW}🔍 Checking Android configuration...${NC}"
if [ -f "android/app/build.gradle" ]; then
    log_check "PASS" "Android build.gradle exists"
    
    # Check application ID
    if grep -q "applicationId" android/app/build.gradle; then
        APP_ID=$(grep "applicationId" android/app/build.gradle | sed 's/.*applicationId //' | sed 's/"//g')
        log_check "PASS" "Application ID configured: $APP_ID"
    else
        log_check "FAIL" "Application ID not configured"
    fi
    
    # Check keystore configuration
    if [ -f "android/key.properties" ]; then
        log_check "PASS" "Android key.properties exists"
        
        # Check keystore file
        KEYSTORE_FILE=$(grep "storeFile" android/key.properties | sed 's/.*=//')
        if [ -f "android/$KEYSTORE_FILE" ]; then
            log_check "PASS" "Keystore file exists"
        else
            log_check "FAIL" "Keystore file not found"
        fi
    else
        log_check "FAIL" "Android key.properties not found"
    fi
    
    # Check ProGuard rules
    if [ -f "android/app/proguard-rules.pro" ]; then
        log_check "PASS" "ProGuard rules configured"
    else
        log_check "WARN" "ProGuard rules not configured"
    fi
    
else
    log_check "FAIL" "Android configuration not found"
fi

# Check iOS configuration
echo -e "${YELLOW}🔍 Checking iOS configuration...${NC}"
if [ -f "ios/Runner/Info.plist" ]; then
    log_check "PASS" "iOS Info.plist exists"
    
    # Check bundle identifier
    if grep -q "CFBundleIdentifier" ios/Runner/Info.plist; then
        log_check "PASS" "Bundle identifier configured"
    else
        log_check "FAIL" "Bundle identifier not configured"
    fi
    
    # Check permissions
    if grep -q "NSCameraUsageDescription" ios/Runner/Info.plist; then
        log_check "PASS" "Camera permission configured"
    else
        log_check "WARN" "Camera permission not configured"
    fi
    
    if grep -q "NSPhotoLibraryUsageDescription" ios/Runner/Info.plist; then
        log_check "PASS" "Photo library permission configured"
    else
        log_check "WARN" "Photo library permission not configured"
    fi
    
else
    log_check "FAIL" "iOS configuration not found"
fi

# Check security configuration
echo -e "${YELLOW}🔍 Checking security configuration...${NC}"
if [ -f "lib/core/security_service.dart" ]; then
    log_check "PASS" "Security service exists"
else
    log_check "FAIL" "Security service not found"
fi

if [ -f "lib/core/environment_config.dart" ]; then
    log_check "PASS" "Environment configuration exists"
else
    log_check "FAIL" "Environment configuration not found"
fi

# Check for sensitive data in code
echo -e "${YELLOW}🔍 Checking for sensitive data in code...${NC}"
if grep -r "TODO\|FIXME\|XXX" lib/ 2>/dev/null; then
    log_check "WARN" "TODO/FIXME comments found in code"
else
    log_check "PASS" "No TODO/FIXME comments found"
fi

if grep -r "password.*=.*['\"]" lib/ 2>/dev/null; then
    log_check "FAIL" "Hardcoded passwords found in code"
else
    log_check "PASS" "No hardcoded passwords found"
fi

if grep -r "secret.*=.*['\"]" lib/ 2>/dev/null; then
    log_check "FAIL" "Hardcoded secrets found in code"
else
    log_check "PASS" "No hardcoded secrets found"
fi

# Check test coverage
echo -e "${YELLOW}🔍 Checking test coverage...${NC}"
if [ -f "coverage/lcov.info" ]; then
    log_check "PASS" "Test coverage report exists"
    
    # Calculate coverage percentage (simplified)
    if command -v genhtml &> /dev/null; then
        COVERAGE_PERCENT=$(genhtml coverage/lcov.info -o coverage/html --quiet | grep "Overall coverage rate" | sed 's/.*: //' | sed 's/%.*//')
        if [ -n "$COVERAGE_PERCENT" ] && [ "$COVERAGE_PERCENT" -ge 80 ]; then
            log_check "PASS" "Test coverage above 80%: $COVERAGE_PERCENT%"
        else
            log_check "WARN" "Test coverage below 80%: $COVERAGE_PERCENT%"
        fi
    fi
else
    log_check "WARN" "Test coverage report not found"
fi

# Check for production builds
echo -e "${YELLOW}🔍 Checking build artifacts...${NC}"
if [ -f "build/app/outputs/bundle/release/app-release.aab" ]; then
    log_check "PASS" "Android App Bundle exists"
else
    log_check "WARN" "Android App Bundle not found (run build script first)"
fi

if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
    log_check "PASS" "Android APK exists"
else
    log_check "WARN" "Android APK not found (run build script first)"
fi

if [ -f "build/ios/ipa/mewayz.ipa" ]; then
    log_check "PASS" "iOS IPA exists"
else
    log_check "WARN" "iOS IPA not found (run build script first)"
fi

# Check documentation
echo -e "${YELLOW}🔍 Checking documentation...${NC}"
if [ -f "README.md" ]; then
    log_check "PASS" "README.md exists"
else
    log_check "WARN" "README.md not found"
fi

if [ -f "PRODUCTION_CHECKLIST.md" ]; then
    log_check "PASS" "Production checklist exists"
else
    log_check "WARN" "Production checklist not found"
fi

# Check git repository
echo -e "${YELLOW}🔍 Checking git repository...${NC}"
if [ -d ".git" ]; then
    log_check "PASS" "Git repository initialized"
    
    # Check for uncommitted changes
    if git diff --quiet && git diff --cached --quiet; then
        log_check "PASS" "No uncommitted changes"
    else
        log_check "WARN" "Uncommitted changes found"
    fi
    
    # Check current branch
    CURRENT_BRANCH=$(git branch --show-current)
    if [ "$CURRENT_BRANCH" = "main" ] || [ "$CURRENT_BRANCH" = "master" ]; then
        log_check "PASS" "On main branch: $CURRENT_BRANCH"
    else
        log_check "WARN" "Not on main branch: $CURRENT_BRANCH"
    fi
    
else
    log_check "WARN" "Git repository not found"
fi

# Check for common issues
echo -e "${YELLOW}🔍 Checking for common issues...${NC}"
if [ -f "android/gradle.properties" ]; then
    if grep -q "org.gradle.jvmargs=-Xmx" android/gradle.properties; then
        log_check "PASS" "Gradle memory settings configured"
    else
        log_check "WARN" "Gradle memory settings not optimized"
    fi
fi

# Final summary
echo -e "${BLUE}📊 Validation Summary:${NC}"
echo -e "   Total Checks: $TOTAL_CHECKS"
echo -e "   Passed: ${GREEN}$PASSED_CHECKS${NC}"
echo -e "   Failed: ${RED}$FAILED_CHECKS${NC}"
echo -e "   Warnings: ${YELLOW}$WARNINGS${NC}"

SCORE=$((PASSED_CHECKS * 100 / TOTAL_CHECKS))
echo -e "   Score: $SCORE%"

if [ $FAILED_CHECKS -eq 0 ]; then
    echo -e "${GREEN}🎉 Production validation completed successfully!${NC}"
    if [ $WARNINGS -gt 0 ]; then
        echo -e "${YELLOW}⚠️ Please address the warnings above before deployment.${NC}"
    fi
    exit 0
else
    echo -e "${RED}❌ Production validation failed!${NC}"
    echo -e "${RED}Please fix the failed checks before deploying to production.${NC}"
    exit 1
fi