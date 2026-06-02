import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_engineer_quest/src/app.dart';

void main() {
  Future<void> pumpQuestApp(
    WidgetTester tester, {
    Size? surfaceSize,
    bool disableAnimations = false,
    Duration settleDuration = const Duration(seconds: 2),
  }) async {
    if (surfaceSize != null) {
      await tester.binding.setSurfaceSize(surfaceSize);
      addTearDown(() => tester.binding.setSurfaceSize(null));
    }

    if (disableAnimations) {
      final binding = TestWidgetsFlutterBinding.ensureInitialized();
      binding.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(
        binding.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
    }

    await tester.pumpWidget(const FlutterEngineerQuestApp());
    await tester.pump(settleDuration);
  }

  bool primaryFocusIsWithin(Key key) {
    final focusContext = FocusManager.instance.primaryFocus?.context;
    if (focusContext == null) {
      return false;
    }
    if (focusContext.widget.key == key) {
      return true;
    }

    var found = false;
    focusContext.visitAncestorElements((ancestor) {
      if (ancestor.widget.key == key) {
        found = true;
        return false;
      }

      return true;
    });

    return found;
  }

  String primaryFocusChain() {
    final focusContext = FocusManager.instance.primaryFocus?.context;
    if (focusContext == null) {
      return 'none';
    }

    final labels = <String>[
      '${focusContext.widget.runtimeType}:${focusContext.widget.key}',
    ];
    focusContext.visitAncestorElements((ancestor) {
      labels.add('${ancestor.widget.runtimeType}:${ancestor.widget.key}');
      return labels.length < 12;
    });

    return labels.join(' <- ');
  }

  Future<void> tabUntilFocused(WidgetTester tester, Key key) async {
    for (var i = 0; i < 20; i++) {
      if (primaryFocusIsWithin(key)) {
        return;
      }

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
    }

    fail(
      'Could not focus $key with keyboard traversal. ${primaryFocusChain()}',
    );
  }

  testWidgets('renders the quest portfolio shell', (tester) async {
    await pumpQuestApp(tester);

    expect(find.text('Flutter Engineer Quest'), findsOneWidget);
    expect(
      find.text('Flutter Specialist | Software Engineer | AI Engineer'),
      findsOneWidget,
    );
    expect(find.text('Quick Scan'), findsOneWidget);
  });

  testWidgets('opens quick scan mode', (tester) async {
    await pumpQuestApp(tester);

    await tester.tap(find.byKey(const ValueKey('quick-scan-button')));
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));

    expect(find.text('Quick Scan Mode'), findsOneWidget);
    expect(find.text('Interactive Architecture Lab'), findsOneWidget);
    expect(find.text('Best fit for teams that need'), findsOneWidget);
    expect(find.text('Copy email'), findsWidgets);
  });

  testWidgets('quest nodes select first and enter dedicated zones', (
    tester,
  ) async {
    await pumpQuestApp(tester, surfaceSize: const Size(1200, 1200));

    await tester.tap(find.byKey(const ValueKey('quest-node-architecture')));
    await tester.pump(const Duration(milliseconds: 400));

    expect(
      find.text('Build apps like systems.\nPolish them like games.'),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('enter-zone-button')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('enter-zone-button')));
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));

    expect(
      find.text('Architecture that keeps teams fast after the first release.'),
      findsOneWidget,
    );
  });

  testWidgets('reduced motion renders the cinematic quest map immediately', (
    tester,
  ) async {
    await pumpQuestApp(
      tester,
      surfaceSize: const Size(1440, 1000),
      disableAnimations: true,
      settleDuration: Duration.zero,
    );

    expect(find.byKey(const ValueKey('quest-cinematic-layer')), findsOneWidget);
    expect(find.byKey(const ValueKey('quest-map-surface')), findsOneWidget);
    expect(find.byKey(const ValueKey('quest-map-path-layer')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('quest-node-architecture')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('quest-node-selected-indicator-hero')),
      findsOneWidget,
    );
    expect(find.text('Selected quest node'), findsOneWidget);
  });

  testWidgets('selected quest cards expose a non-color selected cue', (
    tester,
  ) async {
    await pumpQuestApp(tester, surfaceSize: const Size(1200, 1000));

    await tester.tap(find.byKey(const ValueKey('quest-node-architecture')));
    await tester.pump(const Duration(milliseconds: 300));

    expect(
      find.byKey(const ValueKey('quest-node-selected-indicator-architecture')),
      findsOneWidget,
    );
  });

  testWidgets('keyboard users can select a node and enter its zone', (
    tester,
  ) async {
    await pumpQuestApp(tester, surfaceSize: const Size(1440, 1000));

    await tabUntilFocused(tester, const ValueKey('quest-node-architecture'));
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump(const Duration(milliseconds: 300));

    expect(
      find.byKey(const ValueKey('quest-node-selected-indicator-architecture')),
      findsOneWidget,
    );

    await tabUntilFocused(tester, const ValueKey('enter-zone-button'));
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));

    expect(
      find.text('Architecture that keeps teams fast after the first release.'),
      findsOneWidget,
    );
  });
}
