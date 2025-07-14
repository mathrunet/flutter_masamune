// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'github_organization.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GithubOrganizationModel {
  int? get id;
  String? get name;
  String? get login;
  String? get company;
  String? get blog;
  String? get location;
  String? get email;
  int get publicReposCount;
  int get publicGistsCount;
  int get followersCount;
  int get followingCount;
  ModelUri? get htmlUrl;
  ModelImageUri? get avatarUrl;
  ModelTimestamp get createdAt;
  ModelTimestamp get updatedAt;

  /// Create a copy of GithubOrganizationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GithubOrganizationModelCopyWith<GithubOrganizationModel> get copyWith =>
      _$GithubOrganizationModelCopyWithImpl<GithubOrganizationModel>(
          this as GithubOrganizationModel, _$identity);

  /// Serializes this GithubOrganizationModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GithubOrganizationModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.login, login) || other.login == login) &&
            (identical(other.company, company) || other.company == company) &&
            (identical(other.blog, blog) || other.blog == blog) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.publicReposCount, publicReposCount) ||
                other.publicReposCount == publicReposCount) &&
            (identical(other.publicGistsCount, publicGistsCount) ||
                other.publicGistsCount == publicGistsCount) &&
            (identical(other.followersCount, followersCount) ||
                other.followersCount == followersCount) &&
            (identical(other.followingCount, followingCount) ||
                other.followingCount == followingCount) &&
            (identical(other.htmlUrl, htmlUrl) || other.htmlUrl == htmlUrl) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
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
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'GithubOrganizationModel(id: $id, name: $name, login: $login, company: $company, blog: $blog, location: $location, email: $email, publicReposCount: $publicReposCount, publicGistsCount: $publicGistsCount, followersCount: $followersCount, followingCount: $followingCount, htmlUrl: $htmlUrl, avatarUrl: $avatarUrl, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $GithubOrganizationModelCopyWith<$Res> {
  factory $GithubOrganizationModelCopyWith(GithubOrganizationModel value,
          $Res Function(GithubOrganizationModel) _then) =
      _$GithubOrganizationModelCopyWithImpl;
  @useResult
  $Res call(
      {int? id,
      String? name,
      String? login,
      String? company,
      String? blog,
      String? location,
      String? email,
      int publicReposCount,
      int publicGistsCount,
      int followersCount,
      int followingCount,
      ModelUri? htmlUrl,
      ModelImageUri? avatarUrl,
      ModelTimestamp createdAt,
      ModelTimestamp updatedAt});
}

/// @nodoc
class _$GithubOrganizationModelCopyWithImpl<$Res>
    implements $GithubOrganizationModelCopyWith<$Res> {
  _$GithubOrganizationModelCopyWithImpl(this._self, this._then);

  final GithubOrganizationModel _self;
  final $Res Function(GithubOrganizationModel) _then;

  /// Create a copy of GithubOrganizationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? login = freezed,
    Object? company = freezed,
    Object? blog = freezed,
    Object? location = freezed,
    Object? email = freezed,
    Object? publicReposCount = null,
    Object? publicGistsCount = null,
    Object? followersCount = null,
    Object? followingCount = null,
    Object? htmlUrl = freezed,
    Object? avatarUrl = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      login: freezed == login
          ? _self.login
          : login // ignore: cast_nullable_to_non_nullable
              as String?,
      company: freezed == company
          ? _self.company
          : company // ignore: cast_nullable_to_non_nullable
              as String?,
      blog: freezed == blog
          ? _self.blog
          : blog // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _self.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      publicReposCount: null == publicReposCount
          ? _self.publicReposCount
          : publicReposCount // ignore: cast_nullable_to_non_nullable
              as int,
      publicGistsCount: null == publicGistsCount
          ? _self.publicGistsCount
          : publicGistsCount // ignore: cast_nullable_to_non_nullable
              as int,
      followersCount: null == followersCount
          ? _self.followersCount
          : followersCount // ignore: cast_nullable_to_non_nullable
              as int,
      followingCount: null == followingCount
          ? _self.followingCount
          : followingCount // ignore: cast_nullable_to_non_nullable
              as int,
      htmlUrl: freezed == htmlUrl
          ? _self.htmlUrl
          : htmlUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      avatarUrl: freezed == avatarUrl
          ? _self.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as ModelImageUri?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp,
    ));
  }
}

/// Adds pattern-matching-related methods to [GithubOrganizationModel].
extension GithubOrganizationModelPatterns on GithubOrganizationModel {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_GithubOrganizationModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GithubOrganizationModel() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_GithubOrganizationModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubOrganizationModel():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_GithubOrganizationModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubOrganizationModel() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            int? id,
            String? name,
            String? login,
            String? company,
            String? blog,
            String? location,
            String? email,
            int publicReposCount,
            int publicGistsCount,
            int followersCount,
            int followingCount,
            ModelUri? htmlUrl,
            ModelImageUri? avatarUrl,
            ModelTimestamp createdAt,
            ModelTimestamp updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GithubOrganizationModel() when $default != null:
        return $default(
            _that.id,
            _that.name,
            _that.login,
            _that.company,
            _that.blog,
            _that.location,
            _that.email,
            _that.publicReposCount,
            _that.publicGistsCount,
            _that.followersCount,
            _that.followingCount,
            _that.htmlUrl,
            _that.avatarUrl,
            _that.createdAt,
            _that.updatedAt);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            int? id,
            String? name,
            String? login,
            String? company,
            String? blog,
            String? location,
            String? email,
            int publicReposCount,
            int publicGistsCount,
            int followersCount,
            int followingCount,
            ModelUri? htmlUrl,
            ModelImageUri? avatarUrl,
            ModelTimestamp createdAt,
            ModelTimestamp updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubOrganizationModel():
        return $default(
            _that.id,
            _that.name,
            _that.login,
            _that.company,
            _that.blog,
            _that.location,
            _that.email,
            _that.publicReposCount,
            _that.publicGistsCount,
            _that.followersCount,
            _that.followingCount,
            _that.htmlUrl,
            _that.avatarUrl,
            _that.createdAt,
            _that.updatedAt);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            int? id,
            String? name,
            String? login,
            String? company,
            String? blog,
            String? location,
            String? email,
            int publicReposCount,
            int publicGistsCount,
            int followersCount,
            int followingCount,
            ModelUri? htmlUrl,
            ModelImageUri? avatarUrl,
            ModelTimestamp createdAt,
            ModelTimestamp updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubOrganizationModel() when $default != null:
        return $default(
            _that.id,
            _that.name,
            _that.login,
            _that.company,
            _that.blog,
            _that.location,
            _that.email,
            _that.publicReposCount,
            _that.publicGistsCount,
            _that.followersCount,
            _that.followingCount,
            _that.htmlUrl,
            _that.avatarUrl,
            _that.createdAt,
            _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _GithubOrganizationModel extends GithubOrganizationModel {
  const _GithubOrganizationModel(
      {this.id,
      this.name,
      this.login,
      this.company,
      this.blog,
      this.location,
      this.email,
      this.publicReposCount = 0,
      this.publicGistsCount = 0,
      this.followersCount = 0,
      this.followingCount = 0,
      this.htmlUrl,
      this.avatarUrl,
      this.createdAt = const ModelTimestamp.now(),
      this.updatedAt = const ModelTimestamp.now()})
      : super._();
  factory _GithubOrganizationModel.fromJson(Map<String, dynamic> json) =>
      _$GithubOrganizationModelFromJson(json);

  @override
  final int? id;
  @override
  final String? name;
  @override
  final String? login;
  @override
  final String? company;
  @override
  final String? blog;
  @override
  final String? location;
  @override
  final String? email;
  @override
  @JsonKey()
  final int publicReposCount;
  @override
  @JsonKey()
  final int publicGistsCount;
  @override
  @JsonKey()
  final int followersCount;
  @override
  @JsonKey()
  final int followingCount;
  @override
  final ModelUri? htmlUrl;
  @override
  final ModelImageUri? avatarUrl;
  @override
  @JsonKey()
  final ModelTimestamp createdAt;
  @override
  @JsonKey()
  final ModelTimestamp updatedAt;

  /// Create a copy of GithubOrganizationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GithubOrganizationModelCopyWith<_GithubOrganizationModel> get copyWith =>
      __$GithubOrganizationModelCopyWithImpl<_GithubOrganizationModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GithubOrganizationModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GithubOrganizationModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.login, login) || other.login == login) &&
            (identical(other.company, company) || other.company == company) &&
            (identical(other.blog, blog) || other.blog == blog) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.publicReposCount, publicReposCount) ||
                other.publicReposCount == publicReposCount) &&
            (identical(other.publicGistsCount, publicGistsCount) ||
                other.publicGistsCount == publicGistsCount) &&
            (identical(other.followersCount, followersCount) ||
                other.followersCount == followersCount) &&
            (identical(other.followingCount, followingCount) ||
                other.followingCount == followingCount) &&
            (identical(other.htmlUrl, htmlUrl) || other.htmlUrl == htmlUrl) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
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
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'GithubOrganizationModel(id: $id, name: $name, login: $login, company: $company, blog: $blog, location: $location, email: $email, publicReposCount: $publicReposCount, publicGistsCount: $publicGistsCount, followersCount: $followersCount, followingCount: $followingCount, htmlUrl: $htmlUrl, avatarUrl: $avatarUrl, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$GithubOrganizationModelCopyWith<$Res>
    implements $GithubOrganizationModelCopyWith<$Res> {
  factory _$GithubOrganizationModelCopyWith(_GithubOrganizationModel value,
          $Res Function(_GithubOrganizationModel) _then) =
      __$GithubOrganizationModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? id,
      String? name,
      String? login,
      String? company,
      String? blog,
      String? location,
      String? email,
      int publicReposCount,
      int publicGistsCount,
      int followersCount,
      int followingCount,
      ModelUri? htmlUrl,
      ModelImageUri? avatarUrl,
      ModelTimestamp createdAt,
      ModelTimestamp updatedAt});
}

/// @nodoc
class __$GithubOrganizationModelCopyWithImpl<$Res>
    implements _$GithubOrganizationModelCopyWith<$Res> {
  __$GithubOrganizationModelCopyWithImpl(this._self, this._then);

  final _GithubOrganizationModel _self;
  final $Res Function(_GithubOrganizationModel) _then;

  /// Create a copy of GithubOrganizationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? login = freezed,
    Object? company = freezed,
    Object? blog = freezed,
    Object? location = freezed,
    Object? email = freezed,
    Object? publicReposCount = null,
    Object? publicGistsCount = null,
    Object? followersCount = null,
    Object? followingCount = null,
    Object? htmlUrl = freezed,
    Object? avatarUrl = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_GithubOrganizationModel(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      login: freezed == login
          ? _self.login
          : login // ignore: cast_nullable_to_non_nullable
              as String?,
      company: freezed == company
          ? _self.company
          : company // ignore: cast_nullable_to_non_nullable
              as String?,
      blog: freezed == blog
          ? _self.blog
          : blog // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _self.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      publicReposCount: null == publicReposCount
          ? _self.publicReposCount
          : publicReposCount // ignore: cast_nullable_to_non_nullable
              as int,
      publicGistsCount: null == publicGistsCount
          ? _self.publicGistsCount
          : publicGistsCount // ignore: cast_nullable_to_non_nullable
              as int,
      followersCount: null == followersCount
          ? _self.followersCount
          : followersCount // ignore: cast_nullable_to_non_nullable
              as int,
      followingCount: null == followingCount
          ? _self.followingCount
          : followingCount // ignore: cast_nullable_to_non_nullable
              as int,
      htmlUrl: freezed == htmlUrl
          ? _self.htmlUrl
          : htmlUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      avatarUrl: freezed == avatarUrl
          ? _self.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as ModelImageUri?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp,
    ));
  }
}

// dart format on
