part of katana_model;

/// Class for defining relationships between models.
///
/// You can have that relationship as data by passing a query for the related document to [modelQuery].
///
/// Since it is a mutable class and has an interface to [DocumentBase], it can be replaced by [DocumentBase] by implementing [ModelRef] and mixing in [ModelRefMixin].
///
/// モデル間のリレーションを定義するためのクラス。
///
/// [modelQuery]に関連するドキュメントのクエリーを渡すことでそのリレーションをデータとして持つことができます。
///
/// ミュータブルクラスでかつ[DocumentBase]のインターフェースを備えているため[ModelRef]を実装し、[ModelRefMixin]をミックスインすることで[DocumentBase]で置き換えることが可能です。
typedef ModelRef<T> = ModelRefBase<T>?;

class _ModelRefBase<T> extends ModelRefBase<T>
    with ModelFieldValueAsMapMixin<T?> {
  const _ModelRefBase(super.modelQuery);
}

/// Class for defining relationships between models.
///
/// You can have that relationship as data by passing a query for the related document to [modelQuery].
///
/// Since it is a mutable class and has an interface to [DocumentBase], it can be replaced by [DocumentBase] by implementing [ModelRefBase] and mixing in [ModelRefMixin].
///
/// モデル間のリレーションを定義するためのクラス。
///
/// [modelQuery]に関連するドキュメントのクエリーを渡すことでそのリレーションをデータとして持つことができます。
///
/// ミュータブルクラスでかつ[DocumentBase]のインターフェースを備えているため[ModelRefBase]を実装し、[ModelRefMixin]をミックスインすることで[DocumentBase]で置き換えることが可能です。
class ModelRefBase<T> extends ModelFieldValue<T?> {
  /// Class for defining relationships between models.
  ///
  /// You can have that relationship as data by passing a query for the related document to [modelQuery].
  ///
  /// Since it is a mutable class and has an interface to [DocumentBase], it can be replaced by [DocumentBase] by implementing [ModelRefBase] and mixing in [ModelRefMixin].
  ///
  /// モデル間のリレーションを定義するためのクラス。
  ///
  /// [modelQuery]に関連するドキュメントのクエリーを渡すことでそのリレーションをデータとして持つことができます。
  ///
  /// ミュータブルクラスでかつ[DocumentBase]のインターフェースを備えているため[ModelRefBase]を実装し、[ModelRefMixin]をミックスインすることで[DocumentBase]で置き換えることが可能です。
  const ModelRefBase(this.modelQuery);

  /// Class for defining relationships between models.
  ///
  /// By passing the path of the related document in [path], you can have that relationship as data.
  ///
  /// It is also possible to set a model adapter by specifying [adapter].
  ///
  /// Since it is a mutable class and has an interface to [DocumentBase], it can be replaced by [DocumentBase] by implementing [ModelRefBase] and mixing in [ModelRefMixin].
  ///
  /// モデル間のリレーションを定義するためのクラス。
  ///
  /// [path]に関連するドキュメントのパスを渡すことでそのリレーションをデータとして持つことができます。
  ///
  /// また[adapter]を指定してモデルアダプターを設定することが可能です。
  ///
  /// ミュータブルクラスでかつ[DocumentBase]のインターフェースを備えているため[ModelRefBase]を実装し、[ModelRefMixin]をミックスインすることで[DocumentBase]で置き換えることが可能です。
  factory ModelRefBase.fromPath(String path, [ModelAdapter? adapter]) {
    return _ModelRefBase(
      DocumentModelQuery(
        path.trimQuery().trimString("/"),
        adapter: adapter,
      ),
    );
  }

  /// Convert from [json] map to [ModelRefBase].
  ///
  /// [json]のマップから[ModelRefBase]に変換します。
  factory ModelRefBase.fromJson(Map<String, dynamic> json) {
    return ModelRefBase.fromPath(json.get(ModelRefBase._kRefKey, ""));
  }

  static const _kRefKey = "@ref";

  /// [DocumentModelQuery] of the associated document.
  ///
  /// 関連するドキュメントの[DocumentModelQuery].
  final DocumentModelQuery modelQuery;

  @override
  Map<String, dynamic> toJson() => {
        kTypeFieldKey: (ModelRefBase).toString(),
        ModelRefBase._kRefKey: modelQuery.path.trimQuery().trimString("/"),
      };

  /// Actual value.
  ///
  /// [Null] is returned.
  ///
  /// 実際の値。
  ///
  /// [Null]が返されます。
  @override
  T? get value {
    return null;
  }

  /// Returns the ID for the document path.
  ///
  /// ドキュメントのパス用のIDを返します。
  String get uid {
    return modelQuery.path.trimQuery().trimString("/").split("/").lastOrNull ??
        "";
  }

  @override
  String toString() {
    return modelQuery.path;
  }
}

/// [ModelFieldValueConverter] to enable automatic conversion of [ModelRefBase] as [ModelFieldValue].
///
/// [ModelRefBase]を[ModelFieldValue]として自動変換できるようにするための[ModelFieldValueConverter]。
@immutable
class ModelRefConverter extends ModelFieldValueConverter<ModelRefBase> {
  /// [ModelFieldValueConverter] to enable automatic conversion of [ModelRefBase] as [ModelFieldValue].
  ///
  /// [ModelRefBase]を[ModelFieldValue]として自動変換できるようにするための[ModelFieldValueConverter]。
  const ModelRefConverter();

  @override
  ModelRefBase fromJson(Map<String, Object?> map) {
    return ModelRefBase.fromJson(map);
  }

  @override
  Map<String, Object?> toJson(ModelRefBase value) {
    return value.toJson();
  }
}

/// Filter class to make [ModelRefBase] available to [ModelQuery.filters].
///
/// [ModelRefBase]を[ModelQuery.filters]で利用できるようにするためのフィルタークラス。
@immutable
class ModelRefFilter extends ModelFieldValueFilter<ModelRefBase> {
  /// Filter class to make [ModelRefBase] available to [ModelQuery.filters].
  ///
  /// [ModelRefBase]を[ModelQuery.filters]で利用できるようにするためのフィルタークラス。
  const ModelRefFilter();

  @override
  int? compare(dynamic a, dynamic b) {
    return _hasMatch(a, b, (a, b) => a.compareTo(b));
  }

  @override
  bool? hasMatch(ModelQueryFilter filter, dynamic source) {
    final target = filter.value;
    switch (filter.type) {
      case ModelQueryFilterType.equalTo:
        return _hasMatch(source, target, (source, target) => source == target);
      case ModelQueryFilterType.notEqualTo:
        return _hasMatch(source, target, (source, target) => source != target);
      case ModelQueryFilterType.arrayContains:
        if (source is List) {
          if (source.any((s) =>
              _hasMatch(s, target, (source, target) => source == target) ??
              false)) {
            return true;
          }
        }
        break;
      case ModelQueryFilterType.arrayContainsAny:
        if (source is List && target is List && target.isNotEmpty) {
          if (source.any((s) => target.any((t) =>
              _hasMatch(s, t, (source, target) => source == target) ??
              false))) {
            return true;
          }
        }
        break;
      case ModelQueryFilterType.whereIn:
        if (target is List && target.isNotEmpty) {
          final matches = target.mapAndRemoveEmpty((t) =>
              _hasMatch(source, t, (source, target) => source == target));
          if (matches.isNotEmpty) {
            return matches.any((element) => element);
          }
        }
        break;
      case ModelQueryFilterType.whereNotIn:
        if (target is List && target.isNotEmpty) {
          final matches = target.mapAndRemoveEmpty((t) =>
              _hasMatch(source, t, (source, target) => source == target));
          if (matches.isNotEmpty) {
            return !matches.any((element) => element);
          }
        }
        break;
      default:
        return null;
    }
    return null;
  }

  T? _hasMatch<T>(
    dynamic source,
    dynamic target,
    T Function(String source, String target) filter,
  ) {
    if (source is ModelRefBase && target is ModelRefBase) {
      return filter(source.modelQuery.path, target.modelQuery.path);
    } else if (source is ModelRefBase && target is DocumentModelQuery) {
      return filter(source.modelQuery.path, target.path);
    } else if (source is DocumentModelQuery && target is ModelRefBase) {
      return filter(source.path, target.modelQuery.path);
    } else if (source is ModelRefBase && target is String) {
      return filter(source.modelQuery.path, target);
    } else if (source is String && target is ModelRefBase) {
      return filter(source, target.modelQuery.path);
    } else if (source is ModelRefBase &&
        target is DynamicMap &&
        target.get(kTypeFieldKey, "") == (ModelRefBase).toString()) {
      return filter(source.modelQuery.path,
          ModelRefBase.fromJson(target).modelQuery.path);
    } else if (source is DynamicMap &&
        target is ModelRefBase &&
        source.get(kTypeFieldKey, "") == (ModelRefBase).toString()) {
      return filter(ModelRefBase.fromJson(source).modelQuery.path,
          target.modelQuery.path);
    } else if (source is DynamicMap &&
        target is DynamicMap &&
        source.get(kTypeFieldKey, "") == (ModelRefBase).toString() &&
        target.get(kTypeFieldKey, "") == (ModelRefBase).toString()) {
      return filter(ModelRefBase.fromJson(source).modelQuery.path,
          ModelRefBase.fromJson(target).modelQuery.path);
    }
    return null;
  }
}

/// A mix-in to define that it is a relationship between models in [DocumentBase], etc.
///
/// Mix in the document to which you are relating.
///
/// [DocumentBase]などにモデル間のリレーションであるということを定義するためのミックスイン。
///
/// リレーション先のドキュメントにミックスインしてください。
abstract class ModelRefMixin<T>
    implements ModelRefDocumentBase<T>, ModelRefBase<T>, DocumentBase<T> {
  @override
  Map<String, dynamic> toJson() => {
        kTypeFieldKey: (ModelRefBase).toString(),
        ModelRefBase._kRefKey: modelQuery.path.trimQuery().trimString("/"),
      };
}

/// Define a document base including [ModelRefBase] and [DocumentBase].
///
/// [ModelRefBase]と[DocumentBase]を含めたドキュメントベースを定義します。
abstract class ModelRefDocumentBase<T>
    implements ModelRefBase<T>, DocumentBase<T> {}

/// It is available by mixing in when using [ModelRefBase] in [DocumentBase.value].
///
/// When data is loaded in [DocumentBase.load], the data in [ModelRefBase] is automatically loaded and stored.
///
/// Define [builder] to store relevant documents and data.
///
/// Mix in the document from which you are relaying.
///
/// [DocumentBase.value]で[ModelRefBase]を利用している際にミックスインすることで利用できます。
///
/// [DocumentBase.load]でデータをロードする際に合わせて[ModelRefBase]内のデータを自動でロードして格納します。
///
/// [builder]を定義して関連するドキュメントとデータの格納を行ってください。
///
/// リレーション元のドキュメントにミックスインしてください。
abstract class ModelRefLoaderMixin<T> implements DocumentBase<T> {
  final _modelRefBuilderCache = <DocumentModelQuery, ModelRefMixin>{};

  /// ModelRefBuilder], which implements the definition of the loading method.
  ///
  /// Data is loaded and stored in the order listed.
  ///
  /// ロード方法の定義を実装した[ModelRefBuilder]。
  ///
  /// リストの順番通りにデータのロードと格納が行われます。
  List<ModelRefBuilderBase<T>> get builder;

  @override
  @protected
  @mustCallSuper
  Future<T?> filterOnDidLoad(T? value) async {
    final builderList = builder;
    var tmpValue = value;
    for (final build in builderList) {
      if (tmpValue == null) {
        continue;
      }
      tmpValue = await build._build(
        val: tmpValue,
        cacheList: _modelRefBuilderCache,
        onDidLoad: (query, modelRefMixin) {
          modelRefMixin.addListener(notifyListeners);
          _modelRefBuilderCache[query] = modelRefMixin;
        },
        loaderModelQuery: modelQuery,
      );
    }
    return tmpValue;
  }

  @override
  @protected
  @mustCallSuper
  void dispose() {
    for (final cache in _modelRefBuilderCache.values) {
      cache.removeListener(notifyListeners);
      cache.dispose();
    }
  }
}

/// Builder for granting relationships between models and loading data.
///
/// Define [ModelRefLoaderMixin] to match the mix-in.
///
/// The procedure is;
///
/// 1. Returns a [ModelRefBase] containing only the relation information stored in [TSource] via [modelRef].
/// 2. Generates and returns a mixed-in [DocumentBase] with [ModelRefMixin<TResult>] based on [DocumentModelQuery] via [document].
/// 3. Store the [DocumentBase] generated via [value] in [TSource] and return the updated [TSource].
///
/// モデル間のリレーションを付与しデータのロードを行うためのビルダー。
///
/// [ModelRefLoaderMixin]をミックスインしたときに合わせて定義します。
///
/// 手順としては
///
/// 1. [TSource]に保存されているリレーション情報のみ入った[ModelRefBase]を[modelRef]経由で返します。
/// 2. [DocumentModelQuery]を元に[ModelRefMixin<TResult>]をミックスインした[DocumentBase]を[document]経由で生成し返します。
/// 3. [value]経由で生成された[DocumentBase]を[TSource]に保存して、更新した[TSource]を返すようにします。
///
/// ```dart
/// @override
/// List<ModelRefBuilderBase<StreamModel>> get builder => [
///       ModelRefBuilder(
///         modelRef: (value) => value.user,
///         document: (query) => UserModelDocument(query),
///         value: (value, document) {
///           return value.copyWith(user: document);
///         },
///       )
///     ];
/// ```
@immutable
class ModelRefBuilder<TSource, TResult> extends ModelRefBuilderBase<TSource> {
  /// Builder for granting relationships between models and loading data.
  ///
  /// Define [ModelRefLoaderMixin] to match the mix-in.
  ///
  /// The procedure is;
  ///
  /// 1. Returns a [ModelRefBase] containing only the relation information stored in [TSource] via [modelRef].
  /// 2. Generates and returns a mixed-in [DocumentBase] with [ModelRefMixin<TResult>] based on [DocumentModelQuery] via [document].
  /// 3. Store the [DocumentBase] generated via [value] in [TSource] and return the updated [TSource].
  ///
  /// モデル間のリレーションを付与しデータのロードを行うためのビルダー。
  ///
  /// [ModelRefLoaderMixin]をミックスインしたときに合わせて定義します。
  ///
  /// 手順としては
  ///
  /// 1. [TSource]に保存されているリレーション情報のみ入った[ModelRefBase]を[modelRef]経由で返します。
  /// 2. [DocumentModelQuery]を元に[ModelRefMixin<TResult>]をミックスインした[DocumentBase]を[document]経由で生成し返します。
  /// 3. [value]経由で生成された[DocumentBase]を[TSource]に保存して、更新した[TSource]を返すようにします。
  ///
  /// ```dart
  /// @override
  /// List<ModelRefBuilderBase<StreamModel>> get builder => [
  ///       ModelRefBuilder(
  ///         modelRef: (value) => value.user,
  ///         document: (query) => UserModelDocument(query),
  ///         value: (value, document) {
  ///           return value.copyWith(user: document);
  ///         },
  ///       )
  ///     ];
  /// ```
  const ModelRefBuilder({
    required this.modelRef,
    required this.document,
    required this.value,
  });

  /// Callback to retrieve [ModelRefBase] stored in [TSource].
  ///
  /// [TSource]に格納されている[ModelRefBase]を取得するためのコールバック。
  final ModelRefBase? Function(TSource value) modelRef;

  /// Callback to generate a [DocumentBase] that mixes in a [ModelRefMixin<TResult>] based on a [DocumentModelQuery] obtained from a [ModelRefBase].
  ///
  /// [ModelRefBase]から取得された[DocumentModelQuery]を元に[ModelRefMixin<TResult>]をミックスインした[DocumentBase]を生成するためのコールバック。
  final ModelRefMixin<TResult> Function(DocumentModelQuery modelQuery) document;

  /// Callback to store the generated [ModelRefMixin<TResult>] in [TSource].
  ///
  /// [TSource]に生成された[ModelRefMixin<TResult>]を格納するためのコールバック。
  final TSource Function(
    TSource value,
    ModelRefMixin<TResult> document,
  ) value;

  @override
  Future<TSource?> _build({
    required TSource? val,
    required Map<DocumentModelQuery, ModelRefMixin> cacheList,
    required void Function(
            DocumentModelQuery query, ModelRefMixin modelRefMixin)
        onDidLoad,
    required DocumentModelQuery loaderModelQuery,
  }) async {
    if (val == null) {
      return val;
    }
    final ref = modelRef(val);
    if (ref == null) {
      return val;
    }
    final modelQuery = DocumentModelQuery(
      ref.modelQuery.path,
      adapter: loaderModelQuery.adapter,
    );
    if (cacheList.containsKey(modelQuery)) {
      final doc = cacheList[modelQuery];
      if (doc is ModelRefMixin<TResult>) {
        return value(val, doc);
      }
    }
    final doc = document(modelQuery);
    assert(
      doc.modelQuery == modelQuery,
      "The document was created with a different [DocumentModelQuery] than [ModelRef]. Please match [DocumentModelQuery]: ${doc.modelQuery}, $modelQuery",
    );
    await doc.load();
    onDidLoad(modelQuery, doc);
    return value(val, doc);
  }
}

/// Base class for defining [ModelRefBuilder].
///
/// The actual definition is done using [ModelRefBuilder].
///
/// [ModelRefBuilder]を定義するためのベースクラス。
///
/// 実際の定義は[ModelRefBuilder]を利用します。
@immutable
abstract class ModelRefBuilderBase<TSource> {
  /// Base class for defining [ModelRefBuilder].
  ///
  /// The actual definition is done using [ModelRefBuilder].
  ///
  /// [ModelRefBuilder]を定義するためのベースクラス。
  ///
  /// 実際の定義は[ModelRefBuilder]を利用します。
  const ModelRefBuilderBase();

  Future<TSource?> _build({
    required TSource? val,
    required Map<DocumentModelQuery, ModelRefMixin> cacheList,
    required void Function(
            DocumentModelQuery query, ModelRefMixin modelRefMixin)
        onDidLoad,
    required DocumentModelQuery loaderModelQuery,
  });
}
