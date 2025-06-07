// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:masamune/masamune.dart";
import "package:masamune_calendar/masamune_calendar.dart";

/// List of Masamune adapters for the application.
///
/// This includes the CalendarMasamuneAdapter for calendar functionality.
///
/// アプリケーション用のMasamuneアダプターのリスト。
///
/// カレンダー機能用のCalendarMasamuneAdapterが含まれています。
final List<MasamuneAdapter> masamuneAdapters = [
  const CalendarMasamuneAdapter(),
];

/// Entry point of the application.
///
/// Initializes and runs the Masamune app with calendar integration.
/// The app demonstrates basic calendar functionality with events.
///
/// アプリケーションのエントリーポイント。
///
/// カレンダー統合を含むMasamuneアプリを初期化し実行します。
/// このアプリは基本的なカレンダー機能とイベントを実演します。
void main() {
  runMasamuneApp(
    masamuneAdapters: masamuneAdapters,
    (ref) => MasamuneApp(
      home: const CalendarPage(),
      title: "Flutter Demo",
      masamuneAdapters: ref.adapters,
      theme: AppThemeData(
        primary: Colors.blue,
      ),
    ),
  );
}

/// Main page widget for demonstrating calendar functionality.
///
/// This widget provides a user interface for viewing and navigating
/// through calendar months, displaying events, and managing calendar state.
///
/// カレンダー機能を実演するためのメインページウィジェット。
///
/// このウィジェットはカレンダー月の表示とナビゲーション、イベント表示、
/// カレンダー状態管理のためのユーザーインターフェースを提供します。
class CalendarPage extends StatefulWidget {
  /// Creates a [CalendarPage].
  ///
  /// [CalendarPage]を作成します。
  const CalendarPage({super.key});

  @override
  State<StatefulWidget> createState() => CalendarPageState();
}

/// State class for [CalendarPage].
///
/// Manages the calendar controller and handles navigation between months.
/// Also generates sample events for demonstration purposes.
///
/// [CalendarPage]のStateクラス。
///
/// カレンダーコントローラーを管理し、月間のナビゲーションを処理します。
/// また、デモンストレーション目的でサンプルイベントを生成します。
class CalendarPageState extends State<CalendarPage> {
  /// Controller for managing calendar state and navigation.
  ///
  /// Handles month navigation, date selection, and calendar display state.
  ///
  /// カレンダー状態とナビゲーションを管理するコントローラー。
  ///
  /// 月ナビゲーション、日付選択、カレンダー表示状態を処理します。
  final CalendarController _controller = CalendarController();

  @override
  Widget build(BuildContext context) {
    final now = Clock.now();
    return Scaffold(
      appBar: AppBar(
        title: const Text("App Demo"),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _controller.prev,
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: _controller.next,
          ),
        ],
      ),
      body: Column(
        children: [
          CalendarHeader(
            controller: _controller,
          ),
          Expanded(
            child: Calendar(
              controller: _controller,
              events: [
                // Generate sample events for demonstration
                for (var i = 0; i < 10; i++)
                  CalendarEventItem(
                    startTime: DateTime(now.year, now.month, now.day).add(i.d),
                    data: "Event $i",
                  )
              ],
              expand: true,
            ),
          ),
        ],
      ),
    );
  }
}
