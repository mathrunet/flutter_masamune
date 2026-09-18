part of "/masamune_handover.dart";

/// The operating mode of the application distributed by the handover configuration.
///
/// ハンドオーバー設定によって配信されるアプリケーションの動作モード。
enum HandoverMode {
  /// Normal operation. This is also used when no configuration is available.
  ///
  /// 通常運転。設定が取得できない場合もこのモードになります。
  normal,

  /// Displays an announcement banner while keeping the application fully functional.
  ///
  /// アプリを通常稼働させたまま告知バナーを表示します。
  announce,

  /// Keeps the application readable but disables write-type features specified in [HandoverConfig.features].
  ///
  /// アプリを参照可能にしたまま[HandoverConfig.features]で指定された書き込み系機能を無効化します。
  readonly,

  /// Displays a full-screen maintenance page.
  ///
  /// 全画面のメンテナンスページを表示します。
  maintenance;

  /// Parses [value] into a [HandoverMode]. Unknown values fall back to [HandoverMode.normal].
  ///
  /// [value]を[HandoverMode]に変換します。不明な値は[HandoverMode.normal]になります。
  static HandoverMode parse(String? value) {
    switch (value) {
      case "announce":
        return HandoverMode.announce;
      case "readonly":
        return HandoverMode.readonly;
      case "maintenance":
        return HandoverMode.maintenance;
      default:
        return HandoverMode.normal;
    }
  }
}

/// Immutable configuration for application handover distributed as a static JSON file.
///
/// The JSON is retrieved from a URL such as `https://api.mathru.net/apps/{app_id}.json` and the `handover` section of the file is parsed into this object.
///
/// Absence of the file or the section is a normal condition and results in [HandoverConfig.empty].
///
/// 静的なJSONファイルとして配信されるアプリケーションハンドオーバー用の設定。
///
/// `https://api.mathru.net/apps/{app_id}.json`のようなURLから取得したJSONの`handover`セクションをパースしてこのオブジェクトに変換します。
///
/// ファイルやセクションが存在しないことは正常系であり、その場合は[HandoverConfig.empty]になります。
@immutable
class HandoverConfig {
  /// Immutable configuration for application handover distributed as a static JSON file.
  ///
  /// 静的なJSONファイルとして配信されるアプリケーションハンドオーバー用の設定。
  const HandoverConfig({
    this.mode = HandoverMode.normal,
    this.message = const {},
    this.scheduledAt,
    this.estimatedEndAt,
    this.endpoints = const {},
    this.features = const {},
    this.minVersion,
    this.storeUrlIos,
    this.storeUrlAndroid,
    this.delegateUrl,
  });

  /// Creates a [HandoverConfig] from [json].
  ///
  /// Parsing is tolerant: missing or malformed fields fall back to their defaults and never throw.
  ///
  /// [json]から[HandoverConfig]を作成します。
  ///
  /// パースは寛容に行われ、欠損や不正なフィールドはデフォルト値になり例外を投げません。
  factory HandoverConfig.fromJson(DynamicMap json) {
    final forceUpdate = json.getAsMap("force_update", {});
    return HandoverConfig(
      mode: HandoverMode.parse(json.get("mode", "")),
      message: json.getAsMap("message", {}).map(
          (key, value) => MapEntry(key, value?.toString() ?? "")),
      scheduledAt: DateTime.tryParse(json.get("scheduled_at", "")),
      estimatedEndAt: DateTime.tryParse(json.get("estimated_end_at", "")),
      endpoints: json.getAsMap("endpoints", {}).map(
          (key, value) => MapEntry(key, value?.toString() ?? "")),
      features: json.getAsMap("features", {}).map(
        (key, value) => MapEntry(key, value == true),
      ),
      minVersion: forceUpdate.get<String?>("min_version", null),
      storeUrlIos: forceUpdate.get<String?>("store_url_ios", null),
      storeUrlAndroid: forceUpdate.get<String?>("store_url_android", null),
      delegateUrl: json.get<String?>("delegate_url", null),
    );
  }

  /// An empty configuration representing normal operation.
  ///
  /// 通常運転を表す空の設定。
  static const HandoverConfig empty = HandoverConfig();

  /// The operating mode of the application.
  ///
  /// アプリケーションの動作モード。
  final HandoverMode mode;

  /// Localized messages keyed by locale code (e.g. `ja`, `en`).
  ///
  /// ロケールコード（例:`ja`、`en`）をキーとするローカライズ済みメッセージ。
  final Map<String, String> message;

  /// The scheduled start time of the maintenance used for announcements.
  ///
  /// 告知に使用するメンテナンスの開始予定日時。
  final DateTime? scheduledAt;

  /// The estimated end time of the maintenance.
  ///
  /// メンテナンスの終了予定日時。
  final DateTime? estimatedEndAt;

  /// Endpoint overrides keyed by endpoint name (e.g. `api_base_url`).
  ///
  /// Used to switch backend URLs, ad unit IDs, etc. to the new owner's resources without an app update.
  ///
  /// エンドポイント名（例:`api_base_url`）をキーとするエンドポイントの上書き設定。
  ///
  /// アプリ更新なしでバックエンドURLや広告ユニットID等を新オーナーのリソースへ切り替えるために使用します。
  final Map<String, String> endpoints;

  /// Feature flags keyed by feature name.
  ///
  /// 機能名をキーとする機能フラグ。
  final Map<String, bool> features;

  /// The minimum required application version for force update.
  ///
  /// 強制アップデートに必要な最低アプリバージョン。
  final String? minVersion;

  /// The App Store URL used for force update.
  ///
  /// 強制アップデートに使用するApp StoreのURL。
  final String? storeUrlIos;

  /// The Google Play URL used for force update.
  ///
  /// 強制アップデートに使用するGoogle PlayのURL。
  final String? storeUrlAndroid;

  /// When set, the configuration is delegated to this URL and re-fetched from there.
  ///
  /// Used to hand over control of the configuration to the new owner after a buyout.
  ///
  /// 設定されている場合、設定はこのURLへ委譲されそこから再取得されます。
  ///
  /// バイアウト後に設定の制御権を新オーナーへ引き渡すために使用します。
  final String? delegateUrl;

  /// Returns whether the feature specified by [key] is enabled.
  ///
  /// If the feature is not defined, it is treated as disabled when [mode] is [HandoverMode.readonly] and enabled otherwise.
  ///
  /// [key]で指定した機能が有効かどうかを返します。
  ///
  /// 機能が定義されていない場合、[mode]が[HandoverMode.readonly]のときは無効、それ以外のときは有効として扱われます。
  bool isFeatureEnabled(String key) {
    final value = features[key];
    if (value != null) {
      return value;
    }
    return mode != HandoverMode.readonly;
  }

  /// Returns the endpoint override for [key], or [defaultValue] if not defined.
  ///
  /// [key]に対応するエンドポイントの上書き設定を返します。未定義の場合は[defaultValue]を返します。
  String endpoint(String key, {String defaultValue = ""}) {
    return endpoints[key] ?? defaultValue;
  }

  /// Returns the localized message for [locale], falling back to English and then to any available message.
  ///
  /// [locale]に対応するローカライズ済みメッセージを返します。見つからない場合は英語、それも無ければ任意のメッセージにフォールバックします。
  String messageFor(Locale locale) {
    return message[locale.languageCode] ??
        message["en"] ??
        (message.isNotEmpty ? message.values.first : "");
  }

  @override
  int get hashCode =>
      mode.hashCode ^
      message.hashCode ^
      scheduledAt.hashCode ^
      estimatedEndAt.hashCode ^
      endpoints.hashCode ^
      features.hashCode ^
      minVersion.hashCode ^
      storeUrlIos.hashCode ^
      storeUrlAndroid.hashCode ^
      delegateUrl.hashCode;

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;
}
