/// Describe the settings.
///
/// 設定を記述します。
class Config {
  Config._();

  /// Version of the Android GoogleServices.
  ///
  /// AndroidのGoogleServicesのバージョン。
  static const String googleServicesVersion = "4.4.0";

  /// Version of the Android Kotlin.
  ///
  /// AndroidのKotlinのバージョン。
  static const String androidKotlinVersion = "2.1.0";

  /// Version of the Android Billing Library.
  ///
  /// AndroidのBillingライブラリのバージョン。
  static const String androidBillingVersion = "7.0.0";

  /// Sdk version at Android billing.
  ///
  /// Androidの課金時のSdkバージョン。
  static const int billingCompileSdkVersion = 34;

  /// MinSdk version at Firebase for Android.
  ///
  /// AndroidのFirebase時のMinSdkバージョン。
  static const int firebaseMinSdkVersion = 23;
}
