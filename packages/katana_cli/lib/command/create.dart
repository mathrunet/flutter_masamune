import 'dart:io';

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
      print(
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
      print(
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
    await const MainCliCode().generateDartCode("lib/main");
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
      print("Cannot find `.gitignore`. Project is broken.");
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
    return r"""
# Describe the application information.
# アプリケーション情報を記載します。
app:

  # Retrieve data from a spreadsheet retrieved by a specific Google Form.
  # Please include the URL of the spreadsheet in [url] and the email address you collected in [email].
  # 特定のGoogleフォームで取得したスプレッドシートからデータを取得します。
  # [url]にスプレッドシートのURL、[email]に収集したメールアドレスを記載してください。
  spread_sheet:
    enable: false
    url:
    email:

  # Create a `CertificateSigningRequest.certSigningRequest` for iOS.
  # Please include your support email address in [email].
  # iOS用の`CertificateSigningRequest.certSigningRequest`を作成します。
  # [email]にサポート用のEmailアドレスを記載してください。
  csr: 
    enable: false
    email:
  
  # Convert the cer file created by Certificate in AppleDeveloperProgram from `CertificateSigningRequest.certSigningRequest` to a p12 file.
  # `CertificateSigningRequest.certSigningRequest`からAppleDeveloperProgramのCertificateにて作成されたcerファイルをp12ファイルに変換します。
  p12:
    enable: false

  # Create a keystore for Android.
  # Enter the alias of the keystore in [alias], the common name in [name], the organization name in [organization], the state or province in [state], and the country in [country].
  # Android用のkeystoreを作成します。
  # [alias]にkeystoreのエイリアス、[name]に共通名、[organization]に組織名、[state]に州や都道府県、[country]に国名を入力してください。
  keystore: 
    enable: false
    alias: 
    name: 
    organization: 
    state: Tokyo
    country: Japan
  
  # Describe the settings for using the file picker.
  # Describe the platform for using the picker in [platform]. Specify `any` or `mobile`. Import the picker package for that platform.
  # Specify the permission message to use the library in IOS in [permission].
  # Please include `en`, `ja`, etc. and write the message in that language there.
  # ファイルピッカーを利用するための設定を記述します。
  # [platform]にピッカーを利用するためのプラットフォームを記述します。`any`もしくは`mobile`を指定してください。そのプラットフォーム用のピッカーパッケージをインポートします。
  # [permission]にIOSでライブラリを利用するための権限許可メッセージを指定します。
  # `en`や`ja`などを記載しそこにその言語でのメッセージを記述してください。
  picker:
    enable: false
    platform: any
    permission:
      en: Use the library for profile images.

# This section contains information related to Firebase.
# Firebase関連の情報を記載します。
firebase:
  # Set the Firebase project ID.
  # FirebaseのプロジェクトIDを設定します。
  project_id:

  # Enable Firebase Functions.
  # Firebase Functionsを有効にします。
  functions:
    enable: false

  # Configure Firebase Hosting settings.
  # Set [use_flutter] to `true` so that all routes point to index.html, and set it to `true` when using Flutter Web.
  # Firebase Hostingの設定を行います。
  # [use_flutter]を`true`にするとすべてのルートがindex.htmlを向くようになります。Flutter Webを利用する際に`true`にしてください。
  hosting:
    enable: false
    use_flutter: false
  
  # Enable Firebase Messaging.
  # Firebase Messagingを有効にします。
  messaging:
    enable: false

# This section contains information related to Git.
# Git関連の情報を記載します。
git:
  # Add secure files to .gitignore.
  # If `false`, password files, etc. will be uploaded to Git.
  # Please limit your use to private repositories only.
  # セキュアなファイルを.gitignoreに追加します。
  # `false`にした場合、パスワードファイルなどがGitにアップロードされることになります。
  # プライベートレポジトリのみでの利用に限定してください。
  ignore_secure_file: true

  # Ensure that the dart code is modified and verified before committing.
  # lefthand installation is required.
  # コミット前にdartコードの修正や確認を行うようにします。
  # lefthandのインストールが必要です。
  pre_commit:
    enable: false

# Github-related information will be described.
# Github関連の情報を記載します。
github:
  # Enable Github Actions to perform CI/CD builds on each platform.
  # Enter the platform you wish to specify in [platform], separated by spaces.
  # Available platforms are `android`, `ios`, `web`, `windows`, `macos`, and `linux`.
  # Github Actionsを有効にして各プラットフォームでCI/CDビルドを行うようにします。
  # [platform]で指定したいプラットフォームをスペース区切り入力します。
  # 使用できるプラットフォームは`android`、`ios`、`web`、`windows`、`macos`、`linux`です。
  action:
    enable: false
    platform: android ios web
    ios:
      # Copy the Issuer ID listed on the page at https://appstoreconnect.apple.com/access/api.
      # https://appstoreconnect.apple.com/access/api のページに記載されているIssuer IDをコピーしてください。
      issuer_id: 
      # Please copy and include your team ID from https://developer.apple.com/account.
      # https://developer.apple.com/account のチームIDをコピーして記載してください。
      team_id: 
""";
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
const authAdapter = RuntimeAuthAdapter();

/// App Storage.
/// 
/// Changing to another adapter allows you to change to another storage mechanism.
const storageAdapter = LocalStorageAdapter();

/// App Functions.
/// 
/// Changing to another adapter allows you to change to another functions mechanism.
const functionsAdapter = RuntimeFunctionsAdapter();

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

/// App Flavor.
const flavor = String.fromEnvironment("FLAVOR");

/// App.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MasamuneApp(
      title: title,
      appRef: appRef,
      theme: theme,
      routerConfig: router,
      localize: l,
      authAdapter: authAdapter,
      modelAdapter: modelAdapter,
      storageAdapter: storageAdapter,
      functionsAdapter: functionsAdapter,
    ),
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
    # avoid_print: false  # Uncomment to disable the `avoid_print` rule
    # prefer_single_quotes: true  # Uncomment to enable the `prefer_single_quotes` rule

# Additional information about this file can be found at
# https://dart.dev/guides/language/analysis-options

# Set to exclude json_serializable files.
# json_serializableのファイルを除外するための設定。
analyzer:
  exclude:
    - "**/*.g.dart"
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

/// Contents of katana.yaml.
///
/// pubspec_overrides.yamlの中身。
class PubspecOverridesCliCode extends CliCode {
  /// Contents of katana.yaml.
  ///
  /// pubspec_overrides.yamlの中身。
  const PubspecOverridesCliCode();

  @override
  String get name => "pubspec_overrides";

  @override
  String get prefix => "kapubspec_overridestana";

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
