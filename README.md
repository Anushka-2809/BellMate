BellMate: Periodic Bell and Timetable Reminder App
Overview

BellMate is a cross-platform mobile and web application built with Flutter. It helps users manage schedules efficiently with timetables, notes, and automatic bell reminders. The app supports local data storage for offline access and ensures users never miss important events or classes.

Key Features
For Users:

User Authentication: Secure login & signup system.

Timetable Management: Create, view, and manage daily/weekly schedules.

Bell Reminder: Automated bell sound triggers at scheduled times.

Notes Interface: Add, edit, and delete notes linked with events/tasks.

Local Storage: Persistent offline storage using Flutter’s shared preferences/local DB.

Cross-Platform Support: Works seamlessly on Android, iOS, Web, Linux, macOS, and Windows.

Tech Stack
Core Framework:

Flutter (Dart) → UI and business logic

Native & Build Tools:

C++ & C → Flutter engine bindings

Swift → iOS integration

CMake → Build system for native compilation

Nix → Environment & package management

Storage:

Local Storage / Shared Preferences (current)

Option to extend with Firebase / MongoDB for cloud sync

Project Structure

lib/ → Flutter application source code

web/ → Web app build files

macos/, linux/, windows/ → Platform-specific integration

test/ → Unit and widget tests

assets/ → Bell audio files & other static resources

pubspec.yaml → Dependencies and project configuration

Getting Started
Prerequisites

Flutter SDK installed

Android Studio / VS Code (with Flutter extension)

Emulator or physical device

Installation

Clone the repository:

git clone https://github.com/Anushka-2809/myapp


Install dependencies:

flutter pub get


Run the app:

flutter run

Configuration

Place your bell.mp3 inside the assets/ folder.

Add the file path under pubspec.yaml:

assets:
  - assets/bell.mp3


Timetable and notes are stored locally (offline-first).

What BellMate Does

Rings a bell automatically at scheduled times.

Lets users add, edit, and delete timetables.

Provides a notes system for tasks/events.

Saves all data locally for offline access.

Runs on multiple platforms with a single codebase.

Contributing

Contributions are welcome! Fork the repo, create a new branch, and submit a pull request.

About

BellMate is a Flutter-based productivity app designed to simplify schedule management and reminders. With cross-platform support and offline-first storage, it is lightweight, reliable, and user-friendly.
