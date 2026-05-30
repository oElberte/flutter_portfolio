# Project Memory

## Overview

`flutter_engineer_quest` is a Flutter Web-only interactive portfolio. The product direction is a premium game-inspired portfolio, not a basic landing page.

The current experience has two modes:

- **Quest Mode**: interactive skill map with selectable nodes and dedicated zones.
- **Quick Scan Mode**: recruiter-friendly scrollable summary.

## Current Stack

- Flutter Web
- `go_router`
- `flutter_bloc` with `QuestCubit`
- `equatable`
- `flame`
- `flutter_animate`
- `responsive_framework`
- `url_launcher`
- `flutter_test`
- `bloc_test`
- `mocktail`

## Current Structure

- `lib/main.dart`: path URL strategy and app bootstrap.
- `lib/src/app.dart`: app root, router, theme, responsive breakpoints, root bloc provider.
- `lib/src/core/routing/app_router.dart`: route table.
- `lib/src/core/theme/app_theme.dart`: dark neon theme.
- `lib/src/data/portfolio_content.dart`: static portfolio content.
- `lib/src/data/portfolio_models.dart`: content models.
- `lib/src/features/quest/quest_page.dart`: Quest Mode map and selected node panel.
- `lib/src/features/quest/quest_zone_page.dart`: dedicated quest zone screens.
- `lib/src/features/quest/quest_world_game.dart`: Flame animated atmospheric background.
- `lib/src/features/quest/quest_cubit.dart`: selected quest node state.
- `lib/src/features/home/quick_scan_page.dart`: Quick Scan Mode.
- `lib/src/features/home/project_detail_page.dart`: project case study page.

## Validation

Run:

```bash
dart format lib test
flutter analyze
flutter test
flutter build web
```

For UI work, also run the app in a browser and validate:

- Desktop: `1440x1000`
- Laptop/tablet landscape: `1024x768`
- Tablet portrait: `768x1024`
- Mobile: `390x844`

Screenshots from browser validation belong in `.factory/tests/assets/screenshots/`.

## Important Project Decisions

- Quest cards select nodes first; they do not immediately navigate.
- The selected-node panel owns the `Enter zone` action.
- Desktop Quest Mode aligns cards with custom-painted map nodes.
- Tablet and mobile prioritize readable card layouts over map alignment.
- Flame currently renders atmosphere only; Flutter widgets own content and layout.

## Differences From Global Defaults

- This is not a mobile app despite using Flutter; treat web responsiveness and browser testing as first-class validation.
- No code generation is currently present.
- No dependency injection framework is currently present.
- No network/data layer is currently present; content is static and typed.
