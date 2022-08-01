part of masamune;

/// The provider of the GlobalKey.
AutoDisposeProvider<GlobalKey<T>> globalKeyProvider<T extends State>() {
  return AutoDisposeProvider<GlobalKey<T>>((_) {
    return GlobalKey<T>();
  });
}
