# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- App Information pages: About, Privacy Policy, Open Source Licenses, Developer & Contact.
- About action on the home app bar.
- Dark theme support (follows the system theme setting).
- Regression tests for alarm/task models, storage, and the alarm controller.

### Changed
- Refactored alarm state into a dedicated `AlarmController` (ChangeNotifier).
- Replaced inline empty-state text with a reusable `EmptyState` widget.
- Refreshed README with current features, structure, and dependencies.

## [1.0.0] - 2026-08-17

### Added
- Alarm scheduling with exact notifications (`flutter_local_notifications`).
- Local timezone resolution for correct alarm times (`flutter_timezone` + `timezone`).
- Runtime permission requests for notifications (Android 13+) and exact alarms (Android 12+).
- In-app alarm ringing with sound and a dismiss/snooze dialog.
- Task manager with completion tracking and smart sorting.
- Local persistence via `shared_preferences`.
- Release signing scaffold (`android/key.properties.example`).
- Package renamed to `in.coderooz.notealarm`.

### Changed
- iOS notification delegate configured for foreground notifications.
- Android manifest: app label "Note Alarm" and `USE_FULL_SCREEN_INTENT` permission.
- Task storage now awaits persistence before returning.
- Null-safe JSON parsing in alarm and task models.
- Delete actions now require confirmation.
- Removed unused dependencies (`flutter_background_service`, `intl`, `cupertino_icons`).