part of masamune_firebase;

/// True if you are signed in.
bool get isSignedIn {
  final auth = readProvider(firebaseAuthProvider);
  return auth.isSignedIn;
}

/// You can get the status that user email is verified after authentication is completed.
bool get isVerified {
  final auth = readProvider(firebaseAuthProvider);
  return auth.isVerified;
}

/// You can get the UID after authentication is completed.
///
/// Null is returned if authentication is not completed.
String get userId {
  final auth = readProvider(firebaseAuthProvider);
  return auth.uid;
}

/// Returns a JWT refresh token for the user.
String get refreshToken {
  final auth = readProvider(firebaseAuthProvider);
  return auth.refreshToken;
}

/// Returns a JWT access token for the user.
Future<String> get accessToken {
  final auth = readProvider(firebaseAuthProvider);
  return auth.accessToken;
}
