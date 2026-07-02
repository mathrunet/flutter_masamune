// ignore_for_file: public_member_api_docs

import "package:mysql_client_plus/mysql_client_plus.dart";

class TidbDirectClient {
  const TidbDirectClient._(this._connection);

  final MySQLConnection _connection;

  static Future<TidbDirectClient> connect({
    required String host,
    required int port,
    required String username,
    required String password,
    required String database,
  }) async {
    final connection = await MySQLConnection.createConnection(
      host: host,
      port: port,
      userName: username,
      password: password,
      databaseName: database,
      secure: true,
    );
    await connection.connect();
    return TidbDirectClient._(connection);
  }

  Future<void> execute(String sql, {List<Object?> positional = const []}) async {
    await _connection.execute(
      _replacePlaceholders(sql, positional.length),
      _buildParams(positional),
    );
  }

  Future<List<Map<String, dynamic>>> query(
    String sql, {
    List<Object?> positional = const [],
  }) async {
    final result = await _connection.execute(
      _replacePlaceholders(sql, positional.length),
      _buildParams(positional),
    );
    return result.rows.map((row) => row.typedAssoc()).toList();
  }

  Future<TidbDirectTransaction> transaction() async {
    await _connection.execute("START TRANSACTION");
    return TidbDirectTransaction._(_connection);
  }

  Future<void> close() async {
    await _connection.close();
  }
}

class TidbDirectTransaction {
  const TidbDirectTransaction._(this._connection);

  final MySQLConnection _connection;

  Future<void> execute(String sql, {List<Object?> positional = const []}) async {
    await _connection.execute(
      _replacePlaceholders(sql, positional.length),
      _buildParams(positional),
    );
  }

  Future<void> commit() async {
    await _connection.execute("COMMIT");
  }

  Future<void> rollback() async {
    await _connection.execute("ROLLBACK");
  }
}

String _replacePlaceholders(String sql, int count) {
  var index = 0;
  return sql.replaceAllMapped("?", (_) {
    if (index >= count) {
      return "?";
    }
    return ":p${index++}";
  });
}

Map<String, dynamic> _buildParams(List<Object?> values) {
  return Map.fromEntries(values.indexed.map((entry) {
    final (index, value) = entry;
    return MapEntry("p$index", value);
  }));
}
