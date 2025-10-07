<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Model Functions</h1>
</p>

<p align="center">
  <a href="https://github.com/mathrunet">
    <img src="https://img.shields.io/static/v1?label=GitHub&message=Follow&logo=GitHub&color=333333&link=https://github.com/mathrunet" alt="Follow on GitHub" />
  </a>
  <a href="https://x.com/mathru">
    <img src="https://img.shields.io/static/v1?label=@mathru&message=Follow&logo=X&color=0F1419&link=https://x.com/mathru" alt="Follow on X" />
  </a>
  <a href="https://www.youtube.com/c/mathrunetchannel">
    <img src="https://img.shields.io/static/v1?label=YouTube&message=Follow&logo=YouTube&color=FF0000&link=https://www.youtube.com/c/mathrunetchannel" alt="Follow on YouTube" />
  </a>
  <a href="https://github.com/invertase/melos">
    <img src="https://img.shields.io/static/v1?label=maintained%20with&message=melos&color=FF1493&link=https://github.com/invertase/melos" alt="Maintained with Melos" />
  </a>
</p>

<p align="center">
  <a href="https://github.com/sponsors/mathrunet"><img src="https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=ff69b4&link=https://github.com/sponsors/mathrunet" alt="GitHub Sponsor" /></a>
</p>

---

[[GitHub]](https://github.com/mathrunet) | [[YouTube]](https://www.youtube.com/c/mathrunetchannel) | [[Packages]](https://pub.dev/publishers/mathru.net/packages) | [[X]](https://x.com/mathru) | [[LinkedIn]](https://www.linkedin.com/in/mathrunet/) | [[mathru.net]](https://mathru.net)

---

# Masamune Model Functions

## Usage

### Installation

1. Add the package to your project.

```bash
flutter pub add masamune_model_functions
```

### Setup

2. Register the adapter with your model configuration. Supply a configured `FunctionsAdapter` that connects to your backend (e.g., Firebase Functions, Cloud Run).

```dart
// lib/main.dart

import 'package:masamune_model_functions/masamune_model_functions.dart';
import 'package:katana_functions_firebase/katana_functions_firebase.dart';

final functions = FirebaseFunctionsAdapter(
  options: DefaultFirebaseOptions.currentPlatform,
  region: FirebaseRegion.asiaNortheast1,  // Your region
);

final modelAdapter = FunctionsModelAdapter(
  functionsAdapter: functions,
);

void main() {
  runMasamuneApp(
    appRef: appRef,
    modelAdapter: modelAdapter,
    (appRef, _) => MasamuneApp(
      appRef: appRef,
      home: HomePage(),
    ),
  );
}
```

### Basic Operations

3. Execute Masamune model operations as usual. All reads and writes are proxied through your backend Functions.

**Load a Collection**:

```dart
class MyPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final users = ref.app.model(UserModel.collection())..load();

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index].value;
        return ListTile(
          title: Text(user?.name ?? ''),
        );
      },
    );
  }
}
```

**Save a Document**:

```dart
final collection = ref.app.model(UserModel.collection());
final newDoc = collection.create();
await newDoc.save(
  UserModel(
    name: 'John Doe',
    email: 'john@example.com',
  ),
);
```

### Backend Implementation

Your backend must implement handlers for the following actions:

- `document_model`: Handle document load/save/delete operations
- `collection_model`: Handle collection load operations
- `aggregate_model`: Handle aggregation queries (count, sum, etc.)

**Example Cloud Functions Handler**:

```typescript
// Cloud Functions
export const model = functions.https.onCall(async (data, context) => {
  const { action, path, query, value } = data;
  
  switch (action) {
    case "document_model":
      // Handle document operations
      return await handleDocument(path, value);
      
    case "collection_model":
      // Handle collection queries
      return await handleCollection(path, query);
      
    case "aggregate_model":
      // Handle aggregations
      return await handleAggregate(path, query);
  }
});
```

### Custom Action Names

4. Customize the action names if your Functions use different identifiers:

```dart
final adapter = FunctionsModelAdapter(
  functionsAdapter: functions,
  documentAction: 'document_model_custom',
  collectionAction: 'collection_model_custom',
  aggregateAction: 'aggregate_model_custom',
);
```

### Aggregations

5. Perform aggregation queries through your backend:

```dart
final count = await ref.app.model(
  UserModel.collection().limitTo(100),
).aggregate(ModelAggregateQuery.count());

print("Total users: $count");
```

Ensure your server action returns numeric values that can be cast to the requested type.

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)