part of katana_routing;

/// Theme data for images.
@immutable
class ImageTheme extends ThemeExtension<ImageTheme> {
  const ImageTheme({
    this.landingBackgroundImage,
    this.landingFeatureImage,
    this.backgroundImage,
    this.bootBackgroundImage,
    this.bootFeatureImage,
    this.homeFeatureImage,
  });

  /// Landing Page Background.
  final String? landingBackgroundImage;

  /// Landing page featured image.
  final String? landingFeatureImage;

  /// Feature image of the boot screen.
  final String? bootFeatureImage;

  /// Background image of the boot screen.
  final String? bootBackgroundImage;

  /// Normal screen background.
  final String? backgroundImage;

  /// Featured image of the home screen.
  final String? homeFeatureImage;

  @override
  ImageTheme copyWith({
    String? landingBackgroundImage,
    String? landingFeatureImage,
    String? bootFeatureImage,
    String? bootBackgroundImage,
    String? backgroundImage,
    String? homeFeatureImage,
  }) {
    return ImageTheme(
      landingBackgroundImage:
          landingBackgroundImage ?? this.landingBackgroundImage,
      landingFeatureImage: landingFeatureImage ?? this.landingFeatureImage,
      bootFeatureImage: bootFeatureImage ?? this.bootFeatureImage,
      bootBackgroundImage: bootBackgroundImage ?? this.bootBackgroundImage,
      backgroundImage: backgroundImage ?? this.backgroundImage,
      homeFeatureImage: homeFeatureImage ?? this.homeFeatureImage,
    );
  }

  @override
  ImageTheme lerp(ThemeExtension<ImageTheme>? other, double t) {
    throw UnimplementedError();
  }
}
