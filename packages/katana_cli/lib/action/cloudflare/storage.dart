// Dart imports:
import "dart:async";
import "dart:convert";
import "dart:io";
import "dart:math";

// Package imports:
import "package:yaml/yaml.dart";
import "package:yaml_writer/yaml_writer.dart";

// Project imports:
import "package:katana_cli/katana_cli.dart";

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
    final cloudflare = context.yaml.getAsMap("cloudflare");
    final storage = cloudflare.getAsMap("storage");
    final binding = storage.get("binding", "R2_BUCKET");
    final bucketName = storage.get("bucket_name", "");
    final previewBucketName = storage.get("preview_bucket_name", "");
    final publicBaseUrl = storage.get("public_base_url", "");
    final configuredDownloadUrlSecret = storage.get("download_url_secret", "");
    final backup = storage.getAsMap("backup");
    final backupEnabled = backup.get("enable", false);
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
    final downloadUrlSecret =
        await _loadOrCreateDownloadUrlSecret(configuredDownloadUrlSecret);
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
    var wranglerSource = _updateWranglerR2Bucket(
      await wranglerFile.readAsString(),
      binding: binding,
      bucketName: bucketName,
      previewBucketName: previewBucketName,
      backupEnabled: backupEnabled,
      backupBinding: backupBinding,
      backupBucketName: backupBucketName,
      backupPreviewBucketName: backupPreviewBucketName,
    );
    if (backupEnabled) {
      wranglerSource = _updateWranglerQueueConsumer(
        wranglerSource,
        queueName: backupQueueName,
        maxBatchSize: backupMaxBatchSize,
        maxBatchTimeout: backupMaxBatchTimeout,
        maxRetries: backupMaxRetries,
        deadLetterQueue: backupDeadLetterQueue,
      );
    }
    await wranglerFile.writeAsString(wranglerSource);
    await command(
      "Package installation.",
      [
        npm,
        "install",
        "@mathrunet/masamune_cloudflare_storage",
      ],
      workingDirectory: "cloudflare",
      runInShell: true,
    );
    await addFlutterImport(
      [
        "masamune_storage_cloudflare",
      ],
    );
    await _putWranglerSecret(
      wrangler: wrangler,
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

  Future<String> _loadOrCreateDownloadUrlSecret(String configuredSecret) async {
    final file = File("katana_secrets.yaml");
    final root = file.existsSync()
        ? Map<String, dynamic>.from(
            modifize(loadYaml(await file.readAsString())) as Map? ?? {},
          )
        : <String, dynamic>{};
    final cloudflare = _map(root, "cloudflare");
    final storage = _map(cloudflare, "storage");
    final storedSecret = storage["download_url_secret"];
    final secret = configuredSecret.isNotEmpty
        ? configuredSecret
        : storedSecret is String && storedSecret.isNotEmpty
            ? storedSecret
            : _generateDownloadUrlSecret();
    storage["download_url_secret"] = secret;
    await file.writeAsString(YamlWriter().write(root));
    return secret;
  }

  Map<String, dynamic> _map(Map<String, dynamic> parent, String key) {
    final value = parent[key];
    if (value is Map) {
      return parent[key] = Map<String, dynamic>.from(value);
    }
    return parent[key] = <String, dynamic>{};
  }

  String _generateDownloadUrlSecret() {
    final random = Random.secure();
    final bytes = List<int>.generate(48, (_) => random.nextInt(256));
    return base64UrlEncode(bytes);
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
    if (output.trim().isNotEmpty) {
      stdout.write(output);
    }
    if (result.exitCode == 0) {
      return;
    }
    final normalized = _normalizeWranglerOutput(output);
    if (RegExp(r"\[\s*code:\s*11009\s*\]").hasMatch(normalized) &&
        normalized.contains(
          "queue name '${queueName.toLowerCase()}' is already taken",
        )) {
      return;
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
    required String key,
    required String value,
  }) async {
    label("Set Cloudflare Workers secrets.");
    final process = await Process.start(
      wrangler,
      ["secret", "put", key],
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
