<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Katana Functions</h1>
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

Adapter plug-ins for server integration such as Cloud Functions for Firebase.

The interface with the API is implemented and used on the client side, allowing secure interaction with the server side.

# Installation

Import the following packages

```dart
flutter pub add katana_functions
```

If you use Cloud Functions for Firebase, import the following packages as well.

```dart
flutter pub add katana_functions_firebase
```

# Implementation

## Advance preparation

Always place the `FunctionsAdapterScope` widget near the root of the app.

Pass a FunctionsAdapter such as `RuntimeFunctionsAdapter` as the parameter of adapter.

```dart
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FunctionsAdapterScope(
      adapter: const RuntimeFunctionsAdapter(),
      child: MaterialApp(
        home: const FunctionsPage(),
        title: "Flutter Demo",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      ),
    );
  }
}
```

## Create Function

The following must be complied with as a prerequisite for creating a Function.

- Preliminary server side has been implemented and deployed separately.
- All input/output to/from server side is done in `JsonMap (Map<String, dynamic>)` .
    - No problem if it can be adjusted in `FunctionsAdapter` in the end.
- Returns `Exception` if communication is not successful.

As long as the above is observed, any communication format such as CloudFunctions, RestAPI, GraphQL, gRPC, etc. can be used. (Differences can be absorbed by the `FunctionsAdapter`)

Create a Function by inheriting from the abstract classes `FunctionsAction<TResponse>` and `FunctionsActionResponse`.

Define the action name of the Function in the `action` of the FunctionsAction<TResponse> and define the parameters to be passed to the server side in the `toMap()`.

Create a response based on the values returned from the server to `toResponse(DynamicMap map)`.

```dart
class TestFunctionsAction extends FunctionsAction<TestFunctionsActionResponse> {
  const TestFunctionsAction({
    required this.responseMessage,
  });

  final String responseMessage;

  @override
  String get action => "test";

  @override
  DynamicMap? toMap() {
    return {
      "message": responseMessage,
    };
  }

  @override
  TestFunctionsActionResponse toResponse(DynamicMap map) {
    return TestFunctionsActionResponse(
      message: map["message"] as String,
    );
  }
}

class TestFunctionsActionResponse extends FunctionsActionResponse {
  const TestFunctionsActionResponse({required this.message});

  final String message;
}
```

## Using Functions

Create a Functions object as follows and pass the `FunctionAction` you wish to execute to the `execute` method.

If the execution is successful, the response specified in the return value of `execute` is returned.

```dart
final functions = Functions();
final response = await functions.execute(
  TestFunctionsAction(responseMessage: "Response"),
);
print(response?.message); // "Response"
```

# FunctionsAdapter

The following `FunctionsAdapter` is available

- `RuntimeFunctionsAdapter`：FunctionsAdapter that completes without server processing and without error. available as a stub.
- `FirebaseFunctionsAdapter`: FunctionsAdapter for using FirebaseFunctions, where `action` is the name of the Function.

It is also possible to link with RestAPI, GraphQL, and gRPC that you have prepared yourself by inheriting `FunctionsAdapter`.

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[Sponsor @mathrunet on GitHub Sponsors](https://github.com/sponsors/mathrunet)