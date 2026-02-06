# Crossword Multiplayer Game Flutter

This repository contains a Flutter-based, cross-platform (Android, iOS, Web) crossword puzzle game mockup. The UI replicates the reference layout with a crossword-style grid, clue tiles on the top/left edges, player score display, turn indicators, overlay notifications, a letter rack, action buttons, and an ad banner placeholder.

## Features

- Responsive crossword grid with clue tiles and interactive letter cells
- Local multiplayer turn handling with basic AI opponent
- Word validation via an offline dictionary service
- Light/dark theme support, haptic & sound toggles
- Modular MVVM-style architecture with Provider
- Mock data for board, clues, and rack letters

## Project Structure

- `lib/models`: Data models for cells, clues, and players
- `lib/viewmodels`: Game state and turn logic
- `lib/views`: Screen layouts
- `lib/widgets`: Reusable UI components
- `lib/services`: AI, dictionary, and toggle services
- `assets/clues`: Placeholder assets for clue tiles

## Getting Started

Ensure Flutter is installed, then run:

```bash
flutter pub get
flutter run -d chrome
```

## Notes

This project is a UI prototype with mock data meant to be expanded with networking and production gameplay logic.
