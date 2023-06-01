// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stripe_purchase.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

StripePurchaseModel _$StripePurchaseModelFromJson(Map<String, dynamic> json) {
  return _StripePurchaseModel.fromJson(json);
}

/// @nodoc
mixin _$StripePurchaseModel {
  @JsonKey(name: "user")
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: "confirm")
  bool get confirm => throw _privateConstructorUsedError;
  @JsonKey(name: "verify")
  bool get verified => throw _privateConstructorUsedError;
  @JsonKey(name: "capture")
  bool get captured => throw _privateConstructorUsedError;
  @JsonKey(name: "success")
  bool get success => throw _privateConstructorUsedError;
  @JsonKey(name: "cancel")
  bool get canceled => throw _privateConstructorUsedError;
  @JsonKey(name: "error")
  bool get error => throw _privateConstructorUsedError;
  @JsonKey(name: "refund")
  bool get refund => throw _privateConstructorUsedError;
  @JsonKey(name: "orderId")
  String get orderId => throw _privateConstructorUsedError;
  @JsonKey(name: "purchaseId")
  String get purchaseId => throw _privateConstructorUsedError;
  @JsonKey(name: "paymentMethodId")
  String get paymentMethodId => throw _privateConstructorUsedError;
  @JsonKey(name: "customer")
  String get customerId => throw _privateConstructorUsedError;
  @JsonKey(name: "amount")
  double get amount => throw _privateConstructorUsedError;
  @JsonKey(name: "application")
  String? get application => throw _privateConstructorUsedError;
  @JsonKey(name: "applicationFeeAmount")
  double get applicationFeeAmount => throw _privateConstructorUsedError;
  @JsonKey(name: "transferAmount")
  double get transferAmount => throw _privateConstructorUsedError;
  @JsonKey(name: "transferDistination")
  String get transferDistination => throw _privateConstructorUsedError;
  @JsonKey(name: "currency")
  String get currency => throw _privateConstructorUsedError;
  @JsonKey(name: "clientSecret")
  String get clientSecret => throw _privateConstructorUsedError;
  @JsonKey(name: "createdTime")
  ModelTimestamp get createdTime => throw _privateConstructorUsedError;
  @JsonKey(name: "updatedTime")
  ModelTimestamp get updatedTime => throw _privateConstructorUsedError;
  @JsonKey(name: "emailFrom")
  String? get emailFrom => throw _privateConstructorUsedError;
  @JsonKey(name: "emailTo")
  String? get emailTo => throw _privateConstructorUsedError;
  @JsonKey(name: "emailTitle")
  String? get emailTitle => throw _privateConstructorUsedError;
  @JsonKey(name: "emailContent")
  String? get emailContent => throw _privateConstructorUsedError;
  @JsonKey(name: "locale")
  String? get locale => throw _privateConstructorUsedError;
  @JsonKey(name: "cancel_at_period_end")
  bool get cancelAtPeriodEnd => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StripePurchaseModelCopyWith<StripePurchaseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StripePurchaseModelCopyWith<$Res> {
  factory $StripePurchaseModelCopyWith(
          StripePurchaseModel value, $Res Function(StripePurchaseModel) then) =
      _$StripePurchaseModelCopyWithImpl<$Res, StripePurchaseModel>;
  @useResult
  $Res call(
      {@JsonKey(name: "user") String userId,
      @JsonKey(name: "confirm") bool confirm,
      @JsonKey(name: "verify") bool verified,
      @JsonKey(name: "capture") bool captured,
      @JsonKey(name: "success") bool success,
      @JsonKey(name: "cancel") bool canceled,
      @JsonKey(name: "error") bool error,
      @JsonKey(name: "refund") bool refund,
      @JsonKey(name: "orderId") String orderId,
      @JsonKey(name: "purchaseId") String purchaseId,
      @JsonKey(name: "paymentMethodId") String paymentMethodId,
      @JsonKey(name: "customer") String customerId,
      @JsonKey(name: "amount") double amount,
      @JsonKey(name: "application") String? application,
      @JsonKey(name: "applicationFeeAmount") double applicationFeeAmount,
      @JsonKey(name: "transferAmount") double transferAmount,
      @JsonKey(name: "transferDistination") String transferDistination,
      @JsonKey(name: "currency") String currency,
      @JsonKey(name: "clientSecret") String clientSecret,
      @JsonKey(name: "createdTime") ModelTimestamp createdTime,
      @JsonKey(name: "updatedTime") ModelTimestamp updatedTime,
      @JsonKey(name: "emailFrom") String? emailFrom,
      @JsonKey(name: "emailTo") String? emailTo,
      @JsonKey(name: "emailTitle") String? emailTitle,
      @JsonKey(name: "emailContent") String? emailContent,
      @JsonKey(name: "locale") String? locale,
      @JsonKey(name: "cancel_at_period_end") bool cancelAtPeriodEnd});
}

/// @nodoc
class _$StripePurchaseModelCopyWithImpl<$Res, $Val extends StripePurchaseModel>
    implements $StripePurchaseModelCopyWith<$Res> {
  _$StripePurchaseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? confirm = null,
    Object? verified = null,
    Object? captured = null,
    Object? success = null,
    Object? canceled = null,
    Object? error = null,
    Object? refund = null,
    Object? orderId = null,
    Object? purchaseId = null,
    Object? paymentMethodId = null,
    Object? customerId = null,
    Object? amount = null,
    Object? application = freezed,
    Object? applicationFeeAmount = null,
    Object? transferAmount = null,
    Object? transferDistination = null,
    Object? currency = null,
    Object? clientSecret = null,
    Object? createdTime = null,
    Object? updatedTime = null,
    Object? emailFrom = freezed,
    Object? emailTo = freezed,
    Object? emailTitle = freezed,
    Object? emailContent = freezed,
    Object? locale = freezed,
    Object? cancelAtPeriodEnd = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      confirm: null == confirm
          ? _value.confirm
          : confirm // ignore: cast_nullable_to_non_nullable
              as bool,
      verified: null == verified
          ? _value.verified
          : verified // ignore: cast_nullable_to_non_nullable
              as bool,
      captured: null == captured
          ? _value.captured
          : captured // ignore: cast_nullable_to_non_nullable
              as bool,
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      canceled: null == canceled
          ? _value.canceled
          : canceled // ignore: cast_nullable_to_non_nullable
              as bool,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as bool,
      refund: null == refund
          ? _value.refund
          : refund // ignore: cast_nullable_to_non_nullable
              as bool,
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      purchaseId: null == purchaseId
          ? _value.purchaseId
          : purchaseId // ignore: cast_nullable_to_non_nullable
              as String,
      paymentMethodId: null == paymentMethodId
          ? _value.paymentMethodId
          : paymentMethodId // ignore: cast_nullable_to_non_nullable
              as String,
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      application: freezed == application
          ? _value.application
          : application // ignore: cast_nullable_to_non_nullable
              as String?,
      applicationFeeAmount: null == applicationFeeAmount
          ? _value.applicationFeeAmount
          : applicationFeeAmount // ignore: cast_nullable_to_non_nullable
              as double,
      transferAmount: null == transferAmount
          ? _value.transferAmount
          : transferAmount // ignore: cast_nullable_to_non_nullable
              as double,
      transferDistination: null == transferDistination
          ? _value.transferDistination
          : transferDistination // ignore: cast_nullable_to_non_nullable
              as String,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      clientSecret: null == clientSecret
          ? _value.clientSecret
          : clientSecret // ignore: cast_nullable_to_non_nullable
              as String,
      createdTime: null == createdTime
          ? _value.createdTime
          : createdTime // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp,
      updatedTime: null == updatedTime
          ? _value.updatedTime
          : updatedTime // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp,
      emailFrom: freezed == emailFrom
          ? _value.emailFrom
          : emailFrom // ignore: cast_nullable_to_non_nullable
              as String?,
      emailTo: freezed == emailTo
          ? _value.emailTo
          : emailTo // ignore: cast_nullable_to_non_nullable
              as String?,
      emailTitle: freezed == emailTitle
          ? _value.emailTitle
          : emailTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      emailContent: freezed == emailContent
          ? _value.emailContent
          : emailContent // ignore: cast_nullable_to_non_nullable
              as String?,
      locale: freezed == locale
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as String?,
      cancelAtPeriodEnd: null == cancelAtPeriodEnd
          ? _value.cancelAtPeriodEnd
          : cancelAtPeriodEnd // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_StripePurchaseModelCopyWith<$Res>
    implements $StripePurchaseModelCopyWith<$Res> {
  factory _$$_StripePurchaseModelCopyWith(_$_StripePurchaseModel value,
          $Res Function(_$_StripePurchaseModel) then) =
      __$$_StripePurchaseModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "user") String userId,
      @JsonKey(name: "confirm") bool confirm,
      @JsonKey(name: "verify") bool verified,
      @JsonKey(name: "capture") bool captured,
      @JsonKey(name: "success") bool success,
      @JsonKey(name: "cancel") bool canceled,
      @JsonKey(name: "error") bool error,
      @JsonKey(name: "refund") bool refund,
      @JsonKey(name: "orderId") String orderId,
      @JsonKey(name: "purchaseId") String purchaseId,
      @JsonKey(name: "paymentMethodId") String paymentMethodId,
      @JsonKey(name: "customer") String customerId,
      @JsonKey(name: "amount") double amount,
      @JsonKey(name: "application") String? application,
      @JsonKey(name: "applicationFeeAmount") double applicationFeeAmount,
      @JsonKey(name: "transferAmount") double transferAmount,
      @JsonKey(name: "transferDistination") String transferDistination,
      @JsonKey(name: "currency") String currency,
      @JsonKey(name: "clientSecret") String clientSecret,
      @JsonKey(name: "createdTime") ModelTimestamp createdTime,
      @JsonKey(name: "updatedTime") ModelTimestamp updatedTime,
      @JsonKey(name: "emailFrom") String? emailFrom,
      @JsonKey(name: "emailTo") String? emailTo,
      @JsonKey(name: "emailTitle") String? emailTitle,
      @JsonKey(name: "emailContent") String? emailContent,
      @JsonKey(name: "locale") String? locale,
      @JsonKey(name: "cancel_at_period_end") bool cancelAtPeriodEnd});
}

/// @nodoc
class __$$_StripePurchaseModelCopyWithImpl<$Res>
    extends _$StripePurchaseModelCopyWithImpl<$Res, _$_StripePurchaseModel>
    implements _$$_StripePurchaseModelCopyWith<$Res> {
  __$$_StripePurchaseModelCopyWithImpl(_$_StripePurchaseModel _value,
      $Res Function(_$_StripePurchaseModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? confirm = null,
    Object? verified = null,
    Object? captured = null,
    Object? success = null,
    Object? canceled = null,
    Object? error = null,
    Object? refund = null,
    Object? orderId = null,
    Object? purchaseId = null,
    Object? paymentMethodId = null,
    Object? customerId = null,
    Object? amount = null,
    Object? application = freezed,
    Object? applicationFeeAmount = null,
    Object? transferAmount = null,
    Object? transferDistination = null,
    Object? currency = null,
    Object? clientSecret = null,
    Object? createdTime = null,
    Object? updatedTime = null,
    Object? emailFrom = freezed,
    Object? emailTo = freezed,
    Object? emailTitle = freezed,
    Object? emailContent = freezed,
    Object? locale = freezed,
    Object? cancelAtPeriodEnd = null,
  }) {
    return _then(_$_StripePurchaseModel(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      confirm: null == confirm
          ? _value.confirm
          : confirm // ignore: cast_nullable_to_non_nullable
              as bool,
      verified: null == verified
          ? _value.verified
          : verified // ignore: cast_nullable_to_non_nullable
              as bool,
      captured: null == captured
          ? _value.captured
          : captured // ignore: cast_nullable_to_non_nullable
              as bool,
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      canceled: null == canceled
          ? _value.canceled
          : canceled // ignore: cast_nullable_to_non_nullable
              as bool,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as bool,
      refund: null == refund
          ? _value.refund
          : refund // ignore: cast_nullable_to_non_nullable
              as bool,
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      purchaseId: null == purchaseId
          ? _value.purchaseId
          : purchaseId // ignore: cast_nullable_to_non_nullable
              as String,
      paymentMethodId: null == paymentMethodId
          ? _value.paymentMethodId
          : paymentMethodId // ignore: cast_nullable_to_non_nullable
              as String,
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      application: freezed == application
          ? _value.application
          : application // ignore: cast_nullable_to_non_nullable
              as String?,
      applicationFeeAmount: null == applicationFeeAmount
          ? _value.applicationFeeAmount
          : applicationFeeAmount // ignore: cast_nullable_to_non_nullable
              as double,
      transferAmount: null == transferAmount
          ? _value.transferAmount
          : transferAmount // ignore: cast_nullable_to_non_nullable
              as double,
      transferDistination: null == transferDistination
          ? _value.transferDistination
          : transferDistination // ignore: cast_nullable_to_non_nullable
              as String,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      clientSecret: null == clientSecret
          ? _value.clientSecret
          : clientSecret // ignore: cast_nullable_to_non_nullable
              as String,
      createdTime: null == createdTime
          ? _value.createdTime
          : createdTime // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp,
      updatedTime: null == updatedTime
          ? _value.updatedTime
          : updatedTime // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp,
      emailFrom: freezed == emailFrom
          ? _value.emailFrom
          : emailFrom // ignore: cast_nullable_to_non_nullable
              as String?,
      emailTo: freezed == emailTo
          ? _value.emailTo
          : emailTo // ignore: cast_nullable_to_non_nullable
              as String?,
      emailTitle: freezed == emailTitle
          ? _value.emailTitle
          : emailTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      emailContent: freezed == emailContent
          ? _value.emailContent
          : emailContent // ignore: cast_nullable_to_non_nullable
              as String?,
      locale: freezed == locale
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as String?,
      cancelAtPeriodEnd: null == cancelAtPeriodEnd
          ? _value.cancelAtPeriodEnd
          : cancelAtPeriodEnd // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_StripePurchaseModel extends _StripePurchaseModel {
  const _$_StripePurchaseModel(
      {@JsonKey(name: "user") required this.userId,
      @JsonKey(name: "confirm") this.confirm = false,
      @JsonKey(name: "verify") this.verified = false,
      @JsonKey(name: "capture") this.captured = false,
      @JsonKey(name: "success") this.success = false,
      @JsonKey(name: "cancel") this.canceled = false,
      @JsonKey(name: "error") this.error = false,
      @JsonKey(name: "refund") this.refund = false,
      @JsonKey(name: "orderId") required this.orderId,
      @JsonKey(name: "purchaseId") required this.purchaseId,
      @JsonKey(name: "paymentMethodId") required this.paymentMethodId,
      @JsonKey(name: "customer") required this.customerId,
      @JsonKey(name: "amount") this.amount = 0.0,
      @JsonKey(name: "application") this.application,
      @JsonKey(name: "applicationFeeAmount") this.applicationFeeAmount = 0.0,
      @JsonKey(name: "transferAmount") this.transferAmount = 0.0,
      @JsonKey(name: "transferDistination") this.transferDistination = "",
      @JsonKey(name: "currency") this.currency = "jpy",
      @JsonKey(name: "clientSecret") required this.clientSecret,
      @JsonKey(name: "createdTime") required this.createdTime,
      @JsonKey(name: "updatedTime") required this.updatedTime,
      @JsonKey(name: "emailFrom") this.emailFrom,
      @JsonKey(name: "emailTo") this.emailTo,
      @JsonKey(name: "emailTitle") this.emailTitle,
      @JsonKey(name: "emailContent") this.emailContent,
      @JsonKey(name: "locale") this.locale,
      @JsonKey(name: "cancel_at_period_end") this.cancelAtPeriodEnd = false})
      : super._();

  factory _$_StripePurchaseModel.fromJson(Map<String, dynamic> json) =>
      _$$_StripePurchaseModelFromJson(json);

  @override
  @JsonKey(name: "user")
  final String userId;
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
  @JsonKey(name: "clientSecret")
  final String clientSecret;
  @override
  @JsonKey(name: "createdTime")
  final ModelTimestamp createdTime;
  @override
  @JsonKey(name: "updatedTime")
  final ModelTimestamp updatedTime;
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

  @override
  String toString() {
    return 'StripePurchaseModel(userId: $userId, confirm: $confirm, verified: $verified, captured: $captured, success: $success, canceled: $canceled, error: $error, refund: $refund, orderId: $orderId, purchaseId: $purchaseId, paymentMethodId: $paymentMethodId, customerId: $customerId, amount: $amount, application: $application, applicationFeeAmount: $applicationFeeAmount, transferAmount: $transferAmount, transferDistination: $transferDistination, currency: $currency, clientSecret: $clientSecret, createdTime: $createdTime, updatedTime: $updatedTime, emailFrom: $emailFrom, emailTo: $emailTo, emailTitle: $emailTitle, emailContent: $emailContent, locale: $locale, cancelAtPeriodEnd: $cancelAtPeriodEnd)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_StripePurchaseModel &&
            (identical(other.userId, userId) || other.userId == userId) &&
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
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.purchaseId, purchaseId) ||
                other.purchaseId == purchaseId) &&
            (identical(other.paymentMethodId, paymentMethodId) ||
                other.paymentMethodId == paymentMethodId) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
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
            (identical(other.clientSecret, clientSecret) ||
                other.clientSecret == clientSecret) &&
            (identical(other.createdTime, createdTime) ||
                other.createdTime == createdTime) &&
            (identical(other.updatedTime, updatedTime) ||
                other.updatedTime == updatedTime) &&
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

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        userId,
        confirm,
        verified,
        captured,
        success,
        canceled,
        error,
        refund,
        orderId,
        purchaseId,
        paymentMethodId,
        customerId,
        amount,
        application,
        applicationFeeAmount,
        transferAmount,
        transferDistination,
        currency,
        clientSecret,
        createdTime,
        updatedTime,
        emailFrom,
        emailTo,
        emailTitle,
        emailContent,
        locale,
        cancelAtPeriodEnd
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_StripePurchaseModelCopyWith<_$_StripePurchaseModel> get copyWith =>
      __$$_StripePurchaseModelCopyWithImpl<_$_StripePurchaseModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_StripePurchaseModelToJson(
      this,
    );
  }
}

abstract class _StripePurchaseModel extends StripePurchaseModel {
  const factory _StripePurchaseModel(
      {@JsonKey(name: "user")
          required final String userId,
      @JsonKey(name: "confirm")
          final bool confirm,
      @JsonKey(name: "verify")
          final bool verified,
      @JsonKey(name: "capture")
          final bool captured,
      @JsonKey(name: "success")
          final bool success,
      @JsonKey(name: "cancel")
          final bool canceled,
      @JsonKey(name: "error")
          final bool error,
      @JsonKey(name: "refund")
          final bool refund,
      @JsonKey(name: "orderId")
          required final String orderId,
      @JsonKey(name: "purchaseId")
          required final String purchaseId,
      @JsonKey(name: "paymentMethodId")
          required final String paymentMethodId,
      @JsonKey(name: "customer")
          required final String customerId,
      @JsonKey(name: "amount")
          final double amount,
      @JsonKey(name: "application")
          final String? application,
      @JsonKey(name: "applicationFeeAmount")
          final double applicationFeeAmount,
      @JsonKey(name: "transferAmount")
          final double transferAmount,
      @JsonKey(name: "transferDistination")
          final String transferDistination,
      @JsonKey(name: "currency")
          final String currency,
      @JsonKey(name: "clientSecret")
          required final String clientSecret,
      @JsonKey(name: "createdTime")
          required final ModelTimestamp createdTime,
      @JsonKey(name: "updatedTime")
          required final ModelTimestamp updatedTime,
      @JsonKey(name: "emailFrom")
          final String? emailFrom,
      @JsonKey(name: "emailTo")
          final String? emailTo,
      @JsonKey(name: "emailTitle")
          final String? emailTitle,
      @JsonKey(name: "emailContent")
          final String? emailContent,
      @JsonKey(name: "locale")
          final String? locale,
      @JsonKey(name: "cancel_at_period_end")
          final bool cancelAtPeriodEnd}) = _$_StripePurchaseModel;
  const _StripePurchaseModel._() : super._();

  factory _StripePurchaseModel.fromJson(Map<String, dynamic> json) =
      _$_StripePurchaseModel.fromJson;

  @override
  @JsonKey(name: "user")
  String get userId;
  @override
  @JsonKey(name: "confirm")
  bool get confirm;
  @override
  @JsonKey(name: "verify")
  bool get verified;
  @override
  @JsonKey(name: "capture")
  bool get captured;
  @override
  @JsonKey(name: "success")
  bool get success;
  @override
  @JsonKey(name: "cancel")
  bool get canceled;
  @override
  @JsonKey(name: "error")
  bool get error;
  @override
  @JsonKey(name: "refund")
  bool get refund;
  @override
  @JsonKey(name: "orderId")
  String get orderId;
  @override
  @JsonKey(name: "purchaseId")
  String get purchaseId;
  @override
  @JsonKey(name: "paymentMethodId")
  String get paymentMethodId;
  @override
  @JsonKey(name: "customer")
  String get customerId;
  @override
  @JsonKey(name: "amount")
  double get amount;
  @override
  @JsonKey(name: "application")
  String? get application;
  @override
  @JsonKey(name: "applicationFeeAmount")
  double get applicationFeeAmount;
  @override
  @JsonKey(name: "transferAmount")
  double get transferAmount;
  @override
  @JsonKey(name: "transferDistination")
  String get transferDistination;
  @override
  @JsonKey(name: "currency")
  String get currency;
  @override
  @JsonKey(name: "clientSecret")
  String get clientSecret;
  @override
  @JsonKey(name: "createdTime")
  ModelTimestamp get createdTime;
  @override
  @JsonKey(name: "updatedTime")
  ModelTimestamp get updatedTime;
  @override
  @JsonKey(name: "emailFrom")
  String? get emailFrom;
  @override
  @JsonKey(name: "emailTo")
  String? get emailTo;
  @override
  @JsonKey(name: "emailTitle")
  String? get emailTitle;
  @override
  @JsonKey(name: "emailContent")
  String? get emailContent;
  @override
  @JsonKey(name: "locale")
  String? get locale;
  @override
  @JsonKey(name: "cancel_at_period_end")
  bool get cancelAtPeriodEnd;
  @override
  @JsonKey(ignore: true)
  _$$_StripePurchaseModelCopyWith<_$_StripePurchaseModel> get copyWith =>
      throw _privateConstructorUsedError;
}
