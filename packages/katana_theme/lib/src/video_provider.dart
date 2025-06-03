part of "/katana_theme.dart";

/// {@template video_provider}
/// Provider to load video data and display it in widgets.
///
/// [AssetVideoProvider], etc.
///
/// ビデオのデータをロードしてウィジェットで表示するためのプロバイダー。
///
/// [AssetVideoProvider]などがあります。
/// {@endtemplate}
@immutable
abstract class VideoProvider {
  /// {@template video_provider}
  /// Provider to load video data and display it in widgets.
  ///
  /// [AssetVideoProvider], etc.
  ///
  /// ビデオのデータをロードしてウィジェットで表示するためのプロバイダー。
  ///
  /// [AssetVideoProvider]などがあります。
  /// {@endtemplate}
  const VideoProvider();
}

/// Provider to load video files from assets and display them in widgets.
///
/// アセットからビデオファイルをロードしてウィジェットで表示するためのプロバイダー。
///
/// {@macro video_provider}
@immutable
class AssetVideoProvider extends VideoProvider {
  /// Provider to load video files from assets and display them in widgets.
  ///
  /// アセットからビデオファイルをロードしてウィジェットで表示するためのプロバイダー。
  ///
  /// {@macro video_provider}
  const AssetVideoProvider(this.path);

  /// Paths in the asset.
  ///
  /// アセット内のパス。
  final String path;

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode => path.hashCode;
}
