// Project imports:
import "package:katana_cli/action/firebase/init.dart";

void main() {
  _expect(
    !requiresFirebaseCliScaffold(
      firestore: false,
      dataconnect: false,
      storage: false,
      hosting: false,
      functions: false,
    ),
    "Authentication-only Firebase setup must not require Firebase CLI files.",
  );

  for (final service in const <String>[
    "firestore",
    "dataconnect",
    "storage",
    "hosting",
    "functions",
  ]) {
    _expect(
      requiresFirebaseCliScaffold(
        firestore: service == "firestore",
        dataconnect: service == "dataconnect",
        storage: service == "storage",
        hosting: service == "hosting",
        functions: service == "functions",
      ),
      "$service setup must continue requiring Firebase CLI files.",
    );
  }
}

void _expect(bool value, String message) {
  if (!value) {
    throw StateError(message);
  }
}
