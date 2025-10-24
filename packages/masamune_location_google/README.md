<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Location Google</h1>
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

# Masamune Location Google

## Overview

`masamune_location_google` provides Google Maps integration for Masamune apps. Display maps, add markers, and use Google-specific location features.

**Note**: Requires `masamune_location` for core location functionality.

## Usage

### Installation

```bash
flutter pub add masamune_location
flutter pub add masamune_location_google
```

### Register the Adapter

Configure `GoogleMobileLocationMasamuneAdapter` for Google Maps functionality.

```dart
// lib/adapter.dart

import 'package:masamune_location_google/masamune_location_google.dart';

/// Masamune adapters used in the application.
final masamuneAdapters = <MasamuneAdapter>[
  const UniversalMasamuneAdapter(),

  GoogleMobileLocationMasamuneAdapter(
    apiKey: "YOUR_GOOGLE_MAPS_API_KEY",  // Google Maps API key
    requestWhenInUsePermissionOnInit: true,
    locationAccuracy: LocationAccuracy.high,
  ),
];
```

### Display Google Map

Use the `MapView` widget to display a Google Map:

```dart
class MapPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final mapController = ref.page.controller(MapController.query());

    return Scaffold(
      appBar: AppBar(title: const Text("Map")),
      body: MapView(
        controller: mapController,
        initialCameraPosition: CameraPosition(
          target: LatLng(35.6812, 139.7671),  // Tokyo Station
          zoom: 15,
        ),
        onMapCreated: (controller) {
          print("Map created!");
        },
      ),
    );
  }
}
```

### Add Markers

Add markers to the map:

```dart
// Add a marker
mapController.addMarker(
  Marker(
    markerId: MarkerId("tokyo-station"),
    position: LatLng(35.6812, 139.7671),
    title: "Tokyo Station",
    snippet: "Major railway station",
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
  ),
);

// Remove a marker
mapController.removeMarker(MarkerId("tokyo-station"));

// Clear all markers
mapController.clearMarkers();
```

### Camera Control

Move the camera programmatically:

```dart
// Animate to location
await mapController.animateCamera(
  CameraPosition(
    target: LatLng(35.6812, 139.7671),
    zoom: 17,
    tilt: 45,
    bearing: 90,
  ),
);

// Move immediately
await mapController.moveCamera(
  CameraPosition(
    target: LatLng(35.6812, 139.7671),
    zoom: 15,
  ),
);
```

### Add Shapes

Add circles, polygons, and polylines:

```dart
// Add circle
mapController.addCircle(
  Circle(
    circleId: CircleId("area"),
    center: LatLng(35.6812, 139.7671),
    radius: 500,  // meters
    fillColor: Colors.blue.withOpacity(0.3),
    strokeColor: Colors.blue,
    strokeWidth: 2,
  ),
);

// Add polygon
mapController.addPolygon(
  Polygon(
    polygonId: PolygonId("zone"),
    points: [
      LatLng(35.68, 139.76),
      LatLng(35.69, 139.77),
      LatLng(35.68, 139.78),
    ],
    fillColor: Colors.green.withOpacity(0.3),
  ),
);

// Add polyline (route)
mapController.addPolyline(
  Polyline(
    polylineId: PolylineId("route"),
    points: [
      LatLng(35.6812, 139.7671),
      LatLng(35.6897, 139.6917),
    ],
    color: Colors.red,
    width: 5,
  ),
);
```

### Map Styling

Apply custom map styles:

```dart
mapController.setMapStyle(
  MapStyle.dark,  // or MapStyle.light, MapStyle.custom(jsonString)
);
```

### Tips

- Obtain a Google Maps API key from [Google Cloud Console](https://console.cloud.google.com/)
- Enable Google Maps SDK for iOS/Android in your Google Cloud project
- Configure API key restrictions to prevent unauthorized usage
- Test on real devices for accurate GPS behavior

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)