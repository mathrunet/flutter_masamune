// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'remote_notification_schedule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RemoteNotificationScheduleModel _$RemoteNotificationScheduleModelFromJson(
    Map<String, dynamic> json) {
  return _RemoteNotificationScheduleModel.fromJson(json);
}

/// @nodoc
mixin _$RemoteNotificationScheduleModel {
  ModelServerCommandRemoteNotificationSchedule get command =>
      throw _privateConstructorUsedError;

  /// Serializes this RemoteNotificationScheduleModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RemoteNotificationScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RemoteNotificationScheduleModelCopyWith<RemoteNotificationScheduleModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RemoteNotificationScheduleModelCopyWith<$Res> {
  factory $RemoteNotificationScheduleModelCopyWith(
          RemoteNotificationScheduleModel value,
          $Res Function(RemoteNotificationScheduleModel) then) =
      _$RemoteNotificationScheduleModelCopyWithImpl<$Res,
          RemoteNotificationScheduleModel>;
  @useResult
  $Res call({ModelServerCommandRemoteNotificationSchedule command});
}

/// @nodoc
class _$RemoteNotificationScheduleModelCopyWithImpl<$Res,
        $Val extends RemoteNotificationScheduleModel>
    implements $RemoteNotificationScheduleModelCopyWith<$Res> {
  _$RemoteNotificationScheduleModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RemoteNotificationScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? command = null,
  }) {
    return _then(_value.copyWith(
      command: null == command
          ? _value.command
          : command // ignore: cast_nullable_to_non_nullable
              as ModelServerCommandRemoteNotificationSchedule,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RemoteNotificationScheduleModelImplCopyWith<$Res>
    implements $RemoteNotificationScheduleModelCopyWith<$Res> {
  factory _$$RemoteNotificationScheduleModelImplCopyWith(
          _$RemoteNotificationScheduleModelImpl value,
          $Res Function(_$RemoteNotificationScheduleModelImpl) then) =
      __$$RemoteNotificationScheduleModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ModelServerCommandRemoteNotificationSchedule command});
}

/// @nodoc
class __$$RemoteNotificationScheduleModelImplCopyWithImpl<$Res>
    extends _$RemoteNotificationScheduleModelCopyWithImpl<$Res,
        _$RemoteNotificationScheduleModelImpl>
    implements _$$RemoteNotificationScheduleModelImplCopyWith<$Res> {
  __$$RemoteNotificationScheduleModelImplCopyWithImpl(
      _$RemoteNotificationScheduleModelImpl _value,
      $Res Function(_$RemoteNotificationScheduleModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of RemoteNotificationScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? command = null,
  }) {
    return _then(_$RemoteNotificationScheduleModelImpl(
      command: null == command
          ? _value.command
          : command // ignore: cast_nullable_to_non_nullable
              as ModelServerCommandRemoteNotificationSchedule,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RemoteNotificationScheduleModelImpl
    extends _RemoteNotificationScheduleModel {
  const _$RemoteNotificationScheduleModelImpl({required this.command})
      : super._();

  factory _$RemoteNotificationScheduleModelImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$RemoteNotificationScheduleModelImplFromJson(json);

  @override
  final ModelServerCommandRemoteNotificationSchedule command;

  @override
  String toString() {
    return 'RemoteNotificationScheduleModel(command: $command)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RemoteNotificationScheduleModelImpl &&
            (identical(other.command, command) || other.command == command));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, command);

  /// Create a copy of RemoteNotificationScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RemoteNotificationScheduleModelImplCopyWith<
          _$RemoteNotificationScheduleModelImpl>
      get copyWith => __$$RemoteNotificationScheduleModelImplCopyWithImpl<
          _$RemoteNotificationScheduleModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RemoteNotificationScheduleModelImplToJson(
      this,
    );
  }
}

abstract class _RemoteNotificationScheduleModel
    extends RemoteNotificationScheduleModel {
  const factory _RemoteNotificationScheduleModel(
      {required final ModelServerCommandRemoteNotificationSchedule
          command}) = _$RemoteNotificationScheduleModelImpl;
  const _RemoteNotificationScheduleModel._() : super._();

  factory _RemoteNotificationScheduleModel.fromJson(Map<String, dynamic> json) =
      _$RemoteNotificationScheduleModelImpl.fromJson;

  @override
  ModelServerCommandRemoteNotificationSchedule get command;

  /// Create a copy of RemoteNotificationScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RemoteNotificationScheduleModelImplCopyWith<
          _$RemoteNotificationScheduleModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
