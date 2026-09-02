# flutter_engineer_quest

Flutter Web portfolio for elberte.com, with a Quest Mode skill map and a Quick Scan mode. Content is static and typed in `lib/src/data`. No backend, no DI, no codegen.

```
flutter pub get
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080
dart format lib test && flutter analyze && flutter test && flutter build web
```

Things worth knowing:

- Widget tests find things by `ValueKey` (`quick-scan-button`, `quest-node-*`, `enter-zone-button`). Keep those keys when you move widgets.
- Quest cards select a node and don't navigate. The selected-node panel owns "Enter zone". That's on purpose.
- Flame only draws the animated background. Text, cards and CTAs stay Flutter widgets so they're testable and accessible.
- `test/launch_readiness_test.dart` asserts the exact SEO, manifest and sitemap strings in `web/`. New public routes go in `web/sitemap.xml` too.
- For layout changes, look at it in a browser at 390x844, 768x1024, 1024x768 and 1440x1000 and save screenshots to `.factory/tests/assets/screenshots/`.
