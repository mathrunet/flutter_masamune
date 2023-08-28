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
  ModelTimestamp get time => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  String? get channelId => throw _privateConstructorUsedError;
  Map<String, dynamic>? get data => throw _privateConstructorUsedError;
  String? get token => throw _privateConstructorUsedError;
  String? get topic => throw _privateConstructorUsedError;

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
  $Res call(
      {ModelTimestamp time,
      String title,
      String text,
      String? channelId,
      Map<String, dynamic>? data,
      String? token,
      String? topic});
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
    Object? time = null,
    Object? title = null,
    Object? text = null,
    Object? channelId = freezed,
    Object? data = freezed,
    Object? token = freezed,
    Object? topic = freezed,
  }) {
    return _then(_value.copyWith(
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      channelId: freezed == channelId
          ? _value.channelId
          : channelId // ignore: cast_nullable_to_non_nullable
              as String?,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      token: freezed == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
      topic: freezed == topic
          ? _value.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as String?,
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
  $Res call(
      {ModelTimestamp time,
      String title,
      String text,
      String? channelId,
      Map<String, dynamic>? data,
      String? token,
      String? topic});
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
    Object? time = null,
    Object? title = null,
    Object? text = null,
    Object? channelId = freezed,
    Object? data = freezed,
    Object? token = freezed,
    Object? topic = freezed,
  }) {
    return _then(_$_PushNotificationScheduleModel(
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      channelId: freezed == channelId
          ? _value.channelId
          : channelId // ignore: cast_nullable_to_non_nullable
              as String?,
      data: freezed == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      token: freezed == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
      topic: freezed == topic
          ? _value.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_PushNotificationScheduleModel extends _PushNotificationScheduleModel {
  const _$_PushNotificationScheduleModel(
      {required this.time,
      required this.title,
      required this.text,
      this.channelId,
      final Map<String, dynamic>? data,
      this.token,
      this.topic})
      : _data = data,
        super._();

  factory _$_PushNotificationScheduleModel.fromJson(
          Map<String, dynamic> json) =>
      _$$_PushNotificationScheduleModelFromJson(json);

  @override
  final ModelTimestamp time;
  @override
  final String title;
  @override
  final String text;
  @override
  final String? channelId;
  final Map<String, dynamic>? _data;
  @override
  Map<String, dynamic>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? token;
  @override
  final String? topic;

  @override
  String toString() {
    return 'PushNotificationScheduleModel(time: $time, title: $title, text: $text, channelId: $channelId, data: $data, token: $token, topic: $topic)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PushNotificationScheduleModel &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.channelId, channelId) ||
                other.channelId == channelId) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.topic, topic) || other.topic == topic));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, time, title, text, channelId,
      const DeepCollectionEquality().hash(_data), token, topic);

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
      {required final ModelTimestamp time,
      required final String title,
      required final String text,
      final String? channelId,
      final Map<String, dynamic>? data,
      final String? token,
      final String? topic}) = _$_PushNotificationScheduleModel;
  const _PushNotificationScheduleModel._() : super._();

  factory _PushNotificationScheduleModel.fromJson(Map<String, dynamic> json) =
      _$_PushNotificationScheduleModel.fromJson;

  @override
  ModelTimestamp get time;
  @override
  String get title;
  @override
  String get text;
  @override
  String? get channelId;
  @override
  Map<String, dynamic>? get data;
  @override
  String? get token;
  @override
  String? get topic;
  @override
  @JsonKey(ignore: true)
  _$$_PushNotificationScheduleModelCopyWith<_$_PushNotificationScheduleModel>
      get copyWith => throw _privateConstructorUsedError;
}
