part of '/masamune_ai_firebase.dart';

/// [MasamuneAdapter] for configuring FirebaseVertexAI features.
///
/// Set Firebase options in [options].
///
/// FirebaseVertexAIの機能を設定するための[MasamuneAdapter]。
///
/// [options]にFirebaseのオプションを設定してください。
class FirebaseAIMasamuneAdapter extends AIMasamuneAdapter {
  /// [MasamuneAdapter] for configuring FirebaseVertexAI features.
  ///
  /// Set Firebase options in [options].
  ///
  /// FirebaseVertexAIの機能を設定するための[MasamuneAdapter]。
  ///
  /// [options]にFirebaseのオプションを設定してください。
  FirebaseAIMasamuneAdapter({
    FirebaseVertexAI? vertexAI,
    FirebaseOptions? options,
    this.model = FirebaseAIModel.gemini15Flash,
    super.defaultConfig = const AIConfig(),
    this.iosOptions,
    this.androidOptions,
    this.webOptions,
    this.linuxOptions,
    this.windowsOptions,
    this.macosOptions,
  })  : _options = options,
        _vertexAI = vertexAI;

  /// The model name of the AI.
  ///
  /// AIのモデル名。
  final FirebaseAIModel model;

  /// FirebaseVertexAI instance.
  ///
  /// FirebaseVertexAIのインスタンス。
  FirebaseVertexAI get vertexAI => _vertexAI ?? FirebaseVertexAI.instance;
  final FirebaseVertexAI? _vertexAI;

  static final Map<AIConfig, GenerativeModel> _generativeModel = {};

  /// Options for initializing Firebase.
  ///
  /// If platform-specific options are specified, they take precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// プラットフォーム固有のオプションが指定されている場合はそちらが優先されます。
  FirebaseOptions? get options {
    if (UniversalPlatform.isIOS) {
      return iosOptions ?? _options;
    } else if (UniversalPlatform.isAndroid) {
      return androidOptions ?? _options;
    } else if (UniversalPlatform.isWeb) {
      return webOptions ?? _options;
    } else if (UniversalPlatform.isLinux) {
      return linuxOptions ?? _options;
    } else if (UniversalPlatform.isWindows) {
      return windowsOptions ?? _options;
    } else if (UniversalPlatform.isMacOS) {
      return macosOptions ?? _options;
    } else {
      return _options;
    }
  }

  /// Options for initializing Firebase.
  ///
  /// If options for other platforms are specified, these are ignored.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// 他のプラットフォーム用のオプションが指定されている場合はこちらは無視されます。
  final FirebaseOptions? _options;

  /// Options for initializing Firebase.
  ///
  /// Applies to IOS only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// IOSのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? iosOptions;

  /// Options for initializing Firebase.
  ///
  /// Applies to Android only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// Androidのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? androidOptions;

  /// Options for initializing Firebase.
  ///
  /// Applies to Web only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// Webのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? webOptions;

  /// Options for initializing Firebase.
  ///
  /// Applies to Web only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// Webのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? windowsOptions;

  /// Options for initializing Firebase.
  ///
  /// Applies to MacOS only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// MacOSのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? macosOptions;

  /// Options for initializing Firebase.
  ///
  /// Applies to Linux only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// Linuxのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? linuxOptions;

  /// Initialize the generative model.
  ///
  /// 生成モデルを初期化します。
  @override
  Future<void> initialize({
    AIConfig? config,
  }) async {
    config ??= defaultConfig;
    if (_generativeModel.containsKey(config)) {
      return;
    }
    final systemPrompt = config.systemPrompt;
    final responseSchema = config.responseSchema;
    _generativeModel[config] = vertexAI.generativeModel(
      model: model.model,
      generationConfig: GenerationConfig(
        responseMimeType: responseSchema != null ? "application/json" : null,
        responseSchema: responseSchema?._toSchema(),
      ),
      systemInstruction: systemPrompt != null
          ? AIContent.system(systemPrompt)._toContent()
          : null,
    );
  }

  @override
  Future<AIContent?> generateContent(
    List<AIContent> contents, {
    AIConfig? config,
  }) async {
    config ??= defaultConfig;
    final generativeModel = _generativeModel[config];
    if (generativeModel == null) {
      throw Exception("Please call initialize() before send().");
    }
    final res = AIContent.model();
    StreamSubscription<GenerateContentResponse>? subscription;
    final stream = generativeModel.generateContentStream(
      contents.map((e) {
        return e._toContent();
      }),
    );
    subscription = stream.listen(
      (line) {
        final candidates = line.candidates;
        for (final candidate in candidates) {
          final parts = candidate.content._toAIContentParts();
          res.add(parts, time: DateTime.now());
          if (candidate.finishReason != null) {
            res.complete(time: DateTime.now());
            subscription?.cancel();
            subscription = null;
            return;
          }
        }
      },
      onDone: () {
        res.complete(time: DateTime.now());
        subscription?.cancel();
        subscription = null;
      },
      onError: (error, stackTrace) {
        res.error(error, stackTrace);
        subscription?.cancel();
        subscription = null;
        throw error;
      },
    );
    return res;
  }
}
