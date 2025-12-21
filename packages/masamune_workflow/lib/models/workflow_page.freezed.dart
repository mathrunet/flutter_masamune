// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workflow_page.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkflowPageModel {
  @refParam
  WorkflowOrganizationModelRef get organization;
  @refParam
  WorkflowProjectModelRef get project;
  String? get content;
  String? get path;
  ModelLocale? get locale;
  ModelTimestamp get createdTime;
  ModelTimestamp get updatedTime;

  /// Create a copy of WorkflowPageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WorkflowPageModelCopyWith<WorkflowPageModel> get copyWith =>
      _$WorkflowPageModelCopyWithImpl<WorkflowPageModel>(
          this as WorkflowPageModel, _$identity);

  /// Serializes this WorkflowPageModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WorkflowPageModel &&
            (identical(other.organization, organization) ||
                other.organization == organization) &&
            (identical(other.project, project) || other.project == project) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.locale, locale) || other.locale == locale) &&
            (identical(other.createdTime, createdTime) ||
                other.createdTime == createdTime) &&
            (identical(other.updatedTime, updatedTime) ||
                other.updatedTime == updatedTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, organization, project, content,
      path, locale, createdTime, updatedTime);

  @override
  String toString() {
    return 'WorkflowPageModel(organization: $organization, project: $project, content: $content, path: $path, locale: $locale, createdTime: $createdTime, updatedTime: $updatedTime)';
  }
}

/// @nodoc
abstract mixin class $WorkflowPageModelCopyWith<$Res> {
  factory $WorkflowPageModelCopyWith(
          WorkflowPageModel value, $Res Function(WorkflowPageModel) _then) =
      _$WorkflowPageModelCopyWithImpl;
  @useResult
  $Res call(
      {@refParam WorkflowOrganizationModelRef organization,
      @refParam WorkflowProjectModelRef project,
      String? content,
      String? path,
      ModelLocale? locale,
      ModelTimestamp createdTime,
      ModelTimestamp updatedTime});
}

/// @nodoc
class _$WorkflowPageModelCopyWithImpl<$Res>
    implements $WorkflowPageModelCopyWith<$Res> {
  _$WorkflowPageModelCopyWithImpl(this._self, this._then);

  final WorkflowPageModel _self;
  final $Res Function(WorkflowPageModel) _then;

  /// Create a copy of WorkflowPageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? organization = freezed,
    Object? project = freezed,
    Object? content = freezed,
    Object? path = freezed,
    Object? locale = freezed,
    Object? createdTime = null,
    Object? updatedTime = null,
  }) {
    return _then(_self.copyWith(
      organization: freezed == organization
          ? _self.organization
          : organization // ignore: cast_nullable_to_non_nullable
              as WorkflowOrganizationModelRef,
      project: freezed == project
          ? _self.project
          : project // ignore: cast_nullable_to_non_nullable
              as WorkflowProjectModelRef,
      content: freezed == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      path: freezed == path
          ? _self.path
          : path // ignore: cast_nullable_to_non_nullable
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

/// Adds pattern-matching-related methods to [WorkflowPageModel].
extension WorkflowPageModelPatterns on WorkflowPageModel {
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
    TResult Function(_WorkflowPageModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WorkflowPageModel() when $default != null:
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
    TResult Function(_WorkflowPageModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowPageModel():
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
    TResult? Function(_WorkflowPageModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowPageModel() when $default != null:
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
            @refParam WorkflowProjectModelRef project,
            String? content,
            String? path,
            ModelLocale? locale,
            ModelTimestamp createdTime,
            ModelTimestamp updatedTime)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WorkflowPageModel() when $default != null:
        return $default(_that.organization, _that.project, _that.content,
            _that.path, _that.locale, _that.createdTime, _that.updatedTime);
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
            @refParam WorkflowProjectModelRef project,
            String? content,
            String? path,
            ModelLocale? locale,
            ModelTimestamp createdTime,
            ModelTimestamp updatedTime)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowPageModel():
        return $default(_that.organization, _that.project, _that.content,
            _that.path, _that.locale, _that.createdTime, _that.updatedTime);
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
            @refParam WorkflowProjectModelRef project,
            String? content,
            String? path,
            ModelLocale? locale,
            ModelTimestamp createdTime,
            ModelTimestamp updatedTime)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowPageModel() when $default != null:
        return $default(_that.organization, _that.project, _that.content,
            _that.path, _that.locale, _that.createdTime, _that.updatedTime);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _WorkflowPageModel extends WorkflowPageModel {
  const _WorkflowPageModel(
      {@refParam this.organization,
      @refParam this.project,
      this.content,
      this.path,
      this.locale,
      this.createdTime = const ModelTimestamp.now(),
      this.updatedTime = const ModelTimestamp.now()})
      : super._();
  factory _WorkflowPageModel.fromJson(Map<String, dynamic> json) =>
      _$WorkflowPageModelFromJson(json);

  @override
  @refParam
  final WorkflowOrganizationModelRef organization;
  @override
  @refParam
  final WorkflowProjectModelRef project;
  @override
  final String? content;
  @override
  final String? path;
  @override
  final ModelLocale? locale;
  @override
  @JsonKey()
  final ModelTimestamp createdTime;
  @override
  @JsonKey()
  final ModelTimestamp updatedTime;

  /// Create a copy of WorkflowPageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WorkflowPageModelCopyWith<_WorkflowPageModel> get copyWith =>
      __$WorkflowPageModelCopyWithImpl<_WorkflowPageModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WorkflowPageModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WorkflowPageModel &&
            (identical(other.organization, organization) ||
                other.organization == organization) &&
            (identical(other.project, project) || other.project == project) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.locale, locale) || other.locale == locale) &&
            (identical(other.createdTime, createdTime) ||
                other.createdTime == createdTime) &&
            (identical(other.updatedTime, updatedTime) ||
                other.updatedTime == updatedTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, organization, project, content,
      path, locale, createdTime, updatedTime);

  @override
  String toString() {
    return 'WorkflowPageModel(organization: $organization, project: $project, content: $content, path: $path, locale: $locale, createdTime: $createdTime, updatedTime: $updatedTime)';
  }
}

/// @nodoc
abstract mixin class _$WorkflowPageModelCopyWith<$Res>
    implements $WorkflowPageModelCopyWith<$Res> {
  factory _$WorkflowPageModelCopyWith(
          _WorkflowPageModel value, $Res Function(_WorkflowPageModel) _then) =
      __$WorkflowPageModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@refParam WorkflowOrganizationModelRef organization,
      @refParam WorkflowProjectModelRef project,
      String? content,
      String? path,
      ModelLocale? locale,
      ModelTimestamp createdTime,
      ModelTimestamp updatedTime});
}

/// @nodoc
class __$WorkflowPageModelCopyWithImpl<$Res>
    implements _$WorkflowPageModelCopyWith<$Res> {
  __$WorkflowPageModelCopyWithImpl(this._self, this._then);

  final _WorkflowPageModel _self;
  final $Res Function(_WorkflowPageModel) _then;

  /// Create a copy of WorkflowPageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? organization = freezed,
    Object? project = freezed,
    Object? content = freezed,
    Object? path = freezed,
    Object? locale = freezed,
    Object? createdTime = null,
    Object? updatedTime = null,
  }) {
    return _then(_WorkflowPageModel(
      organization: freezed == organization
          ? _self.organization
          : organization // ignore: cast_nullable_to_non_nullable
              as WorkflowOrganizationModelRef,
      project: freezed == project
          ? _self.project
          : project // ignore: cast_nullable_to_non_nullable
              as WorkflowProjectModelRef,
      content: freezed == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      path: freezed == path
          ? _self.path
          : path // ignore: cast_nullable_to_non_nullable
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
