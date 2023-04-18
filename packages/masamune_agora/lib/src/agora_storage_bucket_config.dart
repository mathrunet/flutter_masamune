part of masamune_agora;

/// Setup to use cloud recording.
///
/// If cloud recording is to be implemented, the server side must also be configured to match this setting.
///
/// クラウドレコーディングを利用するための設定。
///
/// クラウドレコーディングを実装する場合は、この設定を合わせてサーバー側の設定も必要です。
@immutable
class AgoraStorageBucketConfig {
  /// Setup to use cloud recording.
  ///
  /// If cloud recording is to be implemented, the server side must also be configured to match this setting.
  ///
  /// クラウドレコーディングを利用するための設定。
  ///
  /// クラウドレコーディングを実装する場合は、この設定を合わせてサーバー側の設定も必要です。
  const AgoraStorageBucketConfig({
    required this.accessKey,
    required this.bucketName,
    required this.secretKey,
    this.vendor = AgoraStorageVendor.googleCloud,
    this.rootPath = "temp",
    this.enableDebug = false,
  });

  /// Key to access the bucket from the API.
  ///
  /// 1. select the project with the bucket and access the following URL.
  ///    https://console.cloud.google.com/storage/settings;tab=interoperability
  /// 2. Click "Create Key" under "User Account Access Key" to create the key along with [secretKey].
  ///
  /// バケットにAPIからアクセスするためのキー。
  ///
  /// 1. バケットのあるプロジェクトを選択し、下記のURLにアクセスします。
  ///    https://console.cloud.google.com/storage/settings;tab=interoperability
  /// 2. 「ユーザー アカウントのアクセスキー」の「鍵を作成」をクリックすると[secretKey]と共に作成されます。
  final String accessKey;

  /// Storage Vendors.
  ///
  /// Currently only [AgoraStorageVendor.googleCloud] is available.
  ///
  /// ストレージのベンダー。
  ///
  /// 現在は[AgoraStorageVendor.googleCloud]のみを利用できます。
  final AgoraStorageVendor vendor;

  /// Bucket Name.
  ///
  /// In GoogleCloudPlatform, after accessing the URL below, a list of buckets will be displayed, so please enter the "name" part as it is.
  ///
  /// https://console.cloud.google.com/storage/browser
  ///
  /// バケット名。
  ///
  /// GoogleCloudPlatformでは下記のURLにアクセス後、バケット一覧が表示されるのでその「名前」の部分をそのまま入力してください。
  ///
  /// https://console.cloud.google.com/storage/browser
  final String bucketName;

  /// Secret key to access the bucket from the API.
  ///
  /// 1. select the project with the bucket and access the following URL.
  ///    https://console.cloud.google.com/storage/settings;tab=interoperability
  /// 2. Click "Create Key" under "User Account Access Key" to create the key along with [accessKey].
  ///
  /// バケットにAPIからアクセスするためのシークレットキー。
  ///
  /// 1. バケットのあるプロジェクトを選択し、下記のURLにアクセスします。
  ///    https://console.cloud.google.com/storage/settings;tab=interoperability
  /// 2. 「ユーザー アカウントのアクセスキー」の「鍵を作成」をクリックすると[accessKey]と共に作成されます。
  final String secretKey;

  /// The path of the base where the data will be stored.
  ///
  /// Save the files under the folder specified here.
  ///
  /// データを保存するベースのパス。
  ///
  /// ここで指定したフォルダ以下にファイルを保存します。
  final String rootPath;

  /// `true` if you want to enable debugging.
  ///
  /// デバッグを有効化したい場合`true`を指定します。
  final bool enableDebug;
}

/// Vendors available in Agora.
///
/// Currently only [googleCloud] is available.
///
/// Agoraで利用可能なベンダー。
///
/// 現状は[googleCloud]のみ利用可能です。
enum AgoraStorageVendor {
  /// Qinui Cloud.
  qiniuCloud,

  /// Amazon Web Service.
  amazonWebService,

  /// Alibaba Cloud.
  alibabaCloud,

  /// Tencent Cloud.
  tencentCloud,

  /// Kingsoft Cloud.
  kingsoftCloud,

  /// Microsoft Azure.
  azure,

  /// Google Cloud.
  googleCloud,

  /// Huawei Cloud.
  huaweiCloud,

  /// Baidu Cloud.
  baiduAICloud,
}
