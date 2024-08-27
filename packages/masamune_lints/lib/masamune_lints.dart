// Copyright (c) 2024 mathru. All rights reserved.

/// Package that defines lint rules necessary for use with the Masamune framework.
///
/// To use, import `package:masamune_lints/masamune_lints.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_lints;

// Package imports:
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:custom_lint_core/src/lint_codes.dart' as lint_codes;
import 'package:katana/katana.dart';

export 'package:custom_lint/custom_lint.dart';

part 'masamune/masamune_model_should_show_indicator_while_loading.dart';
part 'masamune/masamune_model_should_load.dart';
part 'masamune/masamune_collection_model_should_add_limit_query.dart';
part 'masamune/masamune_scoped_query_must_pass_to_appropriate_ref.dart';

part 'buttons/masamune_button_add_icon.dart';
part 'buttons/masamune_button_type.dart';
part 'buttons/masamune_button_remove_icon.dart';
part 'buttons/masamune_button_convert.dart';

part 'common/masamune_limit_if_nesting.dart';
part 'common/masamune_unwrap_nullable.dart';

part 'src/extensions.dart';

/// Entry point for custom linter, passing a class that extends PluginBase.
///
/// カスタムlinterのエントリポイント。PluginBase を継承したクラスを渡します。
PluginBase createPlugin() => _MasamuneLints();

class _MasamuneLints extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        const _MasamuneModelShouldLoad(),
        const _MasamuneModelShouldShowIndicatorWhileLoading(),
        const _MasamuneCollectionModelShouldAddLimitQuery(),
        const _MasamuneScopedQueryMustPassToAppropriateRef(),
        const _MasamuneLimitIfNesting(),
        const _MasamuneUnwrapNullable(),
      ];
  @override
  List<Assist> getAssists() => [
        _MasamuneButtonAddIcon(),
        _MasamuneButtonRemoveIcon(),
        ..._MaterialButtonType.values.map(
          (buttonType) => _MasamuneButtonConvert(targetType: buttonType),
        ),
      ];
}
