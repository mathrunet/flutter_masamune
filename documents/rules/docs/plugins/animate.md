# アニメーション

`アニメーション`は下記のように利用する。

## 概要

`アニメーション`はシナリオベースのアニメーションを構築できるプラグイン。`AnimateScope`と`AnimateController`を使用して、フェードイン/アウト、移動、回転、スケール、カラーフィルターなどのアニメーションフローを作成。

## 設定方法

1. `katana.yaml`に下記の設定を追加。

    ```yaml
    # katana.yaml

    # Describes settings for implementing animation.
    # アニメーションを実装するための設定を記述します。
    animate:
      enable: true # アニメーションを利用する場合false -> trueに変更
    ```

2. パッケージをプロジェクトに追加。

    ```bash
    flutter pub add masamune_animate
    ```

3. 下記のコマンドを実行して設定を適用。

    ```bash
    katana apply
    ```

4. `lib/adapter.dart`の`masamuneAdapters`に`AnimateMasamuneAdapter`を追加。テストタイムアウトを設定可能。

    ```dart
    // lib/adapter.dart

    /// Masamune adapter.
    ///
    /// The Masamune framework plugin functions can be defined together.
    // TODO: Add the adapters.
    final masamuneAdapters = <MasamuneAdapter>[
        const UniversalMasamuneAdapter(),

        // アニメーションのアダプターを追加。
        const AnimateMasamuneAdapter(
          timeoutDurationOnTest: Duration(milliseconds: 300),  // テストモードでのタイムアウト時間
        ),
    ];
    ```

## コアAPI

- **AnimateScope**: アニメーションを再生するためのウィジェット
- **AnimateController**: アニメーションを制御するコントローラー
- **AnimateRunner**: アニメーションシナリオを構築するためのインターフェース

`AnimateScope`は`controller`または`scenario`コールバックのいずれかが必要です。`autoPlay`、`repeat`、`repeatCount`、`keys`でアニメーションの再生タイミングやウィジェットの再ビルドを制御します。

## 利用方法

### オプション1: AnimateControllerを使用（再利用可能なシナリオに推奨）

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // シナリオを持つコントローラーを作成
    final controller = AnimateController(
      autoPlay: true,
      scenario: (runner) async {
        await runner.fadeIn(duration: const Duration(milliseconds: 300));
        await runner.wait(const Duration(milliseconds: 200));
        await runner.moveY(
          duration: const Duration(milliseconds: 500),
          begin: -20,
          end: 0,
          curve: Curves.easeOut,
        );
      },
    );

    return AnimateScope(
      controller: controller,
      child: const Text("Masamune Animate"),
    );
  }
}
```

### オプション2: インラインシナリオを使用（シンプルな1回限りのアニメーション用）

```dart
Widget build(BuildContext context) {
  return AnimateScope(
    autoPlay: true,
    scenario: (runner) async {
      await runner.fadeIn(duration: const Duration(milliseconds: 300));
      await runner.moveX(
        duration: const Duration(milliseconds: 500),
        begin: -50,
        end: 0,
      );
    },
    child: const Text("Hello World"),
  );
}
```

### オプション3: 手動再生制御

```dart
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> with TickerProviderStateMixin {
  late final AnimateController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimateController(
      scenario: (runner) async {
        await runner.fadeIn(duration: const Duration(milliseconds: 300));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimateScope(
          controller: controller,
          child: const Text("Animated Text"),
        ),
        ElevatedButton(
          onPressed: () => controller.play(),  // 手動トリガー
          child: const Text("Play Animation"),
        ),
      ],
    );
  }
}
```

## 組み込みアニメーションクエリ

`AnimateRunner`のエクステンションとして以下のヘルパーが定義されており、`await`で順次呼び出してシナリオを構築できます:

- **不透明度**: `opacity`、`fadeIn`、`fadeOut`
- **移動**: `move`、`moveX`、`moveY`
- **回転**: `rotate`
- **スケール**: `scale`、`scaleX`、`scaleY`、`scaleXY`
- **カラーフィルター**: `color`
- **カスタム値**: `custom`
- **遅延**: `wait`

各ヘルパーは`duration`、`begin`、`end`、`curve`などのパラメータをサポートしています。

### 使用例

```dart
// フェードインとY軸移動を組み合わせる
scenario: (runner) async {
  await runner.fadeIn(duration: const Duration(milliseconds: 300));
  await runner.moveY(
    duration: const Duration(milliseconds: 500),
    begin: -20,
    end: 0,
    curve: Curves.easeOut,
  );
}

// 回転とスケールを組み合わせる
scenario: (runner) async {
  await runner.rotate(
    duration: const Duration(milliseconds: 500),
    begin: 0,
    end: 3.14159,  // 180度回転
  );
  await runner.scaleXY(
    duration: const Duration(milliseconds: 300),
    begin: 0.5,
    end: 1.0,
  );
}

// カラーフィルターを適用
scenario: (runner) async {
  await runner.color(
    duration: const Duration(milliseconds: 500),
    begin: Colors.transparent,
    end: Colors.blue.withOpacity(0.5),
  );
}
```

## テストに関するヒント

- テストモード（`AnimateMasamuneAdapter.isTest == true`）では、リピート再生が無効化され、`TickerMode`が`false`に設定されて不要なフレームを回避します
- シナリオ内の`wait`は設定された`timeoutDurationOnTest`内に収めてテストのハングを防ぎます

## Web対応

パッケージはWebプラットフォームでも動作し、ブラウザでもアニメーションを実行できます。
