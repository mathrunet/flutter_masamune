part of "web.dart";

/// A class that provides utilities for handling assets without much awareness of their source location (on the network, on the terminal, in the asset folder).
///
/// [Asset.text] allows you to retrieve text from a text file on the network, terminal, or asset.
///
/// [Asset.image] allows you to retrieve image files on the network, terminal, or asset as [ImageProvider].
///
/// アセットのソースの場所（ネットワーク上、端末上、アセットフォルダ内）をあまり意識せず取扱うためのユーティリティを提供するクラス。
///
/// [Asset.text]でネットワーク上や端末、アセット上のテキストファイルからテキストを取り出すことができます。
///
/// [Asset.image]でネットワーク上や端末、アセット上の画像ファイルを[ImageProvider]として取り出すことができます。
class Asset {
  const Asset._();

  /// Get builder to get text data.
  ///
  /// テキストデータを取得するためのビルダーを取得します。
  static const TextProviderBuilder text = TextProviderBuilder._();

  /// Acquire builder to get image data.
  ///
  /// 画像データを取得するためのビルダーを取得します。
  static const ImageProviderBuilder image = ImageProviderBuilder._();
}

/// Class for providing implementation of [Asset.text].
///
/// [Asset.text]を実装を提供するためのクラス。
class TextProviderBuilder with _TextProviderBuilderMixin {
  const TextProviderBuilder._();

  /// Retrieves files in the document folder.
  ///
  /// ドキュメントフォルダ内のファイルを取得します。
  DocumentTextProviderBuilder get document => throw UnimplementedError();

  /// Retrieves files in a temporary folder.
  ///
  /// テンポラリフォルダ内のファイルを取得します。
  TemporaryTextProviderBuilder get temporary => throw UnimplementedError();
}

/// Class for providing implementation of [Asset.text].
///
/// Retrieves files in the document folder.
///
/// [Asset.text]を実装を提供するためのクラス。
///
/// ドキュメントフォルダ内のファイルを取得します。
class DocumentTextProviderBuilder with _TextProviderBuilderMixin {
  const DocumentTextProviderBuilder._();
}

/// Class for providing implementation of [Asset.text].
///
/// Retrieves files in the temporary folder.
///
/// [Asset.text]を実装を提供するためのクラス。
///
/// 一時フォルダ内のファイルを取得します。
class TemporaryTextProviderBuilder with _TextProviderBuilderMixin {
  const TemporaryTextProviderBuilder._();
}

mixin _TextProviderBuilderMixin {
  /// Obtains text from a text file that exists in [uri].
  ///
  /// If [uri] starts with `http://` or `https://`, a request is made to the network with `GET` to retrieve the text.
  /// In this case, request headers can be added at [headers].
  ///
  /// If [uri] starts with an absolute path of `file://` or `/`, a search is performed on the terminal file path to obtain the text within the file if it exists.
  /// (Not available on the Web)
  ///
  /// If the file is not found, or [uri] starts with `resource://`, search for the file in Flutter's assets folder and retrieve the text in the file.
  ///
  /// If [uri] is empty or the text cannot be retrieved for some reason, [defaultValue] is returned.
  ///
  /// [uri]に存在するテキストファイルからテキストを取得します。
  ///
  /// [uri]が`http://`、`https://`から始まる場合、ネットワークに対して`GET`でリクエストを行いテキストを取得します。
  /// その際[headers]でリクエストヘッダを付与することが可能です。
  ///
  /// [uri]が`file://`、または`/`の絶対パスで始まる場合、端末のファイルパスに対して検索を行い、ファイルが存在するときそのファイル内のテキストを取得します。
  /// （Webでは利用できません）
  ///
  /// ファイルが見つからない場合、もしくは[uri]が`resource://`で始まる場合はFlutterのアセットフォルダからファイルを検索し、そのファイル内のテキストを取得します。
  ///
  /// [uri]が空の場合、もしくはテキストがなにかしらの原因で取得出来なかった場合は[defaultValue]が返されます。
  @useResult
  TextProvider call(
    String? uri, {
    Map<String, String>? headers,
    String defaultValue = "",
  }) {
    if (uri.isEmpty) {
      return TextProvider(defaultValue: defaultValue);
    }
    try {
      if (uri!.startsWith("http")) {
        return NetworkTextProvider(
          uri,
          headers: headers,
          defaultValue: defaultValue,
        );
      } else if (uri.startsWith("resource:")) {
        return AssetTextProvider(
          uri.replaceAll(RegExp(r"^resource:(//)?"), ""),
          defaultValue: defaultValue,
        );
      } else {
        return AssetTextProvider(
          uri,
          defaultValue: defaultValue,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      return TextProvider(defaultValue: defaultValue);
    }
  }
}

/// Class for providing implementation of [Asset.image].
///
/// [Asset.image]を実装を提供するためのクラス。
class ImageProviderBuilder with _ImageProviderBuilderMixin {
  const ImageProviderBuilder._();

  /// Retrieves files in the document folder.
  ///
  /// ドキュメントフォルダ内のファイルを取得します。
  DocumentImageProviderBuilder get document => throw UnimplementedError();

  /// Retrieves files in a temporary folder.
  ///
  /// テンポラリフォルダ内のファイルを取得します。
  TemporaryImageProviderBuilder get temporary => throw UnimplementedError();
}

/// Class for providing implementation of [Asset.image].
///
/// Retrieves files in the document folder.
///
/// [Asset.image]を実装を提供するためのクラス。
///
/// ドキュメントフォルダ内のファイルを取得します。
class DocumentImageProviderBuilder with _ImageProviderBuilderMixin {
  const DocumentImageProviderBuilder._();
}

/// Class for providing implementation of [Asset.image].
///
/// Retrieves files in the temporary folder.
///
/// [Asset.image]を実装を提供するためのクラス。
///
/// 一時フォルダ内のファイルを取得します。
class TemporaryImageProviderBuilder with _ImageProviderBuilderMixin {
  const TemporaryImageProviderBuilder._();
}

mixin _ImageProviderBuilderMixin {
  /// [ImageProvider] from the image file existing in [uri].
  ///
  /// If [uri] starts with `http://` or `https://`, images existing on the network are downloaded and retrieved.
  /// If you specify the Base64 encoded string of the image binary after `blob://`, you can retrieve the image file as it is.
  ///
  /// If [uri] starts with an absolute path of `file://` or `/`, a search is performed on the terminal file path and the image file is retrieved if the file exists.
  /// (Not available on the Web)
  ///
  /// If the file is not found, or [uri] starts with `resource://`, search for the file in Flutter's assets folder and retrieve the image file.
  ///
  /// If [uri] is empty, or the text cannot be retrieved for some reason, the image file located at [defaultAssetURI] in Flutter's assets folder will be returned. The default is `assets/image.png`.
  ///
  /// Request headers can be added with [headers] when retrieving images from the network.
  ///
  /// [uri]に存在する画像ファイルから[ImageProvider]を取得します。
  ///
  /// [uri]が`http://`、`https://`から始まる場合、ネットワーク上に存在する画像をダウンロードして取得します。
  /// `blob://`の後に画像バイナリのBase64エンコード文字列を指定するとその画像ファイルをそのまま取得することが可能です。
  ///
  /// [uri]が`file://`、または`/`の絶対パスで始まる場合、端末のファイルパスに対して検索を行い、ファイルが存在するときその画像ファイルを取得します。
  /// （Webでは利用できません）
  ///
  /// ファイルが見つからない場合、もしくは[uri]が`resource://`で始まる場合はFlutterのアセットフォルダからファイルを検索し、その画像ファイルを取得します。
  ///
  /// [uri]が空の場合、もしくはテキストがなにかしらの原因で取得出来なかった場合はFlutterのアセットフォルダ内の[defaultAssetURI]に存在する画像ファイルが返されます。デフォルトは`assets/image.png`。
  ///
  /// ネットワーク上から画像を取得する際に[headers]でリクエストヘッダを付与することが可能です。
  @useResult
  ImageProvider call(
    String? uri, {
    String defaultAssetURI = "assets/image.png",
    Map<String, String>? headers,
  }) {
    if (uri.isEmpty) {
      if (defaultAssetURI.endsWith("svg")) {
        return MemoizedAssetSvgImageProvider(defaultAssetURI);
      } else {
        return _MemoizedAssetImage(defaultAssetURI);
      }
    }
    try {
      if (uri!.startsWith("blob:")) {
        final blob = uri.replaceAll(RegExp(r"^blob:(//)?"), "");
        return MemoryImage(base64Url.decode(blob));
      } else if (uri.startsWith("http")) {
        if (uri.endsWith("svg")) {
          return MemoizedNetworkSvgImageProvider(
            uri,
            headers: headers,
          );
        } else {
          return _MemoizedNetworkImage(uri, headers: headers);
        }
      } else if (uri.startsWith("resource:")) {
        final path = uri.replaceAll(RegExp(r"^resource:(//)?"), "");
        if (path.endsWith("svg")) {
          return MemoizedAssetSvgImageProvider(
            path,
          );
        } else {
          return _MemoizedAssetImage(path);
        }
      } else {
        if (uri.endsWith("svg")) {
          return MemoizedAssetSvgImageProvider(
            uri,
          );
        } else {
          return _MemoizedAssetImage(uri);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
      if (defaultAssetURI.endsWith("svg")) {
        return MemoizedAssetSvgImageProvider(defaultAssetURI);
      } else {
        return _MemoizedAssetImage(defaultAssetURI);
      }
    }
  }
}

/// Memory cache for images.
///
/// 画像のメモリキャッシュ。
class ImageMemoryCache {
  const ImageMemoryCache._();

  static const int _maxCacheImages = 100;
  static final Map<String, ImageStreamCompleter> _manager = {};
  static final Map<String, ImageStreamCompleterHandle> _managerHandles = {};
  static final List<String> _savedImages = [];

  /// Get the cache for the image.
  ///
  /// 画像のキャッシュを取得します。
  static ImageStreamCompleter? getCache(String? key) {
    if (key.isEmpty) {
      return null;
    }
    if (_manager.containsKey(key)) {
      return _manager[key]!;
    }
    return null;
  }

  /// Set the cache for the image.
  ///
  /// 画像のキャッシュを設定します。
  static ImageStreamCompleter setCache(
    String? key,
    ImageStreamCompleter completer,
  ) {
    if (key.isEmpty) {
      return completer;
    }
    if (_savedImages.length == _maxCacheImages) {
      final removedUrl = _savedImages.removeAt(0);
      _manager.remove(removedUrl);
      _managerHandles[removedUrl]?.dispose();
      _managerHandles.remove(removedUrl);
    }
    _savedImages.add(key!);
    _manager[key] = completer;
    _managerHandles[key] = completer.keepAlive();
    return completer;
  }
}

class _MemoizedNetworkImage extends network_image.NetworkImage {
  const _MemoizedNetworkImage(super.url, {super.headers});

  @override
  ImageStreamCompleter loadImage(
      NetworkImage key, ImageDecoderCallback decode) {
    if (key.url.isEmpty) {
      return super.loadImage(key, decode);
    }
    final cache = ImageMemoryCache.getCache(key.url);
    if (cache != null) {
      return cache;
    }
    return ImageMemoryCache.setCache(key.url, super.loadImage(key, decode));
  }
}

class _MemoizedAssetImage extends AssetImage {
  const _MemoizedAssetImage(super.assetName);

  @override
  ImageStreamCompleter loadImage(
      AssetBundleImageKey key, ImageDecoderCallback decode) {
    if (key.name.isEmpty) {
      return super.loadImage(key, decode);
    }
    final cache = ImageMemoryCache.getCache(key.name);
    if (cache != null) {
      return cache;
    }
    return ImageMemoryCache.setCache(key.name, super.loadImage(key, decode));
  }
}
