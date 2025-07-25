// Dart imports:
import "dart:io";

// Package imports:
import "package:katana/katana.dart";

// Project imports:
import "package:katana_cli/config.dart";

/// Class for retrieving and saving files in `android/app/build.gradle`.
///
/// `android/app/build.gradle`のファイルを取得して保存するためのクラス。
class AppGradle {
  /// Class for retrieving and saving files in `android/app/build.gradle`.
  ///
  /// `android/app/build.gradle`のファイルを取得して保存するためのクラス。
  AppGradle();

  /// Whether the file is written in Kotlin.
  ///
  /// ファイルがKotlinで書かれているかどうか。
  bool get isKotlin => _isKotlin;
  bool _isKotlin = false;

  /// Original text data.
  ///
  /// 元のテキストデータ。
  String get rawData => _rawData;
  late String _rawData;

  /// Data reading part of `xxx.properties`.
  ///
  /// `xxx.properties`のデータ読み込み部分。
  List<GradleLoadProperties> get loadProperties => _loadProperties;
  late List<GradleLoadProperties> _loadProperties;

  /// List of `import`.
  ///
  /// `import`のリスト。
  List<GradleImport> get imports => _imports;
  late List<GradleImport> _imports;

  /// List of `apply plugin`.
  ///
  /// `apply plugin`のリスト。
  List<GradlePlugin> get plugins => _plugins;
  late List<GradlePlugin> _plugins;

  /// Data in the `android` section.
  ///
  /// `android`セクションのデータ。
  GradleAndroid? get android => _android;
  GradleAndroid? _android;

  /// Data in the `android` section.
  ///
  /// `android`セクションのデータ。
  List<GradleDependencies> get dependencies => _dependencies;
  late List<GradleDependencies> _dependencies;

  /// Data loading.
  ///
  /// データの読み込み。
  Future<void> load() async {
    if (File("android/app/build.gradle").existsSync()) {
      final gradle = File("android/app/build.gradle");
      _rawData = await gradle.readAsString();
    } else if (File("android/app/build.gradle.kts").existsSync()) {
      _isKotlin = true;
      final gradle = File("android/app/build.gradle.kts");
      _rawData = await gradle.readAsString();
    }
    _loadProperties = GradleLoadProperties._load(_rawData);
    _imports = GradleImport._load(_rawData);
    _plugins = GradlePlugin._load(_rawData);
    _android = GradleAndroid._load(_rawData);
    _dependencies = GradleDependencies._load(_rawData);
  }

  /// Data storage.
  ///
  /// データの保存。
  Future<void> save() async {
    if (_rawData.isEmpty) {
      throw Exception("No value. Please load data with [load].");
    }
    _rawData = GradleLoadProperties._save(_rawData, _loadProperties);
    _rawData = GradleImport._save(_rawData, _imports);
    if (_android != null) {
      _rawData = GradleAndroid._save(_rawData, _android!);
    }
    _rawData = GradlePlugin._save(_rawData, _plugins);
    _rawData = GradleDependencies._save(_rawData, _dependencies);
    if (File("android/app/build.gradle").existsSync()) {
      final gradle = File("android/app/build.gradle");
      await gradle.writeAsString(_rawData);
    } else if (File("android/app/build.gradle.kts").existsSync()) {
      final gradle = File("android/app/build.gradle.kts");
      await gradle.writeAsString(_rawData);
    }
  }
}

/// Data reading part of `xxx.properties`.
///
/// `xxx.properties`のデータ読み込み部分。
class GradleLoadProperties {
  /// Data reading part of `xxx.properties`.
  ///
  /// `xxx.properties`のデータ読み込み部分。
  factory GradleLoadProperties({
    required String path,
    required String name,
    required String file,
    bool isKotlin = false,
  }) {
    return GradleLoadProperties._(
      name: name,
      path: path,
      file: file,
      isKotlin: isKotlin,
    );
  }
  GradleLoadProperties._({
    required this.name,
    required this.file,
    required this.path,
    required this.isKotlin,
  });

  static List<GradleLoadProperties> _load(String content) {
    // 旧バージョン
    if (content.contains("def localProperties = new Properties()")) {
      final region = RegExp(
        r"^([\s\S]*?)def localProperties = new Properties\(\)",
      ).firstMatch(content);
      if (region == null) {
        return [];
      }
      return RegExp(
        r"def (?<name>[a-zA-Z_-]+) = new Properties\(\)([\s\S]*?)def (?<file>[a-zA-Z_-]+) = rootProject.file\('(?<path>[a-zA-Z./_-]+)'\)([\s\S]*?)if \(([a-zA-Z_-]+).exists\(\)\) {([\s\S]*?)([a-zA-Z_-]+).withReader\('UTF-8'\) { reader ->([\s\S]*?)([a-zA-Z_-]+).load\(reader\)([\s\S]*?)}([\s\S]*?)}",
      ).allMatches(region.group(1) ?? "").mapAndRemoveEmpty((e) {
        return GradleLoadProperties._(
          file: e.namedGroup("file") ?? "",
          name: e.namedGroup("name") ?? "",
          path: e.namedGroup("path") ?? "",
          isKotlin: false,
        );
      });
      // 新バージョン
    } else {
      final region = RegExp(
        r"(?<plugins>plugins[^{]*?\{[\s\S]*?\})?([\s\S]*?)android \{",
      ).firstMatch(content);
      if (region == null) {
        return [];
      }
      // KTSバージョン
      if (content.contains("= Properties()")) {
        return RegExp(
          r'val (?<name>[a-zA-Z_-]+) = Properties\(\)([\s\S]*?)rootProject.file\("(?<path>[a-zA-Z./_-]+)"\).let([\s\S]*?){([\s\S]*?)(?<file>[a-zA-Z_-]+)([\s\S]*?)->([\s\S]*?)if([\s\S]*?)\(([a-zA-Z_-]+).exists\(\)\)([\s\S]*?){([\s\S]*?)([a-zA-Z_-]+).inputStream\(\).use([\s\S]*?){([\s\S]*?)stream([\s\S]*?)->([\s\S]*?)([a-zA-Z_-]+).load\(stream\)([\s\S]*?)}([\s\S]*?)}([\s\S]*?)}',
        ).allMatches(region.group(2) ?? "").mapAndRemoveEmpty((e) {
          return GradleLoadProperties._(
            file: e.namedGroup("file") ?? "",
            name: e.namedGroup("name") ?? "",
            path: e.namedGroup("path") ?? "",
            isKotlin: true,
          );
        });
      } else {
        return RegExp(
          r"def (?<name>[a-zA-Z_-]+) = new Properties\(\)([\s\S]*?)def (?<file>[a-zA-Z_-]+) = rootProject.file\('(?<path>[a-zA-Z./_-]+)'\)([\s\S]*?)if \(([a-zA-Z_-]+).exists\(\)\) {([\s\S]*?)([a-zA-Z_-]+).withReader\('UTF-8'\) { reader ->([\s\S]*?)([a-zA-Z_-]+).load\(reader\)([\s\S]*?)}([\s\S]*?)}",
        ).allMatches(region.group(2) ?? "").mapAndRemoveEmpty((e) {
          return GradleLoadProperties._(
            file: e.namedGroup("file") ?? "",
            name: e.namedGroup("name") ?? "",
            path: e.namedGroup("path") ?? "",
            isKotlin: false,
          );
        });
      }
    }
  }

  static String _save(String content, List<GradleLoadProperties> list) {
    final code = list.map((e) => e.toString()).join("\n");
    // 旧バージョン
    if (content.contains("def localProperties = new Properties()")) {
      return content.replaceAllMapped(
        RegExp(
          r"(?<plugins>plugins[^{]*?\{[\s\S]*?\})?([\s\S]*?)def localProperties = new Properties\(\)",
        ),
        (match) {
          final plugins = match.group(1);
          if (plugins.isEmpty) {
            return "${match.group(1) ?? ""}$code\n\ndef localProperties = new Properties()";
          } else {
            return "$plugins\n\n$code\n\ndef localProperties = new Properties()";
          }
        },
      );
    } else {
      final aa =
          content.replaceAllMapped(RegExp(r"^([\s\S]*?)android \{"), (match) {
        final content = match.group(1)?.replaceAllMapped(
                RegExp(
                  r"^([\s\S]*?)(?<plugins>plugins[^{]*?\{[\s\S]*?\})([\s\S]*?)$",
                ), (m) {
              return "${m.group(1) ?? ""}${m.group(2) ?? ""}\n\n$code";
            }) ??
            "";
        return "$content\n\nandroid {";
      });
      return aa;
    }
  }

  /// Variable name of the property file.
  ///
  /// プロパティファイルの変数名。
  final String name;

  /// Property file name.
  ///
  /// プロパティファイル名。
  final String file;

  /// Path of the property file.
  ///
  /// プロパティファイルのパス。
  final String path;

  /// Whether the file is written in Kotlin.
  ///
  /// ファイルがKotlinで書かれているかどうか。
  final bool isKotlin;

  @override
  String toString() {
    if (isKotlin) {
      return "val $name = Properties()\nrootProject.file(\"$path\").let { $file ->\n    if ($file.exists()) {\n        $file.inputStream().use { stream ->\n            $name.load(stream)\n        }\n    }\n}";
    } else {
      return "def $name = new Properties()\ndef $file = rootProject.file('$path')\nif ($file.exists()) {\n    $file.withReader('UTF-8') { reader ->\n        $name.load(reader)\n    }\n}";
    }
  }
}

/// Data in the `import` section.
///
/// `import`セクションのデータ。
class GradleImport {
  /// Data in the `import` section.
  ///
  /// `import`セクションのデータ。
  GradleImport({
    required this.import,
  });

  static List<GradleImport> _load(String content) {
    final region =
        RegExp(r"([\s\S]*?)plugins[^{]*?\{([\s\S]*?)\}").firstMatch(content);
    if (region != null) {
      return RegExp(r"import (?<import>[a-zA-Z0-9_.-]+)")
          .allMatches(region.group(1) ?? "")
          .mapAndRemoveEmpty((e) {
        return GradleImport(
          import: e.namedGroup("import") ?? "",
        );
      });
    }
    return [];
  }

  static String _save(String content, List<GradleImport> list) {
    final region =
        RegExp(r"([\s\S]*?)plugins[^{]*?\{([\s\S]*?)\}").firstMatch(content);
    if (region != null) {
      final code = list.map((e) => e.toString()).join("\n");
      return content.replaceAll(
        RegExp(r"([\s\S]*?)plugins[^{]*?\{([\s\S]*?)\}"),
        "$code\n\nplugins {\n${region.group(2) ?? ""}\n}",
      );
    }
    return content;
  }

  /// Plugin Name.
  ///
  /// プラグインの名前。
  String import;

  @override
  String toString() {
    return "import $import";
  }
}

/// Data in the `apply plugin` section.
///
/// `apply plugin`セクションのデータ。
class GradlePlugin {
  /// Data in the `apply plugin` section.
  ///
  /// `apply plugin`セクションのデータ。
  GradlePlugin({
    required this.plugin,
    bool isKotlin = false,
  }) : _isKotlin = isKotlin;

  static List<GradlePlugin> _load(String content) {
    final newRegion =
        RegExp(r"plugins[^{]*?\{([\s\S]*?)\}").firstMatch(content);
    if (newRegion != null) {
      return RegExp(
        "id[^(]*?\\(('|\")(?<plugin>[a-zA-Z0-9_.-]+)('|\")\\)",
      ).allMatches(newRegion.group(1) ?? "").mapAndRemoveEmpty((e) {
        return GradlePlugin(
          plugin: e.namedGroup("plugin") ?? "",
          isKotlin: e.group(0)?.contains("id(") ?? false,
        );
      });
    }
    final region = RegExp(
      r"apply plugin: 'kotlin-android'([\s\S]*?)apply from:",
    ).firstMatch(content);
    if (region != null) {
      return RegExp(
        r"apply plugin: '(?<plugin>[a-zA-Z0-9_.-]+)'",
      ).allMatches(region.group(1) ?? "").mapAndRemoveEmpty((e) {
        return GradlePlugin(
          plugin: e.namedGroup("plugin") ?? "",
          isKotlin: e.group(0)?.contains("id(") ?? false,
        );
      });
    }
    return [];
  }

  static String _save(String content, List<GradlePlugin> list) {
    final newRegion =
        RegExp(r"plugins[^{]*?\{([\s\S]*?)\}").firstMatch(content);
    if (newRegion != null) {
      final code = list.map((e) {
        if (e.isKotlin) {
          return "    id(\"${e.toString()}\")";
        } else {
          return "    id \"${e.toString()}\"";
        }
      }).join("\n");
      return content.replaceAll(
        RegExp(
          r"plugins[^{]*?\{([\s\S]*?)\}",
        ),
        "plugins {\n$code\n}",
      );
    } else {
      final code =
          list.map((e) => "apply plugin: '${e.toString()}'").join("\n");
      return content.replaceAll(
        RegExp(
          r"apply plugin: 'kotlin-android'([\s\S]*?)apply from:",
        ),
        "apply plugin: 'kotlin-android'\n$code\napply from:",
      );
    }
  }

  /// Plugin Name.
  ///
  /// プラグインの名前。
  String plugin;

  /// Whether the plugin is written in Kotlin.
  ///
  /// プラグインがKotlinで書かれているかどうか。
  bool get isKotlin => _isKotlin;
  final bool _isKotlin;

  @override
  String toString() {
    return plugin;
  }
}

/// Data in the `android` section.
///
/// `android`セクションのデータ。
class GradleAndroid {
  /// Data in the `android` section.
  ///
  /// `android`セクションのデータ。
  GradleAndroid({
    required this.buildTypes,
    required this.compileOptions,
    required this.compileSdkVersion,
    required this.defaultConfig,
    required this.kotlinOptions,
    required this.sourceSets,
    this.namespace,
    this.ndkVersion,
    this.buildToolsVersion,
    this.signingConfigs,
  });
  static final _regExp = RegExp(r"android {([\s\S]+?)\n}");

  factory GradleAndroid._load(String content) {
    final region = _regExp.firstMatch(content)?.group(1) ?? "";
    final namespace =
        RegExp("namespace = ([a-zA-Z0-9_\"'.-]+)").firstMatch(region)?.group(1);
    final compileSdkVersion =
        RegExp("compileSdk = (.+)").firstMatch(region)?.group(1) ?? "0";
    final buildToolsVersion =
        RegExp("buildToolsVersion = (.+)").firstMatch(region)?.group(1);
    final ndkVersion = RegExp("ndkVersion = (.+)").firstMatch(region)?.group(1);
    return GradleAndroid(
      namespace: namespace,
      buildTypes: GradleAndroidBuildTypes._load(region),
      signingConfigs: GradleAndroidSigningConfigs._load(region),
      compileOptions: GradleAndroidCompileOptions._load(region),
      compileSdkVersion: compileSdkVersion,
      defaultConfig: GradleAndroidDefaultConfig._load(region),
      buildToolsVersion: buildToolsVersion,
      kotlinOptions: GradleAndroidKotlinOptions._load(region),
      ndkVersion: ndkVersion,
      sourceSets: GradleAndroidSourceSet._load(region),
    );
  }

  static String _save(String content, GradleAndroid data) {
    return content.replaceAll(_regExp, "android {\n$data\n}");
  }

  /// Namespace.
  ///
  /// 名前空間。
  String? namespace;

  /// SDK version of the compilation.
  ///
  /// コンパイルのSDKバージョン。
  String compileSdkVersion;

  /// NDK Version.
  ///
  /// NDKのバージョン。
  String? ndkVersion;

  /// Build tool version.
  ///
  /// ビルドツールのバージョン。
  String? buildToolsVersion;

  /// Compile Option Setting.
  ///
  /// コンパイルオプション設定。
  GradleAndroidCompileOptions compileOptions;

  /// Kotlin option settings.
  ///
  /// Kotlinのオプション設定。
  GradleAndroidKotlinOptions kotlinOptions;

  /// Source setting.
  ///
  /// ソースの設定。
  List<GradleAndroidSourceSet> sourceSets;

  /// Default settings.
  ///
  /// デフォルトの設定。
  GradleAndroidDefaultConfig defaultConfig;

  /// Build type setting.
  ///
  /// ビルドタイプの設定。
  GradleAndroidBuildTypes buildTypes;

  /// Signature settings.
  ///
  /// 署名の設定。
  GradleAndroidSigningConfigs? signingConfigs;

  @override
  String toString() {
    return "${namespace.isEmpty ? "" : "    namespace = $namespace\n"}    compileSdk = $compileSdkVersion\n${buildToolsVersion != null ? "    buildToolsVersion = $buildToolsVersion\n" : ""}${ndkVersion != null ? "    ndkVersion = $ndkVersion\n" : ""}\n$compileOptions\n$kotlinOptions\n${sourceSets.isNotEmpty ? "    sourceSets {\n${sourceSets.map((e) => e.toString()).join("\n")}\n    }\n\n" : ""}$defaultConfig\n${signingConfigs != null ? "$signingConfigs\n" : ""}\n$buildTypes";
  }
}

/// Compile Option Setting.
///
/// コンパイルオプション設定。
class GradleAndroidCompileOptions {
  /// Compile Option Setting.
  ///
  /// コンパイルオプション設定。
  GradleAndroidCompileOptions({
    required this.sourceCompatibility,
    required this.targetCompatibility,
    this.coreLibraryDesugaringEnabled,
  });

  factory GradleAndroidCompileOptions._load(String content) {
    final region = _regExp.firstMatch(content)?.group(1) ?? "";
    final sourceCompatibility =
        RegExp("sourceCompatibility = ([a-zA-Z0-9_\"'.-]+)")
                .firstMatch(region)
                ?.group(1) ??
            "";
    final targetCompatibility =
        RegExp("targetCompatibility = ([a-zA-Z0-9_\"'.-]+)")
                .firstMatch(region)
                ?.group(1) ??
            "";
    final coreLibraryDesugaringEnabledString =
        RegExp("isCoreLibraryDesugaringEnabled = ([a-zA-Z0-9_\"'.-]+)")
            .firstMatch(region)
            ?.group(1)
            ?.toLowerCase();
    final coreLibraryDesugaringEnabled =
        coreLibraryDesugaringEnabledString == null
            ? null
            : (coreLibraryDesugaringEnabledString == "true" ? true : false);
    return GradleAndroidCompileOptions(
      sourceCompatibility: sourceCompatibility,
      targetCompatibility: targetCompatibility,
      coreLibraryDesugaringEnabled: coreLibraryDesugaringEnabled,
    );
  }

  static final _regExp = RegExp(r"compileOptions {([\s\S]+?)}");

  /// Data for `sourceCompatibility`.
  ///
  /// `sourceCompatibility`のデータ。
  String sourceCompatibility;

  /// Data for `targetCompatibility`.
  ///
  /// `targetCompatibility`のデータ。
  String targetCompatibility;

  /// Data for `coreLibraryDesugaringEnabled`.
  ///
  /// `coreLibraryDesugaringEnabled`のデータ。
  bool? coreLibraryDesugaringEnabled;

  @override
  String toString() {
    return "    compileOptions {\n        sourceCompatibility = $sourceCompatibility\n        targetCompatibility = $targetCompatibility${coreLibraryDesugaringEnabled != null ? "\n        isCoreLibraryDesugaringEnabled = $coreLibraryDesugaringEnabled" : ""}\n    }\n";
  }
}

/// Kotlin option settings.
///
/// Kotlinのオプション設定。
class GradleAndroidKotlinOptions {
  /// Kotlin option settings.
  ///
  /// Kotlinのオプション設定。
  GradleAndroidKotlinOptions({
    required this.jvmTarget,
  });

  factory GradleAndroidKotlinOptions._load(String content) {
    final region = _regExp.firstMatch(content)?.group(1) ?? "";
    final jvmTarget = RegExp("jvmTarget = ([a-zA-Z0-9_\"'().-]+)")
            .firstMatch(region)
            ?.group(1) ??
        "'1.8'";
    return GradleAndroidKotlinOptions(
      jvmTarget: jvmTarget,
    );
  }

  static final _regExp = RegExp(r"kotlinOptions {([\s\S]+?)}");

  /// Setting of `jvmTarget`.
  ///
  /// `jvmTarget`の設定。
  String jvmTarget;

  @override
  String toString() {
    return "    kotlinOptions {\n        jvmTarget = $jvmTarget\n    }\n";
  }
}

/// Source setting.
///
/// ソースの設定。
class GradleAndroidSourceSet {
  /// Source setting.
  ///
  /// ソースの設定。
  GradleAndroidSourceSet({
    required this.source,
    required this.target,
    required this.symbol,
  });

  static final _regExp = RegExp(r"sourceSets {([\s\S]+?)}");

  /// Source Target.
  ///
  /// ソースのターゲット。
  String target;

  /// Additive Method.
  ///
  /// 加算方法。
  String symbol;

  /// Path of the source data.
  ///
  /// ソースデータのパス。
  String source;

  static List<GradleAndroidSourceSet> _load(String content) {
    final region = _regExp.firstMatch(content)?.group(1) ?? "";
    return RegExp(
      "(?<target>[a-zA-Z_.-]+) (?<symbol>[+=]+) (?<source>[a-zA-Z0-9_/\"'.-]+)",
    ).allMatches(region).mapAndRemoveEmpty((e) {
      return GradleAndroidSourceSet(
        source: e.namedGroup("source") ?? "",
        symbol: e.namedGroup("symbol") ?? "",
        target: e.namedGroup("target") ?? "",
      );
    });
  }

  @override
  String toString() {
    return "        $target $symbol $source";
  }
}

/// Default settings.
///
/// デフォルトの設定。
class GradleAndroidDefaultConfig {
  /// Default settings.
  ///
  /// デフォルトの設定。
  GradleAndroidDefaultConfig({
    required this.applicationId,
    required this.minSdkVersion,
    required this.targetSdkVersion,
    required this.versionCode,
    required this.versionName,
    this.testInstrumentationRunner,
    this.multiDexEnabled,
    this.resValues = const [],
  });

  factory GradleAndroidDefaultConfig._load(String content) {
    final region = _regExp.firstMatch(content)?.group(1) ?? "";
    final applicationId =
        RegExp("applicationId = (.+)").firstMatch(region)?.group(1) ?? "";
    final minSdkVersion =
        RegExp("minSdk = (.+)").firstMatch(region)?.group(1) ?? "";
    final targetSdkVersion =
        RegExp("targetSdk = (.+)").firstMatch(region)?.group(1) ?? "";
    final versionCode =
        RegExp("versionCode = (.+)").firstMatch(region)?.group(1) ?? "";
    final versionName =
        RegExp("versionName = (.+)").firstMatch(region)?.group(1) ?? "";
    final testInstrumentationRunner =
        RegExp("testInstrumentationRunner = (.+)").firstMatch(region)?.group(1);
    final multiDexEnabled =
        RegExp("multiDexEnabled = (.+)").firstMatch(region)?.group(1);
    final resValues = RegExp("resValue(.+)")
        .allMatches(region)
        .mapAndRemoveEmpty((e) => e.group(1));
    return GradleAndroidDefaultConfig(
      applicationId: applicationId,
      minSdkVersion: minSdkVersion,
      targetSdkVersion: targetSdkVersion,
      versionCode: versionCode,
      versionName: versionName,
      testInstrumentationRunner: testInstrumentationRunner,
      multiDexEnabled: multiDexEnabled,
      resValues: resValues,
    );
  }

  static final _regExp = RegExp(r"defaultConfig {([\s\S]+?)}");

  /// Application ID.
  ///
  /// アプリケーションID。
  String applicationId;

  /// Minimum SDK version.
  ///
  /// 最小のSDKバージョン。
  String minSdkVersion;

  /// SDK version of the main target.
  ///
  /// メインターゲットのSDKバージョン。
  String targetSdkVersion;

  /// App version code.
  ///
  /// アプリのバージョンコード。
  String versionCode;

  /// Version name of the application.
  ///
  /// アプリのバージョン名。
  String versionName;

  /// Configuration of `testInstrumentationRunner`.
  ///
  /// `testInstrumentationRunner`の設定。
  String? testInstrumentationRunner;

  /// Set `multiDexEnabled`.
  ///
  /// `multiDexEnabled`の設定。
  String? multiDexEnabled;

  /// Setting of `resValue` (multiple settings possible).
  ///
  /// `resValue`の設定（複数設定可能）。
  List<String> resValues;

  @override
  String toString() {
    return "    defaultConfig {\n        applicationId = $applicationId\n        minSdk = $minSdkVersion\n        targetSdk = $targetSdkVersion\n        versionCode = $versionCode\n        versionName = $versionName\n${testInstrumentationRunner.isNotEmpty ? "        testInstrumentationRunner = $testInstrumentationRunner\n" : ""}${multiDexEnabled.isNotEmpty ? "        multiDexEnabled = $multiDexEnabled\n" : ""}${resValues.isNotEmpty ? "${resValues.map((e) => "        resValue${e.replaceAll(RegExp(r"^resValue\s*"), "")}").join("\n")}\n" : ""}    }\n";
  }
}

/// Build type setting.
///
/// ビルドタイプの設定。
class GradleAndroidBuildTypes {
  /// Build type setting.
  ///
  /// ビルドタイプの設定。
  GradleAndroidBuildTypes({
    this.release,
    this.debug,
  });

  factory GradleAndroidBuildTypes._load(String content) {
    final region = _regExp.firstMatch(content)?.group(1) ?? "";
    final release = _releaseRegExp.firstMatch(region)?.group(1);
    final debug = _debugRegExp.firstMatch(region)?.group(1);
    return GradleAndroidBuildTypes(
      release: release != null ? GradleAndroidBuildType._load(release) : null,
      debug: debug != null ? GradleAndroidBuildType._load(debug) : null,
    );
  }

  static final _regExp = RegExp(r"buildTypes {([\s\S]+)}");
  static final _releaseRegExp = RegExp(r"release {([\s\S]+?)}");
  static final _debugRegExp = RegExp(r"debug {([\s\S]+?)}");

  /// Settings at the time of release.
  ///
  /// リリース時の設定。
  GradleAndroidBuildType? release;

  /// Settings during debugging.
  ///
  /// デバッグ時の設定。
  GradleAndroidBuildType? debug;

  @override
  String toString() {
    if (release == null && debug == null) {
      return "";
    }
    return "    buildTypes {\n${release != null ? "        release {\n$release        }\n" : ""}${debug != null ? "        debug {\n$debug        }\n" : ""}    }\n";
  }
}

/// Configuration class for the contents of [GradleAndroidBuildTypes].
///
/// [GradleAndroidBuildTypes]の中身の設定クラス。
class GradleAndroidBuildType {
  /// Configuration class for the contents of [GradleAndroidBuildTypes].
  ///
  /// [GradleAndroidBuildTypes]の中身の設定クラス。
  GradleAndroidBuildType({
    required this.signingConfig,
    this.minifyEnabled,
    this.shrinkResources,
  });

  factory GradleAndroidBuildType._load(String content) {
    final signingConfig =
        RegExp("signingConfig = (.+)").firstMatch(content)?.group(1) ?? "";
    final minifyEnabled =
        RegExp("minifyEnabled = (.+)").firstMatch(content)?.group(1);
    final shrinkResources =
        RegExp("shrinkResources = (.+)").firstMatch(content)?.group(1);
    return GradleAndroidBuildType(
      signingConfig: signingConfig,
      minifyEnabled: minifyEnabled,
      shrinkResources: shrinkResources,
    );
  }

  /// Signature Method.
  ///
  /// 署名方法。
  String signingConfig;

  /// Set `minifyEnabled`.
  ///
  /// `minifyEnabled`の設定。
  String? minifyEnabled;

  /// Set `shrinkResources`.
  ///
  /// `shrinkResources`の設定。
  String? shrinkResources;

  @override
  String toString() {
    return "            signingConfig = $signingConfig\n${minifyEnabled != null ? "            minifyEnabled = $minifyEnabled\n" : ""}${shrinkResources != null ? "            shrinkResources = $shrinkResources\n" : ""}";
  }
}

/// Signature settings.
///
/// 署名の設定。
class GradleAndroidSigningConfigs {
  /// Signature settings.
  ///
  /// 署名の設定。
  GradleAndroidSigningConfigs({
    this.release,
    this.debug,
    bool isKotlin = true,
  }) : _isKotlin = isKotlin;

  factory GradleAndroidSigningConfigs._load(String content) {
    final region = _regExp.firstMatch(content)?.group(1) ?? "";

    final release = region.contains("create(") || region.contains("getByName(")
        ? _releaseWithKotlinRegExp.firstMatch(region)?.group(1)
        : _releaseRegExp.firstMatch(region)?.group(1);
    final debug = region.contains("create(") || region.contains("getByName(")
        ? _debugWithKotlinRegExp.firstMatch(region)?.group(1)
        : _debugRegExp.firstMatch(region)?.group(1);
    return GradleAndroidSigningConfigs(
      release:
          release != null ? GradleAndroidSigningConfig._load(release) : null,
      debug: debug != null ? GradleAndroidSigningConfig._load(debug) : null,
      isKotlin: region.contains("create(") || region.contains("getByName("),
    );
  }

  static final _regExp = RegExp(r"signingConfigs {([\s\S]+)}");
  static final _releaseRegExp = RegExp(r"release {([\s\S]+?)}");
  static final _debugRegExp = RegExp(r"debug {([\s\S]+?)}");
  static final _releaseWithKotlinRegExp =
      RegExp(r'create\("release"\) {([\s\S]+?)}');
  static final _debugWithKotlinRegExp =
      RegExp(r'getByName\("debug"\) {([\s\S]+?)}');

  /// Settings at the time of release.
  ///
  /// リリース時の設定。
  GradleAndroidSigningConfig? release;

  /// Settings during debugging.
  ///
  /// デバッグ時の設定。
  GradleAndroidSigningConfig? debug;

  /// Whether the file is written in Kotlin.
  ///
  /// ファイルがKotlinで書かれているかどうか。
  bool get isKotlin => _isKotlin;
  final bool _isKotlin;

  @override
  String toString() {
    if (release == null && debug == null) {
      return "";
    }
    if (isKotlin) {
      return "    signingConfigs {\n${release != null ? "        create(\"release\") {\n$release        }\n" : ""}${debug != null ? "        getByName(\"debug\") {\n$debug        }\n" : ""}    }\n";
    } else {
      return "    signingConfigs {\n${release != null ? "        release {\n$release        }\n" : ""}${debug != null ? "        debug {\n$debug        }\n" : ""}    }\n";
    }
  }
}

/// Configuration class for the contents of [GradleAndroidSigningConfigs].
///
/// [GradleAndroidSigningConfigs]の中身の設定クラス。
class GradleAndroidSigningConfig {
  /// Configuration class for the contents of [GradleAndroidSigningConfigs].
  ///
  /// [GradleAndroidSigningConfigs]の中身の設定クラス。
  GradleAndroidSigningConfig({
    required this.keyAlias,
    required this.keyPassword,
    required this.storeFile,
    required this.storePassword,
    bool isKotlin = false,
  }) : _isKotlin = isKotlin;

  factory GradleAndroidSigningConfig._load(String content) {
    final keyAlias =
        RegExp("keyAlias = (.+)").firstMatch(content)?.group(1) ?? "";
    final keyPassword =
        RegExp("keyPassword = (.+)").firstMatch(content)?.group(1) ?? "";
    final storeFile =
        RegExp("storeFile = (.+)").firstMatch(content)?.group(1) ?? "";
    final storePassword =
        RegExp("storePassword = (.+)").firstMatch(content)?.group(1) ?? "";
    return GradleAndroidSigningConfig(
      keyAlias: keyAlias,
      keyPassword: keyPassword,
      storeFile: storeFile,
      storePassword: storePassword,
      isKotlin: content.contains("as String?"),
    );
  }

  /// Keystore alias.
  ///
  /// Keystoreのエイリアス。
  String keyAlias;

  /// Keystore alias password.
  ///
  /// Keystoreのエイリアスパスワード。
  String keyPassword;

  /// Keystore file path.
  ///
  /// Keystoreのファイルパス。
  String storeFile;

  /// Keystore password.
  ///
  /// Keystoreのパスワード。
  String storePassword;

  /// Whether the file is written in Kotlin.
  ///
  /// ファイルがKotlinで書かれているかどうか。
  bool get isKotlin => _isKotlin;
  final bool _isKotlin;

  @override
  String toString() {
    return "            keyAlias = $keyAlias\n            keyPassword = $keyPassword\n            storeFile = $storeFile\n            storePassword = $storePassword\n";
  }
}

/// Data in the `dependencies` section.
///
/// `dependencies`セクションのデータ。
class GradleDependencies {
  /// Data in the `android` section.
  ///
  /// `dependencies`セクションのデータ。
  GradleDependencies({
    required this.group,
    required this.packageName,
    bool isKotlin = false,
  }) : _isKotlin = isKotlin;

  /// Whether the file is written in Kotlin.
  ///
  /// ファイルがKotlinで書かれているかどうか。
  bool get isKotlin => _isKotlin;
  final bool _isKotlin;

  static final _regExp = RegExp(r"dependencies {([\s\S]*?)\n?}");

  static List<GradleDependencies> _load(String content) {
    final region = _regExp.firstMatch(content)?.group(1) ?? "";
    final isKotlin = content.contains('("');
    if (isKotlin) {
      final implmentations =
          RegExp(r'(?<group>[a-zA-Z]+)\("(?<packageName>[^"]+)"\)')
              .allMatches(region);
      return implmentations
          .map(
            (e) => GradleDependencies(
              group: e.namedGroup("group") ?? "",
              packageName: e.namedGroup("packageName") ?? "",
              isKotlin: true,
            ),
          )
          .toList();
    } else {
      final implmentations =
          RegExp("(?<group>[a-zA-Z]+) \"(?<packageName>[^\"]+)\"")
              .allMatches(region);
      return implmentations
          .map(
            (e) => GradleDependencies(
              group: e.namedGroup("group") ?? "",
              packageName: e.namedGroup("packageName") ?? "",
            ),
          )
          .toList();
    }
  }

  static String _save(String content, List<GradleDependencies> data) {
    return content.replaceAll(_regExp, "dependencies {\n${data.join("\n")}\n}");
  }

  /// Group.
  ///
  /// グループ。
  String group;

  /// Dependency package name.
  ///
  /// 依存関係のパッケージ名。
  String packageName;

  @override
  String toString() {
    if (isKotlin) {
      return "    $group(\"$packageName\")";
    } else {
      return "    $group \"$packageName\"";
    }
  }
}

/// Class for retrieving and saving files in `android/build.gradle`.
///
/// `android/build.gradle`のファイルを取得して保存するためのクラス。
class BuildGradle {
  /// Class for retrieving and saving files in `android/build.gradle`.
  ///
  /// `android/build.gradle`のファイルを取得して保存するためのクラス。
  BuildGradle();

  /// Whether the file is written in Kotlin.
  ///
  /// ファイルがKotlinで書かれているかどうか。
  bool get isKotlin => _isKotlin;
  bool _isKotlin = false;

  /// Original text data.
  ///
  /// 元のテキストデータ。
  String get rawData => _rawData;
  late String _rawData;

  /// Data in the `buildScript` section.
  ///
  /// `buildScript`セクションのデータ。
  GradleBuildScript get buildScript => _buildScript;
  late GradleBuildScript _buildScript;

  /// Data in the `allprojects` section.
  ///
  /// `allprojects`セクションのデータ。
  GradleAllprojects get allProjects => _allProjects;
  late GradleAllprojects _allProjects;

  /// Data loading.
  ///
  /// データの読み込み。
  Future<void> load() async {
    if (File("android/build.gradle").existsSync()) {
      final gradle = File("android/build.gradle");
      _rawData = await gradle.readAsString();
    } else if (File("android/build.gradle.kts").existsSync()) {
      _isKotlin = true;
      final gradle = File("android/build.gradle.kts");
      _rawData = await gradle.readAsString();
    }
    _buildScript = GradleBuildScript._load(_rawData);
    _allProjects = GradleAllprojects._load(_rawData);
  }

  /// Data storage.
  ///
  /// データの保存。
  Future<void> save() async {
    if (_rawData.isEmpty) {
      throw Exception("No value. Please load data with [load].");
    }
    _rawData = GradleBuildScript._save(_rawData, _buildScript);
    _rawData = GradleAllprojects._save(_rawData, _allProjects);
    if (File("android/build.gradle").existsSync()) {
      final gradle = File("android/build.gradle");
      await gradle.writeAsString(_rawData);
    } else if (File("android/build.gradle.kts").existsSync()) {
      final gradle = File("android/build.gradle.kts");
      await gradle.writeAsString(_rawData);
    }
  }
}

/// Data in the `buildscript` section.
///
/// `buildscript`セクションのデータ。
class GradleBuildScript {
  /// Data in the `buildscript` section.
  ///
  /// `buildscript`セクションのデータ。
  GradleBuildScript({
    required this.kotlinVersion,
    required List<GradleBuildscriptDependencies> dependencies,
  }) : _dependencies = dependencies;

  factory GradleBuildScript._load(String content) {
    final region = _regExp.firstMatch(content)?.group(1) ?? "";
    final kotlinVersion =
        (RegExp("ext.kotlin_version()[\\s\\S]+?=[\\s\\S]+?([a-zA-Z0-9_\"'.-]+)")
                    .firstMatch(region)
                    ?.group(1) ??
                Config.androidKotlinVersion)
            .trimString("'")
            .trimString('"');
    final dependencies = GradleBuildscriptDependencies._load(content);
    return GradleBuildScript(
      kotlinVersion: kotlinVersion,
      dependencies: dependencies,
    );
  }

  static final _regExp = RegExp(r"buildscript {([\s\S]+?)\n}");

  static String _save(String content, GradleBuildScript data) {
    var region = _regExp.firstMatch(content)?.group(1) ?? "";
    region = region.replaceAll(
      RegExp("ext.kotlin_version()[\\s\\S]+?=[\\s\\S]+?([a-zA-Z0-9_\"'.-]+)"),
      "ext.kotlin_version = '${data.kotlinVersion}'",
    );
    region = GradleBuildscriptDependencies._save(region, data.dependencies);
    return content.replaceAll(
        _regExp, "buildscript {\n${region.trimString("\n")}\n}");
  }

  /// Kotlin version.
  ///
  /// Kotlinバージョン。
  String? kotlinVersion;

  /// Data in the `dependencies` section.
  ///
  /// `dependencies`セクションのデータ。
  List<GradleBuildscriptDependencies> get dependencies => _dependencies;
  final List<GradleBuildscriptDependencies> _dependencies;

  @override
  String toString() {
    return "    ext.kotlin_version = '$kotlinVersion'\n";
  }
}

/// Configuration class for the contents of [GradleBuildscriptDependencies].
///
/// [GradleBuildscriptDependencies]の中身の設定クラス。
class GradleBuildscriptDependencies {
  /// Configuration class for the contents of [GradleBuildscriptDependencies].
  ///
  /// [GradleBuildscriptDependencies]の中身の設定クラス。
  GradleBuildscriptDependencies({
    required this.classpath,
  });

  static final _regExp = RegExp(r"dependencies {([\s\S]+?)}");

  /// Keystore alias.
  ///
  /// Keystoreのエイリアス。
  final String classpath;

  static List<GradleBuildscriptDependencies> _load(String content) {
    final region = _regExp.firstMatch(content)?.group(1) ?? "";
    final classpaths = RegExp("classpath (?<classpath>.+)").allMatches(region);
    return classpaths
        .map(
          (e) => GradleBuildscriptDependencies(
            classpath: e
                    .namedGroup("classpath")
                    ?.replaceAll("\n", "")
                    .trimString("'")
                    .trimString('"') ??
                "",
          ),
        )
        .toList();
  }

  static String _save(
      String content, List<GradleBuildscriptDependencies> data) {
    return content.replaceAll(
        _regExp, "dependencies {\n${data.join("\n")}\n    }");
  }

  @override
  String toString() {
    return "        classpath \"$classpath\"";
  }
}

/// Data in the `allprojects` section.
///
/// `allprojects`セクションのデータ。
class GradleAllprojects {
  /// Data in the `allprojects` section.
  ///
  /// `allprojects`セクションのデータ。
  GradleAllprojects({
    required List<GradleAllprojectsConfigurations> configurations,
  }) : _configurations = configurations;

  factory GradleAllprojects._load(String content) {
    final configurations = GradleAllprojectsConfigurations._load(content);
    return GradleAllprojects(
      configurations: configurations,
    );
  }

  static final _regExp = RegExp(r"allprojects {([\s\S]+?)\n}");

  static String _save(String content, GradleAllprojects data) {
    var region = _regExp.firstMatch(content)?.group(1) ?? "";
    region = GradleAllprojectsConfigurations._save(region, data.configurations);
    return content.replaceAll(
        _regExp, "allprojects {\n${region.trimString("\n")}\n}");
  }

  /// Data in the `configurations.all` section.
  ///
  /// `configurations.all`セクションのデータ。
  List<GradleAllprojectsConfigurations> get configurations => _configurations;
  final List<GradleAllprojectsConfigurations> _configurations;

  @override
  String toString() {
    return "";
  }
}

/// Configuration class for the contents of [GradleAllprojectsConfigurations].
///
/// [GradleAllprojectsConfigurations]の中身の設定クラス。
class GradleAllprojectsConfigurations {
  /// Configuration class for the contents of [GradleAllprojectsConfigurations].
  ///
  /// [GradleAllprojectsConfigurations]の中身の設定クラス。
  GradleAllprojectsConfigurations({
    required this.command,
  });

  static final _regExp = RegExp(r"configurations\.all {([\s\S]+?)}");

  /// Command.
  ///
  /// コマンド。
  final String command;

  static List<GradleAllprojectsConfigurations> _load(String content) {
    final region = _regExp.firstMatch(content)?.group(1) ?? "";
    final commands = region
        .replaceAll("\r\n", "\n")
        .replaceAll("\r", "\n")
        .split("\n")
        .map((e) => e.trim())
        .toList();
    return commands
        .map(
          (e) => GradleAllprojectsConfigurations(
            command: e,
          ),
        )
        .toList();
  }

  static String _save(
      String content, List<GradleAllprojectsConfigurations> data) {
    return content.replaceAll(
        _regExp, "configurations.all {\n${data.join("\n")}\n    }");
  }

  @override
  String toString() {
    return "        $command";
  }
}

/// Class for retrieving and saving files in `android/settings.gradle`.
///
/// `android/settings.gradle`のファイルを取得して保存するためのクラス。
class SettingsGradle {
  /// Class for retrieving and saving files in `android/settings.gradle`.
  ///
  /// `android/settings.gradle`のファイルを取得して保存するためのクラス。
  SettingsGradle();

  /// Whether the file is written in Kotlin.
  ///
  /// ファイルがKotlinで書かれているかどうか。
  bool get isKotlin => _isKotlin;
  bool _isKotlin = false;

  /// Original text data.
  ///
  /// 元のテキストデータ。
  String get rawData => _rawData;
  late String _rawData;

  /// Data in the `plugins` section.
  ///
  /// `plugins`セクションのデータ。
  List<SettingsGradlePlugins> get plugins => _plugins;
  late List<SettingsGradlePlugins> _plugins;

  /// Data loading.
  ///
  /// データの読み込み。
  Future<void> load() async {
    if (File("android/settings.gradle").existsSync()) {
      final gradle = File("android/settings.gradle");
      _rawData = await gradle.readAsString();
    } else if (File("android/settings.gradle.kts").existsSync()) {
      _isKotlin = true;
      final gradle = File("android/settings.gradle.kts");
      _rawData = await gradle.readAsString();
    }
    _plugins = SettingsGradlePlugins._load(_rawData);
  }

  /// Data storage.
  ///
  /// データの保存。
  Future<void> save() async {
    if (_rawData.isEmpty) {
      throw Exception("No value. Please load data with [load].");
    }
    _rawData = SettingsGradlePlugins._save(_rawData, _plugins);

    if (File("android/settings.gradle").existsSync()) {
      final gradle = File("android/settings.gradle");
      await gradle.writeAsString(_rawData);
    } else if (File("android/settings.gradle.kts").existsSync()) {
      final gradle = File("android/settings.gradle.kts");
      await gradle.writeAsString(_rawData);
    }
  }
}

/// Configuration class for the contents of [SettingsGradlePlugins].
///
/// [GradleAllprojectsConfigurations]の中身の設定クラス。
class SettingsGradlePlugins {
  /// Configuration class for the contents of [SettingsGradlePlugins].
  ///
  /// [SettingsGradlePlugins]の中身の設定クラス。
  SettingsGradlePlugins({
    required this.package,
    required this.version,
    this.apply,
    this.isKotlin = false,
  });

  static final _regExp = RegExp(
    "id\\(?['\"](?<package>[a-zA-Z0-9._-]+)['\"]\\)? version ['\"](?<version>[a-zA-Z0-9._-]+)['\"]( apply (?<apply>[a-zA-Z]+))?",
  );

  /// Whether the file is written in Kotlin.
  ///
  /// ファイルがKotlinで書かれているかどうか。
  final bool isKotlin;

  /// Package Name.
  ///
  /// パッケージ名。
  final String package;

  /// Version.
  ///
  /// バージョン。
  final String version;

  /// Apply or not.
  ///
  /// 適用するかどうか。
  final bool? apply;

  static List<SettingsGradlePlugins> _load(String content) {
    final newRegion =
        RegExp(r"plugins[^{]*?\{([\s\S]*?)\}").firstMatch(content);
    if (newRegion == null) {
      return [];
    }
    final regionText = newRegion.group(1) ?? "";
    final packages = _regExp.allMatches(regionText);
    return packages
        .map(
          (e) => SettingsGradlePlugins(
            package: e.namedGroup("package") ?? "",
            version: e.namedGroup("version") ?? "",
            apply: e.namedGroup("apply") == null
                ? null
                : e.namedGroup("apply") == "true",
            isKotlin: regionText.contains('id("'),
          ),
        )
        .toList();
  }

  static String _save(String content, List<SettingsGradlePlugins> data) {
    final newRegion =
        RegExp(r"plugins[^{]*?\{([\s\S]*?)\}").firstMatch(content);
    if (newRegion == null) {
      return content;
    }
    final code = data.map((e) => e.toString()).join("\n");
    return content.replaceAll(
      RegExp(
        r"plugins[^{]*?\{([\s\S]*?)\}",
      ),
      "plugins {\n$code\n}",
    );
  }

  @override
  String toString() {
    if (isKotlin) {
      return "    id(\"$package\") version \"$version\"${apply != null ? " apply ${apply! ? "true" : "false"}" : ""}";
    } else {
      return "    id \"$package\" version \"$version\"${apply != null ? " apply ${apply! ? "true" : "false"}" : ""}";
    }
  }
}
