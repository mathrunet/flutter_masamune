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

Use `CalendarController` to manage state and the `Calendar` widget to render the UI.

```dart
class MyCalendarPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final controller = ref.page.controller(
      CalendarController.query(initialDay: DateTime.now()),
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Calendar")),
      body: Calendar(
        controller: controller,
        headerStyle: const CalendarHeaderStyle(
          showFormatButton: true,  // Show month/week/2-week view toggle
        ),
        calendarStyle: CalendarStyle.monthView(),  // or weekView(), twoWeekView()
      ),
    );
  }
}
```

### Navigate and Select Dates

`CalendarController` provides methods to programmatically control the calendar:

```dart
// Select a specific date
controller.select(DateTime(2025, 1, 15));

// Navigate to next/previous month
controller.next();
controller.prev();

// Focus on a specific date without selecting
controller.focus(DateTime(2025, 2, 1));

// Access current state
final selectedDate = controller.selectedDay;  // Currently selected date
final focusedDate = controller.focusedDay;   // Currently displayed month/week
```

### React to User Actions

Attach listeners to respond when users interact with the calendar:

```dart
controller.addListener(() {
  final selected = controller.selectedDay;
  if (selected != null) {
    print("User selected: $selected");
    // Load events for this date, update UI, etc.
  }
});
```

### Customize Appearance

**Using Delegates**: Customize day cells, markers, or headers:

```dart
Calendar(
  controller: controller,
  builderDelegate: BuilderCalendarDelegate(
    dayBuilder: (context, day, focusedDay) {
      // Custom day cell widget
      return Container(
        decoration: BoxDecoration(
          color: day.weekday == DateTime.saturday ? Colors.blue : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(child: Text('${day.day}')),
      );
    },
  ),
  markerDelegate: MarkerCalendarDelegate(
    markerBuilder: (context, day, events) {
      // Add event markers
      if (events.isNotEmpty) {
        return Positioned(
          bottom: 1,
          child: Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
        );
      }
      return const SizedBox.shrink();
    },
  ),
)
```

**Using Styles**: Customize colors and text styles:

```dart
Calendar(
  controller: controller,
  calendarStyle: CalendarStyle.monthView().copyWith(
    selectedDayColor: Colors.blue,
    todayColor: Colors.orange,
    weekendTextStyle: TextStyle(color: Colors.red),
  ),
)
```

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)