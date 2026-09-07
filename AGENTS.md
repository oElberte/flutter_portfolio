Flutter Web portfolio with Quest Mode and recruiter-friendly Quick Scan. Use Flutter and Dart directly; this repo has no `.fvmrc`.

Keep Flame atmospheric and background-only. Portfolio UI and interactions stay in Flutter widgets. Keep typed content in `lib/src/data`, quest-node selection in `QuestCubit`, and navigation and deep links in `go_router`. Intro, hover and parallax state stay local to Quest Mode. Preserve route paths and existing test keys.

Keep the glass/neon visual language, responsive breakpoints and small widgets. Motion must not block navigation or hide content when reduced motion is enabled. Do not add dependencies, backend services, analytics or network-driven content for the home-map upgrade. Quick Scan and quest zones are outside that upgrade unless fixing a regression. When a local `docs/portfolio-plan.md` is present, preserve its product constraints.

For layout or motion changes, check the affected routes at `390x844`, `768x1024`, `1024x768` and `1440x1000`, including keyboard navigation and reduced motion. Use widget/navigation tests for changed UI behavior and Cubit tests for selection changes; a web build is relevant to web integration changes, not every handoff.

Save new browser evidence outside the repo, under `~/Artifacts/3d_portfolio/`. Preserve existing screenshots, including any historical `.factory/tests/assets/screenshots/` evidence; that directory is not the destination for new captures. Do not add docs or READMEs unless requested.
