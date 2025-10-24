// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vector.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VectorModel {
  String get agentId;
  @vectorParam
  String get content;
  ModelTimestamp get createdAt;

  /// Create a copy of VectorModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VectorModelCopyWith<VectorModel> get copyWith =>
      _$VectorModelCopyWithImpl<VectorModel>(this as VectorModel, _$identity);

  /// Serializes this VectorModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VectorModel &&
            (identical(other.agentId, agentId) || other.agentId == agentId) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, agentId, content, createdAt);

  @override
  String toString() {
    return 'VectorModel(agentId: $agentId, content: $content, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $VectorModelCopyWith<$Res> {
  factory $VectorModelCopyWith(
          VectorModel value, $Res Function(VectorModel) _then) =
      _$VectorModelCopyWithImpl;
  @useResult
  $Res call(
      {String agentId, @vectorParam String content, ModelTimestamp createdAt});
}

/// @nodoc
class _$VectorModelCopyWithImpl<$Res> implements $VectorModelCopyWith<$Res> {
  _$VectorModelCopyWithImpl(this._self, this._then);

  final VectorModel _self;
  final $Res Function(VectorModel) _then;

  /// Create a copy of VectorModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? agentId = null,
    Object? content = null,
    Object? createdAt = null,
  }) {
    return _then(_self.copyWith(
      agentId: null == agentId
          ? _self.agentId
          : agentId // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp,
    ));
  }
}

/// Adds pattern-matching-related methods to [VectorModel].
extension VectorModelPatterns on VectorModel {
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
    TResult Function(_VectorModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VectorModel() when $default != null:
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
    TResult Function(_VectorModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VectorModel():
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
    TResult? Function(_VectorModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VectorModel() when $default != null:
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
    TResult Function(String agentId, @vectorParam String content,
            ModelTimestamp createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VectorModel() when $default != null:
        return $default(_that.agentId, _that.content, _that.createdAt);
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
    TResult Function(String agentId, @vectorParam String content,
            ModelTimestamp createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VectorModel():
        return $default(_that.agentId, _that.content, _that.createdAt);
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
    TResult? Function(String agentId, @vectorParam String content,
            ModelTimestamp createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VectorModel() when $default != null:
        return $default(_that.agentId, _that.content, _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _VectorModel extends VectorModel {
  const _VectorModel(
      {required this.agentId,
      @vectorParam required this.content,
      this.createdAt = const ModelTimestamp.now()})
      : super._();
  factory _VectorModel.fromJson(Map<String, dynamic> json) =>
      _$VectorModelFromJson(json);

  @override
  final String agentId;
  @override
  @vectorParam
  final String content;
  @override
  @JsonKey()
  final ModelTimestamp createdAt;

  /// Create a copy of VectorModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$VectorModelCopyWith<_VectorModel> get copyWith =>
      __$VectorModelCopyWithImpl<_VectorModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$VectorModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _VectorModel &&
            (identical(other.agentId, agentId) || other.agentId == agentId) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, agentId, content, createdAt);

  @override
  String toString() {
    return 'VectorModel(agentId: $agentId, content: $content, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$VectorModelCopyWith<$Res>
    implements $VectorModelCopyWith<$Res> {
  factory _$VectorModelCopyWith(
          _VectorModel value, $Res Function(_VectorModel) _then) =
      __$VectorModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String agentId, @vectorParam String content, ModelTimestamp createdAt});
}

/// @nodoc
class __$VectorModelCopyWithImpl<$Res> implements _$VectorModelCopyWith<$Res> {
  __$VectorModelCopyWithImpl(this._self, this._then);

  final _VectorModel _self;
  final $Res Function(_VectorModel) _then;

  /// Create a copy of VectorModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? agentId = null,
    Object? content = null,
    Object? createdAt = null,
  }) {
    return _then(_VectorModel(
      agentId: null == agentId
          ? _self.agentId
          : agentId // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp,
    ));
  }
}

// dart format on
