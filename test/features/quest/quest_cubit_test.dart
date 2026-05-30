import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_engineer_quest/src/features/quest/quest_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(QuestCubit, () {
    test('starts with hero selected', () {
      expect(QuestCubit().state, const QuestState());
    });

    blocTest<QuestCubit, QuestState>(
      'selects a quest node',
      build: QuestCubit.new,
      act: (cubit) => cubit.selectNode('architecture'),
      expect: () => const [QuestState(activeNodeId: 'architecture')],
    );

    blocTest<QuestCubit, QuestState>(
      'emits each selected node in order',
      build: QuestCubit.new,
      act: (cubit) {
        cubit
          ..selectNode('performance')
          ..selectNode('case-study');
      },
      expect: () => const [
        QuestState(activeNodeId: 'performance'),
        QuestState(activeNodeId: 'case-study'),
      ],
    );
  });
}
