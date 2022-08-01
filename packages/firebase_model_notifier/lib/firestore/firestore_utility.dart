part of firebase_model_notifier;

/// Utility class of Firestore.
class FirestoreUtility {
  FirestoreUtility._();

  static dynamic _parse(dynamic value) {
    if (value is String) {
      final b = value.toLowerCase();
      if (b == "true") {
        return true;
      } else if (b == "false") {
        return false;
      }
      final n = num.tryParse(value);
      if (n != null) {
        return n;
      }
      return value;
    } else {
      return value;
    }
  }

  /// Checks if the document in [path] contains a value where [key] is [value].
  static Future<bool> containsValue({
    required String path,
    required String key,
    required dynamic value,
  }) async {
    await FirebaseCore.initialize();
    // await Future.delayed(Duration(milliseconds: Random().nextInt(100)));
    final snapshot = await FirebaseFirestore.instance
        .collection(path)
        .where(key, isEqualTo: value)
        .get();
    return snapshot.size > 0;
  }
}
