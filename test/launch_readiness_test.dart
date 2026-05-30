import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('launch readiness', () {
    test('index exposes SEO, social, and structured data metadata', () {
      final html = File('web/index.html').readAsStringSync();

      expect(html, contains('<html lang="en">'));
      expect(html, contains('name="viewport"'));
      expect(html, contains('rel="canonical" href="https://elberte.com/"'));
      expect(html, contains('property="og:title"'));
      expect(html, contains('property="og:description"'));
      expect(html, contains('property="og:image"'));
      expect(html, contains('name="twitter:card"'));
      expect(html, contains('name="twitter:title"'));
      expect(html, contains('application/ld+json'));
      expect(File('web/social-card.svg').existsSync(), isTrue);
    });

    test('manifest supports a broad portfolio web app launch', () {
      final manifest =
          jsonDecode(File('web/manifest.json').readAsStringSync())
              as Map<String, dynamic>;

      expect(manifest['id'], '.');
      expect(manifest['scope'], '.');
      expect(manifest['lang'], 'en');
      expect(manifest['orientation'], isNot('portrait-primary'));
      expect(manifest['categories'], containsAll(['business', 'portfolio']));
    });

    test('robots and sitemap expose key public routes', () {
      final robots = File('web/robots.txt').readAsStringSync();
      final sitemap = File('web/sitemap.xml').readAsStringSync();

      expect(robots, contains('Allow: /'));
      expect(robots, contains('Sitemap: https://elberte.com/sitemap.xml'));
      expect(sitemap, contains('https://elberte.com/'));
      expect(sitemap, contains('https://elberte.com/quick-scan'));
      expect(sitemap, contains('https://elberte.com/quest/architecture'));
      expect(sitemap, contains('https://elberte.com/quest/performance'));
      expect(sitemap, contains('https://elberte.com/quest/animations'));
      expect(sitemap, contains('https://elberte.com/quest/case-study'));
      expect(sitemap, contains('https://elberte.com/projects/gav-resorts'));
    });
  });
}
