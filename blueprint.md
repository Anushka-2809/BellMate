# Periodic Bell App

## Overview

This is a Flutter application designed to act as a periodic bell for schools or other institutions. It allows users to set up a timetable with specific periods, and the app will ring a bell (or play a sound) at the start and end of each period. The app is designed to work completely offline, storing all data locally on the device.

## Style and Design

*   **Theme:** Material 3 with a primary color seed of `Colors.teal`.
*   **Fonts:** `google_fonts` package is used for typography (`Oswald` for display/headlines, `Roboto` for titles, `Open Sans` for body text).
*   **Theming:** Separate light and dark themes are implemented using the `provider` package for state management.
*   **Layout:** The app uses a `BottomNavigationBar` for main navigation between the Timetable, Notes, and Profile sections.

## Features Implemented (Scaffolding)

*   **Project Structure:** A well-organized file structure with separation for screens, providers, and main application logic.
*   **Theme Management:** A `ThemeProvider` is implemented to allow users to toggle between light, dark, and system theme modes.
*   **Local Storage Setup:** The `shared_preferences` package has been added to the project for local data persistence.
*   **Main Application Screens:**
    *   `HomeScreen`: The main container with a `BottomNavigationBar`.
    *   `TimetableScreen`: A placeholder screen for the main timetable functionality.
    *   `NotesScreen`: A placeholder screen for taking notes.
    *   `ProfileScreen`: A placeholder screen for user profile and app settings.

## Current Plan: Implement Core Functionality

1.  **Local Data Persistence (Timetable):**
    *   Create a data model for a "Period" (e.g., start time, end time, name).
    *   Implement a service or provider to handle CRUD (Create, Read, Update, Delete) operations for the timetable.
    *   Use `shared_preferences` to save and retrieve the timetable data as a JSON string.
2.  **Timetable UI:**
    *   Design and implement the UI on `TimetableScreen` for displaying the list of periods.
    *   Create a form (e.g., in a dialog or a new screen) to allow users to add and edit periods.
3.  **Bell/Notification Logic:**
    *   Implement a background service or a notification system (e.g., using `flutter_local_notifications`).
    *   Schedule notifications to trigger at the start and end times of each period defined in the timetable.
    *   Allow users to choose a custom sound for the bell.
4.  **Notes Feature:**
    *   Implement a simple note-taking interface on the `NotesScreen`.
    *   Save notes to `shared_preferences`.
5.  **Profile/Settings Feature:**
    *   Implement the theme toggling functionality on the `ProfileScreen`.
    *   Add any other app-level settings (e.g., enabling/disabling the bell).
