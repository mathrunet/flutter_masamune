part of masamune;

extension MasamuneModelAppRefExtensions on AppRef {
  TModel model<TModel extends ChangeNotifier>(
    ModelQueryBase<TModel> query,
  ) {
    return watch(query.call(), name: query.name);
  }
}

extension MasamuneModelExtensions on RefHasApp {
  TModel model<TModel extends ChangeNotifier>(
    ModelQueryBase<TModel> query,
  ) {
    return app.watch(query.call(), name: query.name);
  }
}

abstract class ModelQueryBase<TModel extends ChangeNotifier> {
  const ModelQueryBase();

  TModel Function() call();

  String get name => hashCode.toString();
}
