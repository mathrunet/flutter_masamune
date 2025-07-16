// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'github_issue_comment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GithubIssueCommentModel {
  int? get id;
  String? get body;
  String? get authorAssociation;
  @refParam
  GithubUserModelRef? get user;
  ModelUri? get url;
  ModelUri? get htmlUrl;
  ModelUri? get issueUrl;
  ModelTimestamp get createdAt;
  ModelTimestamp get updatedAt;
  bool get fromServer;

  /// Create a copy of GithubIssueCommentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GithubIssueCommentModelCopyWith<GithubIssueCommentModel> get copyWith =>
      _$GithubIssueCommentModelCopyWithImpl<GithubIssueCommentModel>(
          this as GithubIssueCommentModel, _$identity);

  /// Serializes this GithubIssueCommentModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GithubIssueCommentModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.authorAssociation, authorAssociation) ||
                other.authorAssociation == authorAssociation) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.htmlUrl, htmlUrl) || other.htmlUrl == htmlUrl) &&
            (identical(other.issueUrl, issueUrl) ||
                other.issueUrl == issueUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.fromServer, fromServer) ||
                other.fromServer == fromServer));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, body, authorAssociation,
      user, url, htmlUrl, issueUrl, createdAt, updatedAt, fromServer);

  @override
  String toString() {
    return 'GithubIssueCommentModel(id: $id, body: $body, authorAssociation: $authorAssociation, user: $user, url: $url, htmlUrl: $htmlUrl, issueUrl: $issueUrl, createdAt: $createdAt, updatedAt: $updatedAt, fromServer: $fromServer)';
  }
}

/// @nodoc
abstract mixin class $GithubIssueCommentModelCopyWith<$Res> {
  factory $GithubIssueCommentModelCopyWith(GithubIssueCommentModel value,
          $Res Function(GithubIssueCommentModel) _then) =
      _$GithubIssueCommentModelCopyWithImpl;
  @useResult
  $Res call(
      {int? id,
      String? body,
      String? authorAssociation,
      @refParam GithubUserModelRef? user,
      ModelUri? url,
      ModelUri? htmlUrl,
      ModelUri? issueUrl,
      ModelTimestamp createdAt,
      ModelTimestamp updatedAt,
      bool fromServer});
}

/// @nodoc
class _$GithubIssueCommentModelCopyWithImpl<$Res>
    implements $GithubIssueCommentModelCopyWith<$Res> {
  _$GithubIssueCommentModelCopyWithImpl(this._self, this._then);

  final GithubIssueCommentModel _self;
  final $Res Function(GithubIssueCommentModel) _then;

  /// Create a copy of GithubIssueCommentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? body = freezed,
    Object? authorAssociation = freezed,
    Object? user = freezed,
    Object? url = freezed,
    Object? htmlUrl = freezed,
    Object? issueUrl = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? fromServer = null,
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
      authorAssociation: freezed == authorAssociation
          ? _self.authorAssociation
          : authorAssociation // ignore: cast_nullable_to_non_nullable
              as String?,
      user: freezed == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as GithubUserModelRef?,
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      htmlUrl: freezed == htmlUrl
          ? _self.htmlUrl
          : htmlUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      issueUrl: freezed == issueUrl
          ? _self.issueUrl
          : issueUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp,
      fromServer: null == fromServer
          ? _self.fromServer
          : fromServer // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [GithubIssueCommentModel].
extension GithubIssueCommentModelPatterns on GithubIssueCommentModel {
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
    TResult Function(_GithubIssueCommentModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GithubIssueCommentModel() when $default != null:
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
    TResult Function(_GithubIssueCommentModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubIssueCommentModel():
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
    TResult? Function(_GithubIssueCommentModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubIssueCommentModel() when $default != null:
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
            String? authorAssociation,
            @refParam GithubUserModelRef? user,
            ModelUri? url,
            ModelUri? htmlUrl,
            ModelUri? issueUrl,
            ModelTimestamp createdAt,
            ModelTimestamp updatedAt,
            bool fromServer)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GithubIssueCommentModel() when $default != null:
        return $default(
            _that.id,
            _that.body,
            _that.authorAssociation,
            _that.user,
            _that.url,
            _that.htmlUrl,
            _that.issueUrl,
            _that.createdAt,
            _that.updatedAt,
            _that.fromServer);
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
            String? authorAssociation,
            @refParam GithubUserModelRef? user,
            ModelUri? url,
            ModelUri? htmlUrl,
            ModelUri? issueUrl,
            ModelTimestamp createdAt,
            ModelTimestamp updatedAt,
            bool fromServer)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubIssueCommentModel():
        return $default(
            _that.id,
            _that.body,
            _that.authorAssociation,
            _that.user,
            _that.url,
            _that.htmlUrl,
            _that.issueUrl,
            _that.createdAt,
            _that.updatedAt,
            _that.fromServer);
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
            String? authorAssociation,
            @refParam GithubUserModelRef? user,
            ModelUri? url,
            ModelUri? htmlUrl,
            ModelUri? issueUrl,
            ModelTimestamp createdAt,
            ModelTimestamp updatedAt,
            bool fromServer)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubIssueCommentModel() when $default != null:
        return $default(
            _that.id,
            _that.body,
            _that.authorAssociation,
            _that.user,
            _that.url,
            _that.htmlUrl,
            _that.issueUrl,
            _that.createdAt,
            _that.updatedAt,
            _that.fromServer);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _GithubIssueCommentModel extends GithubIssueCommentModel {
  const _GithubIssueCommentModel(
      {this.id,
      this.body,
      this.authorAssociation,
      @refParam this.user,
      this.url,
      this.htmlUrl,
      this.issueUrl,
      this.createdAt = const ModelTimestamp.now(),
      this.updatedAt = const ModelTimestamp.now(),
      this.fromServer = false})
      : super._();
  factory _GithubIssueCommentModel.fromJson(Map<String, dynamic> json) =>
      _$GithubIssueCommentModelFromJson(json);

  @override
  final int? id;
  @override
  final String? body;
  @override
  final String? authorAssociation;
  @override
  @refParam
  final GithubUserModelRef? user;
  @override
  final ModelUri? url;
  @override
  final ModelUri? htmlUrl;
  @override
  final ModelUri? issueUrl;
  @override
  @JsonKey()
  final ModelTimestamp createdAt;
  @override
  @JsonKey()
  final ModelTimestamp updatedAt;
  @override
  @JsonKey()
  final bool fromServer;

  /// Create a copy of GithubIssueCommentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GithubIssueCommentModelCopyWith<_GithubIssueCommentModel> get copyWith =>
      __$GithubIssueCommentModelCopyWithImpl<_GithubIssueCommentModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GithubIssueCommentModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GithubIssueCommentModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.authorAssociation, authorAssociation) ||
                other.authorAssociation == authorAssociation) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.htmlUrl, htmlUrl) || other.htmlUrl == htmlUrl) &&
            (identical(other.issueUrl, issueUrl) ||
                other.issueUrl == issueUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.fromServer, fromServer) ||
                other.fromServer == fromServer));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, body, authorAssociation,
      user, url, htmlUrl, issueUrl, createdAt, updatedAt, fromServer);

  @override
  String toString() {
    return 'GithubIssueCommentModel(id: $id, body: $body, authorAssociation: $authorAssociation, user: $user, url: $url, htmlUrl: $htmlUrl, issueUrl: $issueUrl, createdAt: $createdAt, updatedAt: $updatedAt, fromServer: $fromServer)';
  }
}

/// @nodoc
abstract mixin class _$GithubIssueCommentModelCopyWith<$Res>
    implements $GithubIssueCommentModelCopyWith<$Res> {
  factory _$GithubIssueCommentModelCopyWith(_GithubIssueCommentModel value,
          $Res Function(_GithubIssueCommentModel) _then) =
      __$GithubIssueCommentModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? id,
      String? body,
      String? authorAssociation,
      @refParam GithubUserModelRef? user,
      ModelUri? url,
      ModelUri? htmlUrl,
      ModelUri? issueUrl,
      ModelTimestamp createdAt,
      ModelTimestamp updatedAt,
      bool fromServer});
}

/// @nodoc
class __$GithubIssueCommentModelCopyWithImpl<$Res>
    implements _$GithubIssueCommentModelCopyWith<$Res> {
  __$GithubIssueCommentModelCopyWithImpl(this._self, this._then);

  final _GithubIssueCommentModel _self;
  final $Res Function(_GithubIssueCommentModel) _then;

  /// Create a copy of GithubIssueCommentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? body = freezed,
    Object? authorAssociation = freezed,
    Object? user = freezed,
    Object? url = freezed,
    Object? htmlUrl = freezed,
    Object? issueUrl = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? fromServer = null,
  }) {
    return _then(_GithubIssueCommentModel(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      body: freezed == body
          ? _self.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
      authorAssociation: freezed == authorAssociation
          ? _self.authorAssociation
          : authorAssociation // ignore: cast_nullable_to_non_nullable
              as String?,
      user: freezed == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as GithubUserModelRef?,
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      htmlUrl: freezed == htmlUrl
          ? _self.htmlUrl
          : htmlUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      issueUrl: freezed == issueUrl
          ? _self.issueUrl
          : issueUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp,
      fromServer: null == fromServer
          ? _self.fromServer
          : fromServer // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
