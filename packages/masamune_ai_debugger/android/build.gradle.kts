import java.util.Base64

group = "net.mathru.masamune_ai_debugger"
version = "1.0-SNAPSHOT"

buildscript {
    val kotlinVersion = "2.4.0"
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath("com.android.tools.build:gradle:9.1.0")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlinVersion")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

plugins {
    id("com.android.library")
}

// Flutter passes --dart-define values as -Pdart-defines=<base64>,<base64>.
// The microphone capture and RECORD_AUDIO are included only when
// MASAMUNE_AI_DEBUGGER_VOICE=true; otherwise a stub without audio APIs is used.
val dartDefines: Map<String, String> =
    (project.findProperty("dart-defines") as String? ?: "")
        .split(",")
        .filter { it.isNotBlank() }
        .mapNotNull {
            val decoded =
                try {
                    String(Base64.getDecoder().decode(it))
                } catch (_: IllegalArgumentException) {
                    return@mapNotNull null
                }
            val index = decoded.indexOf("=")
            if (index <= 0) null else decoded.substring(0, index) to decoded.substring(index + 1)
        }
        .toMap()
val voiceEnabled = dartDefines["MASAMUNE_AI_DEBUGGER_VOICE"] == "true"
if (voiceEnabled) {
    logger.lifecycle("masamune_ai_debugger: voice input is enabled (RECORD_AUDIO is added).")
}

android {
    namespace = "net.mathru.masamune_ai_debugger"

    compileSdk = 36

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    sourceSets {
        getByName("main") {
            java.srcDirs(
                "src/main/kotlin",
                if (voiceEnabled) "src/voice/kotlin" else "src/novoice/kotlin",
            )
            if (voiceEnabled) manifest.srcFile("src/voice/AndroidManifest.xml")
        }
    }

    defaultConfig {
        minSdk = 24
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}
