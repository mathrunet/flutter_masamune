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

# Masamune AI

## Overview

- `masamune_ai` is a generative AI integration library for the Masamune framework.
- Configure AI behavior through the adapter (`AIMasamuneAdapter`), including Model Context Protocol (MCP) settings.
- Use `AIThread` to manage multi-turn conversations and `AISingle` for single-turn prompts.
- Manage tool integrations via the MCP client (`McpClient`) and `AITool`.

## Setup

1. Add the package to `pubspec.yaml`.

```yaml
dependencies:
  masamune: ^xxx
  masamune_ai:
```

2. Register an AI adapter in `MasamuneApp`.

```dart
void main() {
  runApp(
    MasamuneApp(
      appRef: appRef,
      adapters: const [
        MyAIMasamuneAdapter(),
      ],
    ),
  );
}
```

## AIMasamuneAdapter

- Implements common AI initialization and configuration logic.
- Provide the following when extending:
  - `defaultConfig`: an `AIConfig` describing the model, system prompt, and response schema.
  - `initialize` and `generateContent`: connect to the actual AI service.
  - `mcpServerConfig`, `mcpClientConfig`, `mcpFunctions`: settings for MCP integration.
  - `contentFilter` and `onGenerateFunctionCallingConfig`: preprocess content or control function-calling retries.

### Runtime Adapter Example

Use `RuntimeAIMasamuneAdapter` for tests or mock implementations.

```dart
class MockAdapter extends RuntimeAIMasamuneAdapter {
  const MockAdapter()
      : super(
          onGenerateContent: (contents, config) async {
            final response = AIContent.model(text: "Mock response!");
            response.complete();
            return response;
          },
        );
}
```

### Firebase AI Adapter

- Available via `masamune_ai_firebase` (`FirebaseAIMasamuneAdapter`).
- Requires Firebase initialization (`FirebaseOptions`) and optionally platform-specific options.
- Supports Gemini models (`FirebaseAIModel`) and Vertex AI function-calling when MCP tools are provided.

```dart
import "package:masamune_ai_firebase/masamune_ai_firebase.dart";

void main() {
  runApp(
    MasamuneApp(
      appRef: appRef,
      adapters: const [
        FirebaseAIMasamuneAdapter(
          options: DefaultFirebaseOptions.currentPlatform,
          model: FirebaseAIModel.gemini20Flash,
          enableAppCheck: true,
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

- Call `initialize` once before generating content. The adapter caches Vertex AI `GenerativeModel` instances per `AIConfigKey` (config + tools).
- When MCP tools are provided, they are converted to Vertex AI function declarations. Use `onGenerateFunctionCallingConfig` to control retries or limits.

### OpenAI Adapter

- Available via `masamune_ai_openai` (`OpenaiAIMasamuneAdapter`).
- Requires an OpenAI API key (`apiKey`) and supports the latest `OpenaiAIModel` definitions.
- Streams responses from the Chat Completions API; additional filtering can be applied through `contentFilter`.

```dart
import "package:masamune_ai_openai/masamune_ai_openai.dart";

void main() {
  runApp(
    MasamuneApp(
      appRef: appRef,
      adapters: const [
        OpenaiAIMasamuneAdapter(
          apiKey: String.fromEnvironment("OPENAI_API_KEY"),
          model: OpenaiAIModel.gpt5Mini,
          contentFilter: _sanitizeMessages,
        ),
      ],
    ),
  );
}

List<AIContent> _sanitizeMessages(List<AIContent> contents) {
  return contents
      .map((content) => content.where((part) => part is AIContentTextPart))
      .toList();
}
```

- Initializes the `dart_openai` client once and streams deltas into `AIContent` instances.
- For backend automation, use `OpenaiChatGPTFunctionsAction` (see `masamune_ai_openai/functions`) to trigger ChatGPT requests from Masamune Functions.

## AIConfig and AITool

- `AIConfig`: holds the model name, system prompt (`AIContent.system`), and response schema (`AISchema`).
- `AITool`: defines a tool that can be invoked through MCP or function calls.

```dart
final weatherTool = AITool(
  name: "weather",
  description: "Get the current weather",
  parameters: {
    "city": AISchema.string(description: "City name"),
  },
);
```

## Conversation Management with AIThread

- Maintains a list of `AIContent` exchanges and supports multi-turn conversations.
- Call `initialize` to set up the model, then `generateContent` to send user input and receive responses.

```dart
final thread = ref.app.controller(
  AIThread.query(
    threadId: "chat-1",
    initialContents: [
      AIContent.text("Hello!"),
    ],
  ),
);

final updatedContents = await thread.generateContent(
  [AIContent.text("Tell me the latest news")],
  config: AIConfig(model: "gpt-4o-mini"),
  tools: {weatherTool},
);
```

## Single Interaction with AISingle

- Use when only one response is needed.

```dart
final single = ref.app.controller(
  AISingle.query(
    config: AIConfig(model: "gpt-4o-mini"),
  ),
);

final result = await single.generateContent([
  AIContent.text("Summarize this"),
]);
```

## MCP Client Integration

- `McpClient` loads tools from an MCP server and processes AI function calls.

```dart
final mcpClient = ref.app.controller(McpClient.query());
await mcpClient.load();
final toolResult = await mcpClient.call("weather", {"city": "Tokyo"});
```

- When `mcpClientConfig` and `mcpFunctions` are configured in the adapter, `AIThread` and `AISingle` automatically invoke tools through MCP during `generateContent`.

## Working with AIContent

- Represents messages exchanged with the model.
- Factory constructors support multiple data types: `AIContent.text`, `AIContent.png`, `AIContent.system`, and more.
- Use `AIContentFunctionCallPart` and `AIContentFunctionResponsePart` to model structured function calls.
- Streamed responses can be handled via `add`, `complete`, and `error`.

## Typical Workflow

1. Register a custom `AIMasamuneAdapter` in `MasamuneApp`.
2. Obtain `AIThread` or `AISingle` via `ref.app.controller`.
3. Optionally load MCP tools.
4. Call `generateContent` with user `AIContent`.
5. Render the AI response from the controller’s `value`.
6. Handle function calls via MCP or custom logic.

## Common Customizations

- **System Prompt**: Provide `AIConfig.systemPromptContent` with `AIContent.system`.
- **Response Schema**: Define structured JSON outputs using `AISchema`.
- **Usage Tracking**: Inspect `onGeneratedContentUsage` for prompt and candidate token counts.
- **Content Filtering**: Apply `contentFilter` or per-call filters to sanitize requests.
- **Function Calling Control**: Customize retries or forced execution with `onGenerateFunctionCallingConfig`.

## Development Tips

- Follow Masamune controller patterns (`appRef`, `ref.app.controller`) for lifecycle-aware access.
- Monitor the `loading` future on `AIContent` for streaming updates.
- Even without MCP, the adapter’s `onFunctionCall` must return an empty list to satisfy the interface.

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)