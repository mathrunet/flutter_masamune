// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations, prefer_const_declarations, unused_element_parameter, prefer_constructors_over_static_methods, matching_super_parameters, prefer_double_quotes, unused_local_variable, unnecessary_lambdas

part of 'github_issue_comment.dart';

// **************************************************************************
// CollectionModelGenerator
// **************************************************************************

extension on GithubIssueCommentModel {
  Map<String, dynamic> get rawValue {
    return toJson();
  }
}

enum _$GithubIssueCommentModelKeys {
  id,
  body,
  authorAssociation,
  user,
  url,
  htmlUrl,
  issueUrl,
  createdAt,
  updatedAt,
  fromServer,
}

class _$GithubIssueCommentModelDocument
    extends DocumentBase<GithubIssueCommentModel>
    with
        ModelRefMixin<GithubIssueCommentModel>,
        ModelRefLoaderMixin<GithubIssueCommentModel> {
  _$GithubIssueCommentModelDocument(super.modelQuery, [super._value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter =
      GithubModelMasamuneAdapter.primary.modelAdapter;

  @override
  GithubIssueCommentModel fromMap(DynamicMap map) =>
      GithubIssueCommentModel.fromJson(map);

  @override
  DynamicMap toMap(GithubIssueCommentModel value) => value.rawValue;

  @override
  List<ModelRefBuilderBase<GithubIssueCommentModel>> get builder => [
        ModelRefBuilder(
          modelRef: (value) => value.user,
          document: (modelQuery) => GithubUserModelDocument(modelQuery),
          value: (value, doc) => value.copyWith(user: doc),
          adapter: GithubUserModelDocument.defaultModelAdapter,
          accessQuery: GithubUserModelDocument.defaultModelAccessQuery,
          validationQueries: GithubUserModelDocument.defaultValidationQueries,
        ),
      ];
}

typedef _$GithubIssueCommentModelMirrorDocument
    = _$GithubIssueCommentModelDocument;

class _$GithubIssueCommentModelCollection
    extends CollectionBase<_$GithubIssueCommentModelDocument>
    with
        FilterableCollectionMixin<_$GithubIssueCommentModelDocument,
            _$_GithubIssueCommentModelCollectionQuery> {
  _$GithubIssueCommentModelCollection(super.modelQuery, [super.value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter =
      GithubModelMasamuneAdapter.primary.modelAdapter;

  @override
  _$GithubIssueCommentModelDocument create([String? id]) =>
      _$GithubIssueCommentModelDocument(modelQuery.create(id));

  @override
  Future<CollectionBase<_$GithubIssueCommentModelDocument>> filter(
    _$_GithubIssueCommentModelCollectionQuery Function(
      _$_GithubIssueCommentModelCollectionQuery source,
    ) callback,
  ) {
    final query = callback.call(
      _$_GithubIssueCommentModelCollectionQuery(modelQuery),
    );
    return replaceQuery((_) => query.modelQuery);
  }
}

typedef _$GithubIssueCommentModelMirrorCollection
    = _$GithubIssueCommentModelCollection;

@immutable
class _$GithubIssueCommentModelRefPath
    extends ModelRefPath<GithubIssueCommentModel> {
  const _$GithubIssueCommentModelRefPath(
    super.uid, {
    required String organizationId,
    required String repositoryId,
    required String issueId,
  })  : _organizationId = organizationId,
        _repositoryId = repositoryId,
        _issueId = issueId;

  final String _organizationId;

  final String _repositoryId;

  final String _issueId;

  @override
  DocumentModelQuery get modelQuery {
    return DocumentModelQuery(
      "organization/$_organizationId/repository/$_repositoryId/issue/$_issueId/comment/${path.trimQuery().trimString("/")}",
      adapter: adapter,
    );
  }
}

@immutable
class _$GithubIssueCommentModelInitialCollection
    extends ModelInitialCollection<GithubIssueCommentModel> {
  const _$GithubIssueCommentModelInitialCollection(
    super.value, {
    required String organizationId,
    required String repositoryId,
    required String issueId,
  })  : _organizationId = organizationId,
        _repositoryId = repositoryId,
        _issueId = issueId;

  final String _organizationId;

  final String _repositoryId;

  final String _issueId;

  @override
  String get path =>
      "organization/$_organizationId/repository/$_repositoryId/issue/$_issueId/comment";

  @override
  DynamicMap toMap(GithubIssueCommentModel value) => value.rawValue;
}

@immutable
class _$GithubIssueCommentModelDocumentQuery {
  const _$GithubIssueCommentModelDocumentQuery();

  @useResult
  _$_GithubIssueCommentModelDocumentQuery call(
    Object _id, {
    required String organizationId,
    required String repositoryId,
    required String issueId,
    ModelAdapter? adapter,
    bool useTestModelAdapter = true,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_GithubIssueCommentModelDocumentQuery(
      DocumentModelQuery(
        "organization/$organizationId/repository/$repositoryId/issue/$issueId/comment/$_id",
        adapter:
            adapter ?? _$GithubIssueCommentModelDocument.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery: accessQuery ??
            _$GithubIssueCommentModelDocument.defaultModelAccessQuery,
        validationQueries:
            _$GithubIssueCommentModelDocument.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(
      r"^organization/([^/]+)/repository/([^/]+)/issue/([^/]+)/comment/([^/]+)$"
          .trimQuery()
          .trimString("/"),
    );
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_GithubIssueCommentModelDocumentQuery
    extends ModelQueryBase<_$GithubIssueCommentModelDocument> {
  const _$_GithubIssueCommentModelDocumentQuery(this.modelQuery);

  final DocumentModelQuery modelQuery;

  @override
  _$GithubIssueCommentModelDocument Function() call(Ref ref) =>
      () => _$GithubIssueCommentModelDocument(modelQuery);

  @override
  String get queryName => modelQuery.toString();
}

@immutable
class _$GithubIssueCommentModelCollectionQuery {
  const _$GithubIssueCommentModelCollectionQuery();

  @useResult
  _$_GithubIssueCommentModelCollectionQuery call({
    required String organizationId,
    required String repositoryId,
    required String issueId,
    bool useTestModelAdapter = true,
    ModelAdapter? adapter,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_GithubIssueCommentModelCollectionQuery(
      CollectionModelQuery(
        "organization/$organizationId/repository/$repositoryId/issue/$issueId/comment",
        adapter:
            adapter ?? _$GithubIssueCommentModelCollection.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery: accessQuery ??
            _$GithubIssueCommentModelCollection.defaultModelAccessQuery,
        validationQueries:
            _$GithubIssueCommentModelCollection.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(
      r"^organization/([^/]+)/repository/([^/]+)/issue/([^/]+)/comment$"
          .trimQuery()
          .trimString("/"),
    );
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_GithubIssueCommentModelCollectionQuery
    extends ModelQueryBase<_$GithubIssueCommentModelCollection> {
  const _$_GithubIssueCommentModelCollectionQuery(this.modelQuery);

  final CollectionModelQuery modelQuery;

  @override
  _$GithubIssueCommentModelCollection Function() call(Ref ref) =>
      () => _$GithubIssueCommentModelCollection(modelQuery);

  @override
  String get queryName => modelQuery.toString();

  static _$_GithubIssueCommentModelCollectionQuery _toQuery(
    CollectionModelQuery query,
  ) =>
      _$_GithubIssueCommentModelCollectionQuery(query);

  _$_GithubIssueCommentModelCollectionQuery collectionGroup() =>
      _$_GithubIssueCommentModelCollectionQuery(modelQuery.collectionGroup());

  _$_GithubIssueCommentModelCollectionQuery reset() =>
      _$_GithubIssueCommentModelCollectionQuery(modelQuery.reset());

  _$_GithubIssueCommentModelCollectionQuery remove(ModelQueryFilterType type) =>
      _$_GithubIssueCommentModelCollectionQuery(modelQuery.remove(type));

  _$_GithubIssueCommentModelCollectionQuery notifyDocumentChanges() =>
      _$_GithubIssueCommentModelCollectionQuery(
        modelQuery.notifyDocumentChanges(),
      );

  _$_GithubIssueCommentModelCollectionQuery limitTo(int value) =>
      _$_GithubIssueCommentModelCollectionQuery(modelQuery.limitTo(value));

  StringModelQuerySelector<_$_GithubIssueCommentModelCollectionQuery> get uid =>
      StringModelQuerySelector<_$_GithubIssueCommentModelCollectionQuery>(
        key: "@uid",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  NumModelQuerySelector<_$_GithubIssueCommentModelCollectionQuery> get id =>
      NumModelQuerySelector<_$_GithubIssueCommentModelCollectionQuery>(
        key: "id",
        toQuery: _toQuery,
        modelQuery: modelQuery,
      );

  StringModelQuerySelector<_$_GithubIssueCommentModelCollectionQuery>
      get body =>
          StringModelQuerySelector<_$_GithubIssueCommentModelCollectionQuery>(
            key: "body",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubIssueCommentModelCollectionQuery>
      get authorAssociation =>
          StringModelQuerySelector<_$_GithubIssueCommentModelCollectionQuery>(
            key: "authorAssociation",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelRefModelQuerySelector<GithubUserModel,
          _$_GithubIssueCommentModelCollectionQuery>
      get user => ModelRefModelQuerySelector<GithubUserModel,
              _$_GithubIssueCommentModelCollectionQuery>(
          key: "user", toQuery: _toQuery, modelQuery: modelQuery);

  ModelUriModelQuerySelector<_$_GithubIssueCommentModelCollectionQuery>
      get url =>
          ModelUriModelQuerySelector<_$_GithubIssueCommentModelCollectionQuery>(
            key: "url",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubIssueCommentModelCollectionQuery>
      get htmlUrl =>
          ModelUriModelQuerySelector<_$_GithubIssueCommentModelCollectionQuery>(
            key: "htmlUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelUriModelQuerySelector<_$_GithubIssueCommentModelCollectionQuery>
      get issueUrl =>
          ModelUriModelQuerySelector<_$_GithubIssueCommentModelCollectionQuery>(
            key: "issueUrl",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelTimestampModelQuerySelector<_$_GithubIssueCommentModelCollectionQuery>
      get createdAt => ModelTimestampModelQuerySelector<
              _$_GithubIssueCommentModelCollectionQuery>(
          key: "createdAt", toQuery: _toQuery, modelQuery: modelQuery);

  ModelTimestampModelQuerySelector<_$_GithubIssueCommentModelCollectionQuery>
      get updatedAt => ModelTimestampModelQuerySelector<
              _$_GithubIssueCommentModelCollectionQuery>(
          key: "updatedAt", toQuery: _toQuery, modelQuery: modelQuery);

  BooleanModelQuerySelector<_$_GithubIssueCommentModelCollectionQuery>
      get fromServer =>
          BooleanModelQuerySelector<_$_GithubIssueCommentModelCollectionQuery>(
            key: "fromServer",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );
}

typedef _$GithubIssueCommentModelMirrorRefPath
    = _$GithubIssueCommentModelRefPath;
typedef _$GithubIssueCommentModelMirrorInitialCollection
    = _$GithubIssueCommentModelInitialCollection;

// **************************************************************************
// FormValueGenerator
// **************************************************************************

@immutable
class _$GithubIssueCommentModelFormQuery {
  const _$GithubIssueCommentModelFormQuery();

  @useResult
  _$_GithubIssueCommentModelFormQuery call(GithubIssueCommentModel value) {
    return _$_GithubIssueCommentModelFormQuery(value);
  }
}

@immutable
class _$_GithubIssueCommentModelFormQuery
    extends FormControllerQueryBase<GithubIssueCommentModel> {
  const _$_GithubIssueCommentModelFormQuery(this.value);

  final GithubIssueCommentModel value;

  @override
  FormController<GithubIssueCommentModel> Function() call(Ref ref) =>
      () => FormController(value);

  @override
  String get queryName => value.hashCode.toString();

  @override
  bool get autoDisposeWhenUnreferenced => true;
}
