# Portfolio Browser Validation Skill

Use this project-specific workflow when changing layout, routing, Quest Mode, Quick Scan Mode, project pages, or visual behavior.

## Steps

1. Start or restart the local Flutter web server:

   ```bash
   flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080
   ```

2. Open `http://localhost:8080/`.

3. Validate the changed route(s) at relevant breakpoints:

   - `390x844`
   - `768x1024`
   - `1024x768`
   - `1440x1000`

4. Check:

   - No horizontal overflow.
   - No browser console errors.
   - Main CTAs are visible and usable.
   - Quest cards select first, then `Enter zone` navigates.
   - Zone pages have readable title, proof meter, and cards.
   - Mobile remains stacked/readable.
   - Desktop Quest Mode map/card alignment remains intentional.

5. Save screenshots under:

   ```text
   .factory/tests/assets/screenshots/
   ```

6. Run final validators:

   ```bash
   dart format lib test
   flutter analyze
   flutter test
   flutter build web
   ```

## Notes

- Do not rely only on Flutter widget tests for visual changes.
- Keep the browser server running when the user wants to inspect manually.
