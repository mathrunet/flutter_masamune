// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stripe_payment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StripePaymentModel {
  @JsonKey(name: "id")
  String get paymentId;
  @JsonKey(name: "type")
  String get type;
  @JsonKey(name: "brand")
  String get brand;
  @JsonKey(name: "numberLast")
  String get numberLast;
  @JsonKey(name: "expMonth")
  int get expMonth;
  @JsonKey(name: "expYear")
  int get expYear;
  @JsonKey(name: "default")
  bool get isDefault;

  /// Create a copy of StripePaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StripePaymentModelCopyWith<StripePaymentModel> get copyWith =>
      _$StripePaymentModelCopyWithImpl<StripePaymentModel>(
          this as StripePaymentModel, _$identity);

  /// Serializes this StripePaymentModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StripePaymentModel &&
            (identical(other.paymentId, paymentId) ||
                other.paymentId == paymentId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.numberLast, numberLast) ||
                other.numberLast == numberLast) &&
            (identical(other.expMonth, expMonth) ||
                other.expMonth == expMonth) &&
            (identical(other.expYear, expYear) || other.expYear == expYear) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, paymentId, type, brand,
      numberLast, expMonth, expYear, isDefault);

  @override
  String toString() {
    return 'StripePaymentModel(paymentId: $paymentId, type: $type, brand: $brand, numberLast: $numberLast, expMonth: $expMonth, expYear: $expYear, isDefault: $isDefault)';
  }
}

/// @nodoc
abstract mixin class $StripePaymentModelCopyWith<$Res> {
  factory $StripePaymentModelCopyWith(
          StripePaymentModel value, $Res Function(StripePaymentModel) _then) =
      _$StripePaymentModelCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: "id") String paymentId,
      @JsonKey(name: "type") String type,
      @JsonKey(name: "brand") String brand,
      @JsonKey(name: "numberLast") String numberLast,
      @JsonKey(name: "expMonth") int expMonth,
      @JsonKey(name: "expYear") int expYear,
      @JsonKey(name: "default") bool isDefault});
}

/// @nodoc
class _$StripePaymentModelCopyWithImpl<$Res>
    implements $StripePaymentModelCopyWith<$Res> {
  _$StripePaymentModelCopyWithImpl(this._self, this._then);

  final StripePaymentModel _self;
  final $Res Function(StripePaymentModel) _then;

  /// Create a copy of StripePaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paymentId = null,
    Object? type = null,
    Object? brand = null,
    Object? numberLast = null,
    Object? expMonth = null,
    Object? expYear = null,
    Object? isDefault = null,
  }) {
    return _then(_self.copyWith(
      paymentId: null == paymentId
          ? _self.paymentId
          : paymentId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      brand: null == brand
          ? _self.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String,
      numberLast: null == numberLast
          ? _self.numberLast
          : numberLast // ignore: cast_nullable_to_non_nullable
              as String,
      expMonth: null == expMonth
          ? _self.expMonth
          : expMonth // ignore: cast_nullable_to_non_nullable
              as int,
      expYear: null == expYear
          ? _self.expYear
          : expYear // ignore: cast_nullable_to_non_nullable
              as int,
      isDefault: null == isDefault
          ? _self.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [StripePaymentModel].
extension StripePaymentModelPatterns on StripePaymentModel {
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
    TResult Function(_StripePaymentModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _StripePaymentModel() when $default != null:
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
    TResult Function(_StripePaymentModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StripePaymentModel():
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
    TResult? Function(_StripePaymentModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StripePaymentModel() when $default != null:
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
            @JsonKey(name: "id") String paymentId,
            @JsonKey(name: "type") String type,
            @JsonKey(name: "brand") String brand,
            @JsonKey(name: "numberLast") String numberLast,
            @JsonKey(name: "expMonth") int expMonth,
            @JsonKey(name: "expYear") int expYear,
            @JsonKey(name: "default") bool isDefault)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _StripePaymentModel() when $default != null:
        return $default(_that.paymentId, _that.type, _that.brand,
            _that.numberLast, _that.expMonth, _that.expYear, _that.isDefault);
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
            @JsonKey(name: "id") String paymentId,
            @JsonKey(name: "type") String type,
            @JsonKey(name: "brand") String brand,
            @JsonKey(name: "numberLast") String numberLast,
            @JsonKey(name: "expMonth") int expMonth,
            @JsonKey(name: "expYear") int expYear,
            @JsonKey(name: "default") bool isDefault)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StripePaymentModel():
        return $default(_that.paymentId, _that.type, _that.brand,
            _that.numberLast, _that.expMonth, _that.expYear, _that.isDefault);
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
            @JsonKey(name: "id") String paymentId,
            @JsonKey(name: "type") String type,
            @JsonKey(name: "brand") String brand,
            @JsonKey(name: "numberLast") String numberLast,
            @JsonKey(name: "expMonth") int expMonth,
            @JsonKey(name: "expYear") int expYear,
            @JsonKey(name: "default") bool isDefault)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StripePaymentModel() when $default != null:
        return $default(_that.paymentId, _that.type, _that.brand,
            _that.numberLast, _that.expMonth, _that.expYear, _that.isDefault);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _StripePaymentModel extends StripePaymentModel {
  const _StripePaymentModel(
      {@JsonKey(name: "id") required this.paymentId,
      @JsonKey(name: "type") required this.type,
      @JsonKey(name: "brand") required this.brand,
      @JsonKey(name: "numberLast") required this.numberLast,
      @JsonKey(name: "expMonth") this.expMonth = 1,
      @JsonKey(name: "expYear") this.expYear = 2000,
      @JsonKey(name: "default") this.isDefault = false})
      : super._();
  factory _StripePaymentModel.fromJson(Map<String, dynamic> json) =>
      _$StripePaymentModelFromJson(json);

  @override
  @JsonKey(name: "id")
  final String paymentId;
  @override
  @JsonKey(name: "type")
  final String type;
  @override
  @JsonKey(name: "brand")
  final String brand;
  @override
  @JsonKey(name: "numberLast")
  final String numberLast;
  @override
  @JsonKey(name: "expMonth")
  final int expMonth;
  @override
  @JsonKey(name: "expYear")
  final int expYear;
  @override
  @JsonKey(name: "default")
  final bool isDefault;

  /// Create a copy of StripePaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$StripePaymentModelCopyWith<_StripePaymentModel> get copyWith =>
      __$StripePaymentModelCopyWithImpl<_StripePaymentModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$StripePaymentModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _StripePaymentModel &&
            (identical(other.paymentId, paymentId) ||
                other.paymentId == paymentId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.numberLast, numberLast) ||
                other.numberLast == numberLast) &&
            (identical(other.expMonth, expMonth) ||
                other.expMonth == expMonth) &&
            (identical(other.expYear, expYear) || other.expYear == expYear) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, paymentId, type, brand,
      numberLast, expMonth, expYear, isDefault);

  @override
  String toString() {
    return 'StripePaymentModel(paymentId: $paymentId, type: $type, brand: $brand, numberLast: $numberLast, expMonth: $expMonth, expYear: $expYear, isDefault: $isDefault)';
  }
}

/// @nodoc
abstract mixin class _$StripePaymentModelCopyWith<$Res>
    implements $StripePaymentModelCopyWith<$Res> {
  factory _$StripePaymentModelCopyWith(
          _StripePaymentModel value, $Res Function(_StripePaymentModel) _then) =
      __$StripePaymentModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "id") String paymentId,
      @JsonKey(name: "type") String type,
      @JsonKey(name: "brand") String brand,
      @JsonKey(name: "numberLast") String numberLast,
      @JsonKey(name: "expMonth") int expMonth,
      @JsonKey(name: "expYear") int expYear,
      @JsonKey(name: "default") bool isDefault});
}

/// @nodoc
class __$StripePaymentModelCopyWithImpl<$Res>
    implements _$StripePaymentModelCopyWith<$Res> {
  __$StripePaymentModelCopyWithImpl(this._self, this._then);

  final _StripePaymentModel _self;
  final $Res Function(_StripePaymentModel) _then;

  /// Create a copy of StripePaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? paymentId = null,
    Object? type = null,
    Object? brand = null,
    Object? numberLast = null,
    Object? expMonth = null,
    Object? expYear = null,
    Object? isDefault = null,
  }) {
    return _then(_StripePaymentModel(
      paymentId: null == paymentId
          ? _self.paymentId
          : paymentId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      brand: null == brand
          ? _self.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String,
      numberLast: null == numberLast
          ? _self.numberLast
          : numberLast // ignore: cast_nullable_to_non_nullable
              as String,
      expMonth: null == expMonth
          ? _self.expMonth
          : expMonth // ignore: cast_nullable_to_non_nullable
              as int,
      expYear: null == expYear
          ? _self.expYear
          : expYear // ignore: cast_nullable_to_non_nullable
              as int,
      isDefault: null == isDefault
          ? _self.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
