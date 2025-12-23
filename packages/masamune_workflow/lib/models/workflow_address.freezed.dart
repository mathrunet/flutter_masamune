// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workflow_address.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkflowAddressModel {
  int get appCount;
  List<String> get appNames;
  List<String> get appSummaries;
  ModelTimestamp get collectedTime;
  ModelTimestamp get updatedTime;
  String? get developerId;
  String? get developerName;
  String? get email;
  String? get privacyPolicyUrl;
  String? get source;
  List<String> get contactPageUrls;

  /// Create a copy of WorkflowAddressModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WorkflowAddressModelCopyWith<WorkflowAddressModel> get copyWith =>
      _$WorkflowAddressModelCopyWithImpl<WorkflowAddressModel>(
          this as WorkflowAddressModel, _$identity);

  /// Serializes this WorkflowAddressModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WorkflowAddressModel &&
            (identical(other.appCount, appCount) ||
                other.appCount == appCount) &&
            const DeepCollectionEquality().equals(other.appNames, appNames) &&
            const DeepCollectionEquality()
                .equals(other.appSummaries, appSummaries) &&
            (identical(other.collectedTime, collectedTime) ||
                other.collectedTime == collectedTime) &&
            (identical(other.updatedTime, updatedTime) ||
                other.updatedTime == updatedTime) &&
            (identical(other.developerId, developerId) ||
                other.developerId == developerId) &&
            (identical(other.developerName, developerName) ||
                other.developerName == developerName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.privacyPolicyUrl, privacyPolicyUrl) ||
                other.privacyPolicyUrl == privacyPolicyUrl) &&
            (identical(other.source, source) || other.source == source) &&
            const DeepCollectionEquality()
                .equals(other.contactPageUrls, contactPageUrls));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      appCount,
      const DeepCollectionEquality().hash(appNames),
      const DeepCollectionEquality().hash(appSummaries),
      collectedTime,
      updatedTime,
      developerId,
      developerName,
      email,
      privacyPolicyUrl,
      source,
      const DeepCollectionEquality().hash(contactPageUrls));

  @override
  String toString() {
    return 'WorkflowAddressModel(appCount: $appCount, appNames: $appNames, appSummaries: $appSummaries, collectedTime: $collectedTime, updatedTime: $updatedTime, developerId: $developerId, developerName: $developerName, email: $email, privacyPolicyUrl: $privacyPolicyUrl, source: $source, contactPageUrls: $contactPageUrls)';
  }
}

/// @nodoc
abstract mixin class $WorkflowAddressModelCopyWith<$Res> {
  factory $WorkflowAddressModelCopyWith(WorkflowAddressModel value,
          $Res Function(WorkflowAddressModel) _then) =
      _$WorkflowAddressModelCopyWithImpl;
  @useResult
  $Res call(
      {int appCount,
      List<String> appNames,
      List<String> appSummaries,
      ModelTimestamp collectedTime,
      ModelTimestamp updatedTime,
      String? developerId,
      String? developerName,
      String? email,
      String? privacyPolicyUrl,
      String? source,
      List<String> contactPageUrls});
}

/// @nodoc
class _$WorkflowAddressModelCopyWithImpl<$Res>
    implements $WorkflowAddressModelCopyWith<$Res> {
  _$WorkflowAddressModelCopyWithImpl(this._self, this._then);

  final WorkflowAddressModel _self;
  final $Res Function(WorkflowAddressModel) _then;

  /// Create a copy of WorkflowAddressModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appCount = null,
    Object? appNames = null,
    Object? appSummaries = null,
    Object? collectedTime = null,
    Object? updatedTime = null,
    Object? developerId = freezed,
    Object? developerName = freezed,
    Object? email = freezed,
    Object? privacyPolicyUrl = freezed,
    Object? source = freezed,
    Object? contactPageUrls = null,
  }) {
    return _then(_self.copyWith(
      appCount: null == appCount
          ? _self.appCount
          : appCount // ignore: cast_nullable_to_non_nullable
              as int,
      appNames: null == appNames
          ? _self.appNames
          : appNames // ignore: cast_nullable_to_non_nullable
              as List<String>,
      appSummaries: null == appSummaries
          ? _self.appSummaries
          : appSummaries // ignore: cast_nullable_to_non_nullable
              as List<String>,
      collectedTime: null == collectedTime
          ? _self.collectedTime
          : collectedTime // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp,
      updatedTime: null == updatedTime
          ? _self.updatedTime
          : updatedTime // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp,
      developerId: freezed == developerId
          ? _self.developerId
          : developerId // ignore: cast_nullable_to_non_nullable
              as String?,
      developerName: freezed == developerName
          ? _self.developerName
          : developerName // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      privacyPolicyUrl: freezed == privacyPolicyUrl
          ? _self.privacyPolicyUrl
          : privacyPolicyUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      source: freezed == source
          ? _self.source
          : source // ignore: cast_nullable_to_non_nullable
              as String?,
      contactPageUrls: null == contactPageUrls
          ? _self.contactPageUrls
          : contactPageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// Adds pattern-matching-related methods to [WorkflowAddressModel].
extension WorkflowAddressModelPatterns on WorkflowAddressModel {
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
    TResult Function(_WorkflowAddressModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WorkflowAddressModel() when $default != null:
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
    TResult Function(_WorkflowAddressModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowAddressModel():
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
    TResult? Function(_WorkflowAddressModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowAddressModel() when $default != null:
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
            int appCount,
            List<String> appNames,
            List<String> appSummaries,
            ModelTimestamp collectedTime,
            ModelTimestamp updatedTime,
            String? developerId,
            String? developerName,
            String? email,
            String? privacyPolicyUrl,
            String? source,
            List<String> contactPageUrls)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WorkflowAddressModel() when $default != null:
        return $default(
            _that.appCount,
            _that.appNames,
            _that.appSummaries,
            _that.collectedTime,
            _that.updatedTime,
            _that.developerId,
            _that.developerName,
            _that.email,
            _that.privacyPolicyUrl,
            _that.source,
            _that.contactPageUrls);
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
            int appCount,
            List<String> appNames,
            List<String> appSummaries,
            ModelTimestamp collectedTime,
            ModelTimestamp updatedTime,
            String? developerId,
            String? developerName,
            String? email,
            String? privacyPolicyUrl,
            String? source,
            List<String> contactPageUrls)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowAddressModel():
        return $default(
            _that.appCount,
            _that.appNames,
            _that.appSummaries,
            _that.collectedTime,
            _that.updatedTime,
            _that.developerId,
            _that.developerName,
            _that.email,
            _that.privacyPolicyUrl,
            _that.source,
            _that.contactPageUrls);
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
            int appCount,
            List<String> appNames,
            List<String> appSummaries,
            ModelTimestamp collectedTime,
            ModelTimestamp updatedTime,
            String? developerId,
            String? developerName,
            String? email,
            String? privacyPolicyUrl,
            String? source,
            List<String> contactPageUrls)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowAddressModel() when $default != null:
        return $default(
            _that.appCount,
            _that.appNames,
            _that.appSummaries,
            _that.collectedTime,
            _that.updatedTime,
            _that.developerId,
            _that.developerName,
            _that.email,
            _that.privacyPolicyUrl,
            _that.source,
            _that.contactPageUrls);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _WorkflowAddressModel extends WorkflowAddressModel {
  const _WorkflowAddressModel(
      {this.appCount = 0,
      final List<String> appNames = const [],
      final List<String> appSummaries = const [],
      this.collectedTime = const ModelTimestamp(),
      this.updatedTime = const ModelTimestamp(),
      this.developerId,
      this.developerName,
      this.email,
      this.privacyPolicyUrl,
      this.source,
      final List<String> contactPageUrls = const []})
      : _appNames = appNames,
        _appSummaries = appSummaries,
        _contactPageUrls = contactPageUrls,
        super._();
  factory _WorkflowAddressModel.fromJson(Map<String, dynamic> json) =>
      _$WorkflowAddressModelFromJson(json);

  @override
  @JsonKey()
  final int appCount;
  final List<String> _appNames;
  @override
  @JsonKey()
  List<String> get appNames {
    if (_appNames is EqualUnmodifiableListView) return _appNames;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_appNames);
  }

  final List<String> _appSummaries;
  @override
  @JsonKey()
  List<String> get appSummaries {
    if (_appSummaries is EqualUnmodifiableListView) return _appSummaries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_appSummaries);
  }

  @override
  @JsonKey()
  final ModelTimestamp collectedTime;
  @override
  @JsonKey()
  final ModelTimestamp updatedTime;
  @override
  final String? developerId;
  @override
  final String? developerName;
  @override
  final String? email;
  @override
  final String? privacyPolicyUrl;
  @override
  final String? source;
  final List<String> _contactPageUrls;
  @override
  @JsonKey()
  List<String> get contactPageUrls {
    if (_contactPageUrls is EqualUnmodifiableListView) return _contactPageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_contactPageUrls);
  }

  /// Create a copy of WorkflowAddressModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WorkflowAddressModelCopyWith<_WorkflowAddressModel> get copyWith =>
      __$WorkflowAddressModelCopyWithImpl<_WorkflowAddressModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WorkflowAddressModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WorkflowAddressModel &&
            (identical(other.appCount, appCount) ||
                other.appCount == appCount) &&
            const DeepCollectionEquality().equals(other._appNames, _appNames) &&
            const DeepCollectionEquality()
                .equals(other._appSummaries, _appSummaries) &&
            (identical(other.collectedTime, collectedTime) ||
                other.collectedTime == collectedTime) &&
            (identical(other.updatedTime, updatedTime) ||
                other.updatedTime == updatedTime) &&
            (identical(other.developerId, developerId) ||
                other.developerId == developerId) &&
            (identical(other.developerName, developerName) ||
                other.developerName == developerName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.privacyPolicyUrl, privacyPolicyUrl) ||
                other.privacyPolicyUrl == privacyPolicyUrl) &&
            (identical(other.source, source) || other.source == source) &&
            const DeepCollectionEquality()
                .equals(other._contactPageUrls, _contactPageUrls));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      appCount,
      const DeepCollectionEquality().hash(_appNames),
      const DeepCollectionEquality().hash(_appSummaries),
      collectedTime,
      updatedTime,
      developerId,
      developerName,
      email,
      privacyPolicyUrl,
      source,
      const DeepCollectionEquality().hash(_contactPageUrls));

  @override
  String toString() {
    return 'WorkflowAddressModel(appCount: $appCount, appNames: $appNames, appSummaries: $appSummaries, collectedTime: $collectedTime, updatedTime: $updatedTime, developerId: $developerId, developerName: $developerName, email: $email, privacyPolicyUrl: $privacyPolicyUrl, source: $source, contactPageUrls: $contactPageUrls)';
  }
}

/// @nodoc
abstract mixin class _$WorkflowAddressModelCopyWith<$Res>
    implements $WorkflowAddressModelCopyWith<$Res> {
  factory _$WorkflowAddressModelCopyWith(_WorkflowAddressModel value,
          $Res Function(_WorkflowAddressModel) _then) =
      __$WorkflowAddressModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int appCount,
      List<String> appNames,
      List<String> appSummaries,
      ModelTimestamp collectedTime,
      ModelTimestamp updatedTime,
      String? developerId,
      String? developerName,
      String? email,
      String? privacyPolicyUrl,
      String? source,
      List<String> contactPageUrls});
}

/// @nodoc
class __$WorkflowAddressModelCopyWithImpl<$Res>
    implements _$WorkflowAddressModelCopyWith<$Res> {
  __$WorkflowAddressModelCopyWithImpl(this._self, this._then);

  final _WorkflowAddressModel _self;
  final $Res Function(_WorkflowAddressModel) _then;

  /// Create a copy of WorkflowAddressModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? appCount = null,
    Object? appNames = null,
    Object? appSummaries = null,
    Object? collectedTime = null,
    Object? updatedTime = null,
    Object? developerId = freezed,
    Object? developerName = freezed,
    Object? email = freezed,
    Object? privacyPolicyUrl = freezed,
    Object? source = freezed,
    Object? contactPageUrls = null,
  }) {
    return _then(_WorkflowAddressModel(
      appCount: null == appCount
          ? _self.appCount
          : appCount // ignore: cast_nullable_to_non_nullable
              as int,
      appNames: null == appNames
          ? _self._appNames
          : appNames // ignore: cast_nullable_to_non_nullable
              as List<String>,
      appSummaries: null == appSummaries
          ? _self._appSummaries
          : appSummaries // ignore: cast_nullable_to_non_nullable
              as List<String>,
      collectedTime: null == collectedTime
          ? _self.collectedTime
          : collectedTime // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp,
      updatedTime: null == updatedTime
          ? _self.updatedTime
          : updatedTime // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp,
      developerId: freezed == developerId
          ? _self.developerId
          : developerId // ignore: cast_nullable_to_non_nullable
              as String?,
      developerName: freezed == developerName
          ? _self.developerName
          : developerName // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      privacyPolicyUrl: freezed == privacyPolicyUrl
          ? _self.privacyPolicyUrl
          : privacyPolicyUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      source: freezed == source
          ? _self.source
          : source // ignore: cast_nullable_to_non_nullable
              as String?,
      contactPageUrls: null == contactPageUrls
          ? _self._contactPageUrls
          : contactPageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

// dart format on
