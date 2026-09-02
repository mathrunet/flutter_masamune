import "package:katana_cli/action/firebase/init.dart";

void main() {
  _expect(
    firebaseAppleBuildConfigurationForFlavor("dev") == "Debug",
    "The dev Firebase flavor must use the Debug Apple build configuration.",
  );
  _expect(
    firebaseAppleBuildConfigurationForFlavor("prod") == "Release",
    "The prod Firebase flavor must use the Release Apple build configuration.",
  );
  _expect(
    _listEquals(
      firebaseAppleBuildConfigurationArgumentsForFlavor("dev"),
      const [
        "--ios-build-config=Debug",
        "--macos-build-config=Debug",
      ],
    ),
    "The dev FlutterFire command must configure Apple platforms without prompts.",
  );
  _expect(
    _listEquals(
      firebaseAppleBuildConfigurationArgumentsForFlavor("prod"),
      const [
        "--ios-build-config=Release",
        "--macos-build-config=Release",
      ],
    ),
    "The prod FlutterFire command must configure Apple platforms without prompts.",
  );
  _expectThrows(
    () => firebaseAppleBuildConfigurationForFlavor("stg"),
    "An unknown Firebase flavor must not select an Apple build configuration.",
  );

  final devAliases = FirebaseProjectAliasSynchronizer.synchronize(
    '''
{
  "projects": { "default": "legacy-project" },
  "targets": {
    "legacy-project": {
      "hosting": { "app": ["legacy-site"] }
    }
  }
}
''',
    flavor: "dev",
    projectId: "app-dev",
  );
  final bothAliases = FirebaseProjectAliasSynchronizer.synchronize(
    devAliases,
    flavor: "prod",
    projectId: "app-prod",
  );
  _expect(
    bothAliases.contains('"dev": "app-dev"') &&
        bothAliases.contains('"prod": "app-prod"'),
    "Firebase project aliases must preserve both environments.",
  );
  _expect(
    bothAliases.contains('"default": "legacy-project"') &&
        bothAliases.contains('"legacy-site"'),
    "Firebase alias synchronization must preserve unrelated CLI settings.",
  );
  _expect(
    FirebaseProjectAliasSynchronizer.synchronize(
          bothAliases,
          flavor: "prod",
          projectId: "app-prod",
        ) ==
        bothAliases,
    "Firebase project alias synchronization must be idempotent.",
  );
  final restoredAliases = FirebaseProjectAliasSynchronizer.restore(
    '{"projects":{"default":"app-prod"}}',
    from: bothAliases,
  );
  _expect(
    restoredAliases.contains('"default": "app-prod"') &&
        restoredAliases.contains('"dev": "app-dev"') &&
        restoredAliases.contains('"prod": "app-prod"') &&
        restoredAliases.contains('"legacy-site"'),
    "Firebase CLI regeneration must preserve aliases and unrelated settings.",
  );
  _expectThrows(
    () => FirebaseProjectAliasSynchronizer.synchronize(
      "not-json",
      flavor: "dev",
      projectId: "app-dev",
    ),
    "Malformed .firebaserc content must fail closed.",
  );

  _expect(
    firebaseProjectListContains(
      '{"status":"success","result":[{"projectId":"app-dev"}]}',
      "app-dev",
    ),
    "Firebase project preflight must recognize the selected project.",
  );
  _expect(
    !firebaseProjectListContains("not-json", "app-dev"),
    "Malformed Firebase CLI output must fail closed.",
  );
  validateFirebaseProjectConfiguration(
    expectedProjectId: "app-dev",
    androidJson: '''
{"project_info":{"project_id":"app-dev"}}
''',
    applePlists: const [
      '''
<?xml version="1.0" encoding="UTF-8"?>
<plist><dict><key>PROJECT_ID</key><string>app-dev</string></dict></plist>
''',
    ],
  );

  _expectThrows(
    () => validateFirebaseProjectConfiguration(
      expectedProjectId: "app-prod",
      androidJson: '''
{"project_info":{"project_id":"app-dev"}}
''',
      applePlists: const [
        """
<plist><dict><key>PROJECT_ID</key><string>app-prod</string></dict></plist>
""",
      ],
    ),
    "A mismatched Android project must fail before the native build.",
  );

  _expectThrows(
    () => validateFirebaseProjectConfiguration(
      expectedProjectId: "app-prod",
      androidJson: '''
{"project_info":{"project_id":"app-prod"}}
''',
      applePlists: const [
        """
<plist><dict><key>PROJECT_ID</key><string>app-dev</string></dict></plist>
""",
      ],
    ),
    "A mismatched Apple project must fail before the native build.",
  );
}

void _expect(bool condition, String message) {
  if (!condition) {
    throw StateError(message);
  }
}

bool _listEquals(List<String> actual, List<String> expected) =>
    actual.length == expected.length &&
    Iterable<int>.generate(actual.length).every(
      (index) => actual[index] == expected[index],
    );

void _expectThrows(void Function() callback, String message) {
  try {
    callback();
  } on Object {
    return;
  }
  throw StateError(message);
}
