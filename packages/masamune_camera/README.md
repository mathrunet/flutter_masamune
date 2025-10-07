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

### Capture Media with `Camera`

Use the `Camera` controller (from this package) to handle camera interactions.

```dart
final camera = ref.page.controller(Camera.query());

await camera.initialize();

final photo = await camera.takePicture();
if (photo != null) {
  debugPrint('Saved image: ${photo.path}');
}

await camera.disposeCamera();
```

The controller wraps permission requests, camera initialization, preview control, and media capture. Use `camera.preview` widget to render the live feed.

### Video Recording

```dart
await camera.startVideoRecording();

// ... wait or show UI ...

final recording = await camera.stopVideoRecording();
if (recording != null) {
  debugPrint('Video path: ${recording.path}');
}
```

`CameraValue` includes metadata such as duration and file type. Adjust defaults via adapter configuration.

### Permissions

`MobileCameraMasamuneAdapter` uses `permission_handler` to request camera and microphone access with a default timeout of 60 seconds. Override `requestCameraPermission` / `requestMicrophonePermission` in a custom adapter if you need different behavior.

### Mock Adapter for Tests

Use `MockCameraMasamuneAdapter` when you want deterministic results in widget tests or desktop/web builds without camera access.

```dart
const mockAdapter = MockCameraMasamuneAdapter(
  mockImagePath: 'assets/mock_image.jpg',
);
```

Register it in your adapter list or swap it in via dependency injection during tests.

### Web Support

Web exports provide a no-op implementation so that calling camera APIs does not crash. Actual media capture requires platform-specific support.

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)