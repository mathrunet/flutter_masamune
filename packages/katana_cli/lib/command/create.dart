// ignore_for_file: implementation_imports

// Dart imports:
import 'dart:io';

// Package imports:
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:image/image.dart';
import 'package:image/src/formats/ico_encoder.dart';
import 'package:xml/xml.dart';

// Project imports:
import 'package:katana_cli/config.dart';
import 'package:katana_cli/katana_cli.dart';
import 'package:katana_cli/src/android_manifest.dart';

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
  "freezed",
  "json_serializable",
];

/// Other generated files.
///
/// その他の生成ファイル。
const otherFiles = {
  "launch.json": LaunchCliCode(),
  "settings.json": SettingsCliCode(),
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
  Future<void> exec(ExecContext context) async {
    final bin = context.yaml.getAsMap("bin");
    final flutter = bin.get("flutter", "flutter");
    final dart = bin.get("dart", "dart");
    final melos = bin.get("melos", "melos");
    final packageName = context.args.get(1, "");
    final options = context.args.get(2, "");
    final moduleName = context.args.get(3, nullOfString);
    final repositoryName = context.args.get(4, nullOfString);
    if (packageName.isEmpty) {
      error(
        "Please provide the name of the package.\r\nパッケージ名を記載してください。\r\n\r\nkatana create [package name]",
      );
      return;
    }
    if (options == "-m" && (moduleName.isEmpty || repositoryName.isEmpty)) {
      error(
        "When creating a module, please include [module name] and [repository name].\r\n\r\nモジュールを作成する場合は[module name]と[repository name]を記載してください。",
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
    if (options == "-m") {
      await command(
        "Create a Flutter package project.",
        [
          flutter,
          "create",
          "--org",
          domain,
          "--template=package",
          "--project-name",
          moduleName!.toSnakeCase(),
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
          "masamune_module",
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
          "melos",
          "import_sorter",
        ],
      );
      label("Replace lib/${moduleName.toSnakeCase()}.dart");
      await const ModuleCliCode().generateDartCode(
        "lib/${moduleName.toSnakeCase()}",
        moduleName.toSnakeCase(),
      );
      label("Create home.dart");
      await HomePageCliCode(module: moduleName)
          .generateDartCode("lib/pages/home", "home");
      label("Create counter.dart");
      await CounterModelCliCode(module: moduleName)
          .generateDartCode("lib/models/counter", "counter");
      label("Edit a ${moduleName.toSnakeCase()}_test.dart");
      await const WidgetTestCliCode()
          .generateFile("${moduleName.toSnakeCase()}_test.dart");
      label("Generate file for VSCode");
      for (final file in otherFiles.entries) {
        await file.value.generateFile(file.key);
      }
      label("Create a pubspec_overrides.yaml");
      await const PubspecOverridesCliCode()
          .generateFile("pubspec_overrides.yaml");
      label("Create a build.yaml");
      await const BuildCliCode().generateFile("build.yaml");
      label("Edit a analysis_options.yaml");
      await const AnalysisOptionsCliCode()
          .generateFile("analysis_options.yaml");
      label("Replace README.md");
      await ModuleReadMeCliCode(module: moduleName).generateFile("README.md");
      label("Create melos.yaml");
      await MelosCliCode(module: moduleName, repository: repositoryName)
          .generateFile("melos.yaml");
      label("Replace pubspec.yaml");
      final pubspecFile = File("pubspec.yaml");
      final pubspec = await pubspecFile.readAsString();
      await pubspecFile.writeAsString(
        pubspec.replaceAll(
          RegExp(
            r"homepage:",
          ),
          "homepage: https://mathru.net",
        ),
      );
      label("Add a .pubignore");
      await const PubignoreCliCode().generateFile(".pubignore");
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
      if (context.yaml.getAsMap("git").get("ignore_secure_file", true)) {
        if (!gitignores.any((e) => e.startsWith("katana_secrets.yaml"))) {
          gitignores.add("katana_secrets.yaml");
        }
      } else {
        gitignores.removeWhere((e) => e.startsWith("katana_secrets.yaml"));
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
      label("Create example.");
      final exampleDirectory = Directory("example");
      if (!exampleDirectory.existsSync()) {
        await exampleDirectory.create();
      }
      await command(
        "Run the project's build_runner to generate code.",
        [
          "katana",
          "create",
          packageName,
          "-e",
          moduleName.toSnakeCase(),
        ],
        workingDirectory: "example",
      );
      label("Run melos.");
      await command(
        "Run the project's build_runner to generate code.",
        [
          melos,
          "bs",
        ],
      );
    } else {
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
          if (options == "-a" || options == "-e") ...allOptionsImportPackage,
        ],
      );
      if (moduleName.isNotEmpty) {
        await command(
          "Import packages.",
          [
            flutter,
            "pub",
            "add",
            "--directory=.",
            if (moduleName.isNotEmpty)
              if (options == "-e")
                "${moduleName!.toSnakeCase()}:{'path':'../'}"
              else
                moduleName!.toSnakeCase(),
          ],
        );
      }
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
      await MainCliCode(module: moduleName)
          .generateDartCode("lib/main", "main");
      label("Replace lib/theme.dart");
      await const MainThemeCliCode().generateDartCode("lib/theme", "theme");
      label("Replace lib/router.dart");
      await const MainRouterCliCode().generateDartCode("lib/router", "router");
      label("Replace lib/localize.dart");
      await const MainLocalizeCliCode()
          .generateDartCode("lib/localize", "localize");
      label("Replace lib/adapter.dart");
      await const MainAdapterCliCode()
          .generateDartCode("lib/adapter", "adapter");
      label("Replace lib/config.dart");
      await const MainConfigCliCode().generateDartCode("lib/config", "config");
      if (moduleName.isNotEmpty) {
        label("Replace lib/module.dart");
        await MainModuleCliCode(module: moduleName!)
            .generateDartCode("lib/module", "module");
      } else {
        label("Create home.dart");
        await const HomePageCliCode()
            .generateDartCode("lib/pages/home", "home");
        label("Create counter.dart");
        await const CounterModelCliCode()
            .generateDartCode("lib/models/counter", "counter");
      }
      label("Generate file for VSCode");
      for (final file in otherFiles.entries) {
        await file.value.generateFile(file.key);
      }
      label("Create a katana.yaml");
      await KatanaCliCode(context.args.get(2, "") == "-a" ||
              context.args.get(2, "") == "-e")
          .generateFile("katana.yaml");
      label("Replace LICENSE");
      await const LicenseCliCode().generateFile("LICENSE");
      label("Create a katana_secrets.yaml");
      await const KatanaSecretsCliCode().generateFile("katana_secrets.yaml");
      label("Create a pubspec_overrides.yaml");
      await const PubspecOverridesCliCode()
          .generateFile("pubspec_overrides.yaml");
      label("Create a build.yaml");
      await const BuildCliCode().generateFile("build.yaml");
      label("Edit a analysis_options.yaml");
      await const AnalysisOptionsCliCode()
          .generateFile("analysis_options.yaml");
      label("Edit a widget_test.dart");
      await const WidgetTestCliCode().generateFile("widget_test.dart");
      label("Create a loader.css");
      await const LoaderCssCliCode().generateFile("loader.css");
      label("Edit as index.html");
      final indexHtmlFile = File("web/index.html");
      final htmlDocument = parse(await indexHtmlFile.readAsString());
      final body = htmlDocument.body;
      final head = htmlDocument.head;
      if (body != null) {
        if (!body.children.any((element) =>
            element.localName == "div" &&
            element.classes.contains("loading"))) {
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
      await indexHtmlFile.writeAsString(htmlDocument.outerHtml);
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
      if (context.yaml.getAsMap("git").get("ignore_secure_file", true)) {
        if (!gitignores.any((e) => e.startsWith("katana_secrets.yaml"))) {
          gitignores.add("katana_secrets.yaml");
        }
      } else {
        gitignores.removeWhere((e) => e.startsWith("katana_secrets.yaml"));
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
    return Config.katanaYamlCode(showAllConfig);
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
    return Config.katanaSecretsYamlCode();
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
import 'package:masamune/masamune.dart';
import 'config.dart';
import 'router.dart';
import 'theme.dart';
import 'localize.dart';
import 'adapter.dart';

export 'config.dart';
export 'router.dart';
export 'theme.dart';
export 'localize.dart';
export 'adapter.dart';
${module == null ? "" : "export 'module.dart';"}
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
const flavor = String.fromEnvironment("FLAVOR");

/// App.
void main() {
  runMasamuneApp(
    (adapters) => MasamuneApp(
      title: title,
      appRef: appRef,
      theme: theme,
      routerConfig: router,
      localize: l,
      authAdapter: authAdapter,
      modelAdapter: modelAdapter,
      storageAdapter: storageAdapter,
      functionsAdapter: functionsAdapter,
      loggerAdapters: loggerAdapters,
      masamuneAdapters: adapters,
    ),
    masamuneAdapters: masamuneAdapters,
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
import 'package:flutter/material.dart';
import 'package:masamune/masamune.dart';
""";
  }

  @override
  String header(String path, String baseName, String className) {
    return """
part '$baseName.theme.dart';
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
  const MainRouterCliCode({this.module});

  /// Name of the module to be used.
  ///
  /// 利用するモジュール名。
  final String? module;

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
import 'package:masamune/masamune.dart';
${module == null ? "import 'pages/home.dart';" : "import 'package:${module!.toSnakeCase()}/pages/home.dart';"}

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
  initialQuery: \${2:HomePage.query()},
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
import 'package:flutter/material.dart';
import 'package:masamune/masamune.dart';
""";
  }

  @override
  String header(String path, String baseName, String className) {
    return """
part '$baseName.localize.dart';
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

// TODO: Set the Google Spreadsheet URL for the translation.
@GoogleSpreadSheetLocalize(
  [
    "\${1:https://docs.google.com/spreadsheets/d/1bw7IXEr7BGkZ4U6on0OuF7HQkTMgDSm6u5ThpBkDPeo/edit#gid=551986808}",
  ],
  version: 1,
)
class AppLocalize extends _\$AppLocalize {}
""";
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
import 'package:masamune/masamune.dart';
import 'package:masamune_universal_ui/masamune_universal_ui.dart';
${module == null ? "" : "import 'module.dart';"}
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
final modelAdapter = RuntimeModelAdapter();

/// App Auth.
/// 
/// Changing to another adapter allows you to change to another authentication mechanism.
// TODO: Change the authentication.
final authAdapter = RuntimeAuthAdapter();

/// App Storage.
/// 
/// Changing to another adapter allows you to change to another storage mechanism.
// TODO: Change the storage.
final storageAdapter = LocalStorageAdapter();

/// App Functions.
/// 
/// Changing to another adapter allows you to change to another functions mechanism.
// TODO: Change the functions.
final functionsAdapter = RuntimeFunctionsAdapter();

/// Logger adapter list.
/// 
/// Adapters for logging can be defined here.
// TODO: Change the loggers.
final loggerAdapters = <LoggerAdapter>[
  const ConsoleLoggerAdapter(),
];

/// Masamune adapter.
/// 
/// The Masamune framework plugin functions can be defined together.
// TODO: Add the adapters.
final masamuneAdapters = <MasamuneAdapter>[
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
import 'package:flutter/material.dart';
import 'package:masamune/masamune.dart';
import 'package:masamune_universal_ui/masamune_universal_ui.dart';
import 'package:${module.toSnakeCase()}/${module.toSnakeCase()}.dart';"
import 'package:${module.toSnakeCase()}/pages/home.dart';"
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
    use_build_context_synchronously: false
    library_private_types_in_public_api: false
    # avoid_print: false  # Uncomment to disable the `avoid_print` rule
    # prefer_single_quotes: true  # Uncomment to enable the `prefer_single_quotes` rule

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
      "args": ["--dart-define=FLAVOR=dev", "--web-renderer", "canvaskit", "--web-port=5555"]
    },
    {
      "name": "Staging",
      "request": "launch",
      "type": "dart",
      "args": ["--dart-define=FLAVOR=stg", "--web-renderer", "canvaskit", "--web-port=5555"]
    },
    {
      "name": "Production",
      "request": "launch",
      "type": "dart",
      "args": ["--dart-define=FLAVOR=prod", "--web-renderer", "html", "--web-port=5555", "--release"]
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
        "*.dart": "$(capture).m.dart,$(capture).page.dart,$(capture).localize.dart,$(capture).theme.dart,$(capture).g.dart,$(capture).freezed.dart"
    }
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

import 'package:flutter_test/flutter_test.dart';

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
      masamune_builder:katana_theme_builder:
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
      masamune_builder:katana_router_page_builder:
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
      masamune_builder:katana_router_router_builder:
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
      masamune_builder:katana_prefs_builder:
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
      masamune_builder:katana_localization_builder:
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
      masamune_builder:katana_listenables_builder:
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
import 'package:flutter/material.dart';
// ignore: unused_import, unnecessary_import
import 'package:masamune/masamune.dart';
import 'package:masamune_universal_ui/masamune_universal_ui.dart';

// ignore: unused_import, unnecessary_import
import '/${module != null ? module?.toSnakeCase() : "main"}.dart';
""";
  }

  @override
  String header(String path, String baseName, String className) {
    return """
import '/models/counter.dart';

part '$baseName.page.dart';
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
import 'package:flutter/material.dart';
// ignore: unused_import, unnecessary_import
import 'package:masamune/masamune.dart';

// ignore: unused_import, unnecessary_import
import '/${module != null ? module?.toSnakeCase() : "main"}.dart';
""";
  }

  @override
  String header(String path, String baseName, String className) {
    return """
import 'package:freezed_annotation/freezed_annotation.dart';

part '$baseName.m.dart';
part '$baseName.g.dart';
part '$baseName.freezed.dart';
""";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
/// Alias for ModelRef<CounterModel>.
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
class CounterModel with _\$CounterModel {
  const factory CounterModel({
     @Default(ModelCounter(0)) ModelCounter counter,
  }) = _CounterModel;
  const CounterModel._();

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
// Copyright (c) ${DateTime.now().year} mathru. All rights reserved.

/// Any comment.
///
/// To use, import `package:${className.toSnakeCase()}/${className.toSnakeCase()}.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library ${className.toSnakeCase()};

import 'package:flutter/material.dart';

import 'package:masamune/masamune.dart';
import 'package:masamune_module/masamune_module.dart';

import 'pages/home.dart';

// Package exports:
export 'package:masamune_module/masamune_module.dart';
""";
  }

  @override
  String header(String path, String baseName, String className) {
    return """
part '${className.toSnakeCase()}.localize.dart';
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

// TODO: Set the Google Spreadsheet URL for the translation.
@GoogleSpreadSheetLocalize(
  [
    "\${6:https://docs.google.com/spreadsheets/d/1bw7IXEr7BGkZ4U6on0OuF7HQkTMgDSm6u5ThpBkDPeo/edit#gid=551986808}",
  ],
  version: 1,
)
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

# github
.github/workflows/
example/.github/

# vscode
example/.vscode/

# firebase
example/firebase/

# documents
example/documents/

# lib
secrets.dart
firebase_options.dart
example/ios/
example/android/
example/macos/
example/windows/
example/web/
example/linux/

# Yaml
pubspec_overrides.yaml
katana_secrets.yaml
katana.yaml
build.yaml
lefthook.yaml
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
  <a href="https://twitter.com/mathru">
    <img src="https://img.shields.io/static/v1?label=Twitter&message=Follow&logo=Twitter&color=1DA1F2&link=https://twitter.com/mathru" alt="Follow on Twitter" />
  </a>
  <a href="https://threads.net/@mathrunet">
    <img src="https://img.shields.io/static/v1?label=Threads&message=Follow&color=101010&link=https://threads.net/@mathrunet" alt="Follow on Threads" />
  </a>
  <a href="https://github.com/invertase/melos">
    <img src="https://img.shields.io/static/v1?label=maintained%20with&message=melos&color=FF1493&link=https://github.com/invertase/melos" alt="Maintained with Melos" />
  </a>
</p>

<p align="center">
  <a href="https://github.com/sponsors/mathrunet"><img src="https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=ff69b4&link=https://github.com/sponsors/mathrunet" alt="GitHub Sponsor" /></a>
</p>

---

[[GitHub]](https://github.com/mathrunet) | [[YouTube]](https://www.youtube.com/c/mathrunetchannel) | [[Packages]](https://pub.dev/publishers/mathru.net/packages) | [[Twitter]](https://twitter.com/mathru) | [[Threads]](https://threads.net/@mathrunet) | [[LinkedIn]](https://www.linkedin.com/in/mathrunet/) | [[mathru.net]](https://mathru.net)

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

Copyright (c) ${DateTime.now().year} mathru (https://mathru.net)

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
