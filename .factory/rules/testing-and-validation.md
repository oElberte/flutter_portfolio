# Testing And Validation Rules

## Required Validators

Before finalizing code changes, run:

```bash
dart format lib test
flutter analyze
flutter test
flutter build web
```

## Test Conventions

- Use `flutter_test` for widget and route behavior.
- Use `bloc_test` for Cubit behavior.
- Use `mocktail` for mocks, especially route/navigation collaborators.
- Add tests for new Quest behavior, zone behavior, and navigation behavior.
- Keep tests focused on user-visible behavior and state transitions.

## Browser Validation

For visual/layout work, Flutter tests are not enough. Also validate in a browser.

Run locally:

```bash
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080
```

Then inspect:

- `/`
- `/quick-scan`
- `/quest/architecture`
- `/quest/performance`
- `/quest/animations`
- `/quest/gav-resorts`
- `/quest/case-study`
- `/projects/gav-resorts`

Common breakpoints:

- `390x844`
- `768x1024`
- `1024x768`
- `1440x1000`

For each relevant route/check:

- Confirm no horizontal overflow.
- Confirm no browser console errors.
- Confirm CTAs navigate correctly.
- Confirm text remains readable.
- Confirm desktop map alignment remains intentional.
- Confirm tablet/mobile layout remains readable.

## Browser Screenshots

Store browser validation screenshots under:

```text
.factory/tests/assets/screenshots/
```

Do not leave generated browser screenshots in the repository root.
