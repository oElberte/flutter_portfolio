import 'package:flutter/material.dart';
import 'package:flutter_engineer_quest/src/features/quest/quest_zone_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class _MockGoRouter extends Mock implements GoRouter {}

void main() {
  late _MockGoRouter router;

  setUp(() {
    router = _MockGoRouter();
    when(() => router.go(any())).thenReturn(null);
  });

  Widget buildSubject(String nodeId) {
    return MaterialApp(
      home: InheritedGoRouter(
        goRouter: router,
        child: QuestZonePage(nodeId: nodeId),
      ),
    );
  }

  group(QuestZonePage, () {
    testWidgets('renders architecture zone content', (tester) async {
      await tester.pumpWidget(buildSubject('architecture'));
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Architecture Lab Zone'), findsOneWidget);
      expect(
        find.text(
          'Architecture that keeps teams fast after the first release.',
        ),
        findsOneWidget,
      );
      expect(find.text('State boundaries'), findsOneWidget);
      expect(find.text('Integration seams'), findsOneWidget);
      expect(find.text('Quality gates'), findsOneWidget);
    });

    testWidgets('renders performance zone content', (tester) async {
      await tester.pumpWidget(buildSubject('performance'));
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Performance Forge Zone'), findsOneWidget);
      expect(
        find.text('Performance wins proven by production metrics.'),
        findsOneWidget,
      );
      expect(find.text('Rendering discipline'), findsOneWidget);
    });

    testWidgets('Back to Quest navigates home', (tester) async {
      await tester.pumpWidget(buildSubject('architecture'));
      await tester.pump(const Duration(seconds: 1));

      await tester.tap(find.text('Back to Quest'));

      verify(() => router.go('/')).called(1);
    });

    testWidgets('Quick Scan navigates to quick scan route', (tester) async {
      await tester.pumpWidget(buildSubject('architecture'));
      await tester.pump(const Duration(seconds: 1));

      await tester.tap(find.text('Quick Scan'));

      verify(() => router.go('/quick-scan')).called(1);
    });

    testWidgets('project zone CTA navigates to project case study', (
      tester,
    ) async {
      await tester.pumpWidget(buildSubject('gav-resorts'));
      await tester.pump(const Duration(seconds: 1));

      await tester.ensureVisible(find.text('Open case study'));
      await tester.pump();
      await tester.tap(find.text('Open case study'));

      verify(() => router.go('/projects/gav-resorts')).called(1);
    });
  });
}
