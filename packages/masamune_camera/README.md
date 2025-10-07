<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Camera</h1>
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

# Masamune Camera

## Usage

### Installation

Add the package to your project.

```bash
flutter pub add masamune_camera
```

Run `flutter pub get` when editing `pubspec.yaml` manually.

### Register the Adapter

Choose the camera adapter that matches your target platform. `MobileCameraMasamuneAdapter` uses the `camera` plugin and `permission_handler` to manage permissions. For tests or unsupported platforms, use `MockCameraMasamuneAdapter`.

```dart
// lib/adapter.dart

/// Masamune adapters used in the application.
final masamuneAdapters = <MasamuneAdapter>[
  const UniversalMasamuneAdapter(),

  const MobileCameraMasamuneAdapter(
    defaultResolutionPreset: ResolutionPreset.high,
    defaultImageFormat: MediaFormat.jpg,
    enableAudio: true,
  ),
];
```

### Capture Photos

Use the `Camera` controller to handle camera interactions.

```dart
class MyCameraPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final camera = ref.page.controller(Camera.query());

    return Scaffold(
      appBar: AppBar(title: const Text("Camera")),
      body: Column(
        children: [
          // Camera preview
          Expanded(
            child: camera.initialized
                ? camera.preview
                : Center(child: CircularProgressIndicator()),
          ),
          
          // Capture button
          ElevatedButton(
            onPressed: () async {
              // Request permissions and initialize
              if (!camera.initialized) {
                final granted = await camera.requestPermission();
                if (!granted) {
                  // Handle permission denied
                  return;
                }
                await camera.initialize();
              }
              
              // Take a picture
              final photo = await camera.takePicture(
                width: 1920,
                height: 1080,
                format: MediaFormat.jpg,
              );
              
              if (photo != null) {
                debugPrint('Saved image: ${photo.path}');
                // Use the captured image
              }
            },
            child: const Text("Take Photo"),
          ),
        ],
      ),
    );
  }
}
```

### Video Recording

Record videos with start/stop controls:

```dart
// Start recording
await camera.startVideoRecording();

// Show recording indicator or timer UI...

// Stop and get the video file
final recording = await camera.stopVideoRecording();
if (recording != null) {
  debugPrint('Video path: ${recording.path}');
  debugPrint('Duration: ${recording.duration}');
  debugPrint('Format: ${recording.format}');
}
```

**Complete Video Example**:

```dart
ElevatedButton(
  onPressed: () async {
    if (camera.recording != null) {
      // Already recording - stop it
      final video = await camera.stopVideoRecording();
      print("Recorded: ${video?.path}");
    } else {
      // Start recording
      await camera.startVideoRecording();
    }
  },
  child: Text(camera.recording != null ? "Stop" : "Record"),
)
```

`CameraValue` includes metadata such as `path`, `duration`, `format`, and `bytes`.

### Permissions

The camera controller automatically requests permissions when needed. You can also manually request:

```dart
final granted = await camera.requestPermission(
  timeout: Duration(seconds: 60),  // Permission request timeout
);

if (!granted) {
  // User denied camera or microphone permission
  // Show explanation dialog or navigate to settings
  await openAppSettings();  // From permission_handler
}
```

`MobileCameraMasamuneAdapter` uses `permission_handler` internally. Override `requestCameraPermission` or `requestMicrophonePermission` in a custom adapter for different behavior.

### Mock Adapter for Tests

Use `MockCameraMasamuneAdapter` for deterministic results in tests or platforms without camera support:

```dart
// lib/adapter.dart (test version)

final masamuneAdapters = <MasamuneAdapter>[
  const UniversalMasamuneAdapter(),
  
  const MockCameraMasamuneAdapter(
    mockImagePath: 'assets/test_image.jpg',  // Path to mock image
  ),
];
```

The mock adapter returns predefined images/videos without accessing actual hardware, making tests fast and reliable.

### Cleanup

Always dispose of the camera controller when done:

```dart
@override
void dispose() {
  camera.disposeCamera();
  super.dispose();
}
```

Or let the Masamune controller lifecycle handle it automatically when using `ref.page.controller()`.

### Web Support

Web exports provide stub implementations that don't crash when called, but actual camera access is not available. Use the mock adapter or conditional imports for web builds.

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)