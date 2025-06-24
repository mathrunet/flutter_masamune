/// Describe the settings.
///
/// 設定を記述します。
class Config {
  Config._();

  /// Version of the Android GoogleServices.
  ///
  /// AndroidのGoogleServicesのバージョン。
  static const String googleServicesVersion = "4.3.14";

  /// Version of the Android Kotlin.
  ///
  /// AndroidのKotlinのバージョン。
  static const String androidKotlinVersion = "1.9.22";

  /// Version of the Android Billing Library.
  ///
  /// AndroidのBillingライブラリのバージョン。
  static const String androidBillingVersion = "6.0.1";

  /// Sdk version at Android billing.
  ///
  /// Androidの課金時のSdkバージョン。
  static const int billingCompileSdkVersion = 34;

  /// MinSdk version at Firebase for Android.
  ///
  /// AndroidのFirebase時のMinSdkバージョン。
  static const int firebaseMinSdkVersion = 23;
}
