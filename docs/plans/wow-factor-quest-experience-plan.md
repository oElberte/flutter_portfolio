# Wow-Factor Quest Experience Implementation Plan

Status: Planned

## Objective

Implement the `Wow-Factor Quest Experience` spec by upgrading Quest Mode with a cinematic intro and a 2.5D desktop map while preserving current routing, tests, responsiveness, and accessibility.

## Phase 1 — Test baseline and behavior guardrails

Add or update tests before implementation:

- Confirm Quest Mode still renders the shell and hero message.
- Confirm quest nodes still select first.
- Confirm `Enter zone` still navigates after selection.
- Confirm keyboard traversal can focus quest cards, select a node, and reach/activate `Enter zone`.
- Confirm focused/selected quest cards have a visible cue that does not rely on color alone.
- Confirm Quick Scan CTA still works.
- Add a reduced-motion/test-safe rendering assertion with `MediaQuery.disableAnimations` enabled so intro content is immediately usable and tests do not depend on long fixed pumps.
- Add a lightweight assertion for the new intro/map surface, such as:
  - cinematic layer exists
  - quest map still exposes node cards
  - selected node panel remains visible

Files:

- `test/widget_test.dart`
- `test/features/quest/quest_cubit_test.dart` if state behavior changes

## Phase 2 — Cinematic intro state

Add local Quest Mode intro timing:

- Introduce a local intro animation flag/timeline in `QuestPage`.
- Track a private quest-session visit flag so the intro runs once per app session and does not replay on normal router back/pop returns.
- Consolidate the existing `_QuestHeroPanel` and `_QuestNodeCard` `flutter_animate` chains into the intro timeline instead of stacking duplicate animations.
- Stagger:
  1. hero panel
  2. map path
  3. node cards
  4. active-node panel
- Keep the total reveal under ~2 seconds.
- Use `MediaQuery.disableAnimations` to skip animated delays and render the hero, full path, node cards, and active-node panel immediately.

Files:

- `lib/src/features/quest/quest_page.dart`

Implementation notes:

- Prefer `flutter_animate`, `AnimatedBuilder`, `TweenAnimationBuilder`, and local widget state.
- Avoid `QuestCubit` or app-wide state for intro-only behavior; keep the session flag private to the quest feature.
- Do not block navigation or initial rendering.

## Phase 3 — 2.5D desktop map depth

Enhance the desktop map only where it adds value:

- Add pointer-position tracking for desktop-sized map.
- Convert pointer movement into subtle parallax offsets.
- Apply small transforms to:
  - map glow/path layer
  - node card visual child/halo only, not the card's `InkWell` layout/hit-test bounds
  - selected-node aura
- Keep tablet/mobile layouts mostly unchanged.

Files:

- `lib/src/features/quest/quest_page.dart`

Implementation notes:

- Use a `MouseRegion` around the map on desktop.
- Clamp movement so cards remain readable and aligned.
- Keep tap/focus bounds stable; apply parallax to decorative layers or bounded visual children rather than moving interactive hit targets.
- Avoid perspective distortion that causes clipping.

## Phase 4 — Animated active path and selected aura

Upgrade `_QuestMapPainter`:

- Add animation progress input for path reveal.
- Add active-node pulse input for selected aura.
- Wrap the animated `CustomPaint` map layer in a `RepaintBoundary`.
- Draw:
  - base path
  - reveal path
  - active route glow toward selected node
  - stronger selected node ring/core

Files:

- `lib/src/features/quest/quest_page.dart`

Implementation notes:

- Keep painter deterministic and small.
- Drive repaints with `AnimatedBuilder`/`Listenable` input or equivalent, and include progress, pulse, and active-node changes in repaint decisions.
- Keep painter repaints scoped to the map layer so node-card widgets are not repainted every frame.
- Avoid expensive per-frame allocations where practical.

## Phase 5 — Node card tactile feedback

Enhance `_QuestNodeCard`:

- Add desktop hover/focus visual feedback.
- Slight scale/elevation/glow change on hover.
- Keep keyboard activation semantics intact and expose focus feedback through the existing `InkWell`/focusable card.
- Preserve existing `ValueKey('quest-node-{id}')` test hooks.
- Preserve readable text and selected state.

Files:

- `lib/src/features/quest/quest_page.dart`

## Phase 6 — Browser validation

Run release-mode browser validation:

```bash
flutter run -d web-server --release --web-hostname 0.0.0.0 --web-port 8080
```

Validate:

- `/` at `1440x1000`
- `/` at `1024x768`
- `/` at `768x1024`
- `/` at `390x844`

Check:

- no horizontal overflow
- no console errors
- intro does not leave blank/blocked screen
- cards remain readable
- selected-node panel remains usable
- `Enter zone` still navigates
- keyboard tab order reaches quest cards and `Enter zone`; Enter/Space selection works; focus/selected state has a non-color visual cue

Save screenshots under:

```text
docs/screenshots/
```

## Phase 7 — Final validators

Run:

```bash
dart format lib test
flutter analyze
flutter test
flutter build web
```

## Risks

- Too much motion can make the site feel slower or distracting.
- Pointer parallax can break map alignment if offsets are too large.
- Flutter Web release/debug behavior can differ for first-load timing.
- Mobile should not inherit hover-only interactions.
- Custom painter animation can add repaint cost if not scoped.

## Success criteria

- First view feels more premium and game-like.
- Desktop Quest Mode has noticeable depth and motion.
- Mobile remains clean and readable.
- Existing tests and validators pass.
- Browser validation confirms no overflow or console errors.
