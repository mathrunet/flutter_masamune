part of masamune_calendar;

/// Styling class for days of the week.
@immutable
class DaysOfWeekStyle {
  /// Styling class for days of the week.
  const DaysOfWeekStyle({
    this.dowTextBuilder,
    this.decoration = const BoxDecoration(),
    this.weekdayStyle =
        const TextStyle(color: Color(0xFF616161)), // Material grey[700]
    this.weekendStyle =
        const TextStyle(color: Color(0xFFF44336)), // Material red[500]
  });

  /// Text Builder.
  final TextBuilder? dowTextBuilder;

  /// Box decorations for the days of the week.
  final BoxDecoration decoration;

  /// Text style for days of the week.
  final TextStyle weekdayStyle;

  /// Text style for days of the week (weekends).
  final TextStyle weekendStyle;
}
