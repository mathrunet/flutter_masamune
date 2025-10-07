<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Agora</h1>
</p>

<p align="center">
  <a href="https://github.com/mathrunet">
    <img src="https://img.shields.io/static/v1?label=GitHub&message=Follow&logo=GitHub&color=333333&link=https://github.com/mathrunet" alt="Follow on GitHub" />
  </a>
  <a href="https://x.com/mathru">
    <img src="https://img.shields.io/static/v1?label=@mathru&message=Follow&logo=X&color=0F1419&link=https://x.com/mathru" alt="Follow on X" />
  </a>
  <a href="https://www.youtube.com/c/mathrunetchannel">
    <img src="https://img.shields.io/static/v1?label=YouTube&message=Follow&logo=YouTube&color=FF0000&link=https://www.youtube.com/c/mathrunetchannel" alt="Follow on YouTube" />
  </a>
  <a href="https://github.com/invertase/melos">
    <img src="https://img.shields.io/static/v1?label=maintained%20with&message=melos&color=FF1493&link=https://github.com/invertase/melos" alt="Maintained with Melos" />
  </a>
</p>

<p align="center">
  <a href="https://github.com/sponsors/mathrunet"><img src="https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=ff69b4&link=https://github.com/sponsors/mathrunet" alt="GitHub Sponsor" /></a>
</p>

---

[[GitHub]](https://github.com/mathrunet) | [[YouTube]](https://www.youtube.com/c/mathrunetchannel) | [[Packages]](https://pub.dev/publishers/mathru.net/packages) | [[X]](https://x.com/mathru) | [[LinkedIn]](https://www.linkedin.com/in/mathrunet/) | [[mathru.net]](https://mathru.net)

---

# Masamune Agora

## Usage

### Installation

Add the package to your project.

```bash
flutter pub add masamune_agora
```

Run `flutter pub get` if you edit `pubspec.yaml` manually.

### Register the Adapter

Register `AgoraMasamuneAdapter` before the app starts. You must supply Agora credentials, a Functions adapter for token issuance, and optionally storage settings for cloud recording or screenshots.

```dart
// lib/adapter.dart

/// Masamune adapter.
///
/// Collect all adapters used by the application.
final masamuneAdapters = <MasamuneAdapter>[
  const UniversalMasamuneAdapter(),

  AgoraMasamuneAdapter(
    appId: "YOUR_AGORA_APP_ID",
    customerId: "YOUR_CUSTOMER_ID",
    customerSecret: "YOUR_CUSTOMER_SECRET",
    functionsAdapter: firebaseFunctionsMasamuneAdapter,
    storageBucketConfig: const AgoraStorageBucketConfig(
      vendor: AgoraStorageVendor.googleCloud,
      bucketName: "your-bucket",
      rootPath: "agora",
      accessKey: "GOOGLE_CLOUD_ACCESS_KEY",
      secretKey: "GOOGLE_CLOUD_SECRET_KEY",
    ),
    enableRecordingByDefault: true,
    enableScreenCaptureByDefault: true,
  ),
];
```

`functionsAdapter` must point to an adapter capable of invoking a backend that returns Agora tokens. When cloud recording or screenshots are enabled, provide `storageBucketConfig` and ensure the target cloud storage and authentication are configured.

### Issue Tokens with Functions

On the server side, respond to the `agora_token` action. The package provides `AgoraTokenFunctionsAction`, which sends the channel name, role, and expiration time.

```dart
// Client-side invocation example
final response = await adapter.functionsAdapter.execute(
  AgoraTokenFunctionsAction(
    channelName: "demo-channel",
    clientRole: AgoraClientRole.broadcaster,
    uid: 1001,
  ),
);
final token = response.token;
```

Your backend should return a JSON map containing the generated token string.

### Connect to Agora Channels

Use `AgoraController` as a Masamune controller to manage connections. Resolve the controller from a scope, call `connect`, and dispose with `disconnect` when finished.

```dart
final agora = ref.page.controller(
  AgoraController.query("demo-channel"),
);

await agora.connect(
  userName: "broadcaster-1",
  videoProfile: AgoraVideoProfile.size1280x720Rate30,
  clientRole: ClientRoleType.clientRoleBroadcaster,
  channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
);

// Update state with camera / microphone toggles.
agora.enableAudio = true;
agora.enableVideo = true;

// Switch camera or mute remote streams.
agora.switchCamera();
agora.mute = false;

await agora.disconnect();
```

`connect` automatically requests microphone / camera permissions using `AgoraPermission`. You can also call `agora.permission.request(...)` directly if you need finer control.

### Display Local and Remote Video

`AgoraScreen` renders the video stream for a given `AgoraUser`. Access users from `AgoraController.value`.

```dart
Widget build(BuildContext context) {
  final users = agora.value;
  final local = users?.firstWhere((user) => user.isLocalUser, orElse: () => null);
  return AgoraScreen(
    value: local,
    useFlutterTexture: true,
    useAndroidSurfaceView: false,
  );
}
```

Display multiple remote users by mapping over the controller value and creating a grid of `AgoraScreen` widgets.

### Cloud Recording and Screenshots

If `storageBucketConfig` is set and recording is enabled, you can start recording or capture screenshots programmatically.

```dart
await agora.startRecording();
await agora.startScreenCapture();

// Fetch URLs where the assets are uploaded.
final recordingUrl = agora.recordURL;
final screenshotUrl = agora.screenCaptureURL;

await agora.stopScreenCapture();
await agora.stopRecording();
```

Ensure that the configured cloud storage can accept uploads from Agora Cloud Recording and that CORS rules allow playback.

### Custom Video Source and Data Streams

Enable custom video input or data streams when connecting.

```dart
await agora.connect(
  userName: "presenter",
  enableCustomVideoSource: true,
  onReceivedDataStream: (streamId, from, data) {
    debugPrint("Message from ${from.name}: ${utf8.decode(data)}");
  },
);

// Push raw frames when using a custom source.
await agora.pushCustomVideo(bytes, VideoPixelFormat.videoPixelI420, 1280, 720);

// Send data messages.
await agora.sendDataStream(Uint8List.fromList("hello".codeUnits));
```

### Audio Recording

Record audio locally to a file while connected.

```dart
await agora.startAudioRecording(
  path.join(appDocDir.path, "session.aac"),
  sampleRate: AudioSampleRateType.audioSampleRate48000,
  quality: AudioRecordingQualityType.audioRecordingQualityHigh,
);

// ... later
await agora.stopAudioRecording();
```

### Web Support

The web implementation provides stubs so the API is callable without runtime errors, but actual media streaming is not available in browsers.

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)