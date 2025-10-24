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

Register `AgoraMasamuneAdapter` before the app starts. You must supply:
- Agora credentials (`appId`, `customerId`, `customerSecret`)
- A `functionsAdapter` for token issuance from your backend
- (Optional) `storageBucketConfig` for cloud recording or screenshots

```dart
// lib/adapter.dart

/// Masamune adapter.
///
/// Collect all adapters used by the application.
final masamuneAdapters = <MasamuneAdapter>[
  const UniversalMasamuneAdapter(),

  AgoraMasamuneAdapter(
    appId: "YOUR_AGORA_APP_ID",                    // From https://console.agora.io/projects
    customerId: "YOUR_CUSTOMER_ID",                // From https://console.agora.io/restfulApi
    customerSecret: "YOUR_CUSTOMER_SECRET",        // From https://console.agora.io/restfulApi
    functionsAdapter: firebaseFunctionsMasamuneAdapter,
    storageBucketConfig: const AgoraStorageBucketConfig(
      vendor: AgoraStorageVendor.googleCloud,     // or aws, qiniu, etc.
      bucketName: "your-bucket",
      rootPath: "agora",                           // Folder in bucket
      accessKey: "GOOGLE_CLOUD_ACCESS_KEY",
      secretKey: "GOOGLE_CLOUD_SECRET_KEY",
    ),
    enableRecordingByDefault: true,                // Auto-start recording on connect
    enableScreenCaptureByDefault: true,            // Auto-capture screenshot on connect
    tokenExpirationTime: Duration(hours: 1),       // Token validity period
  ),
];
```

**Notes**:
- `functionsAdapter` must point to a backend capable of generating Agora RTC tokens (see next section)
- `storageBucketConfig` is required if you enable recording or screenshots
- Obtain credentials from the [Agora Console](https://console.agora.io/)

### Issue Tokens with Functions

Agora requires secure tokens for channel access. Your backend must implement token generation using Agora's server SDK.

**Client-side**: The package provides `AgoraTokenFunctionsAction` to request tokens:

```dart
// Typically called internally by AgoraController.connect()
final response = await adapter.functionsAdapter.execute(
  AgoraTokenFunctionsAction(
    channelName: "demo-channel",
    clientRole: AgoraClientRole.broadcaster,  // or AgoraClientRole.audience
    uid: 1001,                                 // Optional user ID
    expirationTime: Duration(hours: 1),       // Token validity
  ),
);
final token = response.token;
```

**Server-side**: Your backend function should:
1. Listen for the `agora_token` action
2. Generate an RTC token using Agora's token builder
3. Return a JSON map with the token

Example response format:
```json
{
  "token": "generated_agora_rtc_token_string"
}
```

Refer to [Agora Token Generation](https://docs.agora.io/en/video-calling/develop/authentication-workflow) for implementation details.

### Connect to Agora Channels

Use `AgoraController` as a Masamune controller to manage connections. Resolve the controller from a scope, call `connect`, and dispose with `disconnect` when finished.

```dart
final agora = ref.page.controller(
  AgoraController.query("demo-channel"),  // Specify channel name
);

await agora.connect(
  userName: "broadcaster-1",
  videoProfile: AgoraVideoProfile.size1280x720Rate30,
  clientRole: ClientRoleType.clientRoleBroadcaster,    // or clientRoleAudience
  channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
  enableAudio: true,                      // Start with audio enabled
  enableVideo: true,                      // Start with video enabled
  cameraDirection: CameraDirection.cameraFront,  // Front or rear camera
);

// Dynamically toggle audio/video during the session
agora.enableAudio = false;  // Mute microphone
agora.enableVideo = false;  // Turn off camera

// Switch between front and rear cameras
await agora.switchCamera();

// Mute/unmute remote audio streams
agora.mute = true;

// Disconnect when done
await agora.disconnect();
```

**Permissions**: `connect` automatically requests microphone and camera permissions using `AgoraPermission`. For manual control:

```dart
await agora.permission.request(
  video: true,
  audio: true,
);
```

### Display Local and Remote Video

`AgoraScreen` renders the video stream for a given `AgoraUser`. Access users from `AgoraController.value`.

```dart
Widget build(BuildContext context) {
  final users = agora.value;
  final local = users.firstWhereOrNull((user) => user.isLocalUser);
  
  return AgoraScreen(
    value: local,
    useFlutterTexture: true,      // Use Flutter's texture rendering
    useAndroidSurfaceView: false, // Use TextureView on Android (default)
  );
}
```

**Display Multiple Users**: To show all participants (local and remote), map over the users list:

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

### Cloud Recording and Screenshots

If `storageBucketConfig` is set in the adapter and recording is enabled, you can start/stop recording or capture screenshots programmatically.

**Recording**: Capture the entire session as a video file:

```dart
await agora.startRecording();

// Recording is in progress...
// Fetch the URL where the recording will be uploaded
final recordingUrl = agora.recordURL;

await agora.stopRecording();
```

**Screenshots**: Capture a single frame as an image:

```dart
await agora.startScreenCapture();

// Fetch the URL where the screenshot is uploaded
final screenshotUrl = agora.screenCaptureURL;

await agora.stopScreenCapture();
```

**Important**: Ensure that your configured cloud storage (Google Cloud Storage, AWS S3, etc.) accepts uploads from Agora Cloud Recording and that CORS rules allow playback if needed.

### Custom Video Source and Data Streams

**Custom Video Source**: Enable custom video input to push your own video frames instead of using the camera:

```dart
await agora.connect(
  userName: "presenter",
  enableCustomVideoSource: true,
);

// Push raw video frames (e.g., from a file or generated content)
await agora.pushCustomVideo(
  videoFrameBytes,               // Uint8List containing frame data
  VideoPixelFormat.videoPixelI420, // Pixel format
  1280,                           // Width
  720,                            // Height
);
```

**Data Streams**: Send and receive arbitrary data messages between participants:

```dart
await agora.connect(
  userName: "presenter",
  onReceivedDataStream: (streamId, from, data) {
    // Handle incoming data from remote users
    debugPrint("Message from ${from.name}: ${utf8.decode(data)}");
  },
);

// Send data messages to all participants
await agora.sendDataStream(
  Uint8List.fromList(utf8.encode("hello")),
);
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

The web implementation provides stub implementations so the API is callable without runtime errors or conditional imports. However, actual media streaming (video/audio) is not available in browsers. This allows you to write platform-agnostic code while targeting both mobile and web platforms.

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)