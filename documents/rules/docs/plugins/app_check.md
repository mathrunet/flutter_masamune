# Firebase App Check

`Firebase App Check`は下記のように利用する。

## 概要

`Firebase App Check`はアプリの正当性を検証し、不正なトラフィックからFirebaseリソースを保護するセキュリティ機能。

Firebase App CheckはFirebaseサービス(Firestore、Cloud Functions、Storage等)へのアクセスを保護し、正規のアプリからのリクエストのみを許可します。

## 設定方法

### katana.yamlを使用する場合(推奨)

1. `katana.yaml`に下記の設定を追加。

    ```yaml
    # katana.yaml

    # Enable Firebase App Check.
    # Firebase App Checkを有効にします。
    app_check:
      enable: true # Firebase App Checkを利用する場合false -> trueに変更
    ```

2. 下記のコマンドを実行して設定を適用。

    ```bash
    katana apply
    ```

3. `lib/adapter.dart`の`masamuneAdapters`に`FirebaseAppCheckMasamuneAdapter`を追加。

    ```dart
    // lib/adapter.dart

    import 'package:masamune_firebase_app_check/masamune_firebase_app_check.dart';

    /// Masamune adapter.
    ///
    /// The Masamune framework plugin functions can be defined together.
    // TODO: Add the adapters.
    final masamuneAdapters = <MasamuneAdapter>[
        const UniversalMasamuneAdapter(),

        // Firebase App Checkのアダプターを追加
        FirebaseAppCheckMasamuneAdapter(
          options: DefaultFirebaseOptions.currentPlatform,                  // Firebase設定
          activateTiming: FirebaseAppCheckActivateTiming.onPreRunApp,      // アクティブ化タイミング
          androidProvider: FirebaseAppCheckAndroidProvider.playIntegrity,  // Android用プロバイダー
          iosProvider: FirebaseAppCheckIOSProvider.deviceCheck,            // iOS用プロバイダー
        ),
    ];
    ```

### 手動でパッケージを追加する場合

1. パッケージをプロジェクトに追加。

    ```bash
    flutter pub add masamune_firebase_app_check
    ```

2. `lib/adapter.dart`の`masamuneAdapters`に`FirebaseAppCheckMasamuneAdapter`を追加。

    ```dart
    // lib/adapter.dart

    import 'package:masamune_firebase_app_check/masamune_firebase_app_check.dart';

    /// Masamune adapter.
    ///
    /// The Masamune framework plugin functions can be defined together.
    // TODO: Add the adapters.
    final masamuneAdapters = <MasamuneAdapter>[
        const UniversalMasamuneAdapter(),

        // Firebase App Checkのアダプターを追加
        FirebaseAppCheckMasamuneAdapter(
          options: DefaultFirebaseOptions.currentPlatform,                  // Firebase設定
          activateTiming: FirebaseAppCheckActivateTiming.onPreRunApp,      // アクティブ化タイミング
          androidProvider: FirebaseAppCheckAndroidProvider.playIntegrity,  // Android用プロバイダー
          iosProvider: FirebaseAppCheckIOSProvider.deviceCheck,            // iOS用プロバイダー
        ),
    ];
    ```

## アクティブ化タイミング

`activateTiming`パラメータで`FirebaseAppCheck.activate()`を実行するタイミングを制御:

| タイミング | 説明 |
|--------|-------------|
| `onPreRunApp` (デフォルト) | `runApp()`が呼ばれる前にアクティブ化 |
| `onBoot` | `onMaybeBoot()`ライフサイクル中にアクティブ化 |

```dart
FirebaseAppCheckMasamuneAdapter(
  options: DefaultFirebaseOptions.currentPlatform,
  activateTiming: FirebaseAppCheckActivateTiming.onPreRunApp,  // 推奨
)
```

アダプターは提供されたオプションで`Firebase.initializeApp`を自動的に呼び出してからApp Checkをアクティブ化します。

## プロバイダー設定

各プラットフォームに適したプロバイダーを選択:

### Androidプロバイダー

- `playIntegrity` (推奨): 本番環境用のGoogle Play Integrity API
- `debug`: 開発・テスト用
- `platformDependent`: ビルドモードに応じて自動選択

### iOS/macOSプロバイダー

- `deviceCheck` (推奨): AppleのDeviceCheck API
- `appAttest`: より高度な認証(iOS 14+)
- `debug`: 開発・テスト用
- `platformDependent`: ビルドモードに応じて自動選択

```dart
// 本番環境の設定
FirebaseAppCheckMasamuneAdapter(
  options: DefaultFirebaseOptions.currentPlatform,
  androidProvider: FirebaseAppCheckAndroidProvider.playIntegrity,
  iosProvider: FirebaseAppCheckIOSProvider.deviceCheck,
)

// 開発環境の設定
// FirebaseAppCheckMasamuneAdapter(
//   options: DefaultFirebaseOptions.currentPlatform,
//   androidProvider: FirebaseAppCheckAndroidProvider.debug,
//   iosProvider: FirebaseAppCheckIOSProvider.debug,
// )
```

## プラットフォーム別の設定

プラットフォームごとに異なるFirebaseオプションを指定する場合:

```dart
FirebaseAppCheckMasamuneAdapter(
  options: DefaultFirebaseOptions.currentPlatform,
  iosOptions: DefaultFirebaseOptions.ios,          // iOS専用設定
  androidOptions: DefaultFirebaseOptions.android,  // Android専用設定
  androidProvider: FirebaseAppCheckAndroidProvider.playIntegrity,
  iosProvider: FirebaseAppCheckIOSProvider.appAttest,
)
```

## アダプターへのアクセス

App Check機能に手動でアクセスする場合:

```dart
final adapter = FirebaseAppCheckMasamuneAdapter.primary;

// FirebaseAppCheckインスタンスにアクセス
final appCheck = adapter.appCheck;

// 現在のApp Checkトークンを取得
final token = await appCheck.getToken();
print("App Checkトークン: $token");

// 限定使用トークンを取得
final limitedUseToken = await appCheck.getLimitedUseToken();
```

## Firebase Console設定

1. **Firebase Consoleでの設定**:
   - Firebase プロジェクトでApp Checkを有効化
   - 各プラットフォーム(iOS、Android、Web)でアプリを登録
   - 各プラットフォームに適切なプロバイダーを設定

2. **Android (Play Integrity)**:
   - Google Play ConsoleでPlay Integrityを有効化
   - Firebase ConsoleにPlay Integrity APIキーを追加

3. **iOS (DeviceCheck/App Attest)**:
   - Apple Developer AccountでDeviceCheckを有効化
   - Firebase ConsoleにApple Team IDを登録

## デバッグモード

開発中はデバッグプロバイダーを使用:

```dart
// 開発環境用の設定
FirebaseAppCheckMasamuneAdapter(
  options: DefaultFirebaseOptions.currentPlatform,
  androidProvider: FirebaseAppCheckAndroidProvider.debug,
  iosProvider: FirebaseAppCheckIOSProvider.debug,
)
```

デバッグトークンをFirebase Consoleに登録:

1. デバッグモードでアプリを実行
2. ログからデバッグトークンをコピー
3. Firebase Console → App Check → アプリ → デバッグトークンに追加

## Web設定

Web対応には`webOptions`とreCAPTCHA v3を設定:

```dart
FirebaseAppCheckMasamuneAdapter(
  options: DefaultFirebaseOptions.currentPlatform,
  webOptions: DefaultFirebaseOptions.web,
  webRecaptchaSiteKey: "YOUR_RECAPTCHA_SITE_KEY",  // reCAPTCHA v3サイトキー
)
```

## トラブルシューティング

### エラー: App Check verification failed

**原因**: プロバイダーが正しく設定されていない、またはデバッグトークンが登録されていない

**解決方法**:
1. Firebase Consoleでプロバイダー設定を確認
2. デバッグモードの場合、デバッグトークンを登録
3. 本番環境の場合、Play IntegrityやDeviceCheckが有効か確認

### エラー: Firebase not initialized

**原因**: Firebaseの初期化前にApp Checkが実行された

**解決方法**:
```dart
// activateTimingをonPreRunAppに設定(デフォルト)
FirebaseAppCheckMasamuneAdapter(
  options: DefaultFirebaseOptions.currentPlatform,
  activateTiming: FirebaseAppCheckActivateTiming.onPreRunApp,
)
```

### Firebase サービスとの連携

App CheckはFirebaseの以下のサービスを保護します:

- Cloud Firestore
- Cloud Functions
- Cloud Storage
- Realtime Database
- Firebase ML

各サービスでApp Checkを有効にするには、Firebase Consoleで個別に設定が必要です。

### Tips

- 本番環境では必ずPlay Integrity(Android)とDeviceCheck/App Attest(iOS)を使用
- デバッグトークンは開発・テスト環境のみで使用
- App Checkを有効にすると、認証されていないリクエストは拒否される
- 段階的な展開: 最初は`unenforced`モードで監視し、問題なければ`enforced`に切り替え
- トークンの自動更新は内部で処理されるため手動更新は不要
- Web版では必ずreCAPTCHA v3サイトキーを設定
