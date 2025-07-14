// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'github_repository_permission.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GithubRepositoryPermissionValue {
  bool get admin;
  bool get push;
  bool get pull;

  /// Create a copy of GithubRepositoryPermissionValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GithubRepositoryPermissionValueCopyWith<GithubRepositoryPermissionValue>
      get copyWith => _$GithubRepositoryPermissionValueCopyWithImpl<
              GithubRepositoryPermissionValue>(
          this as GithubRepositoryPermissionValue, _$identity);

  /// Serializes this GithubRepositoryPermissionValue to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GithubRepositoryPermissionValue &&
            (identical(other.admin, admin) || other.admin == admin) &&
            (identical(other.push, push) || other.push == push) &&
            (identical(other.pull, pull) || other.pull == pull));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, admin, push, pull);

  @override
  String toString() {
    return 'GithubRepositoryPermissionValue(admin: $admin, push: $push, pull: $pull)';
  }
}

/// @nodoc
abstract mixin class $GithubRepositoryPermissionValueCopyWith<$Res> {
  factory $GithubRepositoryPermissionValueCopyWith(
          GithubRepositoryPermissionValue value,
          $Res Function(GithubRepositoryPermissionValue) _then) =
      _$GithubRepositoryPermissionValueCopyWithImpl;
  @useResult
  $Res call({bool admin, bool push, bool pull});
}

/// @nodoc
class _$GithubRepositoryPermissionValueCopyWithImpl<$Res>
    implements $GithubRepositoryPermissionValueCopyWith<$Res> {
  _$GithubRepositoryPermissionValueCopyWithImpl(this._self, this._then);

  final GithubRepositoryPermissionValue _self;
  final $Res Function(GithubRepositoryPermissionValue) _then;

  /// Create a copy of GithubRepositoryPermissionValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? admin = null,
    Object? push = null,
    Object? pull = null,
  }) {
    return _then(_self.copyWith(
      admin: null == admin
          ? _self.admin
          : admin // ignore: cast_nullable_to_non_nullable
              as bool,
      push: null == push
          ? _self.push
          : push // ignore: cast_nullable_to_non_nullable
              as bool,
      pull: null == pull
          ? _self.pull
          : pull // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [GithubRepositoryPermissionValue].
extension GithubRepositoryPermissionValuePatterns
    on GithubRepositoryPermissionValue {
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
    TResult Function(_GithubRepositoryPermissionValue value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GithubRepositoryPermissionValue() when $default != null:
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
    TResult Function(_GithubRepositoryPermissionValue value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubRepositoryPermissionValue():
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
    TResult? Function(_GithubRepositoryPermissionValue value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubRepositoryPermissionValue() when $default != null:
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
    TResult Function(bool admin, bool push, bool pull)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GithubRepositoryPermissionValue() when $default != null:
        return $default(_that.admin, _that.push, _that.pull);
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
    TResult Function(bool admin, bool push, bool pull) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubRepositoryPermissionValue():
        return $default(_that.admin, _that.push, _that.pull);
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
    TResult? Function(bool admin, bool push, bool pull)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubRepositoryPermissionValue() when $default != null:
        return $default(_that.admin, _that.push, _that.pull);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _GithubRepositoryPermissionValue extends GithubRepositoryPermissionValue {
  const _GithubRepositoryPermissionValue(
      {this.admin = false, this.push = false, this.pull = false})
      : super._();
  factory _GithubRepositoryPermissionValue.fromJson(
          Map<String, dynamic> json) =>
      _$GithubRepositoryPermissionValueFromJson(json);

  @override
  @JsonKey()
  final bool admin;
  @override
  @JsonKey()
  final bool push;
  @override
  @JsonKey()
  final bool pull;

  /// Create a copy of GithubRepositoryPermissionValue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GithubRepositoryPermissionValueCopyWith<_GithubRepositoryPermissionValue>
      get copyWith => __$GithubRepositoryPermissionValueCopyWithImpl<
          _GithubRepositoryPermissionValue>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GithubRepositoryPermissionValueToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GithubRepositoryPermissionValue &&
            (identical(other.admin, admin) || other.admin == admin) &&
            (identical(other.push, push) || other.push == push) &&
            (identical(other.pull, pull) || other.pull == pull));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, admin, push, pull);

  @override
  String toString() {
    return 'GithubRepositoryPermissionValue(admin: $admin, push: $push, pull: $pull)';
  }
}

/// @nodoc
abstract mixin class _$GithubRepositoryPermissionValueCopyWith<$Res>
    implements $GithubRepositoryPermissionValueCopyWith<$Res> {
  factory _$GithubRepositoryPermissionValueCopyWith(
          _GithubRepositoryPermissionValue value,
          $Res Function(_GithubRepositoryPermissionValue) _then) =
      __$GithubRepositoryPermissionValueCopyWithImpl;
  @override
  @useResult
  $Res call({bool admin, bool push, bool pull});
}

/// @nodoc
class __$GithubRepositoryPermissionValueCopyWithImpl<$Res>
    implements _$GithubRepositoryPermissionValueCopyWith<$Res> {
  __$GithubRepositoryPermissionValueCopyWithImpl(this._self, this._then);

  final _GithubRepositoryPermissionValue _self;
  final $Res Function(_GithubRepositoryPermissionValue) _then;

  /// Create a copy of GithubRepositoryPermissionValue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? admin = null,
    Object? push = null,
    Object? pull = null,
  }) {
    return _then(_GithubRepositoryPermissionValue(
      admin: null == admin
          ? _self.admin
          : admin // ignore: cast_nullable_to_non_nullable
              as bool,
      push: null == push
          ? _self.push
          : push // ignore: cast_nullable_to_non_nullable
              as bool,
      pull: null == pull
          ? _self.pull
          : pull // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
