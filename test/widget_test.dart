import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_engineer_quest/src/app.dart';

void main() {
  testWidgets('renders the quest portfolio shell', (tester) async {
    await tester.pumpWidget(const FlutterEngineerQuestApp());
    await tester.pump(const Duration(seconds: 2));

    expect(find.text('Flutter Engineer Quest'), findsOneWidget);
    expect(
      find.text('Flutter Specialist | Software Engineer | AI Engineer'),
      findsOneWidget,
    );
    expect(find.text('Quick Scan'), findsOneWidget);
  });

  testWidgets('opens quick scan mode', (tester) async {
    await tester.pumpWidget(const FlutterEngineerQuestApp());
    await tester.pump(const Duration(seconds: 2));

    await tester.tap(find.byKey(const ValueKey('quick-scan-button')));
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));

    expect(find.text('Quick Scan Mode'), findsOneWidget);
    expect(find.text('Interactive Architecture Lab'), findsOneWidget);
  });

  testWidgets('quest nodes select first and enter dedicated zones', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const FlutterEngineerQuestApp());
    await tester.pump(const Duration(seconds: 2));

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
}
