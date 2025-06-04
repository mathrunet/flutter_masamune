// Dart imports:

// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:masamune/masamune.dart";
import "package:masamune_agora/masamune_agora.dart";

/// List of Masamune adapters for the application.
///
/// This includes the AgoraMasamuneAdapter with necessary configuration
/// for Agora video/audio communication services.
///
/// アプリケーション用のMasamuneアダプターのリスト。
///
/// Agoraビデオ/音声通信サービスに必要な設定を含む
/// AgoraMasamuneAdapterが含まれています。
final List<MasamuneAdapter> masamuneAdapters = [
  const AgoraMasamuneAdapter(
    appId: "e3306fb870954eb880242a756a56c883",
    customerId: "4def5dd9abb0475faa69a5edd1328e6e",
    customerSecret: "f261c32d6af1406eb9a987f5cc900613",
    functionsAdapter: RuntimeFunctionsAdapter(),
  ),
];

/// Entry point of the application.
///
/// Initializes and runs the Masamune app with Agora integration.
/// The app demonstrates basic Agora video communication functionality.
///
/// アプリケーションのエントリーポイント。
///
/// Agora統合を含むMasamuneアプリを初期化し実行します。
/// このアプリは基本的なAgoraビデオ通信機能を実演します。
void main() {
  runMasamuneApp(
    masamuneAdapters: masamuneAdapters,
    (ref) => MasamuneApp(
      home: const AgoraPage(),
      title: "Flutter Demo",
      masamuneAdapters: ref.adapters,
      theme: AppThemeData(
        primary: Colors.blue,
      ),
    ),
  );
}

/// Main page widget for demonstrating Agora video communication.
///
/// This widget provides a user interface for connecting to an Agora channel,
/// displaying video streams from connected users, and managing the connection state.
///
/// Agoraビデオ通信を実演するためのメインページウィジェット。
///
/// このウィジェットはAgoraチャンネルへの接続、接続されたユーザーからの
/// ビデオストリーム表示、接続状態管理のためのユーザーインターフェースを提供します。
class AgoraPage extends StatefulWidget {
  /// Creates an [AgoraPage].
  ///
  /// [AgoraPage]を作成します。
  const AgoraPage({super.key});

  @override
  State<StatefulWidget> createState() => AgoraPagePageState();
}

/// State class for [AgoraPage].
///
/// Manages the Agora controller lifecycle and handles user interactions
/// for video communication functionality.
///
/// [AgoraPage]のStateクラス。
///
/// Agoraコントローラーのライフサイクルを管理し、ビデオ通信機能の
/// ユーザーインタラクションを処理します。
class AgoraPagePageState extends State<AgoraPage> {
  /// Controller for managing Agora video communication.
  ///
  /// Handles connection to the "test_channel" and manages
  /// the list of connected users and their video streams.
  ///
  /// Agoraビデオ通信を管理するコントローラー。
  ///
  /// "test_channel"への接続を処理し、接続されたユーザーと
  /// そのビデオストリームのリストを管理します。
  final AgoraController _controller = AgoraController("test_channel");

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handledOnUpdate);
  }

  /// Handles updates from the Agora controller.
  ///
  /// Called whenever the controller state changes (user joins/leaves, etc.).
  /// Triggers a rebuild of the widget to reflect the latest state.
  ///
  /// Agoraコントローラーからの更新を処理します。
  ///
  /// コントローラーの状態が変更された際（ユーザーの参加/退出など）に呼び出されます。
  /// 最新の状態を反映するためにウィジェットの再構築をトリガーします。
  void _handledOnUpdate() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _controller.removeListener(_handledOnUpdate);
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("App Demo"),
      ),
      body: GridBuilder<AgoraUser>.count(
        crossAxisCount: 2,
        source: _controller.value ?? <AgoraUser>[],
        builder: (context, item, index) {
          return AgoraScreen(value: item);
        },
      ),
      floatingActionButton: !_controller.connected
          ? FloatingActionButton(
              onPressed: () {
                _controller.disconnect();
              },
              child: const Icon(Icons.login),
            )
          : FloatingActionButton(
              onPressed: () {
                _controller.connect(userName: "user_name");
              },
              child: const Icon(Icons.logout),
            ),
    );
  }
}
