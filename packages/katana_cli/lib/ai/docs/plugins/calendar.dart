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

3. `lib/adapter.dart`の`masamuneAdapters`に`MasamuneAdapter`を追加。

    ```dart
    // lib/adapter.dart

    /// Masamune adapter.
    ///
    /// The Masamune framework plugin functions can be defined together.
    // TODO: Add the adapters.
    final masamuneAdapters = <MasamuneAdapter>[
        const UniversalMasamuneAdapter(),

        // カレンダーのアダプターを追加。
        const CalendarMasamuneAdapter(),
    ];
    ```

## 利用方法

```dart
// カレンダーのコントローラーを取得。
final calendar = ref.app.controller(Calendar.query());

// カレンダーを表示。
CalendarView(
  // カレンダーのコントローラー。
  controller: calendar,
  // カレンダーの種類（月別・週別）。
  type: CalendarType.month,
  // 日付が選択された時の処理。
  onDateSelected: (date) {
    print("Selected date: \$date");
  },
  // イベントを表示するための処理。
  eventBuilder: (date) {
    return [
      CalendarEvent(
        title: "イベント1",
        description: "イベント1の説明",
        startTime: date,
        endTime: date.add(const Duration(hours: 1)),
      ),
    ];
  },
);
```
""";
  }
}
