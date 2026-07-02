// ignore_for_file: public_member_api_docs

class TidbDirectClient {
  static Future<TidbDirectClient> connect({
    required String host,
    required int port,
    required String username,
    required String password,
    required String database,
  }) {
    throw UnsupportedError("Direct TiDB access is not supported.");
  }

  Future<void> execute(String sql, {List<Object?> positional = const []}) {
    throw UnsupportedError("Direct TiDB access is not supported.");
  }

  Future<List<Map<String, dynamic>>> query(
    String sql, {
    List<Object?> positional = const [],
  }) {
    throw UnsupportedError("Direct TiDB access is not supported.");
  }

  Future<TidbDirectTransaction> transaction() {
    throw UnsupportedError("Direct TiDB access is not supported.");
  }

  Future<void> close() async {}
}

class TidbDirectTransaction {
  Future<void> execute(String sql, {List<Object?> positional = const []}) {
    throw UnsupportedError("Direct TiDB access is not supported.");
  }

  Future<void> commit() {
    throw UnsupportedError("Direct TiDB access is not supported.");
  }

  Future<void> rollback() {
    throw UnsupportedError("Direct TiDB access is not supported.");
  }
}
