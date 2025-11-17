// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'github_compare.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GithubCompareModel {
  /// Comparison status (behind, ahead, identical, diverged)
  String? get status;

  /// How many commits ahead
  int get aheadBy;

  /// How many commits behind
  int get behindBy;

  /// Total commits in comparison
  int get totalCommits;

  /// Merge base commit (divergence point)
  @jsonParam
  GithubCommitModel? get mergeBaseCommit;

  /// Base commit
  @jsonParam
  GithubCommitModel? get baseCommit;

  /// Commits in the comparison
  @jsonParam
  List<GithubCommitModel> get commits;

  /// URL for diff
  ModelUri? get diffUrl;

  /// URL for patch
  ModelUri? get patchUrl;

  /// HTML URL
  ModelUri? get htmlUrl;

  /// Permalink URL
  ModelUri? get permalinkUrl;
  bool get fromServer;

  /// Create a copy of GithubCompareModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GithubCompareModelCopyWith<GithubCompareModel> get copyWith =>
      _$GithubCompareModelCopyWithImpl<GithubCompareModel>(
          this as GithubCompareModel, _$identity);

  /// Serializes this GithubCompareModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GithubCompareModel &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.aheadBy, aheadBy) || other.aheadBy == aheadBy) &&
            (identical(other.behindBy, behindBy) ||
                other.behindBy == behindBy) &&
            (identical(other.totalCommits, totalCommits) ||
                other.totalCommits == totalCommits) &&
            (identical(other.mergeBaseCommit, mergeBaseCommit) ||
                other.mergeBaseCommit == mergeBaseCommit) &&
            (identical(other.baseCommit, baseCommit) ||
                other.baseCommit == baseCommit) &&
            const DeepCollectionEquality().equals(other.commits, commits) &&
            (identical(other.diffUrl, diffUrl) || other.diffUrl == diffUrl) &&
            (identical(other.patchUrl, patchUrl) ||
                other.patchUrl == patchUrl) &&
            (identical(other.htmlUrl, htmlUrl) || other.htmlUrl == htmlUrl) &&
            (identical(other.permalinkUrl, permalinkUrl) ||
                other.permalinkUrl == permalinkUrl) &&
            (identical(other.fromServer, fromServer) ||
                other.fromServer == fromServer));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      status,
      aheadBy,
      behindBy,
      totalCommits,
      mergeBaseCommit,
      baseCommit,
      const DeepCollectionEquality().hash(commits),
      diffUrl,
      patchUrl,
      htmlUrl,
      permalinkUrl,
      fromServer);

  @override
  String toString() {
    return 'GithubCompareModel(status: $status, aheadBy: $aheadBy, behindBy: $behindBy, totalCommits: $totalCommits, mergeBaseCommit: $mergeBaseCommit, baseCommit: $baseCommit, commits: $commits, diffUrl: $diffUrl, patchUrl: $patchUrl, htmlUrl: $htmlUrl, permalinkUrl: $permalinkUrl, fromServer: $fromServer)';
  }
}

/// @nodoc
abstract mixin class $GithubCompareModelCopyWith<$Res> {
  factory $GithubCompareModelCopyWith(
          GithubCompareModel value, $Res Function(GithubCompareModel) _then) =
      _$GithubCompareModelCopyWithImpl;
  @useResult
  $Res call(
      {String? status,
      int aheadBy,
      int behindBy,
      int totalCommits,
      @jsonParam GithubCommitModel? mergeBaseCommit,
      @jsonParam GithubCommitModel? baseCommit,
      @jsonParam List<GithubCommitModel> commits,
      ModelUri? diffUrl,
      ModelUri? patchUrl,
      ModelUri? htmlUrl,
      ModelUri? permalinkUrl,
      bool fromServer});

  $GithubCommitModelCopyWith<$Res>? get mergeBaseCommit;
  $GithubCommitModelCopyWith<$Res>? get baseCommit;
}

/// @nodoc
class _$GithubCompareModelCopyWithImpl<$Res>
    implements $GithubCompareModelCopyWith<$Res> {
  _$GithubCompareModelCopyWithImpl(this._self, this._then);

  final GithubCompareModel _self;
  final $Res Function(GithubCompareModel) _then;

  /// Create a copy of GithubCompareModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? aheadBy = null,
    Object? behindBy = null,
    Object? totalCommits = null,
    Object? mergeBaseCommit = freezed,
    Object? baseCommit = freezed,
    Object? commits = null,
    Object? diffUrl = freezed,
    Object? patchUrl = freezed,
    Object? htmlUrl = freezed,
    Object? permalinkUrl = freezed,
    Object? fromServer = null,
  }) {
    return _then(_self.copyWith(
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      aheadBy: null == aheadBy
          ? _self.aheadBy
          : aheadBy // ignore: cast_nullable_to_non_nullable
              as int,
      behindBy: null == behindBy
          ? _self.behindBy
          : behindBy // ignore: cast_nullable_to_non_nullable
              as int,
      totalCommits: null == totalCommits
          ? _self.totalCommits
          : totalCommits // ignore: cast_nullable_to_non_nullable
              as int,
      mergeBaseCommit: freezed == mergeBaseCommit
          ? _self.mergeBaseCommit
          : mergeBaseCommit // ignore: cast_nullable_to_non_nullable
              as GithubCommitModel?,
      baseCommit: freezed == baseCommit
          ? _self.baseCommit
          : baseCommit // ignore: cast_nullable_to_non_nullable
              as GithubCommitModel?,
      commits: null == commits
          ? _self.commits
          : commits // ignore: cast_nullable_to_non_nullable
              as List<GithubCommitModel>,
      diffUrl: freezed == diffUrl
          ? _self.diffUrl
          : diffUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      patchUrl: freezed == patchUrl
          ? _self.patchUrl
          : patchUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      htmlUrl: freezed == htmlUrl
          ? _self.htmlUrl
          : htmlUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      permalinkUrl: freezed == permalinkUrl
          ? _self.permalinkUrl
          : permalinkUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      fromServer: null == fromServer
          ? _self.fromServer
          : fromServer // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  /// Create a copy of GithubCompareModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GithubCommitModelCopyWith<$Res>? get mergeBaseCommit {
    if (_self.mergeBaseCommit == null) {
      return null;
    }

    return $GithubCommitModelCopyWith<$Res>(_self.mergeBaseCommit!, (value) {
      return _then(_self.copyWith(mergeBaseCommit: value));
    });
  }

  /// Create a copy of GithubCompareModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GithubCommitModelCopyWith<$Res>? get baseCommit {
    if (_self.baseCommit == null) {
      return null;
    }

    return $GithubCommitModelCopyWith<$Res>(_self.baseCommit!, (value) {
      return _then(_self.copyWith(baseCommit: value));
    });
  }
}

/// Adds pattern-matching-related methods to [GithubCompareModel].
extension GithubCompareModelPatterns on GithubCompareModel {
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
    TResult Function(_GithubCompareModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GithubCompareModel() when $default != null:
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
    TResult Function(_GithubCompareModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubCompareModel():
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
    TResult? Function(_GithubCompareModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubCompareModel() when $default != null:
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
            String? status,
            int aheadBy,
            int behindBy,
            int totalCommits,
            @jsonParam GithubCommitModel? mergeBaseCommit,
            @jsonParam GithubCommitModel? baseCommit,
            @jsonParam List<GithubCommitModel> commits,
            ModelUri? diffUrl,
            ModelUri? patchUrl,
            ModelUri? htmlUrl,
            ModelUri? permalinkUrl,
            bool fromServer)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GithubCompareModel() when $default != null:
        return $default(
            _that.status,
            _that.aheadBy,
            _that.behindBy,
            _that.totalCommits,
            _that.mergeBaseCommit,
            _that.baseCommit,
            _that.commits,
            _that.diffUrl,
            _that.patchUrl,
            _that.htmlUrl,
            _that.permalinkUrl,
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
            String? status,
            int aheadBy,
            int behindBy,
            int totalCommits,
            @jsonParam GithubCommitModel? mergeBaseCommit,
            @jsonParam GithubCommitModel? baseCommit,
            @jsonParam List<GithubCommitModel> commits,
            ModelUri? diffUrl,
            ModelUri? patchUrl,
            ModelUri? htmlUrl,
            ModelUri? permalinkUrl,
            bool fromServer)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubCompareModel():
        return $default(
            _that.status,
            _that.aheadBy,
            _that.behindBy,
            _that.totalCommits,
            _that.mergeBaseCommit,
            _that.baseCommit,
            _that.commits,
            _that.diffUrl,
            _that.patchUrl,
            _that.htmlUrl,
            _that.permalinkUrl,
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
            String? status,
            int aheadBy,
            int behindBy,
            int totalCommits,
            @jsonParam GithubCommitModel? mergeBaseCommit,
            @jsonParam GithubCommitModel? baseCommit,
            @jsonParam List<GithubCommitModel> commits,
            ModelUri? diffUrl,
            ModelUri? patchUrl,
            ModelUri? htmlUrl,
            ModelUri? permalinkUrl,
            bool fromServer)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubCompareModel() when $default != null:
        return $default(
            _that.status,
            _that.aheadBy,
            _that.behindBy,
            _that.totalCommits,
            _that.mergeBaseCommit,
            _that.baseCommit,
            _that.commits,
            _that.diffUrl,
            _that.patchUrl,
            _that.htmlUrl,
            _that.permalinkUrl,
            _that.fromServer);
      case _:
        return null;
    }
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _GithubCompareModel extends GithubCompareModel {
  const _GithubCompareModel(
      {this.status,
      this.aheadBy = 0,
      this.behindBy = 0,
      this.totalCommits = 0,
      @jsonParam this.mergeBaseCommit,
      @jsonParam this.baseCommit,
      @jsonParam final List<GithubCommitModel> commits = const [],
      this.diffUrl,
      this.patchUrl,
      this.htmlUrl,
      this.permalinkUrl,
      this.fromServer = false})
      : _commits = commits,
        super._();
  factory _GithubCompareModel.fromJson(Map<String, dynamic> json) =>
      _$GithubCompareModelFromJson(json);

  /// Comparison status (behind, ahead, identical, diverged)
  @override
  final String? status;

  /// How many commits ahead
  @override
  @JsonKey()
  final int aheadBy;

  /// How many commits behind
  @override
  @JsonKey()
  final int behindBy;

  /// Total commits in comparison
  @override
  @JsonKey()
  final int totalCommits;

  /// Merge base commit (divergence point)
  @override
  @jsonParam
  final GithubCommitModel? mergeBaseCommit;

  /// Base commit
  @override
  @jsonParam
  final GithubCommitModel? baseCommit;

  /// Commits in the comparison
  final List<GithubCommitModel> _commits;

  /// Commits in the comparison
  @override
  @JsonKey()
  @jsonParam
  List<GithubCommitModel> get commits {
    if (_commits is EqualUnmodifiableListView) return _commits;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_commits);
  }

  /// URL for diff
  @override
  final ModelUri? diffUrl;

  /// URL for patch
  @override
  final ModelUri? patchUrl;

  /// HTML URL
  @override
  final ModelUri? htmlUrl;

  /// Permalink URL
  @override
  final ModelUri? permalinkUrl;
  @override
  @JsonKey()
  final bool fromServer;

  /// Create a copy of GithubCompareModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GithubCompareModelCopyWith<_GithubCompareModel> get copyWith =>
      __$GithubCompareModelCopyWithImpl<_GithubCompareModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GithubCompareModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GithubCompareModel &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.aheadBy, aheadBy) || other.aheadBy == aheadBy) &&
            (identical(other.behindBy, behindBy) ||
                other.behindBy == behindBy) &&
            (identical(other.totalCommits, totalCommits) ||
                other.totalCommits == totalCommits) &&
            (identical(other.mergeBaseCommit, mergeBaseCommit) ||
                other.mergeBaseCommit == mergeBaseCommit) &&
            (identical(other.baseCommit, baseCommit) ||
                other.baseCommit == baseCommit) &&
            const DeepCollectionEquality().equals(other._commits, _commits) &&
            (identical(other.diffUrl, diffUrl) || other.diffUrl == diffUrl) &&
            (identical(other.patchUrl, patchUrl) ||
                other.patchUrl == patchUrl) &&
            (identical(other.htmlUrl, htmlUrl) || other.htmlUrl == htmlUrl) &&
            (identical(other.permalinkUrl, permalinkUrl) ||
                other.permalinkUrl == permalinkUrl) &&
            (identical(other.fromServer, fromServer) ||
                other.fromServer == fromServer));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      status,
      aheadBy,
      behindBy,
      totalCommits,
      mergeBaseCommit,
      baseCommit,
      const DeepCollectionEquality().hash(_commits),
      diffUrl,
      patchUrl,
      htmlUrl,
      permalinkUrl,
      fromServer);

  @override
  String toString() {
    return 'GithubCompareModel(status: $status, aheadBy: $aheadBy, behindBy: $behindBy, totalCommits: $totalCommits, mergeBaseCommit: $mergeBaseCommit, baseCommit: $baseCommit, commits: $commits, diffUrl: $diffUrl, patchUrl: $patchUrl, htmlUrl: $htmlUrl, permalinkUrl: $permalinkUrl, fromServer: $fromServer)';
  }
}

/// @nodoc
abstract mixin class _$GithubCompareModelCopyWith<$Res>
    implements $GithubCompareModelCopyWith<$Res> {
  factory _$GithubCompareModelCopyWith(
          _GithubCompareModel value, $Res Function(_GithubCompareModel) _then) =
      __$GithubCompareModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? status,
      int aheadBy,
      int behindBy,
      int totalCommits,
      @jsonParam GithubCommitModel? mergeBaseCommit,
      @jsonParam GithubCommitModel? baseCommit,
      @jsonParam List<GithubCommitModel> commits,
      ModelUri? diffUrl,
      ModelUri? patchUrl,
      ModelUri? htmlUrl,
      ModelUri? permalinkUrl,
      bool fromServer});

  @override
  $GithubCommitModelCopyWith<$Res>? get mergeBaseCommit;
  @override
  $GithubCommitModelCopyWith<$Res>? get baseCommit;
}

/// @nodoc
class __$GithubCompareModelCopyWithImpl<$Res>
    implements _$GithubCompareModelCopyWith<$Res> {
  __$GithubCompareModelCopyWithImpl(this._self, this._then);

  final _GithubCompareModel _self;
  final $Res Function(_GithubCompareModel) _then;

  /// Create a copy of GithubCompareModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? status = freezed,
    Object? aheadBy = null,
    Object? behindBy = null,
    Object? totalCommits = null,
    Object? mergeBaseCommit = freezed,
    Object? baseCommit = freezed,
    Object? commits = null,
    Object? diffUrl = freezed,
    Object? patchUrl = freezed,
    Object? htmlUrl = freezed,
    Object? permalinkUrl = freezed,
    Object? fromServer = null,
  }) {
    return _then(_GithubCompareModel(
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      aheadBy: null == aheadBy
          ? _self.aheadBy
          : aheadBy // ignore: cast_nullable_to_non_nullable
              as int,
      behindBy: null == behindBy
          ? _self.behindBy
          : behindBy // ignore: cast_nullable_to_non_nullable
              as int,
      totalCommits: null == totalCommits
          ? _self.totalCommits
          : totalCommits // ignore: cast_nullable_to_non_nullable
              as int,
      mergeBaseCommit: freezed == mergeBaseCommit
          ? _self.mergeBaseCommit
          : mergeBaseCommit // ignore: cast_nullable_to_non_nullable
              as GithubCommitModel?,
      baseCommit: freezed == baseCommit
          ? _self.baseCommit
          : baseCommit // ignore: cast_nullable_to_non_nullable
              as GithubCommitModel?,
      commits: null == commits
          ? _self._commits
          : commits // ignore: cast_nullable_to_non_nullable
              as List<GithubCommitModel>,
      diffUrl: freezed == diffUrl
          ? _self.diffUrl
          : diffUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      patchUrl: freezed == patchUrl
          ? _self.patchUrl
          : patchUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      htmlUrl: freezed == htmlUrl
          ? _self.htmlUrl
          : htmlUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      permalinkUrl: freezed == permalinkUrl
          ? _self.permalinkUrl
          : permalinkUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      fromServer: null == fromServer
          ? _self.fromServer
          : fromServer // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  /// Create a copy of GithubCompareModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GithubCommitModelCopyWith<$Res>? get mergeBaseCommit {
    if (_self.mergeBaseCommit == null) {
      return null;
    }

    return $GithubCommitModelCopyWith<$Res>(_self.mergeBaseCommit!, (value) {
      return _then(_self.copyWith(mergeBaseCommit: value));
    });
  }

  /// Create a copy of GithubCompareModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GithubCommitModelCopyWith<$Res>? get baseCommit {
    if (_self.baseCommit == null) {
      return null;
    }

    return $GithubCommitModelCopyWith<$Res>(_self.baseCommit!, (value) {
      return _then(_self.copyWith(baseCommit: value));
    });
  }
}

// dart format on
