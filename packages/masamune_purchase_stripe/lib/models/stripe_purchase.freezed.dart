// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stripe_purchase.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StripePurchaseModel {
  @JsonKey(name: "user")
  String get userId;
  @JsonKey(name: "orderId")
  String get orderId;
  @JsonKey(name: "purchaseId")
  String get purchaseId;
  @JsonKey(name: "paymentMethodId")
  String get paymentMethodId;
  @JsonKey(name: "customer")
  String get customerId;
  @JsonKey(name: "clientSecret")
  String get clientSecret;
  @JsonKey(name: "createdTime")
  ModelTimestamp get createdTime;
  @JsonKey(name: "updatedTime")
  ModelTimestamp get updatedTime;
  @JsonKey(name: "confirm")
  bool get confirm;
  @JsonKey(name: "verify")
  bool get verified;
  @JsonKey(name: "capture")
  bool get captured;
  @JsonKey(name: "success")
  bool get success;
  @JsonKey(name: "cancel")
  bool get canceled;
  @JsonKey(name: "error")
  bool get error;
  @JsonKey(name: "refund")
  bool get refund;
  @JsonKey(name: "amount")
  double get amount;
  @JsonKey(name: "application")
  String? get application;
  @JsonKey(name: "applicationFeeAmount")
  double get applicationFeeAmount;
  @JsonKey(name: "transferAmount")
  double get transferAmount;
  @JsonKey(name: "transferDistination")
  String get transferDistination;
  @JsonKey(name: "currency")
  String get currency;
  @JsonKey(name: "emailFrom")
  String? get emailFrom;
  @JsonKey(name: "emailTo")
  String? get emailTo;
  @JsonKey(name: "emailTitle")
  String? get emailTitle;
  @JsonKey(name: "emailContent")
  String? get emailContent;
  @JsonKey(name: "locale")
  String? get locale;
  @JsonKey(name: "cancel_at_period_end")
  bool get cancelAtPeriodEnd;

  /// Create a copy of StripePurchaseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StripePurchaseModelCopyWith<StripePurchaseModel> get copyWith =>
      _$StripePurchaseModelCopyWithImpl<StripePurchaseModel>(
          this as StripePurchaseModel, _$identity);

  /// Serializes this StripePurchaseModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StripePurchaseModel &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.purchaseId, purchaseId) ||
                other.purchaseId == purchaseId) &&
            (identical(other.paymentMethodId, paymentMethodId) ||
                other.paymentMethodId == paymentMethodId) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.clientSecret, clientSecret) ||
                other.clientSecret == clientSecret) &&
            (identical(other.createdTime, createdTime) ||
                other.createdTime == createdTime) &&
            (identical(other.updatedTime, updatedTime) ||
                other.updatedTime == updatedTime) &&
            (identical(other.confirm, confirm) || other.confirm == confirm) &&
            (identical(other.verified, verified) ||
                other.verified == verified) &&
            (identical(other.captured, captured) ||
                other.captured == captured) &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.canceled, canceled) ||
                other.canceled == canceled) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.refund, refund) || other.refund == refund) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.application, application) ||
                other.application == application) &&
            (identical(other.applicationFeeAmount, applicationFeeAmount) ||
                other.applicationFeeAmount == applicationFeeAmount) &&
            (identical(other.transferAmount, transferAmount) ||
                other.transferAmount == transferAmount) &&
            (identical(other.transferDistination, transferDistination) ||
                other.transferDistination == transferDistination) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.emailFrom, emailFrom) ||
                other.emailFrom == emailFrom) &&
            (identical(other.emailTo, emailTo) || other.emailTo == emailTo) &&
            (identical(other.emailTitle, emailTitle) ||
                other.emailTitle == emailTitle) &&
            (identical(other.emailContent, emailContent) ||
                other.emailContent == emailContent) &&
            (identical(other.locale, locale) || other.locale == locale) &&
            (identical(other.cancelAtPeriodEnd, cancelAtPeriodEnd) ||
                other.cancelAtPeriodEnd == cancelAtPeriodEnd));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        userId,
        orderId,
        purchaseId,
        paymentMethodId,
        customerId,
        clientSecret,
        createdTime,
        updatedTime,
        confirm,
        verified,
        captured,
        success,
        canceled,
        error,
        refund,
        amount,
        application,
        applicationFeeAmount,
        transferAmount,
        transferDistination,
        currency,
        emailFrom,
        emailTo,
        emailTitle,
        emailContent,
        locale,
        cancelAtPeriodEnd
      ]);

  @override
  String toString() {
    return 'StripePurchaseModel(userId: $userId, orderId: $orderId, purchaseId: $purchaseId, paymentMethodId: $paymentMethodId, customerId: $customerId, clientSecret: $clientSecret, createdTime: $createdTime, updatedTime: $updatedTime, confirm: $confirm, verified: $verified, captured: $captured, success: $success, canceled: $canceled, error: $error, refund: $refund, amount: $amount, application: $application, applicationFeeAmount: $applicationFeeAmount, transferAmount: $transferAmount, transferDistination: $transferDistination, currency: $currency, emailFrom: $emailFrom, emailTo: $emailTo, emailTitle: $emailTitle, emailContent: $emailContent, locale: $locale, cancelAtPeriodEnd: $cancelAtPeriodEnd)';
  }
}

/// @nodoc
abstract mixin class $StripePurchaseModelCopyWith<$Res> {
  factory $StripePurchaseModelCopyWith(
          StripePurchaseModel value, $Res Function(StripePurchaseModel) _then) =
      _$StripePurchaseModelCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: "user") String userId,
      @JsonKey(name: "orderId") String orderId,
      @JsonKey(name: "purchaseId") String purchaseId,
      @JsonKey(name: "paymentMethodId") String paymentMethodId,
      @JsonKey(name: "customer") String customerId,
      @JsonKey(name: "clientSecret") String clientSecret,
      @JsonKey(name: "createdTime") ModelTimestamp createdTime,
      @JsonKey(name: "updatedTime") ModelTimestamp updatedTime,
      @JsonKey(name: "confirm") bool confirm,
      @JsonKey(name: "verify") bool verified,
      @JsonKey(name: "capture") bool captured,
      @JsonKey(name: "success") bool success,
      @JsonKey(name: "cancel") bool canceled,
      @JsonKey(name: "error") bool error,
      @JsonKey(name: "refund") bool refund,
      @JsonKey(name: "amount") double amount,
      @JsonKey(name: "application") String? application,
      @JsonKey(name: "applicationFeeAmount") double applicationFeeAmount,
      @JsonKey(name: "transferAmount") double transferAmount,
      @JsonKey(name: "transferDistination") String transferDistination,
      @JsonKey(name: "currency") String currency,
      @JsonKey(name: "emailFrom") String? emailFrom,
      @JsonKey(name: "emailTo") String? emailTo,
      @JsonKey(name: "emailTitle") String? emailTitle,
      @JsonKey(name: "emailContent") String? emailContent,
      @JsonKey(name: "locale") String? locale,
      @JsonKey(name: "cancel_at_period_end") bool cancelAtPeriodEnd});
}

/// @nodoc
class _$StripePurchaseModelCopyWithImpl<$Res>
    implements $StripePurchaseModelCopyWith<$Res> {
  _$StripePurchaseModelCopyWithImpl(this._self, this._then);

  final StripePurchaseModel _self;
  final $Res Function(StripePurchaseModel) _then;

  /// Create a copy of StripePurchaseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? orderId = null,
    Object? purchaseId = null,
    Object? paymentMethodId = null,
    Object? customerId = null,
    Object? clientSecret = null,
    Object? createdTime = null,
    Object? updatedTime = null,
    Object? confirm = null,
    Object? verified = null,
    Object? captured = null,
    Object? success = null,
    Object? canceled = null,
    Object? error = null,
    Object? refund = null,
    Object? amount = null,
    Object? application = freezed,
    Object? applicationFeeAmount = null,
    Object? transferAmount = null,
    Object? transferDistination = null,
    Object? currency = null,
    Object? emailFrom = freezed,
    Object? emailTo = freezed,
    Object? emailTitle = freezed,
    Object? emailContent = freezed,
    Object? locale = freezed,
    Object? cancelAtPeriodEnd = null,
  }) {
    return _then(_self.copyWith(
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      orderId: null == orderId
          ? _self.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      purchaseId: null == purchaseId
          ? _self.purchaseId
          : purchaseId // ignore: cast_nullable_to_non_nullable
              as String,
      paymentMethodId: null == paymentMethodId
          ? _self.paymentMethodId
          : paymentMethodId // ignore: cast_nullable_to_non_nullable
              as String,
      customerId: null == customerId
          ? _self.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String,
      clientSecret: null == clientSecret
          ? _self.clientSecret
          : clientSecret // ignore: cast_nullable_to_non_nullable
              as String,
      createdTime: null == createdTime
          ? _self.createdTime
          : createdTime // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp,
      updatedTime: null == updatedTime
          ? _self.updatedTime
          : updatedTime // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp,
      confirm: null == confirm
          ? _self.confirm
          : confirm // ignore: cast_nullable_to_non_nullable
              as bool,
      verified: null == verified
          ? _self.verified
          : verified // ignore: cast_nullable_to_non_nullable
              as bool,
      captured: null == captured
          ? _self.captured
          : captured // ignore: cast_nullable_to_non_nullable
              as bool,
      success: null == success
          ? _self.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      canceled: null == canceled
          ? _self.canceled
          : canceled // ignore: cast_nullable_to_non_nullable
              as bool,
      error: null == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as bool,
      refund: null == refund
          ? _self.refund
          : refund // ignore: cast_nullable_to_non_nullable
              as bool,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      application: freezed == application
          ? _self.application
          : application // ignore: cast_nullable_to_non_nullable
              as String?,
      applicationFeeAmount: null == applicationFeeAmount
          ? _self.applicationFeeAmount
          : applicationFeeAmount // ignore: cast_nullable_to_non_nullable
              as double,
      transferAmount: null == transferAmount
          ? _self.transferAmount
          : transferAmount // ignore: cast_nullable_to_non_nullable
              as double,
      transferDistination: null == transferDistination
          ? _self.transferDistination
          : transferDistination // ignore: cast_nullable_to_non_nullable
              as String,
      currency: null == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      emailFrom: freezed == emailFrom
          ? _self.emailFrom
          : emailFrom // ignore: cast_nullable_to_non_nullable
              as String?,
      emailTo: freezed == emailTo
          ? _self.emailTo
          : emailTo // ignore: cast_nullable_to_non_nullable
              as String?,
      emailTitle: freezed == emailTitle
          ? _self.emailTitle
          : emailTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      emailContent: freezed == emailContent
          ? _self.emailContent
          : emailContent // ignore: cast_nullable_to_non_nullable
              as String?,
      locale: freezed == locale
          ? _self.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as String?,
      cancelAtPeriodEnd: null == cancelAtPeriodEnd
          ? _self.cancelAtPeriodEnd
          : cancelAtPeriodEnd // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [StripePurchaseModel].
extension StripePurchaseModelPatterns on StripePurchaseModel {
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
    TResult Function(_StripePurchaseModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _StripePurchaseModel() when $default != null:
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
    TResult Function(_StripePurchaseModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StripePurchaseModel():
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
    TResult? Function(_StripePurchaseModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StripePurchaseModel() when $default != null:
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
            @JsonKey(name: "user") String userId,
            @JsonKey(name: "orderId") String orderId,
            @JsonKey(name: "purchaseId") String purchaseId,
            @JsonKey(name: "paymentMethodId") String paymentMethodId,
            @JsonKey(name: "customer") String customerId,
            @JsonKey(name: "clientSecret") String clientSecret,
            @JsonKey(name: "createdTime") ModelTimestamp createdTime,
            @JsonKey(name: "updatedTime") ModelTimestamp updatedTime,
            @JsonKey(name: "confirm") bool confirm,
            @JsonKey(name: "verify") bool verified,
            @JsonKey(name: "capture") bool captured,
            @JsonKey(name: "success") bool success,
            @JsonKey(name: "cancel") bool canceled,
            @JsonKey(name: "error") bool error,
            @JsonKey(name: "refund") bool refund,
            @JsonKey(name: "amount") double amount,
            @JsonKey(name: "application") String? application,
            @JsonKey(name: "applicationFeeAmount") double applicationFeeAmount,
            @JsonKey(name: "transferAmount") double transferAmount,
            @JsonKey(name: "transferDistination") String transferDistination,
            @JsonKey(name: "currency") String currency,
            @JsonKey(name: "emailFrom") String? emailFrom,
            @JsonKey(name: "emailTo") String? emailTo,
            @JsonKey(name: "emailTitle") String? emailTitle,
            @JsonKey(name: "emailContent") String? emailContent,
            @JsonKey(name: "locale") String? locale,
            @JsonKey(name: "cancel_at_period_end") bool cancelAtPeriodEnd)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _StripePurchaseModel() when $default != null:
        return $default(
            _that.userId,
            _that.orderId,
            _that.purchaseId,
            _that.paymentMethodId,
            _that.customerId,
            _that.clientSecret,
            _that.createdTime,
            _that.updatedTime,
            _that.confirm,
            _that.verified,
            _that.captured,
            _that.success,
            _that.canceled,
            _that.error,
            _that.refund,
            _that.amount,
            _that.application,
            _that.applicationFeeAmount,
            _that.transferAmount,
            _that.transferDistination,
            _that.currency,
            _that.emailFrom,
            _that.emailTo,
            _that.emailTitle,
            _that.emailContent,
            _that.locale,
            _that.cancelAtPeriodEnd);
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
            @JsonKey(name: "user") String userId,
            @JsonKey(name: "orderId") String orderId,
            @JsonKey(name: "purchaseId") String purchaseId,
            @JsonKey(name: "paymentMethodId") String paymentMethodId,
            @JsonKey(name: "customer") String customerId,
            @JsonKey(name: "clientSecret") String clientSecret,
            @JsonKey(name: "createdTime") ModelTimestamp createdTime,
            @JsonKey(name: "updatedTime") ModelTimestamp updatedTime,
            @JsonKey(name: "confirm") bool confirm,
            @JsonKey(name: "verify") bool verified,
            @JsonKey(name: "capture") bool captured,
            @JsonKey(name: "success") bool success,
            @JsonKey(name: "cancel") bool canceled,
            @JsonKey(name: "error") bool error,
            @JsonKey(name: "refund") bool refund,
            @JsonKey(name: "amount") double amount,
            @JsonKey(name: "application") String? application,
            @JsonKey(name: "applicationFeeAmount") double applicationFeeAmount,
            @JsonKey(name: "transferAmount") double transferAmount,
            @JsonKey(name: "transferDistination") String transferDistination,
            @JsonKey(name: "currency") String currency,
            @JsonKey(name: "emailFrom") String? emailFrom,
            @JsonKey(name: "emailTo") String? emailTo,
            @JsonKey(name: "emailTitle") String? emailTitle,
            @JsonKey(name: "emailContent") String? emailContent,
            @JsonKey(name: "locale") String? locale,
            @JsonKey(name: "cancel_at_period_end") bool cancelAtPeriodEnd)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StripePurchaseModel():
        return $default(
            _that.userId,
            _that.orderId,
            _that.purchaseId,
            _that.paymentMethodId,
            _that.customerId,
            _that.clientSecret,
            _that.createdTime,
            _that.updatedTime,
            _that.confirm,
            _that.verified,
            _that.captured,
            _that.success,
            _that.canceled,
            _that.error,
            _that.refund,
            _that.amount,
            _that.application,
            _that.applicationFeeAmount,
            _that.transferAmount,
            _that.transferDistination,
            _that.currency,
            _that.emailFrom,
            _that.emailTo,
            _that.emailTitle,
            _that.emailContent,
            _that.locale,
            _that.cancelAtPeriodEnd);
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
            @JsonKey(name: "user") String userId,
            @JsonKey(name: "orderId") String orderId,
            @JsonKey(name: "purchaseId") String purchaseId,
            @JsonKey(name: "paymentMethodId") String paymentMethodId,
            @JsonKey(name: "customer") String customerId,
            @JsonKey(name: "clientSecret") String clientSecret,
            @JsonKey(name: "createdTime") ModelTimestamp createdTime,
            @JsonKey(name: "updatedTime") ModelTimestamp updatedTime,
            @JsonKey(name: "confirm") bool confirm,
            @JsonKey(name: "verify") bool verified,
            @JsonKey(name: "capture") bool captured,
            @JsonKey(name: "success") bool success,
            @JsonKey(name: "cancel") bool canceled,
            @JsonKey(name: "error") bool error,
            @JsonKey(name: "refund") bool refund,
            @JsonKey(name: "amount") double amount,
            @JsonKey(name: "application") String? application,
            @JsonKey(name: "applicationFeeAmount") double applicationFeeAmount,
            @JsonKey(name: "transferAmount") double transferAmount,
            @JsonKey(name: "transferDistination") String transferDistination,
            @JsonKey(name: "currency") String currency,
            @JsonKey(name: "emailFrom") String? emailFrom,
            @JsonKey(name: "emailTo") String? emailTo,
            @JsonKey(name: "emailTitle") String? emailTitle,
            @JsonKey(name: "emailContent") String? emailContent,
            @JsonKey(name: "locale") String? locale,
            @JsonKey(name: "cancel_at_period_end") bool cancelAtPeriodEnd)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StripePurchaseModel() when $default != null:
        return $default(
            _that.userId,
            _that.orderId,
            _that.purchaseId,
            _that.paymentMethodId,
            _that.customerId,
            _that.clientSecret,
            _that.createdTime,
            _that.updatedTime,
            _that.confirm,
            _that.verified,
            _that.captured,
            _that.success,
            _that.canceled,
            _that.error,
            _that.refund,
            _that.amount,
            _that.application,
            _that.applicationFeeAmount,
            _that.transferAmount,
            _that.transferDistination,
            _that.currency,
            _that.emailFrom,
            _that.emailTo,
            _that.emailTitle,
            _that.emailContent,
            _that.locale,
            _that.cancelAtPeriodEnd);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _StripePurchaseModel extends StripePurchaseModel {
  const _StripePurchaseModel(
      {@JsonKey(name: "user") required this.userId,
      @JsonKey(name: "orderId") required this.orderId,
      @JsonKey(name: "purchaseId") required this.purchaseId,
      @JsonKey(name: "paymentMethodId") required this.paymentMethodId,
      @JsonKey(name: "customer") required this.customerId,
      @JsonKey(name: "clientSecret") required this.clientSecret,
      @JsonKey(name: "createdTime") required this.createdTime,
      @JsonKey(name: "updatedTime") required this.updatedTime,
      @JsonKey(name: "confirm") this.confirm = false,
      @JsonKey(name: "verify") this.verified = false,
      @JsonKey(name: "capture") this.captured = false,
      @JsonKey(name: "success") this.success = false,
      @JsonKey(name: "cancel") this.canceled = false,
      @JsonKey(name: "error") this.error = false,
      @JsonKey(name: "refund") this.refund = false,
      @JsonKey(name: "amount") this.amount = 0.0,
      @JsonKey(name: "application") this.application,
      @JsonKey(name: "applicationFeeAmount") this.applicationFeeAmount = 0.0,
      @JsonKey(name: "transferAmount") this.transferAmount = 0.0,
      @JsonKey(name: "transferDistination") this.transferDistination = "",
      @JsonKey(name: "currency") this.currency = "jpy",
      @JsonKey(name: "emailFrom") this.emailFrom,
      @JsonKey(name: "emailTo") this.emailTo,
      @JsonKey(name: "emailTitle") this.emailTitle,
      @JsonKey(name: "emailContent") this.emailContent,
      @JsonKey(name: "locale") this.locale,
      @JsonKey(name: "cancel_at_period_end") this.cancelAtPeriodEnd = false})
      : super._();
  factory _StripePurchaseModel.fromJson(Map<String, dynamic> json) =>
      _$StripePurchaseModelFromJson(json);

  @override
  @JsonKey(name: "user")
  final String userId;
  @override
  @JsonKey(name: "orderId")
  final String orderId;
  @override
  @JsonKey(name: "purchaseId")
  final String purchaseId;
  @override
  @JsonKey(name: "paymentMethodId")
  final String paymentMethodId;
  @override
  @JsonKey(name: "customer")
  final String customerId;
  @override
  @JsonKey(name: "clientSecret")
  final String clientSecret;
  @override
  @JsonKey(name: "createdTime")
  final ModelTimestamp createdTime;
  @override
  @JsonKey(name: "updatedTime")
  final ModelTimestamp updatedTime;
  @override
  @JsonKey(name: "confirm")
  final bool confirm;
  @override
  @JsonKey(name: "verify")
  final bool verified;
  @override
  @JsonKey(name: "capture")
  final bool captured;
  @override
  @JsonKey(name: "success")
  final bool success;
  @override
  @JsonKey(name: "cancel")
  final bool canceled;
  @override
  @JsonKey(name: "error")
  final bool error;
  @override
  @JsonKey(name: "refund")
  final bool refund;
  @override
  @JsonKey(name: "amount")
  final double amount;
  @override
  @JsonKey(name: "application")
  final String? application;
  @override
  @JsonKey(name: "applicationFeeAmount")
  final double applicationFeeAmount;
  @override
  @JsonKey(name: "transferAmount")
  final double transferAmount;
  @override
  @JsonKey(name: "transferDistination")
  final String transferDistination;
  @override
  @JsonKey(name: "currency")
  final String currency;
  @override
  @JsonKey(name: "emailFrom")
  final String? emailFrom;
  @override
  @JsonKey(name: "emailTo")
  final String? emailTo;
  @override
  @JsonKey(name: "emailTitle")
  final String? emailTitle;
  @override
  @JsonKey(name: "emailContent")
  final String? emailContent;
  @override
  @JsonKey(name: "locale")
  final String? locale;
  @override
  @JsonKey(name: "cancel_at_period_end")
  final bool cancelAtPeriodEnd;

  /// Create a copy of StripePurchaseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$StripePurchaseModelCopyWith<_StripePurchaseModel> get copyWith =>
      __$StripePurchaseModelCopyWithImpl<_StripePurchaseModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$StripePurchaseModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _StripePurchaseModel &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.purchaseId, purchaseId) ||
                other.purchaseId == purchaseId) &&
            (identical(other.paymentMethodId, paymentMethodId) ||
                other.paymentMethodId == paymentMethodId) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.clientSecret, clientSecret) ||
                other.clientSecret == clientSecret) &&
            (identical(other.createdTime, createdTime) ||
                other.createdTime == createdTime) &&
            (identical(other.updatedTime, updatedTime) ||
                other.updatedTime == updatedTime) &&
            (identical(other.confirm, confirm) || other.confirm == confirm) &&
            (identical(other.verified, verified) ||
                other.verified == verified) &&
            (identical(other.captured, captured) ||
                other.captured == captured) &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.canceled, canceled) ||
                other.canceled == canceled) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.refund, refund) || other.refund == refund) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.application, application) ||
                other.application == application) &&
            (identical(other.applicationFeeAmount, applicationFeeAmount) ||
                other.applicationFeeAmount == applicationFeeAmount) &&
            (identical(other.transferAmount, transferAmount) ||
                other.transferAmount == transferAmount) &&
            (identical(other.transferDistination, transferDistination) ||
                other.transferDistination == transferDistination) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.emailFrom, emailFrom) ||
                other.emailFrom == emailFrom) &&
            (identical(other.emailTo, emailTo) || other.emailTo == emailTo) &&
            (identical(other.emailTitle, emailTitle) ||
                other.emailTitle == emailTitle) &&
            (identical(other.emailContent, emailContent) ||
                other.emailContent == emailContent) &&
            (identical(other.locale, locale) || other.locale == locale) &&
            (identical(other.cancelAtPeriodEnd, cancelAtPeriodEnd) ||
                other.cancelAtPeriodEnd == cancelAtPeriodEnd));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        userId,
        orderId,
        purchaseId,
        paymentMethodId,
        customerId,
        clientSecret,
        createdTime,
        updatedTime,
        confirm,
        verified,
        captured,
        success,
        canceled,
        error,
        refund,
        amount,
        application,
        applicationFeeAmount,
        transferAmount,
        transferDistination,
        currency,
        emailFrom,
        emailTo,
        emailTitle,
        emailContent,
        locale,
        cancelAtPeriodEnd
      ]);

  @override
  String toString() {
    return 'StripePurchaseModel(userId: $userId, orderId: $orderId, purchaseId: $purchaseId, paymentMethodId: $paymentMethodId, customerId: $customerId, clientSecret: $clientSecret, createdTime: $createdTime, updatedTime: $updatedTime, confirm: $confirm, verified: $verified, captured: $captured, success: $success, canceled: $canceled, error: $error, refund: $refund, amount: $amount, application: $application, applicationFeeAmount: $applicationFeeAmount, transferAmount: $transferAmount, transferDistination: $transferDistination, currency: $currency, emailFrom: $emailFrom, emailTo: $emailTo, emailTitle: $emailTitle, emailContent: $emailContent, locale: $locale, cancelAtPeriodEnd: $cancelAtPeriodEnd)';
  }
}

/// @nodoc
abstract mixin class _$StripePurchaseModelCopyWith<$Res>
    implements $StripePurchaseModelCopyWith<$Res> {
  factory _$StripePurchaseModelCopyWith(_StripePurchaseModel value,
          $Res Function(_StripePurchaseModel) _then) =
      __$StripePurchaseModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "user") String userId,
      @JsonKey(name: "orderId") String orderId,
      @JsonKey(name: "purchaseId") String purchaseId,
      @JsonKey(name: "paymentMethodId") String paymentMethodId,
      @JsonKey(name: "customer") String customerId,
      @JsonKey(name: "clientSecret") String clientSecret,
      @JsonKey(name: "createdTime") ModelTimestamp createdTime,
      @JsonKey(name: "updatedTime") ModelTimestamp updatedTime,
      @JsonKey(name: "confirm") bool confirm,
      @JsonKey(name: "verify") bool verified,
      @JsonKey(name: "capture") bool captured,
      @JsonKey(name: "success") bool success,
      @JsonKey(name: "cancel") bool canceled,
      @JsonKey(name: "error") bool error,
      @JsonKey(name: "refund") bool refund,
      @JsonKey(name: "amount") double amount,
      @JsonKey(name: "application") String? application,
      @JsonKey(name: "applicationFeeAmount") double applicationFeeAmount,
      @JsonKey(name: "transferAmount") double transferAmount,
      @JsonKey(name: "transferDistination") String transferDistination,
      @JsonKey(name: "currency") String currency,
      @JsonKey(name: "emailFrom") String? emailFrom,
      @JsonKey(name: "emailTo") String? emailTo,
      @JsonKey(name: "emailTitle") String? emailTitle,
      @JsonKey(name: "emailContent") String? emailContent,
      @JsonKey(name: "locale") String? locale,
      @JsonKey(name: "cancel_at_period_end") bool cancelAtPeriodEnd});
}

/// @nodoc
class __$StripePurchaseModelCopyWithImpl<$Res>
    implements _$StripePurchaseModelCopyWith<$Res> {
  __$StripePurchaseModelCopyWithImpl(this._self, this._then);

  final _StripePurchaseModel _self;
  final $Res Function(_StripePurchaseModel) _then;

  /// Create a copy of StripePurchaseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? userId = null,
    Object? orderId = null,
    Object? purchaseId = null,
    Object? paymentMethodId = null,
    Object? customerId = null,
    Object? clientSecret = null,
    Object? createdTime = null,
    Object? updatedTime = null,
    Object? confirm = null,
    Object? verified = null,
    Object? captured = null,
    Object? success = null,
    Object? canceled = null,
    Object? error = null,
    Object? refund = null,
    Object? amount = null,
    Object? application = freezed,
    Object? applicationFeeAmount = null,
    Object? transferAmount = null,
    Object? transferDistination = null,
    Object? currency = null,
    Object? emailFrom = freezed,
    Object? emailTo = freezed,
    Object? emailTitle = freezed,
    Object? emailContent = freezed,
    Object? locale = freezed,
    Object? cancelAtPeriodEnd = null,
  }) {
    return _then(_StripePurchaseModel(
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      orderId: null == orderId
          ? _self.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      purchaseId: null == purchaseId
          ? _self.purchaseId
          : purchaseId // ignore: cast_nullable_to_non_nullable
              as String,
      paymentMethodId: null == paymentMethodId
          ? _self.paymentMethodId
          : paymentMethodId // ignore: cast_nullable_to_non_nullable
              as String,
      customerId: null == customerId
          ? _self.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String,
      clientSecret: null == clientSecret
          ? _self.clientSecret
          : clientSecret // ignore: cast_nullable_to_non_nullable
              as String,
      createdTime: null == createdTime
          ? _self.createdTime
          : createdTime // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp,
      updatedTime: null == updatedTime
          ? _self.updatedTime
          : updatedTime // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp,
      confirm: null == confirm
          ? _self.confirm
          : confirm // ignore: cast_nullable_to_non_nullable
              as bool,
      verified: null == verified
          ? _self.verified
          : verified // ignore: cast_nullable_to_non_nullable
              as bool,
      captured: null == captured
          ? _self.captured
          : captured // ignore: cast_nullable_to_non_nullable
              as bool,
      success: null == success
          ? _self.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      canceled: null == canceled
          ? _self.canceled
          : canceled // ignore: cast_nullable_to_non_nullable
              as bool,
      error: null == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as bool,
      refund: null == refund
          ? _self.refund
          : refund // ignore: cast_nullable_to_non_nullable
              as bool,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      application: freezed == application
          ? _self.application
          : application // ignore: cast_nullable_to_non_nullable
              as String?,
      applicationFeeAmount: null == applicationFeeAmount
          ? _self.applicationFeeAmount
          : applicationFeeAmount // ignore: cast_nullable_to_non_nullable
              as double,
      transferAmount: null == transferAmount
          ? _self.transferAmount
          : transferAmount // ignore: cast_nullable_to_non_nullable
              as double,
      transferDistination: null == transferDistination
          ? _self.transferDistination
          : transferDistination // ignore: cast_nullable_to_non_nullable
              as String,
      currency: null == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      emailFrom: freezed == emailFrom
          ? _self.emailFrom
          : emailFrom // ignore: cast_nullable_to_non_nullable
              as String?,
      emailTo: freezed == emailTo
          ? _self.emailTo
          : emailTo // ignore: cast_nullable_to_non_nullable
              as String?,
      emailTitle: freezed == emailTitle
          ? _self.emailTitle
          : emailTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      emailContent: freezed == emailContent
          ? _self.emailContent
          : emailContent // ignore: cast_nullable_to_non_nullable
              as String?,
      locale: freezed == locale
          ? _self.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as String?,
      cancelAtPeriodEnd: null == cancelAtPeriodEnd
          ? _self.cancelAtPeriodEnd
          : cancelAtPeriodEnd // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
