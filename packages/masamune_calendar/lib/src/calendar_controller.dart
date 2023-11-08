part of '/masamune_calendar.dart';

/// Controller for operating the calendar
///
/// カレンダーを操作するためのコントローラー
class CalendarController
    extends MasamuneControllerBase<void, CalendarMasamuneAdapter> {
  /// Controller for operating the calendar
  ///
  /// カレンダーを操作するためのコントローラー
  CalendarController({
    this.initialDay,
    super.adapter,
  });

  /// Query for CalendarController.
  ///
  /// ```dart
  /// appRef.controller(CalendarController.query(parameters));     // Get from application scope.
  /// ref.app.controller(CalendarController.query(parameters));    // Watch at application scope.
  /// ref.page.controller(CalendarController.query(parameters));   // Watch at page scope.
  /// ```
  static const query = _$CalendarControllerQuery();

  @override
  CalendarMasamuneAdapter get primaryAdapter => CalendarMasamuneAdapter.primary;

  DateTime? _selectedDay;
  DateTime? _focusedDay;

  /// Sets the date in focus for calendar display.
  ///
  /// カレンダーの表示を行うためフォーカスされている日付を設定します。
  DateTime get focusedDay => _focusedDay ?? initialDay ?? DateTime.now();

  /// Sets the selected date in the calendar.
  ///
  /// カレンダーの選択されている日付を設定します。
  DateTime? get selectedDay => _selectedDay;

  /// The date selected for the first time.
  ///
  /// 初回の選択されている日付。
  final DateTime? initialDay;

  final List<VoidCallback> _nextListeners = [];
  final List<VoidCallback> _prevListeners = [];
  final List<void Function(DateTime)> _selectListeners = [];
  final List<void Function(CalendarFormat)> _changeCalendarFormatListeners = [];

  @override
  void dispose() {
    super.dispose();
    _nextListeners.clear();
    _prevListeners.clear();
    _selectListeners.clear();
    _changeCalendarFormatListeners.clear();
  }

  void _addListener(
    VoidCallback onNext,
    VoidCallback onPrev,
    void Function(DateTime) onSelect,
  ) {
    _nextListeners.add(onNext);
    _prevListeners.add(onPrev);
    _selectListeners.add(onSelect);
  }

  void _removeListener(
    VoidCallback onNext,
    VoidCallback onPrev,
    void Function(DateTime) onSelect,
  ) {
    _nextListeners.remove(onNext);
    _prevListeners.remove(onPrev);
    _selectListeners.remove(onSelect);
  }

  /// Select [dateTime].
  ///
  /// [dateTime]を選択します。
  void select(DateTime dateTime) {
    _selectedDay = dateTime;
    for (final listener in _selectListeners) {
      listener(dateTime);
    }
    notifyListeners();
  }

  /// Focus on [dateTime].
  ///
  /// [dateTime]にフォーカスします。
  void focus(DateTime dateTime) {
    _focusedDay = dateTime;
    notifyListeners();
  }

  /// Displays the calendar for the next month.
  ///
  /// 次の月のカレンダーを表示します。
  void next() {
    for (final listener in _nextListeners) {
      listener();
    }
  }

  /// Displays the previous month's calendar.
  ///
  /// 前の月のカレンダーを表示します。
  void prev() {
    for (final listener in _prevListeners) {
      listener();
    }
  }

  @override
  int get hashCode => initialDay.hashCode;

  @override
  bool operator ==(Object other) => other.hashCode == hashCode;
}

@immutable
class _$CalendarControllerQuery {
  const _$CalendarControllerQuery();

  @useResult
  _$_CalendarControllerQuery call({
    DateTime? initialDay,
  }) =>
      _$_CalendarControllerQuery(
        hashCode.toString(),
        initialDay: initialDay,
      );
}

@immutable
class _$_CalendarControllerQuery
    extends ControllerQueryBase<CalendarController> {
  const _$_CalendarControllerQuery(
    this._name, {
    this.initialDay,
  });

  final String _name;
  final DateTime? initialDay;

  @override
  CalendarController Function() call(Ref ref) {
    return () => CalendarController(
          initialDay: initialDay,
        );
  }

  @override
  String get queryName => _name;
  @override
  bool get autoDisposeWhenUnreferenced => true;
}
