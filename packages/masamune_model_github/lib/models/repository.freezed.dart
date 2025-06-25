// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'repository.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RepositoryModel {
  String get name;
  String get fullName;
  String get description;
  bool get private;
  int? get id;
  String? get htmlUrl;
  String? get cloneUrl;
  String? get sshUrl;
  Map<String, dynamic> get owner;
  String? get defaultBranch;
  String? get language;
  int get stargazersCount;
  int get forksCount;
  int get openIssuesCount;
  String? get createdAt;
  String? get updatedAt;
  String? get pushedAt;

  /// Create a copy of RepositoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RepositoryModelCopyWith<RepositoryModel> get copyWith =>
      _$RepositoryModelCopyWithImpl<RepositoryModel>(
          this as RepositoryModel, _$identity);

  /// Serializes this RepositoryModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RepositoryModel &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.private, private) || other.private == private) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.htmlUrl, htmlUrl) || other.htmlUrl == htmlUrl) &&
            (identical(other.cloneUrl, cloneUrl) ||
                other.cloneUrl == cloneUrl) &&
            (identical(other.sshUrl, sshUrl) || other.sshUrl == sshUrl) &&
            const DeepCollectionEquality().equals(other.owner, owner) &&
            (identical(other.defaultBranch, defaultBranch) ||
                other.defaultBranch == defaultBranch) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.stargazersCount, stargazersCount) ||
                other.stargazersCount == stargazersCount) &&
            (identical(other.forksCount, forksCount) ||
                other.forksCount == forksCount) &&
            (identical(other.openIssuesCount, openIssuesCount) ||
                other.openIssuesCount == openIssuesCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.pushedAt, pushedAt) ||
                other.pushedAt == pushedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      fullName,
      description,
      private,
      id,
      htmlUrl,
      cloneUrl,
      sshUrl,
      const DeepCollectionEquality().hash(owner),
      defaultBranch,
      language,
      stargazersCount,
      forksCount,
      openIssuesCount,
      createdAt,
      updatedAt,
      pushedAt);

  @override
  String toString() {
    return 'RepositoryModel(name: $name, fullName: $fullName, description: $description, private: $private, id: $id, htmlUrl: $htmlUrl, cloneUrl: $cloneUrl, sshUrl: $sshUrl, owner: $owner, defaultBranch: $defaultBranch, language: $language, stargazersCount: $stargazersCount, forksCount: $forksCount, openIssuesCount: $openIssuesCount, createdAt: $createdAt, updatedAt: $updatedAt, pushedAt: $pushedAt)';
  }
}

/// @nodoc
abstract mixin class $RepositoryModelCopyWith<$Res> {
  factory $RepositoryModelCopyWith(
          RepositoryModel value, $Res Function(RepositoryModel) _then) =
      _$RepositoryModelCopyWithImpl;
  @useResult
  $Res call(
      {String name,
      String fullName,
      String description,
      bool private,
      int? id,
      String? htmlUrl,
      String? cloneUrl,
      String? sshUrl,
      Map<String, dynamic> owner,
      String? defaultBranch,
      String? language,
      int stargazersCount,
      int forksCount,
      int openIssuesCount,
      String? createdAt,
      String? updatedAt,
      String? pushedAt});
}

/// @nodoc
class _$RepositoryModelCopyWithImpl<$Res>
    implements $RepositoryModelCopyWith<$Res> {
  _$RepositoryModelCopyWithImpl(this._self, this._then);

  final RepositoryModel _self;
  final $Res Function(RepositoryModel) _then;

  /// Create a copy of RepositoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? fullName = null,
    Object? description = null,
    Object? private = null,
    Object? id = freezed,
    Object? htmlUrl = freezed,
    Object? cloneUrl = freezed,
    Object? sshUrl = freezed,
    Object? owner = null,
    Object? defaultBranch = freezed,
    Object? language = freezed,
    Object? stargazersCount = null,
    Object? forksCount = null,
    Object? openIssuesCount = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? pushedAt = freezed,
  }) {
    return _then(_self.copyWith(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _self.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      private: null == private
          ? _self.private
          : private // ignore: cast_nullable_to_non_nullable
              as bool,
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      htmlUrl: freezed == htmlUrl
          ? _self.htmlUrl
          : htmlUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      cloneUrl: freezed == cloneUrl
          ? _self.cloneUrl
          : cloneUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      sshUrl: freezed == sshUrl
          ? _self.sshUrl
          : sshUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      owner: null == owner
          ? _self.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      defaultBranch: freezed == defaultBranch
          ? _self.defaultBranch
          : defaultBranch // ignore: cast_nullable_to_non_nullable
              as String?,
      language: freezed == language
          ? _self.language
          : language // ignore: cast_nullable_to_non_nullable
              as String?,
      stargazersCount: null == stargazersCount
          ? _self.stargazersCount
          : stargazersCount // ignore: cast_nullable_to_non_nullable
              as int,
      forksCount: null == forksCount
          ? _self.forksCount
          : forksCount // ignore: cast_nullable_to_non_nullable
              as int,
      openIssuesCount: null == openIssuesCount
          ? _self.openIssuesCount
          : openIssuesCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      pushedAt: freezed == pushedAt
          ? _self.pushedAt
          : pushedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _RepositoryModel extends RepositoryModel {
  const _RepositoryModel(
      {this.name = "",
      this.fullName = "",
      this.description = "",
      this.private = false,
      this.id,
      this.htmlUrl,
      this.cloneUrl,
      this.sshUrl,
      final Map<String, dynamic> owner = const <String, dynamic>{},
      this.defaultBranch,
      this.language,
      this.stargazersCount = 0,
      this.forksCount = 0,
      this.openIssuesCount = 0,
      this.createdAt,
      this.updatedAt,
      this.pushedAt})
      : _owner = owner,
        super._();
  factory _RepositoryModel.fromJson(Map<String, dynamic> json) =>
      _$RepositoryModelFromJson(json);

  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String fullName;
  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey()
  final bool private;
  @override
  final int? id;
  @override
  final String? htmlUrl;
  @override
  final String? cloneUrl;
  @override
  final String? sshUrl;
  final Map<String, dynamic> _owner;
  @override
  @JsonKey()
  Map<String, dynamic> get owner {
    if (_owner is EqualUnmodifiableMapView) return _owner;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_owner);
  }

  @override
  final String? defaultBranch;
  @override
  final String? language;
  @override
  @JsonKey()
  final int stargazersCount;
  @override
  @JsonKey()
  final int forksCount;
  @override
  @JsonKey()
  final int openIssuesCount;
  @override
  final String? createdAt;
  @override
  final String? updatedAt;
  @override
  final String? pushedAt;

  /// Create a copy of RepositoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RepositoryModelCopyWith<_RepositoryModel> get copyWith =>
      __$RepositoryModelCopyWithImpl<_RepositoryModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RepositoryModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RepositoryModel &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.private, private) || other.private == private) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.htmlUrl, htmlUrl) || other.htmlUrl == htmlUrl) &&
            (identical(other.cloneUrl, cloneUrl) ||
                other.cloneUrl == cloneUrl) &&
            (identical(other.sshUrl, sshUrl) || other.sshUrl == sshUrl) &&
            const DeepCollectionEquality().equals(other._owner, _owner) &&
            (identical(other.defaultBranch, defaultBranch) ||
                other.defaultBranch == defaultBranch) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.stargazersCount, stargazersCount) ||
                other.stargazersCount == stargazersCount) &&
            (identical(other.forksCount, forksCount) ||
                other.forksCount == forksCount) &&
            (identical(other.openIssuesCount, openIssuesCount) ||
                other.openIssuesCount == openIssuesCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.pushedAt, pushedAt) ||
                other.pushedAt == pushedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      fullName,
      description,
      private,
      id,
      htmlUrl,
      cloneUrl,
      sshUrl,
      const DeepCollectionEquality().hash(_owner),
      defaultBranch,
      language,
      stargazersCount,
      forksCount,
      openIssuesCount,
      createdAt,
      updatedAt,
      pushedAt);

  @override
  String toString() {
    return 'RepositoryModel(name: $name, fullName: $fullName, description: $description, private: $private, id: $id, htmlUrl: $htmlUrl, cloneUrl: $cloneUrl, sshUrl: $sshUrl, owner: $owner, defaultBranch: $defaultBranch, language: $language, stargazersCount: $stargazersCount, forksCount: $forksCount, openIssuesCount: $openIssuesCount, createdAt: $createdAt, updatedAt: $updatedAt, pushedAt: $pushedAt)';
  }
}

/// @nodoc
abstract mixin class _$RepositoryModelCopyWith<$Res>
    implements $RepositoryModelCopyWith<$Res> {
  factory _$RepositoryModelCopyWith(
          _RepositoryModel value, $Res Function(_RepositoryModel) _then) =
      __$RepositoryModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String name,
      String fullName,
      String description,
      bool private,
      int? id,
      String? htmlUrl,
      String? cloneUrl,
      String? sshUrl,
      Map<String, dynamic> owner,
      String? defaultBranch,
      String? language,
      int stargazersCount,
      int forksCount,
      int openIssuesCount,
      String? createdAt,
      String? updatedAt,
      String? pushedAt});
}

/// @nodoc
class __$RepositoryModelCopyWithImpl<$Res>
    implements _$RepositoryModelCopyWith<$Res> {
  __$RepositoryModelCopyWithImpl(this._self, this._then);

  final _RepositoryModel _self;
  final $Res Function(_RepositoryModel) _then;

  /// Create a copy of RepositoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = null,
    Object? fullName = null,
    Object? description = null,
    Object? private = null,
    Object? id = freezed,
    Object? htmlUrl = freezed,
    Object? cloneUrl = freezed,
    Object? sshUrl = freezed,
    Object? owner = null,
    Object? defaultBranch = freezed,
    Object? language = freezed,
    Object? stargazersCount = null,
    Object? forksCount = null,
    Object? openIssuesCount = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? pushedAt = freezed,
  }) {
    return _then(_RepositoryModel(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _self.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      private: null == private
          ? _self.private
          : private // ignore: cast_nullable_to_non_nullable
              as bool,
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      htmlUrl: freezed == htmlUrl
          ? _self.htmlUrl
          : htmlUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      cloneUrl: freezed == cloneUrl
          ? _self.cloneUrl
          : cloneUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      sshUrl: freezed == sshUrl
          ? _self.sshUrl
          : sshUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      owner: null == owner
          ? _self._owner
          : owner // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      defaultBranch: freezed == defaultBranch
          ? _self.defaultBranch
          : defaultBranch // ignore: cast_nullable_to_non_nullable
              as String?,
      language: freezed == language
          ? _self.language
          : language // ignore: cast_nullable_to_non_nullable
              as String?,
      stargazersCount: null == stargazersCount
          ? _self.stargazersCount
          : stargazersCount // ignore: cast_nullable_to_non_nullable
              as int,
      forksCount: null == forksCount
          ? _self.forksCount
          : forksCount // ignore: cast_nullable_to_non_nullable
              as int,
      openIssuesCount: null == openIssuesCount
          ? _self.openIssuesCount
          : openIssuesCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      pushedAt: freezed == pushedAt
          ? _self.pushedAt
          : pushedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
