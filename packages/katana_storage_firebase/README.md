<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Katana Storage</h1>
</p>

<p align="center">
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

# Introduction

The ability to upload files representing image files is used by a variety of applications.

Uploading image files, such as social networking and matching applications, can facilitate communication.

There are many cloud services that allow you to upload files and make them available to your application, but if you are using Flutter and Firestore, [Cloud Storage for Firebase](https://firebase.google.com/products/storage) is probably the best choice for you.

This package implements a package that allows switching between Firebase and local file storage using an adapter similar to the one implemented in [katana_model](https://pub.dev/packages/katana_model).

# Installation

Import the following packages.

```dart
flutter pub add katana_storage
```

If you use Cloud Storage for Firebase, import the following packages together.

```dart
flutter pub add katana_storage_firebase
```

# Implementation

## Advance preparation

Always place the `StorageAdapterScope` widget near the root of the app.

Pass a StorageAdapter such as `LocalStorageAdapter` as the parameter adapter.

```dart
// main.dart
import 'package:flutter/material.dart';
import 'package:katana_storage/katana_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StorageAdapterScope(
      adapter: const LocalStorageAdapter(),
      child: MaterialApp(
        home: const StoragePage(),
        title: "Flutter Demo",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      ),
    );
  }
}
```

## Storage Object Creation

First, create one `Storage` object per file.

Pass a `StorageQuery` describing the relative path on the remote side at the time of creation.

Since the Storage object inherits from `ChangeNotifier`, it can be used in conjunction with `addListener` and riverpod's `ChangeNotifierProvider` to monitor its status.

```dart
final storage = Storage(const StorageQuery("test/file"));
```

```dart
class StoragePage extends StatefulWidget {
  const StoragePage({super.key});

  @override
  State<StatefulWidget> createState() => StoragePageState();
}

class StoragePageState extends State<StoragePage> {
  final storage = Storage(const StorageQuery("test/file"));
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    storage.addListener(_handledOnUpdate);
  }

  void _handledOnUpdate() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    storage.removeListener(_handledOnUpdate);
    storage.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("App Demo")),
      body: TextField(
        controller: controller,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final text = controller.text;
          final bytes = Uint8List.fromList(text.codeUnits);
          await storage.uploadWithBytes(bytes);
        },
        child: const Icon(Icons.upload_file),
      ),
    );
  }
}
```

## Uploading

The following methods are available to perform uploads

- `upload`：Upload the file by specifying the file path locally.
- `uploadWithBytes`：Upload directly by passing byte data.

A `StorageValue` is passed in the return value. The remote full path of the uploaded file is stored here.

```dart
final bytes = Uint8List.fromList(text.codeUnits);
final storageValue = await storage.uploadWithBytes(bytes);
print("Remote path is: ${storageValue.remote.path}");
```

## Downloading

To download a file that has already been uploaded to storage, use the `download` method.

It is also possible to specify a relative path to a file to be saved locally as an argument.

`StorageValue` is passed as the return value, where the local full path of the downloaded file and the actual data of the file are stored.

Saving to local files is not supported on the Web.

```dart
final bytes = Uint8List.fromList(text.codeUnits);
final storageValue = await storage.download("file.jpg");
print("Local path is: ${storageValue.local.path}");
print("Local data is: ${storageValue.local.bytes}");
```

# StorageAdapter

It is possible to change the storage system by passing `StorageAdapterScope` when defining it.

- `RuntimeStorageAdapter`：Data is uploaded only in the app's memory. It is not actually saved. Please use this function during testing.
- `LocalStorageAdapter`：Storage adapter for storing files locally on the terminal; note that both `local` and `remote` in download and upload are in the terminal. This is useful for implementing screen mocks.
- `FirebaseStorageAdapter`：Storage adapter to use Cloud Storage for Firebase. Can be used between apps; requires [initial Firebase configuration](https://firebase.google.com/docs/storage/flutter/start).

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)