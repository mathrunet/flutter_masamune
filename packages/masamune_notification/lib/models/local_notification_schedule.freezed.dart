// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark, unnecessary_non_null_assertion

part of 'local_notification_schedule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LocalNotificationScheduleModel {
  int? get id;
  ModelTimestamp get time;
  LocalNotificationRepeatSettings get repeat;
  String get title;
  String get text;
  DynamicMap get data;

  /// Create a copy of LocalNotificationScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LocalNotificationScheduleModelCopyWith<LocalNotificationScheduleModel>
      get copyWith => _$LocalNotificationScheduleModelCopyWithImpl<
              LocalNotificationScheduleModel>(
          this as LocalNotificationScheduleModel, _$identity);

  /// Serializes this LocalNotificationScheduleModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LocalNotificationScheduleModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.repeat, repeat) || other.repeat == repeat) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.text, text) || other.text == text) &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, time, repeat, title, text,
      const DeepCollectionEquality().hash(data));

  @override
  String toString() {
    return 'LocalNotificationScheduleModel(id: $id, time: $time, repeat: $repeat, title: $title, text: $text, data: $data)';
  }
}

/// @nodoc
abstract mixin class $LocalNotificationScheduleModelCopyWith<$Res> {
  factory $LocalNotificationScheduleModelCopyWith(
          LocalNotificationScheduleModel value,
          $Res Function(LocalNotificationScheduleModel) _then) =
      _$LocalNotificationScheduleModelCopyWithImpl;
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
class _$LocalNotificationScheduleModelCopyWithImpl<$Res>
    implements $LocalNotificationScheduleModelCopyWith<$Res> {
  _$LocalNotificationScheduleModelCopyWithImpl(this._self, this._then);

  final LocalNotificationScheduleModel _self;
  final $Res Function(LocalNotificationScheduleModel) _then;

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
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      time: null == time
          ? _self.time
          : time // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp,
      repeat: null == repeat
          ? _self.repeat
          : repeat // ignore: cast_nullable_to_non_nullable
              as LocalNotificationRepeatSettings,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _self.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _self.data!
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _LocalNotificationScheduleModel extends LocalNotificationScheduleModel {
  const _LocalNotificationScheduleModel(
      {this.id,
      this.time = const ModelTimestamp(),
      this.repeat = LocalNotificationRepeatSettings.none,
      this.title = "",
      this.text = "",
      final Map<String, dynamic> data = const {}})
      : _data = data,
        super._();
  factory _LocalNotificationScheduleModel.fromJson(Map<String, dynamic> json) =>
      _$LocalNotificationScheduleModelFromJson(json);

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

  /// Create a copy of LocalNotificationScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LocalNotificationScheduleModelCopyWith<_LocalNotificationScheduleModel>
      get copyWith => __$LocalNotificationScheduleModelCopyWithImpl<
          _LocalNotificationScheduleModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$LocalNotificationScheduleModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LocalNotificationScheduleModel &&
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

  @override
  String toString() {
    return 'LocalNotificationScheduleModel(id: $id, time: $time, repeat: $repeat, title: $title, text: $text, data: $data)';
  }
}

/// @nodoc
abstract mixin class _$LocalNotificationScheduleModelCopyWith<$Res>
    implements $LocalNotificationScheduleModelCopyWith<$Res> {
  factory _$LocalNotificationScheduleModelCopyWith(
          _LocalNotificationScheduleModel value,
          $Res Function(_LocalNotificationScheduleModel) _then) =
      __$LocalNotificationScheduleModelCopyWithImpl;
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
class __$LocalNotificationScheduleModelCopyWithImpl<$Res>
    implements _$LocalNotificationScheduleModelCopyWith<$Res> {
  __$LocalNotificationScheduleModelCopyWithImpl(this._self, this._then);

  final _LocalNotificationScheduleModel _self;
  final $Res Function(_LocalNotificationScheduleModel) _then;

  /// Create a copy of LocalNotificationScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? time = null,
    Object? repeat = null,
    Object? title = null,
    Object? text = null,
    Object? data = null,
  }) {
    return _then(_LocalNotificationScheduleModel(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      time: null == time
          ? _self.time
          : time // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp,
      repeat: null == repeat
          ? _self.repeat
          : repeat // ignore: cast_nullable_to_non_nullable
              as LocalNotificationRepeatSettings,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _self.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _self._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

// dart format on
