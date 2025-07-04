# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile

# Keep Agora SDK classes
-keep class io.agora.** { *; }
-keep interface io.agora.** { *; }
-keep enum io.agora.** { *; }

# Keep required for desugar runtime
-keep class com.google.devtools.build.android.desugar.runtime.** { *; }

# Keep throwable extensions
-keep class * extends java.lang.Throwable { *; }

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep video/audio capture related classes
-keep class * implements io.agora.rtc2.video.IVideoEncoderEx { *; }
-keep class * implements io.agora.rtc2.audio.IAudioEncoderEx { *; }

# Keep RTC related classes
-keep class io.agora.rtc2.** { *; }
-keep interface io.agora.rtc2.** { *; }
-keep enum io.agora.rtc2.** { *; }

# Don't warn about missing classes
-dontwarn io.agora.**
-dontwarn com.google.devtools.build.android.desugar.runtime.** 