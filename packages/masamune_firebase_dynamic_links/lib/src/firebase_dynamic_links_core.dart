part of masamune_firebase_dynamic_links;

class FirebaseDynamicLinksCore {
  const FirebaseDynamicLinksCore._();

  static FirebaseDynamicLinksModel get _dynamicLinks {
    return readProvider(firebaseDynamicLinksProvider);
  }

  static Future<void> listen([void Function(Uri link)? onUpdate]) {
    return _dynamicLinks.listen(onUpdate);
  }
}
