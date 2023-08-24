part of masamune_module_point_ecosystem;

/// Option to use [PointEcosystemModule].
///
/// [PointEcosystemModule]を利用するためのオプション。
@immutable
class PointEcosystemModuleOptions extends ModuleOptions {
  /// Option to use [PointEcosystemModule].
  ///
  /// [PointEcosystemModule]を利用するためのオプション。
  const PointEcosystemModuleOptions({
    this.rewardedAdUnitId,
    this.dailyBonusEarnAmount,
    this.rewardBonusEarnAmount,
  });

  /// Unit ID for reward ads.
  ///
  /// リワード広告用のユニットID。
  final String? rewardedAdUnitId;

  /// Daily Bonus Points Earned.
  ///
  /// デイリーボーナスのポイント獲得量。
  final double? dailyBonusEarnAmount;

  /// The amount of bonus points earned when viewing reward ads.
  ///
  /// リワード広告を見たときのボーナスポイント獲得量。
  final double? rewardBonusEarnAmount;
}
