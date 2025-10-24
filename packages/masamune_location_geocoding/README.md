<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Location Geocoding</h1>
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

# Masamune Location Geocoding

## Overview

`masamune_location_geocoding` provides geocoding and reverse geocoding functionality for Masamune apps via Cloud Functions. Convert between coordinates and addresses.

**Note**: Requires `masamune_location` for core location functionality.

## Usage

### Installation

```bash
flutter pub add masamune_location
flutter pub add masamune_location_geocoding
```

### Register the Adapter

Configure `GeocodingMasamuneAdapter` with a Functions adapter for backend integration.

```dart
// lib/adapter.dart

import 'package:masamune_location_geocoding/masamune_location_geocoding.dart';
import 'package:katana_functions_firebase/katana_functions_firebase.dart';

final functionsAdapter = FirebaseFunctionsAdapter(
  options: DefaultFirebaseOptions.currentPlatform,
  region: FirebaseRegion.asiaNortheast1,
);

/// Masamune adapters used in the application.
final masamuneAdapters = <MasamuneAdapter>[
  const UniversalMasamuneAdapter(),

  GeocodingMasamuneAdapter(
    functionsAdapter: functionsAdapter,
  ),
];
```

### Reverse Geocoding (Coordinates → Address)

Convert latitude/longitude to a human-readable address:

```dart
class GeocodingPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final geocoding = GeocodingMasamuneAdapter.primary;

    return ElevatedButton(
      onPressed: () async {
        try {
          final address = await geocoding.fromLatLng(
            latitude: 35.6812,
            longitude: 139.7671,
          );
          
          print("Address: $address");
          // e.g., "Tokyo Station, Tokyo, Japan"
        } catch (e) {
          print("Geocoding failed: $e");
        }
      },
      child: const Text("Get Address"),
    );
  }
}
```

### Geocoding (Address → Coordinates)

Convert an address to latitude/longitude:

```dart
final coordinates = await geocoding.fromAddress("Tokyo Station, Japan");

print("Lat: ${coordinates.latitude}, Lng: ${coordinates.longitude}");
```

### Backend Implementation

Your Cloud Functions must implement the geocoding actions using an external API (e.g., Google Maps Geocoding API):

```typescript
// Cloud Functions
import * as functions from 'firebase-functions';
import axios from 'axios';

export const geocoding = functions.https.onCall(async (data, context) => {
  const GOOGLE_MAPS_API_KEY = process.env.GOOGLE_MAPS_API_KEY;
  
  if (data.action === "geocoding") {
    const { latitude, longitude, address } = data;
    
    if (latitude && longitude) {
      // Reverse geocoding (coordinates -> address)
      const response = await axios.get(
        `https://maps.googleapis.com/maps/api/geocode/json`,
        {
          params: {
            latlng: `${latitude},${longitude}`,
            key: GOOGLE_MAPS_API_KEY,
          },
        }
      );
      
      return {
        address: response.data.results[0]?.formatted_address,
      };
    }
    
    if (address) {
      // Geocoding (address -> coordinates)
      const response = await axios.get(
        `https://maps.googleapis.com/maps/api/geocode/json`,
        {
          params: {
            address: address,
            key: GOOGLE_MAPS_API_KEY,
          },
        }
      );
      
      const location = response.data.results[0]?.geometry?.location;
      return {
        latitude: location.lat,
        longitude: location.lng,
      };
    }
  }
});
```

### Tips

- Store Google Maps API key securely using environment variables
- Implement rate limiting in your backend to prevent API quota exhaustion
- Cache frequently requested addresses to reduce API calls
- Handle errors gracefully when geocoding fails (e.g., invalid address)

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)