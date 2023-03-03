part of masamune_picker;

/// Adapter for defining the internal process for file picks in [Picker].
///
/// Some file pick functions restrict the platform (e.g., camera functions), so if necessary, an adapter can be defined and used.
///
/// If you have a [PickerMasamuneAdapter] that you want to use, define it in advance in [PickerMasamuneAdapterScope] or pass it directly when creating a [Picker] object.
///
/// It is also possible to pass it as [MasamuneAdapter] in [runMasamuneApp].
///
/// [Picker]でファイルピックを行うための内部処理を定義するためのアダプター。
///
/// ファイルピックの機能によってはプラットフォームを制限するものがある（カメラ機能など）ため必要であればアダプターを定義して利用します。
///
/// 利用したい[PickerMasamuneAdapter]がある場合は、[PickerMasamuneAdapterScope]で予め定義するか[Picker]のオブジェクト作成時に直接渡してください。
///
/// [runMasamuneApp]で[MasamuneAdapter]として渡すことも可能です。
abstract class PickerMasamuneAdapter extends MasamuneAdapter {
  /// Adapter for defining the internal process for file picks in [Picker].
  ///
  /// Some file pick functions restrict the platform (e.g., camera functions), so if necessary, an adapter can be defined and used.
  ///
  /// If you have a [PickerMasamuneAdapter] that you want to use, define it in advance in [PickerMasamuneAdapterScope] or pass it directly when creating a [Picker] object.
  ///
  /// It is also possible to pass it as [MasamuneAdapter] in [runMasamuneApp].
  ///
  /// [Picker]でファイルピックを行うための内部処理を定義するためのアダプター。
  ///
  /// ファイルピックの機能によってはプラットフォームを制限するものがある（カメラ機能など）ため必要であればアダプターを定義して利用します。
  ///
  /// 利用したい[PickerMasamuneAdapter]がある場合は、[PickerMasamuneAdapterScope]で予め定義するか[Picker]のオブジェクト作成時に直接渡してください。
  ///
  /// [runMasamuneApp]で[MasamuneAdapter]として渡すことも可能です。
  const PickerMasamuneAdapter();

  /// You can retrieve the [PickerMasamuneAdapter] first given by [PickerMasamuneAdapterScope].
  ///
  /// 最初に[PickerMasamuneAdapterScope]で与えた[PickerMasamuneAdapter]を取得することができます。
  static PickerMasamuneAdapter get primary {
    assert(
      _primary != null,
      "PickerMasamuneAdapter is not set. Place [PickerAdapterScope] widget closer to the root.",
    );
    return _primary ?? const TestPickerMasamuneAdapter();
  }

  static PickerMasamuneAdapter? _primary;

  /// Implement a process to pick up single files.
  ///
  /// The title of the file dialog to be picked up is passed in [dialogTitle].
  ///
  /// Please specify [type] to restrict the type of file.
  ///
  /// 単一のファイルをピックアップするための処理を実装してください。
  ///
  /// [dialogTitle]でピックアップする際のファイルダイアログのタイトルが渡されます。
  ///
  /// [type]を指定するとファイルの種類を制限するようにしてください。
  Future<PickerValue> pickSingle({
    String? dialogTitle,
    PickerFileType type = PickerFileType.any,
  });

  /// Implement a process to pick up multiple files.
  ///
  /// The title of the file dialog to be picked up is passed in [dialogTitle].
  ///
  /// Please specify [type] to restrict the type of file.
  ///
  /// 複数のファイルをピックアップするための処理を実装してください。
  ///
  /// [dialogTitle]でピックアップする際のファイルダイアログのタイトルが渡されます。
  ///
  /// [type]を指定するとファイルの種類を制限するようにしてください。
  Future<List<PickerValue>> pickMultiple({
    String? dialogTitle,
    PickerFileType type = PickerFileType.any,
  });

  /// Implement a process to activate the camera and pick up the captured media files.
  ///
  /// The title of the file dialog to be picked up is passed in [dialogTitle].
  ///
  /// Please specify [type] to restrict the type of file.
  ///
  /// カメラを起動し、撮影したメディアファイルをピックアップするための処理を実装してください。
  ///
  /// [dialogTitle]でピックアップする際のファイルダイアログのタイトルが渡されます。
  ///
  /// [type]を指定するとファイルの種類を制限するようにしてください。
  Future<PickerValue> pickCamera({
    String? dialogTitle,
    PickerFileType type = PickerFileType.any,
  });

  @override
  void onInitScope(MasamuneAdapter adapter) {
    super.onInitScope(adapter);
    if (adapter is PickerMasamuneAdapter) {
      PickerMasamuneAdapter._primary ??= adapter;
    }
  }

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<PickerMasamuneAdapter>(
      adapter: this,
      onInit: onInitScope,
      child: app,
    );
  }
}
