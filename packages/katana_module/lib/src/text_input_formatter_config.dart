part of katana_module;

/// TextInputFormatter settings.
@immutable
class TextInputFormatterConfig {
  const TextInputFormatterConfig(
    this.filterPattern, {
    this.replacementString = "",
    this.type = TextInputFormatterConfigType.allow,
  });

  /// Type of TextInputFormatterConfig.
  final TextInputFormatterConfigType type;

  /// Creates a formatter that blocks characters matching a pattern.
  ///
  /// The [filterPattern] and [replacementString] arguments must not be null.
  final String filterPattern;

  /// String used to replace banned patterns.
  ///
  /// For deny lists ([allow] is false), each match of the
  /// [filterPattern] is replaced with this string. If [filterPattern]
  /// can match more than one character at a time, then this can
  /// result in multiple characters being replaced by a single
  /// instance of this [replacementString].
  ///
  /// For allow lists ([allow] is true), sequences between matches of
  /// [filterPattern] are replaced as one, regardless of the number of
  /// characters.
  ///
  /// For example, consider a [filterPattern] consisting of just the
  /// letter "o", applied to text field whose initial value is the
  /// string "Into The Woods", with the [replacementString] set to
  /// `*`.
  ///
  /// If [allow] is true, then the result will be "*o*oo*". Each
  /// sequence of characters not matching the pattern is replaced by
  /// its own single copy of the replacement string, regardless of how
  /// many characters are in that sequence.
  ///
  /// If [allow] is false, then the result will be "Int* the W**ds".
  /// Every matching sequence is replaced, and each "o" matches the
  /// pattern separately.
  ///
  /// If the pattern was the [RegExp] `o+`, the result would be the
  /// same in the case where [allow] is true, but in the case where
  /// [allow] is false, the result would be "Int* the W*ds" (with the
  /// two "o"s replaced by a single occurrence of the replacement
  /// string) because both of the "o"s would be matched simultaneously
  /// by the pattern.
  ///
  /// The filter may adjust the selection and the composing region of the text
  /// after applying the text replacement, such that they still cover the same
  /// text. For instance, if the pattern was `o+` and the last character "s" was
  /// selected: "Into The Wood|s|", then the result will be "Into The W*d|s|",
  /// with the selection still around the same character "s" despite that it is
  /// now the 12th character.
  ///
  /// In the case where one end point of the selection (or the composing region)
  /// is strictly inside the banned pattern (for example, "Into The |Wo|ods"),
  /// that endpoint will be moved to the end of the replacement string (it will
  /// become "Into The |W*|ds" if the pattern was `o+` and the original text and
  /// selection were "Into The |Wo|ods").
  final String replacementString;

  /// Make sure that the actual text input formatter is used for output.
  TextInputFormatter get value {
    return FilteringTextInputFormatter(
      RegExp(filterPattern),
      allow: type == TextInputFormatterConfigType.allow,
      replacementString: replacementString,
    );
  }
}

/// Type of TextInputFormatterConfig.
enum TextInputFormatterConfigType {
  /// Allow.
  allow,

  /// Deny.
  deny,
}
