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
  ModelRefBase(this.modelQuery);

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
    return ModelRefBase(
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
    return ModelRefBase.fromPath(json.get(_kRefKey, ""));
  }

  /// A string of type [ModelRefBase].
  ///
  /// [ModelRefBase]のタイプの文字列。
  static const typeString = "ModelRef";

  /// [DocumentModelQuery] of the associated document.
  ///
  /// 関連するドキュメントの[DocumentModelQuery].
  final DocumentModelQuery modelQuery;

  static const _kRefKey = "@ref";

  @override
  Map<String, dynamic> toJson() => {
        kTypeFieldKey: runtimeType.toString(),
        _kRefKey: modelQuery.path.trimQuery().trimString("/"),
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

  @override
  String toString() {
    return modelQuery.path;
  }
}

/// A mix-in to define that it is a relationship between models in [DocumentBase], etc.
///
/// Mix in the document to which you are relating.
///
/// [DocumentBase]などにモデル間のリレーションであるということを定義するためのミックスイン。
///
/// リレーション先のドキュメントにミックスインしてください。
abstract class ModelRefMixin<T> implements ModelRefBase<T>, DocumentBase<T> {
  @override
  Map<String, dynamic> toJson() => {
        kTypeFieldKey: runtimeType.toString(),
        ModelRefBase._kRefKey: modelQuery.path.trimQuery().trimString("/"),
      };
}

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
  final _modelRefBuilderCache = <DocumentModelQuery, DocumentBase>{};

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
  Future<T?> filterOnDidLoad(T? value, [bool listenWhenPossible = true]) async {
    final builderList = builder;
    var _value = value;
    for (final build in builderList) {
      if (_value == null) {
        continue;
      }
      _value = await build._build(
        val: _value,
        listenWhenPossible: listenWhenPossible,
        cacheList: _modelRefBuilderCache,
        onDidLoad: (query, document) {
          document.addListener(notifyListeners);
          _modelRefBuilderCache[query] = document;
        },
        loaderModelQuery: modelQuery,
      );
    }
    return _value;
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
    required bool listenWhenPossible,
    required Map<DocumentModelQuery, DocumentBase> cacheList,
    required void Function(DocumentModelQuery query, DocumentBase document)
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
      return val;
    }
    final doc = document(modelQuery);
    assert(
      doc.modelQuery == modelQuery,
      "The document was created with a different [DocumentModelQuery] than [ModelRef]. Please match [DocumentModelQuery]: ${doc.modelQuery}, $modelQuery",
    );
    await doc.load(listenWhenPossible);
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
    required bool listenWhenPossible,
    required Map<DocumentModelQuery, DocumentBase> cacheList,
    required void Function(DocumentModelQuery query, DocumentBase document)
        onDidLoad,
    required DocumentModelQuery loaderModelQuery,
  });
}
