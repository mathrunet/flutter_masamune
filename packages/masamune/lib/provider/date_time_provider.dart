part of masamune;

// ignore: subtype_of_sealed_class
/// Provider to provide [DateTime].
/// [DateTime]を提供するためのプロバイダーです。
///
/// Returns the same time if it is within the range of that page.
/// そのページの範囲内であれば同じ時間を返します。
///
/// If [dateTime] is specified, that time is returned; if not, the time in [DateTime.now] is returned.
/// [dateTime]を指定した場合はその時間が返され、指定しなかった場合は[DateTime.now]の時刻が返されます。
///
/// ```dart
/// fianl dateTimeNowProvider = DateTimeProvider();
///
/// class TestPage extends PageScopedWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref){
///     final dateTimeNow = ref.watch(dateTimeNowProvider); // The same time is returned.
///   }
/// }
/// ```
class DateTimeProvider extends AutoDisposeProvider<DateTime> {
  DateTimeProvider([this.dateTime])
      : super((ref) => dateTime ?? DateTime.now());

  /// The value of [DateTime] provided.
  /// 提供される[DateTime]の値。
  final DateTime? dateTime;
}
