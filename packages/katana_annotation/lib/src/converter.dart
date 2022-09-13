part of katana_annotation;

/// Base class for defining the Builder's conversion method.
abstract class ConverterBase {
  const ConverterBase();

  /// Converter for converting [value] to type [T].
  T? convertFrom<T>(dynamic value);

  /// Conversion to store [value] of type [T] as a value in [DynamicMap].
  dynamic convertTo<T>(T value);
}

/// Default converter.
class DefaultConverter extends ConverterBase {
  const DefaultConverter();

  @override
  T? convertFrom<T>(dynamic value) {
    if (value == null) {
      return null;
    }
    switch (T) {
      case DateTime:
        if (value is num) {
          return DateTime.fromMillisecondsSinceEpoch(value.toInt()) as T;
        } else if (value is String) {
          return DateTime.parse(value) as T;
        }
        throw Exception(
          "Could not convert ${value.runtimeType} to ${T.toString()}.",
        );
      case int:
        if (value is int) {
          return value.toInt() as T;
        } else if (value is String) {
          return int.parse(value) as T;
        }
        throw Exception(
          "Could not convert ${value.runtimeType} to ${T.toString()}.",
        );
      case double:
        if (value is num) {
          return value.toDouble() as T;
        } else if (value is String) {
          return double.parse(value) as T;
        }
        throw Exception(
          "Could not convert ${value.runtimeType} to ${T.toString()}.",
        );
      case String:
        return value.toString() as T;
      default:
        return value as T;
    }
  }

  @override
  dynamic convertTo<T>(T value) {
    if (value is DateTime) {
      return value.millisecondsSinceEpoch;
    }
    return value;
  }
}
