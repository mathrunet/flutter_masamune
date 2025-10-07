<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Picker</h1>
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

# Masamune Picker

## Usage

### Installation

Add the package to your project.

```bash
flutter pub add masamune_picker
```

Run `flutter pub get` when editing `pubspec.yaml` manually.

### Register the Adapter

`PickerMasamuneAdapter` integrates file selection, camera capture, and storage handling. Register it before runApp.

```dart
// lib/adapter.dart

/// Masamune adapters used in the application.
final masamuneAdapters = <MasamuneAdapter>[
  const UniversalMasamuneAdapter(),

  const PickerMasamuneAdapter(),
];
```

The adapter provides platform-specific implementations for mobile, desktop, and web, exporting storage utilities under `storage/`.

### Picker Controller

Use `Picker` to launch pickers and retrieve selected files.

```dart
final picker = ref.page.controller(Picker.query());

final image = await picker.pickSingle(type: PickerFileType.image);
debugPrint("Picked: ${image.path}");

final docs = await picker.pickMultiple(type: PickerFileType.custom(["pdf", "docx"]));
```

Access the last selected values via `picker.value` and listen for updates with standard Masamune controller patterns.

### Camera Capture

On supported platforms, `pickCamera()` opens the camera and returns a `PickerValue` for the captured media.

```dart
final photo = await picker.pickCamera(type: PickerFileType.image);
```

Ensure camera permissions are granted; the adapter throws `MasamunePickerPermissionDeniedException` if denied.

### Storage Helpers

The package exports storage helpers under `storage/`. Use them to persist picked files locally or upload them to cloud storage.

```dart
final storage = PickerStorage();
await storage.save(picker.value?.first, fileName: "upload.jpg");
```

### Tips

- Customize allowed file types with `PickerFileType` (any/image/video/audio/custom).
- Provide localized dialog titles via the `dialogTitle` parameter.
- Handle `picker.future` if you need to show loading indicators while selection is in progress.
- Combine with `MasamuneCamera` for advanced capture scenarios or with storage adapters for automatic uploads.

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)