part of "/masamune_calendar.dart";

/// [MasamuneAdapter] for configuring calendar functions.
///
/// [startingDayOfWeek] allows you to change the starting day of the week.
///
/// Select [weekendDays] to set holidays.
///
/// カレンダーの機能を設定するための[MasamuneAdapter]。
///
/// [startingDayOfWeek]を指定すると１週間の開始曜日を変更できます。
///
/// [weekendDays]を選択すると休日を設定できます。
class CalendarMasamuneAdapter extends MasamuneAdapter {
  /// [MasamuneAdapter] for configuring calendar functions.
  ///
  /// [startingDayOfWeek] allows you to change the starting day of the week.
  ///
  /// Select [weekendDays] to set holidays.
  ///
  /// カレンダーの機能を設定するための[MasamuneAdapter]。
  ///
  /// [startingDayOfWeek]を指定すると１週間の開始曜日を変更できます。
  ///
  /// [weekendDays]を選択すると休日を設定できます。
  const CalendarMasamuneAdapter({
    this.startingDayOfWeek = DayOfWeek.sunday,
    this.weekendDays = const [DayOfWeek.saturday, DayOfWeek.sunday],
  });

  /// Starting day of the week.
  ///
  /// １週間の開始曜日。
  final DayOfWeek startingDayOfWeek;

  /// Specify holidays.
  ///
  /// 休日を指定します。
  final List<DayOfWeek> weekendDays;

  /// You can retrieve the [CalendarMasamuneAdapter] first given by [MasamuneAdapterScope].
  ///
  /// 最初に[MasamuneAdapterScope]で与えた[CalendarMasamuneAdapter]を取得することができます。
  static CalendarMasamuneAdapter get primary {
    assert(
      _primary != null,
      "CalendarMasamuneAdapter is not set. Place [MasamuneAdapterScope] widget closer to the root.",
    );
    return _primary!;
  }

  static CalendarMasamuneAdapter? _primary;

  @override
  void onInitScope(MasamuneAdapter adapter) {
    super.onInitScope(adapter);
    if (adapter is! CalendarMasamuneAdapter) {
      return;
    }
    _primary = adapter;
  }

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<CalendarMasamuneAdapter>(
      adapter: this,
      child: app,
    );
  }
}
