<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Google Speech-to-Text</h1>
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

# Masamune Google Speech-to-Text

## Usage

### Installation

Add the package to your project.

```bash
flutter pub add masamune_speech_to_text
```

Run `flutter pub get` when editing `pubspec.yaml` manually.

### Register the Adapter

Configure `GoogleSpeechToTextMasamuneAdapter` before launching the app. Provide the default language settings.

```dart
// lib/adapter.dart

/// Masamune adapters used in the application.
final masamuneAdapters = <MasamuneAdapter>[
  const UniversalMasamuneAdapter(),

  const GoogleSpeechToTextMasamuneAdapter(
    defaultLocale: Locale('en', 'US'),  // Default language (required)
  ),
];
```

**For Japanese**:

```dart
const GoogleSpeechToTextMasamuneAdapter(
  defaultLocale: Locale('ja', 'JP'),
)
```

**With Auto-initialization** (optional):

```dart
// Create controller for auto-initialization
final sttController = SpeechToTextController();

const GoogleSpeechToTextMasamuneAdapter(
  defaultLocale: Locale('en', 'US'),
  speechToTextController: sttController,  // Will initialize on boot
  initializeOnBoot: true,                 // Auto-initialize
)
```

### Speech-to-Text Controller

Use `SpeechToTextController` to initialize speech recognition, start listening, and handle results.

```dart
class VoiceInputPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final stt = ref.page.controller(SpeechToTextController.query());

    // Initialize on page load
    ref.page.on(
      initOrUpdate: () {
        stt.initialize();
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Voice Input")),
      body: Column(
        children: [
          Text(stt.recognizedText ?? "Say something..."),
          
          ElevatedButton(
            onPressed: () async {
              if (stt.isListening) {
                await stt.stop();
              } else {
                await stt.listen(
                  onResult: (result) {
                    print("Recognized: ${result.recognizedWords}");
                  },
                );
              }
            },
            child: Text(stt.isListening ? "Stop" : "Start Listening"),
          ),
        ],
      ),
    );
  }
}
```

### Continuous Listening

- `listen()` starts recognition; set `partialResults: true` to receive interim transcripts.
- Use `stt.pause()` / `stt.resume()` to manage listening sessions without full reinitialization.
- Handle permission checks; the controller throws if microphone access is denied.

### Error Handling

Listen to the error stream or supply `onError` to `listen()` to capture `SpeechRecognitionError` details.

```dart
await stt.listen(
  onError: (SpeechRecognitionError error) {
    debugPrint("Error: ${error.errorMsg}");
  },
);
```

### Tips

- Always call `initialize()` before listening; reuse the controller across sessions for performance.
- Provide UI feedback (animations, status indicators) while listening.
- Localize locale IDs (e.g., `ja_JP`, `fr_FR`) to match target audiences.
- Combine with text input fields to let users edit recognized text.

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)