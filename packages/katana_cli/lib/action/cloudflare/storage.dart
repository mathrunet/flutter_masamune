// Dart imports:
import "dart:async";
import "dart:convert";
import "dart:io";
import "dart:math";

// Package imports:
import "package:yaml/yaml.dart";
import "package:yaml_writer/yaml_writer.dart";

// Project imports:
import "package:katana_cli/action/cloudflare/cloudflare_source_utils.dart";
import "package:katana_cli/katana_cli.dart";

/// Path of the Cloudflare Storage state managed by Katana.
const storageManagedStatePath = "cloudflare/storage.yaml";

/// Result of loading and migrating the Cloudflare Storage managed state.
class StorageManagedStateLoadResult {
  /// Creates a result of loading and migrating the managed state.
  const StorageManagedStateLoadResult({
    required this.state,
    required this.downloadUrlSecret,
    required this.secretsChanged,
    required this.stateChanged,
  });

  /// Storage state stored in [storageManagedStatePath].
  final Map<String, dynamic> state;

  /// Secret used to sign limited download URLs.
  final String downloadUrlSecret;

  /// Whether `katana_secrets.yaml` was changed by migration.
  final bool secretsChanged;

  /// Whether [storageManagedStatePath] must be persisted.
  final bool stateChanged;
}

/// Loads Storage state and migrates the legacy automatically managed secret.
Future<StorageManagedStateLoadResult> loadAndMigrateStorageManagedState(
  Map<String, dynamic> secrets, {
  String configuredSecret = "",
  String Function()? generateSecret,
}) async {
  final file = File(storageManagedStatePath);
  final loaded = file.existsSync()
      ? Map<String, dynamic>.from(
          modifize(loadYaml(await file.readAsString())) as Map? ?? {},
        )
      : <String, dynamic>{};
  final state = _stringMap(loaded);
  final cloudflare = _nestedMap(secrets, "cloudflare");
  final storage = _nestedMap(cloudflare, "storage");
  final legacySecret = storage["download_url_secret"]?.toString() ?? "";
  final storedSecret = state["download_url_secret"]?.toString() ?? "";
  if (legacySecret.isNotEmpty &&
      storedSecret.isNotEmpty &&
      legacySecret != storedSecret) {
    throw StateError(
      "Cloudflare Storage managed state differs between "
      "`katana_secrets.yaml` and `$storageManagedStatePath` at "
      "`download_url_secret`. Resolve the conflict before running "
      "`katana apply` again.",
    );
  }
  final downloadUrlSecret = configuredSecret.isNotEmpty
      ? configuredSecret
      : storedSecret.isNotEmpty
          ? storedSecret
          : legacySecret.isNotEmpty
              ? legacySecret
              : (generateSecret ?? _generateDownloadUrlSecret)();
  var secretsChanged = false;
  var stateChanged = !file.existsSync();
  if (storage.containsKey("download_url_secret")) {
    storage.remove("download_url_secret");
    secretsChanged = true;
  }
  if (state["version"] != 1) {
    state["version"] = 1;
    stateChanged = true;
  }
  if (state["download_url_secret"] != downloadUrlSecret) {
    state["download_url_secret"] = downloadUrlSecret;
    stateChanged = true;
  }
  return StorageManagedStateLoadResult(
    state: state,
    downloadUrlSecret: downloadUrlSecret,
    secretsChanged: secretsChanged,
    stateChanged: stateChanged,
  );
}

/// Saves Cloudflare Storage managed state atomically.
Future<void> saveStorageManagedState(Map<String, dynamic> state) async {
  final file = File(storageManagedStatePath);
  await file.parent.create(recursive: true);
  final temporary = File("${file.path}.tmp");
  await temporary.writeAsString(YamlWriter().write(state));
  try {
    await temporary.rename(file.path);
  } on FileSystemException {
    await file.writeAsString(await temporary.readAsString());
    await temporary.delete();
  }
}

/// Ensures that Storage managed state is ignored by Git.
Future<void> ensureStorageManagedStateIsGitIgnored() async {
  final file = File("cloudflare/.gitignore");
  if (!file.existsSync()) {
    throw StateError(
      "The file `cloudflare/.gitignore` does not exist. Initialize "
      "Cloudflare Workers before enabling Storage.",
    );
  }
  final lines = await file.readAsLines();
  if (lines.any((line) => line.trim() == "storage.yaml")) {
    return;
  }
  lines.add("storage.yaml");
  await file.writeAsString("${lines.join("\n")}\n");
}

Map<String, dynamic> _nestedMap(
  Map<String, dynamic> parent,
  String key,
) {
  final value = parent[key];
  if (value is Map) {
    return parent[key] = _stringMap(value);
  }
  return parent[key] = <String, dynamic>{};
}

Map<String, dynamic> _stringMap(Map<dynamic, dynamic> value) =>
    value.map((key, item) => MapEntry(key.toString(), item));

String _generateDownloadUrlSecret() {
  final random = Random.secure();
  final bytes = List<int>.generate(48, (_) => random.nextInt(256));
  return base64UrlEncode(bytes);
}

/// Cloudflare deployment process for R2 Storage.
///
/// Cloudflare用のR2 Storageのデプロイ処理を行います。
class CloudflareStorageCliAction extends CliCommand with CliActionMixin {
  /// Cloudflare deployment process for R2 Storage.
  ///
  /// Cloudflare用のR2 Storageのデプロイ処理を行います。
  const CloudflareStorageCliAction();

  @override
  String get description =>
      "We will perform the deployment process for Cloudflare R2 Storage. Please create an R2 bucket and set [cloudflare]->[storage]->[bucket_name]. Cloudflare R2 Storageのデプロイ処理を行います。予めR2 bucketを作成し、[cloudflare]->[storage]->[bucket_name]を設定してください。";

  @override
  bool checkEnabled(ExecContext context) {
    final cloudflare = context.yaml.getAsMap("cloudflare");
    final storage = cloudflare.getAsMap("storage");
    return storage.get("enable", false);
  }

  @override
  Future<void> exec(ExecContext context) async {
    final bin = context.yaml.getAsMap("bin");
    final npm = bin.get("npm", "npm");
    final wrangler = bin.get("wrangler", "wrangler");
    final flavor = context.flavorContext?.flavor.name ?? "prod";
    final cloudflare = context.yaml.getAsMap("cloudflare");
    final storage = cloudflare.getAsMap("storage");
    final binding = storage.get("binding", "R2_BUCKET");
    final bucketName = storage.get("bucket_name", "");
    final previewBucketName = storage.get("preview_bucket_name", "");
    final publicBaseUrl = storage.get("public_base_url", "");
    final configuredDownloadUrlSecret = storage.get("download_url_secret", "");
    final backup = storage.getAsMap("backup");
    final backupEnabled = backup.get("enable", false);
    final configuredConsumerFlavor =
        backup.get("consumer_flavor", "").toString().trim();
    final backupBinding = backup.get("binding", "R2_BACKUP_BUCKET");
    final backupBucketName = backup.get("bucket_name", "");
    final backupPreviewBucketName = backup.get("preview_bucket_name", "");
    final backupQueueName = backup.get(
      "queue_name",
      bucketName.isEmpty ? "" : "$bucketName-backup",
    );
    final backupMaxBatchSize = backup.get("max_batch_size", 10);
    final backupMaxBatchTimeout = backup.get("max_batch_timeout", 5);
    final backupMaxRetries = backup.get("max_retries", 3);
    final backupDeadLetterQueue = backup.get(
      "dead_letter_queue",
      backupQueueName.isEmpty ? "" : "$backupQueueName-dlq",
    );
    if (binding.isEmpty) {
      error(
        "If [cloudflare]->[storage]->[enable] is enabled, please include [cloudflare]->[storage]->[binding].",
      );
      return;
    }
    if (bucketName.isEmpty) {
      error(
        "If [cloudflare]->[storage]->[enable] is enabled, please include [cloudflare]->[storage]->[bucket_name]. Create it with `wrangler r2 bucket create <bucket_name>`.",
      );
      return;
    }
    if (publicBaseUrl.isEmpty) {
      error(
        "If [cloudflare]->[storage]->[enable] is enabled, please include [cloudflare]->[storage]->[public_base_url].",
      );
      return;
    }
    if (backupEnabled) {
      if (configuredConsumerFlavor.isNotEmpty &&
          configuredConsumerFlavor != KatanaFlavor.dev.name &&
          configuredConsumerFlavor != KatanaFlavor.prod.name) {
        error(
          "Cloudflare R2 backup [consumer_flavor] must be `dev` or `prod`.",
        );
        return;
      }
      if (backupBinding.isEmpty) {
        error(
          "If [cloudflare]->[storage]->[backup]->[enable] is enabled, please include [binding].",
        );
        return;
      }
      if (backupBucketName.isEmpty) {
        error(
          "If [cloudflare]->[storage]->[backup]->[enable] is enabled, please include [bucket_name]. Create it with `wrangler r2 bucket create <bucket_name>`.",
        );
        return;
      }
      if (backupQueueName.isEmpty) {
        error(
          "If [cloudflare]->[storage]->[backup]->[enable] is enabled, please include [queue_name].",
        );
        return;
      }
      if (binding == backupBinding || bucketName == backupBucketName) {
        error(
          "Cloudflare R2 backup must use a different binding and bucket from the source storage.",
        );
        return;
      }
      if (backupMaxBatchSize <= 0 ||
          backupMaxBatchTimeout < 0 ||
          backupMaxRetries < 0) {
        error(
          "Cloudflare R2 backup queue settings must be non-negative, and [max_batch_size] must be greater than zero.",
        );
        return;
      }
    }
    final cloudflareDir = Directory("cloudflare");
    if (!cloudflareDir.existsSync()) {
      error(
        "The directory `cloudflare` does not exist. Initialize Cloudflare Workers by enabling [cloudflare]->[workers]->[enable] and executing `katana apply`.",
      );
      return;
    }
    final indexFile = File("cloudflare/src/index.ts");
    if (!indexFile.existsSync()) {
      error(
        "The file `cloudflare/src/index.ts` does not exist. Initialize Cloudflare Workers by enabling [cloudflare]->[workers]->[enable] and executing `katana apply`.",
      );
      return;
    }
    final wranglerFile = File("cloudflare/wrangler.jsonc");
    if (!wranglerFile.existsSync()) {
      error(
        "The file `cloudflare/wrangler.jsonc` does not exist. Initialize Cloudflare Workers by enabling [cloudflare]->[workers]->[enable] and executing `katana apply`.",
      );
      return;
    }
    try {
      await ensureStorageManagedStateIsGitIgnored();
    } on StateError catch (exception) {
      error(exception.message.toString());
      return;
    }
    final secrets = await _loadSecretsRoot();
    late final StorageManagedStateLoadResult managed;
    try {
      managed = await loadAndMigrateStorageManagedState(
        secrets,
        configuredSecret: configuredDownloadUrlSecret,
      );
    } on StateError catch (exception) {
      error(exception.message.toString());
      return;
    }
    if (managed.stateChanged) {
      await saveStorageManagedState(managed.state);
    }
    if (managed.secretsChanged) {
      await _saveSecretsRoot(secrets);
    }
    final downloadUrlSecret = managed.downloadUrlSecret;
    final ownsBackupConsumer = _ownsBackupQueueConsumer(
      context,
      queueName: backupQueueName,
      configuredConsumerFlavor: configuredConsumerFlavor,
    );

    label("Add Cloudflare Workers functions");
    final source = await indexFile.readAsString();
    final updated = _updateStorageFunctions(
      source,
      binding: binding,
      bucketName: bucketName,
      publicBaseUrl: publicBaseUrl,
      backupEnabled: backupEnabled,
      backupBinding: backupBinding,
    );
    if (updated == null) {
      return;
    }
    await indexFile.writeAsString(updated);
    label("Add Cloudflare R2 bucket binding");
    final wranglerSource = WranglerEnvironmentSynchronizer.transformEnvironment(
      WranglerEnvironmentSynchronizer.ensureEnvironment(
        await wranglerFile.readAsString(),
        flavor: flavor,
        workerName: cloudflare.get("project_id", ""),
      ),
      flavor: flavor,
      transform: (environment) {
        var updated = _updateWranglerR2Bucket(
          environment,
          binding: binding,
          bucketName: bucketName,
          previewBucketName: previewBucketName,
          backupEnabled: backupEnabled,
          backupBinding: backupBinding,
          backupBucketName: backupBucketName,
          backupPreviewBucketName: backupPreviewBucketName,
        );
        if (backupEnabled) {
          updated = ownsBackupConsumer
              ? _updateWranglerQueueConsumer(
                  updated,
                  queueName: backupQueueName,
                  maxBatchSize: backupMaxBatchSize,
                  maxBatchTimeout: backupMaxBatchTimeout,
                  maxRetries: backupMaxRetries,
                  deadLetterQueue: backupDeadLetterQueue,
                )
              : _removeWranglerQueueConsumer(
                  updated,
                  queueName: backupQueueName,
                );
        }
        return updated;
      },
    );
    await wranglerFile.writeAsString(wranglerSource);
    await installMissingCloudflarePackages(
      npm: npm,
      packages: const ["@mathrunet/masamune_cloudflare_storage"],
    );
    await addFlutterImport(
      [
        "masamune_storage_cloudflare",
      ],
    );
    await _putWranglerSecret(
      wrangler: wrangler,
      environment: flavor,
      key: "STORAGE_DOWNLOAD_URL_SECRET",
      value: downloadUrlSecret,
    );
    if (backupEnabled) {
      await _ensureQueue(wrangler: wrangler, queueName: backupQueueName);
      if (backupDeadLetterQueue.isNotEmpty) {
        await _ensureQueue(
          wrangler: wrangler,
          queueName: backupDeadLetterQueue,
        );
      }
      await _ensureR2CreateNotification(
        wrangler: wrangler,
        bucketName: bucketName,
        queueName: backupQueueName,
      );
    }
  }

  Future<Map<String, dynamic>> _loadSecretsRoot() async {
    final file = File("katana_secrets.yaml");
    if (!file.existsSync()) {
      return {};
    }
    return Map<String, dynamic>.from(
      modifize(loadYaml(await file.readAsString())) as Map? ?? {},
    );
  }

  bool _ownsBackupQueueConsumer(
    ExecContext context, {
    required String queueName,
    required String configuredConsumerFlavor,
  }) {
    final flavorContext = context.flavorContext;
    final currentFlavor = flavorContext?.flavor.name ?? KatanaFlavor.prod.name;
    if (configuredConsumerFlavor.isNotEmpty) {
      return currentFlavor == configuredConsumerFlavor;
    }
    if (flavorContext == null) {
      return true;
    }
    final devQueueName = _backupQueueNameForFlavor(
      flavorContext,
      KatanaFlavor.dev,
    );
    final prodQueueName = _backupQueueNameForFlavor(
      flavorContext,
      KatanaFlavor.prod,
    );
    final devWorkerName = flavorContext.yamlValue(
      const ["cloudflare", "project_id"],
      flavor: KatanaFlavor.dev,
    )?.toString();
    final prodWorkerName = flavorContext.yamlValue(
      const ["cloudflare", "project_id"],
      flavor: KatanaFlavor.prod,
    )?.toString();
    final sharedQueue = devQueueName == queueName && prodQueueName == queueName;
    final distinctWorkers = devWorkerName != null &&
        prodWorkerName != null &&
        devWorkerName.isNotEmpty &&
        prodWorkerName.isNotEmpty &&
        devWorkerName != prodWorkerName;
    if (sharedQueue && distinctWorkers) {
      return currentFlavor == KatanaFlavor.prod.name;
    }
    return true;
  }

  String _backupQueueNameForFlavor(
    FlavorContext context,
    KatanaFlavor flavor,
  ) {
    final bucketName = context.yamlValue(
          const ["cloudflare", "storage", "bucket_name"],
          flavor: flavor,
        )?.toString() ??
        "";
    return context.yamlValue(
          const ["cloudflare", "storage", "backup", "queue_name"],
          flavor: flavor,
        )?.toString() ??
        (bucketName.isEmpty ? "" : "$bucketName-backup");
  }

  Future<void> _saveSecretsRoot(Map<String, dynamic> root) {
    return File("katana_secrets.yaml").writeAsString(YamlWriter().write(root));
  }

  String? _updateStorageFunctions(
    String source, {
    required String binding,
    required String bucketName,
    required String publicBaseUrl,
    required bool backupEnabled,
    required String backupBinding,
  }) {
    final storageFunction = """
    storage.Functions.storageCloudflare({
        bucketBindingName: "$binding",
        publicBaseUrl: "$publicBaseUrl",
    }),""";
    var updated = _ensureStorageImport(source);
    updated = _replaceFunction(
      updated,
      "storage.Functions.storageCloudflare",
      storageFunction,
    );
    final backupFunction = backupEnabled
        ? """
    storage.Functions.storageCloudflareBackup({
        sourceBucketBindingName: "$binding",
        backupBucketBindingName: "$backupBinding",
        sourceBucketName: "$bucketName",
    }),"""
        : "";
    updated = _replaceFunction(
      updated,
      "storage.Functions.storageCloudflareBackup",
      backupFunction,
    );
    if (backupEnabled &&
        !updated.contains("storage.Functions.storageCloudflareBackup(")) {
      final deployFunctions = _findDeployFunctions(updated);
      if (deployFunctions == null) {
        error(
          "Could not find `m.deploy([` in `cloudflare/src/index.ts`. Please check the Cloudflare Workers entrypoint.",
        );
        return null;
      }
      final insert =
          "${_needsLeadingComma(updated, deployFunctions) ? "," : ""}\n$backupFunction";
      updated = updated.replaceRange(
        deployFunctions.end,
        deployFunctions.end,
        insert,
      );
    }
    if (updated.contains("storage.Functions.storageCloudflare(")) {
      return updated;
    }
    final deployFunctions = _findDeployFunctions(updated);
    if (deployFunctions == null) {
      error(
        "Could not find `m.deploy([` in `cloudflare/src/index.ts`. Please check the Cloudflare Workers entrypoint.",
      );
      return null;
    }
    final insert =
        "${_needsLeadingComma(updated, deployFunctions) ? "," : ""}\n$storageFunction";
    return updated.replaceRange(
      deployFunctions.end,
      deployFunctions.end,
      insert,
    );
  }

  String _ensureStorageImport(String source) {
    const package = "@mathrunet/masamune_cloudflare_storage";
    const import = 'import * as storage from "$package";';
    final storageImport = RegExp(
      r'^import \* as \w+ from "@mathrunet/masamune_cloudflare_storage";$',
      multiLine: true,
    ).firstMatch(source);
    if (storageImport != null) {
      return source.replaceRange(
          storageImport.start, storageImport.end, import);
    }
    final imports = RegExp(r"^import .+;$", multiLine: true).allMatches(source);
    if (imports.isEmpty) {
      return "$import\n$source";
    }
    final lastImport = imports.last;
    return source.replaceRange(lastImport.end, lastImport.end, "\n$import");
  }

  String _replaceFunction(
    String source,
    String functionName,
    String replacement,
  ) {
    var updated = source;
    var searchStart = 0;
    var replaced = false;
    while (true) {
      final range = _findFunctionCall(updated, functionName, searchStart);
      if (range == null) {
        break;
      }
      final next = replaced ? "" : replacement;
      updated = updated.replaceRange(range.start, range.end, next);
      searchStart = range.start + next.length;
      replaced = true;
    }
    return updated;
  }

  _SourceRange? _findDeployFunctions(String source) {
    final deployStart = source.indexOf("m.deploy(");
    if (deployStart < 0) {
      return null;
    }
    final functionsStart = source.indexOf("[", deployStart);
    if (functionsStart < 0) {
      return null;
    }
    final functionsEnd = _findClosing(source, functionsStart, "[", "]");
    if (functionsEnd < 0) {
      return null;
    }
    return _SourceRange(functionsStart + 1, functionsEnd);
  }

  bool _needsLeadingComma(String source, _SourceRange range) {
    for (var i = range.end - 1; i >= range.start; i--) {
      final char = source[i];
      if (char.trim().isEmpty) {
        continue;
      }
      return char != ",";
    }
    return false;
  }

  _SourceRange? _findFunctionCall(
    String source,
    String functionName,
    int searchStart,
  ) {
    final start = source.indexOf("$functionName(", searchStart);
    if (start < 0) {
      return null;
    }
    final open = start + functionName.length;
    final close = _findClosing(source, open, "(", ")");
    if (close < 0) {
      return null;
    }
    var end = close + 1;
    while (end < source.length && source[end].trim().isEmpty) {
      end++;
    }
    if (end < source.length && source[end] == ",") {
      end++;
    }
    return _SourceRange(start, end);
  }

  int _findClosing(
    String source,
    int openIndex,
    String openChar,
    String closeChar,
  ) {
    var depth = 0;
    String? quote;
    var escaped = false;
    for (var i = openIndex; i < source.length; i++) {
      final char = source[i];
      if (quote != null) {
        if (escaped) {
          escaped = false;
          continue;
        }
        if (char == "\\") {
          escaped = true;
          continue;
        }
        if (char == quote) {
          quote = null;
        }
        continue;
      }
      if (char == '"' || char == "'" || char == "`") {
        quote = char;
        continue;
      }
      if (char == openChar) {
        depth++;
        continue;
      }
      if (char == closeChar) {
        depth--;
        if (depth == 0) {
          return i;
        }
      }
    }
    return -1;
  }

  String _updateWranglerR2Bucket(
    String source, {
    required String binding,
    required String bucketName,
    required String previewBucketName,
    required bool backupEnabled,
    required String backupBinding,
    required String backupBucketName,
    required String backupPreviewBucketName,
  }) {
    final buckets = <String, String>{
      binding: _r2Bucket(
        binding: binding,
        bucketName: bucketName,
        previewBucketName: previewBucketName,
      ),
      if (backupEnabled)
        backupBinding: _r2Bucket(
          binding: backupBinding,
          bucketName: backupBucketName,
          previewBucketName: backupPreviewBucketName,
        ),
    };
    final updated = _upsertObjectArray(
      source,
      propertyName: "r2_buckets",
      identityName: "binding",
      replacements: buckets,
      propertyIndent: "\t",
      objectIndent: "\t\t",
    );
    if (updated != null) {
      return updated;
    }
    final r2Buckets = """
\t"r2_buckets": [
${buckets.values.join(",\n")}
\t],""";
    return _insertTopLevelProperty(source, r2Buckets);
  }

  String _updateWranglerQueueConsumer(
    String source, {
    required String queueName,
    required int maxBatchSize,
    required int maxBatchTimeout,
    required int maxRetries,
    required String deadLetterQueue,
  }) {
    final consumer = """
\t\t\t{
\t\t\t\t"queue": "$queueName",
\t\t\t\t"max_batch_size": $maxBatchSize,
\t\t\t\t"max_batch_timeout": $maxBatchTimeout,
\t\t\t\t"max_retries": $maxRetries,
\t\t\t\t"max_concurrency": 1${deadLetterQueue.isEmpty ? "" : ","}
${deadLetterQueue.isEmpty ? "" : '\t\t\t\t"dead_letter_queue": "$deadLetterQueue"'}
\t\t\t}""";
    final updated = _upsertObjectArray(
      source,
      propertyName: "consumers",
      identityName: "queue",
      replacements: {queueName: consumer},
      propertyIndent: "\t\t",
      objectIndent: "\t\t\t",
    );
    if (updated != null) {
      return updated;
    }
    final queuesPattern = RegExp(r'"queues"\s*:\s*\{');
    final queuesMatch = queuesPattern.firstMatch(source);
    if (queuesMatch != null) {
      final open = source.indexOf("{", queuesMatch.start);
      final close = _findClosing(source, open, "{", "}");
      if (close >= 0) {
        return source.replaceRange(
          close,
          close,
          """
${_objectNeedsLeadingComma(source, open + 1, close) ? "," : ""}
\t\t"consumers": [
$consumer
\t\t]
\t""",
        );
      }
    }
    return _insertTopLevelProperty(
      source,
      """
\t"queues": {
\t\t"consumers": [
$consumer
\t\t]
\t},""",
    );
  }

  String _removeWranglerQueueConsumer(
    String source, {
    required String queueName,
  }) {
    return _removeObjectArrayItem(
          source,
          propertyName: "consumers",
          identityName: "queue",
          identity: queueName,
          propertyIndent: "\t\t",
          objectIndent: "\t\t\t",
        ) ??
        source;
  }

  String? _removeObjectArrayItem(
    String source, {
    required String propertyName,
    required String identityName,
    required String identity,
    required String propertyIndent,
    required String objectIndent,
  }) {
    final propertyPattern = RegExp('"$propertyName"\\s*:\\s*\\[');
    final propertyMatch = propertyPattern.firstMatch(source);
    if (propertyMatch == null) {
      return null;
    }
    final open = source.indexOf("[", propertyMatch.start);
    final close = _findClosing(source, open, "[", "]");
    if (close < 0) {
      return null;
    }
    final identityPattern = RegExp(
      '"$identityName"\\s*:\\s*"([^"]+)"',
    );
    final output = <String>[];
    var cursor = open + 1;
    while (cursor < close) {
      final objectOpen = source.indexOf("{", cursor);
      if (objectOpen < 0 || objectOpen >= close) {
        break;
      }
      final objectClose = _findClosing(source, objectOpen, "{", "}");
      if (objectClose < 0 || objectClose > close) {
        break;
      }
      final object = source.substring(objectOpen, objectClose + 1).trim();
      if (identityPattern.firstMatch(object)?.group(1) != identity) {
        output.add(_indentObject(object, objectIndent));
      }
      cursor = objectClose + 1;
    }
    final replacement = """
"$propertyName": [
${output.join(",\n")}
$propertyIndent]""";
    return source.replaceRange(
      propertyMatch.start,
      close + 1,
      replacement,
    );
  }

  String? _upsertObjectArray(
    String source, {
    required String propertyName,
    required String identityName,
    required Map<String, String> replacements,
    required String propertyIndent,
    required String objectIndent,
  }) {
    final propertyPattern = RegExp('"$propertyName"\\s*:\\s*\\[');
    final propertyMatch = propertyPattern.firstMatch(source);
    if (propertyMatch == null) {
      return null;
    }
    final open = source.indexOf("[", propertyMatch.start);
    final close = _findClosing(source, open, "[", "]");
    if (close < 0) {
      return null;
    }
    final objects = <String>[];
    var cursor = open + 1;
    while (cursor < close) {
      final objectOpen = source.indexOf("{", cursor);
      if (objectOpen < 0 || objectOpen >= close) {
        break;
      }
      final objectClose = _findClosing(source, objectOpen, "{", "}");
      if (objectClose < 0 || objectClose > close) {
        break;
      }
      objects.add(source.substring(objectOpen, objectClose + 1).trim());
      cursor = objectClose + 1;
    }
    final pending = Map<String, String>.from(replacements);
    final identityPattern = RegExp(
      '"$identityName"\\s*:\\s*"([^"]+)"',
    );
    final output = <String>[];
    for (final object in objects) {
      final identity = identityPattern.firstMatch(object)?.group(1);
      if (identity != null && pending.containsKey(identity)) {
        output.add(pending.remove(identity)!);
      } else {
        output.add(_indentObject(object, objectIndent));
      }
    }
    output.addAll(pending.values);
    final replacement = """
"$propertyName": [
${output.join(",\n")}
$propertyIndent]""";
    return source.replaceRange(
      propertyMatch.start,
      close + 1,
      replacement,
    );
  }

  String _indentObject(String object, String indent) {
    final lines = object.split("\n");
    return lines.map((line) => "$indent${line.trimLeft()}").join("\n");
  }

  bool _objectNeedsLeadingComma(String source, int start, int end) {
    for (var i = end - 1; i >= start; i--) {
      final char = source[i];
      if (char.trim().isEmpty) {
        continue;
      }
      return char != ",";
    }
    return false;
  }

  String _insertTopLevelProperty(String source, String property) {
    final uploadSourceMaps = RegExp(r'"upload_source_maps"\s*:\s*true,?');
    if (uploadSourceMaps.hasMatch(source)) {
      return source.replaceFirstMapped(uploadSourceMaps, (match) {
        return '${match.group(0)!.replaceAll(RegExp(r",$"), "")},\n$property';
      });
    }
    final lastBrace = source.lastIndexOf("}");
    if (lastBrace < 0) {
      return source;
    }
    final rootOpen = source.indexOf("{");
    final needsComma = rootOpen >= 0 &&
        _objectNeedsLeadingComma(source, rootOpen + 1, lastBrace);
    return source.replaceRange(
      lastBrace,
      lastBrace,
      "${needsComma ? "," : ""}\n$property\n",
    );
  }

  String _r2Bucket({
    required String binding,
    required String bucketName,
    required String previewBucketName,
  }) {
    return """
\t\t{
\t\t\t"binding": "$binding",
\t\t\t"bucket_name": "$bucketName"${previewBucketName.isEmpty ? "" : ","}
${previewBucketName.isEmpty ? "" : '\t\t\t"preview_bucket_name": "$previewBucketName"'}
\t\t}""";
  }

  Future<void> _ensureQueue({
    required String wrangler,
    required String queueName,
  }) async {
    label("Ensure Cloudflare Queue `$queueName`.");
    final result = await Process.run(
      wrangler,
      ["queues", "create", queueName],
      workingDirectory: "cloudflare",
      runInShell: true,
    );
    final output = "${result.stdout}\n${result.stderr}";
    if (result.exitCode == 0) {
      if (output.trim().isNotEmpty) {
        stdout.write(output);
      }
      return;
    }
    final normalized = _normalizeWranglerOutput(output);
    final errorCodes = RegExp(r"\[\s*code:\s*(\d+)\s*\]")
        .allMatches(normalized)
        .map((match) => match.group(1))
        .toSet();
    if (errorCodes.length == 1 &&
        errorCodes.single == "11009" &&
        normalized.contains(
          "queue name '${queueName.toLowerCase()}' is already taken",
        )) {
      return;
    }
    if (output.trim().isNotEmpty) {
      stdout.write(output);
    }
    throw Exception("Failed to create Cloudflare Queue `$queueName`.");
  }

  Future<void> _ensureR2CreateNotification({
    required String wrangler,
    required String bucketName,
    required String queueName,
  }) async {
    label("Ensure Cloudflare R2 object-create notification.");
    final list = await Process.run(
      wrangler,
      ["r2", "bucket", "notification", "list", bucketName],
      workingDirectory: "cloudflare",
      runInShell: true,
    );
    final listOutput = "${list.stdout}\n${list.stderr}";
    if (list.exitCode != 0) {
      final normalized = _normalizeWranglerOutput(listOutput);
      final isUnconfigured =
          RegExp(r"\[\s*code:\s*11015\s*\]").hasMatch(normalized) &&
              normalized.contains("no event notification config found") &&
              normalized.contains("no configurations found for bucket");
      // Wrangler reports an unconfigured bucket as an API error. Treat only
      // this response as an empty notification list and create the rule.
      if (!isUnconfigured) {
        stdout.write(listOutput);
        throw Exception(
          "Failed to list Cloudflare R2 notifications for `$bucketName`.",
        );
      }
    }
    if (_hasEquivalentR2ObjectCreateNotification(listOutput, queueName)) {
      return;
    }
    final create = await Process.run(
      wrangler,
      [
        "r2",
        "bucket",
        "notification",
        "create",
        bucketName,
        "--event-type",
        "object-create",
        "--queue",
        queueName,
        "--description",
        "Managed by katana: R2 backup",
      ],
      workingDirectory: "cloudflare",
      runInShell: true,
    );
    final createOutput = "${create.stdout}\n${create.stderr}";
    if (createOutput.trim().isNotEmpty) {
      stdout.write(createOutput);
    }
    if (create.exitCode != 0) {
      throw Exception(
        "Failed to create the R2 object-create notification. Remove or update any overlapping notification rule, then run `katana apply` again.",
      );
    }
  }

  String _normalizeWranglerOutput(String output) {
    return output
        .replaceAll(RegExp(r"\x1B\[[0-?]*[ -/]*[@-~]"), "")
        .toLowerCase();
  }

  bool _hasEquivalentR2ObjectCreateNotification(
    String output,
    String queueName,
  ) {
    final normalized = _normalizeWranglerOutput(output);
    const objectCreateActions = {
      "putobject",
      "completemultipartupload",
      "copyobject",
    };
    final queuePattern = RegExp(
      r"^\s*(?:-\s*)?queue_name\s*:\s*(.*?)\s*$",
      multiLine: true,
    );
    final eventTypePattern = RegExp(
      r"^\s*(?:-\s*)?event_type\s*:\s*(.*?)\s*$",
      multiLine: true,
    );
    final rules = normalized.split(
      RegExp(r"(?=^\s*(?:-\s*)?rule_id\s*:)", multiLine: true),
    );
    return rules.any((rule) {
      final queueMatches = queuePattern.allMatches(rule).toList();
      final eventTypeMatches = eventTypePattern.allMatches(rule).toList();
      if (queueMatches.length != 1 || eventTypeMatches.length != 1) {
        return false;
      }
      final targetQueue = queueMatches.single.group(1)!.trim();
      final actions = eventTypeMatches.single
          .group(1)!
          .split(",")
          .map((action) => action.trim())
          .toList();
      return targetQueue == queueName.toLowerCase() &&
          actions.length == objectCreateActions.length &&
          actions.toSet().containsAll(objectCreateActions);
    });
  }

  Future<void> _putWranglerSecret({
    required String wrangler,
    required String environment,
    required String key,
    required String value,
  }) async {
    label("Set Cloudflare Workers secrets.");
    final process = await Process.start(
      wrangler,
      ["secret", "put", key, "--env", environment],
      workingDirectory: "cloudflare",
      runInShell: true,
    );
    unawaited(stdout.addStream(process.stdout));
    unawaited(stderr.addStream(process.stderr));
    process.stdin.writeln(value);
    await process.stdin.close();
    final exitCode = await process.exitCode;
    if (exitCode != 0) {
      throw Exception(
        "An error has occurred. Please check the log above for details.",
      );
    }
  }
}

class _SourceRange {
  const _SourceRange(this.start, this.end);

  final int start;
  final int end;
}
