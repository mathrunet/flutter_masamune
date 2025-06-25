// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations, prefer_const_declarations

part of 'repository.dart';

// **************************************************************************
// CollectionModelGenerator
// **************************************************************************

extension on RepositoryModel {
  Map<String, dynamic> get rawValue {
    return toJson();
  }
}

enum _$RepositoryModelKeys {
  name,
  fullName,
  description,
  private,
  id,
  htmlUrl,
  cloneUrl,
  sshUrl,
  owner,
  defaultBranch,
  language,
  stargazersCount,
  forksCount,
  openIssuesCount,
  createdAt,
  updatedAt,
  pushedAt,
}

class _$RepositoryModelDocument extends DocumentBase<RepositoryModel>
    with ModelRefMixin<RepositoryModel> {
  _$RepositoryModelDocument(super.modelQuery, [super._value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  RepositoryModel fromMap(DynamicMap map) => RepositoryModel.fromJson(map);

  @override
  DynamicMap toMap(RepositoryModel value) => value.rawValue;
}

typedef _$RepositoryModelMirrorDocument = _$RepositoryModelDocument;

class _$RepositoryModelCollection
    extends CollectionBase<_$RepositoryModelDocument>
    with
        FilterableCollectionMixin<_$RepositoryModelDocument,
            _$_RepositoryModelCollectionQuery> {
  _$RepositoryModelCollection(super.modelQuery, [super.value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  _$RepositoryModelDocument create([String? id]) =>
      _$RepositoryModelDocument(modelQuery.create(id));

  @override
  Future<CollectionBase<_$RepositoryModelDocument>> filter(
    _$_RepositoryModelCollectionQuery Function(
      _$_RepositoryModelCollectionQuery source,
    ) callback,
  ) {
    final query = callback.call(_$_RepositoryModelCollectionQuery(modelQuery));
    return replaceQuery((_) => query.modelQuery);
  }
}

typedef _$RepositoryModelMirrorCollection = _$RepositoryModelCollection;

@immutable
class _$RepositoryModelRefPath extends ModelRefPath<RepositoryModel> {
  const _$RepositoryModelRefPath(super.uid);

  @override
  DocumentModelQuery get modelQuery {
    return DocumentModelQuery(
      "repository/${path.trimQuery().trimString("/")}",
      adapter: adapter,
    );
  }
}

@immutable
class _$RepositoryModelInitialCollection
    extends ModelInitialCollection<RepositoryModel> {
  const _$RepositoryModelInitialCollection(super.value);

  @override
  String get path => "repository";

  @override
  DynamicMap toMap(RepositoryModel value) => value.rawValue;
}

@immutable
class _$RepositoryModelDocumentQuery {
  const _$RepositoryModelDocumentQuery();

  @useResult
  _$_RepositoryModelDocumentQuery call(
    Object _id, {
    ModelAdapter? adapter,
    bool useTestModelAdapter = true,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_RepositoryModelDocumentQuery(
      DocumentModelQuery(
        "repository/$_id",
        adapter: adapter ?? _$RepositoryModelDocument.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery:
            accessQuery ?? _$RepositoryModelDocument.defaultModelAccessQuery,
        validationQueries: _$RepositoryModelDocument.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(r"^repository/([^/]+)$".trimQuery().trimString("/"));
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_RepositoryModelDocumentQuery
    extends ModelQueryBase<_$RepositoryModelDocument> {
  const _$_RepositoryModelDocumentQuery(this.modelQuery);

  final DocumentModelQuery modelQuery;

  @override
  _$RepositoryModelDocument Function() call(Ref ref) =>
      () => _$RepositoryModelDocument(modelQuery);

  @override
  String get queryName => modelQuery.toString();
}

@immutable
class _$RepositoryModelCollectionQuery {
  const _$RepositoryModelCollectionQuery();

  @useResult
  _$_RepositoryModelCollectionQuery call({
    bool useTestModelAdapter = true,
    ModelAdapter? adapter,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_RepositoryModelCollectionQuery(
      CollectionModelQuery(
        "repository",
        adapter: adapter ?? _$RepositoryModelCollection.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery:
            accessQuery ?? _$RepositoryModelCollection.defaultModelAccessQuery,
        validationQueries: _$RepositoryModelCollection.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(r"^repository$".trimQuery().trimString("/"));
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_RepositoryModelCollectionQuery
    extends ModelQueryBase<_$RepositoryModelCollection> {
  const _$_RepositoryModelCollectionQuery(this.modelQuery);

  final CollectionModelQuery modelQuery;

  @override
  _$RepositoryModelCollection Function() call(Ref ref) =>
      () => _$RepositoryModelCollection(modelQuery);

  @override
  String get queryName => modelQuery.toString();

  static _$_RepositoryModelCollectionQuery _toQuery(
    CollectionModelQuery query,
  ) =>
      _$_RepositoryModelCollectionQuery(query);

  _$_RepositoryModelCollectionQuery collectionGroup() =>
      _$_RepositoryModelCollectionQuery(modelQuery.collectionGroup());

  _$_RepositoryModelCollectionQuery reset() =>
      _$_RepositoryModelCollectionQuery(modelQuery.reset());

  _$_RepositoryModelCollectionQuery remove(ModelQueryFilterType type) =>
      _$_RepositoryModelCollectionQuery(modelQuery.remove(type));

  _$_RepositoryModelCollectionQuery notifyDocumentChanges() =>
      _$_RepositoryModelCollectionQuery(modelQuery.notifyDocumentChanges());

  _$_RepositoryModelCollectionQuery limitTo(int value) =>
      _$_RepositoryModelCollectionQuery(modelQuery.limitTo(value));

  StringModelQuerySelector<_$_RepositoryModelCollectionQuery> get uid =>
      StringModelQuerySelector<_$_RepositoryModelCollectionQuery>(
        key: "@uid",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_RepositoryModelCollectionQuery> get name =>
      StringModelQuerySelector<_$_RepositoryModelCollectionQuery>(
        key: "name",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_RepositoryModelCollectionQuery> get fullName =>
      StringModelQuerySelector<_$_RepositoryModelCollectionQuery>(
        key: "fullName",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_RepositoryModelCollectionQuery> get description =>
      StringModelQuerySelector<_$_RepositoryModelCollectionQuery>(
        key: "description",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  BooleanModelQuerySelector<_$_RepositoryModelCollectionQuery> get private =>
      BooleanModelQuerySelector<_$_RepositoryModelCollectionQuery>(
        key: "private",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  NumModelQuerySelector<_$_RepositoryModelCollectionQuery> get id =>
      NumModelQuerySelector<_$_RepositoryModelCollectionQuery>(
        key: "id",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_RepositoryModelCollectionQuery> get htmlUrl =>
      StringModelQuerySelector<_$_RepositoryModelCollectionQuery>(
        key: "htmlUrl",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_RepositoryModelCollectionQuery> get cloneUrl =>
      StringModelQuerySelector<_$_RepositoryModelCollectionQuery>(
        key: "cloneUrl",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_RepositoryModelCollectionQuery> get sshUrl =>
      StringModelQuerySelector<_$_RepositoryModelCollectionQuery>(
        key: "sshUrl",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  MapModelQuerySelector<dynamic, _$_RepositoryModelCollectionQuery> get owner =>
      MapModelQuerySelector<dynamic, _$_RepositoryModelCollectionQuery>(
        key: "owner",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_RepositoryModelCollectionQuery>
      get defaultBranch =>
          StringModelQuerySelector<_$_RepositoryModelCollectionQuery>(
            key: "defaultBranch",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_RepositoryModelCollectionQuery> get language =>
      StringModelQuerySelector<_$_RepositoryModelCollectionQuery>(
        key: "language",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  NumModelQuerySelector<_$_RepositoryModelCollectionQuery>
      get stargazersCount =>
          NumModelQuerySelector<_$_RepositoryModelCollectionQuery>(
            key: "stargazersCount",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  NumModelQuerySelector<_$_RepositoryModelCollectionQuery> get forksCount =>
      NumModelQuerySelector<_$_RepositoryModelCollectionQuery>(
        key: "forksCount",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  NumModelQuerySelector<_$_RepositoryModelCollectionQuery>
      get openIssuesCount =>
          NumModelQuerySelector<_$_RepositoryModelCollectionQuery>(
            key: "openIssuesCount",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_RepositoryModelCollectionQuery> get createdAt =>
      StringModelQuerySelector<_$_RepositoryModelCollectionQuery>(
        key: "createdAt",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_RepositoryModelCollectionQuery> get updatedAt =>
      StringModelQuerySelector<_$_RepositoryModelCollectionQuery>(
        key: "updatedAt",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_RepositoryModelCollectionQuery> get pushedAt =>
      StringModelQuerySelector<_$_RepositoryModelCollectionQuery>(
        key: "pushedAt",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );
}

typedef _$RepositoryModelMirrorRefPath = _$RepositoryModelRefPath;
typedef _$RepositoryModelMirrorInitialCollection
    = _$RepositoryModelInitialCollection;

// **************************************************************************
// FormValueGenerator
// **************************************************************************

@immutable
class _$RepositoryModelFormQuery {
  const _$RepositoryModelFormQuery();

  @useResult
  _$_RepositoryModelFormQuery call(RepositoryModel value) {
    return _$_RepositoryModelFormQuery(value);
  }
}

@immutable
class _$_RepositoryModelFormQuery
    extends FormControllerQueryBase<RepositoryModel> {
  const _$_RepositoryModelFormQuery(this.value);

  final RepositoryModel value;

  @override
  FormController<RepositoryModel> Function() call(Ref ref) =>
      () => FormController(value);

  @override
  String get queryName => value.hashCode.toString();

  @override
  bool get autoDisposeWhenUnreferenced => true;
}
