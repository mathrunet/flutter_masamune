// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workflow_certificate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkflowCertificateModel {
  @refParam
  WorkflowOrganizationModelRef get organization;
  String? get token;
  List<String> get scope;
  ModelTimestamp? get expiredTime;
  ModelTimestamp get createdTime;
  ModelTimestamp get updatedTime;

  /// Create a copy of WorkflowCertificateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WorkflowCertificateModelCopyWith<WorkflowCertificateModel> get copyWith =>
      _$WorkflowCertificateModelCopyWithImpl<WorkflowCertificateModel>(
          this as WorkflowCertificateModel, _$identity);

  /// Serializes this WorkflowCertificateModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WorkflowCertificateModel &&
            (identical(other.organization, organization) ||
                other.organization == organization) &&
            (identical(other.token, token) || other.token == token) &&
            const DeepCollectionEquality().equals(other.scope, scope) &&
            (identical(other.expiredTime, expiredTime) ||
                other.expiredTime == expiredTime) &&
            (identical(other.createdTime, createdTime) ||
                other.createdTime == createdTime) &&
            (identical(other.updatedTime, updatedTime) ||
                other.updatedTime == updatedTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      organization,
      token,
      const DeepCollectionEquality().hash(scope),
      expiredTime,
      createdTime,
      updatedTime);

  @override
  String toString() {
    return 'WorkflowCertificateModel(organization: $organization, token: $token, scope: $scope, expiredTime: $expiredTime, createdTime: $createdTime, updatedTime: $updatedTime)';
  }
}

/// @nodoc
abstract mixin class $WorkflowCertificateModelCopyWith<$Res> {
  factory $WorkflowCertificateModelCopyWith(WorkflowCertificateModel value,
          $Res Function(WorkflowCertificateModel) _then) =
      _$WorkflowCertificateModelCopyWithImpl;
  @useResult
  $Res call(
      {@refParam WorkflowOrganizationModelRef organization,
      String? token,
      List<String> scope,
      ModelTimestamp? expiredTime,
      ModelTimestamp createdTime,
      ModelTimestamp updatedTime});
}

/// @nodoc
class _$WorkflowCertificateModelCopyWithImpl<$Res>
    implements $WorkflowCertificateModelCopyWith<$Res> {
  _$WorkflowCertificateModelCopyWithImpl(this._self, this._then);

  final WorkflowCertificateModel _self;
  final $Res Function(WorkflowCertificateModel) _then;

  /// Create a copy of WorkflowCertificateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? organization = freezed,
    Object? token = freezed,
    Object? scope = null,
    Object? expiredTime = freezed,
    Object? createdTime = null,
    Object? updatedTime = null,
  }) {
    return _then(_self.copyWith(
      organization: freezed == organization
          ? _self.organization
          : organization // ignore: cast_nullable_to_non_nullable
              as WorkflowOrganizationModelRef,
      token: freezed == token
          ? _self.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
      scope: null == scope
          ? _self.scope
          : scope // ignore: cast_nullable_to_non_nullable
              as List<String>,
      expiredTime: freezed == expiredTime
          ? _self.expiredTime
          : expiredTime // ignore: cast_nullable_to_non_nullable
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

/// Adds pattern-matching-related methods to [WorkflowCertificateModel].
extension WorkflowCertificateModelPatterns on WorkflowCertificateModel {
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
    TResult Function(_WorkflowCertificateModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WorkflowCertificateModel() when $default != null:
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
    TResult Function(_WorkflowCertificateModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowCertificateModel():
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
    TResult? Function(_WorkflowCertificateModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowCertificateModel() when $default != null:
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
            String? token,
            List<String> scope,
            ModelTimestamp? expiredTime,
            ModelTimestamp createdTime,
            ModelTimestamp updatedTime)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WorkflowCertificateModel() when $default != null:
        return $default(_that.organization, _that.token, _that.scope,
            _that.expiredTime, _that.createdTime, _that.updatedTime);
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
            String? token,
            List<String> scope,
            ModelTimestamp? expiredTime,
            ModelTimestamp createdTime,
            ModelTimestamp updatedTime)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowCertificateModel():
        return $default(_that.organization, _that.token, _that.scope,
            _that.expiredTime, _that.createdTime, _that.updatedTime);
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
            String? token,
            List<String> scope,
            ModelTimestamp? expiredTime,
            ModelTimestamp createdTime,
            ModelTimestamp updatedTime)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowCertificateModel() when $default != null:
        return $default(_that.organization, _that.token, _that.scope,
            _that.expiredTime, _that.createdTime, _that.updatedTime);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _WorkflowCertificateModel extends WorkflowCertificateModel {
  const _WorkflowCertificateModel(
      {@refParam this.organization,
      this.token,
      final List<String> scope = const [],
      this.expiredTime,
      this.createdTime = const ModelTimestamp.now(),
      this.updatedTime = const ModelTimestamp.now()})
      : _scope = scope,
        super._();
  factory _WorkflowCertificateModel.fromJson(Map<String, dynamic> json) =>
      _$WorkflowCertificateModelFromJson(json);

  @override
  @refParam
  final WorkflowOrganizationModelRef organization;
  @override
  final String? token;
  final List<String> _scope;
  @override
  @JsonKey()
  List<String> get scope {
    if (_scope is EqualUnmodifiableListView) return _scope;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_scope);
  }

  @override
  final ModelTimestamp? expiredTime;
  @override
  @JsonKey()
  final ModelTimestamp createdTime;
  @override
  @JsonKey()
  final ModelTimestamp updatedTime;

  /// Create a copy of WorkflowCertificateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WorkflowCertificateModelCopyWith<_WorkflowCertificateModel> get copyWith =>
      __$WorkflowCertificateModelCopyWithImpl<_WorkflowCertificateModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WorkflowCertificateModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WorkflowCertificateModel &&
            (identical(other.organization, organization) ||
                other.organization == organization) &&
            (identical(other.token, token) || other.token == token) &&
            const DeepCollectionEquality().equals(other._scope, _scope) &&
            (identical(other.expiredTime, expiredTime) ||
                other.expiredTime == expiredTime) &&
            (identical(other.createdTime, createdTime) ||
                other.createdTime == createdTime) &&
            (identical(other.updatedTime, updatedTime) ||
                other.updatedTime == updatedTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      organization,
      token,
      const DeepCollectionEquality().hash(_scope),
      expiredTime,
      createdTime,
      updatedTime);

  @override
  String toString() {
    return 'WorkflowCertificateModel(organization: $organization, token: $token, scope: $scope, expiredTime: $expiredTime, createdTime: $createdTime, updatedTime: $updatedTime)';
  }
}

/// @nodoc
abstract mixin class _$WorkflowCertificateModelCopyWith<$Res>
    implements $WorkflowCertificateModelCopyWith<$Res> {
  factory _$WorkflowCertificateModelCopyWith(_WorkflowCertificateModel value,
          $Res Function(_WorkflowCertificateModel) _then) =
      __$WorkflowCertificateModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@refParam WorkflowOrganizationModelRef organization,
      String? token,
      List<String> scope,
      ModelTimestamp? expiredTime,
      ModelTimestamp createdTime,
      ModelTimestamp updatedTime});
}

/// @nodoc
class __$WorkflowCertificateModelCopyWithImpl<$Res>
    implements _$WorkflowCertificateModelCopyWith<$Res> {
  __$WorkflowCertificateModelCopyWithImpl(this._self, this._then);

  final _WorkflowCertificateModel _self;
  final $Res Function(_WorkflowCertificateModel) _then;

  /// Create a copy of WorkflowCertificateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? organization = freezed,
    Object? token = freezed,
    Object? scope = null,
    Object? expiredTime = freezed,
    Object? createdTime = null,
    Object? updatedTime = null,
  }) {
    return _then(_WorkflowCertificateModel(
      organization: freezed == organization
          ? _self.organization
          : organization // ignore: cast_nullable_to_non_nullable
              as WorkflowOrganizationModelRef,
      token: freezed == token
          ? _self.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
      scope: null == scope
          ? _self._scope
          : scope // ignore: cast_nullable_to_non_nullable
              as List<String>,
      expiredTime: freezed == expiredTime
          ? _self.expiredTime
          : expiredTime // ignore: cast_nullable_to_non_nullable
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
