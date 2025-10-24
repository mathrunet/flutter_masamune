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

### Basic Usage

Use the `Picker` controller to select files or capture from camera.

**Pick a Single Image**:

```dart
class MyPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final picker = ref.page.controller(Picker.query());

    return ElevatedButton(
      onPressed: () async {
        final image = await picker.pickSingle(
          type: PickerFileType.image,
          dialogTitle: "Select an image",
        );
        
        if (image != null) {
          print("Selected: ${image.path}");
          print("Size: ${image.bytes?.length} bytes");
        }
      },
      child: const Text("Pick Image"),
    );
  }
}
```

**Pick Multiple Files**:

```dart
final files = await picker.pickMultiple(
  type: PickerFileType.custom(["pdf", "docx", "txt"]),
  dialogTitle: "Select documents",
);

for (final file in files) {
  print("File: ${file.name}, Size: ${file.bytes?.length}");
}
```

**Access Last Selection**:

```dart
// Access the last selected files
final lastFiles = picker.value;
if (lastFiles != null && lastFiles.isNotEmpty) {
  print("Last picked: ${lastFiles.first.name}");
}

// Listen for changes
picker.addListener(() {
  final files = picker.value;
  // Update UI with selected files
});
```

### Camera Capture

On supported platforms, capture photos or videos directly from the camera:

```dart
// Capture a photo
final photo = await picker.pickCamera(
  type: PickerFileType.image,
  dialogTitle: "Take a photo",
);

// Capture a video
final video = await picker.pickCamera(
  type: PickerFileType.video,
  dialogTitle: "Record a video",
);
```

**Error Handling**:

```dart
try {
  final photo = await picker.pickCamera(type: PickerFileType.image);
  print("Captured: ${photo?.path}");
} on MasamunePickerPermissionDeniedException {
  print("Camera permission denied");
  // Show permission request dialog
} catch (e) {
  print("Picker error: $e");
}
```

### File Types

Specify the type of files to allow:

```dart
// Any file
await picker.pickSingle(type: PickerFileType.any);

// Images only
await picker.pickSingle(type: PickerFileType.image);

// Videos only
await picker.pickSingle(type: PickerFileType.video);

// Audio files
await picker.pickSingle(type: PickerFileType.audio);

// Custom extensions
await picker.pickSingle(
  type: PickerFileType.custom(["pdf", "docx", "xlsx"]),
);
```

### Display Selected Images

Show selected images in your UI:

```dart
class ImagePickerWidget extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final picker = ref.page.controller(Picker.query());

    return Column(
      children: [
        // Display selected images
        if (picker.value != null && picker.value!.isNotEmpty)
          Wrap(
            spacing: 8,
            children: picker.value!.map((file) {
              return Image.memory(
                file.bytes!,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              );
            }).toList(),
          ),
        
        // Pick button
        ElevatedButton(
          onPressed: () async {
            await picker.pickMultiple(type: PickerFileType.image);
          },
          child: const Text("Select Images"),
        ),
      ],
    );
  }
}
```

### Tips

- Use `PickerFileType.custom()` for specific file extensions
- Provide localized dialog titles via the `dialogTitle` parameter
- Monitor `picker.future` to show loading indicators during selection
- Combine with `masamune_camera` for advanced capture scenarios
- Use with storage adapters to automatically upload selected files to cloud storage

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)