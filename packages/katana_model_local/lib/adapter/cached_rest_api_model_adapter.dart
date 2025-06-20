part of "/katana_model_local.dart";

/// Defines [ModelAdapter] to define [builders] and make them work accordingly.
///
/// You can declaratively describe communication with RestAPI.
///
/// [builders]を定義してそれに対応した動作をさせるための[ModelAdapter]。
///
/// RestAPIとの通信を宣言的に記述することができます。
abstract class CachedRestApiModelAdapter extends RestApiModelAdapter {
  /// Defines [ModelAdapter] to define [builders] and make them work accordingly.
  ///
  /// You can declaratively describe communication with RestAPI.
  ///
  /// [builders]を定義してそれに対応した動作をさせるための[ModelAdapter]。
  ///
  /// RestAPIとの通信を宣言的に記述することができます。
  const CachedRestApiModelAdapter({
    required super.builders,
    required super.endpoint,
    NoSqlDatabase? database,
    super.validator,
    super.headers = RestApiModelAdapter.defaultHeaders,
    super.checkError = RestApiModelAdapter.defaultCheckError,
  }) : _database = database;

  /// Designated database. Please use for testing purposes, etc.
  ///
  /// 指定のデータベース。テスト用途などにご利用ください。
  @override
  NoSqlDatabase get database {
    final database = _database ?? sharedDatabase;
    return database;
  }

  final NoSqlDatabase? _database;

  /// A common database throughout the application.
  ///
  /// アプリ内全体での共通のデータベース。
  static final NoSqlDatabase sharedDatabase = NoSqlDatabase(
    onInitialize: (database) async {
      try {
        database.data = await DatabaseExporter.import(
          "${await DatabaseExporter.documentDirectory}/${_kLocalDatabaseId.toSHA1()}",
        );
      } catch (e) {
        database.data = {};
      }
    },
    onSaved: (database) async {
      await DatabaseExporter.export(
        "${await DatabaseExporter.documentDirectory}/${_kLocalDatabaseId.toSHA1()}",
        database.data,
      );
    },
    onDeleted: (database) async {
      await DatabaseExporter.export(
        "${await DatabaseExporter.documentDirectory}/${_kLocalDatabaseId.toSHA1()}",
        database.data,
      );
    },
    onClear: (database) async {
      await DatabaseExporter.export(
        "${await DatabaseExporter.documentDirectory}/${_kLocalDatabaseId.toSHA1()}",
        {},
      );
    },
  );
}
