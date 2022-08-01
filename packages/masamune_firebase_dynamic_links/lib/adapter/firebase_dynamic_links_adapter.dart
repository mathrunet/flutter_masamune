part of masamune_firebase_dynamic_links;

@immutable
class FirebaseDynamicLinksAdapter extends DynamicLinksAdapter {
  const FirebaseDynamicLinksAdapter({
    this.options,
    this.onUpdateLinkWhenAlways,
    this.onUpdateLinkWhenAuthenticated,
  });

  final FirebaseDynamicLinksOptions? options;

  final void Function(BuildContext context, Uri link)?
      onUpdateLinkWhenAuthenticated;
  final void Function(BuildContext context, Uri link)? onUpdateLinkWhenAlways;

  @override
  Future<void> listen([void Function(Uri link)? onUpdate]) {
    return FirebaseDynamicLinksCore.listen(onUpdate);
  }

  @override
  Future<String> create(
    String url, {
    String? socialDescription,
    String? socialImageURL,
    String? socialTitle,
  }) async {
    assert(options != null, "Specify the FreebaseDynamicLinksOptions.");
    return await FirebaseDynamicLinksUrlCore.create(
      url,
      options: options!,
      socialDescription: socialDescription,
      socialImageURL: socialImageURL,
      socialTitle: socialTitle,
    );
  }

  /// It is executed after the boot process is finished and
  /// after transitioning to another page.
  @override
  @mustCallSuper
  Future<void> onAfterFinishBoot(BuildContext context) async {
    await _listen(context);
    return super.onAfterFinishBoot(context);
  }

  Future<void> _listen(BuildContext context) async {
    await listen((link) {
      final signIn = context.model?.isSignedIn ?? false;
      if (onUpdateLinkWhenAuthenticated != null) {
        if (signIn) {
          onUpdateLinkWhenAuthenticated?.call(context, link);
        } else {
          onUpdateLinkWhenAlways?.call(context, link);
        }
      } else if (onUpdateLinkWhenAlways != null) {
        onUpdateLinkWhenAlways?.call(context, link);
      } else {
        final path = link.path;
        if (path.isEmpty) {
          return;
        }
        context.rootNavigator.pushNamed(
          path,
          arguments: RouteQuery.fullscreen,
        );
      }
    });
  }
}
