// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'push_notification_schedule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PushNotificationScheduleModel _$PushNotificationScheduleModelFromJson(
    Map<String, dynamic> json) {
  return _PushNotificationScheduleModel.fromJson(json);
}

/// @nodoc
mixin _$PushNotificationScheduleModel {
  ModelServerCommandPushNotificationSchedule get command =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PushNotificationScheduleModelCopyWith<PushNotificationScheduleModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PushNotificationScheduleModelCopyWith<$Res> {
  factory $PushNotificationScheduleModelCopyWith(
          PushNotificationScheduleModel value,
          $Res Function(PushNotificationScheduleModel) then) =
      _$PushNotificationScheduleModelCopyWithImpl<$Res,
          PushNotificationScheduleModel>;
  @useResult
  $Res call({ModelServerCommandPushNotificationSchedule command});
}

/// @nodoc
class _$PushNotificationScheduleModelCopyWithImpl<$Res,
        $Val extends PushNotificationScheduleModel>
    implements $PushNotificationScheduleModelCopyWith<$Res> {
  _$PushNotificationScheduleModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? command = null,
  }) {
    return _then(_value.copyWith(
      command: null == command
          ? _value.command
          : command // ignore: cast_nullable_to_non_nullable
              as ModelServerCommandPushNotificationSchedule,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PushNotificationScheduleModelCopyWith<$Res>
    implements $PushNotificationScheduleModelCopyWith<$Res> {
  factory _$$_PushNotificationScheduleModelCopyWith(
          _$_PushNotificationScheduleModel value,
          $Res Function(_$_PushNotificationScheduleModel) then) =
      __$$_PushNotificationScheduleModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ModelServerCommandPushNotificationSchedule command});
}

/// @nodoc
class __$$_PushNotificationScheduleModelCopyWithImpl<$Res>
    extends _$PushNotificationScheduleModelCopyWithImpl<$Res,
        _$_PushNotificationScheduleModel>
    implements _$$_PushNotificationScheduleModelCopyWith<$Res> {
  __$$_PushNotificationScheduleModelCopyWithImpl(
      _$_PushNotificationScheduleModel _value,
      $Res Function(_$_PushNotificationScheduleModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? command = null,
  }) {
    return _then(_$_PushNotificationScheduleModel(
      command: null == command
          ? _value.command
          : command // ignore: cast_nullable_to_non_nullable
              as ModelServerCommandPushNotificationSchedule,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_PushNotificationScheduleModel extends _PushNotificationScheduleModel {
  const _$_PushNotificationScheduleModel({required this.command}) : super._();

  factory _$_PushNotificationScheduleModel.fromJson(
          Map<String, dynamic> json) =>
      _$$_PushNotificationScheduleModelFromJson(json);

  @override
  final ModelServerCommandPushNotificationSchedule command;

  @override
  String toString() {
    return 'PushNotificationScheduleModel(command: $command)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PushNotificationScheduleModel &&
            (identical(other.command, command) || other.command == command));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, command);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PushNotificationScheduleModelCopyWith<_$_PushNotificationScheduleModel>
      get copyWith => __$$_PushNotificationScheduleModelCopyWithImpl<
          _$_PushNotificationScheduleModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PushNotificationScheduleModelToJson(
      this,
    );
  }
}

abstract class _PushNotificationScheduleModel
    extends PushNotificationScheduleModel {
  const factory _PushNotificationScheduleModel(
          {required final ModelServerCommandPushNotificationSchedule command}) =
      _$_PushNotificationScheduleModel;
  const _PushNotificationScheduleModel._() : super._();

  factory _PushNotificationScheduleModel.fromJson(Map<String, dynamic> json) =
      _$_PushNotificationScheduleModel.fromJson;

  @override
  ModelServerCommandPushNotificationSchedule get command;
  @override
  @JsonKey(ignore: true)
  _$$_PushNotificationScheduleModelCopyWith<_$_PushNotificationScheduleModel>
      get copyWith => throw _privateConstructorUsedError;
}
