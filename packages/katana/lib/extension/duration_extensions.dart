
part of katana;


/// Provides general extensions to [Duration].
extension DurationExtensions on Duration {
  /// Format and output the duration.
  ///
  /// Enter the format of the date and time in [format].
  String format(String format) {
    assert(format.isNotEmpty, "The format is empty.");
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return format
        .replaceAll("dd", inDays.toString())
        .replaceAll("HH", twoDigits(inHours))
        .replaceAll("mm", twoDigits(inMinutes.remainder(60)))
        .replaceAll("ss", twoDigits(inSeconds.remainder(60)));
  }
}
