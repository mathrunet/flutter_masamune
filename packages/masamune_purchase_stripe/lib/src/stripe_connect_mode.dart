part of masamune_purchase_stripe;

enum _StripeConnectAPIMode {
  createAccount,
  deleteAccount,
  deleteCustomer,
  getAccount,
  createPayment,
  deletePayment,
  setDefaultPayment,
  dashboard,
  createPurchase,
  refreshPurchase,
  capturePurchase,
  confirmPurchase,
  cancelPurchase,
  refundPurchase,
  authorization,
  confirmAuthorization,
}

extension _StripeConnectAPIModeExtensions on _StripeConnectAPIMode {
  String get id {
    switch (this) {
      case _StripeConnectAPIMode.createAccount:
        return "create_account";
      case _StripeConnectAPIMode.deleteAccount:
        return "delete_account";
      case _StripeConnectAPIMode.deleteCustomer:
        return "delete_customer";
      case _StripeConnectAPIMode.getAccount:
        return "get_account";
      case _StripeConnectAPIMode.createPayment:
        return "create_payment";
      case _StripeConnectAPIMode.setDefaultPayment:
        return "set_default_payment";
      case _StripeConnectAPIMode.deletePayment:
        return "delete_payment";
      case _StripeConnectAPIMode.dashboard:
        return "dashboard";
      case _StripeConnectAPIMode.createPurchase:
        return "create_purchase";
      case _StripeConnectAPIMode.refreshPurchase:
        return "refresh_purchase";
      case _StripeConnectAPIMode.capturePurchase:
        return "capture_purchase";
      case _StripeConnectAPIMode.confirmPurchase:
        return "confirm_purchase";
      case _StripeConnectAPIMode.cancelPurchase:
        return "cancel_purchase";
      case _StripeConnectAPIMode.refundPurchase:
        return "refund_purchase";
      case _StripeConnectAPIMode.authorization:
        return "authorization";
      case _StripeConnectAPIMode.confirmAuthorization:
        return "confirm_authorization";
    }
  }
}
