// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations, prefer_const_declarations, unused_element_parameter, prefer_constructors_over_static_methods, matching_super_parameters, prefer_double_quotes, unused_local_variable, unnecessary_lambdas

part of 'github_user.dart';

// **************************************************************************
// CollectionModelGenerator
// **************************************************************************

extension on GithubUserModel {
  Map<String, dynamic> get rawValue {
    return toJson();
  }
}

enum _$GithubUserModelKeys {
  id,
  login,
  name,
  company,
  blog,
  bio,
  location,
  email,
  xUsername,
  nodeId,
  type,
  siteAdmin,
  hirable,
  publicReposCount,
  publicGistsCount,
  followersCount,
  followingCount,
  avatarUrl,
  gravatarId,
  htmlUrl,
  userUrl,
  eventsUrl,
  followersUrl,
  followingUrl,
  gistsUrl,
  organizationsUrl,
  receivedEventsUrl,
  reposUrl,
  starredUrl,
  subscriptionsUrl,
  starredAt,
  createdAt,
  updatedAt,
}

class _$GithubUserModelDocument extends DocumentBase<GithubUserModel>
    with ModelRefMixin<GithubUserModel> {
  _$GithubUserModelDocument(super.modelQuery, [super._value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter =
      GithubModelMasamuneAdapter.primary.modelAdapter;

  @override
  GithubUserModel fromMap(DynamicMap map) => GithubUserModel.fromJson(map);

  @override
  DynamicMap toMap(GithubUserModel value) => value.rawValue;
}

typedef _$GithubUserModelMirrorDocument = _$GithubUserModelDocument;

class _$GithubUserModelCollection
    extends CollectionBase<_$GithubUserModelDocument>
    with
        FilterableCollectionMixin<_$GithubUserModelDocument,
            _$_GithubUserModelCollectionQuery> {
  _$GithubUserModelCollection(super.modelQuery, [super.value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter =
      GithubModelMasamuneAdapter.primary.modelAdapter;

  @override
  _$GithubUserModelDocument create([String? id]) =>
      _$GithubUserModelDocument(modelQuery.create(id));

  @override
  Future<CollectionBase<_$GithubUserModelDocument>> filter(
    _$_GithubUserModelCollectionQuery Function(
      _$_GithubUserModelCollectionQuery source,
    ) callback,
  ) {
    final query = callback.call(_$_GithubUserModelCollectionQuery(modelQuery));
    return replaceQuery((_) => query.modelQuery);
  }
}

typedef _$GithubUserModelMirrorCollection = _$GithubUserModelCollection;

@immutable
class _$GithubUserModelRefPath extends ModelRefPath<GithubUserModel> {
  const _$GithubUserModelRefPath(super.uid);

  @override
  DocumentModelQuery get modelQuery {
    return DocumentModelQuery(
      "owner/${path.trimQuery().trimString("/")}",
      adapter: adapter,
    );
  }
}

@immutable
class _$GithubUserModelInitialCollection
    extends ModelInitialCollection<GithubUserModel> {
  const _$GithubUserModelInitialCollection(super.value);

  @override
  String get path => "owner";

  @override
  DynamicMap toMap(GithubUserModel value) => value.rawValue;
}

@immutable
class _$GithubUserModelDocumentQuery {
  const _$GithubUserModelDocumentQuery();

  @useResult
  _$_GithubUserModelDocumentQuery call(
    Object _id, {
    ModelAdapter? adapter,
    bool useTestModelAdapter = true,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_GithubUserModelDocumentQuery(
      DocumentModelQuery(
        "owner/$_id",
        adapter: adapter ?? _$GithubUserModelDocument.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery:
            accessQuery ?? _$GithubUserModelDocument.defaultModelAccessQuery,
        validationQueries: _$GithubUserModelDocument.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(r"^owner/([^/]+)$".trimQuery().trimString("/"));
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_GithubUserModelDocumentQuery
    extends ModelQueryBase<_$GithubUserModelDocument> {
  const _$_GithubUserModelDocumentQuery(this.modelQuery);

  final DocumentModelQuery modelQuery;

  @override
  _$GithubUserModelDocument Function() call(Ref ref) =>
      () => _$GithubUserModelDocument(modelQuery);

  @override
  String get queryName => modelQuery.toString();
}

@immutable
class _$GithubUserModelCollectionQuery {
  const _$GithubUserModelCollectionQuery();

  @useResult
  _$_GithubUserModelCollectionQuery call({
    bool useTestModelAdapter = true,
    ModelAdapter? adapter,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_GithubUserModelCollectionQuery(
      CollectionModelQuery(
        "owner",
        adapter: adapter ?? _$GithubUserModelCollection.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery:
            accessQuery ?? _$GithubUserModelCollection.defaultModelAccessQuery,
        validationQueries: _$GithubUserModelCollection.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(r"^owner$".trimQuery().trimString("/"));
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_GithubUserModelCollectionQuery
    extends ModelQueryBase<_$GithubUserModelCollection> {
  const _$_GithubUserModelCollectionQuery(this.modelQuery);

  final CollectionModelQuery modelQuery;

  @override
  _$GithubUserModelCollection Function() call(Ref ref) =>
      () => _$GithubUserModelCollection(modelQuery);

  @override
  String get queryName => modelQuery.toString();

  static _$_GithubUserModelCollectionQuery _toQuery(
    CollectionModelQuery query,
  ) =>
      _$_GithubUserModelCollectionQuery(query);

  _$_GithubUserModelCollectionQuery collectionGroup() =>
      _$_GithubUserModelCollectionQuery(modelQuery.collectionGroup());

  _$_GithubUserModelCollectionQuery reset() =>
      _$_GithubUserModelCollectionQuery(modelQuery.reset());

  _$_GithubUserModelCollectionQuery remove(ModelQueryFilterType type) =>
      _$_GithubUserModelCollectionQuery(modelQuery.remove(type));

  _$_GithubUserModelCollectionQuery notifyDocumentChanges() =>
      _$_GithubUserModelCollectionQuery(modelQuery.notifyDocumentChanges());

  _$_GithubUserModelCollectionQuery limitTo(int value) =>
      _$_GithubUserModelCollectionQuery(modelQuery.limitTo(value));

  StringModelQuerySelector<_$_GithubUserModelCollectionQuery> get uid =>
      StringModelQuerySelector<_$_GithubUserModelCollectionQuery>(
        key: "@uid",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  NumModelQuerySelector<_$_GithubUserModelCollectionQuery> get id =>
      NumModelQuerySelector<_$_GithubUserModelCollectionQuery>(
        key: "id",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_GithubUserModelCollectionQuery> get login =>
      StringModelQuerySelector<_$_GithubUserModelCollectionQuery>(
        key: "login",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_GithubUserModelCollectionQuery> get name =>
      StringModelQuerySelector<_$_GithubUserModelCollectionQuery>(
        key: "name",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_GithubUserModelCollectionQuery> get company =>
      StringModelQuerySelector<_$_GithubUserModelCollectionQuery>(
        key: "company",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_GithubUserModelCollectionQuery> get blog =>
      StringModelQuerySelector<_$_GithubUserModelCollectionQuery>(
        key: "blog",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_GithubUserModelCollectionQuery> get bio =>
      StringModelQuerySelector<_$_GithubUserModelCollectionQuery>(
        key: "bio",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_GithubUserModelCollectionQuery> get location =>
      StringModelQuerySelector<_$_GithubUserModelCollectionQuery>(
        key: "location",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_GithubUserModelCollectionQuery> get email =>
      StringModelQuerySelector<_$_GithubUserModelCollectionQuery>(
        key: "email",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_GithubUserModelCollectionQuery> get xUsername =>
      StringModelQuerySelector<_$_GithubUserModelCollectionQuery>(
        key: "xUsername",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_GithubUserModelCollectionQuery> get nodeId =>
      StringModelQuerySelector<_$_GithubUserModelCollectionQuery>(
        key: "nodeId",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_GithubUserModelCollectionQuery> get type =>
      StringModelQuerySelector<_$_GithubUserModelCollectionQuery>(
        key: "type",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  BooleanModelQuerySelector<_$_GithubUserModelCollectionQuery> get siteAdmin =>
      BooleanModelQuerySelector<_$_GithubUserModelCollectionQuery>(
        key: "siteAdmin",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  BooleanModelQuerySelector<_$_GithubUserModelCollectionQuery> get hirable =>
      BooleanModelQuerySelector<_$_GithubUserModelCollectionQuery>(
        key: "hirable",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  NumModelQuerySelector<_$_GithubUserModelCollectionQuery>
      get publicReposCount =>
          NumModelQuerySelector<_$_GithubUserModelCollectionQuery>(
            key: "publicReposCount",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  NumModelQuerySelector<_$_GithubUserModelCollectionQuery>
      get publicGistsCount =>
          NumModelQuerySelector<_$_GithubUserModelCollectionQuery>(
            key: "publicGistsCount",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  NumModelQuerySelector<_$_GithubUserModelCollectionQuery> get followersCount =>
      NumModelQuerySelector<_$_GithubUserModelCollectionQuery>(
        key: "followersCount",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  NumModelQuerySelector<_$_GithubUserModelCollectionQuery> get followingCount =>
      NumModelQuerySelector<_$_GithubUserModelCollectionQuery>(
        key: "followingCount",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  ModelImageUriModelQuerySelector<_$_GithubUserModelCollectionQuery>
      get avatarUrl =>
          ModelImageUriModelQuerySelector<_$_GithubUserModelCollectionQuery>(
            key: "avatarUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubUserModelCollectionQuery> get gravatarId =>
      StringModelQuerySelector<_$_GithubUserModelCollectionQuery>(
        key: "gravatarId",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  ModelUriModelQuerySelector<_$_GithubUserModelCollectionQuery> get htmlUrl =>
      ModelUriModelQuerySelector<_$_GithubUserModelCollectionQuery>(
        key: "htmlUrl",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  ModelUriModelQuerySelector<_$_GithubUserModelCollectionQuery> get userUrl =>
      ModelUriModelQuerySelector<_$_GithubUserModelCollectionQuery>(
        key: "userUrl",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  ModelUriModelQuerySelector<_$_GithubUserModelCollectionQuery> get eventsUrl =>
      ModelUriModelQuerySelector<_$_GithubUserModelCollectionQuery>(
        key: "eventsUrl",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  ModelUriModelQuerySelector<_$_GithubUserModelCollectionQuery>
      get followersUrl =>
          ModelUriModelQuerySelector<_$_GithubUserModelCollectionQuery>(
            key: "followersUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubUserModelCollectionQuery>
      get followingUrl =>
          ModelUriModelQuerySelector<_$_GithubUserModelCollectionQuery>(
            key: "followingUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubUserModelCollectionQuery> get gistsUrl =>
      ModelUriModelQuerySelector<_$_GithubUserModelCollectionQuery>(
        key: "gistsUrl",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  ModelUriModelQuerySelector<_$_GithubUserModelCollectionQuery>
      get organizationsUrl =>
          ModelUriModelQuerySelector<_$_GithubUserModelCollectionQuery>(
            key: "organizationsUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubUserModelCollectionQuery>
      get receivedEventsUrl =>
          ModelUriModelQuerySelector<_$_GithubUserModelCollectionQuery>(
            key: "receivedEventsUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubUserModelCollectionQuery> get reposUrl =>
      ModelUriModelQuerySelector<_$_GithubUserModelCollectionQuery>(
        key: "reposUrl",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  ModelUriModelQuerySelector<_$_GithubUserModelCollectionQuery>
      get starredUrl =>
          ModelUriModelQuerySelector<_$_GithubUserModelCollectionQuery>(
            key: "starredUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubUserModelCollectionQuery>
      get subscriptionsUrl =>
          ModelUriModelQuerySelector<_$_GithubUserModelCollectionQuery>(
            key: "subscriptionsUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelTimestampModelQuerySelector<_$_GithubUserModelCollectionQuery>
      get starredAt =>
          ModelTimestampModelQuerySelector<_$_GithubUserModelCollectionQuery>(
            key: "starredAt",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelTimestampModelQuerySelector<_$_GithubUserModelCollectionQuery>
      get createdAt =>
          ModelTimestampModelQuerySelector<_$_GithubUserModelCollectionQuery>(
            key: "createdAt",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelTimestampModelQuerySelector<_$_GithubUserModelCollectionQuery>
      get updatedAt =>
          ModelTimestampModelQuerySelector<_$_GithubUserModelCollectionQuery>(
            key: "updatedAt",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );
}

typedef _$GithubUserModelMirrorRefPath = _$GithubUserModelRefPath;
typedef _$GithubUserModelMirrorInitialCollection
    = _$GithubUserModelInitialCollection;

// **************************************************************************
// FormValueGenerator
// **************************************************************************

@immutable
class _$GithubUserModelFormQuery {
  const _$GithubUserModelFormQuery();

  @useResult
  _$_GithubUserModelFormQuery call(GithubUserModel value) {
    return _$_GithubUserModelFormQuery(value);
  }
}

@immutable
class _$_GithubUserModelFormQuery
    extends FormControllerQueryBase<GithubUserModel> {
  const _$_GithubUserModelFormQuery(this.value);

  final GithubUserModel value;

  @override
  FormController<GithubUserModel> Function() call(Ref ref) =>
      () => FormController(value);

  @override
  String get queryName => value.hashCode.toString();

  @override
  bool get autoDisposeWhenUnreferenced => true;
}
