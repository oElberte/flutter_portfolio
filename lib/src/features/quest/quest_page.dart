import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../data/portfolio_content.dart';
import '../../data/portfolio_models.dart';
import 'quest_cubit.dart';
import 'quest_world_game.dart';

class QuestPage extends StatefulWidget {
  const QuestPage({super.key});

  @override
  State<QuestPage> createState() => _QuestPageState();
}

class _QuestPageState extends State<QuestPage> {
  late final QuestWorldGame _game = QuestWorldGame();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: GameWidget(game: _game)),
          const Positioned.fill(child: _QuestVignette()),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _QuestHeader(),
                  SizedBox(height: 42),
                  _QuestContent(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestVignette extends StatelessWidget {
  const _QuestVignette();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.voidBlack.withValues(alpha: 0.28),
            Colors.transparent,
            AppColors.voidBlack.withValues(alpha: 0.82),
          ],
        ),
      ),
    );
  }
}

class _QuestHeader extends StatelessWidget {
  const _QuestHeader();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _GlassPanel(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.auto_awesome, color: AppColors.neonCyan),
              const SizedBox(width: 10),
              Text(
                'Flutter Engineer Quest',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
        OutlinedButton(
          key: const ValueKey('quick-scan-button'),
          onPressed: () => context.go('/quick-scan'),
          child: const Text('Quick Scan'),
        ),
        FilledButton(
          onPressed: () => context.go('/quick-scan'),
          child: const Text('View Portfolio'),
        ),
      ],
    );
  }
}

class _QuestContent extends StatelessWidget {
  const _QuestContent();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1120) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SizedBox(width: 430, child: _QuestHeroPanel()),
              SizedBox(width: 36),
              Expanded(
                child: Column(
                  children: [
                    _QuestMapOverlay(),
                    SizedBox(height: 18),
                    _ActiveNodePanel(),
                  ],
                ),
              ),
            ],
          );
        }

        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _QuestHeroPanel(),
            SizedBox(height: 28),
            _QuestMapOverlay(),
            SizedBox(height: 18),
            _ActiveNodePanel(),
          ],
        );
      },
    );
  }
}

class _QuestHeroPanel extends StatelessWidget {
  const _QuestHeroPanel();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.sizeOf(context).width;
        final titleSize = screenWidth < 420
            ? 36.0
            : screenWidth < 760
            ? 42.0
            : screenWidth < 1120
            ? 50.0
            : 58.0;

        return _GlassPanel(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                PortfolioContent.title,
                style: TextStyle(
                  color: AppColors.neonCyan,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Build apps like systems.\nPolish them like games.',
                style: Theme.of(
                  context,
                ).textTheme.displayLarge?.copyWith(fontSize: titleSize),
              ),
              const SizedBox(height: 16),
              Text(
                PortfolioContent.valueProposition,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 22),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: const [
                  _SkillBadge(label: 'Flutter Web'),
                  _SkillBadge(label: 'Flame'),
                  _SkillBadge(label: 'Architecture'),
                  _SkillBadge(label: 'Performance'),
                ],
              ),
            ],
          ),
        ).animate().fadeIn(duration: 650.ms).slideY(begin: 0.06);
      },
    );
  }
}

class _QuestMapOverlay extends StatelessWidget {
  const _QuestMapOverlay();

  static const _mapHeight = 560.0;
  static const _mapCardWidth = 250.0;
  static const _mapCardHeight = 154.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 520) {
          return Column(
            children: [
              for (final indexedNode in PortfolioContent.questNodes.indexed)
                Padding(
                  padding: EdgeInsets.only(
                    bottom:
                        indexedNode.$1 == PortfolioContent.questNodes.length - 1
                        ? 0
                        : 14,
                  ),
                  child: _QuestNodeCard(
                    node: indexedNode.$2,
                    index: indexedNode.$1,
                  ),
                ),
            ],
          );
        }

        if (constraints.maxWidth < 760) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = (constraints.maxWidth - 16) / 2;

              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  for (final indexedNode in PortfolioContent.questNodes.indexed)
                    SizedBox(
                      width: cardWidth,
                      child: _QuestNodeCard(
                        node: indexedNode.$2,
                        index: indexedNode.$1,
                      ),
                    ),
                ],
              );
            },
          );
        }

        return SizedBox(
          height: _mapHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _QuestMapPainter(
                    nodes: PortfolioContent.questNodes,
                    activeNodeId: context.select<QuestCubit, String>(
                      (cubit) => cubit.state.activeNodeId,
                    ),
                  ),
                ),
              ),
              for (final indexedNode in PortfolioContent.questNodes.indexed)
                _PositionedQuestNodeCard(
                  node: indexedNode.$2,
                  index: indexedNode.$1,
                  mapWidth: constraints.maxWidth,
                  mapHeight: _mapHeight,
                  cardWidth: _mapCardWidth,
                  cardHeight: _mapCardHeight,
                ),
            ],
          ),
        );
      },
    );
  }
}

class _PositionedQuestNodeCard extends StatelessWidget {
  const _PositionedQuestNodeCard({
    required this.node,
    required this.index,
    required this.mapWidth,
    required this.mapHeight,
    required this.cardWidth,
    required this.cardHeight,
  });

  final QuestNode node;
  final int index;
  final double mapWidth;
  final double mapHeight;
  final double cardWidth;
  final double cardHeight;

  @override
  Widget build(BuildContext context) {
    final left = (node.x * mapWidth - cardWidth / 2).clamp(
      0.0,
      mapWidth - cardWidth,
    );
    final top = (node.y * mapHeight - cardHeight / 2).clamp(
      0.0,
      mapHeight - cardHeight,
    );

    return Positioned(
      left: left,
      top: top,
      width: cardWidth,
      child: _QuestNodeCard(node: node, index: index, compact: true),
    );
  }
}

class _QuestMapPainter extends CustomPainter {
  const _QuestMapPainter({required this.nodes, required this.activeNodeId});

  final List<QuestNode> nodes;
  final String activeNodeId;

  @override
  void paint(Canvas canvas, Size size) {
    if (nodes.length < 2) {
      return;
    }

    final path = Path()
      ..moveTo(nodes.first.x * size.width, nodes.first.y * size.height);

    for (var i = 1; i < nodes.length; i++) {
      final previous = nodes[i - 1];
      final current = nodes[i];
      final control = Offset(
        (previous.x + current.x) * size.width / 2,
        (previous.y + current.y) * size.height / 2 - size.height * 0.08,
      );

      path.quadraticBezierTo(
        control.dx,
        control.dy,
        current.x * size.width,
        current.y * size.height,
      );
    }

    final glowPaint = Paint()
      ..color = AppColors.neonViolet.withValues(alpha: 0.16)
      ..strokeWidth = 18
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final pathPaint = Paint()
      ..color = AppColors.neonBlue.withValues(alpha: 0.36)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas
      ..drawPath(path, glowPaint)
      ..drawPath(path, pathPaint);

    for (final node in nodes) {
      final isActive = node.id == activeNodeId;
      final center = Offset(node.x * size.width, node.y * size.height);
      final color = _nodeColor(node.type);
      final radius = isActive ? 36.0 : 27.0;

      final glow = Paint()
        ..shader = RadialGradient(
          colors: [
            color.withValues(alpha: isActive ? 0.42 : 0.24),
            color.withValues(alpha: 0.08),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(center: center, radius: radius * 2.6));
      final ring = Paint()
        ..color = color.withValues(alpha: isActive ? 0.95 : 0.65)
        ..style = PaintingStyle.stroke
        ..strokeWidth = isActive ? 3.2 : 2.2;
      final core = Paint()
        ..color = color.withValues(alpha: isActive ? 0.48 : 0.28);

      canvas
        ..drawCircle(center, radius * 2.6, glow)
        ..drawCircle(center, radius, ring)
        ..drawCircle(center, 7, core);
    }
  }

  @override
  bool shouldRepaint(covariant _QuestMapPainter oldDelegate) {
    return oldDelegate.nodes != nodes ||
        oldDelegate.activeNodeId != activeNodeId;
  }
}

class _ActiveNodePanel extends StatelessWidget {
  const _ActiveNodePanel();

  @override
  Widget build(BuildContext context) {
    final activeNodeId = context.select<QuestCubit, String>(
      (cubit) => cubit.state.activeNodeId,
    );
    final node = PortfolioContent.questNodes.firstWhere(
      (node) => node.id == activeNodeId,
      orElse: () => PortfolioContent.questNodes.first,
    );

    return _GlassPanel(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Selected quest node',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.neonCyan,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(node.title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          Text(node.description, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [for (final tag in node.tags) _SkillBadge(label: tag)],
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              if (node.type != QuestNodeType.hero)
                FilledButton.icon(
                  key: const ValueKey('enter-zone-button'),
                  onPressed: () => context.go(node.route),
                  icon: const Icon(Icons.login),
                  label: const Text('Enter zone'),
                ),
              OutlinedButton.icon(
                onPressed: () => context.go('/quick-scan'),
                icon: const Icon(Icons.view_list),
                label: const Text('Quick scan'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuestNodeCard extends StatelessWidget {
  const _QuestNodeCard({
    required this.node,
    required this.index,
    this.compact = false,
  });

  final QuestNode node;
  final int index;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final isActive = context.select<QuestCubit, bool>(
      (cubit) => cubit.state.activeNodeId == node.id,
    );

    return InkWell(
          key: ValueKey('quest-node-${node.id}'),
          borderRadius: BorderRadius.circular(22),
          onTap: () {
            context.read<QuestCubit>().selectNode(node.id);
          },
          child: AnimatedContainer(
            duration: 180.ms,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.neonBlue.withValues(alpha: 0.2)
                  : AppColors.glass,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: isActive
                    ? AppColors.neonCyan
                    : AppColors.neonBlue.withValues(alpha: 0.26),
              ),
              boxShadow: [
                BoxShadow(
                  color: _nodeColor(
                    node.type,
                  ).withValues(alpha: isActive ? 0.28 : 0.12),
                  blurRadius: isActive ? 32 : 18,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(_nodeIcon(node.type), color: _nodeColor(node.type)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        node.subtitle,
                        style: const TextStyle(
                          color: AppColors.neonCyan,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(node.title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(
                  node.description,
                  maxLines: compact ? 2 : 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        )
        .animate(delay: (90 * index).ms)
        .fadeIn(duration: 480.ms)
        .scale(begin: const Offset(0.92, 0.92), end: const Offset(1, 1));
  }
}

class _SkillBadge extends StatelessWidget {
  const _SkillBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.neonBlue.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.neonCyan.withValues(alpha: 0.22)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
        child: Text(
          label,
          style: const TextStyle(
            color: AppColors.starWhite,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _GlassPanel extends StatelessWidget {
  const _GlassPanel({required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.glass,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.neonCyan.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonBlue.withValues(alpha: 0.1),
            blurRadius: 32,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

IconData _nodeIcon(QuestNodeType type) {
  return switch (type) {
    QuestNodeType.hero => Icons.explore,
    QuestNodeType.skill => Icons.hub,
    QuestNodeType.project => Icons.token,
    QuestNodeType.caseStudy => Icons.workspace_premium,
    QuestNodeType.contact => Icons.send,
  };
}

Color _nodeColor(QuestNodeType type) {
  return switch (type) {
    QuestNodeType.hero => AppColors.neonCyan,
    QuestNodeType.skill => AppColors.neonBlue,
    QuestNodeType.project => AppColors.neonViolet,
    QuestNodeType.caseStudy => AppColors.plasmaPink,
    QuestNodeType.contact => AppColors.neonCyan,
  };
}
