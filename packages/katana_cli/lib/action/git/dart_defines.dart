// Dart imports:
import "dart:io";

// Project imports:
import "package:katana_cli/katana_cli.dart";

/// Dart-define file used for production builds in GitHub Actions.
///
/// GitHub Actionsの本番ビルドで使用するdart-defineファイル。
const kProductionDartDefinesFile = "dart_defines/prod.env";

/// Dart-define file used for status checks in GitHub Actions.
///
/// GitHub Actionsのステータスチェックで使用するdart-defineファイル。
const kDevelopmentDartDefinesFile = "dart_defines/dev.env";

const _resolveScript = r"""
perl -ne '
            sub resolve { my ($n, $d) = @_; my $x = $ENV{$n}; if (defined $x && $x ne "") { if ($x =~ m{[\r\n]}) { print STDERR "Dart-define value must not contain line breaks: $n\n"; $main::e = 1; } return $x; } return $d if defined $d; print STDERR "Undefined environment variable: $n\n"; $main::e = 1; return ""; }
            if (/^\s*(#|$)/ || !/=/) { print; next; }
            my ($k, $v) = split /=/, $_, 2;
            $v =~ s/(\$?)(\$\{([A-Za-z_][A-Za-z0-9_]*)(?::-([^}]*))?\})/$1 ? $2 : resolve($3, $4)/ge;
            print "$k=$v";
            END { $? = 1 if $main::e; }
          '""";

/// Stores the environment variables referenced by the dart-define file at [path] in GitHub Secrets.
///
/// Each value is read from the current environment and stored as `<NAME>_<suffix>`, or `<NAME>` when [suffix] is `null`.
/// Variables with only default-value references are skipped when they are not set.
/// Returns `false` and reports the names when a required variable is not set.
///
/// [path]のdart-defineファイルが参照する環境変数をGitHub Secretsに保存します。
///
/// 値は現在の環境変数から読み取り、`<NAME>_<suffix>`（[suffix]が`null`の場合は`<NAME>`）として保存します。
/// デフォルト値付きの参照のみの変数は、未設定の場合スキップします。
/// 必須の変数が未設定の場合は変数名を表示して`false`を返します。
Future<bool> registerDartDefinesSecrets({
  required String gh,
  required String path,
  String? suffix,
}) async {
  final names = dartDefinesEnvironmentNames(path);
  if (names.isEmpty) {
    return true;
  }
  final required = dartDefinesEnvironmentNames(path, requiredOnly: true);
  final missing = required.where((name) {
    final value = Platform.environment[name];
    return value == null || value.isEmpty;
  }).toList();
  if (missing.isNotEmpty) {
    error(
      "Environment variable(s) referenced by `$path` are not set: ${missing.join(", ")}. Register them in Samurai Passwords and run again. `$path`が参照する環境変数が設定されていません。Samurai Passwordsに登録してから再実行してください。",
    );
    return false;
  }
  for (final name in names) {
    final value = Platform.environment[name];
    if (value == null || value.isEmpty) {
      continue;
    }
    final secret = _secretName(name, suffix);
    await githubSecret(
      "Store `$name` referenced by `$path` in `secrets.$secret`.",
      gh: gh,
      name: secret,
      value: value,
    );
  }
  return true;
}

/// Applies dart-define environment variables to the GitHub Actions workflow [source].
///
/// When [buildNames] is not empty, a step that expands [kProductionDartDefinesFile] with Secrets `<NAME>_<suffix>` is inserted before the build step, and the build uses the expanded file.
/// When [statusCheckNames] is not empty, Secrets `<NAME>` are passed to the status check action.
/// [source] is returned unchanged when both are empty.
///
/// GitHub Actionsのワークフロー[source]にdart-defineの環境変数を適用します。
///
/// [buildNames]が空でない場合、Secrets`<NAME>_<suffix>`で[kProductionDartDefinesFile]を展開するステップをビルドステップの前に挿入し、ビルドで展開済みファイルを使用します。
/// [statusCheckNames]が空でない場合、Secrets`<NAME>`をステータスチェックのアクションに渡します。
/// どちらも空の場合は[source]をそのまま返します。
String applyDartDefinesToWorkflow(
  String source, {
  Set<String> buildNames = const {},
  Set<String> statusCheckNames = const {},
  String? suffix,
}) {
  var result = source;
  if (statusCheckNames.isNotEmpty) {
    result = result.replaceAll(
      "        uses: ./.github/actions/status_check\n",
      "        uses: ./.github/actions/status_check\n"
          "${_environmentBlock(statusCheckNames, null)}",
    );
  }
  if (buildNames.isEmpty) {
    return result;
  }
  final lines = result.split("\n");
  final resolved =
      "$kResolvedDartDefinesDirectory/${kProductionDartDefinesFile.split("/").last}";
  final output = <String>[];
  for (final line in lines) {
    if (!line.contains("--dart-define-from-file=$kProductionDartDefinesFile")) {
      output.add(line);
      continue;
    }
    var index =
        output.lastIndexWhere((e) => e.trimLeft().startsWith("- name:"));
    while (index > 0 && output[index - 1].trimLeft().startsWith("#")) {
      index--;
    }
    if (index >= 0) {
      output.insertAll(index, _resolveStep(buildNames, suffix).split("\n"));
    }
    output.add(
      line.replaceAll(
        "--dart-define-from-file=$kProductionDartDefinesFile",
        "--dart-define-from-file=$resolved",
      ),
    );
  }
  return output.join("\n");
}

String _secretName(String name, String? suffix) {
  return suffix == null ? name : "${name}_$suffix";
}

String _environmentBlock(Set<String> names, String? suffix) {
  final sorted = names.toList()..sort();
  return "        env:\n${sorted.map((name) => "          $name: \${{ secrets.${_secretName(name, suffix)} }}\n").join()}";
}

String _resolveStep(Set<String> names, String? suffix) {
  final file = kProductionDartDefinesFile.split("/").last;
  return """
      # Expand environment variable references in dart_defines with Secrets.
      # dart_definesの環境変数参照をSecretsで展開。
      - name: Resolve dart defines
${_environmentBlock(names, suffix)}        run: |
          mkdir -p $kResolvedDartDefinesDirectory
          ${_resolveScript.trim()} $kProductionDartDefinesFile > $kResolvedDartDefinesDirectory/$file
        timeout-minutes: 3
""";
}
