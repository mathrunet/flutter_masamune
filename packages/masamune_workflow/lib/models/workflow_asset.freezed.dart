// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workflow_asset.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkflowAssetModel {
  @refParam
  WorkflowOrganizationModelRef get organization;
  String? get source;
  String? get content;
  String? get path;
  String? get mimtType;
  ModelLocale? get locale;
  ModelTimestamp get createdTime;
  ModelTimestamp get updatedTime;

  /// Create a copy of WorkflowAssetModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WorkflowAssetModelCopyWith<WorkflowAssetModel> get copyWith =>
      _$WorkflowAssetModelCopyWithImpl<WorkflowAssetModel>(
          this as WorkflowAssetModel, _$identity);

  /// Serializes this WorkflowAssetModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WorkflowAssetModel &&
            (identical(other.organization, organization) ||
                other.organization == organization) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.mimtType, mimtType) ||
                other.mimtType == mimtType) &&
            (identical(other.locale, locale) || other.locale == locale) &&
            (identical(other.createdTime, createdTime) ||
                other.createdTime == createdTime) &&
            (identical(other.updatedTime, updatedTime) ||
                other.updatedTime == updatedTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, organization, source, content,
      path, mimtType, locale, createdTime, updatedTime);

  @override
  String toString() {
    return 'WorkflowAssetModel(organization: $organization, source: $source, content: $content, path: $path, mimtType: $mimtType, locale: $locale, createdTime: $createdTime, updatedTime: $updatedTime)';
  }
}

/// @nodoc
abstract mixin class $WorkflowAssetModelCopyWith<$Res> {
  factory $WorkflowAssetModelCopyWith(
          WorkflowAssetModel value, $Res Function(WorkflowAssetModel) _then) =
      _$WorkflowAssetModelCopyWithImpl;
  @useResult
  $Res call(
      {@refParam WorkflowOrganizationModelRef organization,
      String? source,
      String? content,
      String? path,
      String? mimtType,
      ModelLocale? locale,
      ModelTimestamp createdTime,
      ModelTimestamp updatedTime});
}

/// @nodoc
class _$WorkflowAssetModelCopyWithImpl<$Res>
    implements $WorkflowAssetModelCopyWith<$Res> {
  _$WorkflowAssetModelCopyWithImpl(this._self, this._then);

  final WorkflowAssetModel _self;
  final $Res Function(WorkflowAssetModel) _then;

  /// Create a copy of WorkflowAssetModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? organization = freezed,
    Object? source = freezed,
    Object? content = freezed,
    Object? path = freezed,
    Object? mimtType = freezed,
    Object? locale = freezed,
    Object? createdTime = null,
    Object? updatedTime = null,
  }) {
    return _then(_self.copyWith(
      organization: freezed == organization
          ? _self.organization
          : organization // ignore: cast_nullable_to_non_nullable
              as WorkflowOrganizationModelRef,
      source: freezed == source
          ? _self.source
          : source // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      path: freezed == path
          ? _self.path
          : path // ignore: cast_nullable_to_non_nullable
              as String?,
      mimtType: freezed == mimtType
          ? _self.mimtType
          : mimtType // ignore: cast_nullable_to_non_nullable
              as String?,
      locale: freezed == locale
          ? _self.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as ModelLocale?,
      createdTime: null == createdTime
          ? _self.createdTime
          : createdTime // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp,
      updatedTime: null == updatedTime
          ? _self.updatedTime
          : updatedTime // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp,
    ));
  }
}

/// Adds pattern-matching-related methods to [WorkflowAssetModel].
extension WorkflowAssetModelPatterns on WorkflowAssetModel {
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
    TResult Function(_WorkflowAssetModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WorkflowAssetModel() when $default != null:
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
    TResult Function(_WorkflowAssetModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowAssetModel():
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
    TResult? Function(_WorkflowAssetModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowAssetModel() when $default != null:
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
    TResult Function(
            @refParam WorkflowOrganizationModelRef organization,
            String? source,
            String? content,
            String? path,
            String? mimtType,
            ModelLocale? locale,
            ModelTimestamp createdTime,
            ModelTimestamp updatedTime)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WorkflowAssetModel() when $default != null:
        return $default(
            _that.organization,
            _that.source,
            _that.content,
            _that.path,
            _that.mimtType,
            _that.locale,
            _that.createdTime,
            _that.updatedTime);
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
    TResult Function(
            @refParam WorkflowOrganizationModelRef organization,
            String? source,
            String? content,
            String? path,
            String? mimtType,
            ModelLocale? locale,
            ModelTimestamp createdTime,
            ModelTimestamp updatedTime)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowAssetModel():
        return $default(
            _that.organization,
            _that.source,
            _that.content,
            _that.path,
            _that.mimtType,
            _that.locale,
            _that.createdTime,
            _that.updatedTime);
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
    TResult? Function(
            @refParam WorkflowOrganizationModelRef organization,
            String? source,
            String? content,
            String? path,
            String? mimtType,
            ModelLocale? locale,
            ModelTimestamp createdTime,
            ModelTimestamp updatedTime)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowAssetModel() when $default != null:
        return $default(
            _that.organization,
            _that.source,
            _that.content,
            _that.path,
            _that.mimtType,
            _that.locale,
            _that.createdTime,
            _that.updatedTime);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _WorkflowAssetModel extends WorkflowAssetModel {
  const _WorkflowAssetModel(
      {@refParam this.organization,
      this.source,
      this.content,
      this.path,
      this.mimtType,
      this.locale,
      this.createdTime = const ModelTimestamp.now(),
      this.updatedTime = const ModelTimestamp.now()})
      : super._();
  factory _WorkflowAssetModel.fromJson(Map<String, dynamic> json) =>
      _$WorkflowAssetModelFromJson(json);

  @override
  @refParam
  final WorkflowOrganizationModelRef organization;
  @override
  final String? source;
  @override
  final String? content;
  @override
  final String? path;
  @override
  final String? mimtType;
  @override
  final ModelLocale? locale;
  @override
  @JsonKey()
  final ModelTimestamp createdTime;
  @override
  @JsonKey()
  final ModelTimestamp updatedTime;

  /// Create a copy of WorkflowAssetModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WorkflowAssetModelCopyWith<_WorkflowAssetModel> get copyWith =>
      __$WorkflowAssetModelCopyWithImpl<_WorkflowAssetModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WorkflowAssetModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WorkflowAssetModel &&
            (identical(other.organization, organization) ||
                other.organization == organization) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.mimtType, mimtType) ||
                other.mimtType == mimtType) &&
            (identical(other.locale, locale) || other.locale == locale) &&
            (identical(other.createdTime, createdTime) ||
                other.createdTime == createdTime) &&
            (identical(other.updatedTime, updatedTime) ||
                other.updatedTime == updatedTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, organization, source, content,
      path, mimtType, locale, createdTime, updatedTime);

  @override
  String toString() {
    return 'WorkflowAssetModel(organization: $organization, source: $source, content: $content, path: $path, mimtType: $mimtType, locale: $locale, createdTime: $createdTime, updatedTime: $updatedTime)';
  }
}

/// @nodoc
abstract mixin class _$WorkflowAssetModelCopyWith<$Res>
    implements $WorkflowAssetModelCopyWith<$Res> {
  factory _$WorkflowAssetModelCopyWith(
          _WorkflowAssetModel value, $Res Function(_WorkflowAssetModel) _then) =
      __$WorkflowAssetModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@refParam WorkflowOrganizationModelRef organization,
      String? source,
      String? content,
      String? path,
      String? mimtType,
      ModelLocale? locale,
      ModelTimestamp createdTime,
      ModelTimestamp updatedTime});
}

/// @nodoc
class __$WorkflowAssetModelCopyWithImpl<$Res>
    implements _$WorkflowAssetModelCopyWith<$Res> {
  __$WorkflowAssetModelCopyWithImpl(this._self, this._then);

  final _WorkflowAssetModel _self;
  final $Res Function(_WorkflowAssetModel) _then;

  /// Create a copy of WorkflowAssetModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? organization = freezed,
    Object? source = freezed,
    Object? content = freezed,
    Object? path = freezed,
    Object? mimtType = freezed,
    Object? locale = freezed,
    Object? createdTime = null,
    Object? updatedTime = null,
  }) {
    return _then(_WorkflowAssetModel(
      organization: freezed == organization
          ? _self.organization
          : organization // ignore: cast_nullable_to_non_nullable
              as WorkflowOrganizationModelRef,
      source: freezed == source
          ? _self.source
          : source // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      path: freezed == path
          ? _self.path
          : path // ignore: cast_nullable_to_non_nullable
              as String?,
      mimtType: freezed == mimtType
          ? _self.mimtType
          : mimtType // ignore: cast_nullable_to_non_nullable
              as String?,
      locale: freezed == locale
          ? _self.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as ModelLocale?,
      createdTime: null == createdTime
          ? _self.createdTime
          : createdTime // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp,
      updatedTime: null == updatedTime
          ? _self.updatedTime
          : updatedTime // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp,
    ));
  }
}

// dart format on
