<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune AI Firebase</h1>
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

# Masamune AI Firebase

## Overview

- `masamune_ai_firebase` provides Firebase Vertex AI / Gemini integration for the Masamune AI framework.
- Extends `masamune_ai` with `FirebaseAIMasamuneAdapter` for Firebase-powered generative AI.
- Supports Gemini 2.0 Flash and other Firebase AI models.
- Includes automatic function-calling support via Vertex AI when using MCP tools.
- Optionally enables Firebase App Check for secure API access.

## Setup

1. Add the package to your project.

```bash
flutter pub add masamune_ai
flutter pub add masamune_ai_firebase
```

2. Initialize Firebase and register `FirebaseAIMasamuneAdapter` in `MasamuneApp`.

```dart
import "package:masamune_ai_firebase/masamune_ai_firebase.dart";

void main() {
  runApp(
    MasamuneApp(
      appRef: appRef,
      adapters: const [
        FirebaseAIMasamuneAdapter(
          options: DefaultFirebaseOptions.currentPlatform,  // Firebase config
          model: FirebaseAIModel.gemini20Flash,             // AI model
          enableAppCheck: true,                              // Optional: Enable App Check
          defaultConfig: AIConfig(
            systemPromptContent: AIContent.system([
              AIContent.model(text: "You are a helpful assistant."),
            ]),
          ),
        ),
      ],
    ),
  );
}
```

## FirebaseAIMasamuneAdapter Configuration

### Required Parameters

- `options` (`FirebaseOptions`): Firebase project configuration from `firebase_options.dart`
- `model` (`FirebaseAIModel`): The Gemini model to use (see Available Models section)

### Optional Parameters

- `defaultConfig` (`AIConfig`): Default system prompt and response schema
- `enableAppCheck` (`bool`): Enable Firebase App Check for API security (default: `false`)
- `contentFilter`: Preprocess messages before sending to the AI
- `onGenerateFunctionCallingConfig`: Control function-calling retry logic
- `mcpServerConfig`, `mcpClientConfig`, `mcpFunctions`: MCP tool integration settings

## Available Models

The `FirebaseAIModel` enum provides the following Gemini models:

```dart
FirebaseAIModel.gemini20Flash         // Gemini 2.0 Flash (default)
FirebaseAIModel.gemini15Flash         // Gemini 1.5 Flash
FirebaseAIModel.gemini15FlashLatest   // Gemini 1.5 Flash (latest version)
FirebaseAIModel.gemini15Flash8B       // Gemini 1.5 Flash 8B (lightweight)
FirebaseAIModel.gemini15Pro           // Gemini 1.5 Pro
FirebaseAIModel.gemini15ProLatest     // Gemini 1.5 Pro (latest version)
```

## Key Features

### Automatic Initialization

The adapter automatically initializes Firebase and caches `GenerativeModel` instances per `AIConfigKey` (config + tools combination). Call `initialize()` once before generating content:

```dart
final adapter = FirebaseAIMasamuneAdapter.primary;
await adapter.initialize();
```

### Function Calling Support

When MCP tools are provided via `AIThread` or `AISingle`, they are automatically converted to Vertex AI function declarations:

```dart
final thread = ref.app.controller(
  AIThread.query(
    threadId: "chat-1",
    tools: {weatherTool},  // Automatically converted to Vertex AI functions
  ),
);
```

Control function-calling behavior with `onGenerateFunctionCallingConfig`:

```dart
FirebaseAIMasamuneAdapter(
  options: DefaultFirebaseOptions.currentPlatform,
  model: FirebaseAIModel.gemini20Flash,
  onGenerateFunctionCallingConfig: (attempt) => AIGenerateFunctionCallingConfig(
    maxRetries: 3,
    forceExecution: attempt > 0,
  ),
)
```

### App Check Integration

Enable Firebase App Check for additional API security:

```dart
FirebaseAIMasamuneAdapter(
  options: DefaultFirebaseOptions.currentPlatform,
  model: FirebaseAIModel.gemini20Flash,
  enableAppCheck: true,  // Requires Firebase App Check setup
)
```

## Usage with AIThread and AISingle

For conversation management and content generation, use `AIThread` (multi-turn) and `AISingle` (single-turn) controllers from the `masamune_ai` package:

```dart
// Multi-turn conversation
final thread = ref.app.controller(
  AIThread.query(
    threadId: "chat-1",
    initialContents: [AIContent.text("Hello!")],
  ),
);

await thread.generateContent([
  AIContent.text("Tell me about Firebase Gemini API"),
]);

// Single-turn interaction
final single = ref.app.controller(AISingle.query());
final result = await single.generateContent([
  AIContent.text("Summarize this"),
]);
```

## Complete Example

```dart
import "package:masamune_ai/masamune_ai.dart";
import "package:masamune_ai_firebase/masamune_ai_firebase.dart";

void main() {
  runApp(
    MasamuneApp(
      appRef: appRef,
      adapters: const [
        FirebaseAIMasamuneAdapter(
          options: DefaultFirebaseOptions.currentPlatform,
          model: FirebaseAIModel.gemini20Flash,
          defaultConfig: AIConfig(
            systemPromptContent: AIContent.system([
              AIContent.model(text: "You are a helpful AI assistant."),
            ]),
          ),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final thread = ref.app.controller(
      AIThread.query(threadId: "main-chat"),
    );

    return Scaffold(
      body: ListView.builder(
        itemCount: thread.value.length,
        itemBuilder: (context, index) {
          final content = thread.value[index];
          return ListTile(
            title: Text(content.role.name),
            subtitle: Text(content.text),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await thread.generateContent([
            AIContent.text("Hello, Gemini!"),
          ]);
        },
        child: Icon(Icons.send),
      ),
    );
  }
}
```

## Additional Resources

For detailed information on `AIThread`, `AISingle`, `AIContent`, `AITool`, and MCP integration, refer to the [`masamune_ai` package documentation](https://pub.dev/packages/masamune_ai).

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)