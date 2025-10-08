# Agora

`Agora`は下記のように利用する。

## 概要

`Agora`は音声通話、ビデオ通話、クラウドレコーディング、スクリーンキャプチャ、データストリーム、カスタムビデオソースの機能を提供するプラグイン。Agora.io SDKを利用した高品質なリアルタイムコミュニケーションを実現。

## 設定方法

1. `katana.yaml`に下記の設定を追加。

    ```yaml
    # katana.yaml

    # Configure Agora.io streaming settings.
    # Agora.ioのストリーミング設定を行います。
    agora:
      # Set to `true` if you use Agora.io.
      # Agora.ioを利用する場合は`true`にしてください。
      enable: true # Agoraを利用する場合false -> trueに変更

      # AppID for Agora.
      # Log in to the following URL and create a project.
      # After the project is created, the AppID can be copied.
      # Agora用のAppID。
      # 下記URLにログインし、プロジェクトを作成します。
      # プロジェクト作成後、AppIDをコピーすることができます。
      # https://console.agora.io/projects
      app_id: # AgoraのAppIDを記載。

      # AppCertificate for Agora.
      # You can obtain the certificate after entering the project you created and activating it in Security -> App certificate.
      # Agora用のAppCertificate。
      # 作成したプロジェクトに入り、Security -> App certificateにて有効化した後取得できます。
      # https://console.agora.io/projects
      app_certificate: # AgoraのAppCertificateを記載。

      # Set to `true` to enable Agora cloud recording.
      # Agoraのクラウドレコーディングを有効にする場合は`true`にしてください。
      enable_cloud_recording: false

      # Set to `true` to enable Agora full screen sharing.
      # Agoraのフルスクリーン共有を有効にする場合は`true`にしてください。
      enable_fullscreen_sharing: false

      # Specify permission permission messages to use the camera and microphone in IOS.
      # IOSでカメラやマイクを利用するための権限許可メッセージを指定します。
      permission:
        camera:
          en: Use the camera for video chats. # 利用用途を言語ごとに記載。
          ja: ビデオチャットのためにカメラを利用します。 # 利用用途を言語ごとに記載。
        microphone:
          en: Use the microphone for video chats. # 利用用途を言語ごとに記載。
          ja: ビデオチャットのためにマイクを利用します。 # 利用用途を言語ごとに記載。
    ```

2. パッケージをプロジェクトに追加。

    ```bash
    flutter pub add masamune_agora
    ```

3. 下記のコマンドを実行して設定を適用。

    ```bash
    katana apply
    ```

4. `lib/adapter.dart`の`masamuneAdapters`に`AgoraMasamuneAdapter`を追加。Agora認証情報、トークン発行用のバックエンド、クラウド録画用のストレージ設定を指定。

    ```dart
    // lib/adapter.dart

    /// Masamune adapter.
    ///
    /// The Masamune framework plugin functions can be defined together.
    // TODO: Add the adapters.
    final masamuneAdapters = <MasamuneAdapter>[
        const UniversalMasamuneAdapter(),

        // Agoraのアダプターを追加。
        AgoraMasamuneAdapter(
          // AgoraのAppID。https://console.agora.io/projects から取得。
          appId: "YOUR_AGORA_APP_ID",
          // AgoraのカスタマーID。https://console.agora.io/restfulApi から取得。
          customerId: "YOUR_CUSTOMER_ID",
          // Agoraのカスタマーシークレット。https://console.agora.io/restfulApi から取得。
          customerSecret: "YOUR_CUSTOMER_SECRET",
          // トークン発行用のFunctionsアダプター（バックエンドでトークン生成が必要）
          functionsAdapter: firebaseFunctionsMasamuneAdapter,
          // クラウドレコーディングやスクリーンショット用のストレージ設定（オプション）
          storageBucketConfig: const AgoraStorageBucketConfig(
            vendor: AgoraStorageVendor.googleCloud,  // Google Cloud Storage、AWS S3など
            bucketName: "your-bucket",
            rootPath: "agora",                       // バケット内のフォルダパス
            accessKey: "GOOGLE_CLOUD_ACCESS_KEY",
            secretKey: "GOOGLE_CLOUD_SECRET_KEY",
          ),
          // デフォルトで接続時にクラウドレコーディングを開始する場合はtrue
          enableRecordingByDefault: true,
          // デフォルトで接続時にスクリーンキャプチャを開始する場合はtrue
          enableScreenCaptureByDefault: true,
          // トークンの有効期限（デフォルトは1時間）
          tokenExpirationTime: Duration(hours: 1),
        ),
    ];
    ```

    **Note**:
    - `functionsAdapter`はAgora RTCトークンを生成できるバックエンドを指す必要があります
    - `storageBucketConfig`はレコーディングやスクリーンショットを有効にする場合に必須です
    - 認証情報は[Agoraコンソール](https://console.agora.io/)から取得してください

## トークンの発行（Functions）

Agoraはチャンネルへの安全なアクセスのためにトークンが必要です。バックエンドでAgora Server SDKを使用してトークン生成を実装する必要があります。

**クライアント側**: パッケージは`AgoraTokenFunctionsAction`を提供してトークンをリクエストします:

```dart
// 通常はAgoraController.connect()内で自動的に呼び出されます
final response = await adapter.functionsAdapter.execute(
  AgoraTokenFunctionsAction(
    channelName: "demo-channel",
    clientRole: AgoraClientRole.broadcaster,  // または AgoraClientRole.audience
    uid: 1001,                                 // オプションのユーザーID
    expirationTime: Duration(hours: 1),       // トークンの有効期限
  ),
);
final token = response.token;
```

**サーバー側**: バックエンド関数は以下を実行する必要があります:
1. `agora_token`アクションをリッスン
2. AgoraのトークンビルダーでRTCトークンを生成
3. トークンを含むJSONマップを返す

レスポンスフォーマット例:
```json
{
  "token": "generated_agora_rtc_token_string"
}
```

実装の詳細は[Agoraトークン生成ドキュメント](https://docs.agora.io/en/video-calling/develop/authentication-workflow)を参照してください。

## 利用方法

### Agoraチャンネルへの接続

`AgoraController`をMasamuneコントローラーとして使用して接続を管理します。スコープからコントローラーを取得し、`connect`を呼び出し、終了時に`disconnect`で破棄します。

```dart
// チャンネル名を指定してコントローラーを取得
final agora = ref.page.controller(
  AgoraController.query("demo-channel"),
);

// チャンネルに接続
await agora.connect(
  userName: "broadcaster-1",
  videoProfile: AgoraVideoProfile.size1280x720Rate30,
  clientRole: ClientRoleType.clientRoleBroadcaster,    // または clientRoleAudience
  channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
  enableAudio: true,                      // 音声を有効にして開始
  enableVideo: true,                      // ビデオを有効にして開始
  cameraDirection: CameraDirection.cameraFront,  // フロントカメラまたはリアカメラ
);

// セッション中に音声/ビデオを動的に切り替え
agora.enableAudio = false;  // マイクをミュート
agora.enableVideo = false;  // カメラをオフ

// フロントカメラとリアカメラを切り替え
await agora.switchCamera();

// リモート音声ストリームをミュート/ミュート解除
agora.mute = true;

// 終了時に切断
await agora.disconnect();
```

**パーミッション**: `connect`は`AgoraPermission`を使用してマイクとカメラのパーミッションを自動的にリクエストします。手動制御の場合:

```dart
await agora.permission.request(
  video: true,
  audio: true,
);
```

### ローカルおよびリモートビデオの表示

`AgoraScreen`は指定された`AgoraUser`のビデオストリームをレンダリングします。`AgoraController.value`からユーザーにアクセスします。

```dart
Widget build(BuildContext context) {
  final users = agora.value;
  final local = users.firstWhereOrNull((user) => user.isLocalUser);

  return AgoraScreen(
    value: local,
    useFlutterTexture: true,      // Flutterのテクスチャレンダリングを使用
    useAndroidSurfaceView: false, // AndroidでTextureViewを使用（デフォルト）
  );
}
```

**複数ユーザーの表示**: すべての参加者（ローカルとリモート）を表示するには、ユーザーリストをマップします:

```dart
Widget build(BuildContext context) {
  final users = agora.value;

  return GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: 16 / 9,
    ),
    itemCount: users.length,
    itemBuilder: (context, index) {
      return AgoraScreen(
        value: users[index],
        useFlutterTexture: true,
      );
    },
  );
}
```

### クラウドレコーディングとスクリーンショット

アダプターに`storageBucketConfig`が設定されていてレコーディングが有効な場合、プログラムでレコーディングを開始/停止したり、スクリーンショットをキャプチャしたりできます。

**レコーディング**: セッション全体をビデオファイルとしてキャプチャ:

```dart
await agora.startRecording();

// レコーディング中...
// レコーディングがアップロードされるURLを取得
final recordingUrl = agora.recordURL;

await agora.stopRecording();
```

**スクリーンショット**: 単一フレームを画像としてキャプチャ:

```dart
await agora.startScreenCapture();

// スクリーンショットがアップロードされるURLを取得
final screenshotUrl = agora.screenCaptureURL;

await agora.stopScreenCapture();
```

**重要**: 設定したクラウドストレージ（Google Cloud Storage、AWS S3など）がAgora Cloud Recordingからのアップロードを受け入れ、必要に応じて再生を許可するCORSルールを持っていることを確認してください。

### カスタムビデオソースとデータストリーム

**カスタムビデオソース**: カメラの代わりに独自のビデオフレームをプッシュするためにカスタムビデオ入力を有効にします:

```dart
await agora.connect(
  userName: "presenter",
  enableCustomVideoSource: true,
);

// 生のビデオフレームをプッシュ（ファイルや生成コンテンツから）
await agora.pushCustomVideo(
  videoFrameBytes,               // フレームデータを含むUint8List
  VideoPixelFormat.videoPixelI420, // ピクセルフォーマット
  1280,                           // 幅
  720,                            // 高さ
);
```

**データストリーム**: 参加者間で任意のデータメッセージを送受信:

```dart
await agora.connect(
  userName: "presenter",
  onReceivedDataStream: (streamId, from, data) {
    // リモートユーザーからの受信データを処理
    debugPrint("Message from ${from.name}: ${utf8.decode(data)}");
  },
);

// すべての参加者にデータメッセージを送信
await agora.sendDataStream(
  Uint8List.fromList(utf8.encode("hello")),
);
```

### 音声録音

接続中にローカルで音声をファイルに録音します。

```dart
await agora.startAudioRecording(
  path.join(appDocDir.path, "session.aac"),
  sampleRate: AudioSampleRateType.audioSampleRate48000,
  quality: AudioRecordingQualityType.audioRecordingQualityHigh,
);

// ... 後で
await agora.stopAudioRecording();
```

## Web対応

Web実装はスタブ実装を提供するため、ランタイムエラーや条件付きインポートなしでAPIを呼び出すことができます。ただし、実際のメディアストリーミング（ビデオ/オーディオ）はブラウザでは利用できません。これにより、モバイルとWebの両方のプラットフォームをターゲットにしながら、プラットフォームに依存しないコードを書くことができます。
