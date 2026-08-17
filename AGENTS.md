# AGENTS.md — Note Alarm (Flutter)

Instructions for AI coding agents working in this repository.

## Project Overview

- **App:** Note Alarm — a Flutter mobile app combining an alarm clock with a
  task manager.
- **Platforms:** Android (primary), iOS, plus desktop/web scaffolding.
- **State:** local-only, persisted via `shared_preferences` (no backend).

## Commands

Run these from the repo root:

| Task | Command |
|------|---------|
| Get dependencies | `flutter pub get` |
| Analyze (must be clean) | `flutter analyze` |
| Format code | `dart format .` |
| Run tests (must pass) | `flutter test` |
| Run app | `flutter run` |

## Conventions

- **Structure:** feature-first — `lib/features/<feature>/` holds models, pages
  and tiles; `lib/core/` holds theme and notifications; `lib/shared/` holds
  storage, widgets and utils.
- **Formatting:** 2-space indent, trailing commas, `dart format` output.
  Never reformat files outside the change you are working on.
- **Testing:** every feature/change must keep `flutter test` green. Widget
  tests that exercise screens that load storage must call
  `SharedPreferences.setMockInitialValues({})` first.
- **Analysis:** keep `flutter analyze` clean (zero issues). Fix issues you
  introduce; do not leave new lints unresolved.
- **Storage:** use the existing `AlarmStorage` / `TaskStorage` helpers in
  `lib/shared/storage/`; do not bypass them.
- **Notifications:** route all alarm scheduling/cancelling through
  `NotificationService` in `lib/core/notifications/`.

## Rules for AI Agents

- Do not modify `pubspec.yaml` dependencies without explicit user approval.
- Do not add code comments unless they explain non-obvious intent.
- Verify with `flutter analyze` and `flutter test` after any code change.
- Keep platform-specific config (Android/iOS) changes minimal and explain
  why they are needed.
