# Wow-Factor Quest Experience Spec

Status: Planned

## Goal

Make the first portfolio visit feel like entering a premium interactive Flutter world, not just reading a polished landing page. The next visual upgrade should focus on a cinematic first impression and a deeper 2.5D Quest Mode map.

## Current context

- The app already has Quest Mode, Quick Scan Mode, dedicated quest zones, and launch-readiness metadata.
- Quest Mode uses Flame for animated background atmosphere and Flutter widgets for map cards, content, routing, and interaction.
- Desktop Quest Mode already aligns cards to custom-painted map coordinates.
- Tablet and mobile intentionally prioritize readable stacked/card layouts over precise map alignment.

## Target experience

When a user opens `/`, they should feel a short “game start” moment:

1. Background particles and glow are visible immediately.
2. The title/hero panel fades/slides in.
3. The quest path draws across the map.
4. Quest nodes unlock with staggered animation.
5. The active node gets a stronger aura/pulse.
6. Hovering/selecting nodes adds depth, glow, and motion feedback.

## Scope

### Cinematic Quest Intro

- Add a lightweight first-load intro state for Quest Mode.
- Animate the hero panel, path, and node cards in a deliberate sequence.
- Keep the intro short enough to avoid blocking recruiters.
- Provide a reduced-motion path that skips or simplifies animation.

### 2.5D Quest Map

- Add depth layers to the map:
  - slow-moving starfield/background layer
  - mid-layer path glow
  - foreground node cards
- Add pointer-based parallax on desktop.
- Add subtle tilt/elevation to node cards on hover/focus.
- Animate the active path glow toward the selected node.
- Strengthen selected-node aura and ring animation.

### Interaction polish

- Preserve current select-first behavior:
  - click node
  - update selected-node panel
  - use `Enter zone` to navigate
- Keep keyboard/focus behavior usable.
- Avoid visual effects that make text harder to read.

## Out of scope

- Full 3D engine migration.
- Replacing Flutter widgets with Flame-rendered UI.
- Deployment setup.
- Project screenshots/media.
- Major content rewrites.
- New backend or analytics.

## UX requirements

- Desktop should feel layered and reactive.
- Tablet/mobile should remain readable and not depend on hover.
- No horizontal overflow at supported breakpoints.
- Intro should not feel slow; target total reveal under ~2 seconds.
- Motion should be decorative, not required for navigation.

## Accessibility requirements

- Respect `MediaQuery.disableAnimations` where possible.
- Keep all interactive cards as Flutter semantic widgets.
- Keep existing route navigation and testable keys.
- Avoid relying on color alone for selected state.

## Technical approach

- Keep Flame focused on background/atmosphere.
- Keep path, cards, and interaction in Flutter.
- Use local state in `QuestPage` for intro/parallax only.
- Use existing `QuestCubit` for selected-node state.
- Use existing `flutter_animate` and Flutter animation primitives before adding dependencies.

## Acceptance criteria

- Opening `/` shows a more cinematic sequence without delaying usability.
- Desktop map has visible depth, stronger active path glow, and better selected-node emphasis.
- Hover/focus feedback makes node cards feel tactile.
- Mobile and tablet layouts remain readable.
- Existing navigation behavior still works.
- Tests cover core behavior and reduced-motion-safe rendering where practical.
- Browser validation screenshots exist for relevant breakpoints.

## Validation

Run:

```bash
dart format lib test
flutter analyze
flutter test
flutter build web
```

Browser-check:

- `/` at `1440x1000`, `1024x768`, `768x1024`, `390x844`
- Select several nodes.
- Enter at least one quest zone.
- Confirm no console errors or horizontal overflow.
