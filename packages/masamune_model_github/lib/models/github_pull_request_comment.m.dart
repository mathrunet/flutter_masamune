// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations, prefer_const_declarations

part of 'github_pull_request_comment.dart';

// **************************************************************************
// CollectionModelGenerator
// **************************************************************************

extension on GithubPullRequestCommentModel {
  Map<String, dynamic> get rawValue {
    return toJson();
  }
}

enum _$GithubPullRequestCommentModelKeys {
  id,
  body,
  diffHunk,
  path,
  position,
  originalPosition,
  commitId,
  originalCommitId,
  user,
  url,
  pullRequestUrl,
  links,
  createdAt,
  updatedAt,
  fromServer,
}

class _$GithubPullRequestCommentModelDocument
    extends DocumentBase<GithubPullRequestCommentModel>
    with
        ModelRefMixin<GithubPullRequestCommentModel>,
        ModelRefLoaderMixin<GithubPullRequestCommentModel> {
  _$GithubPullRequestCommentModelDocument(super.modelQuery, [super._value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  GithubPullRequestCommentModel fromMap(DynamicMap map) =>
      GithubPullRequestCommentModel.fromJson(map);

  @override
  DynamicMap toMap(GithubPullRequestCommentModel value) => value.rawValue;

  @override
  List<ModelRefBuilderBase<GithubPullRequestCommentModel>> get builder => [
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

typedef _$GithubPullRequestCommentModelMirrorDocument
    = _$GithubPullRequestCommentModelDocument;

class _$GithubPullRequestCommentModelCollection
    extends CollectionBase<_$GithubPullRequestCommentModelDocument>
    with
        FilterableCollectionMixin<_$GithubPullRequestCommentModelDocument,
            _$_GithubPullRequestCommentModelCollectionQuery> {
  _$GithubPullRequestCommentModelCollection(super.modelQuery, [super.value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter = null;

  @override
  _$GithubPullRequestCommentModelDocument create([String? id]) =>
      _$GithubPullRequestCommentModelDocument(modelQuery.create(id));

  @override
  Future<CollectionBase<_$GithubPullRequestCommentModelDocument>> filter(
    _$_GithubPullRequestCommentModelCollectionQuery Function(
      _$_GithubPullRequestCommentModelCollectionQuery source,
    ) callback,
  ) {
    final query = callback.call(
      _$_GithubPullRequestCommentModelCollectionQuery(modelQuery),
    );
    return replaceQuery((_) => query.modelQuery);
  }
}

typedef _$GithubPullRequestCommentModelMirrorCollection
    = _$GithubPullRequestCommentModelCollection;

@immutable
class _$GithubPullRequestCommentModelRefPath
    extends ModelRefPath<GithubPullRequestCommentModel> {
  const _$GithubPullRequestCommentModelRefPath(
    super.uid, {
    required String organizationId,
    required String repositoryId,
    required String pullRequestId,
  })  : _organizationId = organizationId,
        _repositoryId = repositoryId,
        _pullRequestId = pullRequestId;

  final String _organizationId;

  final String _repositoryId;

  final String _pullRequestId;

  @override
  DocumentModelQuery get modelQuery {
    return DocumentModelQuery(
      "organization/$_organizationId/repository/$_repositoryId/pull_request/$_pullRequestId/comment/${path.trimQuery().trimString("/")}",
      adapter: adapter,
    );
  }
}

@immutable
class _$GithubPullRequestCommentModelInitialCollection
    extends ModelInitialCollection<GithubPullRequestCommentModel> {
  const _$GithubPullRequestCommentModelInitialCollection(
    super.value, {
    required String organizationId,
    required String repositoryId,
    required String pullRequestId,
  })  : _organizationId = organizationId,
        _repositoryId = repositoryId,
        _pullRequestId = pullRequestId;

  final String _organizationId;

  final String _repositoryId;

  final String _pullRequestId;

  @override
  String get path =>
      "organization/$_organizationId/repository/$_repositoryId/pull_request/$_pullRequestId/comment";

  @override
  DynamicMap toMap(GithubPullRequestCommentModel value) => value.rawValue;
}

@immutable
class _$GithubPullRequestCommentModelDocumentQuery {
  const _$GithubPullRequestCommentModelDocumentQuery();

  @useResult
  _$_GithubPullRequestCommentModelDocumentQuery call(
    Object _id, {
    required String organizationId,
    required String repositoryId,
    required String pullRequestId,
    ModelAdapter? adapter,
    bool useTestModelAdapter = true,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_GithubPullRequestCommentModelDocumentQuery(
      DocumentModelQuery(
        "organization/$organizationId/repository/$repositoryId/pull_request/$pullRequestId/comment/$_id",
        adapter: adapter ??
            _$GithubPullRequestCommentModelDocument.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery: accessQuery ??
            _$GithubPullRequestCommentModelDocument.defaultModelAccessQuery,
        validationQueries:
            _$GithubPullRequestCommentModelDocument.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(
      r"^organization/([^/]+)/repository/([^/]+)/pull_request/([^/]+)/comment/([^/]+)$"
          .trimQuery()
          .trimString("/"),
    );
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_GithubPullRequestCommentModelDocumentQuery
    extends ModelQueryBase<_$GithubPullRequestCommentModelDocument> {
  const _$_GithubPullRequestCommentModelDocumentQuery(this.modelQuery);

  final DocumentModelQuery modelQuery;

  @override
  _$GithubPullRequestCommentModelDocument Function() call(Ref ref) =>
      () => _$GithubPullRequestCommentModelDocument(modelQuery);

  @override
  String get queryName => modelQuery.toString();
}

@immutable
class _$GithubPullRequestCommentModelCollectionQuery {
  const _$GithubPullRequestCommentModelCollectionQuery();

  @useResult
  _$_GithubPullRequestCommentModelCollectionQuery call({
    required String organizationId,
    required String repositoryId,
    required String pullRequestId,
    bool useTestModelAdapter = true,
    ModelAdapter? adapter,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_GithubPullRequestCommentModelCollectionQuery(
      CollectionModelQuery(
        "organization/$organizationId/repository/$repositoryId/pull_request/$pullRequestId/comment",
        adapter: adapter ??
            _$GithubPullRequestCommentModelCollection.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery: accessQuery ??
            _$GithubPullRequestCommentModelCollection.defaultModelAccessQuery,
        validationQueries:
            _$GithubPullRequestCommentModelCollection.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(
      r"^organization/([^/]+)/repository/([^/]+)/pull_request/([^/]+)/comment$"
          .trimQuery()
          .trimString("/"),
    );
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_GithubPullRequestCommentModelCollectionQuery
    extends ModelQueryBase<_$GithubPullRequestCommentModelCollection> {
  const _$_GithubPullRequestCommentModelCollectionQuery(this.modelQuery);

  final CollectionModelQuery modelQuery;

  @override
  _$GithubPullRequestCommentModelCollection Function() call(Ref ref) =>
      () => _$GithubPullRequestCommentModelCollection(modelQuery);

  @override
  String get queryName => modelQuery.toString();

  static _$_GithubPullRequestCommentModelCollectionQuery _toQuery(
    CollectionModelQuery query,
  ) =>
      _$_GithubPullRequestCommentModelCollectionQuery(query);

  _$_GithubPullRequestCommentModelCollectionQuery collectionGroup() =>
      _$_GithubPullRequestCommentModelCollectionQuery(
        modelQuery.collectionGroup(),
      );

  _$_GithubPullRequestCommentModelCollectionQuery reset() =>
      _$_GithubPullRequestCommentModelCollectionQuery(modelQuery.reset());

  _$_GithubPullRequestCommentModelCollectionQuery remove(
    ModelQueryFilterType type,
  ) =>
      _$_GithubPullRequestCommentModelCollectionQuery(modelQuery.remove(type));

  _$_GithubPullRequestCommentModelCollectionQuery notifyDocumentChanges() =>
      _$_GithubPullRequestCommentModelCollectionQuery(
        modelQuery.notifyDocumentChanges(),
      );

  _$_GithubPullRequestCommentModelCollectionQuery limitTo(int value) =>
      _$_GithubPullRequestCommentModelCollectionQuery(
        modelQuery.limitTo(value),
      );

  StringModelQuerySelector<_$_GithubPullRequestCommentModelCollectionQuery>
      get uid => StringModelQuerySelector<
              _$_GithubPullRequestCommentModelCollectionQuery>(
            key: "@uid",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  NumModelQuerySelector<_$_GithubPullRequestCommentModelCollectionQuery>
      get id => NumModelQuerySelector<
              _$_GithubPullRequestCommentModelCollectionQuery>(
            key: "id",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubPullRequestCommentModelCollectionQuery>
      get body => StringModelQuerySelector<
              _$_GithubPullRequestCommentModelCollectionQuery>(
            key: "body",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubPullRequestCommentModelCollectionQuery>
      get diffHunk => StringModelQuerySelector<
              _$_GithubPullRequestCommentModelCollectionQuery>(
            key: "diffHunk",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubPullRequestCommentModelCollectionQuery>
      get path => StringModelQuerySelector<
              _$_GithubPullRequestCommentModelCollectionQuery>(
            key: "path",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  NumModelQuerySelector<_$_GithubPullRequestCommentModelCollectionQuery>
      get position => NumModelQuerySelector<
              _$_GithubPullRequestCommentModelCollectionQuery>(
            key: "position",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  NumModelQuerySelector<_$_GithubPullRequestCommentModelCollectionQuery>
      get originalPosition => NumModelQuerySelector<
              _$_GithubPullRequestCommentModelCollectionQuery>(
            key: "originalPosition",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubPullRequestCommentModelCollectionQuery>
      get commitId => StringModelQuerySelector<
              _$_GithubPullRequestCommentModelCollectionQuery>(
            key: "commitId",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  StringModelQuerySelector<_$_GithubPullRequestCommentModelCollectionQuery>
      get originalCommitId => StringModelQuerySelector<
              _$_GithubPullRequestCommentModelCollectionQuery>(
            key: "originalCommitId",
            toQuery: _toQuery,
            modelQuery: modelQuery,
          );

  ModelRefModelQuerySelector<GithubUserModel,
          _$_GithubPullRequestCommentModelCollectionQuery>
      get user => ModelRefModelQuerySelector<GithubUserModel,
              _$_GithubPullRequestCommentModelCollectionQuery>(
          key: "user", toQuery: _toQuery, modelQuery: modelQuery);

  ModelUriModelQuerySelector<_$_GithubPullRequestCommentModelCollectionQuery>
      get url => ModelUriModelQuerySelector<
              _$_GithubPullRequestCommentModelCollectionQuery>(
          key: "url", toQuery: _toQuery, modelQuery: modelQuery);

  ModelUriModelQuerySelector<_$_GithubPullRequestCommentModelCollectionQuery>
      get pullRequestUrl => ModelUriModelQuerySelector<
              _$_GithubPullRequestCommentModelCollectionQuery>(
          key: "pullRequestUrl", toQuery: _toQuery, modelQuery: modelQuery);

  ModelUriModelQuerySelector<_$_GithubPullRequestCommentModelCollectionQuery>
      get links => ModelUriModelQuerySelector<
              _$_GithubPullRequestCommentModelCollectionQuery>(
          key: "links", toQuery: _toQuery, modelQuery: modelQuery);

  ModelTimestampModelQuerySelector<
          _$_GithubPullRequestCommentModelCollectionQuery>
      get createdAt => ModelTimestampModelQuerySelector<
              _$_GithubPullRequestCommentModelCollectionQuery>(
          key: "createdAt", toQuery: _toQuery, modelQuery: modelQuery);

  ModelTimestampModelQuerySelector<
          _$_GithubPullRequestCommentModelCollectionQuery>
      get updatedAt => ModelTimestampModelQuerySelector<
              _$_GithubPullRequestCommentModelCollectionQuery>(
          key: "updatedAt", toQuery: _toQuery, modelQuery: modelQuery);

  BooleanModelQuerySelector<_$_GithubPullRequestCommentModelCollectionQuery>
      get fromServer => BooleanModelQuerySelector<
              _$_GithubPullRequestCommentModelCollectionQuery>(
          key: "fromServer", toQuery: _toQuery, modelQuery: modelQuery);
}

typedef _$GithubPullRequestCommentModelMirrorRefPath
    = _$GithubPullRequestCommentModelRefPath;
typedef _$GithubPullRequestCommentModelMirrorInitialCollection
    = _$GithubPullRequestCommentModelInitialCollection;

// **************************************************************************
// FormValueGenerator
// **************************************************************************

@immutable
class _$GithubPullRequestCommentModelFormQuery {
  const _$GithubPullRequestCommentModelFormQuery();

  @useResult
  _$_GithubPullRequestCommentModelFormQuery call(
    GithubPullRequestCommentModel value,
  ) {
    return _$_GithubPullRequestCommentModelFormQuery(value);
  }
}

@immutable
class _$_GithubPullRequestCommentModelFormQuery
    extends FormControllerQueryBase<GithubPullRequestCommentModel> {
  const _$_GithubPullRequestCommentModelFormQuery(this.value);

  final GithubPullRequestCommentModel value;

  @override
  FormController<GithubPullRequestCommentModel> Function() call(Ref ref) =>
      () => FormController(value);

  @override
  String get queryName => value.hashCode.toString();

  @override
  bool get autoDisposeWhenUnreferenced => true;
}
