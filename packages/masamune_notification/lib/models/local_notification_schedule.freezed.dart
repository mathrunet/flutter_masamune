// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of "local_notification_schedule.dart";

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LocalNotificationScheduleModel _$LocalNotificationScheduleModelFromJson(
    Map<String, dynamic> json) {
  return _LocalNotificationScheduleModel.fromJson(json);
}

/// @nodoc
mixin _$LocalNotificationScheduleModel {
  int? get id => throw _privateConstructorUsedError;
  ModelTimestamp get time => throw _privateConstructorUsedError;
  LocalNotificationRepeatSettings get repeat =>
      throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  Map<String, dynamic> get data => throw _privateConstructorUsedError;

  /// Serializes this LocalNotificationScheduleModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LocalNotificationScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LocalNotificationScheduleModelCopyWith<LocalNotificationScheduleModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocalNotificationScheduleModelCopyWith<$Res> {
  factory $LocalNotificationScheduleModelCopyWith(
          LocalNotificationScheduleModel value,
          $Res Function(LocalNotificationScheduleModel) then) =
      _$LocalNotificationScheduleModelCopyWithImpl<$Res,
          LocalNotificationScheduleModel>;
  @useResult
  $Res call(
      {int? id,
      ModelTimestamp time,
      LocalNotificationRepeatSettings repeat,
      String title,
      String text,
      Map<String, dynamic> data});
}

/// @nodoc
class _$LocalNotificationScheduleModelCopyWithImpl<$Res,
        $Val extends LocalNotificationScheduleModel>
    implements $LocalNotificationScheduleModelCopyWith<$Res> {
  _$LocalNotificationScheduleModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LocalNotificationScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? time = null,
    Object? repeat = null,
    Object? title = null,
    Object? text = null,
    Object? data = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp,
      repeat: null == repeat
          ? _value.repeat
          : repeat // ignore: cast_nullable_to_non_nullable
              as LocalNotificationRepeatSettings,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LocalNotificationScheduleModelImplCopyWith<$Res>
    implements $LocalNotificationScheduleModelCopyWith<$Res> {
  factory _$$LocalNotificationScheduleModelImplCopyWith(
          _$LocalNotificationScheduleModelImpl value,
          $Res Function(_$LocalNotificationScheduleModelImpl) then) =
      __$$LocalNotificationScheduleModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      ModelTimestamp time,
      LocalNotificationRepeatSettings repeat,
      String title,
      String text,
      Map<String, dynamic> data});
}

/// @nodoc
class __$$LocalNotificationScheduleModelImplCopyWithImpl<$Res>
    extends _$LocalNotificationScheduleModelCopyWithImpl<$Res,
        _$LocalNotificationScheduleModelImpl>
    implements _$$LocalNotificationScheduleModelImplCopyWith<$Res> {
  __$$LocalNotificationScheduleModelImplCopyWithImpl(
      _$LocalNotificationScheduleModelImpl _value,
      $Res Function(_$LocalNotificationScheduleModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of LocalNotificationScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? time = null,
    Object? repeat = null,
    Object? title = null,
    Object? text = null,
    Object? data = null,
  }) {
    return _then(_$LocalNotificationScheduleModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp,
      repeat: null == repeat
          ? _value.repeat
          : repeat // ignore: cast_nullable_to_non_nullable
              as LocalNotificationRepeatSettings,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LocalNotificationScheduleModelImpl
    extends _LocalNotificationScheduleModel {
  const _$LocalNotificationScheduleModelImpl(
      {this.id,
      this.time = const ModelTimestamp(),
      this.repeat = LocalNotificationRepeatSettings.none,
      this.title = "",
      this.text = "",
      final Map<String, dynamic> data = const {}})
      : _data = data,
        super._();

  factory _$LocalNotificationScheduleModelImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$LocalNotificationScheduleModelImplFromJson(json);

  @override
  final int? id;
  @override
  @JsonKey()
  final ModelTimestamp time;
  @override
  @JsonKey()
  final LocalNotificationRepeatSettings repeat;
  @override
  @JsonKey()
  final String title;
  @override
  @JsonKey()
  final String text;
  final Map<String, dynamic> _data;
  @override
  @JsonKey()
  Map<String, dynamic> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  @override
  String toString() {
    return 'LocalNotificationScheduleModel(id: $id, time: $time, repeat: $repeat, title: $title, text: $text, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocalNotificationScheduleModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.repeat, repeat) || other.repeat == repeat) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.text, text) || other.text == text) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, time, repeat, title, text,
      const DeepCollectionEquality().hash(_data));

  /// Create a copy of LocalNotificationScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocalNotificationScheduleModelImplCopyWith<
          _$LocalNotificationScheduleModelImpl>
      get copyWith => __$$LocalNotificationScheduleModelImplCopyWithImpl<
          _$LocalNotificationScheduleModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LocalNotificationScheduleModelImplToJson(
      this,
    );
  }
}

abstract class _LocalNotificationScheduleModel
    extends LocalNotificationScheduleModel {
  const factory _LocalNotificationScheduleModel(
      {final int? id,
      final ModelTimestamp time,
      final LocalNotificationRepeatSettings repeat,
      final String title,
      final String text,
      final Map<String, dynamic> data}) = _$LocalNotificationScheduleModelImpl;
  const _LocalNotificationScheduleModel._() : super._();

  factory _LocalNotificationScheduleModel.fromJson(Map<String, dynamic> json) =
      _$LocalNotificationScheduleModelImpl.fromJson;

  @override
  int? get id;
  @override
  ModelTimestamp get time;
  @override
  LocalNotificationRepeatSettings get repeat;
  @override
  String get title;
  @override
  String get text;
  @override
  Map<String, dynamic> get data;

  /// Create a copy of LocalNotificationScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocalNotificationScheduleModelImplCopyWith<
          _$LocalNotificationScheduleModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
