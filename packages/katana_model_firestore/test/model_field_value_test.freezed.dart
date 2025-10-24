// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'model_field_value_test.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TestValue {
  ModelTimestamp get dateTime;
  ModelDate get date;
  ModelTime get time;
  ModelTimeRange get timeRange;
  ModelTimestampRange get timestampRange;
  ModelDateRange get dateRange;
  ModelCounter get counter;
  ModelUri get uri;
  ModelImageUri get image;
  ModelVideoUri get video;
  ModelGeoValue get geo;
  ModelVectorValue get vector;
  ModelSearch get search;
  ModelLocale get locale;
  ModelLocalizedValue get localized;
  Map<String, ModelVideoUri> get videoMap;
  List<ModelImageUri> get imageList;
  Map<String, ModelLocalizedValue> get localizedMap;
  List<ModelLocalizedValue> get localizedList;

  /// Create a copy of TestValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TestValueCopyWith<TestValue> get copyWith =>
      _$TestValueCopyWithImpl<TestValue>(this as TestValue, _$identity);

  /// Serializes this TestValue to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TestValue &&
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
            (identical(other.vector, vector) || other.vector == vector) &&
            (identical(other.search, search) || other.search == search) &&
            (identical(other.locale, locale) || other.locale == locale) &&
            (identical(other.localized, localized) ||
                other.localized == localized) &&
            const DeepCollectionEquality().equals(other.videoMap, videoMap) &&
            const DeepCollectionEquality().equals(other.imageList, imageList) &&
            const DeepCollectionEquality()
                .equals(other.localizedMap, localizedMap) &&
            const DeepCollectionEquality()
                .equals(other.localizedList, localizedList));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
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
        vector,
        search,
        locale,
        localized,
        const DeepCollectionEquality().hash(videoMap),
        const DeepCollectionEquality().hash(imageList),
        const DeepCollectionEquality().hash(localizedMap),
        const DeepCollectionEquality().hash(localizedList)
      ]);

  @override
  String toString() {
    return 'TestValue(dateTime: $dateTime, date: $date, time: $time, timeRange: $timeRange, timestampRange: $timestampRange, dateRange: $dateRange, counter: $counter, uri: $uri, image: $image, video: $video, geo: $geo, vector: $vector, search: $search, locale: $locale, localized: $localized, videoMap: $videoMap, imageList: $imageList, localizedMap: $localizedMap, localizedList: $localizedList)';
  }
}

/// @nodoc
abstract mixin class $TestValueCopyWith<$Res> {
  factory $TestValueCopyWith(TestValue value, $Res Function(TestValue) _then) =
      _$TestValueCopyWithImpl;
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
      ModelVectorValue vector,
      ModelSearch search,
      ModelLocale locale,
      ModelLocalizedValue localized,
      Map<String, ModelVideoUri> videoMap,
      List<ModelImageUri> imageList,
      Map<String, ModelLocalizedValue> localizedMap,
      List<ModelLocalizedValue> localizedList});
}

/// @nodoc
class _$TestValueCopyWithImpl<$Res> implements $TestValueCopyWith<$Res> {
  _$TestValueCopyWithImpl(this._self, this._then);

  final TestValue _self;
  final $Res Function(TestValue) _then;

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
    Object? vector = null,
    Object? search = null,
    Object? locale = null,
    Object? localized = null,
    Object? videoMap = null,
    Object? imageList = null,
    Object? localizedMap = null,
    Object? localizedList = null,
  }) {
    return _then(_self.copyWith(
      dateTime: null == dateTime
          ? _self.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as ModelDate,
      time: null == time
          ? _self.time
          : time // ignore: cast_nullable_to_non_nullable
              as ModelTime,
      timeRange: null == timeRange
          ? _self.timeRange
          : timeRange // ignore: cast_nullable_to_non_nullable
              as ModelTimeRange,
      timestampRange: null == timestampRange
          ? _self.timestampRange
          : timestampRange // ignore: cast_nullable_to_non_nullable
              as ModelTimestampRange,
      dateRange: null == dateRange
          ? _self.dateRange
          : dateRange // ignore: cast_nullable_to_non_nullable
              as ModelDateRange,
      counter: null == counter
          ? _self.counter
          : counter // ignore: cast_nullable_to_non_nullable
              as ModelCounter,
      uri: null == uri
          ? _self.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as ModelUri,
      image: null == image
          ? _self.image
          : image // ignore: cast_nullable_to_non_nullable
              as ModelImageUri,
      video: null == video
          ? _self.video
          : video // ignore: cast_nullable_to_non_nullable
              as ModelVideoUri,
      geo: null == geo
          ? _self.geo
          : geo // ignore: cast_nullable_to_non_nullable
              as ModelGeoValue,
      vector: null == vector
          ? _self.vector
          : vector // ignore: cast_nullable_to_non_nullable
              as ModelVectorValue,
      search: null == search
          ? _self.search
          : search // ignore: cast_nullable_to_non_nullable
              as ModelSearch,
      locale: null == locale
          ? _self.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as ModelLocale,
      localized: null == localized
          ? _self.localized
          : localized // ignore: cast_nullable_to_non_nullable
              as ModelLocalizedValue,
      videoMap: null == videoMap
          ? _self.videoMap
          : videoMap // ignore: cast_nullable_to_non_nullable
              as Map<String, ModelVideoUri>,
      imageList: null == imageList
          ? _self.imageList
          : imageList // ignore: cast_nullable_to_non_nullable
              as List<ModelImageUri>,
      localizedMap: null == localizedMap
          ? _self.localizedMap
          : localizedMap // ignore: cast_nullable_to_non_nullable
              as Map<String, ModelLocalizedValue>,
      localizedList: null == localizedList
          ? _self.localizedList
          : localizedList // ignore: cast_nullable_to_non_nullable
              as List<ModelLocalizedValue>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _TestValue implements TestValue {
  const _TestValue(
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
      this.vector = const ModelVectorValue(),
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
  factory _TestValue.fromJson(Map<String, dynamic> json) =>
      _$TestValueFromJson(json);

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
  final ModelVectorValue vector;
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

  /// Create a copy of TestValue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TestValueCopyWith<_TestValue> get copyWith =>
      __$TestValueCopyWithImpl<_TestValue>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TestValueToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TestValue &&
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
            (identical(other.vector, vector) || other.vector == vector) &&
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
  int get hashCode => Object.hashAll([
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
        vector,
        search,
        locale,
        localized,
        const DeepCollectionEquality().hash(_videoMap),
        const DeepCollectionEquality().hash(_imageList),
        const DeepCollectionEquality().hash(_localizedMap),
        const DeepCollectionEquality().hash(_localizedList)
      ]);

  @override
  String toString() {
    return 'TestValue(dateTime: $dateTime, date: $date, time: $time, timeRange: $timeRange, timestampRange: $timestampRange, dateRange: $dateRange, counter: $counter, uri: $uri, image: $image, video: $video, geo: $geo, vector: $vector, search: $search, locale: $locale, localized: $localized, videoMap: $videoMap, imageList: $imageList, localizedMap: $localizedMap, localizedList: $localizedList)';
  }
}

/// @nodoc
abstract mixin class _$TestValueCopyWith<$Res>
    implements $TestValueCopyWith<$Res> {
  factory _$TestValueCopyWith(
          _TestValue value, $Res Function(_TestValue) _then) =
      __$TestValueCopyWithImpl;
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
      ModelVectorValue vector,
      ModelSearch search,
      ModelLocale locale,
      ModelLocalizedValue localized,
      Map<String, ModelVideoUri> videoMap,
      List<ModelImageUri> imageList,
      Map<String, ModelLocalizedValue> localizedMap,
      List<ModelLocalizedValue> localizedList});
}

/// @nodoc
class __$TestValueCopyWithImpl<$Res> implements _$TestValueCopyWith<$Res> {
  __$TestValueCopyWithImpl(this._self, this._then);

  final _TestValue _self;
  final $Res Function(_TestValue) _then;

  /// Create a copy of TestValue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
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
    Object? vector = null,
    Object? search = null,
    Object? locale = null,
    Object? localized = null,
    Object? videoMap = null,
    Object? imageList = null,
    Object? localizedMap = null,
    Object? localizedList = null,
  }) {
    return _then(_TestValue(
      dateTime: null == dateTime
          ? _self.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as ModelDate,
      time: null == time
          ? _self.time
          : time // ignore: cast_nullable_to_non_nullable
              as ModelTime,
      timeRange: null == timeRange
          ? _self.timeRange
          : timeRange // ignore: cast_nullable_to_non_nullable
              as ModelTimeRange,
      timestampRange: null == timestampRange
          ? _self.timestampRange
          : timestampRange // ignore: cast_nullable_to_non_nullable
              as ModelTimestampRange,
      dateRange: null == dateRange
          ? _self.dateRange
          : dateRange // ignore: cast_nullable_to_non_nullable
              as ModelDateRange,
      counter: null == counter
          ? _self.counter
          : counter // ignore: cast_nullable_to_non_nullable
              as ModelCounter,
      uri: null == uri
          ? _self.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as ModelUri,
      image: null == image
          ? _self.image
          : image // ignore: cast_nullable_to_non_nullable
              as ModelImageUri,
      video: null == video
          ? _self.video
          : video // ignore: cast_nullable_to_non_nullable
              as ModelVideoUri,
      geo: null == geo
          ? _self.geo
          : geo // ignore: cast_nullable_to_non_nullable
              as ModelGeoValue,
      vector: null == vector
          ? _self.vector
          : vector // ignore: cast_nullable_to_non_nullable
              as ModelVectorValue,
      search: null == search
          ? _self.search
          : search // ignore: cast_nullable_to_non_nullable
              as ModelSearch,
      locale: null == locale
          ? _self.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as ModelLocale,
      localized: null == localized
          ? _self.localized
          : localized // ignore: cast_nullable_to_non_nullable
              as ModelLocalizedValue,
      videoMap: null == videoMap
          ? _self._videoMap
          : videoMap // ignore: cast_nullable_to_non_nullable
              as Map<String, ModelVideoUri>,
      imageList: null == imageList
          ? _self._imageList
          : imageList // ignore: cast_nullable_to_non_nullable
              as List<ModelImageUri>,
      localizedMap: null == localizedMap
          ? _self._localizedMap
          : localizedMap // ignore: cast_nullable_to_non_nullable
              as Map<String, ModelLocalizedValue>,
      localizedList: null == localizedList
          ? _self._localizedList
          : localizedList // ignore: cast_nullable_to_non_nullable
              as List<ModelLocalizedValue>,
    ));
  }
}

// dart format on
