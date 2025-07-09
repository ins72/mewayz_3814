# Mewayz Production ProGuard Rules
# Keep application entry point
-keep class com.mewayz.app.MainActivity { *; }

# Flutter specific rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class androidx.lifecycle.** { *; }

# Supabase and networking
-keep class io.supabase.** { *; }
-keep class com.squareup.okhttp3.** { *; }
-keep class retrofit2.** { *; }
-keep class com.google.gson.** { *; }
-dontwarn okhttp3.**
-dontwarn retrofit2.**

# Firebase and Google Play Services
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# Social media SDKs
-keep class com.facebook.** { *; }
-keep class com.instagram.** { *; }
-keep class com.twitter.** { *; }
-keep class com.linkedin.** { *; }
-dontwarn com.facebook.**
-dontwarn com.instagram.**

# Payment processing
-keep class com.stripe.** { *; }
-keep class com.paypal.** { *; }
-dontwarn com.stripe.**
-dontwarn com.paypal.**

# Biometric authentication
-keep class androidx.biometric.** { *; }
-keep class androidx.security.** { *; }

# Image loading and caching
-keep class com.bumptech.glide.** { *; }
-keep class com.squareup.picasso.** { *; }
-keep class com.github.bumptech.glide.** { *; }

# Serialization
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes EnclosingMethod
-keepattributes InnerClasses

# Keep model classes
-keep class com.mewayz.app.models.** { *; }
-keep class com.mewayz.app.data.** { *; }

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep enum classes
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep Parcelable classes
-keepclassmembers class * implements android.os.Parcelable {
    public static final ** CREATOR;
}

# Remove debug logs in production
-assumenosideeffects class android.util.Log {
    public static boolean isLoggable(java.lang.String, int);
    public static int v(...);
    public static int i(...);
    public static int w(...);
    public static int d(...);
    public static int e(...);
}

# Optimization settings
-optimizations !code/simplification/arithmetic,!code/simplification/cast,!field/*,!class/merging/*
-optimizationpasses 5
-allowaccessmodification
-dontpreverify
-dontusemixedcaseclassnames
-dontskipnonpubliclibraryclasses
-verbose

# Keep crash reporting
-keep class com.crashlytics.** { *; }
-keep class io.sentry.** { *; }
-dontwarn com.crashlytics.**
-dontwarn io.sentry.**

# Keep analytics
-keep class com.mixpanel.** { *; }
-keep class com.amplitude.** { *; }
-dontwarn com.mixpanel.**
-dontwarn com.amplitude.**

# Additional Flutter plugins
-keep class com.dexterous.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn com.dexterous.**