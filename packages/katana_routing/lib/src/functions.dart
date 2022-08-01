part of katana_routing;

/// Load the provider.
///
/// It is freely available from outside the widget.
///
/// Please specify the provider you want to load in [provider].
///
/// You can use your own [ProviderContainer] by specifying [container].
Result readProvider<Result>(
  ProviderBase<Result> provider, {
  ProviderContainer? container,
}) {
  // ignore: invalid_use_of_visible_for_testing_member
  final _container = container ?? AppScoped.providerContainer;
  return _container.read(provider);
}
