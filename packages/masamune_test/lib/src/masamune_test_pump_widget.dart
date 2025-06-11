part of "/masamune_test.dart";

class _MasamuneTestPumpWidget {
  _MasamuneTestPumpWidget({
    this.images = const [],
  });

  final List<ImageProvider> images;

  Future<void> _pumpWidget(
      flutter_test.WidgetTester tester, Widget widget) async {
    await tester.pumpWidget(widget);
    await tester.runAsync(() async {
      var retryCount = 0;
      while (flutter_test.find.byType(_MasamuneTestLoaded).evaluate().isEmpty) {
        retryCount++;
        await tester.pumpAndSettle();
        await tester.pumpWidget(widget);
        if (retryCount > 10) {
          throw Exception("Failed to find MasamuneTestLoaded");
        }
      }
      final loader =
          flutter_test.find.byType(_MasamuneTestLoaded).evaluate().first;
      final images = <Future<void>>[];
      for (final image in this.images) {
        images.add(precacheImage(image, loader));
      }
      for (final element in flutter_test.find.byType(Image).evaluate()) {
        final widget = element.widget as Image;
        final image = widget.image;
        images.add(precacheImage(image, element));
      }
      for (final element in flutter_test.find.byType(FadeInImage).evaluate()) {
        final widget = element.widget as FadeInImage;
        final image = widget.image;
        images.add(precacheImage(image, element));
      }
      for (final element in flutter_test.find.byType(DecoratedBox).evaluate()) {
        final widget = element.widget as DecoratedBox;
        final decoration = widget.decoration;
        if (decoration is BoxDecoration && decoration.image != null) {
          final image = decoration.image!.image;
          images.add(precacheImage(image, element));
        }
      }
      await Future.wait(images);
    });
    await tester.pumpWidget(widget);
  }
}
