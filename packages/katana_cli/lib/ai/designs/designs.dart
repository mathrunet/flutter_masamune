// Project imports:
import 'package:katana_cli/ai/designs/controller_design.dart';
import 'package:katana_cli/ai/designs/metadata_design.dart';
import 'package:katana_cli/ai/designs/model_design.dart';
import 'package:katana_cli/ai/designs/page_design.dart';
import 'package:katana_cli/ai/designs/plugin_design.dart';
import 'package:katana_cli/ai/designs/theme_design.dart';
import 'package:katana_cli/ai/designs/widget_design.dart';
import 'package:katana_cli/katana_cli.dart';

/// DesignsAiCode is a command that generates AI code to do the design.
///
/// DesignsAiCodeは設計を行うためのAIコードを生成するコマンドです。
class DesignsAiCode extends CliAiCodeCommand {
  /// DesignsAiCode is a command that generates AI code to do the design.
  ///
  /// DesignsAiCodeは設計を行うためのAIコードを生成するコマンドです。
  const DesignsAiCode();

  @override
  final String description =
      "Generate AI code to do the design. 設計を行うためのAIコードを生成します。";

  @override
  Map<String, CliAiCode> get codes => {
        "design": const DesignMdCliAiCode(),
        "page_design": const PageDesignMdCliAiCode(),
        "theme_design": const ThemeDesignMdCliAiCode(),
        "widget_design": const WidgetDesignMdCliAiCode(),
        "plugin_design": const PluginDesignMdCliAiCode(),
        "model_design": const ModelDesignMdCliAiCode(),
        "controller_design": const ControllerDesignMdCliAiCode(),
        "metadata_design": const MetadataDesignMdCliAiCode(),
      };
}

/// Contents of design.md.
///
/// design.mdの中身。
class DesignMdCliAiCode extends CliAiCode {
  /// Contents of design.md.
  ///
  /// design.mdの中身。
  const DesignMdCliAiCode();

  @override
  String get name => "すべての`設計書`の作成";

  @override
  String get description => "`設計`の方法と`設計書`の作成";

  @override
  String get globs => "documents/designs/**/*.md";

  @override
  String get directory => "designs";

  @override
  String body(String baseName, String className) {
    return r"""
要件定義書(`requirements.md`)を元に下記に定義されている各種`設計書`を作成。
下記の順番通りにステップごとに実施。

1. `Page設計書`
    - `documents/rules/designs/page_design.md`を参照して、要件定義書(`requirements.md`)から要件定義書を作成し、`documents/designs/page_design.md`に記載
2. `Model設計書`
    - `documents/rules/designs/model_design.md`を参照して、要件定義書(`requirements.md`)から要件定義書を作成し、`documents/designs/model_design.md`に記載
3. `Theme設計書`
    - `documents/rules/designs/theme_design.md`を参照して、要件定義書(`requirements.md`)から要件定義書を作成し、`documents/designs/theme_design.md`に記載
4. `MetaData設計書`
    - `documents/rules/designs/metadata_design.md`を参照して、要件定義書(`requirements.md`)から要件定義書を作成し`documents/designs/metadata_design.md`に記載
5. `Plugin設計書`
    - `documents/rules/designs/plugin_design.md`を参照して、要件定義書(`requirements.md`)から要件定義書を作成し、`documents/designs/plugin_design.md`に記載
6. `Controller設計書`
    - `documents/rules/designs/controller_design.md`を参照して、要件定義書(`requirements.md`)から要件定義書を作成し、`documents/designs/controller_design.md`に記載
7. `Widget設計書`
    - `documents/rules/designs/widget_design.md`を参照して、要件定義書(`requirements.md`)から要件定義書を作成し、`documents/designs/widget_design.md`に記載
""";
  }
}
