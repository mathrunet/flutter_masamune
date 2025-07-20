// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark, unnecessary_non_null_assertion

part of 'remote_notification_schedule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RemoteNotificationScheduleModel {
  ModelServerCommandRemoteNotificationSchedule get command;

  /// Create a copy of RemoteNotificationScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RemoteNotificationScheduleModelCopyWith<RemoteNotificationScheduleModel>
      get copyWith => _$RemoteNotificationScheduleModelCopyWithImpl<
              RemoteNotificationScheduleModel>(
          this as RemoteNotificationScheduleModel, _$identity);

  /// Serializes this RemoteNotificationScheduleModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RemoteNotificationScheduleModel &&
            (identical(other.command, command) || other.command == command));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, command);

  @override
  String toString() {
    return 'RemoteNotificationScheduleModel(command: $command)';
  }
}

/// @nodoc
abstract mixin class $RemoteNotificationScheduleModelCopyWith<$Res> {
  factory $RemoteNotificationScheduleModelCopyWith(
          RemoteNotificationScheduleModel value,
          $Res Function(RemoteNotificationScheduleModel) _then) =
      _$RemoteNotificationScheduleModelCopyWithImpl;
  @useResult
  $Res call({ModelServerCommandRemoteNotificationSchedule command});
}

/// @nodoc
class _$RemoteNotificationScheduleModelCopyWithImpl<$Res>
    implements $RemoteNotificationScheduleModelCopyWith<$Res> {
  _$RemoteNotificationScheduleModelCopyWithImpl(this._self, this._then);

  final RemoteNotificationScheduleModel _self;
  final $Res Function(RemoteNotificationScheduleModel) _then;

  /// Create a copy of RemoteNotificationScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? command = null,
  }) {
    return _then(_self.copyWith(
      command: null == command
          ? _self.command
          : command // ignore: cast_nullable_to_non_nullable
              as ModelServerCommandRemoteNotificationSchedule,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _RemoteNotificationScheduleModel extends RemoteNotificationScheduleModel {
  const _RemoteNotificationScheduleModel({required this.command}) : super._();
  factory _RemoteNotificationScheduleModel.fromJson(
          Map<String, dynamic> json) =>
      _$RemoteNotificationScheduleModelFromJson(json);

  @override
  final ModelServerCommandRemoteNotificationSchedule command;

  /// Create a copy of RemoteNotificationScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RemoteNotificationScheduleModelCopyWith<_RemoteNotificationScheduleModel>
      get copyWith => __$RemoteNotificationScheduleModelCopyWithImpl<
          _RemoteNotificationScheduleModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RemoteNotificationScheduleModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RemoteNotificationScheduleModel &&
            (identical(other.command, command) || other.command == command));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, command);

  @override
  String toString() {
    return 'RemoteNotificationScheduleModel(command: $command)';
  }
}

/// @nodoc
abstract mixin class _$RemoteNotificationScheduleModelCopyWith<$Res>
    implements $RemoteNotificationScheduleModelCopyWith<$Res> {
  factory _$RemoteNotificationScheduleModelCopyWith(
          _RemoteNotificationScheduleModel value,
          $Res Function(_RemoteNotificationScheduleModel) _then) =
      __$RemoteNotificationScheduleModelCopyWithImpl;
  @override
  @useResult
  $Res call({ModelServerCommandRemoteNotificationSchedule command});
}

/// @nodoc
class __$RemoteNotificationScheduleModelCopyWithImpl<$Res>
    implements _$RemoteNotificationScheduleModelCopyWith<$Res> {
  __$RemoteNotificationScheduleModelCopyWithImpl(this._self, this._then);

  final _RemoteNotificationScheduleModel _self;
  final $Res Function(_RemoteNotificationScheduleModel) _then;

  /// Create a copy of RemoteNotificationScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? command = null,
  }) {
    return _then(_RemoteNotificationScheduleModel(
      command: null == command
          ? _self.command
          : command // ignore: cast_nullable_to_non_nullable
              as ModelServerCommandRemoteNotificationSchedule,
    ));
  }
}

// dart format on
