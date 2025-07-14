// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'github_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GithubUserModel {
  int? get id;
  String? get login;
  String? get name;
  String? get company;
  String? get blog;
  String? get bio;
  String? get location;
  String? get email;
  String? get xUsername;
  String? get nodeId;
  String? get type;
  bool get siteAdmin;
  bool get hirable;
  int get publicReposCount;
  int get publicGistsCount;
  int get followersCount;
  int get followingCount;
  ModelImageUri? get avatarUrl;
  String? get gravatarId;
  ModelUri? get htmlUrl;
  ModelUri? get userUrl;
  ModelUri? get eventsUrl;
  ModelUri? get followersUrl;
  ModelUri? get followingUrl;
  ModelUri? get gistsUrl;
  ModelUri? get organizationsUrl;
  ModelUri? get receivedEventsUrl;
  ModelUri? get reposUrl;
  ModelUri? get starredUrl;
  ModelUri? get subscriptionsUrl;
  ModelTimestamp? get starredAt;
  ModelTimestamp get createdAt;
  ModelTimestamp get updatedAt;

  /// Create a copy of GithubUserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GithubUserModelCopyWith<GithubUserModel> get copyWith =>
      _$GithubUserModelCopyWithImpl<GithubUserModel>(
          this as GithubUserModel, _$identity);

  /// Serializes this GithubUserModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GithubUserModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.login, login) || other.login == login) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.company, company) || other.company == company) &&
            (identical(other.blog, blog) || other.blog == blog) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.xUsername, xUsername) ||
                other.xUsername == xUsername) &&
            (identical(other.nodeId, nodeId) || other.nodeId == nodeId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.siteAdmin, siteAdmin) ||
                other.siteAdmin == siteAdmin) &&
            (identical(other.hirable, hirable) || other.hirable == hirable) &&
            (identical(other.publicReposCount, publicReposCount) ||
                other.publicReposCount == publicReposCount) &&
            (identical(other.publicGistsCount, publicGistsCount) ||
                other.publicGistsCount == publicGistsCount) &&
            (identical(other.followersCount, followersCount) ||
                other.followersCount == followersCount) &&
            (identical(other.followingCount, followingCount) ||
                other.followingCount == followingCount) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.gravatarId, gravatarId) ||
                other.gravatarId == gravatarId) &&
            (identical(other.htmlUrl, htmlUrl) || other.htmlUrl == htmlUrl) &&
            (identical(other.userUrl, userUrl) || other.userUrl == userUrl) &&
            (identical(other.eventsUrl, eventsUrl) ||
                other.eventsUrl == eventsUrl) &&
            (identical(other.followersUrl, followersUrl) ||
                other.followersUrl == followersUrl) &&
            (identical(other.followingUrl, followingUrl) ||
                other.followingUrl == followingUrl) &&
            (identical(other.gistsUrl, gistsUrl) ||
                other.gistsUrl == gistsUrl) &&
            (identical(other.organizationsUrl, organizationsUrl) ||
                other.organizationsUrl == organizationsUrl) &&
            (identical(other.receivedEventsUrl, receivedEventsUrl) ||
                other.receivedEventsUrl == receivedEventsUrl) &&
            (identical(other.reposUrl, reposUrl) ||
                other.reposUrl == reposUrl) &&
            (identical(other.starredUrl, starredUrl) ||
                other.starredUrl == starredUrl) &&
            (identical(other.subscriptionsUrl, subscriptionsUrl) ||
                other.subscriptionsUrl == subscriptionsUrl) &&
            (identical(other.starredAt, starredAt) ||
                other.starredAt == starredAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
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
        updatedAt
      ]);

  @override
  String toString() {
    return 'GithubUserModel(id: $id, login: $login, name: $name, company: $company, blog: $blog, bio: $bio, location: $location, email: $email, xUsername: $xUsername, nodeId: $nodeId, type: $type, siteAdmin: $siteAdmin, hirable: $hirable, publicReposCount: $publicReposCount, publicGistsCount: $publicGistsCount, followersCount: $followersCount, followingCount: $followingCount, avatarUrl: $avatarUrl, gravatarId: $gravatarId, htmlUrl: $htmlUrl, userUrl: $userUrl, eventsUrl: $eventsUrl, followersUrl: $followersUrl, followingUrl: $followingUrl, gistsUrl: $gistsUrl, organizationsUrl: $organizationsUrl, receivedEventsUrl: $receivedEventsUrl, reposUrl: $reposUrl, starredUrl: $starredUrl, subscriptionsUrl: $subscriptionsUrl, starredAt: $starredAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $GithubUserModelCopyWith<$Res> {
  factory $GithubUserModelCopyWith(
          GithubUserModel value, $Res Function(GithubUserModel) _then) =
      _$GithubUserModelCopyWithImpl;
  @useResult
  $Res call(
      {int? id,
      String? login,
      String? name,
      String? company,
      String? blog,
      String? bio,
      String? location,
      String? email,
      String? xUsername,
      String? nodeId,
      String? type,
      bool siteAdmin,
      bool hirable,
      int publicReposCount,
      int publicGistsCount,
      int followersCount,
      int followingCount,
      ModelImageUri? avatarUrl,
      String? gravatarId,
      ModelUri? htmlUrl,
      ModelUri? userUrl,
      ModelUri? eventsUrl,
      ModelUri? followersUrl,
      ModelUri? followingUrl,
      ModelUri? gistsUrl,
      ModelUri? organizationsUrl,
      ModelUri? receivedEventsUrl,
      ModelUri? reposUrl,
      ModelUri? starredUrl,
      ModelUri? subscriptionsUrl,
      ModelTimestamp? starredAt,
      ModelTimestamp createdAt,
      ModelTimestamp updatedAt});
}

/// @nodoc
class _$GithubUserModelCopyWithImpl<$Res>
    implements $GithubUserModelCopyWith<$Res> {
  _$GithubUserModelCopyWithImpl(this._self, this._then);

  final GithubUserModel _self;
  final $Res Function(GithubUserModel) _then;

  /// Create a copy of GithubUserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? login = freezed,
    Object? name = freezed,
    Object? company = freezed,
    Object? blog = freezed,
    Object? bio = freezed,
    Object? location = freezed,
    Object? email = freezed,
    Object? xUsername = freezed,
    Object? nodeId = freezed,
    Object? type = freezed,
    Object? siteAdmin = null,
    Object? hirable = null,
    Object? publicReposCount = null,
    Object? publicGistsCount = null,
    Object? followersCount = null,
    Object? followingCount = null,
    Object? avatarUrl = freezed,
    Object? gravatarId = freezed,
    Object? htmlUrl = freezed,
    Object? userUrl = freezed,
    Object? eventsUrl = freezed,
    Object? followersUrl = freezed,
    Object? followingUrl = freezed,
    Object? gistsUrl = freezed,
    Object? organizationsUrl = freezed,
    Object? receivedEventsUrl = freezed,
    Object? reposUrl = freezed,
    Object? starredUrl = freezed,
    Object? subscriptionsUrl = freezed,
    Object? starredAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      login: freezed == login
          ? _self.login
          : login // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      company: freezed == company
          ? _self.company
          : company // ignore: cast_nullable_to_non_nullable
              as String?,
      blog: freezed == blog
          ? _self.blog
          : blog // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _self.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _self.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      xUsername: freezed == xUsername
          ? _self.xUsername
          : xUsername // ignore: cast_nullable_to_non_nullable
              as String?,
      nodeId: freezed == nodeId
          ? _self.nodeId
          : nodeId // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      siteAdmin: null == siteAdmin
          ? _self.siteAdmin
          : siteAdmin // ignore: cast_nullable_to_non_nullable
              as bool,
      hirable: null == hirable
          ? _self.hirable
          : hirable // ignore: cast_nullable_to_non_nullable
              as bool,
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
      avatarUrl: freezed == avatarUrl
          ? _self.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as ModelImageUri?,
      gravatarId: freezed == gravatarId
          ? _self.gravatarId
          : gravatarId // ignore: cast_nullable_to_non_nullable
              as String?,
      htmlUrl: freezed == htmlUrl
          ? _self.htmlUrl
          : htmlUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      userUrl: freezed == userUrl
          ? _self.userUrl
          : userUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      eventsUrl: freezed == eventsUrl
          ? _self.eventsUrl
          : eventsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      followersUrl: freezed == followersUrl
          ? _self.followersUrl
          : followersUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      followingUrl: freezed == followingUrl
          ? _self.followingUrl
          : followingUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      gistsUrl: freezed == gistsUrl
          ? _self.gistsUrl
          : gistsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      organizationsUrl: freezed == organizationsUrl
          ? _self.organizationsUrl
          : organizationsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      receivedEventsUrl: freezed == receivedEventsUrl
          ? _self.receivedEventsUrl
          : receivedEventsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      reposUrl: freezed == reposUrl
          ? _self.reposUrl
          : reposUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      starredUrl: freezed == starredUrl
          ? _self.starredUrl
          : starredUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      subscriptionsUrl: freezed == subscriptionsUrl
          ? _self.subscriptionsUrl
          : subscriptionsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      starredAt: freezed == starredAt
          ? _self.starredAt
          : starredAt // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp?,
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

/// Adds pattern-matching-related methods to [GithubUserModel].
extension GithubUserModelPatterns on GithubUserModel {
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
    TResult Function(_GithubUserModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GithubUserModel() when $default != null:
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
    TResult Function(_GithubUserModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubUserModel():
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
    TResult? Function(_GithubUserModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubUserModel() when $default != null:
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
            String? login,
            String? name,
            String? company,
            String? blog,
            String? bio,
            String? location,
            String? email,
            String? xUsername,
            String? nodeId,
            String? type,
            bool siteAdmin,
            bool hirable,
            int publicReposCount,
            int publicGistsCount,
            int followersCount,
            int followingCount,
            ModelImageUri? avatarUrl,
            String? gravatarId,
            ModelUri? htmlUrl,
            ModelUri? userUrl,
            ModelUri? eventsUrl,
            ModelUri? followersUrl,
            ModelUri? followingUrl,
            ModelUri? gistsUrl,
            ModelUri? organizationsUrl,
            ModelUri? receivedEventsUrl,
            ModelUri? reposUrl,
            ModelUri? starredUrl,
            ModelUri? subscriptionsUrl,
            ModelTimestamp? starredAt,
            ModelTimestamp createdAt,
            ModelTimestamp updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GithubUserModel() when $default != null:
        return $default(
            _that.id,
            _that.login,
            _that.name,
            _that.company,
            _that.blog,
            _that.bio,
            _that.location,
            _that.email,
            _that.xUsername,
            _that.nodeId,
            _that.type,
            _that.siteAdmin,
            _that.hirable,
            _that.publicReposCount,
            _that.publicGistsCount,
            _that.followersCount,
            _that.followingCount,
            _that.avatarUrl,
            _that.gravatarId,
            _that.htmlUrl,
            _that.userUrl,
            _that.eventsUrl,
            _that.followersUrl,
            _that.followingUrl,
            _that.gistsUrl,
            _that.organizationsUrl,
            _that.receivedEventsUrl,
            _that.reposUrl,
            _that.starredUrl,
            _that.subscriptionsUrl,
            _that.starredAt,
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
            String? login,
            String? name,
            String? company,
            String? blog,
            String? bio,
            String? location,
            String? email,
            String? xUsername,
            String? nodeId,
            String? type,
            bool siteAdmin,
            bool hirable,
            int publicReposCount,
            int publicGistsCount,
            int followersCount,
            int followingCount,
            ModelImageUri? avatarUrl,
            String? gravatarId,
            ModelUri? htmlUrl,
            ModelUri? userUrl,
            ModelUri? eventsUrl,
            ModelUri? followersUrl,
            ModelUri? followingUrl,
            ModelUri? gistsUrl,
            ModelUri? organizationsUrl,
            ModelUri? receivedEventsUrl,
            ModelUri? reposUrl,
            ModelUri? starredUrl,
            ModelUri? subscriptionsUrl,
            ModelTimestamp? starredAt,
            ModelTimestamp createdAt,
            ModelTimestamp updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubUserModel():
        return $default(
            _that.id,
            _that.login,
            _that.name,
            _that.company,
            _that.blog,
            _that.bio,
            _that.location,
            _that.email,
            _that.xUsername,
            _that.nodeId,
            _that.type,
            _that.siteAdmin,
            _that.hirable,
            _that.publicReposCount,
            _that.publicGistsCount,
            _that.followersCount,
            _that.followingCount,
            _that.avatarUrl,
            _that.gravatarId,
            _that.htmlUrl,
            _that.userUrl,
            _that.eventsUrl,
            _that.followersUrl,
            _that.followingUrl,
            _that.gistsUrl,
            _that.organizationsUrl,
            _that.receivedEventsUrl,
            _that.reposUrl,
            _that.starredUrl,
            _that.subscriptionsUrl,
            _that.starredAt,
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
            String? login,
            String? name,
            String? company,
            String? blog,
            String? bio,
            String? location,
            String? email,
            String? xUsername,
            String? nodeId,
            String? type,
            bool siteAdmin,
            bool hirable,
            int publicReposCount,
            int publicGistsCount,
            int followersCount,
            int followingCount,
            ModelImageUri? avatarUrl,
            String? gravatarId,
            ModelUri? htmlUrl,
            ModelUri? userUrl,
            ModelUri? eventsUrl,
            ModelUri? followersUrl,
            ModelUri? followingUrl,
            ModelUri? gistsUrl,
            ModelUri? organizationsUrl,
            ModelUri? receivedEventsUrl,
            ModelUri? reposUrl,
            ModelUri? starredUrl,
            ModelUri? subscriptionsUrl,
            ModelTimestamp? starredAt,
            ModelTimestamp createdAt,
            ModelTimestamp updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubUserModel() when $default != null:
        return $default(
            _that.id,
            _that.login,
            _that.name,
            _that.company,
            _that.blog,
            _that.bio,
            _that.location,
            _that.email,
            _that.xUsername,
            _that.nodeId,
            _that.type,
            _that.siteAdmin,
            _that.hirable,
            _that.publicReposCount,
            _that.publicGistsCount,
            _that.followersCount,
            _that.followingCount,
            _that.avatarUrl,
            _that.gravatarId,
            _that.htmlUrl,
            _that.userUrl,
            _that.eventsUrl,
            _that.followersUrl,
            _that.followingUrl,
            _that.gistsUrl,
            _that.organizationsUrl,
            _that.receivedEventsUrl,
            _that.reposUrl,
            _that.starredUrl,
            _that.subscriptionsUrl,
            _that.starredAt,
            _that.createdAt,
            _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _GithubUserModel extends GithubUserModel {
  const _GithubUserModel(
      {this.id,
      this.login,
      this.name,
      this.company,
      this.blog,
      this.bio,
      this.location,
      this.email,
      this.xUsername,
      this.nodeId,
      this.type,
      this.siteAdmin = false,
      this.hirable = false,
      this.publicReposCount = 0,
      this.publicGistsCount = 0,
      this.followersCount = 0,
      this.followingCount = 0,
      this.avatarUrl,
      this.gravatarId,
      this.htmlUrl,
      this.userUrl,
      this.eventsUrl,
      this.followersUrl,
      this.followingUrl,
      this.gistsUrl,
      this.organizationsUrl,
      this.receivedEventsUrl,
      this.reposUrl,
      this.starredUrl,
      this.subscriptionsUrl,
      this.starredAt,
      this.createdAt = const ModelTimestamp.now(),
      this.updatedAt = const ModelTimestamp.now()})
      : super._();
  factory _GithubUserModel.fromJson(Map<String, dynamic> json) =>
      _$GithubUserModelFromJson(json);

  @override
  final int? id;
  @override
  final String? login;
  @override
  final String? name;
  @override
  final String? company;
  @override
  final String? blog;
  @override
  final String? bio;
  @override
  final String? location;
  @override
  final String? email;
  @override
  final String? xUsername;
  @override
  final String? nodeId;
  @override
  final String? type;
  @override
  @JsonKey()
  final bool siteAdmin;
  @override
  @JsonKey()
  final bool hirable;
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
  final ModelImageUri? avatarUrl;
  @override
  final String? gravatarId;
  @override
  final ModelUri? htmlUrl;
  @override
  final ModelUri? userUrl;
  @override
  final ModelUri? eventsUrl;
  @override
  final ModelUri? followersUrl;
  @override
  final ModelUri? followingUrl;
  @override
  final ModelUri? gistsUrl;
  @override
  final ModelUri? organizationsUrl;
  @override
  final ModelUri? receivedEventsUrl;
  @override
  final ModelUri? reposUrl;
  @override
  final ModelUri? starredUrl;
  @override
  final ModelUri? subscriptionsUrl;
  @override
  final ModelTimestamp? starredAt;
  @override
  @JsonKey()
  final ModelTimestamp createdAt;
  @override
  @JsonKey()
  final ModelTimestamp updatedAt;

  /// Create a copy of GithubUserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GithubUserModelCopyWith<_GithubUserModel> get copyWith =>
      __$GithubUserModelCopyWithImpl<_GithubUserModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GithubUserModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GithubUserModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.login, login) || other.login == login) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.company, company) || other.company == company) &&
            (identical(other.blog, blog) || other.blog == blog) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.xUsername, xUsername) ||
                other.xUsername == xUsername) &&
            (identical(other.nodeId, nodeId) || other.nodeId == nodeId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.siteAdmin, siteAdmin) ||
                other.siteAdmin == siteAdmin) &&
            (identical(other.hirable, hirable) || other.hirable == hirable) &&
            (identical(other.publicReposCount, publicReposCount) ||
                other.publicReposCount == publicReposCount) &&
            (identical(other.publicGistsCount, publicGistsCount) ||
                other.publicGistsCount == publicGistsCount) &&
            (identical(other.followersCount, followersCount) ||
                other.followersCount == followersCount) &&
            (identical(other.followingCount, followingCount) ||
                other.followingCount == followingCount) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.gravatarId, gravatarId) ||
                other.gravatarId == gravatarId) &&
            (identical(other.htmlUrl, htmlUrl) || other.htmlUrl == htmlUrl) &&
            (identical(other.userUrl, userUrl) || other.userUrl == userUrl) &&
            (identical(other.eventsUrl, eventsUrl) ||
                other.eventsUrl == eventsUrl) &&
            (identical(other.followersUrl, followersUrl) ||
                other.followersUrl == followersUrl) &&
            (identical(other.followingUrl, followingUrl) ||
                other.followingUrl == followingUrl) &&
            (identical(other.gistsUrl, gistsUrl) ||
                other.gistsUrl == gistsUrl) &&
            (identical(other.organizationsUrl, organizationsUrl) ||
                other.organizationsUrl == organizationsUrl) &&
            (identical(other.receivedEventsUrl, receivedEventsUrl) ||
                other.receivedEventsUrl == receivedEventsUrl) &&
            (identical(other.reposUrl, reposUrl) ||
                other.reposUrl == reposUrl) &&
            (identical(other.starredUrl, starredUrl) ||
                other.starredUrl == starredUrl) &&
            (identical(other.subscriptionsUrl, subscriptionsUrl) ||
                other.subscriptionsUrl == subscriptionsUrl) &&
            (identical(other.starredAt, starredAt) ||
                other.starredAt == starredAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
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
        updatedAt
      ]);

  @override
  String toString() {
    return 'GithubUserModel(id: $id, login: $login, name: $name, company: $company, blog: $blog, bio: $bio, location: $location, email: $email, xUsername: $xUsername, nodeId: $nodeId, type: $type, siteAdmin: $siteAdmin, hirable: $hirable, publicReposCount: $publicReposCount, publicGistsCount: $publicGistsCount, followersCount: $followersCount, followingCount: $followingCount, avatarUrl: $avatarUrl, gravatarId: $gravatarId, htmlUrl: $htmlUrl, userUrl: $userUrl, eventsUrl: $eventsUrl, followersUrl: $followersUrl, followingUrl: $followingUrl, gistsUrl: $gistsUrl, organizationsUrl: $organizationsUrl, receivedEventsUrl: $receivedEventsUrl, reposUrl: $reposUrl, starredUrl: $starredUrl, subscriptionsUrl: $subscriptionsUrl, starredAt: $starredAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$GithubUserModelCopyWith<$Res>
    implements $GithubUserModelCopyWith<$Res> {
  factory _$GithubUserModelCopyWith(
          _GithubUserModel value, $Res Function(_GithubUserModel) _then) =
      __$GithubUserModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? id,
      String? login,
      String? name,
      String? company,
      String? blog,
      String? bio,
      String? location,
      String? email,
      String? xUsername,
      String? nodeId,
      String? type,
      bool siteAdmin,
      bool hirable,
      int publicReposCount,
      int publicGistsCount,
      int followersCount,
      int followingCount,
      ModelImageUri? avatarUrl,
      String? gravatarId,
      ModelUri? htmlUrl,
      ModelUri? userUrl,
      ModelUri? eventsUrl,
      ModelUri? followersUrl,
      ModelUri? followingUrl,
      ModelUri? gistsUrl,
      ModelUri? organizationsUrl,
      ModelUri? receivedEventsUrl,
      ModelUri? reposUrl,
      ModelUri? starredUrl,
      ModelUri? subscriptionsUrl,
      ModelTimestamp? starredAt,
      ModelTimestamp createdAt,
      ModelTimestamp updatedAt});
}

/// @nodoc
class __$GithubUserModelCopyWithImpl<$Res>
    implements _$GithubUserModelCopyWith<$Res> {
  __$GithubUserModelCopyWithImpl(this._self, this._then);

  final _GithubUserModel _self;
  final $Res Function(_GithubUserModel) _then;

  /// Create a copy of GithubUserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? login = freezed,
    Object? name = freezed,
    Object? company = freezed,
    Object? blog = freezed,
    Object? bio = freezed,
    Object? location = freezed,
    Object? email = freezed,
    Object? xUsername = freezed,
    Object? nodeId = freezed,
    Object? type = freezed,
    Object? siteAdmin = null,
    Object? hirable = null,
    Object? publicReposCount = null,
    Object? publicGistsCount = null,
    Object? followersCount = null,
    Object? followingCount = null,
    Object? avatarUrl = freezed,
    Object? gravatarId = freezed,
    Object? htmlUrl = freezed,
    Object? userUrl = freezed,
    Object? eventsUrl = freezed,
    Object? followersUrl = freezed,
    Object? followingUrl = freezed,
    Object? gistsUrl = freezed,
    Object? organizationsUrl = freezed,
    Object? receivedEventsUrl = freezed,
    Object? reposUrl = freezed,
    Object? starredUrl = freezed,
    Object? subscriptionsUrl = freezed,
    Object? starredAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_GithubUserModel(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      login: freezed == login
          ? _self.login
          : login // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      company: freezed == company
          ? _self.company
          : company // ignore: cast_nullable_to_non_nullable
              as String?,
      blog: freezed == blog
          ? _self.blog
          : blog // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _self.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _self.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      xUsername: freezed == xUsername
          ? _self.xUsername
          : xUsername // ignore: cast_nullable_to_non_nullable
              as String?,
      nodeId: freezed == nodeId
          ? _self.nodeId
          : nodeId // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      siteAdmin: null == siteAdmin
          ? _self.siteAdmin
          : siteAdmin // ignore: cast_nullable_to_non_nullable
              as bool,
      hirable: null == hirable
          ? _self.hirable
          : hirable // ignore: cast_nullable_to_non_nullable
              as bool,
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
      avatarUrl: freezed == avatarUrl
          ? _self.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as ModelImageUri?,
      gravatarId: freezed == gravatarId
          ? _self.gravatarId
          : gravatarId // ignore: cast_nullable_to_non_nullable
              as String?,
      htmlUrl: freezed == htmlUrl
          ? _self.htmlUrl
          : htmlUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      userUrl: freezed == userUrl
          ? _self.userUrl
          : userUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      eventsUrl: freezed == eventsUrl
          ? _self.eventsUrl
          : eventsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      followersUrl: freezed == followersUrl
          ? _self.followersUrl
          : followersUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      followingUrl: freezed == followingUrl
          ? _self.followingUrl
          : followingUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      gistsUrl: freezed == gistsUrl
          ? _self.gistsUrl
          : gistsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      organizationsUrl: freezed == organizationsUrl
          ? _self.organizationsUrl
          : organizationsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      receivedEventsUrl: freezed == receivedEventsUrl
          ? _self.receivedEventsUrl
          : receivedEventsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      reposUrl: freezed == reposUrl
          ? _self.reposUrl
          : reposUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      starredUrl: freezed == starredUrl
          ? _self.starredUrl
          : starredUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      subscriptionsUrl: freezed == subscriptionsUrl
          ? _self.subscriptionsUrl
          : subscriptionsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      starredAt: freezed == starredAt
          ? _self.starredAt
          : starredAt // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp?,
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
