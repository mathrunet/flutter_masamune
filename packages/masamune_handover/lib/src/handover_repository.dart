part of "/masamune_handover.dart";

/// Repository that retrieves [HandoverConfig] from a remote static JSON file.
///
/// All retrieval failures (404, network errors, malformed JSON) are treated as normal conditions and never throw. When retrieval fails, the last successfully fetched configuration cached in [SharedPreferences] is used. When no cache is available, [HandoverConfig.empty] is returned.
///
/// リモートの静的JSONファイルから[HandoverConfig]を取得するリポジトリ。
///
/// すべての取得失敗（404、ネットワークエラー、不正なJSON）は正常系として扱われ例外を投げません。取得に失敗した場合は[SharedPreferences]にキャッシュされた最後に成功した設定を使用します。キャッシュも無い場合は[HandoverConfig.empty]を返します。
class HandoverRepository {
  /// Repository that retrieves [HandoverConfig] from a remote static JSON file.
  ///
  /// リモートの静的JSONファイルから[HandoverConfig]を取得するリポジトリ。
  const HandoverRepository({
    required this.endpoint,
    this.timeout = const Duration(seconds: 3),
    this.verify,
  });

  /// The URL of the static JSON file (e.g. `https://api.mathru.net/apps/myapp.json`).
  ///
  /// 静的JSONファイルのURL（例:`https://api.mathru.net/apps/myapp.json`）。
  final String endpoint;

  /// Timeout for each HTTP request.
  ///
  /// HTTPリクエストごとのタイムアウト。
  final Duration timeout;

  /// Optional callback to verify the integrity of the retrieved JSON (e.g. JWS signature verification).
  ///
  /// Receives the raw JSON map and returns whether it is trustworthy. When it returns `false`, the configuration is discarded.
  ///
  /// 取得したJSONの完全性を検証するための任意のコールバック（例:JWS署名検証）。
  ///
  /// 生のJSONマップを受け取り、信頼できるかどうかを返します。`false`を返した場合その設定は破棄されます。
  final FutureOr<bool> Function(DynamicMap json)? verify;

  static const String _cacheKey = "masamune_handover_cache";
  static const int _maxDelegateHops = 3;

  /// Retrieves the latest [HandoverConfig].
  ///
  /// The `handover` section of the JSON at [endpoint] is parsed. When the section contains a `delegate_url`, the configuration is re-fetched from that URL (up to 3 hops).
  ///
  /// Never throws. Returns the cached configuration on failure, or [HandoverConfig.empty] when no cache exists.
  ///
  /// 最新の[HandoverConfig]を取得します。
  ///
  /// [endpoint]のJSONの`handover`セクションをパースします。セクションに`delegate_url`が含まれる場合はそのURLから再取得します（最大3ホップ）。
  ///
  /// 例外は投げません。失敗時はキャッシュ済みの設定を、キャッシュが無い場合は[HandoverConfig.empty]を返します。
  Future<HandoverConfig> fetch() async {
    try {
      var url = endpoint;
      var extractSection = true;
      for (var hop = 0; hop < _maxDelegateHops; hop++) {
        final json = await _fetchJson(url);
        if (json == null) {
          return _loadCache();
        }
        final section = extractSection ? _extractSection(json) : json;
        if (section == null) {
          // Absence of the handover section is a normal condition.
          // handoverセクションが存在しないことは正常系。
          await _saveCache(null);
          return HandoverConfig.empty;
        }
        if (verify != null && !await verify!.call(section)) {
          return _loadCache();
        }
        final config = HandoverConfig.fromJson(section);
        final delegateUrl = config.delegateUrl;
        if (delegateUrl.isNotEmpty && delegateUrl != url) {
          url = delegateUrl!;
          // Delegated files are expected to contain the handover
          // configuration at the top level or in a `handover` section.
          // 委譲先ファイルはトップレベルまたは`handover`セクションに
          // ハンドオーバー設定を持つことを想定。
          extractSection = false;
          continue;
        }
        await _saveCache(section);
        return config;
      }
      return _loadCache();
    } catch (e) {
      // All failures are normal conditions for the handover configuration.
      // ハンドオーバー設定においてはすべての失敗が正常系。
      debugPrint("HandoverRepository: fallback to cache: $e");
      return _loadCache();
    }
  }

  Future<DynamicMap?> _fetchJson(String url) async {
    try {
      final response = await Api.get(url).timeout(timeout);
      if (response.statusCode != 200) {
        return null;
      }
      final decoded = jsonDecode(response.body);
      if (decoded is! Map) {
        return null;
      }
      return Map<String, dynamic>.from(decoded);
    } catch (e) {
      return null;
    }
  }

  DynamicMap? _extractSection(DynamicMap json) {
    // Allow both a top-level handover config and a `handover` section
    // inside a shared per-app configuration file.
    // アプリ共通設定ファイル内の`handover`セクションと
    // トップレベルのハンドオーバー設定の両方を許容する。
    if (json.containsKey("handover")) {
      final section = json.getAsMap("handover", {});
      return section.isEmpty ? null : section;
    }
    if (json.containsKey("mode") || json.containsKey("delegate_url")) {
      return json;
    }
    return null;
  }

  Future<HandoverConfig> _loadCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString(_cacheKey);
      if (cached == null || cached.isEmpty) {
        return HandoverConfig.empty;
      }
      final decoded = jsonDecode(cached);
      if (decoded is! Map) {
        return HandoverConfig.empty;
      }
      return HandoverConfig.fromJson(Map<String, dynamic>.from(decoded));
    } catch (e) {
      return HandoverConfig.empty;
    }
  }

  Future<void> _saveCache(DynamicMap? json) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (json == null) {
        await prefs.remove(_cacheKey);
      } else {
        await prefs.setString(_cacheKey, jsonEncode(json));
      }
    } catch (e) {
      // Cache failures are ignored.
      // キャッシュの失敗は無視する。
    }
  }
}
