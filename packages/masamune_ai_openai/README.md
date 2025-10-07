<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune AI OpenAI</h1>
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

# Masamune AI OpenAI

## Overview

- `masamune_ai_openai` provides OpenAI ChatGPT integration for the Masamune AI framework.
- Extends `masamune_ai` with `OpenaiAIMasamuneAdapter` for OpenAI-powered generative AI.
- Supports GPT-4o, GPT-5-mini, and other OpenAI models.
- Streams responses from the Chat Completions API with real-time delta updates.
- Includes `OpenaiChatGPTFunctionsAction` for backend integration via Masamune Functions.

## Setup

1. Add the package to your project.

```bash
flutter pub add masamune_ai
flutter pub add masamune_ai_openai
```

2. Register `OpenaiAIMasamuneAdapter` in `MasamuneApp` with your API key.

```dart
import "package:masamune_ai_openai/masamune_ai_openai.dart";

void main() {
  runApp(
    MasamuneApp(
      appRef: appRef,
      adapters: const [
        OpenaiAIMasamuneAdapter(
          apiKey: String.fromEnvironment("OPENAI_API_KEY"),  // Required
          model: OpenaiAIModel.gpt4o,                        // OpenAI model
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

## OpenaiAIMasamuneAdapter Configuration

### Required Parameters

- `apiKey` (`String`): Your OpenAI API key (get from [OpenAI Platform](https://platform.openai.com/api-keys))
- `model` (`OpenaiAIModel`): The OpenAI model to use (see Available Models section)

### Optional Parameters

- `defaultConfig` (`AIConfig`): Default system prompt and response schema
- `contentFilter`: Preprocess messages before sending to OpenAI
- `onGenerateFunctionCallingConfig`: Control function-calling retry logic
- `mcpServerConfig`, `mcpClientConfig`, `mcpFunctions`: MCP tool integration settings

## Available Models

The `OpenaiAIModel` enum provides the following OpenAI models:

```dart
OpenaiAIModel.gpt4o                 // GPT-4o (default)
OpenaiAIModel.gpt4oMini             // GPT-4o mini
OpenaiAIModel.gpt5Mini              // GPT-5 mini (latest)
OpenaiAIModel.o1                    // O1 model
OpenaiAIModel.o1Mini                // O1 mini
OpenaiAIModel.o1Preview             // O1 preview
OpenaiAIModel.gpt4                  // GPT-4
OpenaiAIModel.gpt4Turbo             // GPT-4 Turbo
OpenaiAIModel.gpt35Turbo            // GPT-3.5 Turbo
```

## Key Features

### Streaming Responses

The adapter streams deltas from OpenAI's Chat Completions API, providing real-time updates:

```dart
final thread = ref.app.controller(
  AIThread.query(threadId: "chat-1"),
);

final response = await thread.generateContent([
  AIContent.text("Tell me a story"),
]);

// Monitor streaming updates
response.loading.then((_) {
  print("Response complete!");
});
```

### Content Filtering

Apply custom filtering to sanitize messages before sending:

```dart
OpenaiAIMasamuneAdapter(
  apiKey: String.fromEnvironment("OPENAI_API_KEY"),
  model: OpenaiAIModel.gpt4o,
  contentFilter: (contents) {
    // Remove non-text parts or apply other transformations
    return contents
        .map((content) => content.where((part) => part is AIContentTextPart))
        .toList();
  },
)
```

### Backend Functions Integration

Use `OpenaiChatGPTFunctionsAction` to trigger ChatGPT requests from Masamune Functions on your backend:

```dart
import "package:masamune_ai_openai/functions.dart";

// In your Masamune Functions handler
final response = await functions.execute(
  OpenaiChatGPTFunctionsAction(
    apiKey: yourApiKey,
    model: "gpt-4o",
    messages: [
      {"role": "user", "content": "Hello, ChatGPT!"},
    ],
  ),
);

print(response.text);
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
  AIContent.text("Tell me about GPT-4o"),
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
import "package:masamune_ai_openai/masamune_ai_openai.dart";

void main() {
  runApp(
    MasamuneApp(
      appRef: appRef,
      adapters: const [
        OpenaiAIMasamuneAdapter(
          apiKey: String.fromEnvironment("OPENAI_API_KEY"),
          model: OpenaiAIModel.gpt4o,
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
            AIContent.text("Hello, ChatGPT!"),
          ]);
        },
        child: Icon(Icons.send),
      ),
    );
  }
}
```

## Environment Variables

Set your OpenAI API key using environment variables:

```bash
# In your terminal or .env file
export OPENAI_API_KEY="sk-your-api-key-here"

# Or use --dart-define when running
flutter run --dart-define=OPENAI_API_KEY=sk-your-api-key-here
```

## Additional Resources

For detailed information on `AIThread`, `AISingle`, `AIContent`, `AITool`, and MCP integration, refer to the [`masamune_ai` package documentation](https://pub.dev/packages/masamune_ai).

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)