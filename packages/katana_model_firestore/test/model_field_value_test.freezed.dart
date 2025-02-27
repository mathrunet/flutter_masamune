// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'model_field_value_test.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TestValue _$TestValueFromJson(Map<String, dynamic> json) {
  return _TestValue.fromJson(json);
}

/// @nodoc
mixin _$TestValue {
  ModelTimestamp get dateTime => throw _privateConstructorUsedError;
  ModelDate get date => throw _privateConstructorUsedError;
  ModelTime get time => throw _privateConstructorUsedError;
  ModelTimeRange get timeRange => throw _privateConstructorUsedError;
  ModelTimestampRange get timestampRange => throw _privateConstructorUsedError;
  ModelDateRange get dateRange => throw _privateConstructorUsedError;
  ModelCounter get counter => throw _privateConstructorUsedError;
  ModelUri get uri => throw _privateConstructorUsedError;
  ModelImageUri get image => throw _privateConstructorUsedError;
  ModelVideoUri get video => throw _privateConstructorUsedError;
  ModelGeoValue get geo => throw _privateConstructorUsedError;
  ModelSearch get search => throw _privateConstructorUsedError;
  ModelLocale get locale => throw _privateConstructorUsedError;
  ModelLocalizedValue get localized => throw _privateConstructorUsedError;
  Map<String, ModelVideoUri> get videoMap => throw _privateConstructorUsedError;
  List<ModelImageUri> get imageList => throw _privateConstructorUsedError;
  Map<String, ModelLocalizedValue> get localizedMap =>
      throw _privateConstructorUsedError;
  List<ModelLocalizedValue> get localizedList =>
      throw _privateConstructorUsedError;

  /// Serializes this TestValue to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TestValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TestValueCopyWith<TestValue> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TestValueCopyWith<$Res> {
  factory $TestValueCopyWith(TestValue value, $Res Function(TestValue) then) =
      _$TestValueCopyWithImpl<$Res, TestValue>;
  @useResult
  $Res call(
      {ModelTimestamp dateTime,
      ModelDate date,
      ModelTime time,
      ModelTimeRange timeRange,
      ModelTimestampRange timestampRange,
      ModelDateRange dateRange,
      ModelCounter counter,
      ModelUri uri,
      ModelImageUri image,
      ModelVideoUri video,
      ModelGeoValue geo,
      ModelSearch search,
      ModelLocale locale,
      ModelLocalizedValue localized,
      Map<String, ModelVideoUri> videoMap,
      List<ModelImageUri> imageList,
      Map<String, ModelLocalizedValue> localizedMap,
      List<ModelLocalizedValue> localizedList});
}

/// @nodoc
class _$TestValueCopyWithImpl<$Res, $Val extends TestValue>
    implements $TestValueCopyWith<$Res> {
  _$TestValueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TestValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dateTime = null,
    Object? date = null,
    Object? time = null,
    Object? timeRange = null,
    Object? timestampRange = null,
    Object? dateRange = null,
    Object? counter = null,
    Object? uri = null,
    Object? image = null,
    Object? video = null,
    Object? geo = null,
    Object? search = null,
    Object? locale = null,
    Object? localized = null,
    Object? videoMap = null,
    Object? imageList = null,
    Object? localizedMap = null,
    Object? localizedList = null,
  }) {
    return _then(_value.copyWith(
      dateTime: null == dateTime
          ? _value.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as ModelDate,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as ModelTime,
      timeRange: null == timeRange
          ? _value.timeRange
          : timeRange // ignore: cast_nullable_to_non_nullable
              as ModelTimeRange,
      timestampRange: null == timestampRange
          ? _value.timestampRange
          : timestampRange // ignore: cast_nullable_to_non_nullable
              as ModelTimestampRange,
      dateRange: null == dateRange
          ? _value.dateRange
          : dateRange // ignore: cast_nullable_to_non_nullable
              as ModelDateRange,
      counter: null == counter
          ? _value.counter
          : counter // ignore: cast_nullable_to_non_nullable
              as ModelCounter,
      uri: null == uri
          ? _value.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as ModelUri,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as ModelImageUri,
      video: null == video
          ? _value.video
          : video // ignore: cast_nullable_to_non_nullable
              as ModelVideoUri,
      geo: null == geo
          ? _value.geo
          : geo // ignore: cast_nullable_to_non_nullable
              as ModelGeoValue,
      search: null == search
          ? _value.search
          : search // ignore: cast_nullable_to_non_nullable
              as ModelSearch,
      locale: null == locale
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as ModelLocale,
      localized: null == localized
          ? _value.localized
          : localized // ignore: cast_nullable_to_non_nullable
              as ModelLocalizedValue,
      videoMap: null == videoMap
          ? _value.videoMap
          : videoMap // ignore: cast_nullable_to_non_nullable
              as Map<String, ModelVideoUri>,
      imageList: null == imageList
          ? _value.imageList
          : imageList // ignore: cast_nullable_to_non_nullable
              as List<ModelImageUri>,
      localizedMap: null == localizedMap
          ? _value.localizedMap
          : localizedMap // ignore: cast_nullable_to_non_nullable
              as Map<String, ModelLocalizedValue>,
      localizedList: null == localizedList
          ? _value.localizedList
          : localizedList // ignore: cast_nullable_to_non_nullable
              as List<ModelLocalizedValue>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TestValueImplCopyWith<$Res>
    implements $TestValueCopyWith<$Res> {
  factory _$$TestValueImplCopyWith(
          _$TestValueImpl value, $Res Function(_$TestValueImpl) then) =
      __$$TestValueImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {ModelTimestamp dateTime,
      ModelDate date,
      ModelTime time,
      ModelTimeRange timeRange,
      ModelTimestampRange timestampRange,
      ModelDateRange dateRange,
      ModelCounter counter,
      ModelUri uri,
      ModelImageUri image,
      ModelVideoUri video,
      ModelGeoValue geo,
      ModelSearch search,
      ModelLocale locale,
      ModelLocalizedValue localized,
      Map<String, ModelVideoUri> videoMap,
      List<ModelImageUri> imageList,
      Map<String, ModelLocalizedValue> localizedMap,
      List<ModelLocalizedValue> localizedList});
}

/// @nodoc
class __$$TestValueImplCopyWithImpl<$Res>
    extends _$TestValueCopyWithImpl<$Res, _$TestValueImpl>
    implements _$$TestValueImplCopyWith<$Res> {
  __$$TestValueImplCopyWithImpl(
      _$TestValueImpl _value, $Res Function(_$TestValueImpl) _then)
      : super(_value, _then);

  /// Create a copy of TestValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dateTime = null,
    Object? date = null,
    Object? time = null,
    Object? timeRange = null,
    Object? timestampRange = null,
    Object? dateRange = null,
    Object? counter = null,
    Object? uri = null,
    Object? image = null,
    Object? video = null,
    Object? geo = null,
    Object? search = null,
    Object? locale = null,
    Object? localized = null,
    Object? videoMap = null,
    Object? imageList = null,
    Object? localizedMap = null,
    Object? localizedList = null,
  }) {
    return _then(_$TestValueImpl(
      dateTime: null == dateTime
          ? _value.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as ModelDate,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as ModelTime,
      timeRange: null == timeRange
          ? _value.timeRange
          : timeRange // ignore: cast_nullable_to_non_nullable
              as ModelTimeRange,
      timestampRange: null == timestampRange
          ? _value.timestampRange
          : timestampRange // ignore: cast_nullable_to_non_nullable
              as ModelTimestampRange,
      dateRange: null == dateRange
          ? _value.dateRange
          : dateRange // ignore: cast_nullable_to_non_nullable
              as ModelDateRange,
      counter: null == counter
          ? _value.counter
          : counter // ignore: cast_nullable_to_non_nullable
              as ModelCounter,
      uri: null == uri
          ? _value.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as ModelUri,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as ModelImageUri,
      video: null == video
          ? _value.video
          : video // ignore: cast_nullable_to_non_nullable
              as ModelVideoUri,
      geo: null == geo
          ? _value.geo
          : geo // ignore: cast_nullable_to_non_nullable
              as ModelGeoValue,
      search: null == search
          ? _value.search
          : search // ignore: cast_nullable_to_non_nullable
              as ModelSearch,
      locale: null == locale
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as ModelLocale,
      localized: null == localized
          ? _value.localized
          : localized // ignore: cast_nullable_to_non_nullable
              as ModelLocalizedValue,
      videoMap: null == videoMap
          ? _value._videoMap
          : videoMap // ignore: cast_nullable_to_non_nullable
              as Map<String, ModelVideoUri>,
      imageList: null == imageList
          ? _value._imageList
          : imageList // ignore: cast_nullable_to_non_nullable
              as List<ModelImageUri>,
      localizedMap: null == localizedMap
          ? _value._localizedMap
          : localizedMap // ignore: cast_nullable_to_non_nullable
              as Map<String, ModelLocalizedValue>,
      localizedList: null == localizedList
          ? _value._localizedList
          : localizedList // ignore: cast_nullable_to_non_nullable
              as List<ModelLocalizedValue>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TestValueImpl implements _TestValue {
  const _$TestValueImpl(
      {this.dateTime = const ModelTimestamp(),
      this.date = const ModelDate(),
      this.time = const ModelTime(),
      this.timeRange = const ModelTimeRange.fromModelTime(
          start: ModelTime.time(10, 0), end: ModelTime.time(11, 0)),
      this.timestampRange = const ModelTimestampRange.fromModelTimestamp(
          start: ModelTimestamp.dateTime(2022, 1, 1),
          end: ModelTimestamp.dateTime(2022, 1, 2)),
      this.dateRange = const ModelDateRange.fromModelDate(
          start: ModelDate.date(2022, 1, 1), end: ModelDate.date(2022, 1, 2)),
      this.counter = const ModelCounter(0),
      this.uri = const ModelUri(),
      this.image = const ModelImageUri(),
      this.video = const ModelVideoUri(),
      this.geo = const ModelGeoValue(),
      this.search = const ModelSearch([]),
      this.locale = const ModelLocale(),
      this.localized = const ModelLocalizedValue(),
      final Map<String, ModelVideoUri> videoMap = const {},
      final List<ModelImageUri> imageList = const [],
      final Map<String, ModelLocalizedValue> localizedMap = const {},
      final List<ModelLocalizedValue> localizedList = const []})
      : _videoMap = videoMap,
        _imageList = imageList,
        _localizedMap = localizedMap,
        _localizedList = localizedList;

  factory _$TestValueImpl.fromJson(Map<String, dynamic> json) =>
      _$$TestValueImplFromJson(json);

  @override
  @JsonKey()
  final ModelTimestamp dateTime;
  @override
  @JsonKey()
  final ModelDate date;
  @override
  @JsonKey()
  final ModelTime time;
  @override
  @JsonKey()
  final ModelTimeRange timeRange;
  @override
  @JsonKey()
  final ModelTimestampRange timestampRange;
  @override
  @JsonKey()
  final ModelDateRange dateRange;
  @override
  @JsonKey()
  final ModelCounter counter;
  @override
  @JsonKey()
  final ModelUri uri;
  @override
  @JsonKey()
  final ModelImageUri image;
  @override
  @JsonKey()
  final ModelVideoUri video;
  @override
  @JsonKey()
  final ModelGeoValue geo;
  @override
  @JsonKey()
  final ModelSearch search;
  @override
  @JsonKey()
  final ModelLocale locale;
  @override
  @JsonKey()
  final ModelLocalizedValue localized;
  final Map<String, ModelVideoUri> _videoMap;
  @override
  @JsonKey()
  Map<String, ModelVideoUri> get videoMap {
    if (_videoMap is EqualUnmodifiableMapView) return _videoMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_videoMap);
  }

  final List<ModelImageUri> _imageList;
  @override
  @JsonKey()
  List<ModelImageUri> get imageList {
    if (_imageList is EqualUnmodifiableListView) return _imageList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imageList);
  }

  final Map<String, ModelLocalizedValue> _localizedMap;
  @override
  @JsonKey()
  Map<String, ModelLocalizedValue> get localizedMap {
    if (_localizedMap is EqualUnmodifiableMapView) return _localizedMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_localizedMap);
  }

  final List<ModelLocalizedValue> _localizedList;
  @override
  @JsonKey()
  List<ModelLocalizedValue> get localizedList {
    if (_localizedList is EqualUnmodifiableListView) return _localizedList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_localizedList);
  }

  @override
  String toString() {
    return 'TestValue(dateTime: $dateTime, date: $date, time: $time, timeRange: $timeRange, timestampRange: $timestampRange, dateRange: $dateRange, counter: $counter, uri: $uri, image: $image, video: $video, geo: $geo, search: $search, locale: $locale, localized: $localized, videoMap: $videoMap, imageList: $imageList, localizedMap: $localizedMap, localizedList: $localizedList)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TestValueImpl &&
            (identical(other.dateTime, dateTime) ||
                other.dateTime == dateTime) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.timeRange, timeRange) ||
                other.timeRange == timeRange) &&
            (identical(other.timestampRange, timestampRange) ||
                other.timestampRange == timestampRange) &&
            (identical(other.dateRange, dateRange) ||
                other.dateRange == dateRange) &&
            (identical(other.counter, counter) || other.counter == counter) &&
            (identical(other.uri, uri) || other.uri == uri) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.video, video) || other.video == video) &&
            (identical(other.geo, geo) || other.geo == geo) &&
            (identical(other.search, search) || other.search == search) &&
            (identical(other.locale, locale) || other.locale == locale) &&
            (identical(other.localized, localized) ||
                other.localized == localized) &&
            const DeepCollectionEquality().equals(other._videoMap, _videoMap) &&
            const DeepCollectionEquality()
                .equals(other._imageList, _imageList) &&
            const DeepCollectionEquality()
                .equals(other._localizedMap, _localizedMap) &&
            const DeepCollectionEquality()
                .equals(other._localizedList, _localizedList));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      dateTime,
      date,
      time,
      timeRange,
      timestampRange,
      dateRange,
      counter,
      uri,
      image,
      video,
      geo,
      search,
      locale,
      localized,
      const DeepCollectionEquality().hash(_videoMap),
      const DeepCollectionEquality().hash(_imageList),
      const DeepCollectionEquality().hash(_localizedMap),
      const DeepCollectionEquality().hash(_localizedList));

  /// Create a copy of TestValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TestValueImplCopyWith<_$TestValueImpl> get copyWith =>
      __$$TestValueImplCopyWithImpl<_$TestValueImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TestValueImplToJson(
      this,
    );
  }
}

abstract class _TestValue implements TestValue {
  const factory _TestValue(
      {final ModelTimestamp dateTime,
      final ModelDate date,
      final ModelTime time,
      final ModelTimeRange timeRange,
      final ModelTimestampRange timestampRange,
      final ModelDateRange dateRange,
      final ModelCounter counter,
      final ModelUri uri,
      final ModelImageUri image,
      final ModelVideoUri video,
      final ModelGeoValue geo,
      final ModelSearch search,
      final ModelLocale locale,
      final ModelLocalizedValue localized,
      final Map<String, ModelVideoUri> videoMap,
      final List<ModelImageUri> imageList,
      final Map<String, ModelLocalizedValue> localizedMap,
      final List<ModelLocalizedValue> localizedList}) = _$TestValueImpl;

  factory _TestValue.fromJson(Map<String, dynamic> json) =
      _$TestValueImpl.fromJson;

  @override
  ModelTimestamp get dateTime;
  @override
  ModelDate get date;
  @override
  ModelTime get time;
  @override
  ModelTimeRange get timeRange;
  @override
  ModelTimestampRange get timestampRange;
  @override
  ModelDateRange get dateRange;
  @override
  ModelCounter get counter;
  @override
  ModelUri get uri;
  @override
  ModelImageUri get image;
  @override
  ModelVideoUri get video;
  @override
  ModelGeoValue get geo;
  @override
  ModelSearch get search;
  @override
  ModelLocale get locale;
  @override
  ModelLocalizedValue get localized;
  @override
  Map<String, ModelVideoUri> get videoMap;
  @override
  List<ModelImageUri> get imageList;
  @override
  Map<String, ModelLocalizedValue> get localizedMap;
  @override
  List<ModelLocalizedValue> get localizedList;

  /// Create a copy of TestValue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TestValueImplCopyWith<_$TestValueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
