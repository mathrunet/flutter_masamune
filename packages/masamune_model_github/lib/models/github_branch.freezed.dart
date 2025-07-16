// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'github_branch.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GithubBranchModel {
  String? get name;
  @jsonParam
  GithubCommitModel? get commit;
  @refParam
  GithubBranchModelRef get baseRef;
  bool get fromServer;

  /// Create a copy of GithubBranchModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GithubBranchModelCopyWith<GithubBranchModel> get copyWith =>
      _$GithubBranchModelCopyWithImpl<GithubBranchModel>(
          this as GithubBranchModel, _$identity);

  /// Serializes this GithubBranchModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GithubBranchModel &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.commit, commit) || other.commit == commit) &&
            (identical(other.baseRef, baseRef) || other.baseRef == baseRef) &&
            (identical(other.fromServer, fromServer) ||
                other.fromServer == fromServer));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, commit, baseRef, fromServer);

  @override
  String toString() {
    return 'GithubBranchModel(name: $name, commit: $commit, baseRef: $baseRef, fromServer: $fromServer)';
  }
}

/// @nodoc
abstract mixin class $GithubBranchModelCopyWith<$Res> {
  factory $GithubBranchModelCopyWith(
          GithubBranchModel value, $Res Function(GithubBranchModel) _then) =
      _$GithubBranchModelCopyWithImpl;
  @useResult
  $Res call(
      {String? name,
      @jsonParam GithubCommitModel? commit,
      @refParam GithubBranchModelRef baseRef,
      bool fromServer});

  $GithubCommitModelCopyWith<$Res>? get commit;
}

/// @nodoc
class _$GithubBranchModelCopyWithImpl<$Res>
    implements $GithubBranchModelCopyWith<$Res> {
  _$GithubBranchModelCopyWithImpl(this._self, this._then);

  final GithubBranchModel _self;
  final $Res Function(GithubBranchModel) _then;

  /// Create a copy of GithubBranchModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? commit = freezed,
    Object? baseRef = freezed,
    Object? fromServer = null,
  }) {
    return _then(_self.copyWith(
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      commit: freezed == commit
          ? _self.commit
          : commit // ignore: cast_nullable_to_non_nullable
              as GithubCommitModel?,
      baseRef: freezed == baseRef
          ? _self.baseRef
          : baseRef // ignore: cast_nullable_to_non_nullable
              as GithubBranchModelRef,
      fromServer: null == fromServer
          ? _self.fromServer
          : fromServer // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  /// Create a copy of GithubBranchModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GithubCommitModelCopyWith<$Res>? get commit {
    if (_self.commit == null) {
      return null;
    }

    return $GithubCommitModelCopyWith<$Res>(_self.commit!, (value) {
      return _then(_self.copyWith(commit: value));
    });
  }
}

/// Adds pattern-matching-related methods to [GithubBranchModel].
extension GithubBranchModelPatterns on GithubBranchModel {
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
    TResult Function(_GithubBranchModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GithubBranchModel() when $default != null:
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
    TResult Function(_GithubBranchModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubBranchModel():
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
    TResult? Function(_GithubBranchModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubBranchModel() when $default != null:
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
    TResult Function(String? name, @jsonParam GithubCommitModel? commit,
            @refParam GithubBranchModelRef baseRef, bool fromServer)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GithubBranchModel() when $default != null:
        return $default(
            _that.name, _that.commit, _that.baseRef, _that.fromServer);
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
    TResult Function(String? name, @jsonParam GithubCommitModel? commit,
            @refParam GithubBranchModelRef baseRef, bool fromServer)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubBranchModel():
        return $default(
            _that.name, _that.commit, _that.baseRef, _that.fromServer);
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
    TResult? Function(String? name, @jsonParam GithubCommitModel? commit,
            @refParam GithubBranchModelRef baseRef, bool fromServer)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubBranchModel() when $default != null:
        return $default(
            _that.name, _that.commit, _that.baseRef, _that.fromServer);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _GithubBranchModel extends GithubBranchModel {
  const _GithubBranchModel(
      {this.name,
      @jsonParam this.commit,
      @refParam this.baseRef,
      this.fromServer = false})
      : super._();
  factory _GithubBranchModel.fromJson(Map<String, dynamic> json) =>
      _$GithubBranchModelFromJson(json);

  @override
  final String? name;
  @override
  @jsonParam
  final GithubCommitModel? commit;
  @override
  @refParam
  final GithubBranchModelRef baseRef;
  @override
  @JsonKey()
  final bool fromServer;

  /// Create a copy of GithubBranchModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GithubBranchModelCopyWith<_GithubBranchModel> get copyWith =>
      __$GithubBranchModelCopyWithImpl<_GithubBranchModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GithubBranchModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GithubBranchModel &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.commit, commit) || other.commit == commit) &&
            (identical(other.baseRef, baseRef) || other.baseRef == baseRef) &&
            (identical(other.fromServer, fromServer) ||
                other.fromServer == fromServer));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, commit, baseRef, fromServer);

  @override
  String toString() {
    return 'GithubBranchModel(name: $name, commit: $commit, baseRef: $baseRef, fromServer: $fromServer)';
  }
}

/// @nodoc
abstract mixin class _$GithubBranchModelCopyWith<$Res>
    implements $GithubBranchModelCopyWith<$Res> {
  factory _$GithubBranchModelCopyWith(
          _GithubBranchModel value, $Res Function(_GithubBranchModel) _then) =
      __$GithubBranchModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? name,
      @jsonParam GithubCommitModel? commit,
      @refParam GithubBranchModelRef baseRef,
      bool fromServer});

  @override
  $GithubCommitModelCopyWith<$Res>? get commit;
}

/// @nodoc
class __$GithubBranchModelCopyWithImpl<$Res>
    implements _$GithubBranchModelCopyWith<$Res> {
  __$GithubBranchModelCopyWithImpl(this._self, this._then);

  final _GithubBranchModel _self;
  final $Res Function(_GithubBranchModel) _then;

  /// Create a copy of GithubBranchModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = freezed,
    Object? commit = freezed,
    Object? baseRef = freezed,
    Object? fromServer = null,
  }) {
    return _then(_GithubBranchModel(
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      commit: freezed == commit
          ? _self.commit
          : commit // ignore: cast_nullable_to_non_nullable
              as GithubCommitModel?,
      baseRef: freezed == baseRef
          ? _self.baseRef
          : baseRef // ignore: cast_nullable_to_non_nullable
              as GithubBranchModelRef,
      fromServer: null == fromServer
          ? _self.fromServer
          : fromServer // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  /// Create a copy of GithubBranchModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GithubCommitModelCopyWith<$Res>? get commit {
    if (_self.commit == null) {
      return null;
    }

    return $GithubCommitModelCopyWith<$Res>(_self.commit!, (value) {
      return _then(_self.copyWith(commit: value));
    });
  }
}

// dart format on
