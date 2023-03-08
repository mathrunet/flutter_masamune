part of masamune_ai_openai;

class OpenAIMedia extends ChangeNotifier
    implements ValueListenable<List<OpenAIMediaImg>> {
  OpenAIMedia({
    this.user = "user",
  });

  final String user;

  @override
  List<OpenAIMediaImg> get value => _value;

  Completer<List<OpenAIMediaImg>>? _createCompleter;

  Future<List<OpenAIMediaImg>>? get creating => _createCompleter?.future;

  final List<OpenAIMediaImg> _value = [];

  Future<List<OpenAIMediaImg>> create(
    String prompt, {
    OpenAIImageSize size = OpenAIImageSize.size512,
    int count = 1,
  }) async {
    if (_createCompleter != null) {
      return creating!;
    }
    _createCompleter = Completer();
    final responses = List.generate(
      count,
      (index) => OpenAIMediaImg._(
        width: size.size,
        height: size.size,
        completer: Completer(),
      ),
    );
    try {
      _value.addAll(responses);
      final res = await OpenAI.instance.image.create(
        prompt: prompt,
        size: size,
        n: count,
        responseFormat: OpenAIResponseFormat.url,
      );
      notifyListeners();
      if (res.data.length != count) {
        throw Exception("Failed to get response from openai_generations.");
      }
      for (int i = 0; i < count; i++) {
        responses[i]._complete(url: res.data[i].url);
      }
      notifyListeners();
      _createCompleter?.complete(responses);
      _createCompleter = null;
      return responses;
    } catch (e) {
      for (final response in responses) {
        response._error(e);
      }
      _createCompleter?.completeError(e);
      _createCompleter = null;
      rethrow;
    } finally {
      for (final response in responses) {
        response._finally();
      }
      _createCompleter?.complete([]);
      _createCompleter = null;
    }
  }
}

class OpenAIMediaImg extends ChangeNotifier
    implements ValueListenable<String?> {
  OpenAIMediaImg._({
    String? value,
    required this.width,
    required this.height,
    Completer? completer,
  })  : _value = value,
        _completer = completer;

  factory OpenAIMediaImg.fromJson(Map<String, dynamic> json) {
    return OpenAIMediaImg._(
      value: json["url"] ?? "",
      width: json["width"] ?? 0.0,
      height: json["height"] ?? 0.0,
    );
  }

  @override
  String? get value => _value;
  String? _value;

  final double width;
  final double height;

  ImageProvider? get image => value == null ? null : NetworkImage(value!);

  bool get error => __error;
  bool __error = false;

  Future<void>? get future => _completer?.future ?? _downloadCompleter?.future;
  Completer<void>? _completer;

  Completer<Uint8List?>? _downloadCompleter;

  Future<Uint8List?> download() async {
    if (_downloadCompleter != null) {
      return _downloadCompleter?.future;
    }
    if (value.isEmpty) {
      throw Exception("URL does not exist.");
    }
    _downloadCompleter = Completer();
    try {
      final res = await Api.get(value!);
      if (res.statusCode != 200) {
        throw Exception("Failed to download image.");
      }
      notifyListeners();
      _downloadCompleter?.complete(res.bodyBytes);
      _downloadCompleter = null;
      return res.bodyBytes;
    } catch (e) {
      _downloadCompleter?.completeError(e);
      _downloadCompleter = null;
      rethrow;
    } finally {
      _downloadCompleter?.complete(null);
      _downloadCompleter = null;
    }
  }

  void _complete({
    required String url,
  }) {
    _value = url;
    notifyListeners();
    _finally();
  }

  void _error(Object e) {
    __error = true;
    _value = e.toString();
    notifyListeners();
    _completer?.completeError(e);
    _completer = null;
  }

  void _finally() {
    _completer?.complete();
    _completer = null;
  }

  Map<String, dynamic> toJson() {
    return {
      "url": value,
      "width": width,
      "height": height,
    };
  }
}

extension on OpenAIImageSize {
  double get size {
    switch (this) {
      case OpenAIImageSize.size256:
        return 256;
      case OpenAIImageSize.size512:
        return 512;
      case OpenAIImageSize.size1024:
        return 1024;
    }
  }
}
