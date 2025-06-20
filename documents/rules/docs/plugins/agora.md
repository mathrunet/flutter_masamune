# Agora

`Agora`は下記のように利用する。

## 概要

`Agora`は音声通話、ビデオ通話、音声ストリーミング、ビデオストリーミングの機能を提供するプラグイン。

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

        // Agoraのアダプターを追加。
        const AgoraMasamuneAdapter(),
    ];
    ```

## 利用方法

```dart
// Agoraのコントローラーを取得。
final agora = ref.app.controller(Agora.query());

// チャンネルに参加。
await agora.joinChannel(
  // チャンネル名。
  channelName: "test_channel",
  // ユーザーID。
  uid: 1234567890,
  // トークン。
  token: "your_token",
);

// ローカルのビデオを表示。
AgoraVideoView(
  // コントローラー。
  controller: agora,
  // 表示するユーザーのID。
  uid: 1234567890,
  // 表示モード。
  renderMode: AgoraVideoRenderMode.hidden,
);

// リモートのビデオを表示。
AgoraVideoView(
  // コントローラー。
  controller: agora,
  // 表示するユーザーのID。
  uid: 9876543210,
  // 表示モード。
  renderMode: AgoraVideoRenderMode.hidden,
);

// マイクをミュート。
await agora.muteLocalAudioStream(true);

// カメラをオフ。
await agora.muteLocalVideoStream(true);

// スピーカーをミュート。
await agora.muteAllRemoteAudioStreams(true);

// リモートのビデオをオフ。
await agora.muteAllRemoteVideoStreams(true);

// チャンネルから退出。
await agora.leaveChannel();

// クラウドレコーディングを開始。
final recording = await agora.startCloudRecording(
  // チャンネル名。
  channelName: "test_channel",
  // ユーザーID。
  uid: 1234567890,
  // トークン。
  token: "your_token",
  // 保存先のバケット名。
  storageConfig: AgoraCloudStorageConfig(
    // バケット名。
    bucket: "your_bucket",
    // アクセスキー。
    accessKey: "your_access_key",
    // シークレットキー。
    secretKey: "your_secret_key",
  ),
);

// クラウドレコーディングを停止。
await agora.stopCloudRecording(recording);

// 画面共有を開始。
await agora.startScreenSharing();

// 画面共有を停止。
await agora.stopScreenSharing();
```
