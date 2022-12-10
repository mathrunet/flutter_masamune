part of masamune;

extension MasamuneControllerAppRefExtensions on AppRef {
  TController controller<TController extends ChangeNotifier>(
    ControllerQueryBase<TController> query,
  ) {
    return watch(query.call(), name: query.name);
  }
}

extension MasamuneControllerAppScopedValueRefExtensions on AppScopedValueRef {
  TController controller<TController extends ChangeNotifier>(
    ControllerQueryBase<TController> query,
  ) {
    return watch(query.call(), name: query.name);
  }
}

extension MasamuneControllerPageScopedValueRefExtensions on PageScopedValueRef {
  TController controller<TController extends ChangeNotifier>(
    ControllerQueryBase<TController> query,
  ) {
    return watch(query.call(), name: query.name);
  }
}

abstract class ControllerQueryBase<TController extends ChangeNotifier> {
  const ControllerQueryBase();

  TController Function() call();

  String get name => hashCode.toString();
}
