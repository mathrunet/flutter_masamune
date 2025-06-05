// ignore_for_file: implementation_imports

// Project imports:
import "package:katana_cli/katana_cli.dart";

/// Create a new module-aware Flutter project.
///
/// 新しいモジュール対応Flutterプロジェクトを作成します。
class CreateModuleCliCommand extends CliCommand {
  /// Create a new module-aware Flutter project.
  ///
  /// 新しいモジュール対応Flutterプロジェクトを作成します。
  const CreateModuleCliCommand();

  @override
  String get description =>
      "Create a new module-aware Flutter project. 新しいモジュール対応Flutterプロジェクトを作成します。";

  @override
  String? get example => "katana module [package_name]";

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
    const main = CreateCliCommand();
    await main.exec(context);

    await command(
      "Create a Flutter project.",
      [
        flutter,
        "create",
        "--org",
        "net.mathru.masamune",
        "--template=package",
        "--project-name",
        "masamune_module_$projectName",
        "module",
      ],
    );
    await command(
      "Import packages.",
      [
        flutter,
        "pub",
        "add",
        ...importPackages,
        "masamune_module",
      ],
      workingDirectory: "module",
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
      workingDirectory: "module",
    );
    label("Create a pubspec_overrides.yaml");
    await const PubspecOverridesCliCode()
        .generateFile("module/pubspec_overrides.yaml");
    label("Edit a analysis_options.yaml");
    await const AnalysisOptionsCliCode()
        .generateFile("module/analysis_options.yaml");
    await command(
      "Import additional packages.",
      [
        flutter,
        "pub",
        "add",
        "masamune_module",
        "masamune_module_$projectName:{\"path\":\"./module/\"}"
      ],
    );
    label("Create a masamune_module_${projectName?.toSnakeCase()}");
    await const ModuleMainCliCode().generateDartCode(
        "module/lib/masamune_module_${projectName?.toSnakeCase()}",
        projectName!);
    label("Replace the main.dart");
    await const AppModuleMainCliCode()
        .generateDartCode("lib/main", projectName);
    label("Edit a widget_test.dart");
    await const ModuleWidgetTestCliCode()
        .generateFile("masamune_module_${projectName.toSnakeCase()}_test.dart");
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
      workingDirectory: "module",
    );
  }
}

/// Contents of main.dart.
///
/// main.dartの中身。
class ModuleMainCliCode extends CliCode {
  /// Contents of main.dart.
  ///
  /// main.dartの中身。
  const ModuleMainCliCode();

  @override
  String get name => "main";

  @override
  String get prefix => "main";

  @override
  String get directory => "module/lib";

  @override
  String get description =>
      "Create main.dart for Module. Module用のmain.dartを作成します。";

  @override
  String import(String path, String baseName, String className) {
    return """
// Copyright ${Clock.now().format("yyyy")} mathru. All rights reserved.

/// masamune_module for specific app.
///
/// To use, import `package:masamune_module_${className.toSnakeCase()}/masamune_module_${className.toSnakeCase()}.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_module_${className.toSnakeCase()};

import "package:flutter/material.dart";

import "package:masamune/masamune.dart";
import "package:masamune_module/masamune_module.dart";
import "package:masamune_universal_ui/masamune_universal_ui.dart";
""";
  }

  @override
  String header(String path, String baseName, String className) {
    return """
part "masamune_module_${className.toSnakeCase()}.localize.dart";
""";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
final _localize = _AppLocalize();

@GoogleSpreadSheetLocalize(
  "https://docs.google.com/spreadsheets/d/1bw7IXEr7BGkZ4U6on0OuF7HQkTMgDSm6u5ThpBkDPeo/edit#gid=551986808",
  version: 1,
)
class _AppLocalize extends _\$_AppLocalize {}

class ${className.toPascalCase()}ModuleMasamuneAdapter extends ModuleMasamuneAdapter {
  ${className.toPascalCase()}ModuleMasamuneAdapter({
    super.additionalMasamuneAdapters = const [],
    super.theme,
    super.authAdapter = const RuntimeAuthAdapter(),
    super.modelAdapter = const RuntimeModelAdapter(),
    super.storageAdapter = const RuntimeStorageAdapter(),
    super.functionsAdapter = const RuntimeFunctionsAdapter(),
    super.additionalLoggerAdapters = const [
      ConsoleLoggerAdapter(),
    ],
    super.scaffoldMessengerKey,
    super.debugShowCheckedModeBanner = true,
    super.showPerformanceOverlay = false,
    super.title = "",
    super.onGenerateTitle,
    super.themeMode,
    super.routerBootOverride,
    super.routerInitialQueryOverride,
    super.additionalRouterPages = const [],
    super.additionalRouterRedirect = const [],
    super.additionalNavigatorObservers = const [],
  });

  // TODO: Set the initial page.
  @override
  RouteQuery get routerInitialQuery => throw UnimplementedError();

  @override
  List<RouteQueryBuilder> get routerPages => [
      ];

  @override
  List<MasamuneAdapter> get masamuneAdapters => [
        ...super.masamuneAdapters,
        this,
      ];

  @override
  AppLocalizeBase? get localize => _localize;

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<${className.toPascalCase()}ModuleMasamuneAdapter>(
      adapter: this,
      child: app,
    );
  }
}
""";
  }
}

/// Contents of main.dart.
///
/// main.dartの中身。
class AppModuleMainCliCode extends CliCode {
  /// Contents of main.dart.
  ///
  /// main.dartの中身。
  const AppModuleMainCliCode();

  @override
  String get name => "main";

  @override
  String get prefix => "main";

  @override
  String get directory => "module/lib";

  @override
  String get description =>
      "Create a main.dart of vs. Module for the app. アプリ用の対Moduleのmain.dartを作成します。";

  @override
  String import(String path, String baseName, String className) {
    return """
import "package:flutter/material.dart";

import "package:masamune/masamune.dart";
import "package:masamune_module/masamune_module.dart";
import "package:masamune_module_${className.toSnakeCase()}/masamune_module_${className.toSnakeCase()}.dart";
""";
  }

  @override
  String header(String path, String baseName, String className) {
    return """
part "main.theme.dart";
""";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
@appTheme
final theme = AppThemeData(
);

final module = ${className.toPascalCase()}ModuleMasamuneAdapter(
  title: "${className.toPascalCase()}",
  theme: theme,
);

void main() {
  runMasamuneApp(
    (adapters) => MasamuneModuleApp(module, adapters),
    masamuneAdapters: module.masamuneAdapters,
  );
}
""";
  }
}

/// Contents of widget_test.dart.
///
/// widget_test.dartの中身。
class ModuleWidgetTestCliCode extends CliCode {
  /// Contents of widget_test.dart.
  ///
  /// widget_test.dartの中身。
  const ModuleWidgetTestCliCode();

  @override
  String get name => "widget_test";

  @override
  String get prefix => "widget_test";

  @override
  String get directory => "module/test";

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
