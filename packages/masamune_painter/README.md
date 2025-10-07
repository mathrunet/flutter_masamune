<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Painter</h1>
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

# Masamune Painter

## Usage

### Installation

Add the package to your project.

```bash
flutter pub add masamune_painter
```

Run `flutter pub get` if you edit `pubspec.yaml` manually.

### Register the Adapter

`PainterMasamuneAdapter` configures default drawing behavior, storage paths, and media handlers. Register it before launching the app.

```dart
// lib/adapter.dart

/// Masamune adapters used in the application.
final masamuneAdapters = <MasamuneAdapter>[
  const UniversalMasamuneAdapter(),

  PainterMasamuneAdapter(
    enableAutosave: true,
    storageDirectory: "painter",
  ),
];
```

### Painter Controller

Use `PainterController` to manage drawing state. It stores layers, tools, and undo/redo stacks.

```dart
final painter = ref.page.controller(PainterController.query());

await painter.initialize();
painter.selectPrimaryTool(PainterPrimaryTool.pen);
painter.changeColor(Colors.blue);
```

Listen for changes via `painter.addListener` or watch with Masamune controllers to rebuild UI.

### Painter Widget

Embed the painter canvas and toolbars in your UI.

```dart
Painter(
  controller: painter,
  toolbar: FormPainterToolbar(controller: painter),
  layerList: PainterLayerList(controller: painter),
)
```

- `FormPainterToolbar` provides primary and secondary tools (pen, shapes, text, media).
- `PainterLayerList` manages layer ordering and visibility.
- Inline property panels let users change colors, stroke width, fonts, and filters.

### Storage and Export

`PainterController` saves drawings as JSON or image assets. Use the storage helpers provided under `storage/` to persist data locally or upload to the cloud.

```dart
final export = await painter.export();
await painter.saveToLocal(export, fileName: "sketch.json");

final image = await painter.renderImage();
await painter.saveImageToGallery(image);
```

### Advanced Features

- Autosave support via `enableAutosave` and `PainterMediaDatabase`.
- Import/export stroke data with `PainterExportValue`.
- Grouping, filters, and text formatting via primary/secondary/inline tool sets.
- Media insertion from camera or gallery when combined with Masamune Picker.

### Tips

- Provide onboarding hints so users discover layer management and advanced tools.
- Persist user settings (pen color, brush size) between sessions.
- Consider disabling high-cost filters on low-end devices to maintain performance.

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)