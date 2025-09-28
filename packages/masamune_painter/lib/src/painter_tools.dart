part of "/masamune_painter.dart";

/// Base class for painter tools.
///
/// 描画ツールの基底クラス。
@immutable
abstract class PainterTools {
  /// Base class for painter tools.
  ///
  /// 描画ツールの基底クラス。
  const PainterTools({
    required this.config,
  });

  /// Configuration for the tool.
  ///
  /// ツールの設定。
  final PainterToolLabelConfig config;

  /// Get the id of the tool.
  ///
  /// ツールのIDを取得します。
  String get id;

  /// Check if the tool is enabled.
  ///
  /// ツールが有効かどうかを確認します。
  bool enabled(BuildContext context, PainterToolRef ref);

  /// Check if the tool should be shown.
  ///
  /// ツールが表示されるかどうかを確認します。
  bool shown(BuildContext context, PainterToolRef ref);

  /// Check if the tool is active.
  ///
  /// ツールがアクティブかどうかを確認します。
  bool actived(BuildContext context, PainterToolRef ref);

  /// Get the label for the tool.
  ///
  /// ツールのラベルを取得します。
  Widget label(BuildContext context, PainterToolRef ref);

  /// Get the icon for the tool.
  ///
  /// ツールのアイコンを取得します。
  Widget icon(BuildContext context, PainterToolRef ref);

  /// Execute the tool.
  ///
  /// ツールを実行します。
  void onTap(BuildContext context, PainterToolRef ref);

  /// Check if the tool should unselect on done.
  ///
  /// ツールを実行した後に選択を解除するかどうかを確認します。
  bool get unselectOnDone => true;

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PainterTools &&
          runtimeType == other.runtimeType &&
          id == other.id;
}

/// Base class for painter primary tools.
///
/// 描画ツールのプライマリツールの基底クラス。
@immutable
abstract class PainterPrimaryTools extends PainterTools {
  /// Base class for painter primary tools.
  ///
  /// 描画ツールのプライマリツールの基底クラス。
  const PainterPrimaryTools({
    required super.config,
  });

  /// Get the inline tools.
  ///
  /// インラインツールを取得します。
  List<PainterInlineTools>? get inlineTools => null;

  /// Get the block tools.
  ///
  /// ブロックツールを取得します。
  List<PainterBlockTools>? get blockTools => null;
}

/// Base class for painter sub tools.
///
/// 描画ツールのサブツールの基底クラス。
@immutable
abstract class PainterSecondaryTools extends PainterTools {
  /// Base class for painter sub tools.
  ///
  /// 描画ツールのサブツールの基底クラス。
  const PainterSecondaryTools({
    required super.config,
  });
}

/// Base class for painter block tools.
///
/// 描画ツールのブロックツールの基底クラス。
@immutable
abstract class PainterBlockTools extends PainterTools {
  /// Base class for painter block tools.
  ///
  /// 描画ツールのブロックツールの基底クラス。
  const PainterBlockTools({
    required super.config,
  });
}

/// Base class for painter line block tools.
///
/// 描画ツールの線ブロックツールの基底クラス。
@immutable
abstract class PainterLineBlockTools extends PainterBlockTools {
  /// Base class for painter line block tools.
  ///
  /// 描画ツールの線ブロックツールの基底クラス。
  const PainterLineBlockTools({
    required super.config,
  });

  /// Get the stroke width.
  ///
  /// ストローク幅を取得します。
  double get strokeWidth;
}

/// Base class for painter inline tools.
///
/// 描画ツールのインラインツールの基底クラス。
@immutable
abstract class PainterInlineTools extends PainterTools {
  /// Base class for painter inline tools.
  ///
  /// 描画ツールのインラインツールの基底クラス。
  const PainterInlineTools({
    required super.config,
  });

  /// Active the tool.
  ///
  /// ツールをアクティブにします。
  Future<void> onActive(BuildContext context, PainterToolRef ref);

  /// Deactive the tool.
  ///
  /// ツールを非アクティブにします。
  Future<void> onDeactive(BuildContext context, PainterToolRef ref);
}

/// Base class for painter variable inline tools.
///
/// 描画ツールの変数インラインツールの基底クラス。
@immutable
abstract class PainterVariableInlineTools<TValue extends PaintingValue>
    extends PainterInlineTools {
  /// Base class for painter variable inline tools.
  ///
  /// 描画ツールの変数インラインツールの基底クラス。
  const PainterVariableInlineTools({
    required super.config,
  });

  /// Create a new painting value.
  ///
  /// 新しい描画用のデータを作成します。
  TValue create({
    required Offset point,
    PainterLineBlockTools? line,
    Color? backgroundColor,
    Color? foregroundColor,
    String? uid,
  });

  /// Convert a JSON object to a painting value.
  ///
  /// JSONオブジェクトを描画用のデータに変換します。
  TValue? convertFromJson(DynamicMap json);

  /// Convert a painting value to a JSON object.
  ///
  /// 描画用のデータをJSONオブジェクトに変換します。
  DynamicMap? convertToJson(TValue value);
}

/// Configuration class for Painter tool label.
///
/// Set the label and icon for each tool using [PainterToolLabelConfig].
///
/// 描画ツールのラベル設定クラス。
///
/// [PainterToolLabelConfig]を使用して、各ツールのラベルとアイコンを設定します。
class PainterToolLabelConfig {
  /// Configuration class for Painter tool label.
  ///
  /// Set the label and icon for each tool using [PainterToolLabelConfig].
  ///
  /// 描画ツールのラベル設定クラス。
  ///
  /// [PainterToolLabelConfig]を使用して、各ツールのラベルとアイコンを設定します。
  const PainterToolLabelConfig({
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
