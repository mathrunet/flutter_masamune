// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_test.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TestValue {
  String? get name;
  String? get text;
  List<int> get ids;

  /// Create a copy of TestValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TestValueCopyWith<TestValue> get copyWith =>
      _$TestValueCopyWithImpl<TestValue>(this as TestValue, _$identity);

  /// Serializes this TestValue to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TestValue &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.text, text) || other.text == text) &&
            const DeepCollectionEquality().equals(other.ids, ids));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, name, text, const DeepCollectionEquality().hash(ids));

  @override
  String toString() {
    return 'TestValue(name: $name, text: $text, ids: $ids)';
  }
}

/// @nodoc
abstract mixin class $TestValueCopyWith<$Res> {
  factory $TestValueCopyWith(TestValue value, $Res Function(TestValue) _then) =
      _$TestValueCopyWithImpl;
  @useResult
  $Res call({String? name, String? text, List<int> ids});
}

/// @nodoc
class _$TestValueCopyWithImpl<$Res> implements $TestValueCopyWith<$Res> {
  _$TestValueCopyWithImpl(this._self, this._then);

  final TestValue _self;
  final $Res Function(TestValue) _then;

  /// Create a copy of TestValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? text = freezed,
    Object? ids = null,
  }) {
    return _then(_self.copyWith(
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      text: freezed == text
          ? _self.text
          : text // ignore: cast_nullable_to_non_nullable
              as String?,
      ids: null == ids
          ? _self.ids
          : ids // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ));
  }
}

/// Adds pattern-matching-related methods to [TestValue].
extension TestValuePatterns on TestValue {
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
    TResult Function(_TestValue value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TestValue() when $default != null:
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
    TResult Function(_TestValue value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TestValue():
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
    TResult? Function(_TestValue value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TestValue() when $default != null:
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
    TResult Function(String? name, String? text, List<int> ids)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TestValue() when $default != null:
        return $default(_that.name, _that.text, _that.ids);
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
    TResult Function(String? name, String? text, List<int> ids) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TestValue():
        return $default(_that.name, _that.text, _that.ids);
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
    TResult? Function(String? name, String? text, List<int> ids)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TestValue() when $default != null:
        return $default(_that.name, _that.text, _that.ids);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TestValue implements TestValue {
  const _TestValue({this.name, this.text, final List<int> ids = const []})
      : _ids = ids;
  factory _TestValue.fromJson(Map<String, dynamic> json) =>
      _$TestValueFromJson(json);

  @override
  final String? name;
  @override
  final String? text;
  final List<int> _ids;
  @override
  @JsonKey()
  List<int> get ids {
    if (_ids is EqualUnmodifiableListView) return _ids;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ids);
  }

  /// Create a copy of TestValue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TestValueCopyWith<_TestValue> get copyWith =>
      __$TestValueCopyWithImpl<_TestValue>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TestValueToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TestValue &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.text, text) || other.text == text) &&
            const DeepCollectionEquality().equals(other._ids, _ids));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, name, text, const DeepCollectionEquality().hash(_ids));

  @override
  String toString() {
    return 'TestValue(name: $name, text: $text, ids: $ids)';
  }
}

/// @nodoc
abstract mixin class _$TestValueCopyWith<$Res>
    implements $TestValueCopyWith<$Res> {
  factory _$TestValueCopyWith(
          _TestValue value, $Res Function(_TestValue) _then) =
      __$TestValueCopyWithImpl;
  @override
  @useResult
  $Res call({String? name, String? text, List<int> ids});
}

/// @nodoc
class __$TestValueCopyWithImpl<$Res> implements _$TestValueCopyWith<$Res> {
  __$TestValueCopyWithImpl(this._self, this._then);

  final _TestValue _self;
  final $Res Function(_TestValue) _then;

  /// Create a copy of TestValue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = freezed,
    Object? text = freezed,
    Object? ids = null,
  }) {
    return _then(_TestValue(
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      text: freezed == text
          ? _self.text
          : text // ignore: cast_nullable_to_non_nullable
              as String?,
      ids: null == ids
          ? _self._ids
          : ids // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ));
  }
}

/// @nodoc
mixin _$UserValue {
  String? get name;
  String? get text;

  /// Create a copy of UserValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserValueCopyWith<UserValue> get copyWith =>
      _$UserValueCopyWithImpl<UserValue>(this as UserValue, _$identity);

  /// Serializes this UserValue to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserValue &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.text, text) || other.text == text));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, text);

  @override
  String toString() {
    return 'UserValue(name: $name, text: $text)';
  }
}

/// @nodoc
abstract mixin class $UserValueCopyWith<$Res> {
  factory $UserValueCopyWith(UserValue value, $Res Function(UserValue) _then) =
      _$UserValueCopyWithImpl;
  @useResult
  $Res call({String? name, String? text});
}

/// @nodoc
class _$UserValueCopyWithImpl<$Res> implements $UserValueCopyWith<$Res> {
  _$UserValueCopyWithImpl(this._self, this._then);

  final UserValue _self;
  final $Res Function(UserValue) _then;

  /// Create a copy of UserValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? text = freezed,
  }) {
    return _then(_self.copyWith(
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      text: freezed == text
          ? _self.text
          : text // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [UserValue].
extension UserValuePatterns on UserValue {
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
    TResult Function(_UserValue value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserValue() when $default != null:
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
    TResult Function(_UserValue value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserValue():
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
    TResult? Function(_UserValue value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserValue() when $default != null:
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
    TResult Function(String? name, String? text)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserValue() when $default != null:
        return $default(_that.name, _that.text);
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
    TResult Function(String? name, String? text) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserValue():
        return $default(_that.name, _that.text);
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
    TResult? Function(String? name, String? text)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserValue() when $default != null:
        return $default(_that.name, _that.text);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _UserValue implements UserValue {
  const _UserValue({this.name, this.text});
  factory _UserValue.fromJson(Map<String, dynamic> json) =>
      _$UserValueFromJson(json);

  @override
  final String? name;
  @override
  final String? text;

  /// Create a copy of UserValue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UserValueCopyWith<_UserValue> get copyWith =>
      __$UserValueCopyWithImpl<_UserValue>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UserValueToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserValue &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.text, text) || other.text == text));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, text);

  @override
  String toString() {
    return 'UserValue(name: $name, text: $text)';
  }
}

/// @nodoc
abstract mixin class _$UserValueCopyWith<$Res>
    implements $UserValueCopyWith<$Res> {
  factory _$UserValueCopyWith(
          _UserValue value, $Res Function(_UserValue) _then) =
      __$UserValueCopyWithImpl;
  @override
  @useResult
  $Res call({String? name, String? text});
}

/// @nodoc
class __$UserValueCopyWithImpl<$Res> implements _$UserValueCopyWith<$Res> {
  __$UserValueCopyWithImpl(this._self, this._then);

  final _UserValue _self;
  final $Res Function(_UserValue) _then;

  /// Create a copy of UserValue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = freezed,
    Object? text = freezed,
  }) {
    return _then(_UserValue(
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      text: freezed == text
          ? _self.text
          : text // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$ShopValue {
  String? get name;
  String? get text;
  ModelRef<UserValue> get user;

  /// Create a copy of ShopValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ShopValueCopyWith<ShopValue> get copyWith =>
      _$ShopValueCopyWithImpl<ShopValue>(this as ShopValue, _$identity);

  /// Serializes this ShopValue to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ShopValue &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.user, user) || other.user == user));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, text, user);

  @override
  String toString() {
    return 'ShopValue(name: $name, text: $text, user: $user)';
  }
}

/// @nodoc
abstract mixin class $ShopValueCopyWith<$Res> {
  factory $ShopValueCopyWith(ShopValue value, $Res Function(ShopValue) _then) =
      _$ShopValueCopyWithImpl;
  @useResult
  $Res call({String? name, String? text, ModelRef<UserValue> user});
}

/// @nodoc
class _$ShopValueCopyWithImpl<$Res> implements $ShopValueCopyWith<$Res> {
  _$ShopValueCopyWithImpl(this._self, this._then);

  final ShopValue _self;
  final $Res Function(ShopValue) _then;

  /// Create a copy of ShopValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? text = freezed,
    Object? user = freezed,
  }) {
    return _then(_self.copyWith(
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      text: freezed == text
          ? _self.text
          : text // ignore: cast_nullable_to_non_nullable
              as String?,
      user: freezed == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as ModelRef<UserValue>,
    ));
  }
}

/// Adds pattern-matching-related methods to [ShopValue].
extension ShopValuePatterns on ShopValue {
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
    TResult Function(_ShopValue value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ShopValue() when $default != null:
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
    TResult Function(_ShopValue value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ShopValue():
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
    TResult? Function(_ShopValue value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ShopValue() when $default != null:
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
    TResult Function(String? name, String? text, ModelRef<UserValue> user)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ShopValue() when $default != null:
        return $default(_that.name, _that.text, _that.user);
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
    TResult Function(String? name, String? text, ModelRef<UserValue> user)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ShopValue():
        return $default(_that.name, _that.text, _that.user);
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
    TResult? Function(String? name, String? text, ModelRef<UserValue> user)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ShopValue() when $default != null:
        return $default(_that.name, _that.text, _that.user);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ShopValue implements ShopValue {
  const _ShopValue({this.name, this.text, this.user});
  factory _ShopValue.fromJson(Map<String, dynamic> json) =>
      _$ShopValueFromJson(json);

  @override
  final String? name;
  @override
  final String? text;
  @override
  final ModelRef<UserValue> user;

  /// Create a copy of ShopValue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ShopValueCopyWith<_ShopValue> get copyWith =>
      __$ShopValueCopyWithImpl<_ShopValue>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ShopValueToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ShopValue &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.user, user) || other.user == user));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, text, user);

  @override
  String toString() {
    return 'ShopValue(name: $name, text: $text, user: $user)';
  }
}

/// @nodoc
abstract mixin class _$ShopValueCopyWith<$Res>
    implements $ShopValueCopyWith<$Res> {
  factory _$ShopValueCopyWith(
          _ShopValue value, $Res Function(_ShopValue) _then) =
      __$ShopValueCopyWithImpl;
  @override
  @useResult
  $Res call({String? name, String? text, ModelRef<UserValue> user});
}

/// @nodoc
class __$ShopValueCopyWithImpl<$Res> implements _$ShopValueCopyWith<$Res> {
  __$ShopValueCopyWithImpl(this._self, this._then);

  final _ShopValue _self;
  final $Res Function(_ShopValue) _then;

  /// Create a copy of ShopValue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = freezed,
    Object? text = freezed,
    Object? user = freezed,
  }) {
    return _then(_ShopValue(
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      text: freezed == text
          ? _self.text
          : text // ignore: cast_nullable_to_non_nullable
              as String?,
      user: freezed == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as ModelRef<UserValue>,
    ));
  }
}

// dart format on
