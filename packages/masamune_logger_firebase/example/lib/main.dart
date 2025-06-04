// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:freezed_annotation/freezed_annotation.dart";
import "package:masamune/masamune.dart";
import "package:masamune_logger_firebase/masamune_logger_firebase.dart";

part "main.freezed.dart";
part "main.g.dart";

/// Analytics value model for Firebase logging.
///
/// This class represents analytics data that can be logged to Firebase.
/// It implements [Loggable] interface to enable automatic logging functionality.
///
/// Firebase ログ用の分析値モデル。
///
/// このクラスはFirebaseにログできる分析データを表します。
/// 自動ログ機能を有効にするために[Loggable]インターフェースを実装しています。
@freezed
@immutable
abstract class AnalyticsValue with _$AnalyticsValue implements Loggable {
  /// Creates an [AnalyticsValue] with the specified user ID.
  ///
  /// [userId] is required and represents the user identifier for analytics tracking.
  ///
  /// 指定されたユーザーIDで[AnalyticsValue]を作成します。
  ///
  /// [userId]は必須で、分析追跡用のユーザー識別子を表します。
  const factory AnalyticsValue({
    required String userId,
  }) = _AnalyticsValue;

  const AnalyticsValue._();

  /// Creates an [AnalyticsValue] from JSON data.
  ///
  /// JSONデータから[AnalyticsValue]を作成します。
  factory AnalyticsValue.fromJson(Map<String, Object?> json) =>
      _$AnalyticsValueFromJson(json);

  @override
  String get name => runtimeType.toString();
}

/// Entry point of the application.
///
/// Initializes and runs the Masamune app with Firebase logging functionality.
/// The app demonstrates how to send analytics data to Firebase using the logger.
///
/// アプリケーションのエントリーポイント。
///
/// Firebase ログ機能を含むMasamuneアプリを初期化し実行します。
/// このアプリはロガーを使用してFirebaseに分析データを送信する方法を実演します。
void main() {
  runApp(const MyApp());
}

/// Root application widget.
///
/// Sets up the MasamuneApp with Firebase logger adapter and basic theming.
/// Configures the app to use Firebase for logging analytics events.
///
/// ルートアプリケーションウィジェット。
///
/// Firebaseロガーアダプターと基本テーマを使用してMasamuneAppをセットアップします。
/// 分析イベントのログにFirebaseを使用するようにアプリを設定します。
class MyApp extends StatelessWidget {
  /// Creates a [MyApp].
  ///
  /// [MyApp]を作成します。
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MasamuneApp(
      home: const LoggerPage(),
      title: "Flutter Demo",
      theme: AppThemeData(
        primary: Colors.blue,
      ),
      masamuneAdapters: const [FirebaseLoggerMasamuneAdapter()],
    );
  }
}

/// Main page widget for demonstrating Firebase logging functionality.
///
/// This widget provides a user interface for sending analytics data to Firebase.
/// Users can tap a button to trigger logging of sample analytics events.
///
/// Firebase ログ機能を実演するためのメインページウィジェット。
///
/// このウィジェットはFirebaseに分析データを送信するためのユーザーインターフェースを提供します。
/// ユーザーはボタンをタップしてサンプル分析イベントのログを実行できます。
class LoggerPage extends StatefulWidget {
  /// Creates a [LoggerPage].
  ///
  /// [LoggerPage]を作成します。
  const LoggerPage({super.key});

  @override
  State<StatefulWidget> createState() => LoggerPageState();
}

/// State class for [LoggerPage].
///
/// Manages the logger instance and handles logging operations.
/// Automatically sets up and disposes the logger lifecycle.
///
/// [LoggerPage]のStateクラス。
///
/// ロガーインスタンスを管理し、ログ操作を処理します。
/// ロガーのライフサイクルを自動的にセットアップし解放します。
class LoggerPageState extends State<LoggerPage> {
  /// Logger instance for sending analytics data to Firebase.
  ///
  /// Handles the transmission of [Loggable] objects to Firebase Analytics.
  ///
  /// Firebase に分析データを送信するためのロガーインスタンス。
  ///
  /// [Loggable]オブジェクトのFirebase Analyticsへの送信を処理します。
  final logger = Logger();

  @override
  void initState() {
    super.initState();
    logger.addListener(_handledOnUpdate);
  }

  /// Handles logger state updates.
  ///
  /// Called when the logger state changes. Triggers a UI rebuild
  /// to reflect the current logging status.
  ///
  /// ロガー状態の更新を処理します。
  ///
  /// ロガーの状態が変更された際に呼び出されます。現在のログ状態を
  /// 反映するためにUIの再構築をトリガーします。
  void _handledOnUpdate() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    logger.removeListener(_handledOnUpdate);
    logger.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("App Demo")),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await logger
              .send(const AnalyticsValue(userId: "UserID"))
              .showIndicator(context);
        },
        label: const Text("Send Log"),
        icon: const Icon(Icons.add_a_photo),
      ),
    );
  }
}
