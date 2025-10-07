<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Storage Functions</h1>
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

# Masamune Storage Functions

## Usage

### Installation

1. Add the package to your project.

```bash
flutter pub add masamune_storage_functions
```

### Setup

2. Configure the storage adapter backed by Cloud Functions.

```dart
// lib/main.dart

import 'package:masamune_storage_functions/masamune_storage_functions.dart';
import 'package:katana_functions_firebase/katana_functions_firebase.dart';

final functionsAdapter = FirebaseFunctionsAdapter(
  options: DefaultFirebaseOptions.currentPlatform,
  region: FirebaseRegion.asiaNortheast1,
);

final storageAdapter = FunctionsStorageAdapter(
  functionsAdapter: functionsAdapter,
  bucketName: 'your-project.appspot.com',  // Your Cloud Storage bucket
);

void main() {
  runMasamuneApp(
    appRef: appRef,
    storageAdapter: storageAdapter,
    (appRef, _) => MasamuneApp(
      appRef: appRef,
      home: HomePage(),
    ),
  );
}
```

### Upload Files

3. Upload files through your Cloud Functions backend:

```dart
class FileUploadPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final storage = ref.app.storage();

    return ElevatedButton(
      onPressed: () async {
        // Upload from bytes
        final bytes = await File('path/to/image.png').readAsBytes();
        final uploadedFile = await storage.uploadWithBytes(
          bytes,
          'uploads/user_${userId}/profile.png',
          mimeType: 'image/png',
        );
        
        print("Uploaded to: ${uploadedFile.publicUrl}");
      },
      child: const Text("Upload File"),
    );
  }
}
```

**Upload from URI**:

```dart
// Upload from ModelImageUri or ModelVideoUri
final modelImageUri = ModelImageUri.fromPath('local/path/image.jpg');
final result = await storage.uploadWithUri(
  modelImageUri.uri,
  'uploads/image.jpg',
);

print("Download URL: ${result.downloadUrl}");
```

### Download Files

4. Download files from Cloud Storage:

```dart
// Download file bytes
final bytes = await storage.download('uploads/image.png');

// Save to local file
await File('local/path/downloaded.png').writeAsBytes(bytes);
```

### Delete Files

```dart
// Delete a file
await storage.delete('uploads/old_file.png');
```

### Backend Implementation

Your Cloud Functions must handle storage operations:

```typescript
// Cloud Functions
export const storage = functions.https.onCall(async (data, context) => {
  const bucket = admin.storage().bucket();
  
  switch (data.action) {
    case "upload":
      // Handle file upload
      const file = bucket.file(data.path);
      await file.save(Buffer.from(data.bytes, 'base64'), {
        contentType: data.mimeType,
      });
      
      const [url] = await file.getSignedUrl({
        action: 'read',
        expires: Date.now() + 3600000,
      });
      
      return { 
        publicUrl: url,
        downloadUrl: url,
      };
      
    case "download":
      // Handle file download
      const downloadFile = bucket.file(data.path);
      const [buffer] = await downloadFile.download();
      return { bytes: buffer.toString('base64') };
      
    case "delete":
      // Handle file deletion
      await bucket.file(data.path).delete();
      return { success: true };
  }
});
```

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)