import 'package:equatable/equatable.dart';

enum QuestNodeType { hero, skill, project, caseStudy, contact }

class QuestNode extends Equatable {
  const QuestNode({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.type,
    required this.route,
    required this.x,
    required this.y,
    required this.tags,
  });

  final String id;
  final String title;
  final String subtitle;
  final String description;
  final QuestNodeType type;
  final String route;
  final double x;
  final double y;
  final List<String> tags;

  @override
  List<Object?> get props => [
    id,
    title,
    subtitle,
    description,
    type,
    route,
    x,
    y,
    tags,
  ];
}

class ProjectSpotlight extends Equatable {
  const ProjectSpotlight({
    required this.id,
    required this.title,
    required this.summary,
    required this.problem,
    required this.solution,
    required this.impact,
    required this.stack,
    this.externalUrl,
  });

  final String id;
  final String title;
  final String summary;
  final String problem;
  final String solution;
  final String impact;
  final List<String> stack;
  final String? externalUrl;

  @override
  List<Object?> get props => [
    id,
    title,
    summary,
    problem,
    solution,
    impact,
    stack,
    externalUrl,
  ];
}

class TimelineMilestone extends Equatable {
  const TimelineMilestone({
    required this.title,
    required this.period,
    required this.description,
  });

  final String title;
  final String period;
  final String description;

  @override
  List<Object?> get props => [title, period, description];
}
