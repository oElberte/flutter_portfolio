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

    testWidgets('renders interactive architecture layer explorer', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(1200, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(buildSubject('architecture'));
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Interactive layer explorer'), findsOneWidget);
      expect(find.text('Experience layer'), findsOneWidget);
      expect(find.text('State'), findsOneWidget);
      expect(find.text('Domain'), findsOneWidget);
      expect(find.text('Data'), findsOneWidget);
      expect(find.text('Quality'), findsOneWidget);
    });

    testWidgets('selecting an architecture layer updates details', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(1200, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(buildSubject('architecture'));
      await tester.pump(const Duration(seconds: 1));

      await tester.ensureVisible(find.text('Data'));
      await tester.pump();
      await tester.tap(find.text('Data'));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Data layer'), findsOneWidget);
      expect(
        find.text('Repositories, DTOs, cache, API clients, platform bridges.'),
        findsOneWidget,
      );
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

    testWidgets('renders interactive performance metric explorer', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(1200, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(buildSubject('performance'));
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Interactive metric explorer'), findsOneWidget);
      expect(find.text('80% efficiency'), findsOneWidget);
      expect(find.text('45% cost reduction'), findsOneWidget);
      expect(find.text('75% fewer Firebase reads'), findsOneWidget);
      expect(find.text('50% query improvement'), findsOneWidget);
      expect(find.text('Problem'), findsOneWidget);
      expect(find.text('Optimization'), findsOneWidget);
      expect(find.text('Impact'), findsOneWidget);
    });

    testWidgets('selecting a performance metric updates details', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(1200, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(buildSubject('performance'));
      await tester.pump(const Duration(seconds: 1));

      await tester.ensureVisible(find.text('45% cost reduction'));
      await tester.pump();
      await tester.tap(find.text('45% cost reduction'));
      await tester.pump(const Duration(milliseconds: 300));

      expect(
        find.text(
          'Optimized infrastructure, release automation, and data paths to remove waste from production workflows.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders animations zone content', (tester) async {
      await tester.pumpWidget(buildSubject('animations'));
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('AI + Motion Portal Zone'), findsOneWidget);
      expect(
        find.text('AI-enabled product work with polished Flutter experiences.'),
        findsOneWidget,
      );
      expect(find.text('AI flows'), findsOneWidget);
      expect(find.text('Discovery'), findsOneWidget);
      expect(find.text('Motion system'), findsOneWidget);
    });

    testWidgets('renders interactive AI + motion portal', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(buildSubject('animations'));
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Interactive AI + motion portal'), findsOneWidget);
      expect(find.text('LLM chatbot'), findsOneWidget);
      expect(find.text('Agent integrations'), findsWidgets);
      expect(find.text('Commerce AI'), findsOneWidget);
      expect(find.text('Discovery + motion'), findsOneWidget);
      expect(find.text('Intent'), findsOneWidget);
      expect(find.text('Craft'), findsOneWidget);
      expect(find.text('Proof'), findsOneWidget);
    });

    testWidgets('selecting an AI + motion signal updates details', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(1200, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(buildSubject('animations'));
      await tester.pump(const Duration(seconds: 1));

      await tester.ensureVisible(find.text('Commerce AI'));
      await tester.pump();
      await tester.tap(find.text('Commerce AI'));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.textContaining('50% query improvement'), findsOneWidget);
    });

    testWidgets('renders case study zone content', (tester) async {
      await tester.pumpWidget(buildSubject('case-study'));
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Boss Room Zone'), findsOneWidget);
      expect(
        find.text(
          'The boss room: specialist-level reasoning under constraints.',
        ),
        findsOneWidget,
      );
      expect(find.text('Technical judgment'), findsOneWidget);
      expect(find.text('Business impact'), findsOneWidget);
      expect(find.text('Leadership'), findsOneWidget);
    });

    testWidgets('renders interactive Boss Room battle', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(buildSubject('case-study'));
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Interactive boss battle'), findsOneWidget);
      expect(find.text('Architecture gauntlet'), findsOneWidget);
      expect(find.text('Legacy rebuild'), findsOneWidget);
      expect(find.text('Firebase read shield'), findsOneWidget);
      expect(find.text('Commerce AI phase'), findsOneWidget);
      expect(find.text('Leadership phase'), findsOneWidget);
      expect(find.text('Constraint'), findsOneWidget);
      expect(find.text('Countermove'), findsOneWidget);
      expect(find.text('Victory proof'), findsOneWidget);
    });

    testWidgets('selecting a boss challenge updates details', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(buildSubject('case-study'));
      await tester.pump(const Duration(seconds: 1));

      await tester.ensureVisible(find.text('Commerce AI phase'));
      await tester.pump();
      await tester.tap(find.text('Commerce AI phase'));
      await tester.pump(const Duration(milliseconds: 300));

      expect(
        find.textContaining('50% query performance improvement'),
        findsOneWidget,
      );
      expect(find.textContaining('30% storage cost reduction'), findsOneWidget);
      expect(find.textContaining('15%+ sales lift'), findsOneWidget);
      expect(find.textContaining('20% cost reduction'), findsOneWidget);
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
