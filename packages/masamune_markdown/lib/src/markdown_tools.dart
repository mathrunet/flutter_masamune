part of "/masamune_markdown.dart";

/// Context class for parsing markdown with multi-line support.
///
/// Provides access to the list of lines being parsed and the current position.
/// Tools can peek ahead or consume multiple lines as needed.
///
/// 複数行サポートを持つマークダウンパース用のコンテキストクラス。
///
/// パース中の行リストと現在位置へのアクセスを提供します。
/// ツールは必要に応じて先読みや複数行の消費が可能です。
class MarkdownParseContext {
  /// Context class for parsing markdown with multi-line support.
  ///
  /// Provides access to the list of lines being parsed and the current position.
  /// Tools can peek ahead or consume multiple lines as needed.
  ///
  /// 複数行サポートを持つマークダウンパース用のコンテキストクラス。
  ///
  /// パース中の行リストと現在位置へのアクセスを提供します。
  /// ツールは必要に応じて先読みや複数行の消費が可能です。
  const MarkdownParseContext({
    required this.lines,
    required this.currentIndex,
  });

  /// The list of lines in the markdown document.
  ///
  /// マークダウンドキュメント内の行リスト。
  final List<String> lines;

  /// The current line index being processed.
  ///
  /// 現在処理中の行インデックス。
  final int currentIndex;

  /// Get the current line being processed.
  ///
  /// 現在処理中の行を取得します。
  String get currentLine => lines[currentIndex];

  /// Check if there are more lines to process.
  ///
  /// 処理すべき行がまだあるかを確認します。
  bool get hasMore => currentIndex < lines.length;

  /// Peek at a line with the given offset from the current position.
  ///
  /// Returns null if the offset is out of bounds.
  ///
  /// 現在位置から指定されたオフセットの行を先読みします。
  ///
  /// オフセットが範囲外の場合は null を返します。
  String? peekLine(int offset) {
    final index = currentIndex + offset;
    if (index < 0 || index >= lines.length) {
      return null;
    }
    return lines[index];
  }

  /// Create a new context with an updated index.
  ///
  /// 更新されたインデックスで新しいコンテキストを作成します。
  MarkdownParseContext copyWith({
    int? currentIndex,
  }) {
    return MarkdownParseContext(
      lines: lines,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}

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

/// Base class for markdown block primary tools.
///
/// マークダウンブロックプライマリツールの基底クラス。
abstract class MarkdownBlockPrimaryTools extends MarkdownPrimaryTools
    implements MarkdownBlockTools {
  /// Base class for markdown block primary tools.
  ///
  /// マークダウンブロックプライマリツールの基底クラス。
  const MarkdownBlockPrimaryTools({
    required super.config,
  });
}

/// Base class for markdown block variable primary tools.
///
/// マークダウンブロック変数プライマリツールの基底クラス。
abstract class MarkdownBlockVariablePrimaryTools<
        TValue extends MarkdownBlockValue> extends MarkdownBlockPrimaryTools
    implements MarkdownBlockVariableTools<TValue> {
  /// Base class for markdown block variable primary tools.
  ///
  /// マークダウンブロック変数プライマリツールの基底クラス。
  const MarkdownBlockVariablePrimaryTools({
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

/// Base class for markdown block secondary tools.
///
/// マークダウンブロックサブツールの基底クラス。
abstract class MarkdownBlockSecondaryTools extends MarkdownSecondaryTools
    implements MarkdownBlockTools {
  /// Base class for markdown block secondary tools.
  ///
  /// マークダウンブロックサブツールの基底クラス。
  const MarkdownBlockSecondaryTools({
    required super.config,
  });
}

/// Base class for markdown block variable secondary tools.
///
/// マークダウンブロック変数サブツールの基底クラス。
abstract class MarkdownBlockVariableSecondaryTools<
        TValue extends MarkdownBlockValue> extends MarkdownBlockSecondaryTools
    implements MarkdownBlockVariableTools<TValue> {
  /// Base class for markdown block variable secondary tools.
  ///
  /// マークダウンブロック変数サブツールの基底クラス。
  const MarkdownBlockVariableSecondaryTools({
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

  /// Convert a markdown block using context-based parsing.
  ///
  /// Returns a record containing:
  /// - [value]: The parsed block value, or null if this tool cannot handle the current line
  /// - [linesConsumed]: The number of lines consumed from the context (including the current line)
  ///
  /// If this method returns null, the parser will try the next tool.
  /// If it returns a non-null record, [linesConsumed] must be at least 1.
  ///
  /// For single-line blocks, you can simply check [context.currentLine] and return
  /// a record with [linesConsumed] = 1.
  ///
  /// For multi-line blocks, you can peek ahead using [context.peekLine] and return
  /// the total number of lines consumed.
  ///
  /// コンテキストベースのパースを使用してマークダウンブロックを変換します。
  ///
  /// 以下を含むレコードを返します:
  /// - [value]: パースされたブロック値、またはこのツールが現在の行を処理できない場合は null
  /// - [linesConsumed]: コンテキストから消費された行数（現在の行を含む）
  ///
  /// このメソッドが null を返した場合、パーサーは次のツールを試します。
  /// null でないレコードを返す場合、[linesConsumed] は少なくとも 1 でなければなりません。
  ///
  /// 単一行ブロックの場合、[context.currentLine] をチェックして [linesConsumed] = 1 のレコードを返すだけです。
  ///
  /// 複数行ブロックの場合、[context.peekLine] を使って先読みし、消費した行の総数を返します。
  ({TValue? value, int linesConsumed})? convertFromMarkdown(
    MarkdownParseContext context,
  );
}

/// Base class for markdown block multi line variable tools.
///
/// マークダウンブロック複数行変数ツールの基底クラス。
@immutable
abstract class MarkdownBlockMultiLineVariableTools<
        TValue extends MarkdownMultiLineBlockValue>
    extends MarkdownBlockVariableTools<TValue> {
  /// Base class for markdown block multi line variable tools.
  ///
  /// マークダウンブロック複数行変数ツールの基底クラス。
  const MarkdownBlockMultiLineVariableTools({
    required super.config,
  });

  /// Create a new block value.
  ///
  /// 新しいブロック値を作成します。
  TValue createBlockValue({
    String? initialText,
    List<MarkdownLineValue>? children,
  });
}

/// Base class for markdown block single child variable tools.
///
/// マークダウンブロック単一子要素変数ツールの基底クラス。
@immutable
abstract class MarkdownBlockSingleChildVariableTools<T,
        TValue extends MarkdownSingleChildBlockValue<T>>
    extends MarkdownBlockVariableTools<TValue> {
  /// Base class for markdown block single child variable tools.
  ///
  /// マークダウンブロック単一子要素変数ツールの基底クラス。
  const MarkdownBlockSingleChildVariableTools({
    required super.config,
  });

  /// Create a new block value.
  ///
  /// 新しいブロック値を作成します。
  TValue createBlockValue({
    String? initialText,
    T? child,
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
