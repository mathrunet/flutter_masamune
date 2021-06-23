part of masamune_calendar;

class DaysOfWeekStyle {
  const DaysOfWeekStyle({
    this.dowTextBuilder,
    this.decoration = const BoxDecoration(),
    this.weekdayStyle =
        const TextStyle(color: Color(0xFF616161)), // Material grey[700]
    this.weekendStyle =
        const TextStyle(color: Color(0xFFF44336)), // Material red[500]
  });

  final TextBuilder? dowTextBuilder;

  final BoxDecoration decoration;

  final TextStyle weekdayStyle;

  final TextStyle weekendStyle;
}
