# Contributing to Note Alarm

Thank you for your interest in contributing to **Note Alarm**! 🎉

The following is a set of guidelines for contributing to this project. These are
guidelines, not rules — use your best judgment and feel free to propose changes
to this document in a pull request.

---

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Setup](#development-setup)
- [Project Structure](#project-structure)
- [Coding Conventions](#coding-conventions)
- [Testing](#testing)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)

---

## Code of Conduct

This project and everyone participating in it is governed by the
[Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to
uphold this code. Please report unacceptable behavior to
[contact@coderooz.in](mailto:contact@coderooz.in).

---

## How Can I Contribute?

### Reporting Bugs

Before creating a bug report, please check the existing issues to see if the
problem has already been reported. If it has, add a comment to the existing
issue instead of opening a new one.

When creating a bug report, use the
[bug report template](.github/ISSUE_TEMPLATE/bug_report.md) and include as much
detail as possible:

- Steps to reproduce
- Expected behavior
- Actual behavior
- Screenshots (if applicable)
- Device/emulator and OS version
- Flutter/Dart version (`flutter --version`)

### Suggesting Enhancements

Use the
[feature request template](.github/ISSUE_TEMPLATE/feature_request.md) to suggest
new features or improvements. Clearly describe the problem you are trying to
solve and your proposed solution.

### Pull Requests

1. Fork the repository and create your branch from `main`.
2. Make your changes following the [Coding Conventions](#coding-conventions).
3. Add or update tests for your changes.
4. Run the validation commands (see [Testing](#testing)).
5. Submit a pull request using the
   [pull request template](.github/PULL_REQUEST_TEMPLATE.md).

---

## Development Setup

### Prerequisites

- Flutter SDK (see [README](README.md#prerequisites))
- Android Studio / Xcode for platform builds

### Getting Started

```bash
# Clone the repository
git clone https://github.com/coderooz/Note-Alarm-Flutter-App.git
cd Note-Alarm-Flutter-App

# Install dependencies
flutter pub get

# Run the app
flutter run
```

---

## Project Structure

The project follows a **feature-first** structure:

```
lib/
├── core/          # Theme and notifications
├── features/      # Feature modules (alarm, tasks, about)
├── shared/        # Storage, widgets, and utilities
└── main.dart      # App entry point
```

Keep related code together within its feature folder. Do not add new
dependencies to `pubspec.yaml` without discussing them first.

---

## Coding Conventions

- **Formatting:** 2-space indent, trailing commas, `dart format` output.
- **Analysis:** Keep `flutter analyze` clean (zero issues).
- **Comments:** Only add comments that explain non-obvious intent.
- **Storage:** Use the existing `AlarmStorage` / `TaskStorage` helpers; do not
  bypass them.
- **Notifications:** Route all alarm scheduling/cancelling through
  `NotificationService`.
- **State:** Prefer the existing `AlarmController` (ChangeNotifier) pattern for
  shared state.

---

## Testing

Every change must keep the test suite green:

```bash
# Run the analyzer (must be clean)
flutter analyze

# Run all tests (must pass)
flutter test

# Format code
dart format .
```

Widget tests that exercise screens loading storage must call
`SharedPreferences.setMockInitialValues({})` first.

---

## Commit Guidelines

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
type(scope): description
```

Examples:

- `feat(alarm): add snooze support`
- `fix(notifications): request exact alarm permission`
- `refactor(alarm): extract AlarmController`
- `docs(readme): update project structure`

Common types: `feat`, `fix`, `refactor`, `chore`, `docs`, `test`, `style`,
`perf`.

---

## Pull Request Process

1. Ensure your branch is up to date with `main`.
2. Update the [CHANGELOG.md](CHANGELOG.md) under the `[Unreleased]` section.
3. Verify all validation commands pass.
4. Request a review from the maintainer.
5. Once approved, your changes will be merged.

---

## Attribution

This contribution guide is adapted from best practices used across the
open-source community.

---

## Contact

For questions or support, see [SUPPORT.md](SUPPORT.md).