part of "/masamune_ai.dart";

/// Memory container for [AIAgent].
///
/// [AIAgent]のためのメモリコンテナ。
@immutable
class AgentMemory {
  /// Creates an instance of [AgentMemory].
  ///
  /// [AgentMemory]のインスタンスを生成します。
  const AgentMemory({
    this.entries = const [],
    this.maxEntries = 50,
  });

  /// Stored memory entries.
  ///
  /// 保存されたメモリ。
  final List<String> entries;

  /// Maximum number of entries retained.
  ///
  /// 保持する最大件数。
  final int maxEntries;

  /// Records a new [entry] into memory.
  ///
  /// 新しい[entry]をメモリに記録します。
  AgentMemory record(String entry) {
    if (entry.isEmpty) {
      return this;
    }
    final updated = [...entries, entry];
    if (updated.length <= maxEntries) {
      return AgentMemory(
          entries: List.unmodifiable(updated), maxEntries: maxEntries);
    }
    final trimmed = updated.sublist(updated.length - maxEntries);
    return AgentMemory(
        entries: List.unmodifiable(trimmed), maxEntries: maxEntries);
  }

  /// Merges [other] memory into this instance.
  ///
  /// [other]のメモリを現在のメモリに統合します。
  AgentMemory merge(AgentMemory other) {
    final merged = [...entries, ...other.entries];
    if (merged.length <= maxEntries) {
      return AgentMemory(
          entries: List.unmodifiable(merged), maxEntries: maxEntries);
    }
    final trimmed = merged.sublist(merged.length - maxEntries);
    return AgentMemory(
        entries: List.unmodifiable(trimmed), maxEntries: maxEntries);
  }
}

/// Configuration for vector-based agent memory.
///
/// ベクトルメモリの設定。
@immutable
class AIAgentVectorMemoryConfig {
  /// Configuration for vector-based agent memory.
  ///
  /// ベクトルメモリの設定。
  const AIAgentVectorMemoryConfig({
    this.chunkSize = 512,
    this.chunkOverlap = 64,
    this.minChunkLength = 32,
    this.maxChunksPerEntry = 4,
    this.recallLimit = 5,
    this.measure = VectorDistanceMeasure.cosine,
    this.memoryPrefix = "Relevant memories:",
    this.attachAsSystemContent = true,
  })  : assert(chunkSize > 0, "chunkSize must be greater than 0."),
        assert(chunkOverlap >= 0, "chunkOverlap must be positive."),
        assert(minChunkLength >= 0, "minChunkLength must be positive."),
        assert(
          chunkOverlap < chunkSize,
          "chunkOverlap must be smaller than chunkSize.",
        ),
        assert(
            maxChunksPerEntry > 0, "maxChunksPerEntry must be greater than 0."),
        assert(recallLimit > 0, "recallLimit must be greater than 0.");

  /// Maximum characters stored per chunk.
  ///
  /// チャンクあたりの最大文字数。
  final int chunkSize;

  /// Characters overlapped when chunking.
  ///
  /// チャンク分割時の重なり文字数。
  final int chunkOverlap;

  /// Minimum characters required to persist a chunk.
  ///
  /// 保存対象とする最小文字数。
  final int minChunkLength;

  /// Maximum number of chunks stored per entry.
  ///
  /// 1エントリーあたりに保存する最大チャンク数。
  final int maxChunksPerEntry;

  /// Maximum number of memories recalled per request.
  ///
  /// 1回のリクエストで参照するメモリ件数。
  final int recallLimit;

  /// Distance measure used for nearest search.
  ///
  /// 類似検索に利用する距離測定方法。
  final VectorDistanceMeasure measure;

  /// Prefix text used when injecting memories into the prompt.
  ///
  /// プロンプトにメモリを組み込む際の接頭辞。
  final String memoryPrefix;

  /// If `true`, recalled memories are injected as a system message.
  ///
  /// `true`の場合、取得したメモリをシステムメッセージとして追加します。
  final bool attachAsSystemContent;

  /// Build a formatted prompt from [memories].
  ///
  /// [memories]からフォーマット済みのテキストを作成します。
  String buildMemoryPrompt(List<String> memories) {
    if (memories.isEmpty) {
      return "";
    }
    final buffer = StringBuffer(memoryPrefix.trim());
    for (final memory in memories) {
      final refined = memory.trim();
      if (refined.isEmpty) {
        continue;
      }
      buffer
        ..writeln()
        ..write("- ")
        ..write(refined);
    }
    return buffer.toString().trim();
  }

  /// Safe overlap within the chunk size.
  ///
  /// チャンクサイズに応じて調整された重なり文字数。
  int get safeChunkOverlap =>
      math.min(chunkOverlap, math.max(0, chunkSize - 1));
}

/// Final result returned by [AIAgent.run].
///
/// [AIAgent.run] が返却する最終結果。
@immutable
class AgentRunResult {
  /// Creates an instance of [AgentRunResult].
  ///
  /// [AgentRunResult]のインスタンスを生成します。
  const AgentRunResult({
    required this.status,
    required this.responses,
    required this.steps,
    required this.usedTools,
    required this.memory,
  });

  /// Final status of the run.
  ///
  /// 実行結果のステータス。
  final AgentStatus status;

  /// Agent responses returned to the caller.
  ///
  /// 返却されたエージェントの応答。
  final List<AIContent> responses;

  /// Recorded steps during the run.
  ///
  /// 実行中に記録されたステップ。
  final List<AgentStep> steps;

  /// Tool names used in the run.
  ///
  /// 実行時に利用したツール一覧。
  final Set<String> usedTools;

  /// Memory state after the run.
  ///
  /// 実行完了時のメモリ状態。
  final AgentMemory memory;
}
