// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'github_commit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GithubCommitModel {
  String? get sha;
  String? get message;
  int get commentCount;
  int get additionsCount;
  int get deletionsCount;
  int get totalCount;
  ModelUri? get url;
  ModelUri? get htmlUrl;
  ModelUri? get commentsUrl;
  @refParam
  GithubUserModelRef? get author;
  @refParam
  GithubUserModelRef? get committer;
  @jsonParam
  List<GithubCommitModel> get parents;
  @jsonParam
  List<GithubContentModel> get contents;
  bool get fromServer;

  /// Create a copy of GithubCommitModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GithubCommitModelCopyWith<GithubCommitModel> get copyWith =>
      _$GithubCommitModelCopyWithImpl<GithubCommitModel>(
          this as GithubCommitModel, _$identity);

  /// Serializes this GithubCommitModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GithubCommitModel &&
            (identical(other.sha, sha) || other.sha == sha) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.commentCount, commentCount) ||
                other.commentCount == commentCount) &&
            (identical(other.additionsCount, additionsCount) ||
                other.additionsCount == additionsCount) &&
            (identical(other.deletionsCount, deletionsCount) ||
                other.deletionsCount == deletionsCount) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.htmlUrl, htmlUrl) || other.htmlUrl == htmlUrl) &&
            (identical(other.commentsUrl, commentsUrl) ||
                other.commentsUrl == commentsUrl) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.committer, committer) ||
                other.committer == committer) &&
            const DeepCollectionEquality().equals(other.parents, parents) &&
            const DeepCollectionEquality().equals(other.contents, contents) &&
            (identical(other.fromServer, fromServer) ||
                other.fromServer == fromServer));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      sha,
      message,
      commentCount,
      additionsCount,
      deletionsCount,
      totalCount,
      url,
      htmlUrl,
      commentsUrl,
      author,
      committer,
      const DeepCollectionEquality().hash(parents),
      const DeepCollectionEquality().hash(contents),
      fromServer);

  @override
  String toString() {
    return 'GithubCommitModel(sha: $sha, message: $message, commentCount: $commentCount, additionsCount: $additionsCount, deletionsCount: $deletionsCount, totalCount: $totalCount, url: $url, htmlUrl: $htmlUrl, commentsUrl: $commentsUrl, author: $author, committer: $committer, parents: $parents, contents: $contents, fromServer: $fromServer)';
  }
}

/// @nodoc
abstract mixin class $GithubCommitModelCopyWith<$Res> {
  factory $GithubCommitModelCopyWith(
          GithubCommitModel value, $Res Function(GithubCommitModel) _then) =
      _$GithubCommitModelCopyWithImpl;
  @useResult
  $Res call(
      {String? sha,
      String? message,
      int commentCount,
      int additionsCount,
      int deletionsCount,
      int totalCount,
      ModelUri? url,
      ModelUri? htmlUrl,
      ModelUri? commentsUrl,
      @refParam GithubUserModelRef? author,
      @refParam GithubUserModelRef? committer,
      @jsonParam List<GithubCommitModel> parents,
      @jsonParam List<GithubContentModel> contents,
      bool fromServer});
}

/// @nodoc
class _$GithubCommitModelCopyWithImpl<$Res>
    implements $GithubCommitModelCopyWith<$Res> {
  _$GithubCommitModelCopyWithImpl(this._self, this._then);

  final GithubCommitModel _self;
  final $Res Function(GithubCommitModel) _then;

  /// Create a copy of GithubCommitModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sha = freezed,
    Object? message = freezed,
    Object? commentCount = null,
    Object? additionsCount = null,
    Object? deletionsCount = null,
    Object? totalCount = null,
    Object? url = freezed,
    Object? htmlUrl = freezed,
    Object? commentsUrl = freezed,
    Object? author = freezed,
    Object? committer = freezed,
    Object? parents = null,
    Object? contents = null,
    Object? fromServer = null,
  }) {
    return _then(_self.copyWith(
      sha: freezed == sha
          ? _self.sha
          : sha // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      commentCount: null == commentCount
          ? _self.commentCount
          : commentCount // ignore: cast_nullable_to_non_nullable
              as int,
      additionsCount: null == additionsCount
          ? _self.additionsCount
          : additionsCount // ignore: cast_nullable_to_non_nullable
              as int,
      deletionsCount: null == deletionsCount
          ? _self.deletionsCount
          : deletionsCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalCount: null == totalCount
          ? _self.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      htmlUrl: freezed == htmlUrl
          ? _self.htmlUrl
          : htmlUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      commentsUrl: freezed == commentsUrl
          ? _self.commentsUrl
          : commentsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      author: freezed == author
          ? _self.author
          : author // ignore: cast_nullable_to_non_nullable
              as GithubUserModelRef?,
      committer: freezed == committer
          ? _self.committer
          : committer // ignore: cast_nullable_to_non_nullable
              as GithubUserModelRef?,
      parents: null == parents
          ? _self.parents
          : parents // ignore: cast_nullable_to_non_nullable
              as List<GithubCommitModel>,
      contents: null == contents
          ? _self.contents
          : contents // ignore: cast_nullable_to_non_nullable
              as List<GithubContentModel>,
      fromServer: null == fromServer
          ? _self.fromServer
          : fromServer // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [GithubCommitModel].
extension GithubCommitModelPatterns on GithubCommitModel {
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
    TResult Function(_GithubCommitModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GithubCommitModel() when $default != null:
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
    TResult Function(_GithubCommitModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubCommitModel():
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
    TResult? Function(_GithubCommitModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubCommitModel() when $default != null:
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
            String? sha,
            String? message,
            int commentCount,
            int additionsCount,
            int deletionsCount,
            int totalCount,
            ModelUri? url,
            ModelUri? htmlUrl,
            ModelUri? commentsUrl,
            @refParam GithubUserModelRef? author,
            @refParam GithubUserModelRef? committer,
            @jsonParam List<GithubCommitModel> parents,
            @jsonParam List<GithubContentModel> contents,
            bool fromServer)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GithubCommitModel() when $default != null:
        return $default(
            _that.sha,
            _that.message,
            _that.commentCount,
            _that.additionsCount,
            _that.deletionsCount,
            _that.totalCount,
            _that.url,
            _that.htmlUrl,
            _that.commentsUrl,
            _that.author,
            _that.committer,
            _that.parents,
            _that.contents,
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
            String? sha,
            String? message,
            int commentCount,
            int additionsCount,
            int deletionsCount,
            int totalCount,
            ModelUri? url,
            ModelUri? htmlUrl,
            ModelUri? commentsUrl,
            @refParam GithubUserModelRef? author,
            @refParam GithubUserModelRef? committer,
            @jsonParam List<GithubCommitModel> parents,
            @jsonParam List<GithubContentModel> contents,
            bool fromServer)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubCommitModel():
        return $default(
            _that.sha,
            _that.message,
            _that.commentCount,
            _that.additionsCount,
            _that.deletionsCount,
            _that.totalCount,
            _that.url,
            _that.htmlUrl,
            _that.commentsUrl,
            _that.author,
            _that.committer,
            _that.parents,
            _that.contents,
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
            String? sha,
            String? message,
            int commentCount,
            int additionsCount,
            int deletionsCount,
            int totalCount,
            ModelUri? url,
            ModelUri? htmlUrl,
            ModelUri? commentsUrl,
            @refParam GithubUserModelRef? author,
            @refParam GithubUserModelRef? committer,
            @jsonParam List<GithubCommitModel> parents,
            @jsonParam List<GithubContentModel> contents,
            bool fromServer)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubCommitModel() when $default != null:
        return $default(
            _that.sha,
            _that.message,
            _that.commentCount,
            _that.additionsCount,
            _that.deletionsCount,
            _that.totalCount,
            _that.url,
            _that.htmlUrl,
            _that.commentsUrl,
            _that.author,
            _that.committer,
            _that.parents,
            _that.contents,
            _that.fromServer);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _GithubCommitModel extends GithubCommitModel {
  const _GithubCommitModel(
      {this.sha,
      this.message,
      this.commentCount = 0,
      this.additionsCount = 0,
      this.deletionsCount = 0,
      this.totalCount = 0,
      this.url,
      this.htmlUrl,
      this.commentsUrl,
      @refParam this.author,
      @refParam this.committer,
      @jsonParam final List<GithubCommitModel> parents = const [],
      @jsonParam final List<GithubContentModel> contents = const [],
      this.fromServer = false})
      : _parents = parents,
        _contents = contents,
        super._();
  factory _GithubCommitModel.fromJson(Map<String, dynamic> json) =>
      _$GithubCommitModelFromJson(json);

  @override
  final String? sha;
  @override
  final String? message;
  @override
  @JsonKey()
  final int commentCount;
  @override
  @JsonKey()
  final int additionsCount;
  @override
  @JsonKey()
  final int deletionsCount;
  @override
  @JsonKey()
  final int totalCount;
  @override
  final ModelUri? url;
  @override
  final ModelUri? htmlUrl;
  @override
  final ModelUri? commentsUrl;
  @override
  @refParam
  final GithubUserModelRef? author;
  @override
  @refParam
  final GithubUserModelRef? committer;
  final List<GithubCommitModel> _parents;
  @override
  @JsonKey()
  @jsonParam
  List<GithubCommitModel> get parents {
    if (_parents is EqualUnmodifiableListView) return _parents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_parents);
  }

  final List<GithubContentModel> _contents;
  @override
  @JsonKey()
  @jsonParam
  List<GithubContentModel> get contents {
    if (_contents is EqualUnmodifiableListView) return _contents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_contents);
  }

  @override
  @JsonKey()
  final bool fromServer;

  /// Create a copy of GithubCommitModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GithubCommitModelCopyWith<_GithubCommitModel> get copyWith =>
      __$GithubCommitModelCopyWithImpl<_GithubCommitModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GithubCommitModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GithubCommitModel &&
            (identical(other.sha, sha) || other.sha == sha) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.commentCount, commentCount) ||
                other.commentCount == commentCount) &&
            (identical(other.additionsCount, additionsCount) ||
                other.additionsCount == additionsCount) &&
            (identical(other.deletionsCount, deletionsCount) ||
                other.deletionsCount == deletionsCount) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.htmlUrl, htmlUrl) || other.htmlUrl == htmlUrl) &&
            (identical(other.commentsUrl, commentsUrl) ||
                other.commentsUrl == commentsUrl) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.committer, committer) ||
                other.committer == committer) &&
            const DeepCollectionEquality().equals(other._parents, _parents) &&
            const DeepCollectionEquality().equals(other._contents, _contents) &&
            (identical(other.fromServer, fromServer) ||
                other.fromServer == fromServer));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      sha,
      message,
      commentCount,
      additionsCount,
      deletionsCount,
      totalCount,
      url,
      htmlUrl,
      commentsUrl,
      author,
      committer,
      const DeepCollectionEquality().hash(_parents),
      const DeepCollectionEquality().hash(_contents),
      fromServer);

  @override
  String toString() {
    return 'GithubCommitModel(sha: $sha, message: $message, commentCount: $commentCount, additionsCount: $additionsCount, deletionsCount: $deletionsCount, totalCount: $totalCount, url: $url, htmlUrl: $htmlUrl, commentsUrl: $commentsUrl, author: $author, committer: $committer, parents: $parents, contents: $contents, fromServer: $fromServer)';
  }
}

/// @nodoc
abstract mixin class _$GithubCommitModelCopyWith<$Res>
    implements $GithubCommitModelCopyWith<$Res> {
  factory _$GithubCommitModelCopyWith(
          _GithubCommitModel value, $Res Function(_GithubCommitModel) _then) =
      __$GithubCommitModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? sha,
      String? message,
      int commentCount,
      int additionsCount,
      int deletionsCount,
      int totalCount,
      ModelUri? url,
      ModelUri? htmlUrl,
      ModelUri? commentsUrl,
      @refParam GithubUserModelRef? author,
      @refParam GithubUserModelRef? committer,
      @jsonParam List<GithubCommitModel> parents,
      @jsonParam List<GithubContentModel> contents,
      bool fromServer});
}

/// @nodoc
class __$GithubCommitModelCopyWithImpl<$Res>
    implements _$GithubCommitModelCopyWith<$Res> {
  __$GithubCommitModelCopyWithImpl(this._self, this._then);

  final _GithubCommitModel _self;
  final $Res Function(_GithubCommitModel) _then;

  /// Create a copy of GithubCommitModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? sha = freezed,
    Object? message = freezed,
    Object? commentCount = null,
    Object? additionsCount = null,
    Object? deletionsCount = null,
    Object? totalCount = null,
    Object? url = freezed,
    Object? htmlUrl = freezed,
    Object? commentsUrl = freezed,
    Object? author = freezed,
    Object? committer = freezed,
    Object? parents = null,
    Object? contents = null,
    Object? fromServer = null,
  }) {
    return _then(_GithubCommitModel(
      sha: freezed == sha
          ? _self.sha
          : sha // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      commentCount: null == commentCount
          ? _self.commentCount
          : commentCount // ignore: cast_nullable_to_non_nullable
              as int,
      additionsCount: null == additionsCount
          ? _self.additionsCount
          : additionsCount // ignore: cast_nullable_to_non_nullable
              as int,
      deletionsCount: null == deletionsCount
          ? _self.deletionsCount
          : deletionsCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalCount: null == totalCount
          ? _self.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      htmlUrl: freezed == htmlUrl
          ? _self.htmlUrl
          : htmlUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      commentsUrl: freezed == commentsUrl
          ? _self.commentsUrl
          : commentsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      author: freezed == author
          ? _self.author
          : author // ignore: cast_nullable_to_non_nullable
              as GithubUserModelRef?,
      committer: freezed == committer
          ? _self.committer
          : committer // ignore: cast_nullable_to_non_nullable
              as GithubUserModelRef?,
      parents: null == parents
          ? _self._parents
          : parents // ignore: cast_nullable_to_non_nullable
              as List<GithubCommitModel>,
      contents: null == contents
          ? _self._contents
          : contents // ignore: cast_nullable_to_non_nullable
              as List<GithubContentModel>,
      fromServer: null == fromServer
          ? _self.fromServer
          : fromServer // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
