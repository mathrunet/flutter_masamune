import "dart:io";

import "package:katana_cli/action/cloudflare/cloudflare_source_utils.dart";
import "package:katana_cli/command/code/server/server.dart";
import "package:katana_cli/katana_cli.dart";

/// `katana code server worker/schedule cloudflare`のedge.ts/region.ts登録の回帰テスト。
Future<void> main() async {
  await _testWorkerRegistersInEdge();
  await _testWorkerRegistersInRegion();
  await _testNestedPathAndConstApp();
  await _testRegionDisabledFails();
  await _testScheduleRegion();
  await _testScheduleEdge();
  await _testMissingEdgeWarnsAndContinues();
  await _testFindEdgeTidbUsages();
  _testEnsureNamedImport();
  stdout.writeln("Cloudflare Worker registration regression checks passed");
}

void _check(bool condition, String message) {
  if (!condition) {
    throw StateError(message);
  }
}

Future<T> _inTemporaryProject<T>(
  String prefix,
  Future<T> Function(Directory root) body,
) async {
  final previous = Directory.current;
  final temp = await Directory.systemTemp.createTemp(prefix);
  try {
    Directory.current = temp;
    return await body(temp);
  } finally {
    Directory.current = previous;
    await temp.delete(recursive: true);
  }
}

const _edgeSource = """
import * as m from "@mathrunet/masamune_cloudflare";
import rules from "./rules.json";

export default m.deploy([
    customFunction(),
], {
    type: "edge",
    rules: rules as m.RulesConfig,
});
""";

const _regionSource = """
import * as m from "@mathrunet/masamune_cloudflare";
import rules from "./rules.json";

export default m.deploy([
], {
    type: "region",
    rules: rules as m.RulesConfig,
});
""";

void _writeEntries({bool region = true, String edge = _edgeSource}) {
  Directory("cloudflare/src").createSync(recursive: true);
  File(cloudflareEdgeEntryPath).writeAsStringSync(edge);
  if (region) {
    File(cloudflareRegionEntryPath).writeAsStringSync(_regionSource);
  }
}

Map<String, Object> _yaml({required bool region}) {
  return {
    "cloudflare": {
      "project_id": "app",
      "workers": {
        "enable": true,
        "region": {"enable": region},
      },
    },
  };
}

ExecContext _context(List<String> args, {bool region = true}) {
  return ExecContext(yaml: _yaml(region: region), args: args);
}

int _count(String source, String pattern) {
  return pattern.allMatches(source).length;
}

/// フラグ無しはedge.tsへ登録し、2回実行しても重複しない。
Future<void> _testWorkerRegistersInEdge() async {
  await _inTemporaryProject("katana-worker-edge-", (root) async {
    _writeEntries();
    final context = _context(["code", "server", "worker", "sample"]);
    await const CodeServerWorkerCliCommand().exec(context);
    await const CodeServerWorkerCliCommand().exec(context);
    final edge = File(cloudflareEdgeEntryPath).readAsStringSync();
    final region = File(cloudflareRegionEntryPath).readAsStringSync();
    _check(File("cloudflare/src/workers/sample.ts").existsSync(),
        "The worker source must be generated.");
    _check(
        _count(edge, 'import { SampleWorker } from "./workers/sample";') == 1 &&
            _count(edge, "new SampleWorker()") == 1 &&
            edge.contains("customFunction(),"),
        "SampleWorker must be registered once in edge.ts: $edge");
    _check(region == _regionSource,
        "region.ts must not be touched without --region: $region");
    final action = File("lib/functions/sample.dart").readAsStringSync();
    _check(!action.contains("get target"),
        "The edge FunctionsAction must not override target: $action");
  });
}

/// --regionはregion.tsのみへ登録し、Dart actionにtarget => "region"を付ける。
Future<void> _testWorkerRegistersInRegion() async {
  await _inTemporaryProject("katana-worker-region-", (root) async {
    _writeEntries();
    final context =
        _context(["code", "server", "worker", "--region", "heavy_task"]);
    await const CodeServerWorkerCliCommand().exec(context);
    await const CodeServerWorkerCliCommand().exec(context);
    final edge = File(cloudflareEdgeEntryPath).readAsStringSync();
    final region = File(cloudflareRegionEntryPath).readAsStringSync();
    _check(edge == _edgeSource,
        "edge.ts must not be touched with --region: $edge");
    _check(
        _count(region,
                    'import { HeavyTaskWorker } from "./workers/heavy_task";') ==
                1 &&
            _count(region, "new HeavyTaskWorker()") == 1,
        "HeavyTaskWorker must be registered once in region.ts: $region");
    final action = File("lib/functions/heavy_task.dart").readAsStringSync();
    _check(action.contains('String? get target => "region";'),
        "The region FunctionsAction must target region: $action");
  });
}

/// ネストしたpathと`const app = m.deploy(`形式、`.js`付きimportへの追従。
Future<void> _testNestedPathAndConstApp() async {
  await _inTemporaryProject("katana-worker-nested-", (root) async {
    _writeEntries(edge: """
import * as m from "@mathrunet/masamune_cloudflare";
import { OtherWorker } from "./workers/other.js";

const app = m.deploy([
    new OtherWorker(),
], { type: "edge" });

export default app;
""");
    await const CodeServerWorkerCliCommand()
        .exec(_context(["code", "server", "worker", "user/profile"]));
    final edge = File(cloudflareEdgeEntryPath).readAsStringSync();
    _check(File("cloudflare/src/workers/user/profile.ts").existsSync(),
        "The nested worker source must be generated.");
    _check(
        edge.contains(
                'import { UserProfileWorker } from "./workers/user/profile.js";') &&
            edge.contains("new UserProfileWorker(),") &&
            edge.contains("new OtherWorker(),") &&
            edge.indexOf("new UserProfileWorker()") < edge.indexOf("], { type"),
        "The nested worker must be registered in const app = m.deploy(: $edge");
  });
}

/// region無効で--regionはエラーになり、何も生成しない。
Future<void> _testRegionDisabledFails() async {
  await _inTemporaryProject("katana-worker-region-off-", (root) async {
    _writeEntries(region: false);
    await const CodeServerWorkerCliCommand().exec(_context(
        ["code", "server", "worker", "sample", "--region"],
        region: false));
    await const CodeServerScheduleCloudflareCliCommand().exec(_context(
        ["code", "server", "schedule", "cloudflare", "daily", "--region"],
        region: false));
    _check(!Directory("cloudflare/src/workers").existsSync(),
        "No worker source must be generated when region is disabled.");
    _check(!Directory("lib/functions").existsSync(),
        "No Dart action must be generated when region is disabled.");
    _check(File(cloudflareEdgeEntryPath).readAsStringSync() == _edgeSource,
        "edge.ts must not be touched when region is disabled.");
    // region有効でもregion.tsが無ければ生成しない。
    await const CodeServerWorkerCliCommand()
        .exec(_context(["code", "server", "worker", "sample", "--region"]));
    _check(!Directory("cloudflare/src/workers").existsSync(),
        "No worker source must be generated without region.ts.");
  });
}

/// schedule cloudflare --regionはRegionScheduleProcessWorkdersBaseを継承しregion.tsへ登録する。
Future<void> _testScheduleRegion() async {
  await _inTemporaryProject("katana-schedule-region-", (root) async {
    _writeEntries();
    await const CodeServerScheduleCloudflareCliCommand().exec(_context([
      "code",
      "server",
      "schedule",
      "cloudflare",
      "--region",
      "daily_sync"
    ]));
    final source =
        File("cloudflare/src/workers/daily_sync.ts").readAsStringSync();
    _check(
        source.contains(
                "export class DailySyncSchedule extends mc.RegionScheduleProcessWorkdersBase") &&
            source.contains('path = "/_masamune/schedule/daily_sync";') &&
            source.contains("async run(") &&
            !source.contains("async process("),
        "The region schedule template must use RegionScheduleProcessWorkdersBase: $source");
    final region = File(cloudflareRegionEntryPath).readAsStringSync();
    _check(
        region.contains(
                'import { DailySyncSchedule } from "./workers/daily_sync";') &&
            region.contains("new DailySyncSchedule(),"),
        "The region schedule must be registered in region.ts: $region");
    _check(File(cloudflareEdgeEntryPath).readAsStringSync() == _edgeSource,
        "edge.ts must not be touched by schedule --region.");
  });
}

/// schedule cloudflareはフラグ無しでedge.tsへ登録する。
Future<void> _testScheduleEdge() async {
  await _inTemporaryProject("katana-schedule-edge-", (root) async {
    _writeEntries();
    await const CodeServerScheduleCloudflareCliCommand()
        .exec(_context(["code", "server", "schedule", "cloudflare", "hourly"]));
    final source = File("cloudflare/src/workers/hourly.ts").readAsStringSync();
    _check(
        source.contains("extends mc.ScheduleProcessWorkdersBase") &&
            !source.contains("RegionScheduleProcessWorkdersBase"),
        "The edge schedule template must stay unchanged: $source");
    final edge = File(cloudflareEdgeEntryPath).readAsStringSync();
    _check(
        edge.contains('import { HourlySchedule } from "./workers/hourly";') &&
            edge.contains("new HourlySchedule(),"),
        "The edge schedule must be registered in edge.ts: $edge");
  });
}

/// edge.tsが無い場合は警告のみでコードは生成する。
Future<void> _testMissingEdgeWarnsAndContinues() async {
  await _inTemporaryProject("katana-worker-no-edge-", (root) async {
    await const CodeServerWorkerCliCommand()
        .exec(_context(["code", "server", "worker", "sample"], region: false));
    _check(File("cloudflare/src/workers/sample.ts").existsSync(),
        "The worker source must be generated without edge.ts.");
    _check(!File(cloudflareEdgeEntryPath).existsSync(),
        "edge.ts must not be created.");
  });
}

/// edge.tsから多段importを辿ってTiDB使用ファイルを検出する。
Future<void> _testFindEdgeTidbUsages() async {
  await _inTemporaryProject("katana-edge-tidb-", (root) async {
    Directory("cloudflare/src/workers/nested").createSync(recursive: true);
    Directory("cloudflare/src/lib").createSync(recursive: true);
    File(cloudflareEdgeEntryPath).writeAsStringSync("""
import * as m from "@mathrunet/masamune_cloudflare";
import { AWorker } from "./workers/a";
import { CleanWorker } from "./workers/clean.js";
export default m.deploy([new AWorker(), new CleanWorker()], { type: "edge" });
""");
    File("cloudflare/src/workers/a.ts").writeAsStringSync("""
import { helper } from "./nested/b";
export class AWorker {}
""");
    File("cloudflare/src/workers/nested/b.ts").writeAsStringSync("""
export * from "../../lib/db";
import { a } from "../a";
""");
    File("cloudflare/src/lib/db.ts").writeAsStringSync("""
import { TidbDirectClient } from "@mathrunet/masamune_cloudflare_tidb";
export const client = (env: any) => new TidbDirectClient(env.TIDB_HOST);
""");
    File("cloudflare/src/workers/clean.ts").writeAsStringSync("""
export class CleanWorker {}
""");
    final usages = findEdgeTidbUsages();
    _check(usages.length == 1 && usages.single == "cloudflare/src/lib/db.ts",
        "TiDB usage must be found through nested imports: $usages");
    File("cloudflare/src/lib/db.ts").writeAsStringSync("export const a = 1;\n");
    _check(findEdgeTidbUsages().isEmpty,
        "No TiDB usage must be reported after removal.");
    File(cloudflareEdgeEntryPath).writeAsStringSync("""
import * as tidb from "@mathrunet/masamune_cloudflare_tidb";
""");
    _check(findEdgeTidbUsages().single == cloudflareEdgeEntryPath,
        "TiDB usage in edge.ts itself must be reported.");
  });
}

void _testEnsureNamedImport() {
  const source = """
import * as m from "@mathrunet/masamune_cloudflare";
import { AWorker } from "./workers/a";
""";
  final added = CloudflareSourceUtils.ensureNamedImport(source,
      name: "BWorker", from: "./workers/b");
  _check(
      added.endsWith('import { AWorker } from "./workers/a";\n'
          'import { BWorker } from "./workers/b";\n'),
      "A new import must be added after the last import: $added");
  _check(
      CloudflareSourceUtils.ensureNamedImport(added,
              name: "BWorker", from: "./workers/b") ==
          added,
      "An existing import must be kept as is.");
  final merged = CloudflareSourceUtils.ensureNamedImport(source,
      name: "ASchedule", from: "./workers/a");
  _check(merged.contains('import { AWorker, ASchedule } from "./workers/a";'),
      "A name must be merged into the existing import from the same module: $merged");
}
