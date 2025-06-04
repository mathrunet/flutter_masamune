// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:katana_functions/katana_functions.dart";

void main() {
  runApp(const MyApp());
}

/// Test functions action for demonstrating functions usage.
///
/// Functions使用方法を実演するテスト用FunctionsAction。
class TestFunctionsAction extends FunctionsAction<TestFunctionsActionResponse> {
  /// Creates a TestFunctionsAction.
  ///
  /// TestFunctionsActionを作成します。
  const TestFunctionsAction({
    required this.responseMessage,
  });

  /// Response message for the action.
  ///
  /// アクション用のレスポンスメッセージ。
  final String responseMessage;

  @override
  String get action => "test";

  @override
  DynamicMap? toMap() {
    return {
      "message": responseMessage,
    };
  }

  @override
  TestFunctionsActionResponse toResponse(DynamicMap map) {
    return TestFunctionsActionResponse(
      message: map["message"] as String,
    );
  }
}

/// Response class for TestFunctionsAction.
///
/// TestFunctionsAction用のレスポンスクラス。
class TestFunctionsActionResponse extends FunctionsActionResponse {
  /// Creates a TestFunctionsActionResponse.
  ///
  /// TestFunctionsActionResponseを作成します。
  const TestFunctionsActionResponse({required this.message});

  /// Response message.
  ///
  /// レスポンスメッセージ。
  final String message;
}

/// Main application widget for functions demo.
///
/// Functions デモ用のメインアプリケーションWidget。
class MyApp extends StatelessWidget {
  /// Creates a MyApp widget.
  ///
  /// MyAppウィジェットを作成します。
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FunctionsAdapterScope(
      adapter: const RuntimeFunctionsAdapter(),
      child: MaterialApp(
        home: const FunctionsPage(),
        title: "Flutter Demo",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      ),
    );
  }
}

/// Functions page widget to demonstrate functions functionality.
///
/// Functions機能を実演するページWidget。
class FunctionsPage extends StatefulWidget {
  /// Creates a FunctionsPage widget.
  ///
  /// FunctionsPageウィジェットを作成します。
  const FunctionsPage({super.key});

  @override
  State<StatefulWidget> createState() => FunctionsPageState();
}

/// State for FunctionsPage widget.
///
/// FunctionsPageウィジェットのState。
class FunctionsPageState extends State<FunctionsPage> {
  /// Functions instance for managing function executions.
  ///
  /// 関数実行を管理するFunctionsインスタンス。
  final functions = Functions();

  @override
  void initState() {
    super.initState();
    functions.addListener(_handledOnUpdate);
  }

  void _handledOnUpdate() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    functions.removeListener(_handledOnUpdate);
    functions.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("App Demo")),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Test Functions"),
            onTap: () async {
              final response = await functions.execute(
                const TestFunctionsAction(responseMessage: "success"),
              );
              debugPrint(response?.message); // "success"
            },
          )
        ],
      ),
    );
  }
}
