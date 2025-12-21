// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workflow_task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkflowTaskModel {
  @refParam
  WorkflowWorkflowModelRef get workflow;
  @refParam
  WorkflowOrganizationModelRef get organization;
  @refParam
  WorkflowProjectModelRef get project;
  ModelLocale? get locale;
  WorkflowTaskStatus get status;
  @jsonParam
  List<WorkflowActionCommandValue> get actions;
  @refParam
  WorkflowActionModelRef? get currentAction;
  @jsonParam
  WorkflowActionCommandValue? get nextAction;
  Map<String, dynamic>? get error;
  @jsonParam
  List<WorkflowTaskLogValue> get log;
  String? get prompt;
  Map<String, dynamic>? get materials;
  Map<String, dynamic>? get results;
  Map<String, dynamic>? get assets;
  @searchParam
  String? get search;
  double get usage;
  ModelTimestamp? get startTime;
  ModelTimestamp? get finishedTime;
  ModelTimestamp get createdTime;
  ModelTimestamp get updatedTime;

  /// Create a copy of WorkflowTaskModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WorkflowTaskModelCopyWith<WorkflowTaskModel> get copyWith =>
      _$WorkflowTaskModelCopyWithImpl<WorkflowTaskModel>(
          this as WorkflowTaskModel, _$identity);

  /// Serializes this WorkflowTaskModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WorkflowTaskModel &&
            (identical(other.workflow, workflow) ||
                other.workflow == workflow) &&
            (identical(other.organization, organization) ||
                other.organization == organization) &&
            (identical(other.project, project) || other.project == project) &&
            (identical(other.locale, locale) || other.locale == locale) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other.actions, actions) &&
            (identical(other.currentAction, currentAction) ||
                other.currentAction == currentAction) &&
            (identical(other.nextAction, nextAction) ||
                other.nextAction == nextAction) &&
            const DeepCollectionEquality().equals(other.error, error) &&
            const DeepCollectionEquality().equals(other.log, log) &&
            (identical(other.prompt, prompt) || other.prompt == prompt) &&
            const DeepCollectionEquality().equals(other.materials, materials) &&
            const DeepCollectionEquality().equals(other.results, results) &&
            const DeepCollectionEquality().equals(other.assets, assets) &&
            (identical(other.search, search) || other.search == search) &&
            (identical(other.usage, usage) || other.usage == usage) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.finishedTime, finishedTime) ||
                other.finishedTime == finishedTime) &&
            (identical(other.createdTime, createdTime) ||
                other.createdTime == createdTime) &&
            (identical(other.updatedTime, updatedTime) ||
                other.updatedTime == updatedTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        workflow,
        organization,
        project,
        locale,
        status,
        const DeepCollectionEquality().hash(actions),
        currentAction,
        nextAction,
        const DeepCollectionEquality().hash(error),
        const DeepCollectionEquality().hash(log),
        prompt,
        const DeepCollectionEquality().hash(materials),
        const DeepCollectionEquality().hash(results),
        const DeepCollectionEquality().hash(assets),
        search,
        usage,
        startTime,
        finishedTime,
        createdTime,
        updatedTime
      ]);

  @override
  String toString() {
    return 'WorkflowTaskModel(workflow: $workflow, organization: $organization, project: $project, locale: $locale, status: $status, actions: $actions, currentAction: $currentAction, nextAction: $nextAction, error: $error, log: $log, prompt: $prompt, materials: $materials, results: $results, assets: $assets, search: $search, usage: $usage, startTime: $startTime, finishedTime: $finishedTime, createdTime: $createdTime, updatedTime: $updatedTime)';
  }
}

/// @nodoc
abstract mixin class $WorkflowTaskModelCopyWith<$Res> {
  factory $WorkflowTaskModelCopyWith(
          WorkflowTaskModel value, $Res Function(WorkflowTaskModel) _then) =
      _$WorkflowTaskModelCopyWithImpl;
  @useResult
  $Res call(
      {@refParam WorkflowWorkflowModelRef workflow,
      @refParam WorkflowOrganizationModelRef organization,
      @refParam WorkflowProjectModelRef project,
      ModelLocale? locale,
      WorkflowTaskStatus status,
      @jsonParam List<WorkflowActionCommandValue> actions,
      @refParam WorkflowActionModelRef? currentAction,
      @jsonParam WorkflowActionCommandValue? nextAction,
      Map<String, dynamic>? error,
      @jsonParam List<WorkflowTaskLogValue> log,
      String? prompt,
      Map<String, dynamic>? materials,
      Map<String, dynamic>? results,
      Map<String, dynamic>? assets,
      @searchParam String? search,
      double usage,
      ModelTimestamp? startTime,
      ModelTimestamp? finishedTime,
      ModelTimestamp createdTime,
      ModelTimestamp updatedTime});

  $WorkflowActionCommandValueCopyWith<$Res>? get nextAction;
}

/// @nodoc
class _$WorkflowTaskModelCopyWithImpl<$Res>
    implements $WorkflowTaskModelCopyWith<$Res> {
  _$WorkflowTaskModelCopyWithImpl(this._self, this._then);

  final WorkflowTaskModel _self;
  final $Res Function(WorkflowTaskModel) _then;

  /// Create a copy of WorkflowTaskModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workflow = freezed,
    Object? organization = freezed,
    Object? project = freezed,
    Object? locale = freezed,
    Object? status = null,
    Object? actions = null,
    Object? currentAction = freezed,
    Object? nextAction = freezed,
    Object? error = freezed,
    Object? log = null,
    Object? prompt = freezed,
    Object? materials = freezed,
    Object? results = freezed,
    Object? assets = freezed,
    Object? search = freezed,
    Object? usage = null,
    Object? startTime = freezed,
    Object? finishedTime = freezed,
    Object? createdTime = null,
    Object? updatedTime = null,
  }) {
    return _then(_self.copyWith(
      workflow: freezed == workflow
          ? _self.workflow
          : workflow // ignore: cast_nullable_to_non_nullable
              as WorkflowWorkflowModelRef,
      organization: freezed == organization
          ? _self.organization
          : organization // ignore: cast_nullable_to_non_nullable
              as WorkflowOrganizationModelRef,
      project: freezed == project
          ? _self.project
          : project // ignore: cast_nullable_to_non_nullable
              as WorkflowProjectModelRef,
      locale: freezed == locale
          ? _self.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as ModelLocale?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as WorkflowTaskStatus,
      actions: null == actions
          ? _self.actions
          : actions // ignore: cast_nullable_to_non_nullable
              as List<WorkflowActionCommandValue>,
      currentAction: freezed == currentAction
          ? _self.currentAction
          : currentAction // ignore: cast_nullable_to_non_nullable
              as WorkflowActionModelRef?,
      nextAction: freezed == nextAction
          ? _self.nextAction
          : nextAction // ignore: cast_nullable_to_non_nullable
              as WorkflowActionCommandValue?,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      log: null == log
          ? _self.log
          : log // ignore: cast_nullable_to_non_nullable
              as List<WorkflowTaskLogValue>,
      prompt: freezed == prompt
          ? _self.prompt
          : prompt // ignore: cast_nullable_to_non_nullable
              as String?,
      materials: freezed == materials
          ? _self.materials
          : materials // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      results: freezed == results
          ? _self.results
          : results // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      assets: freezed == assets
          ? _self.assets
          : assets // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      search: freezed == search
          ? _self.search
          : search // ignore: cast_nullable_to_non_nullable
              as String?,
      usage: null == usage
          ? _self.usage
          : usage // ignore: cast_nullable_to_non_nullable
              as double,
      startTime: freezed == startTime
          ? _self.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp?,
      finishedTime: freezed == finishedTime
          ? _self.finishedTime
          : finishedTime // ignore: cast_nullable_to_non_nullable
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

  /// Create a copy of WorkflowTaskModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WorkflowActionCommandValueCopyWith<$Res>? get nextAction {
    if (_self.nextAction == null) {
      return null;
    }

    return $WorkflowActionCommandValueCopyWith<$Res>(_self.nextAction!,
        (value) {
      return _then(_self.copyWith(nextAction: value));
    });
  }
}

/// Adds pattern-matching-related methods to [WorkflowTaskModel].
extension WorkflowTaskModelPatterns on WorkflowTaskModel {
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
    TResult Function(_WorkflowTaskModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WorkflowTaskModel() when $default != null:
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
    TResult Function(_WorkflowTaskModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowTaskModel():
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
    TResult? Function(_WorkflowTaskModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowTaskModel() when $default != null:
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
            @refParam WorkflowWorkflowModelRef workflow,
            @refParam WorkflowOrganizationModelRef organization,
            @refParam WorkflowProjectModelRef project,
            ModelLocale? locale,
            WorkflowTaskStatus status,
            @jsonParam List<WorkflowActionCommandValue> actions,
            @refParam WorkflowActionModelRef? currentAction,
            @jsonParam WorkflowActionCommandValue? nextAction,
            Map<String, dynamic>? error,
            @jsonParam List<WorkflowTaskLogValue> log,
            String? prompt,
            Map<String, dynamic>? materials,
            Map<String, dynamic>? results,
            Map<String, dynamic>? assets,
            @searchParam String? search,
            double usage,
            ModelTimestamp? startTime,
            ModelTimestamp? finishedTime,
            ModelTimestamp createdTime,
            ModelTimestamp updatedTime)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WorkflowTaskModel() when $default != null:
        return $default(
            _that.workflow,
            _that.organization,
            _that.project,
            _that.locale,
            _that.status,
            _that.actions,
            _that.currentAction,
            _that.nextAction,
            _that.error,
            _that.log,
            _that.prompt,
            _that.materials,
            _that.results,
            _that.assets,
            _that.search,
            _that.usage,
            _that.startTime,
            _that.finishedTime,
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
            @refParam WorkflowWorkflowModelRef workflow,
            @refParam WorkflowOrganizationModelRef organization,
            @refParam WorkflowProjectModelRef project,
            ModelLocale? locale,
            WorkflowTaskStatus status,
            @jsonParam List<WorkflowActionCommandValue> actions,
            @refParam WorkflowActionModelRef? currentAction,
            @jsonParam WorkflowActionCommandValue? nextAction,
            Map<String, dynamic>? error,
            @jsonParam List<WorkflowTaskLogValue> log,
            String? prompt,
            Map<String, dynamic>? materials,
            Map<String, dynamic>? results,
            Map<String, dynamic>? assets,
            @searchParam String? search,
            double usage,
            ModelTimestamp? startTime,
            ModelTimestamp? finishedTime,
            ModelTimestamp createdTime,
            ModelTimestamp updatedTime)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowTaskModel():
        return $default(
            _that.workflow,
            _that.organization,
            _that.project,
            _that.locale,
            _that.status,
            _that.actions,
            _that.currentAction,
            _that.nextAction,
            _that.error,
            _that.log,
            _that.prompt,
            _that.materials,
            _that.results,
            _that.assets,
            _that.search,
            _that.usage,
            _that.startTime,
            _that.finishedTime,
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
            @refParam WorkflowWorkflowModelRef workflow,
            @refParam WorkflowOrganizationModelRef organization,
            @refParam WorkflowProjectModelRef project,
            ModelLocale? locale,
            WorkflowTaskStatus status,
            @jsonParam List<WorkflowActionCommandValue> actions,
            @refParam WorkflowActionModelRef? currentAction,
            @jsonParam WorkflowActionCommandValue? nextAction,
            Map<String, dynamic>? error,
            @jsonParam List<WorkflowTaskLogValue> log,
            String? prompt,
            Map<String, dynamic>? materials,
            Map<String, dynamic>? results,
            Map<String, dynamic>? assets,
            @searchParam String? search,
            double usage,
            ModelTimestamp? startTime,
            ModelTimestamp? finishedTime,
            ModelTimestamp createdTime,
            ModelTimestamp updatedTime)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowTaskModel() when $default != null:
        return $default(
            _that.workflow,
            _that.organization,
            _that.project,
            _that.locale,
            _that.status,
            _that.actions,
            _that.currentAction,
            _that.nextAction,
            _that.error,
            _that.log,
            _that.prompt,
            _that.materials,
            _that.results,
            _that.assets,
            _that.search,
            _that.usage,
            _that.startTime,
            _that.finishedTime,
            _that.createdTime,
            _that.updatedTime);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _WorkflowTaskModel extends WorkflowTaskModel {
  const _WorkflowTaskModel(
      {@refParam this.workflow,
      @refParam this.organization,
      @refParam this.project,
      this.locale,
      this.status = WorkflowTaskStatus.waiting,
      @jsonParam final List<WorkflowActionCommandValue> actions = const [],
      @refParam this.currentAction,
      @jsonParam this.nextAction,
      final Map<String, dynamic>? error,
      @jsonParam final List<WorkflowTaskLogValue> log = const [],
      this.prompt,
      final Map<String, dynamic>? materials,
      final Map<String, dynamic>? results,
      final Map<String, dynamic>? assets,
      @searchParam this.search,
      this.usage = 0,
      this.startTime,
      this.finishedTime,
      this.createdTime = const ModelTimestamp.now(),
      this.updatedTime = const ModelTimestamp.now()})
      : _actions = actions,
        _error = error,
        _log = log,
        _materials = materials,
        _results = results,
        _assets = assets,
        super._();
  factory _WorkflowTaskModel.fromJson(Map<String, dynamic> json) =>
      _$WorkflowTaskModelFromJson(json);

  @override
  @refParam
  final WorkflowWorkflowModelRef workflow;
  @override
  @refParam
  final WorkflowOrganizationModelRef organization;
  @override
  @refParam
  final WorkflowProjectModelRef project;
  @override
  final ModelLocale? locale;
  @override
  @JsonKey()
  final WorkflowTaskStatus status;
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
  @refParam
  final WorkflowActionModelRef? currentAction;
  @override
  @jsonParam
  final WorkflowActionCommandValue? nextAction;
  final Map<String, dynamic>? _error;
  @override
  Map<String, dynamic>? get error {
    final value = _error;
    if (value == null) return null;
    if (_error is EqualUnmodifiableMapView) return _error;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<WorkflowTaskLogValue> _log;
  @override
  @JsonKey()
  @jsonParam
  List<WorkflowTaskLogValue> get log {
    if (_log is EqualUnmodifiableListView) return _log;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_log);
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

  final Map<String, dynamic>? _results;
  @override
  Map<String, dynamic>? get results {
    final value = _results;
    if (value == null) return null;
    if (_results is EqualUnmodifiableMapView) return _results;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _assets;
  @override
  Map<String, dynamic>? get assets {
    final value = _assets;
    if (value == null) return null;
    if (_assets is EqualUnmodifiableMapView) return _assets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @searchParam
  final String? search;
  @override
  @JsonKey()
  final double usage;
  @override
  final ModelTimestamp? startTime;
  @override
  final ModelTimestamp? finishedTime;
  @override
  @JsonKey()
  final ModelTimestamp createdTime;
  @override
  @JsonKey()
  final ModelTimestamp updatedTime;

  /// Create a copy of WorkflowTaskModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WorkflowTaskModelCopyWith<_WorkflowTaskModel> get copyWith =>
      __$WorkflowTaskModelCopyWithImpl<_WorkflowTaskModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WorkflowTaskModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WorkflowTaskModel &&
            (identical(other.workflow, workflow) ||
                other.workflow == workflow) &&
            (identical(other.organization, organization) ||
                other.organization == organization) &&
            (identical(other.project, project) || other.project == project) &&
            (identical(other.locale, locale) || other.locale == locale) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._actions, _actions) &&
            (identical(other.currentAction, currentAction) ||
                other.currentAction == currentAction) &&
            (identical(other.nextAction, nextAction) ||
                other.nextAction == nextAction) &&
            const DeepCollectionEquality().equals(other._error, _error) &&
            const DeepCollectionEquality().equals(other._log, _log) &&
            (identical(other.prompt, prompt) || other.prompt == prompt) &&
            const DeepCollectionEquality()
                .equals(other._materials, _materials) &&
            const DeepCollectionEquality().equals(other._results, _results) &&
            const DeepCollectionEquality().equals(other._assets, _assets) &&
            (identical(other.search, search) || other.search == search) &&
            (identical(other.usage, usage) || other.usage == usage) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.finishedTime, finishedTime) ||
                other.finishedTime == finishedTime) &&
            (identical(other.createdTime, createdTime) ||
                other.createdTime == createdTime) &&
            (identical(other.updatedTime, updatedTime) ||
                other.updatedTime == updatedTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        workflow,
        organization,
        project,
        locale,
        status,
        const DeepCollectionEquality().hash(_actions),
        currentAction,
        nextAction,
        const DeepCollectionEquality().hash(_error),
        const DeepCollectionEquality().hash(_log),
        prompt,
        const DeepCollectionEquality().hash(_materials),
        const DeepCollectionEquality().hash(_results),
        const DeepCollectionEquality().hash(_assets),
        search,
        usage,
        startTime,
        finishedTime,
        createdTime,
        updatedTime
      ]);

  @override
  String toString() {
    return 'WorkflowTaskModel(workflow: $workflow, organization: $organization, project: $project, locale: $locale, status: $status, actions: $actions, currentAction: $currentAction, nextAction: $nextAction, error: $error, log: $log, prompt: $prompt, materials: $materials, results: $results, assets: $assets, search: $search, usage: $usage, startTime: $startTime, finishedTime: $finishedTime, createdTime: $createdTime, updatedTime: $updatedTime)';
  }
}

/// @nodoc
abstract mixin class _$WorkflowTaskModelCopyWith<$Res>
    implements $WorkflowTaskModelCopyWith<$Res> {
  factory _$WorkflowTaskModelCopyWith(
          _WorkflowTaskModel value, $Res Function(_WorkflowTaskModel) _then) =
      __$WorkflowTaskModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@refParam WorkflowWorkflowModelRef workflow,
      @refParam WorkflowOrganizationModelRef organization,
      @refParam WorkflowProjectModelRef project,
      ModelLocale? locale,
      WorkflowTaskStatus status,
      @jsonParam List<WorkflowActionCommandValue> actions,
      @refParam WorkflowActionModelRef? currentAction,
      @jsonParam WorkflowActionCommandValue? nextAction,
      Map<String, dynamic>? error,
      @jsonParam List<WorkflowTaskLogValue> log,
      String? prompt,
      Map<String, dynamic>? materials,
      Map<String, dynamic>? results,
      Map<String, dynamic>? assets,
      @searchParam String? search,
      double usage,
      ModelTimestamp? startTime,
      ModelTimestamp? finishedTime,
      ModelTimestamp createdTime,
      ModelTimestamp updatedTime});

  @override
  $WorkflowActionCommandValueCopyWith<$Res>? get nextAction;
}

/// @nodoc
class __$WorkflowTaskModelCopyWithImpl<$Res>
    implements _$WorkflowTaskModelCopyWith<$Res> {
  __$WorkflowTaskModelCopyWithImpl(this._self, this._then);

  final _WorkflowTaskModel _self;
  final $Res Function(_WorkflowTaskModel) _then;

  /// Create a copy of WorkflowTaskModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? workflow = freezed,
    Object? organization = freezed,
    Object? project = freezed,
    Object? locale = freezed,
    Object? status = null,
    Object? actions = null,
    Object? currentAction = freezed,
    Object? nextAction = freezed,
    Object? error = freezed,
    Object? log = null,
    Object? prompt = freezed,
    Object? materials = freezed,
    Object? results = freezed,
    Object? assets = freezed,
    Object? search = freezed,
    Object? usage = null,
    Object? startTime = freezed,
    Object? finishedTime = freezed,
    Object? createdTime = null,
    Object? updatedTime = null,
  }) {
    return _then(_WorkflowTaskModel(
      workflow: freezed == workflow
          ? _self.workflow
          : workflow // ignore: cast_nullable_to_non_nullable
              as WorkflowWorkflowModelRef,
      organization: freezed == organization
          ? _self.organization
          : organization // ignore: cast_nullable_to_non_nullable
              as WorkflowOrganizationModelRef,
      project: freezed == project
          ? _self.project
          : project // ignore: cast_nullable_to_non_nullable
              as WorkflowProjectModelRef,
      locale: freezed == locale
          ? _self.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as ModelLocale?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as WorkflowTaskStatus,
      actions: null == actions
          ? _self._actions
          : actions // ignore: cast_nullable_to_non_nullable
              as List<WorkflowActionCommandValue>,
      currentAction: freezed == currentAction
          ? _self.currentAction
          : currentAction // ignore: cast_nullable_to_non_nullable
              as WorkflowActionModelRef?,
      nextAction: freezed == nextAction
          ? _self.nextAction
          : nextAction // ignore: cast_nullable_to_non_nullable
              as WorkflowActionCommandValue?,
      error: freezed == error
          ? _self._error
          : error // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      log: null == log
          ? _self._log
          : log // ignore: cast_nullable_to_non_nullable
              as List<WorkflowTaskLogValue>,
      prompt: freezed == prompt
          ? _self.prompt
          : prompt // ignore: cast_nullable_to_non_nullable
              as String?,
      materials: freezed == materials
          ? _self._materials
          : materials // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      results: freezed == results
          ? _self._results
          : results // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      assets: freezed == assets
          ? _self._assets
          : assets // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      search: freezed == search
          ? _self.search
          : search // ignore: cast_nullable_to_non_nullable
              as String?,
      usage: null == usage
          ? _self.usage
          : usage // ignore: cast_nullable_to_non_nullable
              as double,
      startTime: freezed == startTime
          ? _self.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp?,
      finishedTime: freezed == finishedTime
          ? _self.finishedTime
          : finishedTime // ignore: cast_nullable_to_non_nullable
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

  /// Create a copy of WorkflowTaskModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WorkflowActionCommandValueCopyWith<$Res>? get nextAction {
    if (_self.nextAction == null) {
      return null;
    }

    return $WorkflowActionCommandValueCopyWith<$Res>(_self.nextAction!,
        (value) {
      return _then(_self.copyWith(nextAction: value));
    });
  }
}

// dart format on
