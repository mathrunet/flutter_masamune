// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'github_project.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GithubProjectModel {
  int? get id;
  String? get name;
  String? get previousName;
  ModelUri? get projectUrl;
  ModelUri? get url;

  /// Create a copy of GithubProjectModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GithubProjectModelCopyWith<GithubProjectModel> get copyWith =>
      _$GithubProjectModelCopyWithImpl<GithubProjectModel>(
          this as GithubProjectModel, _$identity);

  /// Serializes this GithubProjectModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GithubProjectModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.previousName, previousName) ||
                other.previousName == previousName) &&
            (identical(other.projectUrl, projectUrl) ||
                other.projectUrl == projectUrl) &&
            (identical(other.url, url) || other.url == url));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, previousName, projectUrl, url);

  @override
  String toString() {
    return 'GithubProjectModel(id: $id, name: $name, previousName: $previousName, projectUrl: $projectUrl, url: $url)';
  }
}

/// @nodoc
abstract mixin class $GithubProjectModelCopyWith<$Res> {
  factory $GithubProjectModelCopyWith(
          GithubProjectModel value, $Res Function(GithubProjectModel) _then) =
      _$GithubProjectModelCopyWithImpl;
  @useResult
  $Res call(
      {int? id,
      String? name,
      String? previousName,
      ModelUri? projectUrl,
      ModelUri? url});
}

/// @nodoc
class _$GithubProjectModelCopyWithImpl<$Res>
    implements $GithubProjectModelCopyWith<$Res> {
  _$GithubProjectModelCopyWithImpl(this._self, this._then);

  final GithubProjectModel _self;
  final $Res Function(GithubProjectModel) _then;

  /// Create a copy of GithubProjectModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? previousName = freezed,
    Object? projectUrl = freezed,
    Object? url = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      previousName: freezed == previousName
          ? _self.previousName
          : previousName // ignore: cast_nullable_to_non_nullable
              as String?,
      projectUrl: freezed == projectUrl
          ? _self.projectUrl
          : projectUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
    ));
  }
}

/// Adds pattern-matching-related methods to [GithubProjectModel].
extension GithubProjectModelPatterns on GithubProjectModel {
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
    TResult Function(_GithubProjectModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GithubProjectModel() when $default != null:
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
    TResult Function(_GithubProjectModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubProjectModel():
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
    TResult? Function(_GithubProjectModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubProjectModel() when $default != null:
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
    TResult Function(int? id, String? name, String? previousName,
            ModelUri? projectUrl, ModelUri? url)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GithubProjectModel() when $default != null:
        return $default(_that.id, _that.name, _that.previousName,
            _that.projectUrl, _that.url);
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
    TResult Function(int? id, String? name, String? previousName,
            ModelUri? projectUrl, ModelUri? url)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubProjectModel():
        return $default(_that.id, _that.name, _that.previousName,
            _that.projectUrl, _that.url);
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
    TResult? Function(int? id, String? name, String? previousName,
            ModelUri? projectUrl, ModelUri? url)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubProjectModel() when $default != null:
        return $default(_that.id, _that.name, _that.previousName,
            _that.projectUrl, _that.url);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _GithubProjectModel extends GithubProjectModel {
  const _GithubProjectModel(
      {this.id, this.name, this.previousName, this.projectUrl, this.url})
      : super._();
  factory _GithubProjectModel.fromJson(Map<String, dynamic> json) =>
      _$GithubProjectModelFromJson(json);

  @override
  final int? id;
  @override
  final String? name;
  @override
  final String? previousName;
  @override
  final ModelUri? projectUrl;
  @override
  final ModelUri? url;

  /// Create a copy of GithubProjectModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GithubProjectModelCopyWith<_GithubProjectModel> get copyWith =>
      __$GithubProjectModelCopyWithImpl<_GithubProjectModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GithubProjectModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GithubProjectModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.previousName, previousName) ||
                other.previousName == previousName) &&
            (identical(other.projectUrl, projectUrl) ||
                other.projectUrl == projectUrl) &&
            (identical(other.url, url) || other.url == url));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, previousName, projectUrl, url);

  @override
  String toString() {
    return 'GithubProjectModel(id: $id, name: $name, previousName: $previousName, projectUrl: $projectUrl, url: $url)';
  }
}

/// @nodoc
abstract mixin class _$GithubProjectModelCopyWith<$Res>
    implements $GithubProjectModelCopyWith<$Res> {
  factory _$GithubProjectModelCopyWith(
          _GithubProjectModel value, $Res Function(_GithubProjectModel) _then) =
      __$GithubProjectModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? id,
      String? name,
      String? previousName,
      ModelUri? projectUrl,
      ModelUri? url});
}

/// @nodoc
class __$GithubProjectModelCopyWithImpl<$Res>
    implements _$GithubProjectModelCopyWith<$Res> {
  __$GithubProjectModelCopyWithImpl(this._self, this._then);

  final _GithubProjectModel _self;
  final $Res Function(_GithubProjectModel) _then;

  /// Create a copy of GithubProjectModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? previousName = freezed,
    Object? projectUrl = freezed,
    Object? url = freezed,
  }) {
    return _then(_GithubProjectModel(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      previousName: freezed == previousName
          ? _self.previousName
          : previousName // ignore: cast_nullable_to_non_nullable
              as String?,
      projectUrl: freezed == projectUrl
          ? _self.projectUrl
          : projectUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
    ));
  }
}

// dart format on
