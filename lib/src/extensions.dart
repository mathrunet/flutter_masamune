part of masamune;

const double kMobileBreakPoint = 768;

extension TextEditingControllerExtensions on TextEditingController? {
  bool get isEmpty {
    if (this == null) {
      return true;
    }
    return this!.text.isEmpty;
  }

  bool get isNotEmpty {
    if (this == null) {
      return false;
    }
    return this!.text.isNotEmpty;
  }
}

extension ButtonStyleExtension on ButtonStyle {
  ButtonStyle addState({
    Color? backgroundColor,
    Color? foregroundColor,
    Set<MaterialState> state = const {
      MaterialState.focused,
      MaterialState.hovered,
      MaterialState.pressed,
      MaterialState.selected,
    },
  }) {
    return copyWith(
      backgroundColor: MaterialStateProperty.resolveWith((st) {
        if (st.containsAny(state)) {
          return backgroundColor ?? this.backgroundColor?.resolve(st);
        }
        return this.backgroundColor?.resolve(st);
      }),
      foregroundColor: MaterialStateProperty.resolveWith((st) {
        if (st.containsAny(state)) {
          return foregroundColor ?? this.foregroundColor?.resolve(st);
        }
        return this.foregroundColor?.resolve(st);
      }),
    );
  }
}

extension PlatformBuildContextExtensions on BuildContext {
  bool get isMobile => Config.isMobile;

  bool get isMobileOrSmall {
    if (isMobile) {
      return true;
    }
    return mediaQuery.size.width <= kMobileBreakPoint;
  }

  bool get isDesktop => Config.isDesktop;

  bool get isModal {
    return ModalRoute.of(this) is UIModalRoute;
  }

  bool get isMobileOrModal => isModal || isMobile;

  bool get isFullscreen {
    final parentRoute = ModalRoute.of(this);
    return parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;
  }
}

extension NetworkOrAssetDynamicMapExtensions on DynamicMap {
  ImageProvider getAsImage(
    String key, [
    ImageSize size = ImageSize.full,
    String defaultURI = "assets/default.png",
  ]) {
    final uri = get(key, "");
    return NetworkOrAsset.image(uri, size, defaultURI);
  }

  VideoProvider getAsVideo(String key,
      [String defaultURI = "assets/default.mp4"]) {
    final uri = get(key, "");
    return NetworkOrAsset.video(uri, defaultURI);
  }
}
