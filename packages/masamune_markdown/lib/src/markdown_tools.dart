part of "/masamune_markdown.dart";

/// Base class for markdown tools.
///
/// マークダウンツールの基底クラス。
@immutable
abstract class MarkdownTools {
  /// Base class for markdown tools.
  ///
  /// マークダウンツールの基底クラス。
  const MarkdownTools({
    required this.config,
  });

  /// Configuration for the tool.
  ///
  /// ツールの設定。
  final MarkdownToolLabelConfig config;

  /// Get the id of the tool.
  ///
  /// ツールのIDを取得します。
  String get id;

  /// Check if the tool is enabled.
  ///
  /// ツールが有効かどうかを確認します。
  bool enabled(BuildContext context, MarkdownToolRef ref);

  /// Check if the tool should be shown.
  ///
  /// ツールが表示されるかどうかを確認します。
  bool shown(BuildContext context, MarkdownToolRef ref);

  /// Check if the tool is active.
  ///
  /// ツールがアクティブかどうかを確認します。
  bool actived(BuildContext context, MarkdownToolRef ref);

  /// Get the label for the tool.
  ///
  /// ツールのラベルを取得します。
  Widget label(BuildContext context, MarkdownToolRef ref);

  /// Get the icon for the tool.
  ///
  /// ツールのアイコンを取得します。
  Widget icon(BuildContext context, MarkdownToolRef ref);

  /// Execute the tool.
  ///
  /// ツールを実行します。
  void onTap(BuildContext context, MarkdownToolRef ref);

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MarkdownTools &&
          runtimeType == other.runtimeType &&
          id == other.id;
}

/// Base class for markdown property tools.
///
/// マークダウンプロパティツールの基底クラス。
@immutable
abstract class MarkdownPropertyTools<TProperty extends MarkdownProperty>
    extends MarkdownTools {
  /// Base class for markdown property tools.
  ///
  /// マークダウンプロパティツールの基底クラス。
  const MarkdownPropertyTools({
    required super.config,
  });

  /// Apply the inline property to the given properties.
  ///
  /// インラインプロパテズを適用します。
  List<MarkdownProperty> addProperty(
    List<MarkdownProperty> properties, {
    Object? value,
  });

  /// Remove the inline property from the given properties.
  ///
  /// インラインプロパテズを削除します。
  List<MarkdownProperty> removeProperty(
    List<MarkdownProperty> properties,
  );

  /// Convert a JSON object to a markdown span value.
  ///
  /// JSONオブジェクトをマークダウンスパン値に変換します。
  TProperty? convertFromJson(DynamicMap json);

  /// Convert a markdown span value to a JSON object.
  ///
  /// マークダウンスパン値をJSONオブジェクトに変換します。
  DynamicMap? convertToJson(TProperty value);

  /// Convert a markdown string to a markdown span value.
  ///
  /// マークダウン文字列をマークダウンスパン値に変換します。
  TProperty? convertFromMarkdown(String markdown);

  /// Convert a markdown span value to a markdown string.
  ///
  /// マークダウンスパン値をマークダウン文字列に変換します。
  String? convertToMarkdown(TProperty value);
}

/// Base class for markdown primary tools.
///
/// マークダウンプライマリツールの基底クラス。
@immutable
abstract class MarkdownPrimaryTools extends MarkdownTools {
  /// Base class for markdown primary tools.
  ///
  /// マークダウンプライマリツールの基底クラス。
  const MarkdownPrimaryTools({
    required super.config,
  });

  /// Get the block tools.
  ///
  /// ブロックツールを取得します。
  List<MarkdownBlockTools>? get blockTools => null;

  /// Get the inline tools.
  ///
  /// インラインツールを取得します。
  List<MarkdownInlineTools>? get inlineTools => null;

  /// Check if the keyboard should be hidden when the tool is selected.
  ///
  /// ツールが選択されたときにキーボードを非表示にするかどうかを確認します。
  bool get hideKeyboardOnSelected;
}

/// Base class for markdown property primary tools.
///
/// マークダウンプロパティプライマリツールの基底クラス。
@immutable
abstract class MarkdownPropertyPrimaryTools<TProperty extends MarkdownProperty>
    extends MarkdownPrimaryTools implements MarkdownPropertyTools<TProperty> {
  /// Base class for markdown property primary tools.
  ///
  /// マークダウンプロパティプライマリツールの基底クラス。
  const MarkdownPropertyPrimaryTools({
    required super.config,
  });
}

/// Base class for markdown sub tools.
///
/// マークダウンサブツールの基底クラス。
@immutable
abstract class MarkdownSecondaryTools extends MarkdownTools {
  /// Base class for markdown sub tools.
  ///
  /// マークダウンサブツールの基底クラス。
  const MarkdownSecondaryTools({
    required super.config,
  });
}

/// Base class for markdown block tools.
///
/// マークダウンブロックツールの基底クラス。
@immutable
abstract class MarkdownBlockTools extends MarkdownTools {
  /// Base class for markdown block tools.
  ///
  /// マークダウンブロックツールの基底クラス。
  const MarkdownBlockTools({
    required super.config,
  });

  /// Create a new block.
  ///
  /// 新しいブロックを作成します。
  MarkdownBlockValue addBlock({MarkdownBlockValue? source}) {
    return MarkdownBlockValue.createEmpty(indent: source?.indent ?? 0);
  }

  /// Exchange a block.
  ///
  /// ブロックを交換します。
  MarkdownBlockValue? exchangeBlock(MarkdownBlockValue target);
}

/// Base class for markdown block variable tools.
///
/// マークダウンブロック変数ツールの基底クラス。
@immutable
abstract class MarkdownBlockVariableTools<TValue extends MarkdownBlockValue>
    extends MarkdownBlockTools {
  /// Base class for markdown block variable tools.
  ///
  /// マークダウンブロック変数ツールの基底クラス。
  const MarkdownBlockVariableTools({
    required super.config,
  });

  /// Convert a JSON object to a markdown block value.
  ///
  /// JSONオブジェクトをマークダウンブロック値に変換します。
  TValue? convertFromJson(DynamicMap json);

  /// Convert a markdown block value to a JSON object.
  ///
  /// マークダウンブロック値をJSONオブジェクトに変換します。
  DynamicMap? convertToJson(TValue value);

  /// Convert a markdown string to a markdown block value.
  ///
  /// マークダウン文字列をマークダウンブロック値に変換します。
  TValue? convertFromMarkdown(String markdown);

  /// Convert a markdown block value to a markdown string.
  ///
  /// マークダウンブロック値をマークダウン文字列に変換します。
  String? convertToMarkdown(TValue value);

  /// Create a new block value.
  ///
  /// 新しいブロック値を作成します。
  TValue createBlockValue({
    String? initialText,
    List<MarkdownLineValue>? children,
  });
}

/// Base class for markdown inline tools.
///
/// マークダウンインラインツールの基底クラス。
@immutable
abstract class MarkdownInlineTools extends MarkdownTools {
  /// Base class for markdown inline tools.
  ///
  /// マークダウンインラインツールの基底クラス。
  const MarkdownInlineTools({
    required super.config,
  });

  /// Active the tool.
  ///
  /// ツールをアクティブにします。
  Future<void> onActive(BuildContext context, MarkdownToolRef ref);

  /// Deactive the tool.
  ///
  /// ツールを非アクティブにします。
  Future<void> onDeactive(BuildContext context, MarkdownToolRef ref);
}

/// Base class for markdown property inline tools.
///
/// マークダウンプロパティインラインツールの基底クラス。
@immutable
abstract class MarkdownPropertyInlineTools<TProperty extends MarkdownProperty>
    extends MarkdownInlineTools implements MarkdownPropertyTools<TProperty> {
  /// Base class for markdown property inline tools.
  ///
  /// マークダウンプロパティインラインツールの基底クラス。
  const MarkdownPropertyInlineTools({
    required super.config,
  });
}

/// Configuration class for Markdown tool label.
///
/// Set the label and icon for each tool using [MarkdownToolLabelConfig].
///
/// Markdownツールのラベル設定クラス。
///
/// [MarkdownToolLabelConfig]を使用して、各ツールのラベルとアイコンを設定します。
class MarkdownToolLabelConfig {
  /// Configuration class for Markdown tool label.
  ///
  /// Set the label and icon for each tool using [MarkdownToolLabelConfig].
  ///
  /// Markdownツールのラベル設定クラス。
  ///
  /// [MarkdownToolLabelConfig]を使用して、各ツールのラベルとアイコンを設定します。
  const MarkdownToolLabelConfig({
    required this.title,
    required this.icon,
  });

  /// Label for the tool.
  ///
  /// ツールのラベル。
  final LocalizedValue<String> title;

  /// Icon for the tool.
  ///
  /// ツールのアイコン。
  final IconData icon;
}
