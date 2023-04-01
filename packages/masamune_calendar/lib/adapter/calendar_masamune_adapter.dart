part of masamune_calendar;

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

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<CalendarMasamuneAdapter>(
      adapter: this,
      child: app,
    );
  }
}
