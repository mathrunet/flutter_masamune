part of masamune;

final wordpressCollectionProvider =
    ModelProvider.family<WordpressCollectionModel, String>(
  (_, endpoint) => WordpressCollectionModel(endpoint),
);

class WordpressQuery {
  const WordpressQuery(
    this.path, {
    this.categories = const [],
  });

  final String path;
  final List<int> categories;

  String get value {
    var tmp = "$path?key=";
    if (categories.isNotEmpty) {
      tmp = "$tmp&categories=${categories.join(",")}";
    }
    return tmp;
  }
}

class WordpressCollectionModel extends ApiDynamicCollectionModel {
  WordpressCollectionModel(String endpoint)
      : paramaters = _getParamaters(endpoint),
        super(_getPath(endpoint));

  static String _getPath(String path) {
    if (path.contains("?")) {
      return path.split("?").first;
    }
    return path;
  }

  static Map<String, dynamic> _getParamaters(String path) {
    if (path.contains("?")) {
      final params = Uri.parse(path).queryParameters;
      return <String, dynamic>{
        if (params.containsKey("categories"))
          "categories": params
              .get("categories", "")
              .split(",")
              .mapAndRemoveEmpty((e) => int.tryParse(e)),
      };
    }
    return const {};
  }

  final Map<String, dynamic> paramaters;
  late final WordPress.WordPressAPI _wordpress;

  @override
  void initState() {
    super.initState();
    _wordpress = WordPress.WordPressAPI(endpoint);
  }

  /// The actual loading process is done from the API when it is loaded.
  ///
  /// By overriding, it is possible to use plugins, etc.
  /// in addition to simply retrieving from the URL.
  @override
  @protected
  Future<void> loadRequest() async {
    final res = await _wordpress.posts.fetch(args: paramaters);
    if (res.statusCode != 200) {
      throw Exception("Could not retrieve data from wordpress.");
    }
    onCatchResponse(res);
    final posts = (res.data as List<WordPress.Post>)
        .mapAndRemoveEmpty((item) => item.toMap());
    await Future.wait(posts.mapAndRemoveEmpty((e) async {
      final featuredMedia = e.get("featured_media", 0);
      if (featuredMedia.isEmpty) {
        e["image"] = null;
        return;
      }
      final media = await _wordpress.media.fetch(id: featuredMedia);
      e["image"] = media.data.sourceUrl;
    }));
    final data = fromCollection(filterOnLoad(posts));
    addAll(data);
  }

  /// The actual loading process is done from the API when it is saved.
  ///
  /// By overriding, it is possible to use plugins, etc.
  /// in addition to simply saving to the URL.
  @override
  @protected
  Future<void> saveRequest() async {
    throw UnimplementedError();
  }
}
