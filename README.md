# Note-Alarm ⏰📝

**Note-Alarm** is a clean and modern productivity application built with **Flutter** that combines **alarm scheduling** and **task management** into a single, lightweight mobile app.
The project focuses on **practical Flutter architecture**, **state handling**, and **user-friendly Material 3 UI design**, making it suitable for both learning and real-world usage.

---

## 📱 Application Overview

Note-Alarm helps users:
- Set time-based alarms as reminders
- Manage daily tasks and to-do lists
- Track completion status visually
- Keep everything simple, fast, and offline-friendly

The app runs fully **on-device**: alarms are scheduled with `flutter_local_notifications` (exact alarms, works when the app is closed) and all data is persisted locally with `shared_preferences`.

---

## ✨ Features

### ⏰ Alarm Clock
- **Native Time Picker:** Create alarms using the system time selector.
- **Multiple Alarms:** Add, view, and manage multiple alarms.
- **Active State Toggle:** Enable or disable alarms with instant visual feedback.
- **Exact Notifications:** Alarms fire via `flutter_local_notifications` even when the app is closed.
- **In-App Ringing:** A periodic check triggers the alarm dialog and sound while the app is active.
- **Swipe-to-Edit / Swipe-to-Delete:** Intuitive gestures with confirmation dialogs.
- **Remaining Time:** Each alarm shows how much time is left (days/hours/minutes).

### ✅ To-Do & Task Manager
- **Quick Task Creation:** Add tasks via a modal bottom sheet.
- **Completion Tracking:** Mark tasks as completed using checkboxes.
- **Smart Sorting:** Completed tasks automatically move to the bottom.
- **Visual Feedback:** Completed tasks use strikethrough text.
- **Swipe-to-Delete:** Remove tasks with a smooth swipe gesture and confirmation.

### ℹ️ App Information
- **About:** App overview and version.
- **Privacy Policy:** Local-only data storage statement.
- **Open Source Licenses:** Built-in license viewer.
- **Developer & Contact:** Developer details and contact information.

---

## 🧠 Architecture & Design

- **Feature-First Structure:** Clear separation of alarms and tasks.
- **Model-Driven UI:** Dedicated models for alarms and tasks.
- **Controller Pattern:** `AlarmController` (ChangeNotifier) owns alarm state, persistence, and notification scheduling.
- **Reusable Widgets:** Custom tiles, empty states, buttons, and modals.
- **Material 3 Design:** Modern UI with light and dark themes (follows system setting).

---

## 🛠️ Tech Stack

- **Framework:** Flutter (Dart)
- **UI System:** Material 3
- **State Management:** StatefulWidgets + ChangeNotifier (`AlarmController`)
- **Key Widgets & APIs:**
  - `ListView.builder`
  - `Dismissible`
  - `Switch`
  - `Checkbox`
  - `Timer.periodic`
  - `ModalBottomSheet`
  - `showTimePicker`
- **Dependencies:**
  - `flutter_local_notifications` – exact alarm notifications
  - `flutter_timezone` / `timezone` – correct local-time scheduling
  - `audioplayers` – in-app alarm sound
  - `shared_preferences` – local persistence

---

## 📂 Project Structure

```
lib/
├── main.dart
├── app.dart
│
├── core/
│   ├── notifications/
│   │   └── notification_service.dart
│   └── theme/
│       └── app_theme.dart
│
├── features/
│   ├── about/
│   │   ├── about_page.dart
│   │   ├── privacy_page.dart
│   │   ├── licenses_page.dart
│   │   └── developer_page.dart
│   ├── alarm/
│   │   ├── alarm_model.dart
│   │   ├── alarm_controller.dart
│   │   ├── alarm_page.dart
│   │   └── alarm_tile.dart
│   └── tasks/
│       ├── task_model.dart
│       ├── task_page.dart
│       └── task_tile.dart
│
└── shared/
    ├── storage/
    │   ├── alarm_storage.dart
    │   └── task_storage.dart
    └── widgets/
        ├── app_button.dart
        ├── app_model.dart
        └── empty_state.dart
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK installed
  👉 https://docs.flutter.dev/get-started/install

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/coderooz/Note-Alarm-Flutter-App.git
   cd Note-Alarm-Flutter-App
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

---

## 🧠 What This Project Demonstrates

* Flutter **stateful UI patterns** and ChangeNotifier controllers
* Handling **user input** (time picker, text fields, switches)
* Efficient list rendering with `ListView.builder`
* Gesture-based interactions (`Dismissible`)
* Local persistence with `shared_preferences`
* Exact alarm scheduling with `flutter_local_notifications`
* Clean, readable, and maintainable Flutter code

---

## 🔮 Planned Enhancements

* [ ] Alarm labels & repeat options
* [ ] Snooze logic (reschedule for +5 minutes)
* [ ] Task categories and priorities
* [ ] Manual theme override (light/dark/system toggle)

---

## 📄 License

This project is licensed under the **MIT License**.
See the [LICENSE](LICENSE) file for details.

---

## 🤝 Contributing

Contributions are welcome! Please read:

- [CONTRIBUTING.md](CONTRIBUTING.md) — how to contribute
- [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) — community guidelines
- [SUPPORT.md](SUPPORT.md) — how to get help
- [SECURITY.md](SECURITY.md) — how to report vulnerabilities
- [CHANGELOG.md](CHANGELOG.md) — version history

---

## 👨‍💻 Author

Created with ❤️ by **Coderooz**
GitHub: [https://github.com/coderooz](https://github.com/coderooz)

---

## 📬 Contact

* **Email:** [contact@coderooz.in](mailto:contact@coderooz.in?subject=Note-Alarm%20Flutter%20Project)