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

### Basic Usage

Use `PainterController` to manage drawing state and the `Painter` widget to display the canvas.

```dart
class DrawingPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final painter = ref.page.controller(PainterController.query());

    // Initialize on page load
    ref.page.on(
      initOrUpdate: () {
        painter.initialize();
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Painter")),
      body: Column(
        children: [
          // Toolbar with drawing tools
          FormPainterToolbar(controller: painter),
          
          // Main drawing canvas
          Expanded(
            child: Painter(controller: painter),
          ),
          
          // Layer management
          Container(
            height: 100,
            child: PainterLayerList(controller: painter),
          ),
        ],
      ),
    );
  }
}
```

### Drawing Tools

Control the painter programmatically:

```dart
// Select drawing tool
painter.selectPrimaryTool(PainterPrimaryTool.pen);
painter.selectPrimaryTool(PainterPrimaryTool.shape);
painter.selectPrimaryTool(PainterPrimaryTool.text);

// Change drawing properties
painter.changeColor(Colors.blue);
painter.changeStrokeWidth(5.0);

// Undo/Redo
painter.undo();
painter.redo();
```

### UI Components

**FormPainterToolbar**: Provides tool selection buttons
- Primary tools: Pen, shape, text, media, select
- Secondary tools: Copy, cut, paste
- Inline tools: Color picker, stroke settings, font properties

**PainterLayerList**: Manages layers
- Add/remove layers
- Change layer order
- Toggle layer visibility
- Rename layers

### Storage and Export

Save drawings as JSON or export as images:

**Export as JSON**:

```dart
// Export drawing data
final exportData = await painter.export();

// Save to file (contains all layers, strokes, and settings)
await File('path/to/drawing.json').writeAsString(
  jsonEncode(exportData.toJson()),
);

// Import later
final jsonData = await File('path/to/drawing.json').readAsString();
final importData = PainterExportValue.fromJson(jsonDecode(jsonData));
await painter.import(importData);
```

**Export as Image**:

```dart
// Render drawing to image
final imageBytes = await painter.renderImage(
  width: 1920,
  height: 1080,
  format: ImageByteFormat.png,
);

// Save to gallery or file
await painter.saveImageToGallery(imageBytes);

// Or save to file
await File('path/to/image.png').writeAsBytes(imageBytes);
```

**Autosave**:

Enable autosave in the adapter to automatically persist drawings:

```dart
PainterMasamuneAdapter(
  enableAutosave: true,
  autosaveInterval: Duration(seconds: 30),  // Save every 30 seconds
  storageDirectory: "painter",
)
```

### Advanced Features

**Layer Management**:

```dart
// Add new layer
painter.addLayer();

// Remove layer
painter.removeLayer(layerId);

// Rename layer
painter.renameLayer(layerId, "Background");

// Change layer order
painter.moveLayerUp(layerId);
painter.moveLayerDown(layerId);

// Toggle visibility
painter.toggleLayerVisibility(layerId);
```

**Filters and Effects**:

Apply filters to selected elements:

```dart
painter.selectPrimaryTool(PainterPrimaryTool.select);
// Select an element
painter.applyFilter(PainterFilter.blur);
painter.applyFilter(PainterFilter.grayscale);
```

**Media Insertion**:

Insert images from camera or gallery (requires `masamune_picker`):

```dart
painter.selectPrimaryTool(PainterPrimaryTool.media);
// Opens picker to select image
// Image is inserted as a new layer
```

### Tips

- Provide onboarding hints for layer management and advanced tools
- Persist user preferences (pen color, brush size) using shared preferences
- Consider disabling filters on low-end devices for better performance
- Use autosave to prevent data loss
- Test export/import flow thoroughly for data integrity

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)