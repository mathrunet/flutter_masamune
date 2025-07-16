// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'github_content.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GithubContentModel {
  String? get name;
  String? get path;
  String? get content;
  String? get sha;
  String? get type;
  String? get encoding;
  String? get patch;
  String? get status;
  @refParam
  GithubUserModelRef get committer;
  int get size;
  int get additionsCount;
  int get deletionsCount;
  int get changesCount;
  ModelUri? get rawUrl;
  ModelUri? get blobUrl;
  ModelUri? get htmlUrl;
  ModelUri? get gitUrl;
  ModelUri? get downloadUrl;
  @jsonParam
  List<GithubContentModel>? get children;
  bool get fromServer;

  /// Create a copy of GithubContentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GithubContentModelCopyWith<GithubContentModel> get copyWith =>
      _$GithubContentModelCopyWithImpl<GithubContentModel>(
          this as GithubContentModel, _$identity);

  /// Serializes this GithubContentModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GithubContentModel &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.sha, sha) || other.sha == sha) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.encoding, encoding) ||
                other.encoding == encoding) &&
            (identical(other.patch, patch) || other.patch == patch) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.committer, committer) ||
                other.committer == committer) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.additionsCount, additionsCount) ||
                other.additionsCount == additionsCount) &&
            (identical(other.deletionsCount, deletionsCount) ||
                other.deletionsCount == deletionsCount) &&
            (identical(other.changesCount, changesCount) ||
                other.changesCount == changesCount) &&
            (identical(other.rawUrl, rawUrl) || other.rawUrl == rawUrl) &&
            (identical(other.blobUrl, blobUrl) || other.blobUrl == blobUrl) &&
            (identical(other.htmlUrl, htmlUrl) || other.htmlUrl == htmlUrl) &&
            (identical(other.gitUrl, gitUrl) || other.gitUrl == gitUrl) &&
            (identical(other.downloadUrl, downloadUrl) ||
                other.downloadUrl == downloadUrl) &&
            const DeepCollectionEquality().equals(other.children, children) &&
            (identical(other.fromServer, fromServer) ||
                other.fromServer == fromServer));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        name,
        path,
        content,
        sha,
        type,
        encoding,
        patch,
        status,
        committer,
        size,
        additionsCount,
        deletionsCount,
        changesCount,
        rawUrl,
        blobUrl,
        htmlUrl,
        gitUrl,
        downloadUrl,
        const DeepCollectionEquality().hash(children),
        fromServer
      ]);

  @override
  String toString() {
    return 'GithubContentModel(name: $name, path: $path, content: $content, sha: $sha, type: $type, encoding: $encoding, patch: $patch, status: $status, committer: $committer, size: $size, additionsCount: $additionsCount, deletionsCount: $deletionsCount, changesCount: $changesCount, rawUrl: $rawUrl, blobUrl: $blobUrl, htmlUrl: $htmlUrl, gitUrl: $gitUrl, downloadUrl: $downloadUrl, children: $children, fromServer: $fromServer)';
  }
}

/// @nodoc
abstract mixin class $GithubContentModelCopyWith<$Res> {
  factory $GithubContentModelCopyWith(
          GithubContentModel value, $Res Function(GithubContentModel) _then) =
      _$GithubContentModelCopyWithImpl;
  @useResult
  $Res call(
      {String? name,
      String? path,
      String? content,
      String? sha,
      String? type,
      String? encoding,
      String? patch,
      String? status,
      @refParam GithubUserModelRef committer,
      int size,
      int additionsCount,
      int deletionsCount,
      int changesCount,
      ModelUri? rawUrl,
      ModelUri? blobUrl,
      ModelUri? htmlUrl,
      ModelUri? gitUrl,
      ModelUri? downloadUrl,
      @jsonParam List<GithubContentModel>? children,
      bool fromServer});
}

/// @nodoc
class _$GithubContentModelCopyWithImpl<$Res>
    implements $GithubContentModelCopyWith<$Res> {
  _$GithubContentModelCopyWithImpl(this._self, this._then);

  final GithubContentModel _self;
  final $Res Function(GithubContentModel) _then;

  /// Create a copy of GithubContentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? path = freezed,
    Object? content = freezed,
    Object? sha = freezed,
    Object? type = freezed,
    Object? encoding = freezed,
    Object? patch = freezed,
    Object? status = freezed,
    Object? committer = freezed,
    Object? size = null,
    Object? additionsCount = null,
    Object? deletionsCount = null,
    Object? changesCount = null,
    Object? rawUrl = freezed,
    Object? blobUrl = freezed,
    Object? htmlUrl = freezed,
    Object? gitUrl = freezed,
    Object? downloadUrl = freezed,
    Object? children = freezed,
    Object? fromServer = null,
  }) {
    return _then(_self.copyWith(
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      path: freezed == path
          ? _self.path
          : path // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      sha: freezed == sha
          ? _self.sha
          : sha // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      encoding: freezed == encoding
          ? _self.encoding
          : encoding // ignore: cast_nullable_to_non_nullable
              as String?,
      patch: freezed == patch
          ? _self.patch
          : patch // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      committer: freezed == committer
          ? _self.committer
          : committer // ignore: cast_nullable_to_non_nullable
              as GithubUserModelRef,
      size: null == size
          ? _self.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      additionsCount: null == additionsCount
          ? _self.additionsCount
          : additionsCount // ignore: cast_nullable_to_non_nullable
              as int,
      deletionsCount: null == deletionsCount
          ? _self.deletionsCount
          : deletionsCount // ignore: cast_nullable_to_non_nullable
              as int,
      changesCount: null == changesCount
          ? _self.changesCount
          : changesCount // ignore: cast_nullable_to_non_nullable
              as int,
      rawUrl: freezed == rawUrl
          ? _self.rawUrl
          : rawUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      blobUrl: freezed == blobUrl
          ? _self.blobUrl
          : blobUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      htmlUrl: freezed == htmlUrl
          ? _self.htmlUrl
          : htmlUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      gitUrl: freezed == gitUrl
          ? _self.gitUrl
          : gitUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      downloadUrl: freezed == downloadUrl
          ? _self.downloadUrl
          : downloadUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      children: freezed == children
          ? _self.children
          : children // ignore: cast_nullable_to_non_nullable
              as List<GithubContentModel>?,
      fromServer: null == fromServer
          ? _self.fromServer
          : fromServer // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [GithubContentModel].
extension GithubContentModelPatterns on GithubContentModel {
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
    TResult Function(_GithubContentModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GithubContentModel() when $default != null:
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
    TResult Function(_GithubContentModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubContentModel():
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
    TResult? Function(_GithubContentModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubContentModel() when $default != null:
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
            String? name,
            String? path,
            String? content,
            String? sha,
            String? type,
            String? encoding,
            String? patch,
            String? status,
            @refParam GithubUserModelRef committer,
            int size,
            int additionsCount,
            int deletionsCount,
            int changesCount,
            ModelUri? rawUrl,
            ModelUri? blobUrl,
            ModelUri? htmlUrl,
            ModelUri? gitUrl,
            ModelUri? downloadUrl,
            @jsonParam List<GithubContentModel>? children,
            bool fromServer)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GithubContentModel() when $default != null:
        return $default(
            _that.name,
            _that.path,
            _that.content,
            _that.sha,
            _that.type,
            _that.encoding,
            _that.patch,
            _that.status,
            _that.committer,
            _that.size,
            _that.additionsCount,
            _that.deletionsCount,
            _that.changesCount,
            _that.rawUrl,
            _that.blobUrl,
            _that.htmlUrl,
            _that.gitUrl,
            _that.downloadUrl,
            _that.children,
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
            String? name,
            String? path,
            String? content,
            String? sha,
            String? type,
            String? encoding,
            String? patch,
            String? status,
            @refParam GithubUserModelRef committer,
            int size,
            int additionsCount,
            int deletionsCount,
            int changesCount,
            ModelUri? rawUrl,
            ModelUri? blobUrl,
            ModelUri? htmlUrl,
            ModelUri? gitUrl,
            ModelUri? downloadUrl,
            @jsonParam List<GithubContentModel>? children,
            bool fromServer)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubContentModel():
        return $default(
            _that.name,
            _that.path,
            _that.content,
            _that.sha,
            _that.type,
            _that.encoding,
            _that.patch,
            _that.status,
            _that.committer,
            _that.size,
            _that.additionsCount,
            _that.deletionsCount,
            _that.changesCount,
            _that.rawUrl,
            _that.blobUrl,
            _that.htmlUrl,
            _that.gitUrl,
            _that.downloadUrl,
            _that.children,
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
            String? name,
            String? path,
            String? content,
            String? sha,
            String? type,
            String? encoding,
            String? patch,
            String? status,
            @refParam GithubUserModelRef committer,
            int size,
            int additionsCount,
            int deletionsCount,
            int changesCount,
            ModelUri? rawUrl,
            ModelUri? blobUrl,
            ModelUri? htmlUrl,
            ModelUri? gitUrl,
            ModelUri? downloadUrl,
            @jsonParam List<GithubContentModel>? children,
            bool fromServer)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubContentModel() when $default != null:
        return $default(
            _that.name,
            _that.path,
            _that.content,
            _that.sha,
            _that.type,
            _that.encoding,
            _that.patch,
            _that.status,
            _that.committer,
            _that.size,
            _that.additionsCount,
            _that.deletionsCount,
            _that.changesCount,
            _that.rawUrl,
            _that.blobUrl,
            _that.htmlUrl,
            _that.gitUrl,
            _that.downloadUrl,
            _that.children,
            _that.fromServer);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _GithubContentModel extends GithubContentModel {
  const _GithubContentModel(
      {this.name,
      this.path,
      this.content,
      this.sha,
      this.type,
      this.encoding,
      this.patch,
      this.status,
      @refParam this.committer,
      this.size = 0,
      this.additionsCount = 0,
      this.deletionsCount = 0,
      this.changesCount = 0,
      this.rawUrl,
      this.blobUrl,
      this.htmlUrl,
      this.gitUrl,
      this.downloadUrl,
      @jsonParam final List<GithubContentModel>? children,
      this.fromServer = false})
      : _children = children,
        super._();
  factory _GithubContentModel.fromJson(Map<String, dynamic> json) =>
      _$GithubContentModelFromJson(json);

  @override
  final String? name;
  @override
  final String? path;
  @override
  final String? content;
  @override
  final String? sha;
  @override
  final String? type;
  @override
  final String? encoding;
  @override
  final String? patch;
  @override
  final String? status;
  @override
  @refParam
  final GithubUserModelRef committer;
  @override
  @JsonKey()
  final int size;
  @override
  @JsonKey()
  final int additionsCount;
  @override
  @JsonKey()
  final int deletionsCount;
  @override
  @JsonKey()
  final int changesCount;
  @override
  final ModelUri? rawUrl;
  @override
  final ModelUri? blobUrl;
  @override
  final ModelUri? htmlUrl;
  @override
  final ModelUri? gitUrl;
  @override
  final ModelUri? downloadUrl;
  final List<GithubContentModel>? _children;
  @override
  @jsonParam
  List<GithubContentModel>? get children {
    final value = _children;
    if (value == null) return null;
    if (_children is EqualUnmodifiableListView) return _children;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  final bool fromServer;

  /// Create a copy of GithubContentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GithubContentModelCopyWith<_GithubContentModel> get copyWith =>
      __$GithubContentModelCopyWithImpl<_GithubContentModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GithubContentModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GithubContentModel &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.sha, sha) || other.sha == sha) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.encoding, encoding) ||
                other.encoding == encoding) &&
            (identical(other.patch, patch) || other.patch == patch) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.committer, committer) ||
                other.committer == committer) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.additionsCount, additionsCount) ||
                other.additionsCount == additionsCount) &&
            (identical(other.deletionsCount, deletionsCount) ||
                other.deletionsCount == deletionsCount) &&
            (identical(other.changesCount, changesCount) ||
                other.changesCount == changesCount) &&
            (identical(other.rawUrl, rawUrl) || other.rawUrl == rawUrl) &&
            (identical(other.blobUrl, blobUrl) || other.blobUrl == blobUrl) &&
            (identical(other.htmlUrl, htmlUrl) || other.htmlUrl == htmlUrl) &&
            (identical(other.gitUrl, gitUrl) || other.gitUrl == gitUrl) &&
            (identical(other.downloadUrl, downloadUrl) ||
                other.downloadUrl == downloadUrl) &&
            const DeepCollectionEquality().equals(other._children, _children) &&
            (identical(other.fromServer, fromServer) ||
                other.fromServer == fromServer));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        name,
        path,
        content,
        sha,
        type,
        encoding,
        patch,
        status,
        committer,
        size,
        additionsCount,
        deletionsCount,
        changesCount,
        rawUrl,
        blobUrl,
        htmlUrl,
        gitUrl,
        downloadUrl,
        const DeepCollectionEquality().hash(_children),
        fromServer
      ]);

  @override
  String toString() {
    return 'GithubContentModel(name: $name, path: $path, content: $content, sha: $sha, type: $type, encoding: $encoding, patch: $patch, status: $status, committer: $committer, size: $size, additionsCount: $additionsCount, deletionsCount: $deletionsCount, changesCount: $changesCount, rawUrl: $rawUrl, blobUrl: $blobUrl, htmlUrl: $htmlUrl, gitUrl: $gitUrl, downloadUrl: $downloadUrl, children: $children, fromServer: $fromServer)';
  }
}

/// @nodoc
abstract mixin class _$GithubContentModelCopyWith<$Res>
    implements $GithubContentModelCopyWith<$Res> {
  factory _$GithubContentModelCopyWith(
          _GithubContentModel value, $Res Function(_GithubContentModel) _then) =
      __$GithubContentModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? name,
      String? path,
      String? content,
      String? sha,
      String? type,
      String? encoding,
      String? patch,
      String? status,
      @refParam GithubUserModelRef committer,
      int size,
      int additionsCount,
      int deletionsCount,
      int changesCount,
      ModelUri? rawUrl,
      ModelUri? blobUrl,
      ModelUri? htmlUrl,
      ModelUri? gitUrl,
      ModelUri? downloadUrl,
      @jsonParam List<GithubContentModel>? children,
      bool fromServer});
}

/// @nodoc
class __$GithubContentModelCopyWithImpl<$Res>
    implements _$GithubContentModelCopyWith<$Res> {
  __$GithubContentModelCopyWithImpl(this._self, this._then);

  final _GithubContentModel _self;
  final $Res Function(_GithubContentModel) _then;

  /// Create a copy of GithubContentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = freezed,
    Object? path = freezed,
    Object? content = freezed,
    Object? sha = freezed,
    Object? type = freezed,
    Object? encoding = freezed,
    Object? patch = freezed,
    Object? status = freezed,
    Object? committer = freezed,
    Object? size = null,
    Object? additionsCount = null,
    Object? deletionsCount = null,
    Object? changesCount = null,
    Object? rawUrl = freezed,
    Object? blobUrl = freezed,
    Object? htmlUrl = freezed,
    Object? gitUrl = freezed,
    Object? downloadUrl = freezed,
    Object? children = freezed,
    Object? fromServer = null,
  }) {
    return _then(_GithubContentModel(
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      path: freezed == path
          ? _self.path
          : path // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      sha: freezed == sha
          ? _self.sha
          : sha // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      encoding: freezed == encoding
          ? _self.encoding
          : encoding // ignore: cast_nullable_to_non_nullable
              as String?,
      patch: freezed == patch
          ? _self.patch
          : patch // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      committer: freezed == committer
          ? _self.committer
          : committer // ignore: cast_nullable_to_non_nullable
              as GithubUserModelRef,
      size: null == size
          ? _self.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      additionsCount: null == additionsCount
          ? _self.additionsCount
          : additionsCount // ignore: cast_nullable_to_non_nullable
              as int,
      deletionsCount: null == deletionsCount
          ? _self.deletionsCount
          : deletionsCount // ignore: cast_nullable_to_non_nullable
              as int,
      changesCount: null == changesCount
          ? _self.changesCount
          : changesCount // ignore: cast_nullable_to_non_nullable
              as int,
      rawUrl: freezed == rawUrl
          ? _self.rawUrl
          : rawUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      blobUrl: freezed == blobUrl
          ? _self.blobUrl
          : blobUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      htmlUrl: freezed == htmlUrl
          ? _self.htmlUrl
          : htmlUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      gitUrl: freezed == gitUrl
          ? _self.gitUrl
          : gitUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      downloadUrl: freezed == downloadUrl
          ? _self.downloadUrl
          : downloadUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      children: freezed == children
          ? _self._children
          : children // ignore: cast_nullable_to_non_nullable
              as List<GithubContentModel>?,
      fromServer: null == fromServer
          ? _self.fromServer
          : fromServer // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
