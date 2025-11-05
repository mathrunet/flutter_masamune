// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'purchase_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PurchaseUserModel {
  double get value;

  /// Create a copy of PurchaseUserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PurchaseUserModelCopyWith<PurchaseUserModel> get copyWith =>
      _$PurchaseUserModelCopyWithImpl<PurchaseUserModel>(
          this as PurchaseUserModel, _$identity);

  /// Serializes this PurchaseUserModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PurchaseUserModel &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, value);

  @override
  String toString() {
    return 'PurchaseUserModel(value: $value)';
  }
}

/// @nodoc
abstract mixin class $PurchaseUserModelCopyWith<$Res> {
  factory $PurchaseUserModelCopyWith(
          PurchaseUserModel value, $Res Function(PurchaseUserModel) _then) =
      _$PurchaseUserModelCopyWithImpl;
  @useResult
  $Res call({double value});
}

/// @nodoc
class _$PurchaseUserModelCopyWithImpl<$Res>
    implements $PurchaseUserModelCopyWith<$Res> {
  _$PurchaseUserModelCopyWithImpl(this._self, this._then);

  final PurchaseUserModel _self;
  final $Res Function(PurchaseUserModel) _then;

  /// Create a copy of PurchaseUserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_self.copyWith(
      value: null == value
          ? _self.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// Adds pattern-matching-related methods to [PurchaseUserModel].
extension PurchaseUserModelPatterns on PurchaseUserModel {
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
    TResult Function(_PurchaseUserModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PurchaseUserModel() when $default != null:
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
    TResult Function(_PurchaseUserModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PurchaseUserModel():
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
    TResult? Function(_PurchaseUserModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PurchaseUserModel() when $default != null:
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
    TResult Function(double value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PurchaseUserModel() when $default != null:
        return $default(_that.value);
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
    TResult Function(double value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PurchaseUserModel():
        return $default(_that.value);
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
    TResult? Function(double value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PurchaseUserModel() when $default != null:
        return $default(_that.value);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _PurchaseUserModel extends PurchaseUserModel {
  const _PurchaseUserModel({this.value = 0.0}) : super._();
  factory _PurchaseUserModel.fromJson(Map<String, dynamic> json) =>
      _$PurchaseUserModelFromJson(json);

  @override
  @JsonKey()
  final double value;

  /// Create a copy of PurchaseUserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PurchaseUserModelCopyWith<_PurchaseUserModel> get copyWith =>
      __$PurchaseUserModelCopyWithImpl<_PurchaseUserModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PurchaseUserModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PurchaseUserModel &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, value);

  @override
  String toString() {
    return 'PurchaseUserModel(value: $value)';
  }
}

/// @nodoc
abstract mixin class _$PurchaseUserModelCopyWith<$Res>
    implements $PurchaseUserModelCopyWith<$Res> {
  factory _$PurchaseUserModelCopyWith(
          _PurchaseUserModel value, $Res Function(_PurchaseUserModel) _then) =
      __$PurchaseUserModelCopyWithImpl;
  @override
  @useResult
  $Res call({double value});
}

/// @nodoc
class __$PurchaseUserModelCopyWithImpl<$Res>
    implements _$PurchaseUserModelCopyWith<$Res> {
  __$PurchaseUserModelCopyWithImpl(this._self, this._then);

  final _PurchaseUserModel _self;
  final $Res Function(_PurchaseUserModel) _then;

  /// Create a copy of PurchaseUserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? value = null,
  }) {
    return _then(_PurchaseUserModel(
      value: null == value
          ? _self.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

// dart format on
