<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Katana Auth</h1>
</p>

<p align="center">
  <a href="https://twitter.com/mathru">
    <img src="https://img.shields.io/twitter/follow/mathru.svg?colorA=1da1f2&colorB=&label=Follow%20on%20Twitter&style=flat-square" alt="Follow on Twitter" />
  </a>
  <a href="https://github.com/invertase/melos">
    <img src="https://img.shields.io/badge/maintained%20with-melos-f700ff.svg?style=flat-square" alt="Maintained with Melos" />
  </a>
</p>

<p align="center">
  <a href="https://www.buymeacoffee.com/mathru"><img src="https://img.buymeacoffee.com/button-api/?text=Buy me a coffee&emoji=&slug=mathru&button_colour=FF5F5F&font_colour=ffffff&font_family=Poppins&outline_colour=000000&coffee_colour=FFDD00" width="136" /></a>
</p>

---

[[YouTube]](https://www.youtube.com/c/mathrunetchannel) | [[Packages]](https://pub.dev/publishers/mathru.net/packages) | [[Twitter]](https://twitter.com/mathru) | [[LinkedIn]](https://www.linkedin.com/in/mathrunet/)

---

# Introduction

FirebaseAuthentication for use around authentication is useful.

Various types of authentication can be easily implemented, including authentication by e-mail address, phone number, and SNS accounts.

However, even if Firebase authentication is to be used later, there may be times when you want to implement authentication without connecting to the server when creating a mockup of the application, or when you want to implement authentication in the test code.

Therefore, I have implemented a package that allows switching between Firebase and local authentication using an adapter, just as I did with katana_model.

In addition, the interface has been improved so that it is easy to switch between using Google sign-in and Apple sign-in depending on the application.

# Installation

Import the following packages.

```dart
flutter pub add katana_auth
```

If you use Firestore, import the following packages together.

```dart
flutter pub add katana_auth_firebase
```

# Implementation

## Advance preparation

Always place the `AuthAdapterScope` widget near the root of the app.

Pass an AuthAdapter such as `RuntimeAuthAdapter` as the adapter parameter.

```dart
// main.dart
import 'package:flutter/material.dart';
import 'package:katana_auth/katana_auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthAdapterScope(
      adapter: const RuntimeAuthAdapter(),
      child: MaterialApp(
        home: const AuthPage(),
        title: "Flutter Demo",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      ),
    );
  }
}
```

## Creating Authentication Objects

To perform authentication, first create an `Authentication` and keep it somewhere.

The `Authentication` object can obtain the following data to check the status of authentication.

- isSignedIn：Returns `true` if authenticated.
- isAnonymously：Returns `true` for anonymous authentication.
- userId：Returns the user ID.
- userEmail：Returns the user's email address if email authentication, etc. is performed.
- userPhoneNumber：Returns the user's phone number if phone number verification is performed.

In addition, since `Authentication` inherits ChangeNotifier, it is possible to monitor updates by using `addListener` or riverpod's `ChangeNotifierProvider`, for example.

```dart
// auth_page.dart
import 'package:flutter/material.dart';
import 'package:katana_auth/katana_auth.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<StatefulWidget> createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {
  final auth = Authentication();

  @override
  void initState() {
    super.initState();
    auth.addListener(_handledOnUpdate);
  }

  void _handledOnUpdate() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    auth.removeListener(_handledOnUpdate);
    auth.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("App Demo")),
      body: ListView(
        children: [
          ListTile(
            title: Text("SignedIn: ${auth.isSignedIn}"),
          ),
          ListTile(
            title: Text("Anonymously: ${auth.isAnonymously}"),
          ),
          ListTile(
            title: Text("ID: ${auth.userId}"),
          ),
          ListTile(
            title: Text("Email: ${auth.userEmail}"),
          ),
          ListTile(
            title: Text("Phone: ${auth.userPhoneNumber}"),
          ),
        ],
      ),
    );
  }
}
```

## User Registration & Login

The `auth.register` method is used to register users.

`RegisterAuthProvider` must be passed as the argument.

RegisterAuthProvider should be obtained using an `AuthQuery` with a `register` method.

(AuthQuery is discussed below.)

```dart
await auth.register(
  EmailAndPasswordAuthQuery.register(
    email: "test@email.com",
    password: "12345678",
  ),
);
```

Also, use `auth.signIn` to perform login.

The SignInAuthProvider must be passed as an argument and should be obtained using an `AuthQuery` with a `signIn` method.

```dart
await auth.signIn(
  EmailAndPasswordAuthQuery.signIn(
    email: "test@email.com",
    password: "12345678",
  ),
);
```

Use `auth.confirmSignIn` to confirm authentication, such as to perform mail link authentication or SMS authentication.

```dart
await auth.confirmSignIn(
  SmsAuthQuery.confirmSignIn(
    code: "012345",
  ),
);
```

## Change User Information

Use `auth.change` to change user information.

`ChangeAuthProvider` is passed as an argument, but the AuthQuery method can be changed depending on what is to be changed.

- `EmailAndPasswordAuthQuery.changeEmail`：Change of e-mail address.
- `EmailAndPasswordAuthQuery.changePassword`：Change password.
- `SmsAuthQuery.changePhoneNumber`：Change of telephone number.

```dart
await auth.change(
  EmailAndPasswordAuthQuery.changeEmail(
    email: "changed@email.com"
  ),
);
```

(Only available when logged in.)

## Logout

Use `auth.signOut` to log out.

Available only at login, no arguments required.

```dart
await auth.signOut();
```

# AuthAdapter

It is possible to change the authentication system by passing it when defining the `AuthAdapterScope`.

- `RuntimeAuthAdapter`：Authentication system that works only when the app is launched. Authentication information is reset when the app is re-launched. Use this system when testing.
- `LocalAuthAdapter`：Authentication system that works only locally on the device. Authentication information remains even if the application is re-launched, but cannot be shared among other devices.
- `FirebaseAuthAdapter`：FirebaseAuthentication system. Allows sharing of authentication information between terminals; requires [initial Firebase configuration](https://firebase.google.com/docs/auth/flutter/start).

# AuthQuery

`AuthQuery` is provided for each authentication provider.

By using the `AuthQuery` method, it is possible to use the functions for authentication provided by the `Authentication` class.

(Availability is limited by the authentication provider.)

- `AnonymouslyAuthQuery`：AuthQuery for providers offering anonymous authentication.
- `EmailAndPasswordAuthQuery`：AuthQuery for providers that offers authentication by email address and password.
- `EmailLinkAuthQuery`：AuthQuery for providers that offers authentication via email link.
- `SmsAuthQuery`：AuthQuery for providers offering authentication via SMS.
- `SnsSignInAuthProvider`：Abstract class of AuthQuery for providers offering authentication with SNS accounts. Since it is an abstract class, the actual AuthQuery can be used by loading other related packages.
