part of katana_flutter;

/// Gender.
///
/// Male, Female and others are defined.
enum Gender {
  /// Male.
  male,

  /// Female.
  female,

  /// Others.
  other,
}

extension GenderExtensions on Gender {
  /// Gender id.
  String get id {
    switch (this) {
      case Gender.male:
        return "male";
      case Gender.female:
        return "female";
      case Gender.other:
        return "other";
    }
  }

  /// Gender name.
  String get name {
    switch (this) {
      case Gender.male:
        return "Male".localize();
      case Gender.female:
        return "Female".localize();
      case Gender.other:
        return "Others".localize();
    }
  }
}
