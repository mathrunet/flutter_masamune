part of katana_flutter;

/// Ages.
///
/// The constants are defined from the teens to the 60s.
enum Ages {
  /// 10s.
  teens,

  /// 20s.
  twenties,

  /// 30s.
  thirties,

  /// 40s.
  forties,

  /// 50s.
  fifties,

  /// 60s.
  sixties,
}

extension AgesExtensions on Ages {
  /// Ages id.
  String get id {
    switch (this) {
      case Ages.teens:
        return "teens";
      case Ages.twenties:
        return "twenties";
      case Ages.thirties:
        return "thirties";
      case Ages.forties:
        return "forties";
      case Ages.fifties:
        return "fifties";
      case Ages.sixties:
        return "sixties";
    }
  }

  /// Ages name.
  String get name {
    switch (this) {
      case Ages.teens:
        return "10s".localize();
      case Ages.twenties:
        return "20s".localize();
      case Ages.thirties:
        return "30s".localize();
      case Ages.forties:
        return "40s".localize();
      case Ages.fifties:
        return "50s".localize();
      case Ages.sixties:
        return "60s".localize();
    }
  }
}
