# `PeriodicScope`の利用方法

# PeriodicScope

## 概要

一定時間ごとに自動的に再描画を行うウィジェット。タイマーやカウントダウン、定期的な更新が必要なUIに最適。

## 特徴

- 指定した間隔で自動的に再描画
- 現在時刻を`DateTime`として提供
- メモリリークを防ぐための適切なタイマー管理
- シンプルなビルダーパターン
- カスタマイズ可能な更新間隔

## 基本的な使い方

### シンプルなタイマー表示

```dart
PeriodicScope(
  duration: const Duration(seconds: 1),
  builder: (context, now) {
    return Text(
      now.toString(),
      style: Theme.of(context).textTheme.headlineMedium,
    );
  },
);
```

## 実装例

### カウントダウンタイマー

```dart
final targetTime = Clock.now().add(Duration(minutes: 5));

PeriodicScope(
  duration: const Duration(seconds: 1),
  builder: (context, now) {
    final remaining = targetTime.difference(now);
    return Text(
      '${remaining.inMinutes}:${(remaining.inSeconds % 60).toString().padLeft(2, '0')}',
      style: Theme.of(context).textTheme.headlineLarge,
    );
  },
);
```

### 経過時間の表示

```dart
final startTime = Clock.now();

PeriodicScope(
  duration: const Duration(seconds: 1),
  builder: (context, now) {
    final elapsed = now.difference(startTime);
    return Text(
      '経過時間: ${elapsed.inMinutes}分${elapsed.inSeconds % 60}秒',
    );
  },
);
```

### アニメーションと組み合わせる

```dart
PeriodicScope(
  duration: const Duration(milliseconds: 100),
  builder: (context, now) {
    return Transform.rotate(
      angle: (now.millisecondsSinceEpoch / 1000) * pi,
      child: const Icon(
        Icons.refresh,
        size: 32,
      ),
    );
  },
);
```

### 定期的なデータ更新

```dart
PeriodicScope(
  duration: const Duration(minutes: 5),
  builder: (context, now) {
    return FutureBuilder(
      future: fetchLatestData(),  // データ取得の非同期処理
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text('最終更新: ${now.toString()}');
        }
        return const CircularProgressIndicator();
      },
    );
  },
);
```

## 注意点

- `duration`と`builder`は必須パラメータ
- ウィジェットが破棄されるときに自動的にタイマーをキャンセル（メモリリーク防止）
- 更新間隔は必要以上に短くしないことを推奨（パフォーマンスに影響する可能性あり）
- `builder`は指定した`duration`ごとに呼び出される
- `builder`には現在時刻が`DateTime`として提供される（`Clock.now()`を使用）
- 画面がバックグラウンドに移行してもタイマーは動作し続ける
- 内部では`Timer.periodic`を使用して定期的に`setState()`を呼び出している
- タイマーは`initState`で開始され、`dispose`で自動的にキャンセルされる

## 利用シーン

- タイマー
- カウントダウン
- 経過時間の表示
- アニメーション
- 定期的なデータ更新
