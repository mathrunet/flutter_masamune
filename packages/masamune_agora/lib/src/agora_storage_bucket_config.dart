part of masamune_agora;

/// Bucket settings for cloud recording.
class AgoraStorageBucketConfig extends StorageBucketConfig {
  /// Bucket settings for cloud recording.
  ///
  /// The [bucketName] is not the Amazon resource name, but the name as it is given.
  const AgoraStorageBucketConfig({
    required this.accessKey,
    this.region = AWSRegion.ap_northeast_1,
    required this.bucketName,
    required this.secretKey,
    this.vendor = AgoraStorageVendor.googleCloud,
    this.path = "temp",
    this.enableDebug = false,
  });

  /// Access key.
  final String accessKey;

  /// Region.
  final AWSRegion region;

  /// Vendor.
  final AgoraStorageVendor vendor;

  /// Bucket name.
  ///
  /// The [bucketName] is not the Amazon resource name, but the name as it is given.
  final String bucketName;

  /// Secret key.
  final String secretKey;

  /// Pass to save.
  final String path;

  /// Enable debug.
  final bool enableDebug;
}

/// AWS Regions.
enum AWSRegion {
  us_east_1,
  us_east_2,
  us_west_1,
  us_west_2,

  eu_west_1,
  eu_west_2,
  eu_west_3,
  eu_central_1,

  ap_southeast_1,
  ap_southeast_2,
  ap_northeast_1,
  ap_northeast_2,

  sa_east_1,

  ca_central_1,

  ap_south_1,

  cn_north_1,
  cn_northwest_1,
  us_gov_west_1,
}

enum AgoraStorageVendor {
  qiniuCloud,
  amazonWebService,
  alibabaCloud,
  tencentCloud,
  kingsoftCloud,
  azure,
  googleCloud,
  huaweiCloud,
  baiduAICloud,
}
