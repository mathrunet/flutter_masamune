<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Calendar</h1>
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

# Masamune Calendar

## Usage

### Installation

Add the package to your project.

```bash
flutter pub add masamune_calendar
```

Run `flutter pub get` if you edit `pubspec.yaml` manually.

### Register the Adapter

Configure calendar defaults such as the starting weekday and weekend days.

```dart
// lib/adapter.dart

/// Masamune adapters used by the application.
final masamuneAdapters = <MasamuneAdapter>[
  const UniversalMasamuneAdapter(),

  const CalendarMasamuneAdapter(
    startingDayOfWeek: DayOfWeek.monday,
    weekendDays: [DayOfWeek.saturday, DayOfWeek.sunday],
  ),
];
```

The adapter registers itself via `MasamuneAdapterScope`, making it accessible through `CalendarMasamuneAdapter.primary`.

### Build a Calendar

Use `CalendarController` to manage state and `Calendar` widget (from this package) to render the UI.

```dart
final controller = ref.page.controller(
  CalendarController.query(initialDay: DateTime.now()),
);

return Calendar(
  controller: controller,
  headerStyle: const CalendarHeaderStyle(showFormatButton: true),
  calendarStyle: CalendarStyle.weekView(),
);
```

### Listen to User Interaction

`CalendarController` exposes methods to navigate and select dates. Attach listeners to react to user actions.

```dart
controller.select(DateTime(2025, 1, 15));
controller.next();
controller.prev();
```

You can also override delegates (`BuilderCalendarDelegate`, `MarkerCalendarDelegate`) to customize day cells, markers, or headers.

### Save and Restore State

- `controller.focusedDay` and `controller.selectedDay` keep track of the current view and selection.
- Use `CalendarMasamuneAdapter` to change global defaults without touching individual widgets.
- Store selections in your own state management layer (e.g., Riverpod) if you need cross-page persistence.

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)