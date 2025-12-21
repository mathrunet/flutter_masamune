// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workflow_action.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkflowActionModel {
  @jsonParam
  WorkflowActionCommandValue get command;
  @refParam
  WorkflowTaskModelRef get task;
  @refParam
  WorkflowWorkflowModelRef get workflow;
  @refParam
  WorkflowOrganizationModelRef get organization;
  @refParam
  WorkflowProjectModelRef get project;
  WorkflowTaskStatus get status;
  ModelLocale? get locale;
  Map<String, dynamic>? get error;
  String? get prompt;
  @jsonParam
  List<WorkflowTaskLogValue> get log;
  Map<String, dynamic>? get materials;
  Map<String, dynamic>? get results;
  Map<String, dynamic>? get assets;
  double get usage;
  String? get search;
  String? get token;
  ModelTimestamp? get tokenExpiredTime;
  ModelTimestamp? get startTime;
  ModelTimestamp? get finishedTime;
  ModelTimestamp get createdTime;
  ModelTimestamp get updatedTime;

  /// Create a copy of WorkflowActionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WorkflowActionModelCopyWith<WorkflowActionModel> get copyWith =>
      _$WorkflowActionModelCopyWithImpl<WorkflowActionModel>(
          this as WorkflowActionModel, _$identity);

  /// Serializes this WorkflowActionModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WorkflowActionModel &&
            (identical(other.command, command) || other.command == command) &&
            (identical(other.task, task) || other.task == task) &&
            (identical(other.workflow, workflow) ||
                other.workflow == workflow) &&
            (identical(other.organization, organization) ||
                other.organization == organization) &&
            (identical(other.project, project) || other.project == project) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.locale, locale) || other.locale == locale) &&
            const DeepCollectionEquality().equals(other.error, error) &&
            (identical(other.prompt, prompt) || other.prompt == prompt) &&
            const DeepCollectionEquality().equals(other.log, log) &&
            const DeepCollectionEquality().equals(other.materials, materials) &&
            const DeepCollectionEquality().equals(other.results, results) &&
            const DeepCollectionEquality().equals(other.assets, assets) &&
            (identical(other.usage, usage) || other.usage == usage) &&
            (identical(other.search, search) || other.search == search) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.tokenExpiredTime, tokenExpiredTime) ||
                other.tokenExpiredTime == tokenExpiredTime) &&
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
        command,
        task,
        workflow,
        organization,
        project,
        status,
        locale,
        const DeepCollectionEquality().hash(error),
        prompt,
        const DeepCollectionEquality().hash(log),
        const DeepCollectionEquality().hash(materials),
        const DeepCollectionEquality().hash(results),
        const DeepCollectionEquality().hash(assets),
        usage,
        search,
        token,
        tokenExpiredTime,
        startTime,
        finishedTime,
        createdTime,
        updatedTime
      ]);

  @override
  String toString() {
    return 'WorkflowActionModel(command: $command, task: $task, workflow: $workflow, organization: $organization, project: $project, status: $status, locale: $locale, error: $error, prompt: $prompt, log: $log, materials: $materials, results: $results, assets: $assets, usage: $usage, search: $search, token: $token, tokenExpiredTime: $tokenExpiredTime, startTime: $startTime, finishedTime: $finishedTime, createdTime: $createdTime, updatedTime: $updatedTime)';
  }
}

/// @nodoc
abstract mixin class $WorkflowActionModelCopyWith<$Res> {
  factory $WorkflowActionModelCopyWith(
          WorkflowActionModel value, $Res Function(WorkflowActionModel) _then) =
      _$WorkflowActionModelCopyWithImpl;
  @useResult
  $Res call(
      {@jsonParam WorkflowActionCommandValue command,
      @refParam WorkflowTaskModelRef task,
      @refParam WorkflowWorkflowModelRef workflow,
      @refParam WorkflowOrganizationModelRef organization,
      @refParam WorkflowProjectModelRef project,
      WorkflowTaskStatus status,
      ModelLocale? locale,
      Map<String, dynamic>? error,
      String? prompt,
      @jsonParam List<WorkflowTaskLogValue> log,
      Map<String, dynamic>? materials,
      Map<String, dynamic>? results,
      Map<String, dynamic>? assets,
      double usage,
      String? search,
      String? token,
      ModelTimestamp? tokenExpiredTime,
      ModelTimestamp? startTime,
      ModelTimestamp? finishedTime,
      ModelTimestamp createdTime,
      ModelTimestamp updatedTime});

  $WorkflowActionCommandValueCopyWith<$Res> get command;
}

/// @nodoc
class _$WorkflowActionModelCopyWithImpl<$Res>
    implements $WorkflowActionModelCopyWith<$Res> {
  _$WorkflowActionModelCopyWithImpl(this._self, this._then);

  final WorkflowActionModel _self;
  final $Res Function(WorkflowActionModel) _then;

  /// Create a copy of WorkflowActionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? command = null,
    Object? task = freezed,
    Object? workflow = freezed,
    Object? organization = freezed,
    Object? project = freezed,
    Object? status = null,
    Object? locale = freezed,
    Object? error = freezed,
    Object? prompt = freezed,
    Object? log = null,
    Object? materials = freezed,
    Object? results = freezed,
    Object? assets = freezed,
    Object? usage = null,
    Object? search = freezed,
    Object? token = freezed,
    Object? tokenExpiredTime = freezed,
    Object? startTime = freezed,
    Object? finishedTime = freezed,
    Object? createdTime = null,
    Object? updatedTime = null,
  }) {
    return _then(_self.copyWith(
      command: null == command
          ? _self.command
          : command // ignore: cast_nullable_to_non_nullable
              as WorkflowActionCommandValue,
      task: freezed == task
          ? _self.task
          : task // ignore: cast_nullable_to_non_nullable
              as WorkflowTaskModelRef,
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
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as WorkflowTaskStatus,
      locale: freezed == locale
          ? _self.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as ModelLocale?,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      prompt: freezed == prompt
          ? _self.prompt
          : prompt // ignore: cast_nullable_to_non_nullable
              as String?,
      log: null == log
          ? _self.log
          : log // ignore: cast_nullable_to_non_nullable
              as List<WorkflowTaskLogValue>,
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
      usage: null == usage
          ? _self.usage
          : usage // ignore: cast_nullable_to_non_nullable
              as double,
      search: freezed == search
          ? _self.search
          : search // ignore: cast_nullable_to_non_nullable
              as String?,
      token: freezed == token
          ? _self.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
      tokenExpiredTime: freezed == tokenExpiredTime
          ? _self.tokenExpiredTime
          : tokenExpiredTime // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp?,
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

  /// Create a copy of WorkflowActionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WorkflowActionCommandValueCopyWith<$Res> get command {
    return $WorkflowActionCommandValueCopyWith<$Res>(_self.command, (value) {
      return _then(_self.copyWith(command: value));
    });
  }
}

/// Adds pattern-matching-related methods to [WorkflowActionModel].
extension WorkflowActionModelPatterns on WorkflowActionModel {
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
    TResult Function(_WorkflowActionModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WorkflowActionModel() when $default != null:
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
    TResult Function(_WorkflowActionModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowActionModel():
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
    TResult? Function(_WorkflowActionModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowActionModel() when $default != null:
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
            @jsonParam WorkflowActionCommandValue command,
            @refParam WorkflowTaskModelRef task,
            @refParam WorkflowWorkflowModelRef workflow,
            @refParam WorkflowOrganizationModelRef organization,
            @refParam WorkflowProjectModelRef project,
            WorkflowTaskStatus status,
            ModelLocale? locale,
            Map<String, dynamic>? error,
            String? prompt,
            @jsonParam List<WorkflowTaskLogValue> log,
            Map<String, dynamic>? materials,
            Map<String, dynamic>? results,
            Map<String, dynamic>? assets,
            double usage,
            String? search,
            String? token,
            ModelTimestamp? tokenExpiredTime,
            ModelTimestamp? startTime,
            ModelTimestamp? finishedTime,
            ModelTimestamp createdTime,
            ModelTimestamp updatedTime)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WorkflowActionModel() when $default != null:
        return $default(
            _that.command,
            _that.task,
            _that.workflow,
            _that.organization,
            _that.project,
            _that.status,
            _that.locale,
            _that.error,
            _that.prompt,
            _that.log,
            _that.materials,
            _that.results,
            _that.assets,
            _that.usage,
            _that.search,
            _that.token,
            _that.tokenExpiredTime,
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
            @jsonParam WorkflowActionCommandValue command,
            @refParam WorkflowTaskModelRef task,
            @refParam WorkflowWorkflowModelRef workflow,
            @refParam WorkflowOrganizationModelRef organization,
            @refParam WorkflowProjectModelRef project,
            WorkflowTaskStatus status,
            ModelLocale? locale,
            Map<String, dynamic>? error,
            String? prompt,
            @jsonParam List<WorkflowTaskLogValue> log,
            Map<String, dynamic>? materials,
            Map<String, dynamic>? results,
            Map<String, dynamic>? assets,
            double usage,
            String? search,
            String? token,
            ModelTimestamp? tokenExpiredTime,
            ModelTimestamp? startTime,
            ModelTimestamp? finishedTime,
            ModelTimestamp createdTime,
            ModelTimestamp updatedTime)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowActionModel():
        return $default(
            _that.command,
            _that.task,
            _that.workflow,
            _that.organization,
            _that.project,
            _that.status,
            _that.locale,
            _that.error,
            _that.prompt,
            _that.log,
            _that.materials,
            _that.results,
            _that.assets,
            _that.usage,
            _that.search,
            _that.token,
            _that.tokenExpiredTime,
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
            @jsonParam WorkflowActionCommandValue command,
            @refParam WorkflowTaskModelRef task,
            @refParam WorkflowWorkflowModelRef workflow,
            @refParam WorkflowOrganizationModelRef organization,
            @refParam WorkflowProjectModelRef project,
            WorkflowTaskStatus status,
            ModelLocale? locale,
            Map<String, dynamic>? error,
            String? prompt,
            @jsonParam List<WorkflowTaskLogValue> log,
            Map<String, dynamic>? materials,
            Map<String, dynamic>? results,
            Map<String, dynamic>? assets,
            double usage,
            String? search,
            String? token,
            ModelTimestamp? tokenExpiredTime,
            ModelTimestamp? startTime,
            ModelTimestamp? finishedTime,
            ModelTimestamp createdTime,
            ModelTimestamp updatedTime)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowActionModel() when $default != null:
        return $default(
            _that.command,
            _that.task,
            _that.workflow,
            _that.organization,
            _that.project,
            _that.status,
            _that.locale,
            _that.error,
            _that.prompt,
            _that.log,
            _that.materials,
            _that.results,
            _that.assets,
            _that.usage,
            _that.search,
            _that.token,
            _that.tokenExpiredTime,
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
class _WorkflowActionModel extends WorkflowActionModel {
  const _WorkflowActionModel(
      {@jsonParam required this.command,
      @refParam this.task,
      @refParam this.workflow,
      @refParam this.organization,
      @refParam this.project,
      this.status = WorkflowTaskStatus.waiting,
      this.locale,
      final Map<String, dynamic>? error,
      this.prompt,
      @jsonParam final List<WorkflowTaskLogValue> log = const [],
      final Map<String, dynamic>? materials,
      final Map<String, dynamic>? results,
      final Map<String, dynamic>? assets,
      this.usage = 0,
      this.search,
      this.token,
      this.tokenExpiredTime,
      this.startTime,
      this.finishedTime,
      this.createdTime = const ModelTimestamp.now(),
      this.updatedTime = const ModelTimestamp.now()})
      : _error = error,
        _log = log,
        _materials = materials,
        _results = results,
        _assets = assets,
        super._();
  factory _WorkflowActionModel.fromJson(Map<String, dynamic> json) =>
      _$WorkflowActionModelFromJson(json);

  @override
  @jsonParam
  final WorkflowActionCommandValue command;
  @override
  @refParam
  final WorkflowTaskModelRef task;
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
  @JsonKey()
  final WorkflowTaskStatus status;
  @override
  final ModelLocale? locale;
  final Map<String, dynamic>? _error;
  @override
  Map<String, dynamic>? get error {
    final value = _error;
    if (value == null) return null;
    if (_error is EqualUnmodifiableMapView) return _error;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? prompt;
  final List<WorkflowTaskLogValue> _log;
  @override
  @JsonKey()
  @jsonParam
  List<WorkflowTaskLogValue> get log {
    if (_log is EqualUnmodifiableListView) return _log;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_log);
  }

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
  @JsonKey()
  final double usage;
  @override
  final String? search;
  @override
  final String? token;
  @override
  final ModelTimestamp? tokenExpiredTime;
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

  /// Create a copy of WorkflowActionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WorkflowActionModelCopyWith<_WorkflowActionModel> get copyWith =>
      __$WorkflowActionModelCopyWithImpl<_WorkflowActionModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WorkflowActionModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WorkflowActionModel &&
            (identical(other.command, command) || other.command == command) &&
            (identical(other.task, task) || other.task == task) &&
            (identical(other.workflow, workflow) ||
                other.workflow == workflow) &&
            (identical(other.organization, organization) ||
                other.organization == organization) &&
            (identical(other.project, project) || other.project == project) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.locale, locale) || other.locale == locale) &&
            const DeepCollectionEquality().equals(other._error, _error) &&
            (identical(other.prompt, prompt) || other.prompt == prompt) &&
            const DeepCollectionEquality().equals(other._log, _log) &&
            const DeepCollectionEquality()
                .equals(other._materials, _materials) &&
            const DeepCollectionEquality().equals(other._results, _results) &&
            const DeepCollectionEquality().equals(other._assets, _assets) &&
            (identical(other.usage, usage) || other.usage == usage) &&
            (identical(other.search, search) || other.search == search) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.tokenExpiredTime, tokenExpiredTime) ||
                other.tokenExpiredTime == tokenExpiredTime) &&
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
        command,
        task,
        workflow,
        organization,
        project,
        status,
        locale,
        const DeepCollectionEquality().hash(_error),
        prompt,
        const DeepCollectionEquality().hash(_log),
        const DeepCollectionEquality().hash(_materials),
        const DeepCollectionEquality().hash(_results),
        const DeepCollectionEquality().hash(_assets),
        usage,
        search,
        token,
        tokenExpiredTime,
        startTime,
        finishedTime,
        createdTime,
        updatedTime
      ]);

  @override
  String toString() {
    return 'WorkflowActionModel(command: $command, task: $task, workflow: $workflow, organization: $organization, project: $project, status: $status, locale: $locale, error: $error, prompt: $prompt, log: $log, materials: $materials, results: $results, assets: $assets, usage: $usage, search: $search, token: $token, tokenExpiredTime: $tokenExpiredTime, startTime: $startTime, finishedTime: $finishedTime, createdTime: $createdTime, updatedTime: $updatedTime)';
  }
}

/// @nodoc
abstract mixin class _$WorkflowActionModelCopyWith<$Res>
    implements $WorkflowActionModelCopyWith<$Res> {
  factory _$WorkflowActionModelCopyWith(_WorkflowActionModel value,
          $Res Function(_WorkflowActionModel) _then) =
      __$WorkflowActionModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@jsonParam WorkflowActionCommandValue command,
      @refParam WorkflowTaskModelRef task,
      @refParam WorkflowWorkflowModelRef workflow,
      @refParam WorkflowOrganizationModelRef organization,
      @refParam WorkflowProjectModelRef project,
      WorkflowTaskStatus status,
      ModelLocale? locale,
      Map<String, dynamic>? error,
      String? prompt,
      @jsonParam List<WorkflowTaskLogValue> log,
      Map<String, dynamic>? materials,
      Map<String, dynamic>? results,
      Map<String, dynamic>? assets,
      double usage,
      String? search,
      String? token,
      ModelTimestamp? tokenExpiredTime,
      ModelTimestamp? startTime,
      ModelTimestamp? finishedTime,
      ModelTimestamp createdTime,
      ModelTimestamp updatedTime});

  @override
  $WorkflowActionCommandValueCopyWith<$Res> get command;
}

/// @nodoc
class __$WorkflowActionModelCopyWithImpl<$Res>
    implements _$WorkflowActionModelCopyWith<$Res> {
  __$WorkflowActionModelCopyWithImpl(this._self, this._then);

  final _WorkflowActionModel _self;
  final $Res Function(_WorkflowActionModel) _then;

  /// Create a copy of WorkflowActionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? command = null,
    Object? task = freezed,
    Object? workflow = freezed,
    Object? organization = freezed,
    Object? project = freezed,
    Object? status = null,
    Object? locale = freezed,
    Object? error = freezed,
    Object? prompt = freezed,
    Object? log = null,
    Object? materials = freezed,
    Object? results = freezed,
    Object? assets = freezed,
    Object? usage = null,
    Object? search = freezed,
    Object? token = freezed,
    Object? tokenExpiredTime = freezed,
    Object? startTime = freezed,
    Object? finishedTime = freezed,
    Object? createdTime = null,
    Object? updatedTime = null,
  }) {
    return _then(_WorkflowActionModel(
      command: null == command
          ? _self.command
          : command // ignore: cast_nullable_to_non_nullable
              as WorkflowActionCommandValue,
      task: freezed == task
          ? _self.task
          : task // ignore: cast_nullable_to_non_nullable
              as WorkflowTaskModelRef,
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
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as WorkflowTaskStatus,
      locale: freezed == locale
          ? _self.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as ModelLocale?,
      error: freezed == error
          ? _self._error
          : error // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      prompt: freezed == prompt
          ? _self.prompt
          : prompt // ignore: cast_nullable_to_non_nullable
              as String?,
      log: null == log
          ? _self._log
          : log // ignore: cast_nullable_to_non_nullable
              as List<WorkflowTaskLogValue>,
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
      usage: null == usage
          ? _self.usage
          : usage // ignore: cast_nullable_to_non_nullable
              as double,
      search: freezed == search
          ? _self.search
          : search // ignore: cast_nullable_to_non_nullable
              as String?,
      token: freezed == token
          ? _self.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
      tokenExpiredTime: freezed == tokenExpiredTime
          ? _self.tokenExpiredTime
          : tokenExpiredTime // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp?,
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

  /// Create a copy of WorkflowActionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WorkflowActionCommandValueCopyWith<$Res> get command {
    return $WorkflowActionCommandValueCopyWith<$Res>(_self.command, (value) {
      return _then(_self.copyWith(command: value));
    });
  }
}

// dart format on
