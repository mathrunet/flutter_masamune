// Dart imports:

// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:masamune/masamune.dart";
import "package:masamune_universal_ui/masamune_universal_ui.dart";

/// List of Masamune adapters for the application.
///
/// This includes the UniversalMasamuneAdapter for universal UI functionality
/// that provides consistent UI components across different platforms.
///
/// アプリケーション用のMasamuneアダプターのリスト。
///
/// 異なるプラットフォーム間で一貫したUIコンポーネントを提供する
/// ユニバーサルUI機能用のUniversalMasamuneAdapterが含まれています。
final List<MasamuneAdapter> masamuneAdapters = [
  const UniversalMasamuneAdapter(),
];

/// Entry point of the application.
///
/// Initializes and runs the Masamune app with Universal UI functionality.
/// The app demonstrates the usage of Universal UI components that provide
/// consistent design and behavior across different platforms.
///
/// アプリケーションのエントリーポイント。
///
/// ユニバーサルUI機能を含むMasamuneアプリを初期化し実行します。
/// このアプリは異なるプラットフォーム間で一貫したデザインと動作を提供する
/// ユニバーサルUIコンポーネントの使用方法を実演します。
void main() {
  runMasamuneApp(
    masamuneAdapters: masamuneAdapters,
    (ref) => MasamuneApp(
      home: const UniversalUIPage(),
      title: "Flutter Demo",
      masamuneAdapters: ref.adapters,
      theme: AppThemeData(
        primary: Colors.blue,
      ),
    ),
  );
}

/// Main page widget for demonstrating Universal UI functionality.
///
/// This widget showcases the Universal UI components including UniversalScaffold,
/// UniversalAppBar, and UniversalListView. It demonstrates how these components
/// provide consistent behavior and appearance across different platforms while
/// adapting to platform-specific design guidelines.
///
/// Features demonstrated:
/// - Universal scaffold structure
/// - Universal app bar with consistent styling
/// - Universal list view with scrollable content
///
/// ユニバーサルUI機能を実演するためのメインページウィジェット。
///
/// このウィジェットはUniversalScaffold、UniversalAppBar、UniversalListViewを含む
/// ユニバーサルUIコンポーネントを実演します。これらのコンポーネントが
/// プラットフォーム固有のデザインガイドラインに適応しながら、異なるプラットフォーム間で
/// 一貫した動作と外観を提供する方法を実演します。
///
/// 実演機能:
/// - ユニバーサルスキャフォールド構造
/// - 一貫したスタイリングのユニバーサルアプリバー
/// - スクロール可能なコンテンツのユニバーサルリストビュー
class UniversalUIPage extends StatelessWidget {
  /// Creates a [UniversalUIPage].
  ///
  /// [UniversalUIPage]を作成します。
  const UniversalUIPage({super.key});

  @override
  Widget build(BuildContext context) {
    return UniversalScaffold(
      appBar: const UniversalAppBar(
        title: Text("App Demo"),
      ),
      body: UniversalListView(
        children: [
          // Generate sample list items for demonstration
          for (var i = 0; i < 10; i++)
            ListTile(
              title: Text("Title $i"),
              subtitle: Text("Subtitle $i"),
            ),
        ],
      ),
    );
  }
}
