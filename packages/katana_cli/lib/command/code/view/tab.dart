part of "view.dart";

/// Create a template page for the tab.
///
/// タブのテンプレートページを作成します。
class CodeViewTabCliCommand extends CliCodeCommand {
  /// Create a template page for the tab.
  ///
  /// タブのテンプレートページを作成します。
  const CodeViewTabCliCommand();

  @override
  String get name => "template_tab";

  @override
  String get prefix => "templateTab";

  @override
  String get directory => "lib/pages";

  @override
  String get description =>
      "Create a template for the tab page in `$directory/(filepath).dart`. タブページのテンプレートを`$directory/(filepath).dart`に作成します。";

  @override
  String? get example => "katana code tmp tab [page_name]";

  @override
  Future<void> exec(ExecContext context) async {
    final path = context.args.get(3, "");
    if (path.isEmpty) {
      error(
        "[path] is not specified. Please enter [path] according to the following command.\r\nkatana code tmp form [path]\r\n",
      );
      return;
    }
    final existsMain = File("lib/main.dart").existsSync();
    label("Create a tab template in `$directory/$path.dart`.");
    await generateDartCode(
      "$directory/$path",
      path,
      filter: (value) {
        if (existsMain) {
          return value;
        } else {
          return """$value
/// [RouteQueryBuilder], which is also available externally.
/// 
/// ```dart
/// @PagePath(
///   "test",
///   implementType: ${path.split("/").distinct().join("_").toPascalCase()}PageQuery,
/// )
/// class TestPage extends PageScopedWidget {
/// }
/// ```
typedef ${path.split("/").distinct().join("_").toPascalCase()}PageQuery = _\$${path.split("/").distinct().join("_").toPascalCase()}PageQuery;
""";
        }
      },
    );
  }

  @override
  String import(String path, String baseName, String className) {
    final packageName = retrievePackageName();
    return """
// ignore: unused_import, unnecessary_import
import 'package:flutter/material.dart';
// ignore: unused_import, unnecessary_import
import 'package:masamune/masamune.dart';
import 'package:masamune_universal_ui/masamune_universal_ui.dart';

// ignore: unused_import, unnecessary_import
import 'package:$packageName/main.dart';
""";
  }

  @override
  String header(String path, String baseName, String className) {
    return """
part '$baseName.page.dart';
""";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
/// Define a list of tabs for use with ${className}Page.
enum ${className}PageTab {
  // TODO: Define the type of tabs.
  tab1,
  tab2;

  /// The first tab to display.
  // TODO: Specify the initial tab.
  static const ${className}PageTab initialTab = ${className}PageTab.tab1;

  /// Get the label of ${className}PageTab.
  // TODO: Specify a label for each tab.
  String get label {
    switch (this) {
      case ${className}PageTab.tab1:
        return "Tab1";
      case ${className}PageTab.tab2:
        return "Tab2";
    }
  }

  /// Get the view widget of ${className}PageTab.
  // TODO: Specify a widget for each tab.
  Widget get view {
    switch (this) {
      case ${className}PageTab.tab1:
        return const Empty();
      case ${className}PageTab.tab2:
        return const Empty();
    }
  }
}

/// Page widget for $className.
@immutable
// TODO: Set the path for the page.
@PagePath("\${1:$path}")
class ${className}Page extends PageScopedWidget {
  const ${className}Page({
    super.key,
    // TODO: Set parameters for the page.
    \${2}
  });

  // TODO: Set parameters for the page in the form [final String xxx].
  \${3}

  /// Used to transition to the ${className}Page screen.
  ///
  /// ```dart
  /// router.push(${className}Page.query(parameters));    // Push page to ${className}Page.
  /// router.replace(${className}Page.query(parameters)); // Replace page to ${className}Page.
  /// ```
  @pageRouteQuery
  static const query = _\$${className}PageQuery();

  @override
  Widget build(BuildContext context, PageRef ref) {
    // Describes the process of loading
    // and defining variables required for the page.
    // TODO: Implement the variable loading process.
    \${4}

    final tabBar = TabBar(
      isScrollable: true,
      indicatorSize: TabBarIndicatorSize.tab,
      tabAlignment: TabAlignment.start,
      tabs: [
        ...${className}PageTab.values.map((e) => Tab(text: e.label)),
      ],
    );
    final tabView = TabBarView(
      children: [
        ...${className}PageTab.values.map((e) => e.view),
      ],
    );

    // Describes the structure of the page.
    // TODO: Implement the view.
    return DefaultTabController(
      initialIndex: ${className}PageTab.initialTab.index,
      length: ${className}PageTab.values.length,
      child: UniversalScaffold(
        appBar: UniversalAppBar(
          bottom: tabBar,
        ),
        body: tabView,
      ),
    );
  }
}
""";
  }
}
