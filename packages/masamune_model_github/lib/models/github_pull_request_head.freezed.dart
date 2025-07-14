// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'github_pull_request_head.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GithubPullRequestHeadValue {
  String? get label;
  String? get ref;
  String? get sha;
  @refParam
  GithubUserModelRef? get user;
  @refParam
  GithubRepositoryModelRef? get repo;

  /// Create a copy of GithubPullRequestHeadValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GithubPullRequestHeadValueCopyWith<GithubPullRequestHeadValue>
      get copyWith =>
          _$GithubPullRequestHeadValueCopyWithImpl<GithubPullRequestHeadValue>(
              this as GithubPullRequestHeadValue, _$identity);

  /// Serializes this GithubPullRequestHeadValue to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GithubPullRequestHeadValue &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.ref, ref) || other.ref == ref) &&
            (identical(other.sha, sha) || other.sha == sha) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.repo, repo) || other.repo == repo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, label, ref, sha, user, repo);

  @override
  String toString() {
    return 'GithubPullRequestHeadValue(label: $label, ref: $ref, sha: $sha, user: $user, repo: $repo)';
  }
}

/// @nodoc
abstract mixin class $GithubPullRequestHeadValueCopyWith<$Res> {
  factory $GithubPullRequestHeadValueCopyWith(GithubPullRequestHeadValue value,
          $Res Function(GithubPullRequestHeadValue) _then) =
      _$GithubPullRequestHeadValueCopyWithImpl;
  @useResult
  $Res call(
      {String? label,
      String? ref,
      String? sha,
      @refParam GithubUserModelRef? user,
      @refParam GithubRepositoryModelRef? repo});
}

/// @nodoc
class _$GithubPullRequestHeadValueCopyWithImpl<$Res>
    implements $GithubPullRequestHeadValueCopyWith<$Res> {
  _$GithubPullRequestHeadValueCopyWithImpl(this._self, this._then);

  final GithubPullRequestHeadValue _self;
  final $Res Function(GithubPullRequestHeadValue) _then;

  /// Create a copy of GithubPullRequestHeadValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = freezed,
    Object? ref = freezed,
    Object? sha = freezed,
    Object? user = freezed,
    Object? repo = freezed,
  }) {
    return _then(_self.copyWith(
      label: freezed == label
          ? _self.label
          : label // ignore: cast_nullable_to_non_nullable
              as String?,
      ref: freezed == ref
          ? _self.ref
          : ref // ignore: cast_nullable_to_non_nullable
              as String?,
      sha: freezed == sha
          ? _self.sha
          : sha // ignore: cast_nullable_to_non_nullable
              as String?,
      user: freezed == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as GithubUserModelRef?,
      repo: freezed == repo
          ? _self.repo
          : repo // ignore: cast_nullable_to_non_nullable
              as GithubRepositoryModelRef?,
    ));
  }
}

/// Adds pattern-matching-related methods to [GithubPullRequestHeadValue].
extension GithubPullRequestHeadValuePatterns on GithubPullRequestHeadValue {
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
    TResult Function(_GithubPullRequestHeadValue value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GithubPullRequestHeadValue() when $default != null:
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
    TResult Function(_GithubPullRequestHeadValue value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubPullRequestHeadValue():
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
    TResult? Function(_GithubPullRequestHeadValue value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubPullRequestHeadValue() when $default != null:
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
            String? label,
            String? ref,
            String? sha,
            @refParam GithubUserModelRef? user,
            @refParam GithubRepositoryModelRef? repo)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GithubPullRequestHeadValue() when $default != null:
        return $default(
            _that.label, _that.ref, _that.sha, _that.user, _that.repo);
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
            String? label,
            String? ref,
            String? sha,
            @refParam GithubUserModelRef? user,
            @refParam GithubRepositoryModelRef? repo)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubPullRequestHeadValue():
        return $default(
            _that.label, _that.ref, _that.sha, _that.user, _that.repo);
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
            String? label,
            String? ref,
            String? sha,
            @refParam GithubUserModelRef? user,
            @refParam GithubRepositoryModelRef? repo)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubPullRequestHeadValue() when $default != null:
        return $default(
            _that.label, _that.ref, _that.sha, _that.user, _that.repo);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _GithubPullRequestHeadValue extends GithubPullRequestHeadValue {
  const _GithubPullRequestHeadValue(
      {this.label,
      this.ref,
      this.sha,
      @refParam this.user,
      @refParam this.repo})
      : super._();
  factory _GithubPullRequestHeadValue.fromJson(Map<String, dynamic> json) =>
      _$GithubPullRequestHeadValueFromJson(json);

  @override
  final String? label;
  @override
  final String? ref;
  @override
  final String? sha;
  @override
  @refParam
  final GithubUserModelRef? user;
  @override
  @refParam
  final GithubRepositoryModelRef? repo;

  /// Create a copy of GithubPullRequestHeadValue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GithubPullRequestHeadValueCopyWith<_GithubPullRequestHeadValue>
      get copyWith => __$GithubPullRequestHeadValueCopyWithImpl<
          _GithubPullRequestHeadValue>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GithubPullRequestHeadValueToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GithubPullRequestHeadValue &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.ref, ref) || other.ref == ref) &&
            (identical(other.sha, sha) || other.sha == sha) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.repo, repo) || other.repo == repo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, label, ref, sha, user, repo);

  @override
  String toString() {
    return 'GithubPullRequestHeadValue(label: $label, ref: $ref, sha: $sha, user: $user, repo: $repo)';
  }
}

/// @nodoc
abstract mixin class _$GithubPullRequestHeadValueCopyWith<$Res>
    implements $GithubPullRequestHeadValueCopyWith<$Res> {
  factory _$GithubPullRequestHeadValueCopyWith(
          _GithubPullRequestHeadValue value,
          $Res Function(_GithubPullRequestHeadValue) _then) =
      __$GithubPullRequestHeadValueCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? label,
      String? ref,
      String? sha,
      @refParam GithubUserModelRef? user,
      @refParam GithubRepositoryModelRef? repo});
}

/// @nodoc
class __$GithubPullRequestHeadValueCopyWithImpl<$Res>
    implements _$GithubPullRequestHeadValueCopyWith<$Res> {
  __$GithubPullRequestHeadValueCopyWithImpl(this._self, this._then);

  final _GithubPullRequestHeadValue _self;
  final $Res Function(_GithubPullRequestHeadValue) _then;

  /// Create a copy of GithubPullRequestHeadValue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? label = freezed,
    Object? ref = freezed,
    Object? sha = freezed,
    Object? user = freezed,
    Object? repo = freezed,
  }) {
    return _then(_GithubPullRequestHeadValue(
      label: freezed == label
          ? _self.label
          : label // ignore: cast_nullable_to_non_nullable
              as String?,
      ref: freezed == ref
          ? _self.ref
          : ref // ignore: cast_nullable_to_non_nullable
              as String?,
      sha: freezed == sha
          ? _self.sha
          : sha // ignore: cast_nullable_to_non_nullable
              as String?,
      user: freezed == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as GithubUserModelRef?,
      repo: freezed == repo
          ? _self.repo
          : repo // ignore: cast_nullable_to_non_nullable
              as GithubRepositoryModelRef?,
    ));
  }
}

// dart format on
