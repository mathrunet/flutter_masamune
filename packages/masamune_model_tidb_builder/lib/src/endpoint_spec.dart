// Dart imports:
import "dart:convert";

// Project imports:
import "rules_reader.dart";

/// A column generated from a Masamune model field.
class TidbColumnSpec {
  /// Creates a column specification.
  const TidbColumnSpec({
    required this.name,
    required this.sqlType,
    this.required = false,
  });

  /// Column name.
  final String name;

  /// TiDB SQL type.
  final String sqlType;

  /// Whether model construction requires this field.
  final bool required;
}

/// A table generated from one annotated Masamune model.
class TidbTableSpec {
  /// Creates a table specification.
  const TidbTableSpec({
    required this.database,
    required this.table,
    required this.columns,
  });

  /// Database name.
  final String database;

  /// Table name.
  final String table;

  /// Columns including Masamune reserved columns.
  final List<TidbColumnSpec> columns;
}

/// A parameter accepted by a custom Data Service endpoint.
class TidbCustomEndpointParameterSpec {
  /// Creates a custom endpoint parameter.
  const TidbCustomEndpointParameterSpec({
    required this.name,
    this.type = "string",
    this.required = true,
    this.defaultValue = "",
  });

  /// Parameter name.
  final String name;

  /// Data Service parameter type.
  final String type;

  /// Whether callers must provide the value.
  final bool required;

  /// Default value.
  final String defaultValue;
}

/// A server-only custom SQL endpoint.
class TidbCustomEndpointSpec {
  /// Creates a custom endpoint specification.
  const TidbCustomEndpointSpec({
    required this.name,
    required this.path,
    required this.sql,
    this.method = "POST",
    this.parameters = const [],
    this.timeoutMilliseconds = 30000,
    this.rowLimit = 2000,
  });

  /// Stable manifest key.
  final String name;

  /// Endpoint path.
  final String path;

  /// SQL source.
  final String sql;

  /// HTTP method.
  final String method;

  /// Endpoint parameters.
  final List<TidbCustomEndpointParameterSpec> parameters;

  /// Endpoint timeout.
  final int timeoutMilliseconds;

  /// Maximum returned or affected rows.
  final int rowLimit;
}

/// Complete output of the TiDB Data Service generator.
class TidbGeneratedArtifacts {
  /// Creates generated artifacts.
  const TidbGeneratedArtifacts(this.files);

  /// Relative output path to file contents.
  final Map<String, String> files;
}

/// Single source of truth for the Workers/Data Service endpoint convention.
class TidbEndpointSpec {
  /// Generates official Data Service CaC files and Masamune manifests.
  static TidbGeneratedArtifacts generate({
    required List<TidbTableSpec> tables,
    required TidbRulesReader rules,
    List<TidbCustomEndpointSpec> customEndpoints = const [],
    String appId = "",
    String appName = "masamune",
    String clusterId = "0",
  }) {
    final sorted = [...tables]..sort((a, b) =>
        "${a.database}.${a.table}".compareTo("${b.database}.${b.table}"));
    final endpointConfigs = <Map<String, dynamic>>[];
    final manifestTables = <String, dynamic>{};
    final manifestCustomEndpoints = <String, dynamic>{};
    final files = <String, String>{};
    final schema = StringBuffer(
      "-- GENERATED CODE - DO NOT MODIFY BY HAND.\n"
      "-- Additive schema migration for TiDB Data Service.\n\n",
    );

    for (final table in sorted) {
      _validateIdentifier(table.database, "database");
      _validateIdentifier(table.table, "table");
      final columns = _mergeReservedColumns(table.columns);
      schema
        ..writeln("CREATE DATABASE IF NOT EXISTS `${table.database}`;")
        ..writeln("USE `${table.database}`;")
        ..writeln("CREATE TABLE IF NOT EXISTS `${table.table}` (")
        ..writeln(columns.map(_columnDefinition).join(",\n"))
        ..writeln(");")
        ..writeln();
      for (final column in columns.where((column) => column.name != "id")) {
        schema.writeln(
          "ALTER TABLE `${table.table}` ADD COLUMN IF NOT EXISTS "
          "`${column.name}` ${column.sqlType};",
        );
      }
      schema.writeln();

      final operations = <String, Map<String, String>>{};
      final readDenied = rules.isExplicitlyDenied(
        table.database,
        table.table,
        TidbRulesOperation.get,
      );
      final createDenied = rules.isExplicitlyDenied(
        table.database,
        table.table,
        TidbRulesOperation.create,
      );
      final updateDenied = rules.isExplicitlyDenied(
        table.database,
        table.table,
        TidbRulesOperation.update,
      );
      final deleteDenied = rules.isExplicitlyDenied(
        table.database,
        table.table,
        TidbRulesOperation.delete,
      );
      if (!readDenied) {
        for (final operation in ["get", "list", "count"]) {
          _addEndpoint(
            files: files,
            configs: endpointConfigs,
            operations: operations,
            table: table,
            columns: columns,
            operation: operation,
            clusterId: clusterId,
            description: "Generated from rules.json read access.",
          );
        }
      }
      if (!(createDenied && updateDenied)) {
        _addEndpoint(
          files: files,
          configs: endpointConfigs,
          operations: operations,
          table: table,
          columns: columns,
          operation: "upsert",
          clusterId: clusterId,
          description: "Generated from rules.json create/update access.",
        );
      }
      if (!updateDenied) {
        _addEndpoint(
          files: files,
          configs: endpointConfigs,
          operations: operations,
          table: table,
          columns: columns,
          operation: "update",
          clusterId: clusterId,
          description: "Generated from rules.json update access.",
        );
      }
      if (!deleteDenied) {
        _addEndpoint(
          files: files,
          configs: endpointConfigs,
          operations: operations,
          table: table,
          columns: columns,
          operation: "delete",
          clusterId: clusterId,
          description: "Generated from rules.json delete access.",
        );
      }
      manifestTables["${table.database}\u0000${table.table}"] = {
        "database": table.database,
        "table": table.table,
        "columns": columns.map((column) => column.name).toList(),
        "endpoints": operations,
      };
    }

    final customNames = <String>{};
    final customPaths = <String>{};
    for (final endpoint in customEndpoints) {
      _validateIdentifier(endpoint.name, "custom endpoint name");
      if (!customNames.add(endpoint.name)) {
        throw ArgumentError("Duplicate custom endpoint name: ${endpoint.name}");
      }
      final method = endpoint.method.toUpperCase();
      if (method != "GET" && method != "POST") {
        throw ArgumentError(
          "Custom endpoint method must be GET or POST: $method",
        );
      }
      if (!endpoint.path.startsWith("/") ||
          endpoint.path.contains("..") ||
          endpoint.path.split("/").where((part) => part.isNotEmpty).isEmpty) {
        throw ArgumentError(
          "Custom endpoint path must be an absolute Data Service path.",
        );
      }
      final pathKey = "$method ${endpoint.path}";
      if (!customPaths.add(pathKey)) {
        throw ArgumentError("Duplicate custom endpoint path: $pathKey");
      }
      if (endpoint.sql.trim().isEmpty) {
        throw ArgumentError(
          "Custom endpoint SQL must not be empty: ${endpoint.name}",
        );
      }
      if (endpoint.timeoutMilliseconds < 1 || endpoint.rowLimit < 1) {
        throw ArgumentError(
          "Custom endpoint timeout and row limit must be positive.",
        );
      }
      final parameterNames = <String>{};
      for (final parameter in endpoint.parameters) {
        _validateIdentifier(parameter.name, "custom endpoint parameter");
        if (!parameterNames.add(parameter.name)) {
          throw ArgumentError(
            "Duplicate parameter `${parameter.name}` in ${endpoint.name}.",
          );
        }
      }
      final sqlFile = "sql/$method-custom-${endpoint.name}.sql";
      endpointConfigs.add({
        "name": endpoint.name,
        "description": "Generated server-only custom endpoint.",
        "method": method,
        "endpoint": endpoint.path,
        "data_source": {
          "cluster_id": int.tryParse(clusterId) ?? clusterId,
        },
        "params": endpoint.parameters
            .map(
              (parameter) => _parameter(
                parameter.name,
                type: parameter.type,
                required: parameter.required,
                defaultValue: parameter.defaultValue,
              ),
            )
            .toList(),
        "settings": {
          "timeout": endpoint.timeoutMilliseconds,
          "row_limit": endpoint.rowLimit,
          "enable_pagination": 0,
          "cache_enabled": 0,
          "cache_ttl": 30,
        },
        "tag": "MasamuneServer",
        "batch_operation": 0,
        "sql_file": sqlFile,
        "type": "sql_endpoint",
        "return_type": "json",
      });
      files["http_endpoints/$sqlFile"] =
          endpoint.sql.endsWith("\n") ? endpoint.sql : "${endpoint.sql}\n";
      manifestCustomEndpoints[endpoint.name] = {
        "path": endpoint.path,
        "method": method,
      };
    }

    files["data_sources/cluster.json"] = _json([
      {"cluster_id": int.tryParse(clusterId) ?? clusterId},
    ]);
    files["dataapp_config.json"] = _json({
      "app_id": appId,
      "app_name": appName,
      "app_type": "dataapi",
      "app_version": "1.0.0",
      "description": "Generated by masamune_model_tidb_builder.",
    });
    files["http_endpoints/config.json"] = _json(endpointConfigs);
    files["__masamune/schema.sql"] = schema.toString();
    files["__generated_manifest.json"] = _json({
      "version": "1",
      "tables": manifestTables,
      "custom_endpoints": manifestCustomEndpoints,
      "generated_files": [...files.keys, "__generated_manifest.json"]..sort(),
    });
    return TidbGeneratedArtifacts(files);
  }

  static void _addEndpoint({
    required Map<String, String> files,
    required List<Map<String, dynamic>> configs,
    required Map<String, Map<String, String>> operations,
    required TidbTableSpec table,
    required List<TidbColumnSpec> columns,
    required String operation,
    required String clusterId,
    required String description,
  }) {
    final method =
        ["get", "list", "count"].contains(operation) ? "GET" : "POST";
    final endpoint = _endpointPath(table.database, table.table, operation);
    final sqlFile =
        "sql/$method-${endpoint.substring(1).replaceAll("/", "-")}.sql";
    final params = _parameters(operation, columns);
    configs.add({
      "name": "${table.database}_${table.table}_$operation",
      "description": description,
      "method": method,
      "endpoint": endpoint,
      "data_source": {
        "cluster_id": int.tryParse(clusterId) ?? clusterId,
      },
      "params": params,
      "settings": {
        "timeout": 30000,
        "row_limit": 2000,
        "enable_pagination": 0,
        "cache_enabled": 0,
        "cache_ttl": 30,
      },
      "tag": "Masamune",
      "batch_operation": 0,
      "sql_file": sqlFile,
      "type": "sql_endpoint",
      "return_type": "json",
    });
    files["http_endpoints/$sqlFile"] = _sql(operation, table, columns);
    operations[operation] = {"path": endpoint, "method": method};
  }

  static List<Map<String, dynamic>> _parameters(
    String operation,
    List<TidbColumnSpec> columns,
  ) {
    if (operation == "get" || operation == "delete") {
      return [_parameter("id", required: true)];
    }
    if (operation == "list" || operation == "count") {
      final values = <Map<String, dynamic>>[];
      for (final column in columns) {
        for (final suffix in ["", "_ne", "_lt", "_lte", "_gt", "_gte", "_in"]) {
          values.add(_parameter(
            "${column.name}$suffix",
            defaultValue: "__MASAMUNE_UNSET__",
          ));
        }
      }
      if (operation == "list") {
        values.add(_parameter("limit", type: "integer", defaultValue: "1001"));
      }
      return values;
    }
    final update = operation == "update";
    return columns
        .where((column) => !update || column.name != "created_at")
        .map((column) => _parameter(
              column.name,
              required: true,
              type: _parameterType(column.sqlType),
            ))
        .toList();
  }

  static Map<String, dynamic> _parameter(
    String name, {
    String type = "string",
    bool required = false,
    String? defaultValue,
  }) {
    return {
      "name": name,
      "type": type,
      "required": required ? 1 : 0,
      "default":
          defaultValue ?? (type == "integer" || type == "number" ? "0" : ""),
      "description": "Generated Masamune parameter.",
      "is_path_parameter": false,
    };
  }

  static String _sql(
    String operation,
    TidbTableSpec table,
    List<TidbColumnSpec> columns,
  ) {
    final prefix = "USE `${table.database}`;\n";
    if (operation == "get") {
      return "$prefix"
          "SELECT * FROM `${table.table}` WHERE `id` = \${id} LIMIT 1;\n";
    }
    if (operation == "list" || operation == "count") {
      final where = _filterSql(columns);
      final select =
          operation == "count" ? "SELECT COUNT(*) AS count" : "SELECT *";
      final limit = operation == "list" ? "\nLIMIT \${limit}" : "";
      return "$prefix$select FROM `${table.table}`\nWHERE $where$limit;\n";
    }
    if (operation == "delete") {
      return "$prefix"
          "DELETE FROM `${table.table}` WHERE `id` = \${id};\n";
    }
    if (operation == "update") {
      final updated = columns
          .where((column) => column.name != "id" && column.name != "created_at")
          .map((column) => "`${column.name}` = \${${column.name}}")
          .join(",\n  ");
      return "$prefix"
          "UPDATE `${table.table}` SET\n  $updated\nWHERE `id` = \${id};\n";
    }
    final names = columns.map((column) => "`${column.name}`").join(", ");
    final values = columns.map((column) => "\${${column.name}}").join(", ");
    final updates = columns
        .where((column) => column.name != "id" && column.name != "created_at")
        .map((column) => "`${column.name}` = VALUES(`${column.name}`)")
        .join(", ");
    return "$prefix"
        "INSERT INTO `${table.table}` ($names) VALUES ($values)\n"
        "ON DUPLICATE KEY UPDATE $updates;\n";
  }

  static String _filterSql(List<TidbColumnSpec> columns) {
    const unset = "__MASAMUNE_UNSET__";
    return columns.expand((column) {
      final name = column.name;
      final value =
          column.sqlType == "JSON" ? "CAST(`$name` AS CHAR)" : "`$name`";
      String parameter(String suffix) {
        final placeholder = "\${$name$suffix}";
        if (column.sqlType.startsWith("BIGINT") ||
            column.sqlType.startsWith("TINYINT")) {
          return "CAST($placeholder AS SIGNED)";
        }
        if (column.sqlType.startsWith("DOUBLE")) {
          return "CAST($placeholder AS DECIMAL(65, 30))";
        }
        return placeholder;
      }

      return [
        "(\${$name} = '$unset' OR $value = ${parameter("")})",
        "(\${${name}_ne} = '$unset' OR $value != ${parameter("_ne")})",
        "(\${${name}_lt} = '$unset' OR $value < ${parameter("_lt")})",
        "(\${${name}_lte} = '$unset' OR $value <= ${parameter("_lte")})",
        "(\${${name}_gt} = '$unset' OR $value > ${parameter("_gt")})",
        "(\${${name}_gte} = '$unset' OR $value >= ${parameter("_gte")})",
        "(\${${name}_in} = '$unset' OR FIND_IN_SET($value, \${${name}_in}) > 0)",
      ];
    }).join("\n  AND ");
  }

  static List<TidbColumnSpec> _mergeReservedColumns(
    List<TidbColumnSpec> values,
  ) {
    final columns = <String, TidbColumnSpec>{
      "id": const TidbColumnSpec(
        name: "id",
        sqlType: "VARCHAR(255)",
        required: true,
      ),
      "parent_id":
          const TidbColumnSpec(name: "parent_id", sqlType: "VARCHAR(255)"),
      "created_at": const TidbColumnSpec(name: "created_at", sqlType: "BIGINT"),
      "updated_at": const TidbColumnSpec(name: "updated_at", sqlType: "BIGINT"),
    };
    for (final value in values) {
      _validateIdentifier(value.name, "column");
      columns[value.name] = value;
    }
    return columns.values.toList();
  }

  static String _columnDefinition(TidbColumnSpec column) {
    if (column.name == "id") {
      return "  `id` VARCHAR(255) PRIMARY KEY";
    }
    return "  `${column.name}` ${column.sqlType}"
        "${column.required ? " NOT NULL" : ""}";
  }

  static String _parameterType(String sqlType) {
    if (sqlType.startsWith("BIGINT") || sqlType.startsWith("TINYINT")) {
      return "integer";
    }
    if (sqlType.startsWith("DOUBLE")) {
      return "number";
    }
    return "string";
  }

  static String _endpointPath(
    String database,
    String table,
    String operation,
  ) {
    final path = "/$database/$table/$operation";
    if (path.length < 64) {
      return path;
    }
    final hash = _fnv1a(path).toRadixString(16).padLeft(8, "0");
    final reverseHash = _fnv1a(path.split("").reversed.join())
        .toRadixString(16)
        .padLeft(8, "0");
    return "/_m_$hash$reverseHash/$operation";
  }

  static int _fnv1a(String value) {
    var hash = 0x811c9dc5;
    for (final byte in utf8.encode(value)) {
      hash ^= byte;
      hash = (hash * 0x01000193) & 0xffffffff;
    }
    return hash;
  }

  static void _validateIdentifier(String value, String label) {
    if (!RegExp(r"^[A-Za-z_][A-Za-z0-9_]*$").hasMatch(value)) {
      throw ArgumentError("Invalid TiDB $label: $value");
    }
  }

  static String _json(Object value) {
    return "${const JsonEncoder.withIndent("  ").convert(value)}\n";
  }
}
