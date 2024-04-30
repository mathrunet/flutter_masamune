part of "tmp.dart";

/// Create a template for the bottom navigation.
///
/// 下部ナビゲーションのテンプレートを作成します。
class CodeTmpNavigationCliCommand extends CliCodeCommand {
  /// Create a template for the bottom navigation.
  ///
  /// 下部ナビゲーションのテンプレートを作成します。
  const CodeTmpNavigationCliCommand();

  @override
  String get name => "template_navigation";

  @override
  String get prefix => "templateNavigation";

  @override
  String get directory => "lib/pages";

  @override
  String get description =>
      "Create a template for the navigation page in `$directory/(filepath).dart`. ナビゲーションページのテンプレートを`$directory/(filepath).dart`に作成します。";

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
    label("Create a navigation template in `$directory/$path.dart`.");
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
    return """
// ignore: unused_import, unnecessary_import
import 'package:flutter/material.dart';
// ignore: unused_import, unnecessary_import
import 'package:masamune/masamune.dart';
import 'package:masamune_universal_ui/masamune_universal_ui.dart';

// ignore: unused_import, unnecessary_import
import '/main.dart';
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
/// Define a list of navigation for use with ${className}Page.
enum ${className}PageNavigation {
  // TODO: Define the type of navigation.
  navigation1,
  navigation2;

  /// The first navigation to display.
  // TODO: Specify the initial navigation.
  static const ${className}PageNavigation initialNavigation = ${className}PageNavigation.navigation1;

  /// Get the label of ${className}PageNavigation.
  // TODO: Specify a label for each navigation.
  String get label {
    switch (this) {
      case ${className}PageNavigation.navigation1:
        return "Nav1";
      case ${className}PageNavigation.navigation2:
        return "Nav2";
    }
  }


  /// Get the icon of ${className}PageNavigation.
  // TODO: Specify a icon for each navigation.
  Widget get icon {
    switch (this) {
      case ${className}PageNavigation.navigation1:
        return const Icon(Icons.home);
      case ${className}PageNavigation.navigation2:
        return const Icon(Icons.home);
    }
  }

  /// Get the route query of ${className}PageNavigation.
  // TODO: Specify a RouteQuery for each navigation.
  RouteQuery? get routeQuery {
    switch (this) {
      case ${className}PageNavigation.navigation1:
        return null;
      case ${className}PageNavigation.navigation2:
        return null;
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
    final nestedRouter = ref.page.router(
      initialQuery: ${className}PageNavigation.initialNavigation.routeQuery,
      pages: [],
    );
    \${4}

    // Describes the structure of the page.
    // TODO: Implement the view.
    return UniversalScaffold(
      body: Router.withConfig(config: nestedRouter),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: theme.color.background,
        selectedItemColor: theme.color.primary,
        unselectedItemColor: theme.color.weak,
        type: BottomNavigationBarType.fixed,
        currentIndex: nestedRouter.currentQuery?.key<${className}PageNavigation>()?.index ??
            ${className}PageNavigation.initialNavigation.index,
        onTap: (index) {
          final routeQuery = ${className}PageNavigation.values[index].routeQuery;
          if (routeQuery == null) {
            return;
          }
          nestedRouter.push(routeQuery);
        },
        items: [
          ...${className}PageNavigation.values.map((e) {
            return BottomNavigationBarItem(
              icon: e.icon,
              label: e.label,
            );
          }),
        ],
      ),
    );
  }
}
""";
  }
}
