part of '/masamune_app_review.dart';

/// [MasamuneControllerBase] for reviewing applications in the store.
///
/// [review] reviews the application in the store.
///
/// ストアにおけるアプリレビューを行うための[MasamuneControllerBase]。
///
/// [review]でストアにおけるアプリレビューを行います。
class AppReview extends MasamuneControllerBase<void, AppReviewMasamuneAdapter> {
  /// [MasamuneControllerBase] for reviewing applications in the store.
  ///
  /// [review] reviews the application in the store.
  ///
  /// ストアにおけるアプリレビューを行うための[MasamuneControllerBase]。
  ///
  /// [review]でストアにおけるアプリレビューを行います。
  AppReview({super.adapter});

  /// Query for Picker.
  ///
  /// ```dart
  /// appRef.controller(AppReview.query(parameters));     // Get from application scope.
  /// ref.app.controller(AppReview.query(parameters));    // Watch at application scope.
  /// ref.page.controller(AppReview.query(parameters));   // Watch at page scope.
  /// ```
  static const query = _$AppReviewQuery();

  @override
  AppReviewMasamuneAdapter get primaryAdapter =>
      AppReviewMasamuneAdapter.primary;

  static final InAppReview _instance = InAppReview.instance;

  /// Review by store.
  ///
  /// Check whether review is possible on the OS.
  /// If it is difficult to review on the OS, open the store URL.
  ///
  /// ストアによるレビューを行います。
  ///
  /// まずOSでのレビューが可能かどうかのチェックを行いそれが難しい場合は
  /// ストアのURLを開くようにします。
  Future<void> review() async {
    try {
      if (kIsWeb) {
        throw Exception('Review is not available on web.');
      }
      if (await _instance.isAvailable()) {
        _instance.requestReview();
      } else {
        final url = UniversalPlatform.isIOS
            ? adapter.appStoreUrl
            : adapter.googlePlayStoreUrl;

        if (url == null || !await launchUrl(Uri.parse(url))) {
          throw Exception("Cannot launch the store URL");
        }
      }
    } catch (e) {
      rethrow;
    }
  }
}

@immutable
class _$AppReviewQuery {
  const _$AppReviewQuery();

  @useResult
  _$_AppReviewQuery call() => _$_AppReviewQuery(
        hashCode.toString(),
      );
}

@immutable
class _$_AppReviewQuery extends ControllerQueryBase<AppReview> {
  const _$_AppReviewQuery(
    this._name,
  );

  final String _name;

  @override
  AppReview Function() call(Ref ref) {
    return () => AppReview();
  }

  @override
  String get queryName => _name;
  @override
  bool get autoDisposeWhenUnreferenced => true;
}
