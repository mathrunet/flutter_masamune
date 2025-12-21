// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workflow_workflow.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkflowWorkflowModel {
  String? get name;
  @refParam
  WorkflowProjectModelRef get project;
  ModelLocale? get locale;
  @refParam
  WorkflowOrganizationModelRef get organization;
  WorkflowRepeat get repeat;
  @jsonParam
  List<WorkflowActionCommandValue> get actions;
  String? get prompt;
  Map<String, dynamic>? get materials;
  ModelTimestamp? get nextTime;
  ModelTimestamp? get startTime;
  ModelTimestamp get createdTime;
  ModelTimestamp get updatedTime;

  /// Create a copy of WorkflowWorkflowModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WorkflowWorkflowModelCopyWith<WorkflowWorkflowModel> get copyWith =>
      _$WorkflowWorkflowModelCopyWithImpl<WorkflowWorkflowModel>(
          this as WorkflowWorkflowModel, _$identity);

  /// Serializes this WorkflowWorkflowModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WorkflowWorkflowModel &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.project, project) || other.project == project) &&
            (identical(other.locale, locale) || other.locale == locale) &&
            (identical(other.organization, organization) ||
                other.organization == organization) &&
            (identical(other.repeat, repeat) || other.repeat == repeat) &&
            const DeepCollectionEquality().equals(other.actions, actions) &&
            (identical(other.prompt, prompt) || other.prompt == prompt) &&
            const DeepCollectionEquality().equals(other.materials, materials) &&
            (identical(other.nextTime, nextTime) ||
                other.nextTime == nextTime) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.createdTime, createdTime) ||
                other.createdTime == createdTime) &&
            (identical(other.updatedTime, updatedTime) ||
                other.updatedTime == updatedTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      project,
      locale,
      organization,
      repeat,
      const DeepCollectionEquality().hash(actions),
      prompt,
      const DeepCollectionEquality().hash(materials),
      nextTime,
      startTime,
      createdTime,
      updatedTime);

  @override
  String toString() {
    return 'WorkflowWorkflowModel(name: $name, project: $project, locale: $locale, organization: $organization, repeat: $repeat, actions: $actions, prompt: $prompt, materials: $materials, nextTime: $nextTime, startTime: $startTime, createdTime: $createdTime, updatedTime: $updatedTime)';
  }
}

/// @nodoc
abstract mixin class $WorkflowWorkflowModelCopyWith<$Res> {
  factory $WorkflowWorkflowModelCopyWith(WorkflowWorkflowModel value,
          $Res Function(WorkflowWorkflowModel) _then) =
      _$WorkflowWorkflowModelCopyWithImpl;
  @useResult
  $Res call(
      {String? name,
      @refParam WorkflowProjectModelRef project,
      ModelLocale? locale,
      @refParam WorkflowOrganizationModelRef organization,
      WorkflowRepeat repeat,
      @jsonParam List<WorkflowActionCommandValue> actions,
      String? prompt,
      Map<String, dynamic>? materials,
      ModelTimestamp? nextTime,
      ModelTimestamp? startTime,
      ModelTimestamp createdTime,
      ModelTimestamp updatedTime});
}

/// @nodoc
class _$WorkflowWorkflowModelCopyWithImpl<$Res>
    implements $WorkflowWorkflowModelCopyWith<$Res> {
  _$WorkflowWorkflowModelCopyWithImpl(this._self, this._then);

  final WorkflowWorkflowModel _self;
  final $Res Function(WorkflowWorkflowModel) _then;

  /// Create a copy of WorkflowWorkflowModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? project = freezed,
    Object? locale = freezed,
    Object? organization = freezed,
    Object? repeat = null,
    Object? actions = null,
    Object? prompt = freezed,
    Object? materials = freezed,
    Object? nextTime = freezed,
    Object? startTime = freezed,
    Object? createdTime = null,
    Object? updatedTime = null,
  }) {
    return _then(_self.copyWith(
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      project: freezed == project
          ? _self.project
          : project // ignore: cast_nullable_to_non_nullable
              as WorkflowProjectModelRef,
      locale: freezed == locale
          ? _self.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as ModelLocale?,
      organization: freezed == organization
          ? _self.organization
          : organization // ignore: cast_nullable_to_non_nullable
              as WorkflowOrganizationModelRef,
      repeat: null == repeat
          ? _self.repeat
          : repeat // ignore: cast_nullable_to_non_nullable
              as WorkflowRepeat,
      actions: null == actions
          ? _self.actions
          : actions // ignore: cast_nullable_to_non_nullable
              as List<WorkflowActionCommandValue>,
      prompt: freezed == prompt
          ? _self.prompt
          : prompt // ignore: cast_nullable_to_non_nullable
              as String?,
      materials: freezed == materials
          ? _self.materials
          : materials // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      nextTime: freezed == nextTime
          ? _self.nextTime
          : nextTime // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp?,
      startTime: freezed == startTime
          ? _self.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp?,
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

/// Adds pattern-matching-related methods to [WorkflowWorkflowModel].
extension WorkflowWorkflowModelPatterns on WorkflowWorkflowModel {
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
    TResult Function(_WorkflowWorkflowModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WorkflowWorkflowModel() when $default != null:
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
    TResult Function(_WorkflowWorkflowModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowWorkflowModel():
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
    TResult? Function(_WorkflowWorkflowModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowWorkflowModel() when $default != null:
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
            String? name,
            @refParam WorkflowProjectModelRef project,
            ModelLocale? locale,
            @refParam WorkflowOrganizationModelRef organization,
            WorkflowRepeat repeat,
            @jsonParam List<WorkflowActionCommandValue> actions,
            String? prompt,
            Map<String, dynamic>? materials,
            ModelTimestamp? nextTime,
            ModelTimestamp? startTime,
            ModelTimestamp createdTime,
            ModelTimestamp updatedTime)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WorkflowWorkflowModel() when $default != null:
        return $default(
            _that.name,
            _that.project,
            _that.locale,
            _that.organization,
            _that.repeat,
            _that.actions,
            _that.prompt,
            _that.materials,
            _that.nextTime,
            _that.startTime,
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
            String? name,
            @refParam WorkflowProjectModelRef project,
            ModelLocale? locale,
            @refParam WorkflowOrganizationModelRef organization,
            WorkflowRepeat repeat,
            @jsonParam List<WorkflowActionCommandValue> actions,
            String? prompt,
            Map<String, dynamic>? materials,
            ModelTimestamp? nextTime,
            ModelTimestamp? startTime,
            ModelTimestamp createdTime,
            ModelTimestamp updatedTime)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowWorkflowModel():
        return $default(
            _that.name,
            _that.project,
            _that.locale,
            _that.organization,
            _that.repeat,
            _that.actions,
            _that.prompt,
            _that.materials,
            _that.nextTime,
            _that.startTime,
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
            String? name,
            @refParam WorkflowProjectModelRef project,
            ModelLocale? locale,
            @refParam WorkflowOrganizationModelRef organization,
            WorkflowRepeat repeat,
            @jsonParam List<WorkflowActionCommandValue> actions,
            String? prompt,
            Map<String, dynamic>? materials,
            ModelTimestamp? nextTime,
            ModelTimestamp? startTime,
            ModelTimestamp createdTime,
            ModelTimestamp updatedTime)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowWorkflowModel() when $default != null:
        return $default(
            _that.name,
            _that.project,
            _that.locale,
            _that.organization,
            _that.repeat,
            _that.actions,
            _that.prompt,
            _that.materials,
            _that.nextTime,
            _that.startTime,
            _that.createdTime,
            _that.updatedTime);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _WorkflowWorkflowModel extends WorkflowWorkflowModel {
  const _WorkflowWorkflowModel(
      {this.name,
      @refParam this.project,
      this.locale,
      @refParam this.organization,
      this.repeat = WorkflowRepeat.none,
      @jsonParam final List<WorkflowActionCommandValue> actions = const [],
      this.prompt,
      final Map<String, dynamic>? materials,
      this.nextTime,
      this.startTime,
      this.createdTime = const ModelTimestamp.now(),
      this.updatedTime = const ModelTimestamp.now()})
      : _actions = actions,
        _materials = materials,
        super._();
  factory _WorkflowWorkflowModel.fromJson(Map<String, dynamic> json) =>
      _$WorkflowWorkflowModelFromJson(json);

  @override
  final String? name;
  @override
  @refParam
  final WorkflowProjectModelRef project;
  @override
  final ModelLocale? locale;
  @override
  @refParam
  final WorkflowOrganizationModelRef organization;
  @override
  @JsonKey()
  final WorkflowRepeat repeat;
  final List<WorkflowActionCommandValue> _actions;
  @override
  @JsonKey()
  @jsonParam
  List<WorkflowActionCommandValue> get actions {
    if (_actions is EqualUnmodifiableListView) return _actions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_actions);
  }

  @override
  final String? prompt;
  final Map<String, dynamic>? _materials;
  @override
  Map<String, dynamic>? get materials {
    final value = _materials;
    if (value == null) return null;
    if (_materials is EqualUnmodifiableMapView) return _materials;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final ModelTimestamp? nextTime;
  @override
  final ModelTimestamp? startTime;
  @override
  @JsonKey()
  final ModelTimestamp createdTime;
  @override
  @JsonKey()
  final ModelTimestamp updatedTime;

  /// Create a copy of WorkflowWorkflowModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WorkflowWorkflowModelCopyWith<_WorkflowWorkflowModel> get copyWith =>
      __$WorkflowWorkflowModelCopyWithImpl<_WorkflowWorkflowModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WorkflowWorkflowModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WorkflowWorkflowModel &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.project, project) || other.project == project) &&
            (identical(other.locale, locale) || other.locale == locale) &&
            (identical(other.organization, organization) ||
                other.organization == organization) &&
            (identical(other.repeat, repeat) || other.repeat == repeat) &&
            const DeepCollectionEquality().equals(other._actions, _actions) &&
            (identical(other.prompt, prompt) || other.prompt == prompt) &&
            const DeepCollectionEquality()
                .equals(other._materials, _materials) &&
            (identical(other.nextTime, nextTime) ||
                other.nextTime == nextTime) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.createdTime, createdTime) ||
                other.createdTime == createdTime) &&
            (identical(other.updatedTime, updatedTime) ||
                other.updatedTime == updatedTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      project,
      locale,
      organization,
      repeat,
      const DeepCollectionEquality().hash(_actions),
      prompt,
      const DeepCollectionEquality().hash(_materials),
      nextTime,
      startTime,
      createdTime,
      updatedTime);

  @override
  String toString() {
    return 'WorkflowWorkflowModel(name: $name, project: $project, locale: $locale, organization: $organization, repeat: $repeat, actions: $actions, prompt: $prompt, materials: $materials, nextTime: $nextTime, startTime: $startTime, createdTime: $createdTime, updatedTime: $updatedTime)';
  }
}

/// @nodoc
abstract mixin class _$WorkflowWorkflowModelCopyWith<$Res>
    implements $WorkflowWorkflowModelCopyWith<$Res> {
  factory _$WorkflowWorkflowModelCopyWith(_WorkflowWorkflowModel value,
          $Res Function(_WorkflowWorkflowModel) _then) =
      __$WorkflowWorkflowModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? name,
      @refParam WorkflowProjectModelRef project,
      ModelLocale? locale,
      @refParam WorkflowOrganizationModelRef organization,
      WorkflowRepeat repeat,
      @jsonParam List<WorkflowActionCommandValue> actions,
      String? prompt,
      Map<String, dynamic>? materials,
      ModelTimestamp? nextTime,
      ModelTimestamp? startTime,
      ModelTimestamp createdTime,
      ModelTimestamp updatedTime});
}

/// @nodoc
class __$WorkflowWorkflowModelCopyWithImpl<$Res>
    implements _$WorkflowWorkflowModelCopyWith<$Res> {
  __$WorkflowWorkflowModelCopyWithImpl(this._self, this._then);

  final _WorkflowWorkflowModel _self;
  final $Res Function(_WorkflowWorkflowModel) _then;

  /// Create a copy of WorkflowWorkflowModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = freezed,
    Object? project = freezed,
    Object? locale = freezed,
    Object? organization = freezed,
    Object? repeat = null,
    Object? actions = null,
    Object? prompt = freezed,
    Object? materials = freezed,
    Object? nextTime = freezed,
    Object? startTime = freezed,
    Object? createdTime = null,
    Object? updatedTime = null,
  }) {
    return _then(_WorkflowWorkflowModel(
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      project: freezed == project
          ? _self.project
          : project // ignore: cast_nullable_to_non_nullable
              as WorkflowProjectModelRef,
      locale: freezed == locale
          ? _self.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as ModelLocale?,
      organization: freezed == organization
          ? _self.organization
          : organization // ignore: cast_nullable_to_non_nullable
              as WorkflowOrganizationModelRef,
      repeat: null == repeat
          ? _self.repeat
          : repeat // ignore: cast_nullable_to_non_nullable
              as WorkflowRepeat,
      actions: null == actions
          ? _self._actions
          : actions // ignore: cast_nullable_to_non_nullable
              as List<WorkflowActionCommandValue>,
      prompt: freezed == prompt
          ? _self.prompt
          : prompt // ignore: cast_nullable_to_non_nullable
              as String?,
      materials: freezed == materials
          ? _self._materials
          : materials // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      nextTime: freezed == nextTime
          ? _self.nextTime
          : nextTime // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp?,
      startTime: freezed == startTime
          ? _self.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp?,
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
