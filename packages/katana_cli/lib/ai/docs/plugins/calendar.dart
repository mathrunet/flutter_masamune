// Project imports:
import "package:katana_cli/ai/docs/plugin_usage.dart";

/// Contents of calendar.md.
///
/// calendar.mdの中身。
class PluginCalendarMdCliAiCode extends PluginUsageCliAiCode {
  /// Contents of calendar.md.
  ///
  /// calendar.mdの中身。
  const PluginCalendarMdCliAiCode();

  @override
  String get name => "カレンダー";

  @override
  String get description => "`カレンダー`の利用方法";

  @override
  String get globs => "*";

  @override
  String get directory => "docs/plugins";

  @override
  String get excerpt => "`カレンダー`は月別や週別のカレンダーのUIを表示するためのプラグイン。";

  @override
  String body(String baseName, String className) {
    return """
`カレンダー`は下記のように利用する。

## 概要

$excerpt

## 設定方法

### katana.yamlを使用する場合(推奨)

1. `katana.yaml`に下記の設定を追加。

    ```yaml
    # katana.yaml

    # Describe the settings for using the calendar.
    # カレンダーを利用するための設定を記述します。
    calendar:
      enable: true # カレンダーを利用する場合false -> trueに変更
    ```

2. 下記のコマンドを実行して設定を適用。

    ```bash
    katana apply
    ```

3. `lib/adapter.dart`の`masamuneAdapters`に`CalendarMasamuneAdapter`を追加。

    ```dart
    // lib/adapter.dart

    /// Masamune adapter.
    ///
    /// The Masamune framework plugin functions can be defined together.
    // TODO: Add the adapters.
    final masamuneAdapters = <MasamuneAdapter>[
        const UniversalMasamuneAdapter(),

        // カレンダーのアダプターを追加。
        // 週の開始曜日や週末の曜日を設定可能。
        const CalendarMasamuneAdapter(
          startingDayOfWeek: DayOfWeek.monday,
          weekendDays: [DayOfWeek.saturday, DayOfWeek.sunday],
        ),
    ];
    ```

### 手動でパッケージを追加する場合

1. パッケージをプロジェクトに追加。

    ```bash
    flutter pub add masamune_calendar
    ```

2. `lib/adapter.dart`の`masamuneAdapters`に`CalendarMasamuneAdapter`を追加。

    ```dart
    // lib/adapter.dart

    /// Masamune adapter.
    ///
    /// The Masamune framework plugin functions can be defined together.
    // TODO: Add the adapters.
    final masamuneAdapters = <MasamuneAdapter>[
        const UniversalMasamuneAdapter(),

        // カレンダーのアダプターを追加。
        // 週の開始曜日や週末の曜日を設定可能。
        const CalendarMasamuneAdapter(
          startingDayOfWeek: DayOfWeek.monday,
          weekendDays: [DayOfWeek.saturday, DayOfWeek.sunday],
        ),
    ];
    ```

## 利用方法

### 基本的な使い方

```dart
class MyCalendarPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    // カレンダーのコントローラーを取得。
    final controller = ref.page.controller(
      CalendarController.query(initialDay: DateTime.now()),
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Calendar")),
      body: Calendar(
        controller: controller,
        events: const [], // イベントリスト
        calendarStyle: CalendarStyle.monthView(),  // 月表示
      ),
    );
  }
}
```

### カレンダーの操作

```dart
// 日付を選択
controller.select(DateTime(2025, 1, 15));

// 次の月/週へ移動
controller.next();
controller.prev();

// 特定の日付にフォーカス（選択はせずに表示だけ変更）
controller.focus(DateTime(2025, 2, 1));

// 現在の選択日を取得
final selectedDate = controller.selectedDay;  // 選択されている日付

// 現在のフォーカス日を取得
final focusedDate = controller.focusedDay;   // 表示中の月/週
```

### ユーザーアクションへの反応

```dart
// カレンダーの変更を監視
controller.addListener(() {
  final selected = controller.selectedDay;
  if (selected != null) {
    print("User selected: \$selected");
    // この日付のイベントを読み込む、UIを更新する、など
  }
});
```

### 外観のカスタマイズ

#### デリゲートを使用したカスタマイズ

```dart
Calendar(
  controller: controller,
  events: const [],
  builderDelegate: BuilderCalendarDelegate(
    dayBuilder: (context, day, focusedDay) {
      // カスタム日付セルウィジェット
      return Container(
        decoration: BoxDecoration(
          color: day.weekday == DateTime.saturday ? Colors.blue : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(child: Text('\${day.day}')),
      );
    },
  ),
  markerDelegate: MarkerCalendarDelegate(
    markerBuilder: (context, day, events) {
      // イベントマーカーを追加
      if (events.isNotEmpty) {
        return Positioned(
          bottom: 1,
          child: Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
        );
      }
      return const SizedBox.shrink();
    },
  ),
)
```

#### スタイルを使用したカスタマイズ

```dart
Calendar(
  controller: controller,
  events: const [],
  calendarStyle: CalendarStyle.monthView().copyWith(
    selectedDayColor: Colors.blue,
    todayColor: Colors.orange,
    weekendTextStyle: TextStyle(color: Colors.red),
  ),
)
```

### カレンダー表示形式の切り替え

```dart
// 月表示
Calendar(
  controller: controller,
  events: const [],
  calendarStyle: CalendarStyle.monthView(),
)

// 週表示
Calendar(
  controller: controller,
  events: const [],
  calendarStyle: CalendarStyle.weekView(),
)

// 2週間表示
Calendar(
  controller: controller,
  events: const [],
  calendarStyle: CalendarStyle.twoWeekView(),
)
```
""";
  }
}
