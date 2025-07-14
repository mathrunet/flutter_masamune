// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'github_license.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GithubLicenseValue {
  String? get key;
  String? get name;
  String? get spdxId;
  ModelUri? get url;
  String? get nodeId;

  /// Create a copy of GithubLicenseValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GithubLicenseValueCopyWith<GithubLicenseValue> get copyWith =>
      _$GithubLicenseValueCopyWithImpl<GithubLicenseValue>(
          this as GithubLicenseValue, _$identity);

  /// Serializes this GithubLicenseValue to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GithubLicenseValue &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.spdxId, spdxId) || other.spdxId == spdxId) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.nodeId, nodeId) || other.nodeId == nodeId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, key, name, spdxId, url, nodeId);

  @override
  String toString() {
    return 'GithubLicenseValue(key: $key, name: $name, spdxId: $spdxId, url: $url, nodeId: $nodeId)';
  }
}

/// @nodoc
abstract mixin class $GithubLicenseValueCopyWith<$Res> {
  factory $GithubLicenseValueCopyWith(
          GithubLicenseValue value, $Res Function(GithubLicenseValue) _then) =
      _$GithubLicenseValueCopyWithImpl;
  @useResult
  $Res call(
      {String? key,
      String? name,
      String? spdxId,
      ModelUri? url,
      String? nodeId});
}

/// @nodoc
class _$GithubLicenseValueCopyWithImpl<$Res>
    implements $GithubLicenseValueCopyWith<$Res> {
  _$GithubLicenseValueCopyWithImpl(this._self, this._then);

  final GithubLicenseValue _self;
  final $Res Function(GithubLicenseValue) _then;

  /// Create a copy of GithubLicenseValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = freezed,
    Object? name = freezed,
    Object? spdxId = freezed,
    Object? url = freezed,
    Object? nodeId = freezed,
  }) {
    return _then(_self.copyWith(
      key: freezed == key
          ? _self.key
          : key // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      spdxId: freezed == spdxId
          ? _self.spdxId
          : spdxId // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      nodeId: freezed == nodeId
          ? _self.nodeId
          : nodeId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [GithubLicenseValue].
extension GithubLicenseValuePatterns on GithubLicenseValue {
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
    TResult Function(_GithubLicenseValue value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GithubLicenseValue() when $default != null:
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
    TResult Function(_GithubLicenseValue value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubLicenseValue():
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
    TResult? Function(_GithubLicenseValue value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubLicenseValue() when $default != null:
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
    TResult Function(String? key, String? name, String? spdxId, ModelUri? url,
            String? nodeId)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GithubLicenseValue() when $default != null:
        return $default(
            _that.key, _that.name, _that.spdxId, _that.url, _that.nodeId);
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
    TResult Function(String? key, String? name, String? spdxId, ModelUri? url,
            String? nodeId)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubLicenseValue():
        return $default(
            _that.key, _that.name, _that.spdxId, _that.url, _that.nodeId);
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
    TResult? Function(String? key, String? name, String? spdxId, ModelUri? url,
            String? nodeId)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubLicenseValue() when $default != null:
        return $default(
            _that.key, _that.name, _that.spdxId, _that.url, _that.nodeId);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _GithubLicenseValue extends GithubLicenseValue {
  const _GithubLicenseValue(
      {this.key, this.name, this.spdxId, this.url, this.nodeId})
      : super._();
  factory _GithubLicenseValue.fromJson(Map<String, dynamic> json) =>
      _$GithubLicenseValueFromJson(json);

  @override
  final String? key;
  @override
  final String? name;
  @override
  final String? spdxId;
  @override
  final ModelUri? url;
  @override
  final String? nodeId;

  /// Create a copy of GithubLicenseValue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GithubLicenseValueCopyWith<_GithubLicenseValue> get copyWith =>
      __$GithubLicenseValueCopyWithImpl<_GithubLicenseValue>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GithubLicenseValueToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GithubLicenseValue &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.spdxId, spdxId) || other.spdxId == spdxId) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.nodeId, nodeId) || other.nodeId == nodeId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, key, name, spdxId, url, nodeId);

  @override
  String toString() {
    return 'GithubLicenseValue(key: $key, name: $name, spdxId: $spdxId, url: $url, nodeId: $nodeId)';
  }
}

/// @nodoc
abstract mixin class _$GithubLicenseValueCopyWith<$Res>
    implements $GithubLicenseValueCopyWith<$Res> {
  factory _$GithubLicenseValueCopyWith(
          _GithubLicenseValue value, $Res Function(_GithubLicenseValue) _then) =
      __$GithubLicenseValueCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? key,
      String? name,
      String? spdxId,
      ModelUri? url,
      String? nodeId});
}

/// @nodoc
class __$GithubLicenseValueCopyWithImpl<$Res>
    implements _$GithubLicenseValueCopyWith<$Res> {
  __$GithubLicenseValueCopyWithImpl(this._self, this._then);

  final _GithubLicenseValue _self;
  final $Res Function(_GithubLicenseValue) _then;

  /// Create a copy of GithubLicenseValue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? key = freezed,
    Object? name = freezed,
    Object? spdxId = freezed,
    Object? url = freezed,
    Object? nodeId = freezed,
  }) {
    return _then(_GithubLicenseValue(
      key: freezed == key
          ? _self.key
          : key // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      spdxId: freezed == spdxId
          ? _self.spdxId
          : spdxId // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      nodeId: freezed == nodeId
          ? _self.nodeId
          : nodeId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
