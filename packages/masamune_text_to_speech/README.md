<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Text-to-Speech</h1>
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

# Masamune Text-to-Speech

## Usage

### Installation

Add the package to your project.

```bash
flutter pub add masamune_text_to_speech
```

Run `flutter pub get` when editing `pubspec.yaml` manually.

### Register the Adapter

Configure `TextToSpeechMasamuneAdapter` before runApp. Set default language, speech rate, or iOS audio category if needed.

```dart
// lib/adapter.dart

/// Masamune adapters used in the application.
final masamuneAdapters = <MasamuneAdapter>[
  const UniversalMasamuneAdapter(),

  const TextToSpeechMasamuneAdapter(
    defaultLocale: Locale('en', 'US'),                         // Default language (required)
    defaultSpeechRate: 0.5,                                    // Speech speed (0.0-1.0, default: 1.0)
    defaultVolume: 1.0,                                        // Volume (0.0-1.0, default: 1.0)
    defaultPitch: 1.0,                                         // Pitch (0.0-1.0, default: 1.0)
    defaultIosAudioCategory: TextToSpeechIosAudioCategory.playback,  // iOS audio category
    defaultIosAudioCategoryOptions: [
      TextToSpeechIosAudioCategoryOptions.mixWithOthers,       // Mix with other audio
    ],
  ),
];
```

### Text-to-Speech Controller

Use `TextToSpeechController` to speak text, stop playback, and query voices.

```dart
class TextReaderPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final tts = ref.page.controller(TextToSpeechController.query());

    // Initialize on page load
    ref.page.on(
      initOrUpdate: () {
        tts.initialize();
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Text to Speech")),
      body: Column(
        children: [
          TextField(
            onChanged: (text) {
              // Store text to speak
            },
          ),
          
          ElevatedButton(
            onPressed: () async {
              await tts.speak("Hello Masamune!");
            },
            child: const Text("Speak"),
          ),
          
          ElevatedButton(
            onPressed: () async {
              await tts.stop();
            },
            child: const Text("Stop"),
          ),
        ],
      ),
    );
  }
}
```

### Configure Voice Parameters

Change pitch, rate, or language dynamically.

```dart
await tts.setLanguage("ja-JP");
await tts.setSpeechRate(0.6);
await tts.setPitch(1.2);
await tts.speak("こんにちは");
```

Use `availableLanguages()` and `availableVoices()` to present selection UI to users.

### Queueing and Completion

- `await tts.speak()` resolves when playback completes.
- Use `tts.setQueueMode(QueueMode.queue)` to enqueue multiple sentences.
- Register `onComplete` callback to react when speech finishes.

### Tips

- Set the iOS audio category (`playback`, `ambient`, etc.) to control mixing with other audio.
- Handle `tts.initialize()` errors gracefully, especially on web where permissions differ.
- Cache frequently used phrases if you need low latency in successive calls.
- Combine with `masamune_speech_to_text` to build conversational interfaces.

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)