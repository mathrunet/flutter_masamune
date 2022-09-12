part of katana_module;

extension ModuleBuildContextExtensions on BuildContext {
  /// Get the model adapter.
  ModelAdapter? get model {
    return AdapterScope.of(this)?.modelAdapter;
  }

  /// Get the adapter plugins.
  AdapterPlugins? get plugin {
    return AdapterScope.of(this)?.plugin;
  }

  /// Get the platform adapter.
  PlatformAdapter? get platform {
    return AdapterScope.of(this)?.platformAdapter;
  }

  /// Get the app module config.
  AppModule? get app {
    return AppScope.of(this)?.app;
  }

  /// Get the template module config.
  T? template<T extends TemplateModule>() {
    return AppScope.of(this)?.template as T?;
  }
}

extension SignInAdapterListExtensions on List<SignInAdapter>? {
  Future<void> signOut(BuildContext context) async {
    if (this == null) {
      return;
    }
    final providerIds = context.model?.activeSignInProviders ?? const [];
    if (providerIds.isEmpty) {
      await context.model?.signOut();
      return;
    }
    for (final sns in this!) {
      final id = sns.provider;
      if (!providerIds.any((tmp) => tmp.contains(id))) {
        continue;
      }
      await sns.signOut();
      return;
    }
    await context.model?.signOut();
  }
}

extension WidgetRefModelExtensions on WidgetRef {
  /// Get the document model of [path] from the resource registered with Adapter.
  ///
  /// Setting `[listen]' to `false' will retrieve data only once.
  ///
  /// If [disposable] is `true`, the widget is automatically disposed when it is destroyed.
  DynamicDocumentModel readDocumentModel(
    String path, {
    bool listen = true,
    bool disposable = true,
  }) {
    final context = this as BuildContext;

    return read(
      context.model!.documentProvider(
        applyModuleTag(path),
        disposable: disposable,
      ),
    )..fetch(listen);
  }

  /// Get the collection model of [path] from the resource registered with Adapter.
  ///
  /// Setting `[listen]' to `false' will retrieve data only once.
  ///
  /// If [disposable] is `true`, the widget is automatically disposed when it is destroyed.
  DynamicCollectionModel readCollectionModel(
    String path, {
    bool listen = true,
    bool disposable = true,
  }) {
    final context = this as BuildContext;

    return read(
      context.model!.collectionProvider(
        applyModuleTag(path),
        disposable: disposable,
      ),
    )..fetch(listen);
  }

  /// Get the searchable collection model of [path] from the resource registered with Adapter.
  DynamicSearchableCollectionModel readSearchableCollectionModel(String path) {
    final context = this as BuildContext;

    return read(
      context.model!.searchableCollectionProvider(applyModuleTag(path)),
    );
  }

  /// Get the user document model of [path] from the resource registered with Adapter.
  ///
  /// Setting `[listen]' to `false' will retrieve data only once.
  ///
  /// If [disposable] is `true`, the widget is automatically disposed when it is destroyed.
  DynamicDocumentModel readUserDocumentModel({
    bool listen = true,
    bool disposable = true,
    String userPath = Const.user,
  }) {
    final context = this as BuildContext;

    return read(
      context.model!.documentProvider(
        applyModuleTag("$userPath/${context.model?.userId}"),
        disposable: disposable,
      ),
    )..fetch(listen);
  }

  /// Get the document model of [path] from the resource registered with Adapter.
  ///
  /// After acquisition, monitor changes.
  ///
  /// Setting `[once]' to `true' will retrieve data only once.
  DynamicDocumentModel watchDocumentModel(
    String path, {
    bool listen = true,
    bool disposable = true,
  }) {
    final context = this as BuildContext;

    return watch(
      context.model!.documentProvider(
        applyModuleTag(path),
        disposable: disposable,
      ),
    )..fetch(listen);
  }

  /// Get the collection model of [path] from the resource registered with Adapter.
  ///
  /// After acquisition, monitor changes.
  ///
  /// Setting `[listen]' to `false' will retrieve data only once.
  ///
  /// If [disposable] is `true`, the widget is automatically disposed when it is destroyed.
  DynamicCollectionModel watchCollectionModel(
    String path, {
    bool listen = true,
    bool disposable = true,
  }) {
    final context = this as BuildContext;

    return watch(
      context.model!.collectionProvider(
        applyModuleTag(path),
        disposable: disposable,
      ),
    )..fetch(listen);
  }

  /// Get the searchable collection model of [path] from the resource registered with Adapter.
  ///
  /// After acquisition, monitor changes.
  DynamicSearchableCollectionModel watchSearchableCollectionModel(String path) {
    final context = this as BuildContext;

    return watch(
      context.model!.searchableCollectionProvider(
        applyModuleTag(path),
      ),
    );
  }

  /// Get the user document model of [path] from the resource registered with Adapter.
  ///
  /// After acquisition, monitor changes.
  ///
  /// Setting `[listen]' to `false' will retrieve data only once.
  ///
  /// If [disposable] is `true`, the widget is automatically disposed when it is destroyed.
  DynamicDocumentModel watchUserDocumentModel({
    bool listen = true,
    bool disposable = true,
    String userPath = Const.user,
  }) {
    final context = this as BuildContext;

    return watch(
      context.model!.documentProvider(
        applyModuleTag("$userPath/${context.model?.userId}"),
        disposable: disposable,
      ),
    )..fetch(listen);
  }
}
