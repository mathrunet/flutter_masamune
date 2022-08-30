part of katana;

/// Extension method of Dynamic List.
extension JsonDynamicListExtensions on DynamicList {
  /// Convert to JSON string.
  String toJsonString() {
    return jsonEncode(this);
  }
}

/// Extension method of Dynamic Map.
extension JsonDynamicMapExtensions on DynamicMap {
  /// Convert to JSON string.
  String toJsonString() {
    return jsonEncode(this);
  }
}
