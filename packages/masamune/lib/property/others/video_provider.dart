part of masamune.property.others;

@immutable
abstract class VideoProvider {
  const VideoProvider();
}

@immutable
class AssetVideoProvider extends VideoProvider {
  const AssetVideoProvider(this.path);
  final String path;
}

@immutable
class NetworkVideoProvider extends VideoProvider {
  const NetworkVideoProvider(this.url);
  final String url;
}

@immutable
class FileVideoProvider extends VideoProvider {
  const FileVideoProvider(this.file);
  final dynamic file;
}
