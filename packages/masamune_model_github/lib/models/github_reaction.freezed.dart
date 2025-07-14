// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'github_reaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GithubReactionValue {
  int? get plusOne;
  int? get minusOne;
  int? get confused;
  int? get eyes;
  int? get heart;
  int? get hooray;
  int? get laugh;
  int? get rocket;
  int get totalCount;
  ModelUri? get url;

  /// Create a copy of GithubReactionValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GithubReactionValueCopyWith<GithubReactionValue> get copyWith =>
      _$GithubReactionValueCopyWithImpl<GithubReactionValue>(
          this as GithubReactionValue, _$identity);

  /// Serializes this GithubReactionValue to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GithubReactionValue &&
            (identical(other.plusOne, plusOne) || other.plusOne == plusOne) &&
            (identical(other.minusOne, minusOne) ||
                other.minusOne == minusOne) &&
            (identical(other.confused, confused) ||
                other.confused == confused) &&
            (identical(other.eyes, eyes) || other.eyes == eyes) &&
            (identical(other.heart, heart) || other.heart == heart) &&
            (identical(other.hooray, hooray) || other.hooray == hooray) &&
            (identical(other.laugh, laugh) || other.laugh == laugh) &&
            (identical(other.rocket, rocket) || other.rocket == rocket) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.url, url) || other.url == url));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, plusOne, minusOne, confused,
      eyes, heart, hooray, laugh, rocket, totalCount, url);

  @override
  String toString() {
    return 'GithubReactionValue(plusOne: $plusOne, minusOne: $minusOne, confused: $confused, eyes: $eyes, heart: $heart, hooray: $hooray, laugh: $laugh, rocket: $rocket, totalCount: $totalCount, url: $url)';
  }
}

/// @nodoc
abstract mixin class $GithubReactionValueCopyWith<$Res> {
  factory $GithubReactionValueCopyWith(
          GithubReactionValue value, $Res Function(GithubReactionValue) _then) =
      _$GithubReactionValueCopyWithImpl;
  @useResult
  $Res call(
      {int? plusOne,
      int? minusOne,
      int? confused,
      int? eyes,
      int? heart,
      int? hooray,
      int? laugh,
      int? rocket,
      int totalCount,
      ModelUri? url});
}

/// @nodoc
class _$GithubReactionValueCopyWithImpl<$Res>
    implements $GithubReactionValueCopyWith<$Res> {
  _$GithubReactionValueCopyWithImpl(this._self, this._then);

  final GithubReactionValue _self;
  final $Res Function(GithubReactionValue) _then;

  /// Create a copy of GithubReactionValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? plusOne = freezed,
    Object? minusOne = freezed,
    Object? confused = freezed,
    Object? eyes = freezed,
    Object? heart = freezed,
    Object? hooray = freezed,
    Object? laugh = freezed,
    Object? rocket = freezed,
    Object? totalCount = null,
    Object? url = freezed,
  }) {
    return _then(_self.copyWith(
      plusOne: freezed == plusOne
          ? _self.plusOne
          : plusOne // ignore: cast_nullable_to_non_nullable
              as int?,
      minusOne: freezed == minusOne
          ? _self.minusOne
          : minusOne // ignore: cast_nullable_to_non_nullable
              as int?,
      confused: freezed == confused
          ? _self.confused
          : confused // ignore: cast_nullable_to_non_nullable
              as int?,
      eyes: freezed == eyes
          ? _self.eyes
          : eyes // ignore: cast_nullable_to_non_nullable
              as int?,
      heart: freezed == heart
          ? _self.heart
          : heart // ignore: cast_nullable_to_non_nullable
              as int?,
      hooray: freezed == hooray
          ? _self.hooray
          : hooray // ignore: cast_nullable_to_non_nullable
              as int?,
      laugh: freezed == laugh
          ? _self.laugh
          : laugh // ignore: cast_nullable_to_non_nullable
              as int?,
      rocket: freezed == rocket
          ? _self.rocket
          : rocket // ignore: cast_nullable_to_non_nullable
              as int?,
      totalCount: null == totalCount
          ? _self.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
    ));
  }
}

/// Adds pattern-matching-related methods to [GithubReactionValue].
extension GithubReactionValuePatterns on GithubReactionValue {
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
    TResult Function(_GithubReactionValue value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GithubReactionValue() when $default != null:
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
    TResult Function(_GithubReactionValue value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubReactionValue():
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
    TResult? Function(_GithubReactionValue value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubReactionValue() when $default != null:
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
            int? plusOne,
            int? minusOne,
            int? confused,
            int? eyes,
            int? heart,
            int? hooray,
            int? laugh,
            int? rocket,
            int totalCount,
            ModelUri? url)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GithubReactionValue() when $default != null:
        return $default(
            _that.plusOne,
            _that.minusOne,
            _that.confused,
            _that.eyes,
            _that.heart,
            _that.hooray,
            _that.laugh,
            _that.rocket,
            _that.totalCount,
            _that.url);
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
            int? plusOne,
            int? minusOne,
            int? confused,
            int? eyes,
            int? heart,
            int? hooray,
            int? laugh,
            int? rocket,
            int totalCount,
            ModelUri? url)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubReactionValue():
        return $default(
            _that.plusOne,
            _that.minusOne,
            _that.confused,
            _that.eyes,
            _that.heart,
            _that.hooray,
            _that.laugh,
            _that.rocket,
            _that.totalCount,
            _that.url);
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
            int? plusOne,
            int? minusOne,
            int? confused,
            int? eyes,
            int? heart,
            int? hooray,
            int? laugh,
            int? rocket,
            int totalCount,
            ModelUri? url)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubReactionValue() when $default != null:
        return $default(
            _that.plusOne,
            _that.minusOne,
            _that.confused,
            _that.eyes,
            _that.heart,
            _that.hooray,
            _that.laugh,
            _that.rocket,
            _that.totalCount,
            _that.url);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _GithubReactionValue extends GithubReactionValue {
  const _GithubReactionValue(
      {this.plusOne,
      this.minusOne,
      this.confused,
      this.eyes,
      this.heart,
      this.hooray,
      this.laugh,
      this.rocket,
      this.totalCount = 0,
      this.url})
      : super._();
  factory _GithubReactionValue.fromJson(Map<String, dynamic> json) =>
      _$GithubReactionValueFromJson(json);

  @override
  final int? plusOne;
  @override
  final int? minusOne;
  @override
  final int? confused;
  @override
  final int? eyes;
  @override
  final int? heart;
  @override
  final int? hooray;
  @override
  final int? laugh;
  @override
  final int? rocket;
  @override
  @JsonKey()
  final int totalCount;
  @override
  final ModelUri? url;

  /// Create a copy of GithubReactionValue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GithubReactionValueCopyWith<_GithubReactionValue> get copyWith =>
      __$GithubReactionValueCopyWithImpl<_GithubReactionValue>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GithubReactionValueToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GithubReactionValue &&
            (identical(other.plusOne, plusOne) || other.plusOne == plusOne) &&
            (identical(other.minusOne, minusOne) ||
                other.minusOne == minusOne) &&
            (identical(other.confused, confused) ||
                other.confused == confused) &&
            (identical(other.eyes, eyes) || other.eyes == eyes) &&
            (identical(other.heart, heart) || other.heart == heart) &&
            (identical(other.hooray, hooray) || other.hooray == hooray) &&
            (identical(other.laugh, laugh) || other.laugh == laugh) &&
            (identical(other.rocket, rocket) || other.rocket == rocket) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.url, url) || other.url == url));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, plusOne, minusOne, confused,
      eyes, heart, hooray, laugh, rocket, totalCount, url);

  @override
  String toString() {
    return 'GithubReactionValue(plusOne: $plusOne, minusOne: $minusOne, confused: $confused, eyes: $eyes, heart: $heart, hooray: $hooray, laugh: $laugh, rocket: $rocket, totalCount: $totalCount, url: $url)';
  }
}

/// @nodoc
abstract mixin class _$GithubReactionValueCopyWith<$Res>
    implements $GithubReactionValueCopyWith<$Res> {
  factory _$GithubReactionValueCopyWith(_GithubReactionValue value,
          $Res Function(_GithubReactionValue) _then) =
      __$GithubReactionValueCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? plusOne,
      int? minusOne,
      int? confused,
      int? eyes,
      int? heart,
      int? hooray,
      int? laugh,
      int? rocket,
      int totalCount,
      ModelUri? url});
}

/// @nodoc
class __$GithubReactionValueCopyWithImpl<$Res>
    implements _$GithubReactionValueCopyWith<$Res> {
  __$GithubReactionValueCopyWithImpl(this._self, this._then);

  final _GithubReactionValue _self;
  final $Res Function(_GithubReactionValue) _then;

  /// Create a copy of GithubReactionValue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? plusOne = freezed,
    Object? minusOne = freezed,
    Object? confused = freezed,
    Object? eyes = freezed,
    Object? heart = freezed,
    Object? hooray = freezed,
    Object? laugh = freezed,
    Object? rocket = freezed,
    Object? totalCount = null,
    Object? url = freezed,
  }) {
    return _then(_GithubReactionValue(
      plusOne: freezed == plusOne
          ? _self.plusOne
          : plusOne // ignore: cast_nullable_to_non_nullable
              as int?,
      minusOne: freezed == minusOne
          ? _self.minusOne
          : minusOne // ignore: cast_nullable_to_non_nullable
              as int?,
      confused: freezed == confused
          ? _self.confused
          : confused // ignore: cast_nullable_to_non_nullable
              as int?,
      eyes: freezed == eyes
          ? _self.eyes
          : eyes // ignore: cast_nullable_to_non_nullable
              as int?,
      heart: freezed == heart
          ? _self.heart
          : heart // ignore: cast_nullable_to_non_nullable
              as int?,
      hooray: freezed == hooray
          ? _self.hooray
          : hooray // ignore: cast_nullable_to_non_nullable
              as int?,
      laugh: freezed == laugh
          ? _self.laugh
          : laugh // ignore: cast_nullable_to_non_nullable
              as int?,
      rocket: freezed == rocket
          ? _self.rocket
          : rocket // ignore: cast_nullable_to_non_nullable
              as int?,
      totalCount: null == totalCount
          ? _self.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
    ));
  }
}

// dart format on
