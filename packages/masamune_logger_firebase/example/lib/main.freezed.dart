// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'main.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AnalyticsValue {
  String get userId;

  /// Create a copy of AnalyticsValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AnalyticsValueCopyWith<AnalyticsValue> get copyWith =>
      _$AnalyticsValueCopyWithImpl<AnalyticsValue>(
          this as AnalyticsValue, _$identity);

  /// Serializes this AnalyticsValue to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AnalyticsValue &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId);

  @override
  String toString() {
    return 'AnalyticsValue(userId: $userId)';
  }
}

/// @nodoc
abstract mixin class $AnalyticsValueCopyWith<$Res> {
  factory $AnalyticsValueCopyWith(
          AnalyticsValue value, $Res Function(AnalyticsValue) _then) =
      _$AnalyticsValueCopyWithImpl;
  @useResult
  $Res call({String userId});
}

/// @nodoc
class _$AnalyticsValueCopyWithImpl<$Res>
    implements $AnalyticsValueCopyWith<$Res> {
  _$AnalyticsValueCopyWithImpl(this._self, this._then);

  final AnalyticsValue _self;
  final $Res Function(AnalyticsValue) _then;

  /// Create a copy of AnalyticsValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
  }) {
    return _then(_self.copyWith(
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _AnalyticsValue extends AnalyticsValue {
  const _AnalyticsValue({required this.userId}) : super._();
  factory _AnalyticsValue.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsValueFromJson(json);

  @override
  final String userId;

  /// Create a copy of AnalyticsValue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AnalyticsValueCopyWith<_AnalyticsValue> get copyWith =>
      __$AnalyticsValueCopyWithImpl<_AnalyticsValue>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AnalyticsValueToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AnalyticsValue &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId);

  @override
  String toString() {
    return 'AnalyticsValue(userId: $userId)';
  }
}

/// @nodoc
abstract mixin class _$AnalyticsValueCopyWith<$Res>
    implements $AnalyticsValueCopyWith<$Res> {
  factory _$AnalyticsValueCopyWith(
          _AnalyticsValue value, $Res Function(_AnalyticsValue) _then) =
      __$AnalyticsValueCopyWithImpl;
  @override
  @useResult
  $Res call({String userId});
}

/// @nodoc
class __$AnalyticsValueCopyWithImpl<$Res>
    implements _$AnalyticsValueCopyWith<$Res> {
  __$AnalyticsValueCopyWithImpl(this._self, this._then);

  final _AnalyticsValue _self;
  final $Res Function(_AnalyticsValue) _then;

  /// Create a copy of AnalyticsValue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? userId = null,
  }) {
    return _then(_AnalyticsValue(
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
