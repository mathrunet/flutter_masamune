// ignore_for_file: implementation_imports

// Dart imports:
import "dart:io";

// Package imports:
import "package:html/dom.dart";
import "package:html/parser.dart";
import "package:image/image.dart";
import "package:image/src/formats/ico_encoder.dart";
import "package:xml/xml.dart";

// Project imports:
import "package:katana_cli/ai/claude_code.dart";
import "package:katana_cli/ai/designs/designs.dart";
import "package:katana_cli/ai/docs/docs.dart";
import "package:katana_cli/ai/impls/impls.dart";
import "package:katana_cli/ai/tests/tests.dart";
import "package:katana_cli/katana.dart";
import "package:katana_cli/katana_cli.dart";
import "package:katana_cli/localize.dart";
import "package:katana_cli/snippet/snippet.dart";
import "package:katana_cli/src/android_manifest.dart";

/// Flavors.
///
/// フレーバー。
final flavors = [
  "dev",
  "stg",
  "prod",
];

/// Package to import.
///
/// インポートするパッケージ。
final importPackages = [
  "masamune",
  "masamune_universal_ui",
  "freezed_annotation",
  "json_annotation",
];

/// Additional import packages if the "-a" option is used.
///
/// "-a"のオプションが利用された場合の追加インポートパッケージ。
final allOptionsImportPackage = [
  "masamune_animate",
  "font_awesome_flutter",
  "url_strategy",
];

/// Package for dev to import.
///
/// インポートするdev用パッケージ。
final importDevPackages = [
  "build_runner",
  "masamune_builder",
  "masamune_lints",
  "masamune_test",
  "freezed",
  "json_serializable",
];

/// Other generated files.
///
/// その他の生成ファイル。
const otherFiles = {
  "launch.json": LaunchCliCode(),
  "settings.json": SettingsCliCode(),
  "tasks.json": TasksCliCode(),
};

final _faviconSize = [
  16,
  32,
  192,
];

/// Create a new Flutter project.
///
/// 新しいFlutterプロジェクトを作成します。
class CreateCliCommand extends CliCommand {
  /// Create a new Flutter project.
  ///
  /// 新しいFlutterプロジェクトを作成します。
  const CreateCliCommand();

  @override
  String get description =>
      "Create a new Flutter project. 新しいFlutterプロジェクトを作成します。";

  @override
  String? get example => "katana create [application_id]";

  @override
  Future<void> exec(ExecContext context) async {
    final bin = context.yaml.getAsMap("bin");
    final flutter = bin.get("flutter", "flutter");
    final dart = bin.get("dart", "dart");
    final packageName = context.args.get(1, "");
    if (packageName.isEmpty) {
      error(
        "Please provide the name of the package.\r\nパッケージ名を記載してください。\r\n\r\nkatana create [package name]",
      );
      return;
    }
    final projectName = packageName.split(".").lastOrNull;
    final domain = packageName
        .split(".")
        .sublist(0, packageName.split(".").length - 1)
        .join(".");
    if (projectName.isEmpty || domain.isEmpty) {
      error(
        "The format of the package name should be specified in the following format.\r\nパッケージ名の形式は下記の形式で指定してください。\r\n\r\n[Domain].[ProjectName]\r\ne.g. net.mathru.website",
      );
      return;
    }
    await command(
      "Create a Flutter project.",
      [
        flutter,
        "create",
        "--org",
        domain,
        "--project-name",
        projectName!,
        ".",
      ],
    );
    await command(
      "Import packages.",
      [
        flutter,
        "pub",
        "add",
        ...importPackages,
      ],
    );
    await command(
      "Import dev packages.",
      [
        flutter,
        "pub",
        "add",
        "--dev",
        ...importDevPackages,
        "import_sorter",
      ],
    );
    label("Replace lib/main.dart");
    await const MainCliCode().generateDartCode("lib/main", "main");
    label("Replace lib/theme.dart");
    await const MainThemeCliCode().generateDartCode("lib/theme", "theme");
    label("Replace lib/router.dart");
    await const MainRouterCliCode().generateDartCode("lib/router", "router");
    label("Replace lib/localize.dart");
    await const MainLocalizeCliCode()
        .generateDartCode("lib/localize", "localize");
    label("Generate localize.base.yaml");
    await const LocalizeYamlCliCode().generateFile("localize.base.yaml");
    label("Generate localize.app.yaml");
    await const AppLocalizeYamlCliCode().generateFile("localize.app.yaml");
    label("Replace lib/adapter.dart");
    await const MainAdapterCliCode().generateDartCode("lib/adapter", "adapter");
    label("Replace lib/config.dart");
    await const MainConfigCliCode().generateDartCode("lib/config", "config");
    label("Create home.dart");
    await const HomePageCliCode().generateDartCode("lib/pages/home", "home");
    label("Create counter.dart");
    await const CounterModelCliCode()
        .generateDartCode("lib/models/counter", "counter");
    label("Generate file for VSCode");
    for (final file in otherFiles.entries) {
      await file.value.generateFile(file.key);
    }
    label("Create a katana.yaml");
    await const KatanaCliCode(false).generateFile("katana.yaml");
    label("Replace LICENSE");
    await const LicenseCliCode().generateFile("LICENSE");
    label("Create a katana_secrets.yaml");
    await const KatanaSecretsCliCode().generateFile("katana_secrets.yaml");
    label("Create a pubspec_overrides.yaml");
    await const PubspecOverridesCliCode()
        .generateFile("pubspec_overrides.yaml");
    // label("Create a build.yaml");
    // await const BuildCliCode().generateFile("build.yaml");
    label("Create a dart_defines/**.env");
    for (final flavor in flavors) {
      await DartDefinesCliCode(
        packageName: "$domain.$projectName",
        flavor: flavor,
      ).generateFile("$flavor.env");
    }
    label("Edit a analysis_options.yaml");
    await const AnalysisOptionsCliCode().generateFile("analysis_options.yaml");
    label("Create a flutter_test_config.dart");
    await const FlutterTestConfigCliCode()
        .generateFile("flutter_test_config.dart");
    label("Remove a widget_test.dart");
    final widgetTestFile = File("test/widget_test.dart");
    if (widgetTestFile.existsSync()) {
      await widgetTestFile.delete();
    }
    label("Create a loader.css");
    await const LoaderCssCliCode().generateFile("loader.css");
    label("Create a flutter_bootstrap.js");
    await const BootstrapJsCliCode().generateFile("flutter_bootstrap.js");
    label("Edit as index.html");
    final indexHtmlFile = File("web/index.html");
    final htmlDocument = parse(await indexHtmlFile.readAsString());
    final body = htmlDocument.body;
    final head = htmlDocument.head;
    if (body != null) {
      if (!body.children.any((element) =>
          element.localName == "div" && element.classes.contains("loading"))) {
        body.children.insertFirst(
          Element.tag("div")
            ..classes.add("loading")
            ..children.add(
              Element.tag("div")
                ..children.addAll(
                  [
                    Element.tag("img")
                      ..attributes["src"] = "icons/Icon-192.png"
                      ..classes.add("logo"),
                    Element.tag("div")..classes.add("loader-bar")
                  ],
                ),
            ),
        );
      }
    }
    if (head != null) {
      if (!head.children.any((element) =>
          element.localName == "link" &&
          element.attributes["rel"] == "stylesheet" &&
          element.attributes["href"] == "loader.css")) {
        head.children.add(Element.tag("link")
          ..attributes["rel"] = "stylesheet"
          ..attributes["href"] = "loader.css"
          ..attributes["type"] = "text/css"
          ..attributes["media"] = "all");
      }
      final icon = head.children.firstWhereOrNull((item) =>
          item.localName == "link" && item.attributes["rel"] == "icon");
      if (icon == null) {
        head.children.add(Element.tag("link")
          ..attributes["rel"] = "icon"
          ..attributes["href"] = "favicon.ico");
      } else if (icon.attributes["href"] != "favicon.ico") {
        icon.attributes["href"] = "favicon.ico";
        icon.attributes.remove("type");
      }
    }
    await indexHtmlFile.writeAsString(
      htmlDocument.outerHtml.replaceAll(
        "<script src=\"flutter_bootstrap.js\" async=\"\"></script>",
        "<script>{{flutter_bootstrap_js}}</script>",
      ),
    );
    label("Create a favicon.ico");
    final iconFile = File("web/icons/Icon-512.png");
    final iconImage = decodeImage(iconFile.readAsBytesSync())!;
    final icoPngFile = File("web/favicon.png");
    if (icoPngFile.existsSync()) {
      await icoPngFile.delete();
    }
    final icoFile = File("web/favicon.ico");
    if (icoFile.existsSync()) {
      await icoFile.delete();
    }
    final ico = IcoEncoder();
    await icoFile.writeAsBytes(
      ico.encodeImages(_faviconSize.map((e) {
        return copyResize(
          iconImage,
          height: e,
          width: e,
          interpolation: Interpolation.average,
        );
      }).toList()),
    );
    label("Create a feature.png");
    final featurePngFile = File("web/feature.png");
    if (!featurePngFile.existsSync()) {
      await featurePngFile.writeAsBytes(
        encodePng(
          copyResize(
            iconImage,
            height: 512,
            width: 512,
            interpolation: Interpolation.average,
          ),
        ),
      );
    }
    label("Create a assets directory");
    final assetsDirectory = Directory("assets");
    if (!assetsDirectory.existsSync()) {
      await assetsDirectory.create();
    }
    label("Edit AndroidManifest.xml.");
    await AndroidManifestPermissionType.internet.enablePermission();
    await AndroidManifestQueryType.openLinkHttps.enableQuery();
    await AndroidManifestQueryType.dialTel.enableQuery();
    await AndroidManifestQueryType.sendEmail.enableQuery();
    await AndroidManifestQueryType.sendAny.enableQuery();
    label("Edit env.properties");
    await DartDefinesEnvPropertiesCliCode(
      packageName: "$domain.$projectName",
    ).generateFile("env.properties");
    label("Add processing to the Gradle file.");
    final gradle = AppGradle();
    await gradle.load();
    if (gradle.isKotlin &&
        !gradle.imports.any((e) => e.import == "java.util.Properties")) {
      gradle.imports.add(
        GradleImport(
          import: "java.util.Properties",
        ),
      );
    }
    if (!gradle.loadProperties.any((e) => e.name == "envProperties")) {
      gradle.loadProperties.add(
        GradleLoadProperties(
          path: "env.properties",
          name: "envProperties",
          file: "envPropertiesFile",
          isKotlin: gradle.isKotlin,
        ),
      );
    }
    await gradle.save();
    label("Edit Debug.xcconfig");
    final xcconfigDebugFile = File("ios/Flutter/Debug.xcconfig");
    if (!xcconfigDebugFile.existsSync()) {
      error(
        "Cannot find `ios/Flutter/Debug.xcconfig`. Project is broken.",
      );
      return;
    }
    final xcconfigDebug = await xcconfigDebugFile.readAsLines();
    if (!xcconfigDebug
        .any((e) => e.startsWith("#include \"DartDefine.xcconfig\""))) {
      xcconfigDebug.add("#include \"DartDefine.xcconfig\"");
    }
    await xcconfigDebugFile.writeAsString(xcconfigDebug.join("\n"));
    label("Edit Release.xcconfig");
    final xcconfigReleaseFile = File("ios/Flutter/Release.xcconfig");
    if (!xcconfigDebugFile.existsSync()) {
      error(
        "Cannot find `ios/Flutter/Release.xcconfig`. Project is broken.",
      );
      return;
    }
    final xcconfigRelease = await xcconfigReleaseFile.readAsLines();
    if (!xcconfigRelease
        .any((e) => e.startsWith("#include \"DartDefine.xcconfig\""))) {
      xcconfigRelease.add("#include \"DartDefine.xcconfig\"");
    }
    await xcconfigReleaseFile.writeAsString(xcconfigRelease.join("\n"));
    label("Edit DartDefine.xcconfig");
    await DartDefinesXcconfigCliCode(
      packageName: "$domain.$projectName",
    ).generateFile("DartDefine.xcconfig");
    label("Edit AppDelegate.swift on IOS");
    final appDelegateIos = File("ios/Runner/AppDelegate.swift");
    if (appDelegateIos.existsSync()) {
      final document = await appDelegateIos.readAsString();
      final newDocument = """
#if canImport(UIKit) && canImport(Flutter)
$document
#endif
""";
      await appDelegateIos.writeAsString(newDocument);
    }
    label("Edit RunnerTest.swift on IOS");
    final runnerTestsIos = File("ios/RunnerTests/RunnerTests.swift");
    if (runnerTestsIos.existsSync()) {
      final document = await runnerTestsIos.readAsString();
      final newDocument = """
#if canImport(UIKit) && canImport(Flutter) && canImport(XCTest)
$document
#endif
""";
      await runnerTestsIos.writeAsString(newDocument);
    }
    label("Edit AppDelegate.swift on MacOS");
    final appDelegateMacOS = File("macos/Runner/AppDelegate.swift");
    if (appDelegateMacOS.existsSync()) {
      final document = await appDelegateMacOS.readAsString();
      final newDocument = """
#if canImport(Cocoa) && canImport(FlutterMacOS)
$document
#endif
""";
      await appDelegateMacOS.writeAsString(newDocument);
    }
    label("Edit MainFlutterWindow.swift on MacOS");
    final mainFlutterWindowMacOS = File("macos/Runner/MainFlutterWindow.swift");
    if (mainFlutterWindowMacOS.existsSync()) {
      final document = await mainFlutterWindowMacOS.readAsString();
      final newDocument = """
#if canImport(Cocoa) && canImport(FlutterMacOS)
$document
#endif
""";
      await mainFlutterWindowMacOS.writeAsString(newDocument);
    }
    label("Edit RunnerTest.swift on MacOS");
    final runnerTestsMacOS = File("macos/RunnerTests/RunnerTests.swift");
    if (runnerTestsMacOS.existsSync()) {
      final document = await runnerTestsMacOS.readAsString();
      final newDocument = """
#if canImport(Cocoa) && canImport(FlutterMacOS) && canImport(XCTest)
$document
#endif
""";
      await runnerTestsMacOS.writeAsString(newDocument);
    }
    label("Edit DebugProfile.entitlements.");
    final debugEntitlements = File("macos/Runner/DebugProfile.entitlements");
    if (debugEntitlements.existsSync()) {
      final document =
          XmlDocument.parse(await debugEntitlements.readAsString());
      final dict = document.findAllElements("dict").firstOrNull;
      if (dict == null) {
        throw Exception(
          "Could not find `dict` element in `macos/Runner/DebugProfile.entitlements`. File is corrupt.",
        );
      }
      final node = dict.children.firstWhereOrNull((p0) {
        return p0 is XmlElement &&
            p0.name.toString() == "key" &&
            p0.innerText == "com.apple.security.network.client";
      });
      if (node == null) {
        dict.children.addAll(
          [
            XmlElement(
              XmlName("key"),
              [],
              [XmlText("com.apple.security.network.client")],
            ),
            XmlElement(
              XmlName("true"),
              [],
              [],
            ),
          ],
        );
      }
      await debugEntitlements.writeAsString(
        document.toXmlString(pretty: true, indent: "\t", newLine: "\n"),
      );
    }
    label("Replace pubspec.yaml");
    final pubspecFile = File("pubspec.yaml");
    final pubspec = await pubspecFile.readAsString();
    await pubspecFile.writeAsString(
      pubspec.replaceAll(
        RegExp(
          r"# assets:[\s\S]+#   - images/a_dot_burr.jpeg[\s\S]+#   - images/a_dot_ham.jpeg",
        ),
        "assets:\n    - assets/\n",
      ),
    );
    label("Create a .gitattributes");
    await const GitAttributesCliCode().generateFile(".gitattributes");
    label("Rewrite `.gitignore`.");
    final gitignore = File(".gitignore");
    if (!gitignore.existsSync()) {
      error("Cannot find `.gitignore`. Project is broken.");
      return;
    }
    final gitignores = await gitignore.readAsLines();
    if (!gitignores.any((e) => e.startsWith("secrets.dart"))) {
      gitignores.add("secrets.dart");
    }
    if (!gitignores.any((e) => e.startsWith("pubspec_overrides.yaml"))) {
      gitignores.add("pubspec_overrides.yaml");
    }
    if (!gitignores.any((e) => e.startsWith("/android/app/.cxx/"))) {
      gitignores.add("/android/app/.cxx/");
    }
    if (!gitignores.any((e) => e.startsWith("/android/env.properties"))) {
      gitignores.add("/android/env.properties");
    }
    if (!gitignores
        .any((e) => e.startsWith("/ios/Flutter/DartDefine.xcconfig"))) {
      gitignores.add("/ios/Flutter/DartDefine.xcconfig");
    }
    if (context.yaml.getAsMap("git").get("ignore_secure_file", true)) {
      if (!gitignores.any((e) => e.startsWith("katana_secrets.yaml"))) {
        gitignores.add("katana_secrets.yaml");
      }
    } else {
      gitignores.removeWhere((e) => e.startsWith("katana_secrets.yaml"));
    }
    if (!gitignores.any((e) => e.startsWith("documents/test/macos/**/*.*"))) {
      gitignores.add("documents/test/macos/**/*.*");
    }
    if (!gitignores.any((e) => e.startsWith("documentsdebug/**/*.*"))) {
      gitignores.add("documents/debug/**/*.*");
    }
    if (!gitignores.any((e) => e.startsWith("test/**/failures/**/*.*"))) {
      gitignores.add("test/**/failures/**/*.*");
    }
    if (!gitignores.any((e) => e.startsWith(".mcp.json"))) {
      gitignores.add(".mcp.json");
    }
    await gitignore.writeAsString(gitignores.join("\n"));
    await Future.delayed(const Duration(seconds: 5));
    await command(
      "Run the project's build_runner to generate code.",
      [
        flutter,
        "packages",
        "pub",
        "run",
        "build_runner",
        "build",
        "--delete-conflicting-outputs",
      ],
    );
    if (Platform.isMacOS) {
      await command(
        "Run `pod install`.",
        [
          "pod",
          "install",
        ],
        workingDirectory: "ios",
      );
    }
    label("Create PrivacyInfo.xcprivacy.");
    await XCode.createPrivacyManifests();
    await command(
      "Run dart format",
      [
        dart,
        "format",
        ".",
      ],
    );
    await command(
      "Run import sorter",
      [
        flutter,
        "pub",
        "run",
        "import_sorter:main",
        ".",
      ],
    );
  }
}

/// Create a new Flutter project.
///
/// 新しいFlutterプロジェクトを作成します。
class ComposeCliCommand extends CliCommand {
  /// Create a new Flutter project.
  ///
  /// 新しいFlutterプロジェクトを作成します。
  const ComposeCliCommand();

  @override
  String get description =>
      "Create a new Flutter project. 新しいFlutterプロジェクトを作成します。";

  @override
  String? get example => "katana compose [application_id]";

  @override
  Future<void> exec(ExecContext context) async {
    final bin = context.yaml.getAsMap("bin");
    final flutter = bin.get("flutter", "flutter");
    final dart = bin.get("dart", "dart");
    final packageName = context.args.get(1, "");
    if (packageName.isEmpty) {
      error(
        "Please provide the name of the package.\r\nパッケージ名を記載してください。\r\n\r\nkatana compose [package name]",
      );
      return;
    }
    final projectName = packageName.split(".").lastOrNull;
    final domain = packageName
        .split(".")
        .sublist(0, packageName.split(".").length - 1)
        .join(".");
    if (projectName.isEmpty || domain.isEmpty) {
      error(
        "The format of the package name should be specified in the following format.\r\nパッケージ名の形式は下記の形式で指定してください。\r\n\r\n[Domain].[ProjectName]\r\ne.g. net.mathru.website",
      );
      return;
    }
    await command(
      "Create a Flutter project.",
      [
        flutter,
        "create",
        "--org",
        domain,
        "--project-name",
        projectName!,
        ".",
      ],
    );
    await command(
      "Import packages.",
      [
        flutter,
        "pub",
        "add",
        ...importPackages,
        ...allOptionsImportPackage,
      ],
    );
    await command(
      "Import dev packages.",
      [
        flutter,
        "pub",
        "add",
        "--dev",
        ...importDevPackages,
        "import_sorter",
      ],
    );
    label("Replace lib/main.dart");
    await const MainCliCode().generateDartCode("lib/main", "main");
    label("Replace lib/theme.dart");
    await const MainThemeCliCode().generateDartCode("lib/theme", "theme");
    label("Replace lib/router.dart");
    await const MainRouterCliCode(
      initialQuery: "null",
      initialQueryImport: "",
    ).generateDartCode("lib/router", "router");
    label("Replace lib/localize.dart");
    await const MainLocalizeCliCode()
        .generateDartCode("lib/localize", "localize");
    label("Generate localize.base.yaml");
    await const LocalizeYamlCliCode().generateFile("localize.base.yaml");
    label("Generate localize.app.yaml");
    await const AppLocalizeYamlCliCode().generateFile("localize.app.yaml");
    label("Replace lib/adapter.dart");
    await const MainAdapterCliCode().generateDartCode("lib/adapter", "adapter");
    label("Replace lib/config.dart");
    await const MainConfigCliCode().generateDartCode("lib/config", "config");
    label("Generate file for VSCode");
    for (final file in otherFiles.entries) {
      await file.value.generateFile(file.key);
    }
    await const CodeSnippetsCliGroup().generateFiles();
    label("Generate file for Cursor AI");
    await const DesignsAiCode().exec(context);
    await const ImplsAiCode().exec(context);
    await const DocsAiCode().exec(context);
    await const GitAgentsMarkdownCliCode().generateFile("CLAUDE.md");
    await const TestsAiCode().exec(context);
    label("Create a katana.yaml");
    await const KatanaCliCode(true).generateFile("katana.yaml");
    label("Create a store.yaml");
    await const StoreYamlCliCode().generateFile("store.yaml");
    label("Replace LICENSE");
    await const LicenseCliCode().generateFile("LICENSE");
    label("Create a katana_secrets.yaml");
    await const KatanaSecretsCliCode().generateFile("katana_secrets.yaml");
    label("Create a pubspec_overrides.yaml");
    await const PubspecOverridesCliCode()
        .generateFile("pubspec_overrides.yaml");
    // label("Create a build.yaml");
    // await const BuildCliCode().generateFile("build.yaml");
    label("Create a dart_defines/**.env");
    for (final flavor in flavors) {
      await DartDefinesCliCode(
        packageName: "$domain.$projectName",
        flavor: flavor,
      ).generateFile("$flavor.env");
    }
    label("Edit a analysis_options.yaml");
    await const AnalysisOptionsCliCode().generateFile("analysis_options.yaml");
    label("Create a flutter_test_config.dart");
    await const FlutterTestConfigCliCode()
        .generateFile("flutter_test_config.dart");
    label("Remove a widget_test.dart");
    final widgetTestFile = File("test/widget_test.dart");
    if (widgetTestFile.existsSync()) {
      await widgetTestFile.delete();
    }
    label("Create a loader.css");
    await const LoaderCssCliCode().generateFile("loader.css");
    label("Create a flutter_bootstrap.js");
    await const BootstrapJsCliCode().generateFile("flutter_bootstrap.js");
    label("Edit as index.html");
    final indexHtmlFile = File("web/index.html");
    final htmlDocument = parse(await indexHtmlFile.readAsString());
    final body = htmlDocument.body;
    final head = htmlDocument.head;
    if (body != null) {
      if (!body.children.any((element) =>
          element.localName == "div" && element.classes.contains("loading"))) {
        body.children.insertFirst(
          Element.tag("div")
            ..classes.add("loading")
            ..children.add(
              Element.tag("div")
                ..children.addAll(
                  [
                    Element.tag("img")
                      ..attributes["src"] = "icons/Icon-192.png"
                      ..classes.add("logo"),
                    Element.tag("div")..classes.add("loader-bar")
                  ],
                ),
            ),
        );
      }
    }
    if (head != null) {
      if (!head.children.any((element) =>
          element.localName == "link" &&
          element.attributes["rel"] == "stylesheet" &&
          element.attributes["href"] == "loader.css")) {
        head.children.add(Element.tag("link")
          ..attributes["rel"] = "stylesheet"
          ..attributes["href"] = "loader.css"
          ..attributes["type"] = "text/css"
          ..attributes["media"] = "all");
      }
      final icon = head.children.firstWhereOrNull((item) =>
          item.localName == "link" && item.attributes["rel"] == "icon");
      if (icon == null) {
        head.children.add(Element.tag("link")
          ..attributes["rel"] = "icon"
          ..attributes["href"] = "favicon.ico");
      } else if (icon.attributes["href"] != "favicon.ico") {
        icon.attributes["href"] = "favicon.ico";
        icon.attributes.remove("type");
      }
    }
    await indexHtmlFile.writeAsString(
      htmlDocument.outerHtml.replaceAll(
        "<script src=\"flutter_bootstrap.js\" async=\"\"></script>",
        "<script>{{flutter_bootstrap_js}}</script>",
      ),
    );

    label("Create a favicon.ico");
    final iconFile = File("web/icons/Icon-512.png");
    final iconImage = decodeImage(iconFile.readAsBytesSync())!;
    final icoPngFile = File("web/favicon.png");
    if (icoPngFile.existsSync()) {
      await icoPngFile.delete();
    }
    final icoFile = File("web/favicon.ico");
    if (icoFile.existsSync()) {
      await icoFile.delete();
    }
    final ico = IcoEncoder();
    await icoFile.writeAsBytes(
      ico.encodeImages(_faviconSize.map((e) {
        return copyResize(
          iconImage,
          height: e,
          width: e,
          interpolation: Interpolation.average,
        );
      }).toList()),
    );
    label("Create a feature.png");
    final featurePngFile = File("web/feature.png");
    if (!featurePngFile.existsSync()) {
      await featurePngFile.writeAsBytes(
        encodePng(
          copyResize(
            iconImage,
            height: 512,
            width: 512,
            interpolation: Interpolation.average,
          ),
        ),
      );
    }
    label("Create a assets directory");
    final assetsDirectory = Directory("assets");
    if (!assetsDirectory.existsSync()) {
      await assetsDirectory.create();
    }
    label("Edit AndroidManifest.xml.");
    await AndroidManifestPermissionType.internet.enablePermission();
    await AndroidManifestQueryType.openLinkHttps.enableQuery();
    await AndroidManifestQueryType.dialTel.enableQuery();
    await AndroidManifestQueryType.sendEmail.enableQuery();
    await AndroidManifestQueryType.sendAny.enableQuery();
    label("Edit env.properties");
    await DartDefinesEnvPropertiesCliCode(
      packageName: "$domain.$projectName",
    ).generateFile("env.properties");
    label("Add processing to the Gradle file.");
    final gradle = AppGradle();
    await gradle.load();
    if (gradle.isKotlin &&
        !gradle.imports.any((e) => e.import == "java.util.Properties")) {
      gradle.imports.add(
        GradleImport(
          import: "java.util.Properties",
        ),
      );
    }
    if (!gradle.loadProperties.any((e) => e.name == "envProperties")) {
      gradle.loadProperties.add(
        GradleLoadProperties(
          path: "env.properties",
          name: "envProperties",
          file: "envPropertiesFile",
          isKotlin: gradle.isKotlin,
        ),
      );
    }
    await gradle.save();
    label("Edit AppDelegate.swift on IOS");
    final appDelegateIos = File("ios/Runner/AppDelegate.swift");
    if (appDelegateIos.existsSync()) {
      final document = await appDelegateIos.readAsString();
      final newDocument = """
#if canImport(UIKit) && canImport(Flutter)
$document
#endif
""";
      await appDelegateIos.writeAsString(newDocument);
    }
    label("Edit Debug.xcconfig");
    final xcconfigDebugFile = File("ios/Flutter/Debug.xcconfig");
    if (!xcconfigDebugFile.existsSync()) {
      error(
        "Cannot find `ios/Flutter/Debug.xcconfig`. Project is broken.",
      );
      return;
    }
    final xcconfigDebug = await xcconfigDebugFile.readAsLines();
    if (!xcconfigDebug
        .any((e) => e.startsWith("#include \"DartDefine.xcconfig\""))) {
      xcconfigDebug.add("#include \"DartDefine.xcconfig\"");
    }
    await xcconfigDebugFile.writeAsString(xcconfigDebug.join("\n"));
    label("Edit Release.xcconfig");
    final xcconfigReleaseFile = File("ios/Flutter/Release.xcconfig");
    if (!xcconfigDebugFile.existsSync()) {
      error(
        "Cannot find `ios/Flutter/Release.xcconfig`. Project is broken.",
      );
      return;
    }
    final xcconfigRelease = await xcconfigReleaseFile.readAsLines();
    if (!xcconfigRelease
        .any((e) => e.startsWith("#include \"DartDefine.xcconfig\""))) {
      xcconfigRelease.add("#include \"DartDefine.xcconfig\"");
    }
    await xcconfigReleaseFile.writeAsString(xcconfigRelease.join("\n"));
    label("Edit DartDefine.xcconfig");
    await DartDefinesXcconfigCliCode(
      packageName: "$domain.$projectName",
    ).generateFile("DartDefine.xcconfig");
    label("Edit RunnerTest.swift on IOS");
    final runnerTestsIos = File("ios/RunnerTests/RunnerTests.swift");
    if (runnerTestsIos.existsSync()) {
      final document = await runnerTestsIos.readAsString();
      final newDocument = """
#if canImport(UIKit) && canImport(Flutter) && canImport(XCTest)
$document
#endif
""";
      await runnerTestsIos.writeAsString(newDocument);
    }
    label("Edit AppDelegate.swift on MacOS");
    final appDelegateMacOS = File("macos/Runner/AppDelegate.swift");
    if (appDelegateMacOS.existsSync()) {
      final document = await appDelegateMacOS.readAsString();
      final newDocument = """
#if canImport(Cocoa) && canImport(FlutterMacOS)
$document
#endif
""";
      await appDelegateMacOS.writeAsString(newDocument);
    }
    label("Edit MainFlutterWindow.swift on MacOS");
    final mainFlutterWindowMacOS = File("macos/Runner/MainFlutterWindow.swift");
    if (mainFlutterWindowMacOS.existsSync()) {
      final document = await mainFlutterWindowMacOS.readAsString();
      final newDocument = """
#if canImport(Cocoa) && canImport(FlutterMacOS)
$document
#endif
""";
      await mainFlutterWindowMacOS.writeAsString(newDocument);
    }
    label("Edit RunnerTest.swift on MacOS");
    final runnerTestsMacOS = File("macos/RunnerTests/RunnerTests.swift");
    if (runnerTestsMacOS.existsSync()) {
      final document = await runnerTestsMacOS.readAsString();
      final newDocument = """
#if canImport(Cocoa) && canImport(FlutterMacOS) && canImport(XCTest)
$document
#endif
""";
      await runnerTestsMacOS.writeAsString(newDocument);
    }
    label("Edit DebugProfile.entitlements.");
    final debugEntitlements = File("macos/Runner/DebugProfile.entitlements");
    if (debugEntitlements.existsSync()) {
      final document =
          XmlDocument.parse(await debugEntitlements.readAsString());
      final dict = document.findAllElements("dict").firstOrNull;
      if (dict == null) {
        throw Exception(
          "Could not find `dict` element in `macos/Runner/DebugProfile.entitlements`. File is corrupt.",
        );
      }
      final node = dict.children.firstWhereOrNull((p0) {
        return p0 is XmlElement &&
            p0.name.toString() == "key" &&
            p0.innerText == "com.apple.security.network.client";
      });
      if (node == null) {
        dict.children.addAll(
          [
            XmlElement(
              XmlName("key"),
              [],
              [XmlText("com.apple.security.network.client")],
            ),
            XmlElement(
              XmlName("true"),
              [],
              [],
            ),
          ],
        );
      }
      await debugEntitlements.writeAsString(
        document.toXmlString(pretty: true, indent: "\t", newLine: "\n"),
      );
    }
    label("Replace pubspec.yaml");
    final pubspecFile = File("pubspec.yaml");
    final pubspec = await pubspecFile.readAsString();
    await pubspecFile.writeAsString(
      pubspec.replaceAll(
        RegExp(
          r"# assets:[\s\S]+#   - images/a_dot_burr.jpeg[\s\S]+#   - images/a_dot_ham.jpeg",
        ),
        "assets:\n    - assets/\n",
      ),
    );
    label("Create a .gitattributes");
    await const GitAttributesCliCode().generateFile(".gitattributes");
    label("Rewrite `.gitignore`.");
    final gitignore = File(".gitignore");
    if (!gitignore.existsSync()) {
      error("Cannot find `.gitignore`. Project is broken.");
      return;
    }
    final gitignores = await gitignore.readAsLines();
    if (!gitignores.any((e) => e.startsWith("secrets.dart"))) {
      gitignores.add("secrets.dart");
    }
    if (!gitignores.any((e) => e.startsWith("pubspec_overrides.yaml"))) {
      gitignores.add("pubspec_overrides.yaml");
    }
    if (!gitignores.any((e) => e.startsWith("/android/app/.cxx/"))) {
      gitignores.add("/android/app/.cxx/");
    }
    if (!gitignores.any((e) => e.startsWith("/android/env.properties"))) {
      gitignores.add("/android/env.properties");
    }
    if (!gitignores
        .any((e) => e.startsWith("/ios/Flutter/DartDefine.xcconfig"))) {
      gitignores.add("/ios/Flutter/DartDefine.xcconfig");
    }
    if (context.yaml.getAsMap("git").get("ignore_secure_file", true)) {
      if (!gitignores.any((e) => e.startsWith("katana_secrets.yaml"))) {
        gitignores.add("katana_secrets.yaml");
      }
    } else {
      gitignores.removeWhere((e) => e.startsWith("katana_secrets.yaml"));
    }
    if (!gitignores.any((e) => e.startsWith("documents/test/macos/**/*.*"))) {
      gitignores.add("documents/test/macos/**/*.*");
    }
    if (!gitignores.any((e) => e.startsWith("documentsdebug/**/*.*"))) {
      gitignores.add("documents/debug/**/*.*");
    }
    if (!gitignores.any((e) => e.startsWith("test/**/failures/**/*.*"))) {
      gitignores.add("test/**/failures/**/*.*");
    }
    if (!gitignores.any((e) => e.startsWith(".mcp.json"))) {
      gitignores.add(".mcp.json");
    }
    await gitignore.writeAsString(gitignores.join("\n"));
    await Future.delayed(const Duration(seconds: 5));
    await command(
      "Run the project's build_runner to generate code.",
      [
        flutter,
        "packages",
        "pub",
        "run",
        "build_runner",
        "build",
        "--delete-conflicting-outputs",
      ],
    );
    if (Platform.isMacOS) {
      await command(
        "Run `pod install`.",
        [
          "pod",
          "install",
        ],
        workingDirectory: "ios",
      );
    }
    label("Create PrivacyInfo.xcprivacy.");
    await XCode.createPrivacyManifests();
    await command(
      "Run dart format",
      [
        dart,
        "format",
        ".",
      ],
    );
    await command(
      "Run import sorter",
      [
        flutter,
        "pub",
        "run",
        "import_sorter:main",
        ".",
      ],
    );
  }
}

/// Create a new Flutter package.
///
/// 新しいFlutterパッケージを作成します。
class PackageCliCommand extends CliCommand {
  /// Create a new Flutter package.
  ///
  /// 新しいFlutterパッケージを作成します。
  const PackageCliCommand();

  @override
  String get description =>
      "Create a new Flutter package. 新しいFlutterパッケージを作成します。";

  @override
  String? get example => "katana package [package_name]";

  @override
  Future<void> exec(ExecContext context) async {
    final bin = context.yaml.getAsMap("bin");
    final flutter = bin.get("flutter", "flutter");
    final packageName = context.args.get(1, "");
    if (packageName.isEmpty) {
      error(
        "Please provide the name of the package.\r\nパッケージ名を記載してください。\r\n\r\nkatana package [package name]",
      );
      return;
    }
    final projectName = packageName.split(".").lastOrNull;
    final domain = packageName
        .split(".")
        .sublist(0, packageName.split(".").length - 1)
        .join(".");
    if (projectName.isEmpty || domain.isEmpty) {
      error(
        "The format of the package name should be specified in the following format.\r\nパッケージ名の形式は下記の形式で指定してください。\r\n\r\n[Domain].[ProjectName]\r\ne.g. net.mathru.website",
      );
      return;
    }
    await command(
      "Create a Flutter project.",
      [
        flutter,
        "create",
        "--org",
        domain,
        "--template=package",
        projectName!,
      ],
    );
    await _moveDirectoryContents(projectName, ".");
    Directory(projectName).deleteSync(recursive: true);
    File("test/${projectName.toSnakeCase()}_test.dart").deleteSync();
    await command(
      "Import packages.",
      [
        flutter,
        "pub",
        "add",
        ...importPackages,
      ],
    );
    await command(
      "Import dev packages.",
      [
        flutter,
        "pub",
        "add",
        "--dev",
        ...importDevPackages,
        "import_sorter",
      ],
    );
    label("Generate file for VSCode");
    for (final file in otherFiles.entries) {
      await file.value.generateFile(file.key);
    }
    await const CodeSnippetsCliGroup().generateFiles();
    label("Replace package main file.");
    await PackageMainCliCode(packageName: projectName)
        .generateFile("${projectName.toSnakeCase()}.dart");
    label("Replace package README.md file.");
    await PackageReadMeCliCode(packageName: projectName)
        .generateFile("README.md");
    label("Replace LICENSE");
    await const LicenseCliCode().generateFile("LICENSE");
    label("Create a pubspec_overrides.yaml");
    await const PubspecOverridesCliCode()
        .generateFile("pubspec_overrides.yaml");
    // label("Create a build.yaml");
    // await const BuildCliCode().generateFile("build.yaml");
    label("Edit a analysis_options.yaml");
    await const AnalysisOptionsCliCode().generateFile("analysis_options.yaml");
    label("Rewrite `.gitignore`.");
    final gitignore = File(".gitignore");
    if (!gitignore.existsSync()) {
      error("Cannot find `.gitignore`. Project is broken.");
      return;
    }
    final gitignores = await gitignore.readAsLines();
    if (!gitignores.any((e) => e.startsWith("pubspec_overrides.yaml"))) {
      gitignores.add("pubspec_overrides.yaml");
    }
    if (!gitignores.any((e) => e.startsWith("/android/app/.cxx/"))) {
      gitignores.add("/android/app/.cxx/");
    }
    await gitignore.writeAsString(gitignores.join("\n"));
    label("Rewrite `pubspec.yaml`.");
    final pubspec = File("pubspec.yaml");
    if (!pubspec.existsSync()) {
      error("Cannot find `pubspec.yaml`. Project is broken.");
      return;
    }
    final pubspecsRes = <String>[];
    final pubspecs = await pubspec.readAsLines();
    for (final tmp in pubspecs) {
      if (tmp.startsWith("homepage:")) {
        pubspecsRes.add("# homepage:");
      } else if (tmp.startsWith("flutter:")) {
        pubspecsRes.add("# flutter:");
      } else {
        pubspecsRes.add(tmp);
      }
    }
    await pubspec.writeAsString(pubspecsRes.join("\n"));
    await Future.delayed(const Duration(seconds: 5));
    await command(
      "Run the project's build_runner to generate code.",
      [
        flutter,
        "packages",
        "pub",
        "run",
        "build_runner",
        "build",
        "--delete-conflicting-outputs",
      ],
    );
    await command(
      "Run import sorter",
      [
        flutter,
        "pub",
        "run",
        "import_sorter:main",
        ".",
      ],
    );
  }

  /// ディレクトリの内容を再帰的に移動する関数
  Future<void> _moveDirectoryContents(
    String sourceDir,
    String targetDir,
  ) async {
    final dir = Directory(sourceDir);
    final entities = await dir.list(recursive: false).toList();

    for (final entity in entities) {
      final name = entity.path.split(Platform.pathSeparator).last;
      final newPath = "$targetDir${Platform.pathSeparator}$name";

      if (entity is File) {
        await entity.rename(newPath);
      } else if (entity is Directory) {
        await Directory(newPath).create(recursive: true);
        await _moveDirectoryContents(entity.path, newPath);
      }
    }
  }
}

/// Contents of katana.yaml.
///
/// katana.yamlの中身。
class KatanaCliCode extends CliCode {
  /// Contents of katana.yaml.
  ///
  /// katana.yamlの中身。
  const KatanaCliCode(this.showAllConfig);

  /// `true` to show all settings.
  ///
  /// すべての設定を表示する場合は`true`。
  final bool showAllConfig;

  @override
  String get name => "katana";

  @override
  String get prefix => "katana";

  @override
  String get directory => "";

  @override
  String get description =>
      "Create katana.yaml for katana_cli. katana_cli用のkatana.yamlを作成します。";

  @override
  String import(String path, String baseName, String className) {
    return "";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return katanaYamlCode(showAllConfig);
  }
}

/// Contents of katana.yaml.
///
/// katana_secrets.yamlの中身。
class KatanaSecretsCliCode extends CliCode {
  /// Contents of katana.yaml.
  ///
  /// katana_secrets.yamlの中身。
  const KatanaSecretsCliCode();

  @override
  String get name => "katana_secrets";

  @override
  String get prefix => "katana_secrets";

  @override
  String get directory => "";

  @override
  String get description =>
      "Create katana_secrets.yaml for katana_cli. katana_cli用のkatana_secrets.yamlを作成します。";

  @override
  String import(String path, String baseName, String className) {
    return "";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return katanaSecretsYamlCode();
  }
}

/// Contents of main.dart.
///
/// main.dartの中身。
class MainCliCode extends CliCode {
  /// Contents of main.dart.
  ///
  /// main.dartの中身。
  const MainCliCode({this.module});

  /// Name of the module to be used.
  ///
  /// 利用するモジュール名。
  final String? module;

  @override
  String get name => "main";

  @override
  String get prefix => "main";

  @override
  String get directory => "lib";

  @override
  String get description =>
      "Create a main.dart for all Masamune Framework functions.\nMasamune Frameworkの機能すべてに対応したmain.dartを作成します。";

  @override
  String import(String path, String baseName, String className) {
    return """
import "package:masamune/masamune.dart";
import "config.dart";
import "router.dart";
import "theme.dart";
import "localize.dart";
import "adapter.dart";

export "config.dart";
export "router.dart";
export "theme.dart";
export "localize.dart";
export "adapter.dart";
${module == null ? "" : "export \"module.dart\";"}
""";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
/// App Ref.
///
/// ```dart
/// appRef.controller(Controller.query()); // Get a controller.
/// appRef.model(Model.query());           // Get a model.
/// ```
final appRef = AppRef();

/// App authentication.
///
/// ```dart
/// appAuth.signIn(
///   EmailAndPasswordSignInAuthProvider(
///     email: email,
///     password: password,
///   ),
/// );
/// ```
final appAuth = Authentication();

/// App server functions.
/// 
/// It is used in conjunction with the server side.
///
/// ```dart
/// appFunction.notification(
///   title: "Notification",
///   text: "Notification text",
///   target: "Topic",
/// );
/// ```
final appFunction = Functions();

/// App logger.
/// 
/// Used to obtain and send logs.
/// 
/// ```
/// appLogger.send(
///   AnalyticsValue(
///     userId: "user id",
///   )
/// );
/// ```
final appLogger = Logger();

/// App Flavor.
// ignore: do_not_use_environment
const flavor = String.fromEnvironment("flavor");

/// App Platform.
const platform = PlatformInfo();

/// App.
void main() {
  runMasamuneApp(
    (ref) => MasamuneApp(
      title: title,
      appRef: appRef,
      theme: theme,
      routerConfig: router,
      localize: l,
      authAdapter: authAdapter,
      modelAdapter: modelAdapter,
      storageAdapter: storageAdapter,
      functionsAdapter: functionsAdapter,
      masamuneAdapters: ref.adapters,
      loggerAdapters: ref.loggerAdapters,
      navigatorObservers: ref.navigatorObservers,
    ),
    masamuneAdapters: masamuneAdapters,
    loggerAdapters: loggerAdapters,
  );
}
""";
  }
}

/// Contents of theme.dart.
///
/// theme.dartの中身。
class MainThemeCliCode extends CliCode {
  /// Contents of theme.dart.
  ///
  /// theme.dartの中身。
  const MainThemeCliCode();

  @override
  String get name => "theme";

  @override
  String get prefix => "theme";

  @override
  String get directory => "lib";

  @override
  String get description =>
      "Create a theme.dart for all Masamune Framework functions.\nMasamune Frameworkの機能すべてに対応したtheme.dartを作成します。";

  @override
  String import(String path, String baseName, String className) {
    return """
import "package:flutter/material.dart";
import "package:masamune/masamune.dart";
""";
  }

  @override
  String header(String path, String baseName, String className) {
    return """
part "$baseName.theme.dart";
""";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
/// App Theme.
///
/// ```dart
/// theme.color.primary   // Primary color.
/// theme.text.bodyMedium // Medium body text style.
/// theme.asset.xxx       // xxx image.
/// theme.font.xxx        // xxx font.
/// ```
@appTheme
final theme = AppThemeData(
  // TODO: Set the design.
  primary: Colors.blue,
  secondary: Colors.cyan,
  onPrimary: Colors.white,
  onSecondary: Colors.white,
  \${1}
);
""";
  }
}

/// Contents of router.dart.
///
/// router.dartの中身。
class MainRouterCliCode extends CliCode {
  /// Contents of router.dart.
  ///
  /// router.dartの中身。
  const MainRouterCliCode({
    this.module,
    this.initialQuery = "\${2:HomePage.query()}",
    this.initialQueryImport = "import \"pages/home.dart\";",
  });

  /// Name of the module to be used.
  ///
  /// 利用するモジュール名。
  final String? module;

  /// Initial query.
  ///
  /// 初期クエリ。
  final String initialQuery;

  /// Initial query import.
  ///
  /// 初期クエリのインポート。
  final String initialQueryImport;

  @override
  String get name => "router";

  @override
  String get prefix => "router";

  @override
  String get directory => "lib";

  @override
  String get description =>
      "Create a router.dart for all Masamune Framework functions.\nMasamune Frameworkの機能すべてに対応したrouter.dartを作成します。";

  @override
  String import(String path, String baseName, String className) {
    return """
import "package:masamune/masamune.dart";
$initialQueryImport

""";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
/// App Router.
///
/// ```dart
/// router.push(Page.query());  // Push page to Page.
/// router.pop();               // Pop page.
/// ```
final router = AppRouter(
  // TODO: Please configure the initial routing and redirection settings.
  boot: \${1:null},
  initialQuery: $initialQuery,
  redirect: [],
  pages: [
    // TODO: Add the page query to be used for routing.
    \${3}
  ],
);
""";
  }
}

/// Contents of main.dart.
///
/// localize.dartの中身。
class MainLocalizeCliCode extends CliCode {
  /// Contents of main.dart.
  ///
  /// localize.dartの中身。
  const MainLocalizeCliCode();

  @override
  String get name => "localize";

  @override
  String get prefix => "localize";

  @override
  String get directory => "lib";

  @override
  String get description =>
      "Create a localize.dart for all Masamune Framework functions.\nMasamune Frameworkの機能すべてに対応したlocalize.dartを作成します。";

  @override
  String import(String path, String baseName, String className) {
    return """
import "package:flutter/material.dart";
import "package:masamune/masamune.dart";
""";
  }

  @override
  String header(String path, String baseName, String className) {
    return """
part "$baseName.localize.dart";
""";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
/// App Localization.
///
/// ```dart
/// l().xxx  // Localization for xxx.
/// ```
final l = AppLocalize();

/// App Localization.
///
/// You can add multilingual support by editing `localize.yaml`.
/// 
/// [version] is the version of the Yaml file.
@YamlLocalize(version: 1)
class AppLocalize extends _\$AppLocalize {}
""";
  }
}

/// Contents of localize.base.yaml.
///
/// localize.base.yamlの中身。
class LocalizeYamlCliCode extends CliCode {
  /// Contents of localize.base.yaml.
  ///
  /// localize.base.yamlの中身。
  const LocalizeYamlCliCode();

  @override
  String get name => "localize.base";

  @override
  String get prefix => "localize.base";

  @override
  String get directory => "";

  @override
  String get description =>
      "Create localize.base.yaml for katana_cli. katana_cli用のlocalize.base.yamlを作成します。";

  @override
  String import(String path, String baseName, String className) {
    return "";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return localizeYamlCode();
  }
}

/// Contents of localize.app.yaml.
///
/// localize.app.yamlの中身。
class AppLocalizeYamlCliCode extends CliCode {
  /// Contents of localize.app.yaml.
  ///
  /// localize.app.yamlの中身。
  const AppLocalizeYamlCliCode();

  @override
  String get name => "localize.app";

  @override
  String get prefix => "localize.app";

  @override
  String get directory => "";

  @override
  String get description =>
      "Create localize.app.yaml for katana_cli. katana_cli用のlocalize.app.yamlを作成します。";

  @override
  String import(String path, String baseName, String className) {
    return "";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return appLocalizeYamlCode();
  }
}

/// Contents of adapter.dart.
///
/// adapter.dartの中身。
class MainAdapterCliCode extends CliCode {
  /// Contents of adapter.dart.
  ///
  /// adapter.dartの中身。
  const MainAdapterCliCode({this.module});

  /// Name of the module to be used.
  ///
  /// 利用するモジュール名。
  final String? module;

  @override
  String get name => "adapter";

  @override
  String get prefix => "adapter";

  @override
  String get directory => "lib";

  @override
  String get description =>
      "Create a adapter.dart for all Masamune Framework functions.\nMasamune Frameworkの機能すべてに対応したadapter.dartを作成します。";

  @override
  String import(String path, String baseName, String className) {
    return """
import "package:masamune/masamune.dart";
import "package:masamune_universal_ui/masamune_universal_ui.dart";
${module == null ? "" : "import \"module.dart\";"}
""";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
/// App Model.
///
/// By replacing this with another adapter, the data storage location can be changed.
// TODO: Change the database.
final modelAdapter = runtimeModelAdapter;

/// App Auth.
/// 
/// Changing to another adapter allows you to change to another authentication mechanism.
// TODO: Change the authentication.
final authAdapter = runtimeAuthAdapter;

/// App Storage.
/// 
/// Changing to another adapter allows you to change to another storage mechanism.
// TODO: Change the storage.
final storageAdapter = runtimeStorageAdapter;

/// App Functions.
/// 
/// Changing to another adapter allows you to change to another functions mechanism.
// TODO: Change the functions.
final functionsAdapter = runtimeFunctionsAdapter;

/// Logger adapter list.
/// 
/// Adapters for logging can be defined here.
// TODO: Change the loggers.
final loggerAdapters = runtimeLoggerAdapters;

/// Masamune adapter list.
/// 
/// The Masamune framework plugin functions can be defined together.
// TODO: Add the adapters.
final masamuneAdapters = runtimeMasamuneAdapters;

/// Test user id.
/// 
/// Please set up mock data using this.
const testUserUid = "${uuid()}";

/// Current time.
/// 
/// Set the current time for testing.
/// 
/// Please set up mock data using this.
final testCurrentTime = Clock(${Clock.now().year}, 1, 1, 12, 0, 0);

/// App Model.
/// 
/// Testing model adapter.
final runtimeModelAdapter = RuntimeModelAdapter();

/// App Auth.
/// 
/// Test Auth adapter.
final runtimeAuthAdapter = RuntimeAuthAdapter();

/// App Storage.
/// 
/// Testing storage adapter.
final runtimeStorageAdapter = LocalStorageAdapter();

/// App Functions.
/// 
/// Testing functions adapter.
final runtimeFunctionsAdapter = RuntimeFunctionsAdapter();

/// Logger adapter list.
/// 
/// Testing logger adapter list.
final runtimeLoggerAdapters = <LoggerAdapter>[
  const ConsoleLoggerAdapter(),
];

/// Masamune adapter list.
/// 
/// Testing masamune adapter list.
final runtimeMasamuneAdapters = <MasamuneAdapter>[
  const UniversalMasamuneAdapter(),
  ${module != null ? "appModule," : ""}
];
""";
  }
}

/// Contents of config.dart.
///
/// config.dartの中身。
class MainConfigCliCode extends CliCode {
  /// Contents of config.dart.
  ///
  /// config.dartの中身。
  const MainConfigCliCode();

  @override
  String get name => "config";

  @override
  String get prefix => "config";

  @override
  String get directory => "lib";

  @override
  String get description =>
      "Create a config.dart for all Masamune Framework functions.\nMasamune Frameworkの機能すべてに対応したconfig.dartを作成します。";

  @override
  String import(String path, String baseName, String className) {
    return "";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
/// App Title.
// TODO: Define the title of the application.
const title = "\${1}";
""";
  }
}

/// Contents of module.dart.
///
/// module.dartの中身。
class MainModuleCliCode extends CliCode {
  /// Contents of module.dart.
  ///
  /// module.dartの中身。
  const MainModuleCliCode({required this.module});

  /// Name of the module to be used.
  ///
  /// 利用するモジュール名。
  final String module;

  @override
  String get name => "module";

  @override
  String get prefix => "module";

  @override
  String get directory => "lib";

  @override
  String get description =>
      "Create a module.dart for all Masamune Framework functions.\nMasamune Frameworkの機能すべてに対応したmodule.dartを作成します。";

  @override
  String import(String path, String baseName, String className) {
    return """
import "package:flutter/material.dart";
import "package:masamune/masamune.dart";
import "package:masamune_universal_ui/masamune_universal_ui.dart";
import "package:${module.toSnakeCase()}/${module.toSnakeCase()}.dart";"
import "package:${module.toSnakeCase()}/pages/home.dart";"
""";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
/// [ModuleMasamuneAdapter] for applications.
// TODO: Please configure the module.
final appModule = ${module.toPascalCase()}MasamuneAdapter(
  title: const LocalizedValue([
    LocalizedLocaleValue(Locale("en"), title),
  ]),
  appRef: appRef,
  auth: appAuth,
  router: router,
  function: appFunction,
  localize: l,
  theme: theme,
  option: ${module.toPascalCase()}ModuleOptions(
  ),
);
""";
  }
}

/// Contents of katana.yaml.
///
/// analysis_options.yamlの中身。
class AnalysisOptionsCliCode extends CliCode {
  /// Contents of katana.yaml.
  ///
  /// analysis_options.yamlの中身。
  const AnalysisOptionsCliCode();

  @override
  String get name => "analysis_options";

  @override
  String get prefix => "analysis_options";

  @override
  String get directory => "";

  @override
  String get description =>
      "Define `analysis_options.yaml` with additional settings. `analysis_options.yaml`を追加設定込で定義します。";

  @override
  String import(String path, String baseName, String className) {
    return "";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return r"""
# This file configures the analyzer, which statically analyzes Dart code to
# check for errors, warnings, and lints.
#
# The issues identified by the analyzer are surfaced in the UI of Dart-enabled
# IDEs (https://dart.dev/tools#ides-and-editors). The analyzer can also be
# invoked from the command line by running `flutter analyze`.

# The following line activates a set of recommended lints for Flutter apps,
# packages, and plugins designed to encourage good coding practices.
include: package:flutter_lints/flutter.yaml

linter:
  # The lint rules applied to this project can be customized in the
  # section below to disable rules from the `package:flutter_lints/flutter.yaml`
  # included above or to enable additional rules. A list of all available lints
  # and their documentation is published at
  # https://dart-lang.github.io/linter/lints/index.html.
  #
  # Instead of disabling a lint rule for the entire project in the
  # section below, it can also be suppressed for a single line of code
  # or a specific dart file by using the `// ignore: name_of_lint` and
  # `// ignore_for_file: name_of_lint` syntax on the line or in the file
  # producing the lint.
  rules:
    prefer_double_quotes: true
    prefer_asserts_with_message: true
    cancel_subscriptions: true
    prefer_const_constructors: true
    always_put_control_body_on_new_line: true
    prefer_if_elements_to_conditional_expressions: true
    always_put_required_named_parameters_first: true
    avoid_equals_and_hash_code_on_mutable_classes: true
    use_if_null_to_convert_nulls_to_bools: true
    missing_whitespace_between_adjacent_strings: true
    leading_newlines_in_multiline_strings: true
    deprecated_member_use_from_same_package: true
    close_sinks: true
    avoid_print: true
    no_duplicate_case_values: true
    do_not_use_environment: true
    library_names: true
    matching_super_parameters: true
    no_literal_bool_comparisons: true
    omit_obvious_local_variable_types: true
    type_annotate_public_apis: true
    package_prefixed_library_names: true
    prefer_mixin: true
    prefer_void_to_null: true
    unnecessary_lambdas: true
    unnecessary_async: true
    use_decorated_box: true
    use_colored_box: true
    sized_box_shrink_expand: true
    unnecessary_null_aware_operator_on_extension_on_nullable: true
    prefer_is_not_operator: true
    prefer_iterable_whereType: true
    exhaustive_cases: true
    prefer_asserts_in_initializer_lists: true
    prefer_conditional_assignment: true
    prefer_const_constructors_in_immutables: true
    prefer_const_declarations: true
    prefer_const_literals_to_create_immutables: true
    prefer_constructors_over_static_methods: true
    prefer_contains: true
    public_member_api_docs: true
    no_default_cases: false
    library_private_types_in_public_api: false
    use_build_context_synchronously: false

# Additional information about this file can be found at
# https://dart.dev/guides/language/analysis-options

# Set to exclude json_serializable files.
# json_serializableのファイルを除外するための設定。
analyzer:
  plugins:
    - custom_lint
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
    - "**/*.theme.dart"
    - "**/*.localize.dart"
    - "**/*.listenable.dart"
    - "**/*.page.dart"
    - "**/*.router.dart"
    - "**/*.prefs.dart"
    - "**/*.m.dart"
    - "**/*.model.dart"
    - "lib/dataconnect/**"
    - "lib/firebase_options.dart"
  errors:
    prefer_double_quotes: error
    always_put_control_body_on_new_line: error
    prefer_asserts_with_message: error
    leading_newlines_in_multiline_strings: error
    use_if_null_to_convert_nulls_to_bools: error
    missing_whitespace_between_adjacent_strings: error
    prefer_if_elements_to_conditional_expressions: error
    do_not_use_environment: error
    avoid_print: error
    library_names: error
    prefer_mixin: error
    prefer_void_to_null: error
    exhaustive_cases: error
    prefer_asserts_in_initializer_lists: error
    deprecated_member_use_from_same_package: warning
    close_sinks: warning
    no_duplicate_case_values: warning
    matching_super_parameters: warning
    no_literal_bool_comparisons: warning
    omit_obvious_local_variable_types: warning
    type_annotate_public_apis: warning
    package_prefixed_library_names: warning
    unnecessary_lambdas: warning
    unnecessary_async: warning
    use_decorated_box: warning
    use_colored_box: warning
    sized_box_shrink_expand: warning
    unnecessary_null_aware_operator_on_extension_on_nullable: warning
    prefer_is_not_operator: warning
    prefer_iterable_whereType: warning
    prefer_conditional_assignment: warning
    prefer_const_constructors_in_immutables: warning
    prefer_const_declarations: warning
    prefer_const_literals_to_create_immutables: warning
    prefer_constructors_over_static_methods: warning
    prefer_contains: warning
    prefer_const_constructors: warning
    public_member_api_docs: warning
    cancel_subscriptions: warning
    always_put_required_named_parameters_first: warning
    avoid_equals_and_hash_code_on_mutable_classes: warning
""";
  }
}

/// Contents of .gitattributes.
///
/// .gitattributesの中身。
class GitAttributesCliCode extends CliCode {
  /// Contents of .gitattributes.
  ///
  /// .gitattributesの中身。
  const GitAttributesCliCode();

  @override
  String get name => ".gitattributes";

  @override
  String get prefix => ".gitattributes";

  @override
  String get directory => "";

  @override
  String get description =>
      "Define `.gitattributes` with additional settings. `.gitattributes`を追加設定込で定義します。";

  @override
  String import(String path, String baseName, String className) {
    return "";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return r"""
*.jpg binary
*.jpeg binary
*.png binary
*.gif binary
*.svg binary
*.webp binary
*.zip binary
*.mp3 binary
*.mp4 binary
*.wav binary
*.ogg binary
*.flac binary
*.m4a binary
*.m4v binary
*.mov binary
*.webm binary
*.pdf binary
*.doc binary
*.docx binary
*.xls binary
*.xlsx binary
*.ppt binary
*.pptx binary
""";
  }
}

/// Contents of launch.json.
///
/// launch.jsonの中身。
class LaunchCliCode extends CliCode {
  /// Contents of launch.json.
  ///
  /// launch.jsonの中身。
  const LaunchCliCode();

  @override
  String get name => "launch";

  @override
  String get prefix => "launch";

  @override
  String get directory => ".vscode";

  @override
  String get description =>
      "Create launch.json for VSCode. VSCode用のlaunch.jsonを作成します。";

  @override
  String import(String path, String baseName, String className) {
    return "";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return r"""
{
  // Use IntelliSense to learn about possible attributes.
  // Hover to view descriptions of existing attributes.
  // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Development",
      "request": "launch",
      "type": "dart",
      "args": ["--dart-define-from-file=dart_defines/dev.env", "--web-port=5555"]
    },
    {
      "name": "Staging",
      "request": "launch",
      "type": "dart",
      "args": ["--dart-define-from-file=dart_defines/stg.env", "--web-port=5555"]
    },
    {
      "name": "Production",
      "request": "launch",
      "type": "dart",
      "args": ["--dart-define-from-file=dart_defines/prod.env", "--web-port=5555", "--release"]
    }
  ]
}
""";
  }
}

/// Contents of settings.json.
///
/// settings.jsonの中身。
class SettingsCliCode extends CliCode {
  /// Contents of settings.json.
  ///
  /// settings.jsonの中身。
  const SettingsCliCode();

  @override
  String get name => "settings";

  @override
  String get prefix => "settings";

  @override
  String get directory => ".vscode";

  @override
  String get description =>
      "Create settings.json for VSCode. VSCode用のsettings.jsonを作成します。";

  @override
  String import(String path, String baseName, String className) {
    return "";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return r"""
{
    "explorer.fileNesting.enabled": true,
    "explorer.fileNesting.patterns": {        
        "*.dart": "$(capture).m.dart,$(capture).model.dart,$(capture).page.dart,$(capture).localize.dart,$(capture).theme.dart,$(capture).g.dart,$(capture).freezed.dart,$(capture).extensions.dart,$(capture).api.dart",
        "*.yaml": "$(capture).base.yaml,$(capture).app.yaml"
    }
}
""";
  }
}

/// Contents of tasks.json.
///
/// tasks.jsonの中身。
class TasksCliCode extends CliCode {
  /// Contents of tasks.json.
  ///
  /// tasks.jsonの中身。
  const TasksCliCode();

  @override
  String get name => "tasks";

  @override
  String get prefix => "tasks";

  @override
  String get directory => ".vscode";

  @override
  String get description =>
      "Create tasks.json for VSCode. VSCode用のtasks.jsonを作成します。";

  @override
  String import(String path, String baseName, String className) {
    return "";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return r"""
{
    // See https://go.microsoft.com/fwlink/?LinkId=733558
    // for the documentation about the tasks.json format
    "version": "2.0.0",
    "tasks": [
        {
            "label": "flavor_dev",
            "type": "shell",
            "command": "katana flavor dev",
        },
        {
            "label": "flavor_stg",
            "type": "shell",
            "command": "katana flavor stg",
        },
        {
            "label": "flavor_prod",
            "type": "shell",
            "command": "katana flavor prod",
        }
    ]
}
""";
  }
}

/// Contents of flutter_test_config.dart.
///
/// flutter_test_config.dartの中身。
class FlutterTestConfigCliCode extends CliCode {
  /// Contents of flutter_test_config.dart.
  ///
  /// flutter_test_config.dartの中身。
  const FlutterTestConfigCliCode();

  @override
  String get name => "flutter_test_config";

  @override
  String get prefix => "flutter_test_config";

  @override
  String get directory => "test";

  @override
  String get description =>
      "Create `flutter_test_config.dart` for initial test setup. テストの初期設定を行う`flutter_test_config.dart`を作成します。";

  @override
  String import(String path, String baseName, String className) {
    return "";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    final packageName = retrievePackageName();
    return """
import "dart:async";
import "package:masamune_test/masamune_test.dart";

// ignore: avoid_relative_lib_imports
import "package:$packageName/main.dart";

/// Performing test initialization.
Future<void> testExecutable(FutureOr<void> Function() testMain) {
  return MasamuneTestConfig.initialize(
    run: testMain,
    initialUserId: "${uuid()}",
    theme: theme,
    modelAdapter: runtimeModelAdapter,
    authAdapter: runtimeAuthAdapter,
    storageAdapter: runtimeStorageAdapter,
    functionsAdapter: runtimeFunctionsAdapter,
    loggerAdapters: runtimeLoggerAdapters,
    masamuneAdapters: runtimeMasamuneAdapters,
  );
}
""";
  }
}

/// Contents of widget_test.dart.
///
/// widget_test.dartの中身。
class WidgetTestCliCode extends CliCode {
  /// Contents of widget_test.dart.
  ///
  /// widget_test.dartの中身。
  const WidgetTestCliCode();

  @override
  String get name => "widget_test";

  @override
  String get prefix => "widget_test";

  @override
  String get directory => "test";

  @override
  String get description =>
      "Create an error-free widget_test.dart. エラーのでないwidget_test.dartを作成します。";

  @override
  String import(String path, String baseName, String className) {
    return "";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return r"""
// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import "package:flutter_test/flutter_test.dart";

void main() {
  test("Test", () {});
}
""";
  }
}

/// Contents of pubspec_overrides.yaml.
///
/// pubspec_overrides.yamlの中身。
class PubspecOverridesCliCode extends CliCode {
  /// Contents of pubspec_overrides.yaml.
  ///
  /// pubspec_overrides.yamlの中身。
  const PubspecOverridesCliCode();

  @override
  String get name => "pubspec_overrides";

  @override
  String get prefix => "pubspec_overrides";

  @override
  String get directory => "";

  @override
  String get description =>
      "Create pubspec_overrides.yaml for katana_cli. katana_cli用のpubspec_overrides.yamlを作成します。";

  @override
  String import(String path, String baseName, String className) {
    return "";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return r"""
dependency_overrides:
""";
  }
}

/// Contents of build.yaml.
///
/// build.yamlの中身。
class BuildCliCode extends CliCode {
  /// Contents of build.yaml.
  ///
  /// build.yamlの中身。
  const BuildCliCode();

  @override
  String get name => "build";

  @override
  String get prefix => "build";

  @override
  String get directory => "";

  @override
  String get description =>
      "Create build.yaml for katana_cli. build.yamlを作成します。";

  @override
  String import(String path, String baseName, String className) {
    return "";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return r"""
targets:
  $default:
    builders:
      katana_theme_builder:
        enabled: true
        generate_for:
          include:
            - lib/*.dart
            - lib/**/*.dart
            - test/*.dart
            - test/**/*.dart
            - example/lib/*.dart
            - example/lib/**/*.dart
            - example/test/*.dart
            - example/test/**/*.dart
      masamune_builder:
        enabled: true
        generate_for:
          include:
            - lib/*.dart
            - lib/**/*.dart
            - test/*.dart
            - test/**/*.dart
            - example/lib/*.dart
            - example/lib/**/*.dart
            - example/test/*.dart
            - example/test/**/*.dart
      katana_router_page_builder:
        enabled: true
        generate_for:
          include:
            - lib/*.dart
            - lib/**/*.dart
            - test/*.dart
            - test/**/*.dart
            - example/lib/*.dart
            - example/lib/**/*.dart
            - example/test/*.dart
            - example/test/**/*.dart
      katana_router_router_builder:
        enabled: true
        generate_for:
          include:
            - lib/*.dart
            - lib/**/*.dart
            - test/*.dart
            - test/**/*.dart
            - example/lib/*.dart
            - example/lib/**/*.dart
            - example/test/*.dart
            - example/test/**/*.dart
      katana_localization_builder:
        enabled: true
        generate_for:
          include:
            - localize.*.yaml
            - lib/*.dart
            - lib/**/*.dart
            - test/*.dart
            - test/**/*.dart
            - example/lib/*.dart
            - example/lib/**/*.dart
            - example/test/*.dart
            - example/test/**/*.dart
      json_serializable:
        enabled: true
        generate_for:
          include:
            - lib/*.dart
            - lib/**/*.dart
            - test/*.dart
            - test/**/*.dart
            - example/lib/*.dart
            - example/lib/**/*.dart
            - example/test/*.dart
            - example/test/**/*.dart
      freezed:
        enabled: true
        generate_for:
          include:
            - lib/*.dart
            - lib/**/*.dart
            - test/*.dart
            - test/**/*.dart
            - example/lib/*.dart
            - example/lib/**/*.dart
            - example/test/*.dart
            - example/test/**/*.dart
""";
  }
}

/// Contents of loader.css.
///
/// loader.cssの中身。
class LoaderCssCliCode extends CliCode {
  /// Contents of loader.css.
  ///
  /// loader.cssの中身。
  const LoaderCssCliCode();

  @override
  String get name => "loader";

  @override
  String get prefix => "loader";

  @override
  String get directory => "web";

  @override
  String get description =>
      "Create loader.css for katana_cli. katana_cli用のloader.cssを作成します。";

  @override
  String import(String path, String baseName, String className) {
    return "";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
@media (prefers-color-scheme: light) {
  html {
    --text-color: #666666;
    --bar-background-color: rgba(33, 33, 33, 0.1);
    --background-color: #f7f7f7;
  }
}

@media (prefers-color-scheme: dark) {
  html {
    --text-color: #aaaaaa;
    --bar-background-color: rgba(247, 247, 247, 0.1);
    --background-color: #212121;
  }
}

body {
    background-color: var(--background-color);
}
.loading {
    display: flex;
    justify-content: center;
    text-align: center;
    align-items: center;
    margin: 0;
    position: absolute;
    top: 50%;
    left: 50%;
    -ms-transform: translate(-50%, -50%);
    transform: translate(-50%, -50%);
}
.loader {
    border: 0.3rem solid var(--background-color);
    border-radius: 50%;
    border-top: 0.3rem solid var(--text-color);
    border-right: 0.3rem solid var(--text-color);
    border-bottom: 0.3rem solid var(--text-color);
    width: 6rem;
    height: 6rem;
    -webkit-animation: spin 1s linear infinite;
    animation: spin 1s linear infinite;
}
.loader-bar {
    width: 8rem;
    background-color: var(--bar-background-color);
    height: 0.3rem;
    border-radius: 0.06rem;
    position: relative;
    overflow: hidden;
    margin-left: auto;
    margin-right: auto;
}
.loader-bar:after {
    position: absolute;
    content: '';
    left:-25%;
    width: 50%;
    height: 0.3rem;
    background-color: var(--text-color);
    border-radius: 0.06rem;
    animation: bar linear 1s infinite;
}
.logo {
    width: 6rem;
    height: 6rem;
    margin-bottom: 0.8rem;
    border-radius: 0.8rem;
}
.fade{
    animation: fadeIn 0.2s ease 0.3s 1 normal;
}
@keyframes fadeIn {
    0% {opacity: 0}
    100% {opacity: 1}
}
@-webkit-keyframes spin {
    0% {
    -webkit-transform: rotate(0deg);
    }
    100% {
    -webkit-transform: rotate(360deg);
    }
}
@keyframes spin {
    0% {
    transform: rotate(0deg);
    }
    100% {
    transform: rotate(360deg);
    }
}
@keyframes bar {
    0% {
        left: -25%;
    }
    100% {
        left: 100%;
    }
}
""";
  }
}

/// Contents of flutter_bootstrap.js.
///
/// flutter_bootstrap.jsの中身。
class BootstrapJsCliCode extends CliCode {
  /// Contents of flutter_bootstrap.js.
  ///
  /// flutter_bootstrap.jsの中身。
  const BootstrapJsCliCode();

  @override
  String get name => "flutter_bootstrap";

  @override
  String get prefix => "flutter_bootstrap";

  @override
  String get directory => "web";

  @override
  String get description =>
      "Create a flutter_bootstrap.js for web. Web用のflutter_bootstrap.jsを作成します。";

  @override
  String import(String path, String baseName, String className) {
    return "";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
{{flutter_js}}
{{flutter_build_config}}
_flutter.loader.load({
    onEntrypointLoaded: async function (engineInitializer) {
        const appRunner = await engineInitializer.initializeEngine();
        document.body.querySelector(".loading").style.display = "none";
        await appRunner.runApp();
    },
});
""";
  }
}

/// Create a base class for the home page.
///
/// ホームページのベースクラスを作成します。
class HomePageCliCode extends CliCode {
  /// Create a base class for the home page.
  ///
  /// ホームページのベースクラスを作成します。
  const HomePageCliCode({this.module});

  /// Module name. If this is specified, the code for the module is output.
  ///
  /// モジュール名。これが指定されている場合はモジュール用のコードを出力します。
  final String? module;

  @override
  String get name => "home";

  @override
  String get prefix => "home";

  @override
  String get directory => "lib/pages";

  @override
  String get description =>
      "Create a base class for the home page in `$directory/(filepath).dart`. ホームページのベースクラスを`$directory/(filepath).dart`に作成します。";

  @override
  String import(String path, String baseName, String className) {
    return """
// ignore: unused_import, unnecessary_import
import "package:flutter/material.dart";
// ignore: unused_import, unnecessary_import
import "package:masamune/masamune.dart";
import "package:masamune_universal_ui/masamune_universal_ui.dart";

// ignore: unused_import, unnecessary_import
import "/${module != null ? module?.toSnakeCase() : "main"}.dart";
""";
  }

  @override
  String header(String path, String baseName, String className) {
    return """
import "/models/counter.dart";

part "$baseName.page.dart";
""";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
@immutable
@PagePath("/")
class HomePage extends PageScopedWidget {
  const HomePage({
    super.key,
  });

  /// Used to transition to the HomePage screen.
  ///
  /// ```dart
  /// router.push(HomePage.query(parameters));    // Push page to HomePage.
  /// router.replace(HomePage.query(parameters)); // Replace page to HomePage.
  /// ```
  @pageRouteQuery
  static const query = _\$HomePageQuery();

  @override
  Widget build(BuildContext context, PageRef ref) {
    // Describes the process of loading
    // and defining variables required for the page.
    final model = ref.app.model(CounterModel.document())..load();

    // Describes the structure of the page.
    return UniversalScaffold(
      appBar: UniversalAppBar(title: Text(${module != null ? "ml().appTitle" : "l().appTitle"})),
      body: UniversalColumn(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "You have pushed the button this many times:",
          ),
          Text(
            "\${model.value?.counter.value ?? 0}",
            style: context.theme.text.displayMedium,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final value = model.value ?? const CounterModel();
          model.save(
            value.copyWith(counter: value.counter.increment(1)),
          );
        },
        tooltip: "Increment",
        child: const Icon(Icons.add),
      ),
    );
  }
}

${module == null ? "" : """
/// [RouteQueryBuilder], which is also available externally.
///
/// ```dart
/// @PagePath(
///   "test",
///   implementType: HomePageQuery,
/// )
/// class TestPage extends PageScopedWidget {
/// }
/// ```
typedef HomePageQuery = _\$HomePageQuery;
"""}
""";
  }
}

/// Create a base class for the counter model.
///
/// カウンターモデルのベースクラスを作成します。
class CounterModelCliCode extends CliCode {
  /// Create a base class for the counter model.
  ///
  /// カウンターモデルのベースクラスを作成します。
  const CounterModelCliCode({this.module});

  /// Module name. If this is specified, the code for the module is output.
  ///
  /// モジュール名。これが指定されている場合はモジュール用のコードを出力します。
  final String? module;

  @override
  String get name => "counter";

  @override
  String get prefix => "counter";

  @override
  String get directory => "lib/models";

  @override
  String get description =>
      "Create a base class for the counter model in `$directory/(filepath).dart`. カウンターモデルのベースクラスを`$directory/(filepath).dart`に作成します。";

  @override
  String import(String path, String baseName, String className) {
    return """
// ignore: unused_import, unnecessary_import
import "package:flutter/material.dart";
// ignore: unused_import, unnecessary_import
import "package:masamune/masamune.dart";

// ignore: unused_import, unnecessary_import
import "/${module != null ? module?.toSnakeCase() : "main"}.dart";
""";
  }

  @override
  String header(String path, String baseName, String className) {
    return """
import "package:freezed_annotation/freezed_annotation.dart";

part "$baseName.m.dart";
part "$baseName.g.dart";
part "$baseName.freezed.dart";
""";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
/// Alias for ModelRef&lt;CounterModel&gt;.
/// 
/// When defining parameters for other Models, you can define them as follows
/// 
/// ```dart
/// @refParam CounterModelRef $baseName
/// ```
typedef CounterModelRef = ModelRef<CounterModel>?;

/// Value for model.
@freezed
@formValue
@immutable
@DocumentModelPath("app/counter")
abstract class CounterModel with _\$CounterModel {
  /// Value for model.
  const factory CounterModel({
     @Default(ModelCounter(0)) ModelCounter counter,
  }) = _CounterModel;
  const CounterModel._();

  /// Convert from JSON.
  ///
  /// ```dart
  /// CounterModel.fromJson(json);
  /// ```
  factory CounterModel.fromJson(Map<String, Object?> json) => _\$CounterModelFromJson(json);

  /// Query for document.
  ///
  /// ```dart
  /// appRef.model(CounterModel.document());       // Get the document.
  /// ref.app.model(CounterModel.document())..load();  // Load the document.
  /// ```
  static const document = _\$CounterModelDocumentQuery();

  /// Query for form value.
  ///
  /// ```dart
  /// ref.app.form(CounterModel.form(CounterModel()));    // Get the form controller in app scope.
  /// ref.page.form(CounterModel.form(CounterModel()));    // Get the form controller in page scope.
  /// ```
  static const form = _\$CounterModelFormQuery();
}
""";
  }
}

/// Contents of lib/`module`.dart.
///
/// lib/`module`.dartの中身。
class ModuleCliCode extends CliCode {
  /// Contents of lib/`module`.dart.
  ///
  /// lib/`module`.dartの中身。
  const ModuleCliCode();

  @override
  String get name => "module";

  @override
  String get prefix => "module";

  @override
  String get directory => "lib";

  @override
  String get description =>
      "Create a module.dart for all Masamune Framework functions.\nMasamune Frameworkの機能すべてに対応したmodule.dartを作成します。";

  @override
  String import(String path, String baseName, String className) {
    return """
// Copyright (c) ${Clock.now().year} mathru. All rights reserved.

/// Any comment.
///
/// To use, import `package:${className.toSnakeCase()}/${className.toSnakeCase()}.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library ${className.toSnakeCase()};

import "package:flutter/material.dart";

import "package:masamune/masamune.dart";
import "package:masamune_module/masamune_module.dart";

import "pages/home.dart";

// Package exports:
export "package:masamune_module/masamune_module.dart";
""";
  }

  @override
  String header(String path, String baseName, String className) {
    return """
part "${className.toSnakeCase()}.localize.dart";
""";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
/// App Localization.
///
/// ```dart
/// ml().xxx  // Localization for xxx.
/// ```
final ml = AppLocalize();

/// App Localization.
///
/// You can add multilingual support by editing `localize.yaml`.
/// 
/// [version] is the version of the Yaml file.
@YamlLocalize(version: 1)
class AppLocalize extends _\$AppLocalize {}

/// Define [${className.toPascalCase()}MasamuneAdapter] specific words and settings.
class ${className.toPascalCase()}ModuleOptions extends ModuleOptions {
  const ${className.toPascalCase()}ModuleOptions();

  // TODO: Define the words used in the module.
}

/// Define [${className.toPascalCase()}MasamuneAdapter] pages.
class ${className.toPascalCase()}ModulePages extends ModulePages {
  const ${className.toPascalCase()}ModulePages({
    this.home = const HomePageQuery(),
  });

  // TODO: Define the pages.
  final HomePageQuery home;

  @override
  List<RouteQueryBuilder> get pages => [
    home,
  ];
}

/// [AppModuleMasamuneAdapter] should be compiled into a list of [MasamuneAdapters] and passed to [runMasamuneApp.masamuneAdapters].
/// 
/// ```dart
/// const module = ${className.toPascalCase()}MasamuneAdapter();
/// 
/// void main() {
///  runMasamuneApp(
///    (adapters) => MasamuneApp(
///      title: title,
///      appRef: appRef,
///      theme: theme,
///      routerConfig: router,
///      localize: l,
///      authAdapter: authAdapter,
///      modelAdapter: modelAdapter,
///      storageAdapter: storageAdapter,
///      functionsAdapter: functionsAdapter,
///      loggerAdapters: loggerAdapters,
///      masamuneAdapters: adapters,
///    ),
///    masamuneAdapters: [module],
///  );
///}
/// ```
@immutable
class ${className.toPascalCase()}MasamuneAdapter extends AppModuleMasamuneAdapter<${className.toPascalCase()}ModulePages, ${className.toPascalCase()}ModuleOptions> {
  /// [AppModuleMasamuneAdapter] should be compiled into a list of [MasamuneAdapters] and passed to [runMasamuneApp.masamuneAdapters].
  /// 
  /// ```dart
  /// const module = ${className.toPascalCase()}MasamuneAdapter();
  /// 
  /// void main() {
  ///  runMasamuneApp(
  ///    (adapters) => MasamuneApp(
  ///      title: title,
  ///      appRef: appRef,
  ///      theme: theme,
  ///      routerConfig: router,
  ///      localize: l,
  ///      authAdapter: authAdapter,
  ///      modelAdapter: modelAdapter,
  ///      storageAdapter: storageAdapter,
  ///      functionsAdapter: functionsAdapter,
  ///      loggerAdapters: loggerAdapters,
  ///      masamuneAdapters: adapters,
  ///    ),
  ///    masamuneAdapters: [module],
  ///  );
  ///}
  ///```
  const ${className.toPascalCase()}MasamuneAdapter({
    required super.appRef,
    required super.auth,
    required super.router,
    required super.localize,
    required super.theme,
    required super.function,
    super.title,
    super.option = const ${className.toPascalCase()}ModuleOptions(),
    super.page = const ${className.toPascalCase()}ModulePages(),
  });

  /// You can retrieve the [${className.toPascalCase()}MasamuneAdapter] first given by [MasamuneAdapterScope].
  static ${className.toPascalCase()}MasamuneAdapter get primary {
    assert(
      _primary != null,
      "${className.toPascalCase()}MasamuneAdapter is not set. Place [MasamuneAdapterScope] widget closer to the root.",
    );
    return _primary!;
  }

  static ${className.toPascalCase()}MasamuneAdapter? _primary;

  @override
  void onInitScope(MasamuneAdapter adapter) {
    super.onInitScope(adapter);
    if (adapter is! ${className.toPascalCase()}MasamuneAdapter) {
      return;
    }
    _primary = adapter;
  }

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<${className.toPascalCase()}MasamuneAdapter>(
      adapter: this,
      child: super.onBuildApp(context, app),
    );
  }
}
""";
  }
}

/// Contents of .pubignore.
///
/// .pubignoreの中身。
class PubignoreCliCode extends CliCode {
  /// Contents of .pubignore.
  ///
  /// .pubignoreの中身。
  const PubignoreCliCode();

  @override
  String get name => ".pubignore";

  @override
  String get prefix => ".pubignore";

  @override
  String get directory => "";

  @override
  String get description =>
      "Define `.pubignore` with additional settings. `.pubignore`を追加設定込で定義します。";

  @override
  String import(String path, String baseName, String className) {
    return "";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return r"""
# See https://dart.dev/tools/pub/publishing#what-files-are-published

# example
example/.github/
example/.vscode/
example/firebase/
example/documents/
example/ios/
example/android/
example/macos/
example/windows/
example/web/
example/linux/
example/build/
example/.dart_tool
example/.flutter-plugins
example/.flutter-plugins-dependencies
example/.packages
example/.pub-cache/
example/.pub/

# android
android/.classpath
android/.project
android/.settings/org.eclipse.buildship.core.prefs

# lib
firebase_options.dart

# Yaml
pubspec_overrides.yaml
katana.yaml
build.yaml
lefthook.yaml

# others
.DS_Store
.env
.dart_tool/
.packages
.pub/
build/
*.iml
.idea/
.vscode/
.flutter-plugins-dependencies
flutter_export_environment.sh
.last_build_id
""";
  }
}

/// Contents of README.md.
///
/// README.mdの中身。
class ModuleReadMeCliCode extends CliCode {
  /// Contents of README.md.
  ///
  /// README.mdの中身。
  const ModuleReadMeCliCode({required this.module});

  /// Module Name.
  ///
  /// モジュール名。
  final String module;

  @override
  String get name => "README";

  @override
  String get prefix => "README";

  @override
  String get directory => "";

  @override
  String get description =>
      "Define `README.md` with additional settings. `README.md`を追加設定込で定義します。";

  @override
  String import(String path, String baseName, String className) {
    return "";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune ${module.toPascalCase()} Module</h1>
</p>

<p align="center">
  <a href="https://github.com/mathrunet">
    <img src="https://img.shields.io/static/v1?label=GitHub&message=Follow&logo=GitHub&color=333333&link=https://github.com/mathrunet" alt="Follow on GitHub" />
  </a>
  <a href="https://x.com/mathru">
    <img src="https://img.shields.io/static/v1?label=@mathru&message=Follow&logo=X&color=0F1419&link=https://x.com/mathru" alt="Follow on X" />
  </a>
  <a href="https://www.youtube.com/c/mathrunetchannel">
    <img src="https://img.shields.io/static/v1?label=YouTube&message=Follow&logo=YouTube&color=FF0000&link=https://www.youtube.com/c/mathrunetchannel" alt="Follow on YouTube" />
  </a>
  <a href="https://github.com/invertase/melos">
    <img src="https://img.shields.io/static/v1?label=maintained%20with&message=melos&color=FF1493&link=https://github.com/invertase/melos" alt="Maintained with Melos" />
  </a>
</p>

<p align="center">
  <a href="https://github.com/sponsors/mathrunet"><img src="https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=ff69b4&link=https://github.com/sponsors/mathrunet" alt="GitHub Sponsor" /></a>
</p>

---

[[GitHub]](https://github.com/mathrunet) | [[YouTube]](https://www.youtube.com/c/mathrunetchannel) | [[Packages]](https://pub.dev/publishers/mathru.net/packages) | [[X]](https://x.com/mathru) | [[LinkedIn]](https://www.linkedin.com/in/mathrunet/) | [[mathru.net]](https://mathru.net)

---

Plug-in packages that add functionality to the Masamune Framework.

For more information about Masamune Framework, please click here.

[https://pub.dev/packages/masamune](https://pub.dev/packages/masamune)

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)
""";
  }
}

/// Contents of melos.yaml.
///
/// melos.yamlの中身。
class MelosCliCode extends CliCode {
  /// Contents of melos.yaml.
  ///
  /// melos.yamlの中身。
  const MelosCliCode({required this.module, required this.repository});

  /// Module Name.
  ///
  /// モジュール名。
  final String module;

  /// The name of the Git repository.
  ///
  /// Gitレポジトリ名。
  final String? repository;

  @override
  String get name => "melos";

  @override
  String get prefix => "melos";

  @override
  String get directory => "";

  @override
  String get description =>
      "Define `melos.yaml` with additional settings. `melos.yaml`を追加設定込で定義します。";

  @override
  String import(String path, String baseName, String className) {
    return "";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
name: ${module.toSnakeCase()}
repository: $repository
packages:
  - .
  - example
command:
  version:
    # Generate commit links in package changelogs.
    linkToCommits: true
    # Only allow versioning to happen on main branch.
    branch: main
    # Additionally build a changelog at the root of the workspace.
    workspaceChangelog: false
  bootstrap:
    # It seems so that running "pub get" in parallel has some issues (like
    # https://github.com/dart-lang/pub/issues/3404). Disabling this feature
    # makes the CI much more stable.
    runPubGetInParallel: false

scripts:
  format: >
    melos exec -- "dart format ."
  
  publish: >
    melos publish --no-dry-run -y
  
  upgrade: >
    melos exec -- "flutter pub upgrade"

  analyze: >
    melos exec -- "flutter analyze"

  fix: >
    melos exec -- "dart fix --apply lib"

  import_sorter: >
    melos exec -- "flutter pub run import_sorter:main ."
""";
  }
}

/// Contents of LICENSE.
///
/// LICENSEの中身。
class LicenseCliCode extends CliCode {
  /// Contents of LICENSE.
  ///
  /// LICENSEの中身。
  const LicenseCliCode();

  @override
  String get name => "LICENSE";

  @override
  String get prefix => "LICENSE";

  @override
  String get directory => "";

  @override
  String get description => "Define LICENSE. LICENSEを定義します。";

  @override
  String import(String path, String baseName, String className) {
    return "";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
MIT License

Copyright (c) ${Clock.now().year} mathru (https://mathru.net)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.""";
  }
}

/// Contents of the Package's main Dart file.
///
/// PackageのメインDartファイルの中身。
class PackageMainCliCode extends CliCode {
  /// Contents of the Package's main Dart file.
  ///
  /// PackageのメインDartファイルの中身。
  const PackageMainCliCode({
    required this.packageName,
  });

  /// Package Name.
  ///
  /// パッケージ名。
  final String packageName;

  @override
  String get name => packageName.toSnakeCase();

  @override
  String get prefix => packageName.toSnakeCase();

  @override
  String get directory => "lib";

  @override
  String get description =>
      "Define the main Dart file of the package. パッケージのメインDartファイルを定義します。";

  @override
  String import(String path, String baseName, String className) {
    return "";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
// Copyright (c) 2025 mathru. All rights reserved.

/// A new Flutter package project.
///
/// To use, import `package:${packageName.toSnakeCase()}/${packageName.toSnakeCase()}.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library ${packageName.toSnakeCase()};
""";
  }
}

/// Contents of the Package's README.md file.
///
/// PackageのREADME.mdファイルの中身。
class PackageReadMeCliCode extends CliCode {
  /// Contents of the Package's README.md file.
  ///
  /// PackageのREADME.mdファイルの中身。
  const PackageReadMeCliCode({
    required this.packageName,
  });

  /// Package Name.
  ///
  /// パッケージ名。
  final String packageName;

  @override
  String get name => "README";

  @override
  String get prefix => "README";

  @override
  String get directory => "";

  @override
  String get description =>
      "Define the README.md file of the package. パッケージのREADME.mdファイルを定義します。";

  @override
  String import(String path, String baseName, String className) {
    return "";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">${packageName.toPascalCase()}</h1>
</p>

<p align="center">
  <a href="https://github.com/mathrunet">
    <img src="https://img.shields.io/static/v1?label=GitHub&message=Follow&logo=GitHub&color=333333&link=https://github.com/mathrunet" alt="Follow on GitHub" />
  </a>
  <a href="https://x.com/mathru">
    <img src="https://img.shields.io/static/v1?label=@mathru&message=Follow&logo=X&color=0F1419&link=https://x.com/mathru" alt="Follow on X" />
  </a>
  <a href="https://www.youtube.com/c/mathrunetchannel">
    <img src="https://img.shields.io/static/v1?label=YouTube&message=Follow&logo=YouTube&color=FF0000&link=https://www.youtube.com/c/mathrunetchannel" alt="Follow on YouTube" />
  </a>
  <a href="https://github.com/invertase/melos">
    <img src="https://img.shields.io/static/v1?label=maintained%20with&message=melos&color=FF1493&link=https://github.com/invertase/melos" alt="Maintained with Melos" />
  </a>
</p>

<p align="center">
  <a href="https://github.com/sponsors/mathrunet"><img src="https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=ff69b4&link=https://github.com/sponsors/mathrunet" alt="GitHub Sponsor" /></a>
</p>

---

[[GitHub]](https://github.com/mathrunet) | [[YouTube]](https://www.youtube.com/c/mathrunetchannel) | [[Packages]](https://pub.dev/publishers/mathru.net/packages) | [[X]](https://x.com/mathru) | [[LinkedIn]](https://www.linkedin.com/in/mathrunet/) | [[mathru.net]](https://mathru.net)

---

Plug-in packages that add functionality to the Masamune Framework.

For more information about Masamune Framework, please click here.

[https://pub.dev/packages/masamune](https://pub.dev/packages/masamune)

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)""";
  }
}

/// Contents of dart_defines/**.env
///
/// dart_defines/**.envの中身。
class DartDefinesCliCode extends CliCode {
  /// Contents of dart_defines/**.env
  ///
  /// dart_defines/**.envの中身。
  const DartDefinesCliCode({
    required this.packageName,
    required this.flavor,
  });

  /// Package Name.
  ///
  /// パッケージ名。
  final String packageName;

  /// Flavor.
  ///
  /// フレーバー。
  final String flavor;

  @override
  String get name => flavor;

  @override
  String get prefix => flavor;

  @override
  String get directory => "dart_defines";

  @override
  String get description =>
      "Define the dart_defines/**.env file. dart_defines/**.envファイルを定義します。";

  @override
  String import(String path, String baseName, String className) {
    return "";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
flavor=$flavor
applicationId=$packageName
""";
  }
}

/// Contents of ios/Flutter/DartDefine.xcconfig
///
/// ios/Flutter/DartDefine.xcconfigの中身。
class DartDefinesXcconfigCliCode extends CliCode {
  /// Contents of ios/Flutter/DartDefine.xcconfig
  ///
  /// ios/Flutter/DartDefine.xcconfigの中身。
  const DartDefinesXcconfigCliCode({
    required this.packageName,
  });

  /// Package Name.
  ///
  /// パッケージ名。
  final String packageName;

  @override
  String get name => "DartDefine";

  @override
  String get prefix => "DartDefine";

  @override
  String get directory => "ios/Flutter";

  @override
  String get description =>
      "Define the ios/Flutter/DartDefine.xcconfig file. ios/Flutter/DartDefine.xcconfigファイルを定義します。";

  @override
  String import(String path, String baseName, String className) {
    return "";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
applicationId=$packageName
""";
  }
}

/// Contents of android/env.properties
///
/// android/env.propertiesの中身。
class DartDefinesEnvPropertiesCliCode extends CliCode {
  /// Contents of android/env.properties
  ///
  /// android/env.propertiesの中身。
  const DartDefinesEnvPropertiesCliCode({
    required this.packageName,
  });

  /// Package Name.
  ///
  /// パッケージ名。
  final String packageName;

  @override
  String get name => "env";

  @override
  String get prefix => "env";

  @override
  String get directory => "android";

  @override
  String get description =>
      "Define the android/env.properties file. android/env.propertiesファイルを定義します。";

  @override
  String import(String path, String baseName, String className) {
    return "";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
applicationId=$packageName
""";
  }
}

/// Contents of store.yaml
///
/// store.yamlの中身。
class StoreYamlCliCode extends CliCode {
  /// Contents of store.yaml
  ///
  /// store.yamlの中身。
  const StoreYamlCliCode();

  @override
  String get name => "store";

  @override
  String get prefix => "store";

  @override
  String get directory => "";

  @override
  String get description => "Define the store.yaml file. store.yamlファイルを定義します。";

  @override
  String import(String path, String baseName, String className) {
    return "";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return r"""
# Store Asset Generation Settings File
# ストアアセット生成設定ファイル

# Basic Settings
# 基本設定
project_name: "StoreScreenshot"
output_dir: "documents/store"

# Icon Settings
# アイコン設定
icon:
  foreground:
    path: "documents/icon_foreground.png"
    scale: 0.8
  background:
    # Pattern 1: Image
    # パターン1: 画像
    # path: "./assets/icon_background.png"
    # Pattern 2: Single Color
    # パターン2: 単色
    # color: "#FF6B6B"
    # Pattern 3: Gradient
    # パターン3: グラデーション
    gradient:
      # Type: linear or radial
      type: linear
      # Angle: 0-360 degrees
      angle: 45
      colors:
        - "#2F2F2F"
        - "#484848"

# Logo Settings
# ロゴ設定
logo:
  # Pattern 1: Image
  # パターン1: 画像
  # path: "documents/logo.png"
  # Pattern 2: Generate from text
  # パターン2: テキストから生成
  text: "AppTitle"
  font_family: "MPlus"
  font_size: 64
  color: "#FFFFFF"
  width: 480
  height: 64

# Feature Graphic Settings (Google Play Only)
# フィーチャーグラフィック設定（Google Play用）
feature_graphic:
  # Foreground Image.
  # 前景画像。
  foreground:
    # path: "documents/feature_foreground.png"
  # Icon Overlay.
  # アイコンをオーバーレイ配置。
  icon:
    # Placement Position: top-left, top-center, top-right, left-center, center, right-center, bottom-left, bottom-center, bottom-right
    align: "bottom-right"
    path: "documents/icon_foreground.png"
    scale: 0.016 
    marginX: 276
    marginY: 24

  # Logo Overlay.
  # ロゴをオーバーレイ配置。
  logo:
    # Pattern 1: Image path
    # パターン1: 画像パス
    # path: "./assets/logo.png"
    # Pattern 2: Generate from text
    # パターン2: テキストから生成（pathの代わりに使用）
    text: "AppTitle"
    font_family: "MPlus"
    font_size: 36
    font_weight: "bold"
    color: "#FFFFFF"
    width: 240
    height: 36
    align: "bottom-right"
    scale: 1.0
    marginX: 24
    marginY: 24
  background:
    gradient:
      # Type: linear or radial
      type: linear
      # Angle: 0-360 degrees
      angle: 45
      colors:
        - "#2F2F2F"
        - "#484848"

# Screenshot Settings
# スクリーンショット設定
screenshots:
  # Background Settings
  # 背景設定
  background:
    gradient:
      # Type: linear or radial
      type: linear
      # Angle: 0-360 degrees
      angle: 45
      colors:
        - "#2F2F2F"
        - "#484848"

  # Portrait Screenshot Definitions
  # スクリーンショット定義（縦向き）
  portrait:
    - title:
        ja: "アプリの説明"
        en: "App Description"
      font_family:
        ja: "MPlus"
        en: "MPlus"
      font_size: 108
      text_margin: 260
      text_color: "#000000"
      text_border:
        enabled: true
        width: 12
        color: "#FFFFFF"
      icon:
        # Placement Position: top-left, top-center, top-right, left-center, center, right-center, bottom-left, bottom-center, bottom-right
        align: "top-right"
        path: "documents/icon_foreground.png"
        scale: 0.036
        marginX: 520 
        marginY: 40
      logo:
        # Pattern 1: Image path
        # パターン1: 画像パス
        # path: "./assets/logo.png"
        # Pattern 2: Generate from text
        # パターン2: テキストから生成（pathの代わりに使用）
        text: "AppTitle"
        font_family: "MPlus"
        font_size: 64
        font_weight: "bold"
        color: "#FFFFFF"
        width: 480
        height: 64
        align: "top-right"
        scale: 1.0
        marginX: 40
        marginY: 40
      screenshot:
        phone:
          ja: "documents/screenshots/ja/phone/1.png"
          en: "documents/screenshots/en/phone/1.png"
        tablet:
          ja: "documents/screenshots/ja/tablet/1.png"
          en: "documents/screenshots/en/tablet/1.png"

    - title:
        ja: "アプリの説明"
        en: "App Description"
      font_family:
        ja: "MPlus"
        en: "MPlus"
      font_size: 108
      text_margin: 260
      text_color: "#000000"
      text_border:
        enabled: true
        width: 12
        color: "#FFFFFF"
      icon:
        # Placement Position: top-left, top-center, top-right, left-center, center, right-center, bottom-left, bottom-center, bottom-right
        align: "top-left"
        path: "documents/icon_foreground.png"
        scale: 0.036
        marginX: 40
        marginY: 40
      logo:
        # Pattern 1: Image path
        # パターン1: 画像パス
        # path: "./assets/logo.png"
        # Pattern 2: Generate from text
        # パターン2: テキストから生成（pathの代わりに使用）
        text: "AppTitle"
        font_family: "MPlus"
        font_size: 64
        font_weight: "bold"
        color: "#FFFFFF"
        width: 480
        height: 64
        align: "top-left"
        scale: 1.0
        marginX: 96
        marginY: 40
      screenshot:
        phone:
          ja: "documents/screenshots/ja/phone/2.png"
          en: "documents/screenshots/en/phone/2.png"
        tablet:
          ja: "documents/screenshots/ja/tablet/2.png"
          en: "documents/screenshots/en/tablet/2.png"

    - title:
        ja: "アプリの説明"
        en: "App Description"
      font_family:
        ja: "MPlus"
        en: "MPlus"
      font_size: 108
      text_margin: 260
      text_color: "#000000"
      text_border:
        enabled: true
        width: 12
        color: "#FFFFFF"
      icon:
        # Placement Position: top-left, top-center, top-right, left-center, center, right-center, bottom-left, bottom-center, bottom-right
        align: "top-right"
        path: "documents/icon_foreground.png"
        scale: 0.036
        marginX: 520 
        marginY: 40
      logo:
        # Pattern 1: Image path
        # パターン1: 画像パス
        # path: "./assets/logo.png"
        # Pattern 2: Generate from text
        # パターン2: テキストから生成（pathの代わりに使用）
        text: "AppTitle"
        font_family: "MPlus"
        font_size: 64
        font_weight: "bold"
        color: "#FFFFFF"
        width: 480
        height: 64
        align: "top-right"
        scale: 1.0
        marginX: 40
        marginY: 40
      screenshot:
        phone:
          ja: "documents/screenshots/ja/phone/3.png"
          en: "documents/screenshots/en/phone/3.png"
        tablet:
          ja: "documents/screenshots/ja/tablet/3.png"
          en: "documents/screenshots/en/tablet/3.png"

    - title:
        ja: "アプリの説明"
        en: "App Description"
      font_family:
        ja: "MPlus"
        en: "MPlus"
      font_size: 108
      text_margin: 320
      text_color: "#000000"
      text_border:
        enabled: true
        width: 12
        color: "#FFFFFF"
      icon:
        # Placement Position: top-left, top-center, top-right, left-center, center, right-center, bottom-left, bottom-center, bottom-right
        align: "top-left"
        path: "documents/icon_foreground.png"
        scale: 0.036
        marginX: 40
        marginY: 40
      logo:
        # Pattern 1: Image path
        # パターン1: 画像パス
        # path: "./assets/logo.png"
        # Pattern 2: Generate from text
        # パターン2: テキストから生成（pathの代わりに使用）
        text: "AppTitle"
        font_family: "MPlus"
        font_size: 64
        font_weight: "bold"
        color: "#FFFFFF"
        width: 480
        height: 64
        align: "top-left"
        scale: 1.0
        marginX: 96
        marginY: 40
      screenshot:
        phone:
          ja: "documents/screenshots/ja/phone/4.png"
          en: "documents/screenshots/en/phone/4.png"
        tablet:
          ja: "documents/screenshots/ja/tablet/4.png"
          en: "documents/screenshots/en/tablet/4.png"

    - title:
        ja: "アプリの説明"
        en: "App Description"
      font_family:
        ja: "MPlus"
        en: "MPlus"
      font_size: 108
      text_margin: 260
      text_color: "#000000"
      text_border:
        enabled: true
        width: 12
        color: "#FFFFFF"
      icon:
        # Placement Position: top-left, top-center, top-right, left-center, center, right-center, bottom-left, bottom-center, bottom-right
        align: "top-right"
        path: "documents/icon_foreground.png"
        scale: 0.036
        marginX: 520 
        marginY: 40
      logo:
        # Pattern 1: Image path
        # パターン1: 画像パス
        # path: "./assets/logo.png"
        # Pattern 2: Generate from text
        # パターン2: テキストから生成（pathの代わりに使用）
        text: "AppTitle"
        font_family: "MPlus"
        font_size: 64
        font_weight: "bold"
        color: "#FFFFFF"
        width: 480
        height: 64
        align: "top-right"
        scale: 1.0
        marginX: 40
        marginY: 40
      screenshot:
        phone:
          ja: "documents/screenshots/ja/phone/5.png"
          en: "documents/screenshots/en/phone/5.png"
        tablet:
          ja: "documents/screenshots/ja/tablet/5.png"
          en: "documents/screenshots/en/tablet/5.png"

  # Landscape Screenshot Definitions
  # スクリーンショット定義（横向き）
  landscape:
    - title:
        ja: "アプリの説明"
        en: "App Description"
      font_family:
        ja: "MPlus"
        en: "MPlus"
      font_size: 108
      text_margin: 520
      text_margin_tablet: 320
      text_color: "#000000"
      text_border:
        enabled: true
        width: 12
        color: "#FFFFFF"
      # layout_pattern: arrangement pattern in landscape mode
      #   - "text-left" : text on the left, screenshot on the right
      #   - "text-right" : text on the right, screenshot on the left
      #   - default (not specified): default top layout
      layout_pattern: "text-left"
      icon:
        # Placement Position: top-left, top-center, top-right, left-center, center, right-center, bottom-left, bottom-center, bottom-right
        align: "top-left"
        path: "documents/icon_foreground.png"
        scale: 0.036
        marginX: 40
        marginY: 40
      logo:
        # Pattern 1: Image path
        # パターン1: 画像パス
        # path: "./assets/logo.png"
        # Pattern 2: Generate from text
        # パターン2: テキストから生成（pathの代わりに使用）
        text: "AppTitle"
        font_family: "MPlus"
        font_size: 64
        font_weight: "bold"
        color: "#FFFFFF"
        width: 480
        height: 64
        align: "top-left"
        scale: 1.0
        marginX: 96
        marginY: 40
      screenshot:
        phone:
          ja: "documents/screenshots/ja/phone/1.png"
          en: "documents/screenshots/en/phone/1.png"
        tablet:
          ja: "documents/screenshots/ja/tablet/1.png"
          en: "documents/screenshots/en/tablet/1.png"

    - title:
        ja: "アプリの説明"
        en: "App Description"
      font_family:
        ja: "MPlus"
        en: "MPlus"
      font_size: 108
      text_margin: 520
      text_margin_tablet: 320
      text_color: "#000000"
      text_border:
        enabled: true
        width: 12
        color: "#FFFFFF"
      # layout_pattern: arrangement pattern in landscape mode
      #   - "text-left" : text on the left, screenshot on the right
      #   - "text-right" : text on the right, screenshot on the left
      #   - default (not specified): default top layout
      layout_pattern: "text-right"
      icon:
        # Placement Position: top-left, top-center, top-right, left-center, center, right-center, bottom-left, bottom-center, bottom-right
        align: "top-right"
        path: "documents/icon_foreground.png"
        scale: 0.036
        marginX: 520 
        marginY: 40
      logo:
        # Pattern 1: Image path
        # パターン1: 画像パス
        # path: "./assets/logo.png"
        # Pattern 2: Generate from text
        # パターン2: テキストから生成（pathの代わりに使用）
        text: "AppTitle"
        font_family: "MPlus"
        font_size: 64
        font_weight: "bold"
        color: "#FFFFFF"
        width: 480
        height: 64
        align: "top-right"
        scale: 1.0
        marginX: 40
        marginY: 40
      screenshot:
        phone:
          ja: "documents/screenshots/ja/phone/2.png"
          en: "documents/screenshots/en/phone/2.png"
        tablet:
          ja: "documents/screenshots/ja/tablet/2.png"
          en: "documents/screenshots/en/tablet/2.png"

    - title:
        ja: "アプリの説明"
        en: "App Description"
      font_family:
        ja: "MPlus"
        en: "MPlus"
      font_size: 108
      text_margin: 520
      text_margin_tablet: 320
      text_color: "#000000"
      text_border:
        enabled: true
        width: 12
        color: "#FFFFFF"
      # layout_pattern: arrangement pattern in landscape mode
      #   - "text-left" : text on the left, screenshot on the right
      #   - "text-right" : text on the right, screenshot on the left
      #   - default (not specified): default top layout
      layout_pattern: "text-left"
      icon:
        # Placement Position: top-left, top-center, top-right, left-center, center, right-center, bottom-left, bottom-center, bottom-right
        align: "top-left"
        path: "documents/icon_foreground.png"
        scale: 0.036
        marginX: 40
        marginY: 40
      logo:
        # Pattern 1: Image path
        # パターン1: 画像パス
        # path: "./assets/logo.png"
        # Pattern 2: Generate from text
        # パターン2: テキストから生成（pathの代わりに使用）
        text: "AppTitle"
        font_family: "MPlus"
        font_size: 64
        font_weight: "bold"
        color: "#FFFFFF"
        width: 480
        height: 64
        align: "top-left"
        scale: 1.0
        marginX: 96
        marginY: 40
      screenshot:
        phone:
          ja: "documents/screenshots/ja/phone/3.png"
          en: "documents/screenshots/en/phone/3.png"
        tablet:
          ja: "documents/screenshots/ja/tablet/3.png"
          en: "documents/screenshots/en/tablet/3.png"

    - title:
        ja: "アプリの説明"
        en: "App Description"
      font_family:
        ja: "MPlus"
        en: "MPlus"
      font_size: 108
      text_margin: 520
      text_margin_tablet: 370
      text_color: "#000000"
      text_border:
        enabled: true
        width: 12
        color: "#FFFFFF"
      # layout_pattern: arrangement pattern in landscape mode
      #   - "text-left" : text on the left, screenshot on the right
      #   - "text-right" : text on the right, screenshot on the left
      #   - default (not specified): default top layout
      layout_pattern: "text-right"
      icon:
        # Placement Position: top-left, top-center, top-right, left-center, center, right-center, bottom-left, bottom-center, bottom-right
        align: "top-right"
        path: "documents/icon_foreground.png"
        scale: 0.036
        marginX: 520 
        marginY: 40
      logo:
        # Pattern 1: Image path
        # パターン1: 画像パス
        # path: "./assets/logo.png"
        # Pattern 2: Generate from text
        # パターン2: テキストから生成（pathの代わりに使用）
        text: "AppTitle"
        font_family: "MPlus"
        font_size: 64
        font_weight: "bold"
        color: "#FFFFFF"
        width: 480
        height: 64
        align: "top-right"
        scale: 1.0
        marginX: 40
        marginY: 40
      screenshot:
        phone:
          ja: "documents/screenshots/ja/phone/4.png"
          en: "documents/screenshots/en/phone/4.png"
        tablet:
          ja: "documents/screenshots/ja/tablet/4.png"
          en: "documents/screenshots/en/tablet/4.png"

    - title:
        ja: "アプリの説明"
        en: "App Description"
      font_family:
        ja: "MPlus"
        en: "MPlus"
      font_size: 108
      text_margin: 520
      text_margin_tablet: 320
      text_color: "#000000"
      text_border:
        enabled: true
        width: 12
        color: "#FFFFFF"
      # layout_pattern: arrangement pattern in landscape mode
      #   - "text-left" : text on the left, screenshot on the right
      #   - "text-right" : text on the right, screenshot on the left
      #   - default (not specified): default top layout
      layout_pattern: "text-left"
      icon:
        # Placement Position: top-left, top-center, top-right, left-center, center, right-center, bottom-left, bottom-center, bottom-right
        align: "top-left"
        path: "documents/icon_foreground.png"
        scale: 0.036
        marginX: 40
        marginY: 40
      logo:
        # Pattern 1: Image path
        # パターン1: 画像パス
        # path: "./assets/logo.png"
        # Pattern 2: Generate from text
        # パターン2: テキストから生成（pathの代わりに使用）
        text: "AppTitle"
        font_family: "MPlus"
        font_size: 64
        font_weight: "bold"
        color: "#FFFFFF"
        width: 480
        height: 64
        align: "top-left"
        scale: 1.0
        marginX: 96
        marginY: 40
      screenshot:
        phone:
          ja: "documents/screenshots/ja/phone/5.png"
          en: "documents/screenshots/en/phone/5.png"
        tablet:
          ja: "documents/screenshots/ja/tablet/5.png"
          en: "documents/screenshots/en/tablet/5.png"

  # デバイスフレーム
  iphone_frame:
    path: "documents/frames/iphone.png"
  ipad_frame:
    path: "documents/frames/ipad.png"
  # Size Specifications
  # サイズ仕様
  sizes:
    iphone:
      name: "iphone-6.9"
      portrait:
        width: 1290
        height: 2796
      landscape:
        width: 2796
        height: 1290
    ipad:
      name: "ipad-12.9"
      portrait:
        width: 2048
        height: 2732
      landscape:
        width: 2732
        height: 2048

# Font Settings
# フォント設定
fonts:
  - family: "MPlus"
    path: "documents/fonts/MPLUSRounded1c-Bold.ttf"
  - family: "ZCool"
    path: "documents/fonts/ZCOOLQingKeHuangYou-Regular.ttf"
  - family: "Jua"
    path: "documents/fonts/Jua-Regular.ttf"

# Language Settings
# 言語設定
locales:
  - ja
  - en

# Output Settings
# 出力設定
output:
  format: png
  quality: 95
  naming_pattern: "{locale}/{type}/{size}/{index}.png"
""";
  }
}
