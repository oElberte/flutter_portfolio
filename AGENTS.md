# Factory Droid Context

## Project

This repository is a Flutter Web portfolio called `flutter_engineer_quest`.
It presents an interactive Specialist Flutter Engineer portfolio with:

- Quest Mode: Flame-powered atmospheric background with Flutter widget overlays.
- Quick Scan Mode: recruiter-friendly scrollable portfolio.
- Quest zones: dedicated routes for architecture, performance, AI/motion, project, and case-study content.

## Commands

Use these commands before handing off code changes:

```bash
dart format lib test
flutter analyze
flutter test
flutter build web
```

For local browser validation:

```bash
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080
```

Then test `http://localhost:8080/` and key routes:

- `/`
- `/quick-scan`
- `/quest/architecture`
- `/quest/performance`
- `/quest/animations`
- `/quest/gav-resorts`
- `/quest/case-study`
- `/projects/gav-resorts`

## Architecture

- `lib/main.dart`: app entrypoint and web path URL strategy.
- `lib/src/app.dart`: `MaterialApp.router`, `ResponsiveBreakpoints`, and root `QuestCubit` provider.
- `lib/src/core/routing`: `go_router` route definitions.
- `lib/src/core/theme`: dark neon portfolio theme.
- `lib/src/data`: typed static portfolio content.
- `lib/src/features/quest`: Quest Mode, zones, Flame background, and `QuestCubit`.
- `lib/src/features/home`: Quick Scan and project detail pages.

## Conventions

- Keep production UI responsive with `LayoutBuilder`, `MediaQuery`, and existing breakpoints.
- Keep Flame focused on atmospheric/background effects unless intentionally expanding game mechanics.
- Keep content data typed in `lib/src/data`.
- Use `QuestCubit` for quest-node selection state.
- Use `go_router` for app navigation and deep links.
- Prefer small widgets and existing glass/neon visual language.
- Do not add docs/readmes unless explicitly requested.

## Testing

- Use `flutter_test` for widget and navigation behavior.
- Use `bloc_test` for Cubit behavior.
- Use `mocktail` when mocking route/navigation collaborators.
- Browser-test visual/layout changes at common breakpoints: `390x844`, `768x1024`, `1024x768`, `1440x1000`.
- Store browser validation screenshots under `.factory/tests/assets/screenshots/`.

## Notes

- This repo is git-initialized locally.
- Existing `.factory/tests/assets/screenshots/` contains browser validation screenshots and should be preserved.
