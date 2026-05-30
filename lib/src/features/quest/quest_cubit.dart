import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuestState extends Equatable {
  const QuestState({this.activeNodeId = 'hero'});

  final String activeNodeId;

  QuestState copyWith({String? activeNodeId}) {
    return QuestState(activeNodeId: activeNodeId ?? this.activeNodeId);
  }

  @override
  List<Object?> get props => [activeNodeId];
}

class QuestCubit extends Cubit<QuestState> {
  QuestCubit() : super(const QuestState());

  void selectNode(String nodeId) {
    emit(state.copyWith(activeNodeId: nodeId));
  }
}
