part of masamune;

extension TextEditingControllerExtensions on TextEditingController? {
  bool get isEmpty {
    if (this == null) {
      return true;
    }
    return this!.text.isEmpty;
  }

  bool get isNotEmpty {
    if (this == null) {
      return false;
    }
    return this!.text.isNotEmpty;
  }
}
