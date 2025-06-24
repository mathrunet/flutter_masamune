part of "/katana_localization_annotation.dart";

/// This is an annotation for automatically generating multilingual code from a Yaml file.
///
/// Create the Yaml file in the specified format and place it at the path specified in [path].
/// Call the key specified in `key` to get translations in languages such as `ja_JP` and `en_US`.
///
/// By adding an annotation and creating a class that inherits from `_$AppLocalize`, as shown in the example below, you can use the localization feature.
///
/// Yamlファイルを元に多言語化コードを自動作成するためのアノテーションです。
///
/// 事前のフォーマットでYamlを作成し[path]に指定したパスに配置します。
/// `key`に指定したキーを呼び出し、`ja_JP`や`en_US`に指定した言語での翻訳を取得します。
///
/// ```yaml
/// localize:
///   - key: "hello"
///     ja_JP: "こんにちは"
///     en_US: "Hello"
///   - key: "world"
///     ja_JP: "世界"
///     en_US: "World"
/// ```
///
/// 下記の例のようにアノテーションを付与して`_$AppLocalize`を継承したクラスを作成することで多言語化用の機能を利用することができます。
///
/// ```dart
/// @yamlLocalize
/// class AppLocalize extends _$AppLocalize {
/// }
///
/// final l = AppLocalize();
/// ```
const yamlLocalize = YamlLocalize();

/// This is an annotation for automatically generating multilingual code from a Yaml file.
///
/// Create the Yaml file in the specified format and place it at the path specified in [path].
/// Call the key specified in `key` to get translations in languages such as `ja_JP` and `en_US`.
///
/// By adding an annotation and creating a class that inherits from `_$AppLocalize`, as shown in the example below, you can use the localization feature.
///
/// Yamlファイルを元に多言語化コードを自動作成するためのアノテーションです。
///
/// 事前のフォーマットでYamlを作成し[path]に指定したパスに配置します。
/// `key`に指定したキーを呼び出し、`ja_JP`や`en_US`に指定した言語での翻訳を取得します。
///
/// ```yaml
/// localize:
///   - key: "hello"
///     ja_JP: "こんにちは"
///     en_US: "Hello"
///   - key: "world"
///     ja_JP: "世界"
///     en_US: "World"
/// ```
///
/// 下記の例のようにアノテーションを付与して`_$AppLocalize`を継承したクラスを作成することで多言語化用の機能を利用することができます。
///
/// ```dart
/// @yamlLocalize
/// class AppLocalize extends _$AppLocalize {
/// }
///
/// final l = AppLocalize();
/// ```
class YamlLocalize {
  /// This is an annotation for automatically generating multilingual code from a Yaml file.
  ///
  /// Create the Yaml file in the specified format and place it at the path specified in [path].
  /// Call the key specified in `key` to get translations in languages such as `ja_JP` and `en_US`.
  ///
  /// By adding an annotation and creating a class that inherits from `_$AppLocalize`, as shown in the example below, you can use the localization feature.
  ///
  /// Yamlファイルを元に多言語化コードを自動作成するためのアノテーションです。
  ///
  /// 事前のフォーマットでYamlを作成し[path]に指定したパスに配置します。
  /// `key`に指定したキーを呼び出し、`ja_JP`や`en_US`に指定した言語での翻訳を取得します。
  ///
  /// ```yaml
  /// localize:
  ///   - key: "hello"
  ///     ja_JP: "こんにちは"
  ///     en_US: "Hello"
  ///   - key: "world"
  ///     ja_JP: "世界"
  ///     en_US: "World"
  /// ```
  ///
  /// 下記の例のようにアノテーションを付与して`_$AppLocalize`を継承したクラスを作成することで多言語化用の機能を利用することができます。
  ///
  /// ```dart
  /// @yamlLocalize
  /// class AppLocalize extends _$AppLocalize {
  /// }
  ///
  /// final l = AppLocalize();
  /// ```
  const YamlLocalize({
    this.path = const ["localize.base.yaml", "localize.app.yaml"],
  });

  /// The path to the Yaml file.
  ///
  /// The Yaml file must be in the specified format.
  ///
  /// YAMLファイルへのパス。
  ///
  /// 指定したフォーマットでYAMLファイルを作成します。
  ///
  /// ```yaml
  /// localize:
  ///   - key: "hello"
  ///     ja_JP: "こんにちは"
  ///     en_US: "Hello"
  ///   - key: "world"
  ///     ja_JP: "世界"
  ///     en_US: "World"
  /// ```
  final List<String> path;
}
