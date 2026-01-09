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

The app currently runs fully **on-device** and simulates alarms while the app is active, laying the groundwork for future background notifications.

---

## ✨ Features

### ⏰ Alarm Clock
- **Native Time Picker:** Create alarms using the system time selector.
- **Multiple Alarms:** Add, view, and manage multiple alarms.
- **Active State Toggle:** Enable or disable alarms with instant visual feedback.
- **Foreground Alarm Simulation:** Uses `Timer.periodic` to trigger alarms while the app is active.
- **Swipe-to-Delete:** Remove alarms easily using intuitive gestures.
- **Sorted Scheduling:** Alarms are automatically ordered by time.

---

### ✅ To-Do & Task Manager
- **Quick Task Creation:** Add tasks via a modal bottom sheet.
- **Completion Tracking:** Mark tasks as completed using circular checkboxes.
- **Smart Sorting:** Completed tasks automatically move to the bottom.
- **Visual Feedback:** Completed tasks use strikethrough text and muted colors.
- **Swipe-to-Delete:** Remove tasks with a smooth swipe gesture.

---

## 🧠 Architecture & Design

- **Feature-First Structure:** Clear separation of alarms and tasks.
- **Model-Driven UI:** Dedicated models for alarms and tasks.
- **Reusable Widgets:** Custom tiles for alarms and tasks.
- **Material 3 Design:** Modern UI with clean typography and spacing.
- **Scalable Foundation:** Easy to extend with persistence and notifications.

---

## 🛠️ Tech Stack

- **Framework:** Flutter (Dart)
- **UI System:** Material 3
- **State Management:** StatefulWidgets (local state)
- **Key Widgets & APIs:**
  - `ListView.builder`
  - `Dismissible`
  - `Switch`
  - `Checkbox`
  - `Timer.periodic`
  - `ModalBottomSheet`
  - `showTimePicker`
- **Dependencies:**
  - `intl` – time formatting support

---

## 📂 Project Structure

```

lib/
├── main.dart
├── app.dart
│
├── core/
│   └── theme/
│       └── app_theme.dart
│
├── features/
│   ├── alarm/
│   │   ├── alarm_model.dart
│   │   ├── alarm_page.dart
│   │   └── alarm_tile.dart
│   │
│   └── tasks/
│       ├── task_model.dart
│       ├── task_page.dart
│       └── task_tile.dart

````

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
````

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

* Flutter **stateful UI patterns**
* Handling **user input** (time picker, text fields, switches)
* Efficient list rendering with `ListView.builder`
* Gesture-based interactions (`Dismissible`)
* Clean, readable, and maintainable Flutter code
* Building a real-world app foundation without heavy libraries

---

## 🔮 Planned Enhancements

* [ ] Persistent storage using `shared_preferences` or `Hive`
* [ ] Background alarms with `flutter_local_notifications`
* [ ] Task categories and priorities
* [ ] Alarm labels & repeat options
* [ ] Dark mode customization

---

## 📄 License

This project is licensed under the **MIT License**.
See the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

Created with ❤️ by **Coderooz**
GitHub: [https://github.com/coderooz](https://github.com/coderooz)

---

## 📬 Contact

* **Email:** [coderooz.dev@gmail.com](mailto:coderooz.dev@gmail.com?subject=Note-Alarm%20Flutter%20Project)

