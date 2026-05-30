# Flutter Web Portfolio Rules

## Scope

These rules apply to `flutter_engineer_quest`.

## UI and Layout

- Preserve the current dark neon/glass visual language.
- Prefer responsive Flutter widgets over fixed desktop-only layouts.
- Use `LayoutBuilder` and existing breakpoint behavior before introducing new responsive abstractions.
- Desktop Quest Mode may use map-aligned positioning.
- Tablet/mobile Quest Mode must remain readable and must not require precise map interaction.
- Avoid horizontal overflow at all supported breakpoints.

## Flame Usage

- Flame is currently used for animated atmosphere/background effects.
- Do not move core portfolio content into Flame unless explicitly planned.
- Keep labels, cards, CTAs, and route interactions as Flutter widgets for accessibility and testability.

## Routing

- Use `go_router`.
- Keep path URL strategy enabled for direct web routes.
- Preserve these route families:
  - `/`
  - `/quick-scan`
  - `/quest/:nodeId`
  - `/projects/:projectId`

## State Management

- Use `QuestCubit` for Quest Mode selected-node state.
- Use local widget state only for simple ephemeral UI state.
- Do not introduce a new state-management library unless the project architecture changes substantially.

## Content

- Keep portfolio content in typed Dart data under `lib/src/data`.
- Do not hardcode duplicate portfolio copy across widgets when it belongs in content data.
- Keep public portfolio links and public project links in content data.
- Do not include secrets, private URLs, temporary local paths, or environment-specific values.

## Dependencies

- Do not add packages unless the feature clearly needs them.
- Prefer existing packages already present in `pubspec.yaml`.
- After dependency changes, run `flutter pub get`, `flutter analyze`, and `flutter test`.
