// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations, prefer_const_declarations, unused_element_parameter, prefer_constructors_over_static_methods, matching_super_parameters, prefer_double_quotes, unused_local_variable, unnecessary_lambdas

part of 'github_compare.dart';

// **************************************************************************
// DocumentModelGenerator
// **************************************************************************

extension on GithubCompareModel {
  Map<String, dynamic> get rawValue {
    final map = toJson();
    return {
      ...map,
      "mergeBaseCommit": mergeBaseCommit?.toJson(),
      "baseCommit": baseCommit?.toJson(),
      "commits": commits.map((e) => e.toJson()).toList(),
    };
  }
}

enum _$GithubCompareModelKeys {
  status,
  aheadBy,
  behindBy,
  totalCommits,
  mergeBaseCommit,
  baseCommit,
  commits,
  diffUrl,
  patchUrl,
  htmlUrl,
  permalinkUrl,
  fromServer,
}

class _$GithubCompareModelDocument extends DocumentBase<GithubCompareModel>
    with ModelRefMixin<GithubCompareModel> {
  _$GithubCompareModelDocument(super.modelQuery, [super._value]);

  static const ModelAccessQuery? defaultModelAccessQuery = null;

  static const List<ModelValidationQuery>? defaultValidationQueries = [];

  static final ModelAdapter? defaultModelAdapter =
      GithubModelMasamuneAdapter.primary.modelAdapter;

  @override
  GithubCompareModel fromMap(DynamicMap map) =>
      GithubCompareModel.fromJson(map);

  @override
  DynamicMap toMap(GithubCompareModel value) => value.rawValue;
}

typedef _$GithubCompareModelMirrorDocument = _$GithubCompareModelDocument;

@immutable
class _$GithubCompareModelRefPath extends ModelRefPath<GithubCompareModel> {
  const _$GithubCompareModelRefPath({
    required String organizationId,
    required String repositoryId,
    required String compareId,
  })  : _organizationId = organizationId,
        _repositoryId = repositoryId,
        _compareId = compareId,
        super("");

  final String _organizationId;

  final String _repositoryId;

  final String _compareId;

  @override
  DocumentModelQuery get modelQuery {
    return DocumentModelQuery(
      "organization/$_organizationId/repository/$_repositoryId/compare/$_compareId",
      adapter: adapter,
    );
  }
}

@immutable
class _$GithubCompareModelInitialDocument
    extends ModelInitialDocument<GithubCompareModel> {
  const _$GithubCompareModelInitialDocument(
    super.value, {
    required String organizationId,
    required String repositoryId,
    required String compareId,
  })  : _organizationId = organizationId,
        _repositoryId = repositoryId,
        _compareId = compareId;

  final String _organizationId;

  final String _repositoryId;

  final String _compareId;

  @override
  String get path =>
      "organization/$_organizationId/repository/$_repositoryId/compare/$_compareId";

  @override
  DynamicMap toMap(GithubCompareModel value) => value.rawValue;
}

@immutable
class _$GithubCompareModelDocumentQuery {
  const _$GithubCompareModelDocumentQuery();

  @useResult
  _$_GithubCompareModelDocumentQuery call({
    required String organizationId,
    required String repositoryId,
    required String compareId,
    bool useTestModelAdapter = true,
    ModelAdapter? adapter,
    ModelAccessQuery? accessQuery,
  }) {
    return _$_GithubCompareModelDocumentQuery(
      DocumentModelQuery(
        "organization/$organizationId/repository/$repositoryId/compare/$compareId",
        adapter: adapter ?? _$GithubCompareModelDocument.defaultModelAdapter,
        useTestModelAdapter: useTestModelAdapter,
        accessQuery:
            accessQuery ?? _$GithubCompareModelDocument.defaultModelAccessQuery,
        validationQueries:
            _$GithubCompareModelDocument.defaultValidationQueries,
      ),
    );
  }

  RegExp get regExp {
    return RegExp(
      r"^organization/([^/]+)/repository/([^/]+)/compare/([^/]+)$"
          .trimQuery()
          .trimString("/"),
    );
  }

  bool hasMatchPath(String path) {
    return regExp.hasMatch(path.trimQuery().trimString("/"));
  }
}

@immutable
class _$_GithubCompareModelDocumentQuery
    extends ModelQueryBase<_$GithubCompareModelDocument> {
  const _$_GithubCompareModelDocumentQuery(this.modelQuery);

  final DocumentModelQuery modelQuery;

  @override
  _$GithubCompareModelDocument Function() call(Ref ref) =>
      () => _$GithubCompareModelDocument(modelQuery);

  @override
  String get queryName => modelQuery.toString();
}

typedef _$GithubCompareModelMirrorRefPath = _$GithubCompareModelRefPath;
typedef _$GithubCompareModelMirrorInitialDocument
    = _$GithubCompareModelInitialDocument;

// **************************************************************************
// FormValueGenerator
// **************************************************************************

@immutable
class _$GithubCompareModelFormQuery {
  const _$GithubCompareModelFormQuery();

  @useResult
  _$_GithubCompareModelFormQuery call(GithubCompareModel value) {
    return _$_GithubCompareModelFormQuery(value);
  }
}

@immutable
class _$_GithubCompareModelFormQuery
    extends FormControllerQueryBase<GithubCompareModel> {
  const _$_GithubCompareModelFormQuery(this.value);

  final GithubCompareModel value;

  @override
  FormController<GithubCompareModel> Function() call(Ref ref) =>
      () => FormController(value);

  @override
  String get queryName => value.hashCode.toString();

  @override
  bool get autoDisposeWhenUnreferenced => true;
}
