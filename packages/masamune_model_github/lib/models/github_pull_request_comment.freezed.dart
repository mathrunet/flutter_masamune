// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'github_pull_request_comment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GithubPullRequestCommentModel {
  int? get id;
  String? get body;
  String? get diffHunk;
  String? get path;
  int? get position;
  int? get originalPosition;
  String? get commitId;
  String? get originalCommitId;
  @refParam
  GithubUserModelRef? get user;
  ModelUri? get url;
  ModelUri? get pullRequestUrl;
  ModelUri? get links;
  ModelTimestamp get createdAt;
  ModelTimestamp get updatedAt;

  /// Create a copy of GithubPullRequestCommentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GithubPullRequestCommentModelCopyWith<GithubPullRequestCommentModel>
      get copyWith => _$GithubPullRequestCommentModelCopyWithImpl<
              GithubPullRequestCommentModel>(
          this as GithubPullRequestCommentModel, _$identity);

  /// Serializes this GithubPullRequestCommentModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GithubPullRequestCommentModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.diffHunk, diffHunk) ||
                other.diffHunk == diffHunk) &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.originalPosition, originalPosition) ||
                other.originalPosition == originalPosition) &&
            (identical(other.commitId, commitId) ||
                other.commitId == commitId) &&
            (identical(other.originalCommitId, originalCommitId) ||
                other.originalCommitId == originalCommitId) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.pullRequestUrl, pullRequestUrl) ||
                other.pullRequestUrl == pullRequestUrl) &&
            (identical(other.links, links) || other.links == links) &&
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
      updatedAt);

  @override
  String toString() {
    return 'GithubPullRequestCommentModel(id: $id, body: $body, diffHunk: $diffHunk, path: $path, position: $position, originalPosition: $originalPosition, commitId: $commitId, originalCommitId: $originalCommitId, user: $user, url: $url, pullRequestUrl: $pullRequestUrl, links: $links, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $GithubPullRequestCommentModelCopyWith<$Res> {
  factory $GithubPullRequestCommentModelCopyWith(
          GithubPullRequestCommentModel value,
          $Res Function(GithubPullRequestCommentModel) _then) =
      _$GithubPullRequestCommentModelCopyWithImpl;
  @useResult
  $Res call(
      {int? id,
      String? body,
      String? diffHunk,
      String? path,
      int? position,
      int? originalPosition,
      String? commitId,
      String? originalCommitId,
      @refParam GithubUserModelRef? user,
      ModelUri? url,
      ModelUri? pullRequestUrl,
      ModelUri? links,
      ModelTimestamp createdAt,
      ModelTimestamp updatedAt});
}

/// @nodoc
class _$GithubPullRequestCommentModelCopyWithImpl<$Res>
    implements $GithubPullRequestCommentModelCopyWith<$Res> {
  _$GithubPullRequestCommentModelCopyWithImpl(this._self, this._then);

  final GithubPullRequestCommentModel _self;
  final $Res Function(GithubPullRequestCommentModel) _then;

  /// Create a copy of GithubPullRequestCommentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? body = freezed,
    Object? diffHunk = freezed,
    Object? path = freezed,
    Object? position = freezed,
    Object? originalPosition = freezed,
    Object? commitId = freezed,
    Object? originalCommitId = freezed,
    Object? user = freezed,
    Object? url = freezed,
    Object? pullRequestUrl = freezed,
    Object? links = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      body: freezed == body
          ? _self.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
      diffHunk: freezed == diffHunk
          ? _self.diffHunk
          : diffHunk // ignore: cast_nullable_to_non_nullable
              as String?,
      path: freezed == path
          ? _self.path
          : path // ignore: cast_nullable_to_non_nullable
              as String?,
      position: freezed == position
          ? _self.position
          : position // ignore: cast_nullable_to_non_nullable
              as int?,
      originalPosition: freezed == originalPosition
          ? _self.originalPosition
          : originalPosition // ignore: cast_nullable_to_non_nullable
              as int?,
      commitId: freezed == commitId
          ? _self.commitId
          : commitId // ignore: cast_nullable_to_non_nullable
              as String?,
      originalCommitId: freezed == originalCommitId
          ? _self.originalCommitId
          : originalCommitId // ignore: cast_nullable_to_non_nullable
              as String?,
      user: freezed == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as GithubUserModelRef?,
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      pullRequestUrl: freezed == pullRequestUrl
          ? _self.pullRequestUrl
          : pullRequestUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      links: freezed == links
          ? _self.links
          : links // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
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

/// Adds pattern-matching-related methods to [GithubPullRequestCommentModel].
extension GithubPullRequestCommentModelPatterns
    on GithubPullRequestCommentModel {
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
    TResult Function(_GithubPullRequestCommentModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GithubPullRequestCommentModel() when $default != null:
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
    TResult Function(_GithubPullRequestCommentModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubPullRequestCommentModel():
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
    TResult? Function(_GithubPullRequestCommentModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubPullRequestCommentModel() when $default != null:
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
            String? body,
            String? diffHunk,
            String? path,
            int? position,
            int? originalPosition,
            String? commitId,
            String? originalCommitId,
            @refParam GithubUserModelRef? user,
            ModelUri? url,
            ModelUri? pullRequestUrl,
            ModelUri? links,
            ModelTimestamp createdAt,
            ModelTimestamp updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GithubPullRequestCommentModel() when $default != null:
        return $default(
            _that.id,
            _that.body,
            _that.diffHunk,
            _that.path,
            _that.position,
            _that.originalPosition,
            _that.commitId,
            _that.originalCommitId,
            _that.user,
            _that.url,
            _that.pullRequestUrl,
            _that.links,
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
            String? body,
            String? diffHunk,
            String? path,
            int? position,
            int? originalPosition,
            String? commitId,
            String? originalCommitId,
            @refParam GithubUserModelRef? user,
            ModelUri? url,
            ModelUri? pullRequestUrl,
            ModelUri? links,
            ModelTimestamp createdAt,
            ModelTimestamp updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubPullRequestCommentModel():
        return $default(
            _that.id,
            _that.body,
            _that.diffHunk,
            _that.path,
            _that.position,
            _that.originalPosition,
            _that.commitId,
            _that.originalCommitId,
            _that.user,
            _that.url,
            _that.pullRequestUrl,
            _that.links,
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
            String? body,
            String? diffHunk,
            String? path,
            int? position,
            int? originalPosition,
            String? commitId,
            String? originalCommitId,
            @refParam GithubUserModelRef? user,
            ModelUri? url,
            ModelUri? pullRequestUrl,
            ModelUri? links,
            ModelTimestamp createdAt,
            ModelTimestamp updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubPullRequestCommentModel() when $default != null:
        return $default(
            _that.id,
            _that.body,
            _that.diffHunk,
            _that.path,
            _that.position,
            _that.originalPosition,
            _that.commitId,
            _that.originalCommitId,
            _that.user,
            _that.url,
            _that.pullRequestUrl,
            _that.links,
            _that.createdAt,
            _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _GithubPullRequestCommentModel extends GithubPullRequestCommentModel {
  const _GithubPullRequestCommentModel(
      {this.id,
      this.body,
      this.diffHunk,
      this.path,
      this.position,
      this.originalPosition,
      this.commitId,
      this.originalCommitId,
      @refParam this.user,
      this.url,
      this.pullRequestUrl,
      this.links = const [],
      this.createdAt = const ModelTimestamp.now(),
      this.updatedAt = const ModelTimestamp.now()})
      : super._();
  factory _GithubPullRequestCommentModel.fromJson(Map<String, dynamic> json) =>
      _$GithubPullRequestCommentModelFromJson(json);

  @override
  final int? id;
  @override
  final String? body;
  @override
  final String? diffHunk;
  @override
  final String? path;
  @override
  final int? position;
  @override
  final int? originalPosition;
  @override
  final String? commitId;
  @override
  final String? originalCommitId;
  @override
  @refParam
  final GithubUserModelRef? user;
  @override
  final ModelUri? url;
  @override
  final ModelUri? pullRequestUrl;
  @override
  @JsonKey()
  final ModelUri? links;
  @override
  @JsonKey()
  final ModelTimestamp createdAt;
  @override
  @JsonKey()
  final ModelTimestamp updatedAt;

  /// Create a copy of GithubPullRequestCommentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GithubPullRequestCommentModelCopyWith<_GithubPullRequestCommentModel>
      get copyWith => __$GithubPullRequestCommentModelCopyWithImpl<
          _GithubPullRequestCommentModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GithubPullRequestCommentModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GithubPullRequestCommentModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.diffHunk, diffHunk) ||
                other.diffHunk == diffHunk) &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.originalPosition, originalPosition) ||
                other.originalPosition == originalPosition) &&
            (identical(other.commitId, commitId) ||
                other.commitId == commitId) &&
            (identical(other.originalCommitId, originalCommitId) ||
                other.originalCommitId == originalCommitId) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.pullRequestUrl, pullRequestUrl) ||
                other.pullRequestUrl == pullRequestUrl) &&
            (identical(other.links, links) || other.links == links) &&
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
      updatedAt);

  @override
  String toString() {
    return 'GithubPullRequestCommentModel(id: $id, body: $body, diffHunk: $diffHunk, path: $path, position: $position, originalPosition: $originalPosition, commitId: $commitId, originalCommitId: $originalCommitId, user: $user, url: $url, pullRequestUrl: $pullRequestUrl, links: $links, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$GithubPullRequestCommentModelCopyWith<$Res>
    implements $GithubPullRequestCommentModelCopyWith<$Res> {
  factory _$GithubPullRequestCommentModelCopyWith(
          _GithubPullRequestCommentModel value,
          $Res Function(_GithubPullRequestCommentModel) _then) =
      __$GithubPullRequestCommentModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? id,
      String? body,
      String? diffHunk,
      String? path,
      int? position,
      int? originalPosition,
      String? commitId,
      String? originalCommitId,
      @refParam GithubUserModelRef? user,
      ModelUri? url,
      ModelUri? pullRequestUrl,
      ModelUri? links,
      ModelTimestamp createdAt,
      ModelTimestamp updatedAt});
}

/// @nodoc
class __$GithubPullRequestCommentModelCopyWithImpl<$Res>
    implements _$GithubPullRequestCommentModelCopyWith<$Res> {
  __$GithubPullRequestCommentModelCopyWithImpl(this._self, this._then);

  final _GithubPullRequestCommentModel _self;
  final $Res Function(_GithubPullRequestCommentModel) _then;

  /// Create a copy of GithubPullRequestCommentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? body = freezed,
    Object? diffHunk = freezed,
    Object? path = freezed,
    Object? position = freezed,
    Object? originalPosition = freezed,
    Object? commitId = freezed,
    Object? originalCommitId = freezed,
    Object? user = freezed,
    Object? url = freezed,
    Object? pullRequestUrl = freezed,
    Object? links = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_GithubPullRequestCommentModel(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      body: freezed == body
          ? _self.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
      diffHunk: freezed == diffHunk
          ? _self.diffHunk
          : diffHunk // ignore: cast_nullable_to_non_nullable
              as String?,
      path: freezed == path
          ? _self.path
          : path // ignore: cast_nullable_to_non_nullable
              as String?,
      position: freezed == position
          ? _self.position
          : position // ignore: cast_nullable_to_non_nullable
              as int?,
      originalPosition: freezed == originalPosition
          ? _self.originalPosition
          : originalPosition // ignore: cast_nullable_to_non_nullable
              as int?,
      commitId: freezed == commitId
          ? _self.commitId
          : commitId // ignore: cast_nullable_to_non_nullable
              as String?,
      originalCommitId: freezed == originalCommitId
          ? _self.originalCommitId
          : originalCommitId // ignore: cast_nullable_to_non_nullable
              as String?,
      user: freezed == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as GithubUserModelRef?,
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      pullRequestUrl: freezed == pullRequestUrl
          ? _self.pullRequestUrl
          : pullRequestUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      links: freezed == links
          ? _self.links
          : links // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
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
