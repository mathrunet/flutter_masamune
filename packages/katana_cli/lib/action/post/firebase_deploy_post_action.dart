// Project imports:
import 'package:katana_cli/katana_cli.dart';

/// Specify the Firebase deployment location.
///
/// Firebaseのデプロイ先を指定します。
enum FirebaseDeployPostActionType {
  /// Firebase functions.
  ///
  /// Firebase functions.
  functions,

  /// Firebase hosting.
  ///
  /// Firebase hosting.
  hosting,

  /// Firebase Data Connect.
  ///
  /// Firebase Data Connect.
  dataconnect;
}

class _FirebaseDeployPostAction extends PostAction {
  const _FirebaseDeployPostAction(this.types);

  final List<FirebaseDeployPostActionType> types;

  @override
  Future<void> exec(ExecContext context) async {
    if (types.isEmpty) {
      return;
    }
    final bin = context.yaml.getAsMap("bin");
    final firebaseCommand = bin.get("firebase", "firebase");
    await command(
      "Deploy firebase products.",
      [
        firebaseCommand,
        "deploy",
        "--only",
        types.map((e) => e.name).join(","),
      ],
      workingDirectory: "firebase",
    );
  }
}

/// [ExecContext] for [_FirebaseDeployPostAction].
///
/// [_FirebaseDeployPostAction]用の[ExecContext]。
extension FirebaseDeployPostActionExecContextExtensions on ExecContext {
  /// Deploy the entire package after the process is complete.
  ///
  /// 処理終了後にまとめてデプロイします。
  void requestFirebaseDeploy(FirebaseDeployPostActionType type) {
    final action = postActions.firstWhereOrNull(
      (item) => item is _FirebaseDeployPostAction,
    );
    if (action != null) {
      postActions.remove(action);
      postActions.add(
        _FirebaseDeployPostAction(
          [...(action as _FirebaseDeployPostAction).types, type].distinct(),
        ),
      );
    } else {
      postActions.add(_FirebaseDeployPostAction([type]));
    }
  }
}
