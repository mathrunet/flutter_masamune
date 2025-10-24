<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Location</h1>
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

# Masamune Location Platform Interface

## Overview

`masamune_location_platform_interface` defines the abstract interfaces for location-related adapters in the Masamune framework. This package is primarily used by package authors implementing custom location adapters.

**Note**: Most developers should use `masamune_location` instead of this package directly.

## Usage

This package is automatically included as a dependency when you use:
- `masamune_location`
- `masamune_location_background`
- `masamune_location_geocoding`
- `masamune_location_google`

### For Package Authors

If you're creating a custom location adapter, extend `LocationMasamuneAdapter`:

```dart
import 'package:masamune_location_platform_interface/masamune_location_platform_interface.dart';

class MyCustomLocationAdapter extends LocationMasamuneAdapter {
  @override
  Future<Position> getCurrentPosition() async {
    // Implement custom location retrieval
  }

  @override
  Future<void> startListening({
    double? distanceFilter,
    Duration? timeInterval,
  }) async {
    // Implement continuous updates
  }

  // ... other methods
}
```

### Provided Interfaces

- `LocationMasamuneAdapter` - Abstract base class for location adapters
- `Position` - Location data structure
- `LocationAccuracy` - Accuracy level enum
- `PermissionStatus` - Permission state enum

## For End Users

Use concrete implementations like:
- `MobileLocationMasamuneAdapter` (from `masamune_location`)
- `GoogleMobileLocationMasamuneAdapter` (from `masamune_location_google`)
- `BackgroundLocationMasamuneAdapter` (from `masamune_location_background`)

See the respective package documentation for usage examples.

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)