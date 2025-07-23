// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations, prefer_const_declarations, unused_element_parameter, prefer_constructors_over_static_methods, matching_super_parameters, prefer_double_quotes, unused_local_variable, unnecessary_lambdas

part of 'github_organization.dart';

// **************************************************************************
// CollectionModelGenerator
// **************************************************************************

extension on GithubOrganizationModel {
  Map<String, dynamic> get rawValue {
    return toJson();
  }
}

enum _$GithubOrganizationModelKeys {
  id,
  name,
  login,
  company,
  blog,
  location,
  email,
  publicReposCount,
  publicGistsCount,
  followersCount,
  followingCount,
  htmlUrl,
  avatarUrl,
  type,
  createdAt,
  updatedAt,
}

class _$GithubOrganizationModelDocument
    extends DocumentBase<GithubOrganizationModel>
    with ModelRefMixin<GithubOrganizationModel> {
  _$GithubOrganizationModelDocument(super.modelQuery, [super._value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter =
      GithubModelMasamuneAdapter.primary.modelAdapter;

  @override
  GithubOrganizationModel fromMap(DynamicMap map) =>
      GithubOrganizationModel.fromJson(map);

  @override
  DynamicMap toMap(GithubOrganizationModel value) => value.rawValue;
}

typedef _$GithubOrganizationModelMirrorDocument
    = _$GithubOrganizationModelDocument;

class _$GithubOrganizationModelCollection
    extends CollectionBase<_$GithubOrganizationModelDocument>
    with
        FilterableCollectionMixin<_$GithubOrganizationModelDocument,
            _$_GithubOrganizationModelCollectionQuery> {
  _$GithubOrganizationModelCollection(super.modelQuery, [super.value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter =
      GithubModelMasamuneAdapter.primary.modelAdapter;

  @override
  _$GithubOrganizationModelDocument create([String? id]) =>
      _$GithubOrganizationModelDocument(modelQuery.create(id));

  @override
  Future<CollectionBase<_$GithubOrganizationModelDocument>> filter(
    _$_GithubOrganizationModelCollectionQuery Function(
      _$_GithubOrganizationModelCollectionQuery source,
    ) callback,
  ) {
    final query = callback.call(
      _$_GithubOrganizationModelCollectionQuery(modelQuery),
    );
    return replaceQuery((_) => query.modelQuery);
  }
}

typedef _$GithubOrganizationModelMirrorCollection
    = _$GithubOrganizationModelCollection;

@immutable
class _$GithubOrganizationModelRefPath
    extends ModelRefPath<GithubOrganizationModel> {
  const _$GithubOrganizationModelRefPath(super.uid);

  @override
  DocumentModelQuery get modelQuery {
    return DocumentModelQuery(
      "organization/${path.trimQuery().trimString("/")}",
      adapter: adapter,
    );
  }
}

@immutable
class _$GithubOrganizationModelInitialCollection
    extends ModelInitialCollection<GithubOrganizationModel> {
  const _$GithubOrganizationModelInitialCollection(super.value);

  @override
  String get path => "organization";

  @override
  DynamicMap toMap(GithubOrganizationModel value) => value.rawValue;
}

@immutable
class _$GithubOrganizationModelDocumentQuery {
  const _$GithubOrganizationModelDocumentQuery();

  @useResult
  _$_GithubOrganizationModelDocumentQuery call(
    Object _id, {
    ModelAdapter? adapter,
    bool useTestModelAdapter = true,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_GithubOrganizationModelDocumentQuery(
      DocumentModelQuery(
        "organization/$_id",
        adapter:
            adapter ?? _$GithubOrganizationModelDocument.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery: accessQuery ??
            _$GithubOrganizationModelDocument.defaultModelAccessQuery,
        validationQueries:
            _$GithubOrganizationModelDocument.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(r"^organization/([^/]+)$".trimQuery().trimString("/"));
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_GithubOrganizationModelDocumentQuery
    extends ModelQueryBase<_$GithubOrganizationModelDocument> {
  const _$_GithubOrganizationModelDocumentQuery(this.modelQuery);

  final DocumentModelQuery modelQuery;

  @override
  _$GithubOrganizationModelDocument Function() call(Ref ref) =>
      () => _$GithubOrganizationModelDocument(modelQuery);

  @override
  String get queryName => modelQuery.toString();
}

@immutable
class _$GithubOrganizationModelCollectionQuery {
  const _$GithubOrganizationModelCollectionQuery();

  @useResult
  _$_GithubOrganizationModelCollectionQuery call({
    bool useTestModelAdapter = true,
    ModelAdapter? adapter,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_GithubOrganizationModelCollectionQuery(
      CollectionModelQuery(
        "organization",
        adapter:
            adapter ?? _$GithubOrganizationModelCollection.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery: accessQuery ??
            _$GithubOrganizationModelCollection.defaultModelAccessQuery,
        validationQueries:
            _$GithubOrganizationModelCollection.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(r"^organization$".trimQuery().trimString("/"));
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_GithubOrganizationModelCollectionQuery
    extends ModelQueryBase<_$GithubOrganizationModelCollection> {
  const _$_GithubOrganizationModelCollectionQuery(this.modelQuery);

  final CollectionModelQuery modelQuery;

  @override
  _$GithubOrganizationModelCollection Function() call(Ref ref) =>
      () => _$GithubOrganizationModelCollection(modelQuery);

  @override
  String get queryName => modelQuery.toString();

  static _$_GithubOrganizationModelCollectionQuery _toQuery(
    CollectionModelQuery query,
  ) =>
      _$_GithubOrganizationModelCollectionQuery(query);

  _$_GithubOrganizationModelCollectionQuery collectionGroup() =>
      _$_GithubOrganizationModelCollectionQuery(modelQuery.collectionGroup());

  _$_GithubOrganizationModelCollectionQuery reset() =>
      _$_GithubOrganizationModelCollectionQuery(modelQuery.reset());

  _$_GithubOrganizationModelCollectionQuery remove(ModelQueryFilterType type) =>
      _$_GithubOrganizationModelCollectionQuery(modelQuery.remove(type));

  _$_GithubOrganizationModelCollectionQuery notifyDocumentChanges() =>
      _$_GithubOrganizationModelCollectionQuery(
        modelQuery.notifyDocumentChanges(),
      );

  _$_GithubOrganizationModelCollectionQuery limitTo(int value) =>
      _$_GithubOrganizationModelCollectionQuery(modelQuery.limitTo(value));

  StringModelQuerySelector<_$_GithubOrganizationModelCollectionQuery> get uid =>
      StringModelQuerySelector<_$_GithubOrganizationModelCollectionQuery>(
        key: "@uid",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  NumModelQuerySelector<_$_GithubOrganizationModelCollectionQuery> get id =>
      NumModelQuerySelector<_$_GithubOrganizationModelCollectionQuery>(
        key: "id",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_GithubOrganizationModelCollectionQuery>
      get name =>
          StringModelQuerySelector<_$_GithubOrganizationModelCollectionQuery>(
            key: "name",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubOrganizationModelCollectionQuery>
      get login =>
          StringModelQuerySelector<_$_GithubOrganizationModelCollectionQuery>(
            key: "login",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubOrganizationModelCollectionQuery>
      get company =>
          StringModelQuerySelector<_$_GithubOrganizationModelCollectionQuery>(
            key: "company",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubOrganizationModelCollectionQuery>
      get blog =>
          StringModelQuerySelector<_$_GithubOrganizationModelCollectionQuery>(
            key: "blog",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubOrganizationModelCollectionQuery>
      get location =>
          StringModelQuerySelector<_$_GithubOrganizationModelCollectionQuery>(
            key: "location",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubOrganizationModelCollectionQuery>
      get email =>
          StringModelQuerySelector<_$_GithubOrganizationModelCollectionQuery>(
            key: "email",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  NumModelQuerySelector<_$_GithubOrganizationModelCollectionQuery>
      get publicReposCount =>
          NumModelQuerySelector<_$_GithubOrganizationModelCollectionQuery>(
            key: "publicReposCount",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  NumModelQuerySelector<_$_GithubOrganizationModelCollectionQuery>
      get publicGistsCount =>
          NumModelQuerySelector<_$_GithubOrganizationModelCollectionQuery>(
            key: "publicGistsCount",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  NumModelQuerySelector<_$_GithubOrganizationModelCollectionQuery>
      get followersCount =>
          NumModelQuerySelector<_$_GithubOrganizationModelCollectionQuery>(
            key: "followersCount",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  NumModelQuerySelector<_$_GithubOrganizationModelCollectionQuery>
      get followingCount =>
          NumModelQuerySelector<_$_GithubOrganizationModelCollectionQuery>(
            key: "followingCount",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubOrganizationModelCollectionQuery>
      get htmlUrl =>
          ModelUriModelQuerySelector<_$_GithubOrganizationModelCollectionQuery>(
            key: "htmlUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelImageUriModelQuerySelector<_$_GithubOrganizationModelCollectionQuery>
      get avatarUrl => ModelImageUriModelQuerySelector<
              _$_GithubOrganizationModelCollectionQuery>(
          key: "avatarUrl", toQuery: _toQuery, modelQuery: modelQuery);

  ValueModelQuerySelector<GithubOrganizationType,
          _$_GithubOrganizationModelCollectionQuery>
      get type => ValueModelQuerySelector<GithubOrganizationType,
              _$_GithubOrganizationModelCollectionQuery>(
          key: "type", toQuery: _toQuery, modelQuery: modelQuery);

  ModelTimestampModelQuerySelector<_$_GithubOrganizationModelCollectionQuery>
      get createdAt => ModelTimestampModelQuerySelector<
              _$_GithubOrganizationModelCollectionQuery>(
          key: "createdAt", toQuery: _toQuery, modelQuery: modelQuery);

  ModelTimestampModelQuerySelector<_$_GithubOrganizationModelCollectionQuery>
      get updatedAt => ModelTimestampModelQuerySelector<
              _$_GithubOrganizationModelCollectionQuery>(
          key: "updatedAt", toQuery: _toQuery, modelQuery: modelQuery);
}

typedef _$GithubOrganizationModelMirrorRefPath
    = _$GithubOrganizationModelRefPath;
typedef _$GithubOrganizationModelMirrorInitialCollection
    = _$GithubOrganizationModelInitialCollection;

// **************************************************************************
// FormValueGenerator
// **************************************************************************

@immutable
class _$GithubOrganizationModelFormQuery {
  const _$GithubOrganizationModelFormQuery();

  @useResult
  _$_GithubOrganizationModelFormQuery call(GithubOrganizationModel value) {
    return _$_GithubOrganizationModelFormQuery(value);
  }
}

@immutable
class _$_GithubOrganizationModelFormQuery
    extends FormControllerQueryBase<GithubOrganizationModel> {
  const _$_GithubOrganizationModelFormQuery(this.value);

  final GithubOrganizationModel value;

  @override
  FormController<GithubOrganizationModel> Function() call(Ref ref) =>
      () => FormController(value);

  @override
  String get queryName => value.hashCode.toString();

  @override
  bool get autoDisposeWhenUnreferenced => true;
}
