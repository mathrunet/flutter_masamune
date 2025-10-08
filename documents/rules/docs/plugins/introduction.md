# チュートリアル

`チュートリアル`は下記のように利用する。

## 概要

`チュートリアル`はアプリ起動時にアプリの説明を行うためのプラグイン。

## 設定方法

### katana.yamlを使用する場合(推奨)

1. `katana.yaml`に下記の設定を追加。

    ```yaml
    # katana.yaml

    # Describe the settings for using the introductory part of the application.
    # アプリの導入部分を利用するための設定を記述します。
    introduction:
      enable: true # チュートリアルを利用する場合false -> trueに変更
    ```

2. 下記のコマンドを実行して設定を適用。

    ```bash
    katana apply
    ```

3. `lib/adapter.dart`の`masamuneAdapters`に`IntroductionMasamuneAdapter`を追加。

    ```dart
    // lib/adapter.dart

    /// Masamune adapter.
    ///
    /// The Masamune framework plugin functions can be defined together.
    // TODO: Add the adapters.
    final masamuneAdapters = <MasamuneAdapter>[
        const UniversalMasamuneAdapter(),

        // チュートリアルのアダプターを追加。
        // デフォルトのイントロダクションスライドを設定。
        IntroductionMasamuneAdapter(
          items: const [
            IntroductionItem(
              title: LocalizedValue("ようこそ"),
              body: LocalizedValue("このアプリの機能を紹介します。"),
              image: AssetImage("assets/images/tutorial_1.png"),
            ),
            IntroductionItem(
              title: LocalizedValue("整理整頓"),
              body: LocalizedValue("タスクを簡単に管理できます。"),
              image: AssetImage("assets/images/tutorial_2.png"),
            ),
          ],
        ),
    ];
    ```

### 手動でパッケージを追加する場合

1. パッケージをプロジェクトに追加。

    ```bash
    flutter pub add masamune_introduction
    ```

2. `lib/adapter.dart`の`masamuneAdapters`に`IntroductionMasamuneAdapter`を追加。

    ```dart
    // lib/adapter.dart

    /// Masamune adapter.
    ///
    /// The Masamune framework plugin functions can be defined together.
    // TODO: Add the adapters.
    final masamuneAdapters = <MasamuneAdapter>[
        const UniversalMasamuneAdapter(),

        // チュートリアルのアダプターを追加。
        // デフォルトのイントロダクションスライドを設定。
        IntroductionMasamuneAdapter(
          items: const [
            IntroductionItem(
              title: LocalizedValue("ようこそ"),
              body: LocalizedValue("このアプリの機能を紹介します。"),
              image: AssetImage("assets/images/tutorial_1.png"),
            ),
            IntroductionItem(
              title: LocalizedValue("整理整頓"),
              body: LocalizedValue("タスクを簡単に管理できます。"),
              image: AssetImage("assets/images/tutorial_2.png"),
            ),
          ],
        ),
    ];
    ```

`IntroductionMasamuneAdapter.primary`で、設定したアイテムに実行時にアクセスできます。

## 利用方法

### ウィジェットとして表示

`MasamuneIntroduction`をウィジェットツリーに直接埋め込みます。色、ボタンラベル、ナビゲーションをカスタマイズできます。

```dart
class OnboardingPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    return Scaffold(
      body: MasamuneIntroduction(
        enableSkip: true,                              // スキップボタンを表示
        activeColor: Theme.of(context).primaryColor,   // インジケーター色
        doneLabel: LocalizedValue("始める"),            // 完了ボタンテキスト
        skipLabel: LocalizedValue("スキップ"),          // スキップボタンテキスト
        routeQuery: HomePage.query(),                  // 完了時の遷移先
      ),
    );
  }
}
```

### ページとして使用

`MasamuneIntroductionPage`はルーティングサポート付きの事前構築済み`PageScopedWidget`です。ルーターでプッシュできます:

```dart
// イントロダクションページへ遷移
context.router.push(MasamuneIntroductionPage.query());

// 完了後の遷移先を指定して遷移
context.router.push(
  MasamuneIntroductionPage.query(
    routeQuery: HomePage.query(),  // 「完了」タップ時の遷移先
  ),
);
```

### スライドのカスタマイズ

#### 外観のカスタマイズ

```dart
IntroductionItem(
  title: LocalizedValue("ようこそ"),
  body: LocalizedValue("アプリを始めましょう"),
  image: AssetImage("assets/intro_1.png"),
  background: Colors.blue.shade50,           // スライドの背景色
  foregroundColor: Colors.black87,           // テキスト色
  imageDecoration: BoxDecoration(            // 画像のスタイル
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 10,
        offset: Offset(0, 4),
      ),
    ],
  ),
)
```

#### ボタンのカスタマイズ

```dart
MasamuneIntroduction(
  enableSkip: true,
  doneLabel: LocalizedValue("始める"),
  skipLabel: LocalizedValue("スキップ"),
  nextLabel: LocalizedValue("次へ"),
  activeColor: Colors.purple,                // アクティブなインジケーター色
  inactiveColor: Colors.grey,                // 非アクティブなインジケーター色
  buttonStyle: ElevatedButton.styleFrom(
    backgroundColor: Colors.purple,
    foregroundColor: Colors.white,
  ),
)
```

### 初回起動時のみ表示

初回アプリ起動時のみイントロダクションを表示:

```dart
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isFirstLaunch(),
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          return MasamuneIntroductionPage(
            routeQuery: HomePage.query(),
          );
        }
        return HomePage();
      },
    );
  }

  Future<bool> _isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirst = prefs.getBool('first_launch') ?? true;
    if (isFirst) {
      await prefs.setBool('first_launch', false);
    }
    return isFirst;
  }
}
```

### Tips

- フィーチャーフラグやリモート設定を使用してイントロダクションの表示を制御できます。
- `SharedPreferences`と組み合わせて完了状態を記憶します。
- ナビゲーションイベントをリッスンして分析トラッキングを追加できます。
- 動画コンテンツには、カスタムスライドで`video_player`の使用を検討してください。
