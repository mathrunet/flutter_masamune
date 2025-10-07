<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Auth Firebase</h1>
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

# Masamune Auth Firebase

## Overview

`masamune_auth_firebase` provides server-side integration utilities for Firebase Authentication in Masamune apps. This package focuses on backend operations that cannot be safely performed on the client side.

**Note**: This package does NOT include a client-side auth adapter. For Firebase Authentication adapters, see:
- `katana_auth_firebase` - Core Firebase Auth adapter
- `masamune_auth_google_firebase` - Google Sign-In with Firebase
- `masamune_auth_apple_firebase` - Apple Sign-In with Firebase
- `masamune_auth_github_firebase` - GitHub Sign-In with Firebase

## Usage

### Installation

Add the package to your project.

```bash
flutter pub add masamune_auth_firebase
```

Run `flutter pub get` after editing `pubspec.yaml` manually.

### Delete User with Functions Action

This package provides `FirebaseDeleteUserFunctionsAction` for securely deleting Firebase Authentication users from your backend.

**Client-side usage**:

```dart
import 'package:masamune_functions/masamune_functions.dart';
import 'package:masamune_auth_firebase/masamune_auth_firebase.dart';

// In your controller or page
final functions = ref.app.functions();

Future<void> deleteUserAccount(String uid) async {
  try {
    final response = await functions.execute(
      FirebaseDeleteUserFunctionsAction(userId: uid),
    );
    // User deleted successfully
  } catch (e) {
    debugPrint("Failed to delete user: $e");
    rethrow;
  }
}
```

**Server-side implementation**:

Your Masamune Functions backend should handle the `delete_user` action:

```dart
// In your Cloud Functions or backend
if (action == "delete_user") {
  final userId = data["userId"];
  
  // Authenticate the request
  // Verify user has permission to delete this account
  
  // Delete using Firebase Admin SDK
  await admin.auth().deleteUser(userId);
  
  return {"success": true};
}
```

The action sends `{ "userId": uid }` to your backend and expects an empty response (or throws an exception on failure).

### Authentication Flow

For complete Firebase Authentication integration, combine with:

1. **Core Auth**: `katana_auth_firebase` for basic Firebase Auth
2. **Sign-In Methods**: Platform-specific packages like:
   - `masamune_auth_google_firebase` (Google Sign-In)
   - `masamune_auth_apple_firebase` (Apple Sign-In)
   - `masamune_auth_github_firebase` (GitHub Sign-In)
3. **Server Operations**: This package (`masamune_auth_firebase`) for secure backend operations

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)