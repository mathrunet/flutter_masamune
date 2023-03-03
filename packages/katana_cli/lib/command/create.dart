// ignore_for_file: implementation_imports

// Dart imports:
import 'dart:io';

// Package imports:
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:image/image.dart';
import 'package:image/src/formats/ico_encoder.dart';

// Project imports:
import 'package:katana_cli/config.dart';
import 'package:katana_cli/katana_cli.dart';

/// Package to import.
///
/// インポートするパッケージ。
final importPackages = [
  "masamune",
  "freezed_annotation",
  "json_annotation",
];

/// Package for dev to import.
///
/// インポートするdev用パッケージ。
final importDevPackages = [
  "build_runner",
  "masamune_builder",
  "freezed",
  "json_serializable",
];

/// Other generated files.
///
/// その他の生成ファイル。
const otherFiles = {
  "launch.json": LaunchCliCode(),
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
      ],
    );
    label("Replace lib/main.dart");
    await const MainCliCode().generateDartCode("lib/main", "main");
    label("Generate file for VSCode");
    for (final file in otherFiles.entries) {
      await file.value.generateFile(file.key);
    }
    label("Create a katana.yaml");
    await const KatanaCliCode().generateFile("katana.yaml");
    label("Create a katana_secrets.yaml");
    await const KatanaSecretsCliCode().generateFile("katana_secrets.yaml");
    label("Create a pubspec_overrides.yaml");
    await const PubspecOverridesCliCode()
        .generateFile("pubspec_overrides.yaml");
    label("Edit a analysis_options.yaml");
    await const AnalysisOptionsCliCode().generateFile("analysis_options.yaml");
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
      "Run `pod install`.",
      [
        "pod",
        "install",
      ],
      workingDirectory: "ios",
    );
  }
}

/// Contents of katana.yaml.
///
/// katana.yamlの中身。
class KatanaCliCode extends CliCode {
  /// Contents of katana.yaml.
  ///
  /// katana.yamlの中身。
  const KatanaCliCode();

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
    return Config.katanaYamlCode;
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
    return r"""
# Describe Github secret information.
# Githubのシークレット情報を記述します。
github:
  # Please describe the Github token.
  # Githubのトークンを記載してください。
  token:
""";
  }
}

/// Contents of main.dart.
///
/// main.dartの中身。
class MainCliCode extends CliCode {
  /// Contents of main.dart.
  ///
  /// main.dartの中身。
  const MainCliCode();

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
import 'package:flutter/material.dart';
import 'package:masamune/masamune.dart';
""";
  }

  @override
  String header(String path, String baseName, String className) {
    return """
part '$baseName.theme.dart';
part '$baseName.localize.dart';
""";
  }

  @override
  String body(String path, String baseName, String className) {
    return r"""
/// App Title.
// TODO: Define the title of the application.
const title = "${1}";

/// Initial page query.
// TODO: Define the initial page query of the application.
final initialQuery = ${2:null};

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
];

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
  ${3}
);

/// App Router.
///
/// ```dart
/// router.push(Page.query());  // Push page to Page.
/// router.pop();               // Pop page.
/// ```
final router = AppRouter(
  // TODO: Please configure the initial routing and redirection settings.
  boot: ${4:null},
  initialQuery: initialQuery,
  redirect: [],
  pages: [
    // TODO: Add the page query to be used for routing.
    ${5}
  ],
);

/// App Localization.
///
/// ```dart
/// l().xxx  // Localization for xxx.
/// ```
final l = AppLocalize();

// TODO: Set the Google Spreadsheet URL for the translation.
@GoogleSpreadSheetLocalize(
  "${6:https://docs.google.com/spreadsheets/d/1bw7IXEr7BGkZ4U6on0OuF7HQkTMgDSm6u5ThpBkDPeo/edit#gid=551986808}",
  version: 1,
)
class AppLocalize extends _$AppLocalize {}

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
    () => MasamuneApp(
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
      masamuneAdapters: masamuneAdapters,
    ),
    masamuneAdapters: masamuneAdapters,
  );
}
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
    # avoid_print: false  # Uncomment to disable the `avoid_print` rule
    # prefer_single_quotes: true  # Uncomment to enable the `prefer_single_quotes` rule

# Additional information about this file can be found at
# https://dart.dev/guides/language/analysis-options

# Set to exclude json_serializable files.
# json_serializableのファイルを除外するための設定。
analyzer:
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
      "args": ["--dart-define=FLAVOR=dev", "--web-renderer", "html", "--web-port=5555"]
    },
    {
      "name": "Staging",
      "request": "launch",
      "type": "dart",
      "args": ["--dart-define=FLAVOR=stg", "--web-renderer", "html", "--web-port=5555"]
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
