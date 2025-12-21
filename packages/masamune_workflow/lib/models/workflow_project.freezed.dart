// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workflow_project.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkflowProjectModel {
  String? get name;
  String? get description;
  String? get concept;
  String? get goal;
  String? get target;
  ModelLocale? get locale;
  Map<String, dynamic>? get kpi;
  @refParam
  WorkflowOrganizationModelRef get organization;
  String? get icon;
  String? get googleAccessToken;
  String? get googleRefreshToken;
  String? get googleServiceAccount;
  String? get githubPersonalAccessToken;
  String? get appstoreIssuerId;
  String? get appstoreAuthKeyId;
  String? get appstoreAuthKey;
  ModelTimestamp get createdTime;
  ModelTimestamp get updatedTime;

  /// Create a copy of WorkflowProjectModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WorkflowProjectModelCopyWith<WorkflowProjectModel> get copyWith =>
      _$WorkflowProjectModelCopyWithImpl<WorkflowProjectModel>(
          this as WorkflowProjectModel, _$identity);

  /// Serializes this WorkflowProjectModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WorkflowProjectModel &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.concept, concept) || other.concept == concept) &&
            (identical(other.goal, goal) || other.goal == goal) &&
            (identical(other.target, target) || other.target == target) &&
            (identical(other.locale, locale) || other.locale == locale) &&
            const DeepCollectionEquality().equals(other.kpi, kpi) &&
            (identical(other.organization, organization) ||
                other.organization == organization) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.googleAccessToken, googleAccessToken) ||
                other.googleAccessToken == googleAccessToken) &&
            (identical(other.googleRefreshToken, googleRefreshToken) ||
                other.googleRefreshToken == googleRefreshToken) &&
            (identical(other.googleServiceAccount, googleServiceAccount) ||
                other.googleServiceAccount == googleServiceAccount) &&
            (identical(other.githubPersonalAccessToken,
                    githubPersonalAccessToken) ||
                other.githubPersonalAccessToken == githubPersonalAccessToken) &&
            (identical(other.appstoreIssuerId, appstoreIssuerId) ||
                other.appstoreIssuerId == appstoreIssuerId) &&
            (identical(other.appstoreAuthKeyId, appstoreAuthKeyId) ||
                other.appstoreAuthKeyId == appstoreAuthKeyId) &&
            (identical(other.appstoreAuthKey, appstoreAuthKey) ||
                other.appstoreAuthKey == appstoreAuthKey) &&
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
      description,
      concept,
      goal,
      target,
      locale,
      const DeepCollectionEquality().hash(kpi),
      organization,
      icon,
      googleAccessToken,
      googleRefreshToken,
      googleServiceAccount,
      githubPersonalAccessToken,
      appstoreIssuerId,
      appstoreAuthKeyId,
      appstoreAuthKey,
      createdTime,
      updatedTime);

  @override
  String toString() {
    return 'WorkflowProjectModel(name: $name, description: $description, concept: $concept, goal: $goal, target: $target, locale: $locale, kpi: $kpi, organization: $organization, icon: $icon, googleAccessToken: $googleAccessToken, googleRefreshToken: $googleRefreshToken, googleServiceAccount: $googleServiceAccount, githubPersonalAccessToken: $githubPersonalAccessToken, appstoreIssuerId: $appstoreIssuerId, appstoreAuthKeyId: $appstoreAuthKeyId, appstoreAuthKey: $appstoreAuthKey, createdTime: $createdTime, updatedTime: $updatedTime)';
  }
}

/// @nodoc
abstract mixin class $WorkflowProjectModelCopyWith<$Res> {
  factory $WorkflowProjectModelCopyWith(WorkflowProjectModel value,
          $Res Function(WorkflowProjectModel) _then) =
      _$WorkflowProjectModelCopyWithImpl;
  @useResult
  $Res call(
      {String? name,
      String? description,
      String? concept,
      String? goal,
      String? target,
      ModelLocale? locale,
      Map<String, dynamic>? kpi,
      @refParam WorkflowOrganizationModelRef organization,
      String? icon,
      String? googleAccessToken,
      String? googleRefreshToken,
      String? googleServiceAccount,
      String? githubPersonalAccessToken,
      String? appstoreIssuerId,
      String? appstoreAuthKeyId,
      String? appstoreAuthKey,
      ModelTimestamp createdTime,
      ModelTimestamp updatedTime});
}

/// @nodoc
class _$WorkflowProjectModelCopyWithImpl<$Res>
    implements $WorkflowProjectModelCopyWith<$Res> {
  _$WorkflowProjectModelCopyWithImpl(this._self, this._then);

  final WorkflowProjectModel _self;
  final $Res Function(WorkflowProjectModel) _then;

  /// Create a copy of WorkflowProjectModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? description = freezed,
    Object? concept = freezed,
    Object? goal = freezed,
    Object? target = freezed,
    Object? locale = freezed,
    Object? kpi = freezed,
    Object? organization = freezed,
    Object? icon = freezed,
    Object? googleAccessToken = freezed,
    Object? googleRefreshToken = freezed,
    Object? googleServiceAccount = freezed,
    Object? githubPersonalAccessToken = freezed,
    Object? appstoreIssuerId = freezed,
    Object? appstoreAuthKeyId = freezed,
    Object? appstoreAuthKey = freezed,
    Object? createdTime = null,
    Object? updatedTime = null,
  }) {
    return _then(_self.copyWith(
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      concept: freezed == concept
          ? _self.concept
          : concept // ignore: cast_nullable_to_non_nullable
              as String?,
      goal: freezed == goal
          ? _self.goal
          : goal // ignore: cast_nullable_to_non_nullable
              as String?,
      target: freezed == target
          ? _self.target
          : target // ignore: cast_nullable_to_non_nullable
              as String?,
      locale: freezed == locale
          ? _self.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as ModelLocale?,
      kpi: freezed == kpi
          ? _self.kpi
          : kpi // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      organization: freezed == organization
          ? _self.organization
          : organization // ignore: cast_nullable_to_non_nullable
              as WorkflowOrganizationModelRef,
      icon: freezed == icon
          ? _self.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      googleAccessToken: freezed == googleAccessToken
          ? _self.googleAccessToken
          : googleAccessToken // ignore: cast_nullable_to_non_nullable
              as String?,
      googleRefreshToken: freezed == googleRefreshToken
          ? _self.googleRefreshToken
          : googleRefreshToken // ignore: cast_nullable_to_non_nullable
              as String?,
      googleServiceAccount: freezed == googleServiceAccount
          ? _self.googleServiceAccount
          : googleServiceAccount // ignore: cast_nullable_to_non_nullable
              as String?,
      githubPersonalAccessToken: freezed == githubPersonalAccessToken
          ? _self.githubPersonalAccessToken
          : githubPersonalAccessToken // ignore: cast_nullable_to_non_nullable
              as String?,
      appstoreIssuerId: freezed == appstoreIssuerId
          ? _self.appstoreIssuerId
          : appstoreIssuerId // ignore: cast_nullable_to_non_nullable
              as String?,
      appstoreAuthKeyId: freezed == appstoreAuthKeyId
          ? _self.appstoreAuthKeyId
          : appstoreAuthKeyId // ignore: cast_nullable_to_non_nullable
              as String?,
      appstoreAuthKey: freezed == appstoreAuthKey
          ? _self.appstoreAuthKey
          : appstoreAuthKey // ignore: cast_nullable_to_non_nullable
              as String?,
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

/// Adds pattern-matching-related methods to [WorkflowProjectModel].
extension WorkflowProjectModelPatterns on WorkflowProjectModel {
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
    TResult Function(_WorkflowProjectModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WorkflowProjectModel() when $default != null:
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
    TResult Function(_WorkflowProjectModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowProjectModel():
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
    TResult? Function(_WorkflowProjectModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowProjectModel() when $default != null:
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
            String? description,
            String? concept,
            String? goal,
            String? target,
            ModelLocale? locale,
            Map<String, dynamic>? kpi,
            @refParam WorkflowOrganizationModelRef organization,
            String? icon,
            String? googleAccessToken,
            String? googleRefreshToken,
            String? googleServiceAccount,
            String? githubPersonalAccessToken,
            String? appstoreIssuerId,
            String? appstoreAuthKeyId,
            String? appstoreAuthKey,
            ModelTimestamp createdTime,
            ModelTimestamp updatedTime)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WorkflowProjectModel() when $default != null:
        return $default(
            _that.name,
            _that.description,
            _that.concept,
            _that.goal,
            _that.target,
            _that.locale,
            _that.kpi,
            _that.organization,
            _that.icon,
            _that.googleAccessToken,
            _that.googleRefreshToken,
            _that.googleServiceAccount,
            _that.githubPersonalAccessToken,
            _that.appstoreIssuerId,
            _that.appstoreAuthKeyId,
            _that.appstoreAuthKey,
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
            String? description,
            String? concept,
            String? goal,
            String? target,
            ModelLocale? locale,
            Map<String, dynamic>? kpi,
            @refParam WorkflowOrganizationModelRef organization,
            String? icon,
            String? googleAccessToken,
            String? googleRefreshToken,
            String? googleServiceAccount,
            String? githubPersonalAccessToken,
            String? appstoreIssuerId,
            String? appstoreAuthKeyId,
            String? appstoreAuthKey,
            ModelTimestamp createdTime,
            ModelTimestamp updatedTime)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowProjectModel():
        return $default(
            _that.name,
            _that.description,
            _that.concept,
            _that.goal,
            _that.target,
            _that.locale,
            _that.kpi,
            _that.organization,
            _that.icon,
            _that.googleAccessToken,
            _that.googleRefreshToken,
            _that.googleServiceAccount,
            _that.githubPersonalAccessToken,
            _that.appstoreIssuerId,
            _that.appstoreAuthKeyId,
            _that.appstoreAuthKey,
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
            String? description,
            String? concept,
            String? goal,
            String? target,
            ModelLocale? locale,
            Map<String, dynamic>? kpi,
            @refParam WorkflowOrganizationModelRef organization,
            String? icon,
            String? googleAccessToken,
            String? googleRefreshToken,
            String? googleServiceAccount,
            String? githubPersonalAccessToken,
            String? appstoreIssuerId,
            String? appstoreAuthKeyId,
            String? appstoreAuthKey,
            ModelTimestamp createdTime,
            ModelTimestamp updatedTime)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowProjectModel() when $default != null:
        return $default(
            _that.name,
            _that.description,
            _that.concept,
            _that.goal,
            _that.target,
            _that.locale,
            _that.kpi,
            _that.organization,
            _that.icon,
            _that.googleAccessToken,
            _that.googleRefreshToken,
            _that.googleServiceAccount,
            _that.githubPersonalAccessToken,
            _that.appstoreIssuerId,
            _that.appstoreAuthKeyId,
            _that.appstoreAuthKey,
            _that.createdTime,
            _that.updatedTime);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _WorkflowProjectModel extends WorkflowProjectModel {
  const _WorkflowProjectModel(
      {this.name,
      this.description,
      this.concept,
      this.goal,
      this.target,
      this.locale,
      final Map<String, dynamic>? kpi,
      @refParam this.organization,
      this.icon,
      this.googleAccessToken,
      this.googleRefreshToken,
      this.googleServiceAccount,
      this.githubPersonalAccessToken,
      this.appstoreIssuerId,
      this.appstoreAuthKeyId,
      this.appstoreAuthKey,
      this.createdTime = const ModelTimestamp.now(),
      this.updatedTime = const ModelTimestamp.now()})
      : _kpi = kpi,
        super._();
  factory _WorkflowProjectModel.fromJson(Map<String, dynamic> json) =>
      _$WorkflowProjectModelFromJson(json);

  @override
  final String? name;
  @override
  final String? description;
  @override
  final String? concept;
  @override
  final String? goal;
  @override
  final String? target;
  @override
  final ModelLocale? locale;
  final Map<String, dynamic>? _kpi;
  @override
  Map<String, dynamic>? get kpi {
    final value = _kpi;
    if (value == null) return null;
    if (_kpi is EqualUnmodifiableMapView) return _kpi;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @refParam
  final WorkflowOrganizationModelRef organization;
  @override
  final String? icon;
  @override
  final String? googleAccessToken;
  @override
  final String? googleRefreshToken;
  @override
  final String? googleServiceAccount;
  @override
  final String? githubPersonalAccessToken;
  @override
  final String? appstoreIssuerId;
  @override
  final String? appstoreAuthKeyId;
  @override
  final String? appstoreAuthKey;
  @override
  @JsonKey()
  final ModelTimestamp createdTime;
  @override
  @JsonKey()
  final ModelTimestamp updatedTime;

  /// Create a copy of WorkflowProjectModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WorkflowProjectModelCopyWith<_WorkflowProjectModel> get copyWith =>
      __$WorkflowProjectModelCopyWithImpl<_WorkflowProjectModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WorkflowProjectModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WorkflowProjectModel &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.concept, concept) || other.concept == concept) &&
            (identical(other.goal, goal) || other.goal == goal) &&
            (identical(other.target, target) || other.target == target) &&
            (identical(other.locale, locale) || other.locale == locale) &&
            const DeepCollectionEquality().equals(other._kpi, _kpi) &&
            (identical(other.organization, organization) ||
                other.organization == organization) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.googleAccessToken, googleAccessToken) ||
                other.googleAccessToken == googleAccessToken) &&
            (identical(other.googleRefreshToken, googleRefreshToken) ||
                other.googleRefreshToken == googleRefreshToken) &&
            (identical(other.googleServiceAccount, googleServiceAccount) ||
                other.googleServiceAccount == googleServiceAccount) &&
            (identical(other.githubPersonalAccessToken,
                    githubPersonalAccessToken) ||
                other.githubPersonalAccessToken == githubPersonalAccessToken) &&
            (identical(other.appstoreIssuerId, appstoreIssuerId) ||
                other.appstoreIssuerId == appstoreIssuerId) &&
            (identical(other.appstoreAuthKeyId, appstoreAuthKeyId) ||
                other.appstoreAuthKeyId == appstoreAuthKeyId) &&
            (identical(other.appstoreAuthKey, appstoreAuthKey) ||
                other.appstoreAuthKey == appstoreAuthKey) &&
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
      description,
      concept,
      goal,
      target,
      locale,
      const DeepCollectionEquality().hash(_kpi),
      organization,
      icon,
      googleAccessToken,
      googleRefreshToken,
      googleServiceAccount,
      githubPersonalAccessToken,
      appstoreIssuerId,
      appstoreAuthKeyId,
      appstoreAuthKey,
      createdTime,
      updatedTime);

  @override
  String toString() {
    return 'WorkflowProjectModel(name: $name, description: $description, concept: $concept, goal: $goal, target: $target, locale: $locale, kpi: $kpi, organization: $organization, icon: $icon, googleAccessToken: $googleAccessToken, googleRefreshToken: $googleRefreshToken, googleServiceAccount: $googleServiceAccount, githubPersonalAccessToken: $githubPersonalAccessToken, appstoreIssuerId: $appstoreIssuerId, appstoreAuthKeyId: $appstoreAuthKeyId, appstoreAuthKey: $appstoreAuthKey, createdTime: $createdTime, updatedTime: $updatedTime)';
  }
}

/// @nodoc
abstract mixin class _$WorkflowProjectModelCopyWith<$Res>
    implements $WorkflowProjectModelCopyWith<$Res> {
  factory _$WorkflowProjectModelCopyWith(_WorkflowProjectModel value,
          $Res Function(_WorkflowProjectModel) _then) =
      __$WorkflowProjectModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? name,
      String? description,
      String? concept,
      String? goal,
      String? target,
      ModelLocale? locale,
      Map<String, dynamic>? kpi,
      @refParam WorkflowOrganizationModelRef organization,
      String? icon,
      String? googleAccessToken,
      String? googleRefreshToken,
      String? googleServiceAccount,
      String? githubPersonalAccessToken,
      String? appstoreIssuerId,
      String? appstoreAuthKeyId,
      String? appstoreAuthKey,
      ModelTimestamp createdTime,
      ModelTimestamp updatedTime});
}

/// @nodoc
class __$WorkflowProjectModelCopyWithImpl<$Res>
    implements _$WorkflowProjectModelCopyWith<$Res> {
  __$WorkflowProjectModelCopyWithImpl(this._self, this._then);

  final _WorkflowProjectModel _self;
  final $Res Function(_WorkflowProjectModel) _then;

  /// Create a copy of WorkflowProjectModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = freezed,
    Object? description = freezed,
    Object? concept = freezed,
    Object? goal = freezed,
    Object? target = freezed,
    Object? locale = freezed,
    Object? kpi = freezed,
    Object? organization = freezed,
    Object? icon = freezed,
    Object? googleAccessToken = freezed,
    Object? googleRefreshToken = freezed,
    Object? googleServiceAccount = freezed,
    Object? githubPersonalAccessToken = freezed,
    Object? appstoreIssuerId = freezed,
    Object? appstoreAuthKeyId = freezed,
    Object? appstoreAuthKey = freezed,
    Object? createdTime = null,
    Object? updatedTime = null,
  }) {
    return _then(_WorkflowProjectModel(
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      concept: freezed == concept
          ? _self.concept
          : concept // ignore: cast_nullable_to_non_nullable
              as String?,
      goal: freezed == goal
          ? _self.goal
          : goal // ignore: cast_nullable_to_non_nullable
              as String?,
      target: freezed == target
          ? _self.target
          : target // ignore: cast_nullable_to_non_nullable
              as String?,
      locale: freezed == locale
          ? _self.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as ModelLocale?,
      kpi: freezed == kpi
          ? _self._kpi
          : kpi // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      organization: freezed == organization
          ? _self.organization
          : organization // ignore: cast_nullable_to_non_nullable
              as WorkflowOrganizationModelRef,
      icon: freezed == icon
          ? _self.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      googleAccessToken: freezed == googleAccessToken
          ? _self.googleAccessToken
          : googleAccessToken // ignore: cast_nullable_to_non_nullable
              as String?,
      googleRefreshToken: freezed == googleRefreshToken
          ? _self.googleRefreshToken
          : googleRefreshToken // ignore: cast_nullable_to_non_nullable
              as String?,
      googleServiceAccount: freezed == googleServiceAccount
          ? _self.googleServiceAccount
          : googleServiceAccount // ignore: cast_nullable_to_non_nullable
              as String?,
      githubPersonalAccessToken: freezed == githubPersonalAccessToken
          ? _self.githubPersonalAccessToken
          : githubPersonalAccessToken // ignore: cast_nullable_to_non_nullable
              as String?,
      appstoreIssuerId: freezed == appstoreIssuerId
          ? _self.appstoreIssuerId
          : appstoreIssuerId // ignore: cast_nullable_to_non_nullable
              as String?,
      appstoreAuthKeyId: freezed == appstoreAuthKeyId
          ? _self.appstoreAuthKeyId
          : appstoreAuthKeyId // ignore: cast_nullable_to_non_nullable
              as String?,
      appstoreAuthKey: freezed == appstoreAuthKey
          ? _self.appstoreAuthKey
          : appstoreAuthKey // ignore: cast_nullable_to_non_nullable
              as String?,
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
