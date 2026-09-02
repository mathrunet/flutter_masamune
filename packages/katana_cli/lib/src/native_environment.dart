/// Configures Android Gradle to read Katana's native build environment from
/// Flutter's `DART_DEFINES` project property.
class AndroidNativeEnvironmentSynchronizer {
  const AndroidNativeEnvironmentSynchronizer._();

  /// Beginning of the managed Gradle section.
  static const beginMarker = "// KATANA NATIVE ENVIRONMENT BEGIN";

  /// End of the managed Gradle section.
  static const endMarker = "// KATANA NATIVE ENVIRONMENT END";

  /// Beginning of the managed Firebase section.
  static const firebaseBeginMarker = "// KATANA FIREBASE ENVIRONMENT BEGIN";

  /// End of the managed Firebase section.
  static const firebaseEndMarker = "// KATANA FIREBASE ENVIRONMENT END";

  /// Adds dev/prod validation and optional Android application ID switching.
  ///
  /// `ANDROID_APPLICATION_ID` is optional. When omitted, the application ID
  /// already present in Gradle remains the effective value.
  static String synchronize(String source, {required bool isKotlin}) {
    if (source.contains(beginMarker)) {
      return source;
    }
    final applicationIdPattern = isKotlin
        ? RegExp(
            r'''applicationId\s*=\s*(?:katanaAndroidApplicationId\s*\?:\s*)?(["'][^"']+["'])''',
          )
        : RegExp(
            r'''applicationId\s*(?:=\s*)?(?:katanaAndroidApplicationId\s*\?:\s*)?(["'][^"']+["'])''',
          );
    final match = applicationIdPattern.firstMatch(source);
    if (match == null) {
      throw const FormatException("Android applicationId was not found.");
    }
    final originalApplicationId = match.group(1)!;
    final androidIndex =
        RegExp(r"^android\s*\{", multiLine: true).firstMatch(source)?.start;
    if (androidIndex == null) {
      throw const FormatException("Android Gradle block was not found.");
    }
    final block = isKotlin ? _kotlinBlock : _groovyBlock;
    var result = source.replaceRange(androidIndex, androidIndex, "$block\n\n");
    result = result.replaceFirst(
      applicationIdPattern,
      isKotlin
          ? "applicationId = katanaAndroidApplicationId ?: $originalApplicationId"
          : "applicationId katanaAndroidApplicationId ?: $originalApplicationId",
    );
    return result;
  }

  /// Configures Google Services tasks to consume the selected environment.
  static String synchronizeFirebase(String source, {required bool isKotlin}) {
    if (source.contains(firebaseBeginMarker)) {
      return source;
    }
    if (!source.contains(beginMarker)) {
      throw const FormatException(
        "Katana native environment must be configured before Firebase.",
      );
    }
    final block = isKotlin ? _kotlinFirebaseBlock : _groovyFirebaseBlock;
    return "$source\n$block";
  }

  static const _kotlinBlock = '''
$beginMarker
val katanaDartDefines =
    ((project.findProperty("dart-defines") ?: project.findProperty("DART_DEFINES")) as? String)
        ?.split(",")
        ?.filter { it.isNotBlank() }
        ?.associate { encoded ->
            val decoded = String(java.util.Base64.getDecoder().decode(encoded))
            val separator = decoded.indexOf('=')
            if (separator < 0) decoded to "" else decoded.substring(0, separator) to decoded.substring(separator + 1)
        }
        ?: emptyMap()
val katanaFlavor = katanaDartDefines["FLAVOR"]
    ?: throw GradleException("FLAVOR must be specified with --dart-define-from-file.")
if (katanaFlavor !in setOf("dev", "prod")) {
    throw GradleException("FLAVOR must be dev or prod: \$katanaFlavor")
}
val katanaAndroidApplicationId = katanaDartDefines["ANDROID_APPLICATION_ID"]
$endMarker
''';

  static const _groovyBlock = '''
$beginMarker
def katanaDartDefines = (project.findProperty("dart-defines") ?: project.findProperty("DART_DEFINES") ?: "")
    .split(",")
    .findAll { !it.isEmpty() }
    .collectEntries { encoded ->
        def decoded = new String(java.util.Base64.decoder.decode(encoded), "UTF-8")
        def separator = decoded.indexOf('=')
        separator < 0 ? [(decoded): ""] : [(decoded.substring(0, separator)): decoded.substring(separator + 1)]
    }
def katanaFlavor = katanaDartDefines["FLAVOR"]
if (katanaFlavor == null) {
    throw new GradleException("FLAVOR must be specified with --dart-define-from-file.")
}
if (!(katanaFlavor in ["dev", "prod"])) {
    throw new GradleException("FLAVOR must be dev or prod: \$katanaFlavor")
}
def katanaAndroidApplicationId = katanaDartDefines["ANDROID_APPLICATION_ID"]
$endMarker
''';

  static const _kotlinFirebaseBlock = '''
$firebaseBeginMarker
afterEvaluate {
    tasks.matching { it.name.endsWith("GoogleServices") }.configureEach {
        val selectedGoogleServices =
            file("src/katanaFirebase/\$katanaFlavor/google-services.json")
        if (!selectedGoogleServices.exists()) {
            throw GradleException(
                "Firebase configuration is missing for FLAVOR=\$katanaFlavor: \${selectedGoogleServices.path}",
            )
        }
        val setter = javaClass.methods.firstOrNull {
            it.name == "setGoogleServicesJsonFiles" && it.parameterCount == 1
        } ?: throw GradleException(
            "The Google Services plugin does not expose googleServicesJsonFiles.",
        )
        setter.invoke(this, listOf(selectedGoogleServices))
    }
}
$firebaseEndMarker
''';

  static const _groovyFirebaseBlock = '''
$firebaseBeginMarker
afterEvaluate {
    tasks.matching { it.name.endsWith("GoogleServices") }.configureEach {
        def selectedGoogleServices =
            file("src/katanaFirebase/\${katanaFlavor}/google-services.json")
        if (!selectedGoogleServices.exists()) {
            throw new GradleException(
                "Firebase configuration is missing for FLAVOR=\${katanaFlavor}: \${selectedGoogleServices.path}"
            )
        }
        def setter = getClass().methods.find {
            it.name == "setGoogleServicesJsonFiles" && it.parameterCount == 1
        }
        if (setter == null) {
            throw new GradleException(
                "The Google Services plugin does not expose googleServicesJsonFiles."
            )
        }
        setter.invoke(delegate, [selectedGoogleServices])
    }
}
$firebaseEndMarker
''';
}

/// Configures an Apple Runner target to select Firebase plist by `FLAVOR`.
class AppleFirebaseEnvironmentSynchronizer {
  const AppleFirebaseEnvironmentSynchronizer._();

  /// Stable build phase identifier used in generated Xcode projects.
  static const buildPhaseId = "F17EBA5E0000000000000001";

  /// Display name of the generated build phase.
  static const buildPhaseName = "Select Katana Firebase Configuration";

  /// Creates the shell script invoked by the Xcode build phase.
  static String get shellScript => r'''
#!/bin/sh
set -eu

FLAVOR=""
OLD_IFS="$IFS"
IFS=','
for encoded in ${DART_DEFINES:-}; do
  decoded="$(printf '%s' "$encoded" | /usr/bin/base64 -D)"
  case "$decoded" in
    FLAVOR=*) FLAVOR="${decoded#FLAVOR=}" ;;
  esac
done
IFS="$OLD_IFS"

case "$FLAVOR" in
  dev|prod) ;;
  *) echo "error: FLAVOR must be dev or prod." >&2; exit 1 ;;
esac

firebase_root="$PROJECT_DIR/Runner/Firebase"
if [ ! -d "$firebase_root" ]; then
  exit 0
fi
source_plist="$firebase_root/$FLAVOR/GoogleService-Info.plist"
if [ ! -f "$source_plist" ]; then
  echo "error: Firebase configuration is missing for FLAVOR=$FLAVOR: $source_plist" >&2
  exit 1
fi
destination="$TARGET_BUILD_DIR/$UNLOCALIZED_RESOURCES_FOLDER_PATH/GoogleService-Info.plist"
/bin/mkdir -p "$(/usr/bin/dirname "$destination")"
/bin/cp "$source_plist" "$destination"
''';

  /// Adds an idempotent shell build phase to the Runner native target.
  static String synchronizeProject(String source) {
    if (source.contains("$buildPhaseId /* $buildPhaseName */")) {
      return source;
    }
    final runnerTarget = RegExp(
      r"(?<head>[A-Z0-9]+ /\* Runner \*/ = \{[\s\S]*?buildPhases = \(\n)",
    ).firstMatch(source);
    if (runnerTarget == null) {
      throw const FormatException("The Runner Xcode target was not found.");
    }
    var result = source.replaceRange(
      runnerTarget.end,
      runnerTarget.end,
      "\t\t\t\t$buildPhaseId /* $buildPhaseName */,\n",
    );
    const sectionEnd = "/* End PBXShellScriptBuildPhase section */";
    final sectionIndex = result.indexOf(sectionEnd);
    if (sectionIndex < 0) {
      throw const FormatException(
          "PBXShellScriptBuildPhase section was not found.");
    }
    final escapedScript = shellScript
        .replaceAll(r"\", r"\\")
        .replaceAll('"', r'\"')
        .replaceAll("\n", r"\n");
    final phase = '''
\t\t$buildPhaseId /* $buildPhaseName */ = {
\t\t\tisa = PBXShellScriptBuildPhase;
\t\t\talwaysOutOfDate = 1;
\t\t\tbuildActionMask = 2147483647;
\t\t\tfiles = ();
\t\t\tinputFileListPaths = ();
\t\t\tinputPaths = ();
\t\t\tname = "$buildPhaseName";
\t\t\toutputFileListPaths = ();
\t\t\toutputPaths = (
\t\t\t\t"\$(TARGET_BUILD_DIR)/\$(UNLOCALIZED_RESOURCES_FOLDER_PATH)/GoogleService-Info.plist",
\t\t\t);
\t\t\trunOnlyForDeploymentPostprocessing = 0;
\t\t\tshellPath = /bin/sh;
\t\t\tshellScript = "$escapedScript";
\t\t};
''';
    result = result.replaceRange(sectionIndex, sectionIndex, phase);
    return result;
  }
}
