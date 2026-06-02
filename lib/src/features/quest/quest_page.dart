import 'dart:math' as math;

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

bool _questIntroPlayedInCurrentSession = false;

class QuestPage extends StatefulWidget {
  const QuestPage({super.key});

  @override
  State<QuestPage> createState() => _QuestPageState();
}

class _QuestPageState extends State<QuestPage> with TickerProviderStateMixin {
  late final QuestWorldGame _game = QuestWorldGame();
  late final AnimationController _introController;
  late final AnimationController _pulseController;
  late final bool _shouldPlayIntro;
  var _introConfigured = false;
  var _animationsDisabled = false;
  var _parallaxOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _shouldPlayIntro = !_questIntroPlayedInCurrentSession;
    _questIntroPlayedInCurrentSession = true;
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1700),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final disableAnimations = MediaQuery.disableAnimationsOf(context);

    if (!_introConfigured) {
      if (disableAnimations || !_shouldPlayIntro) {
        _introController.value = 1;
      } else {
        _introController.forward();
      }
      _introConfigured = true;
    }

    if (disableAnimations != _animationsDisabled) {
      _animationsDisabled = disableAnimations;
      if (disableAnimations) {
        _introController.value = 1;
        _pulseController
          ..stop()
          ..value = 0;
      } else if (!_pulseController.isAnimating) {
        _pulseController.repeat();
      }
    } else if (!disableAnimations && !_pulseController.isAnimating) {
      _pulseController.repeat();
    }
  }

  @override
  void dispose() {
    _introController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _updateParallaxOffset(Offset offset) {
    if (_parallaxOffset == offset) {
      return;
    }

    setState(() {
      _parallaxOffset = offset;
    });
  }

  @override
  Widget build(BuildContext context) {
    final disableAnimations = MediaQuery.disableAnimationsOf(context);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: ExcludeFocus(
              child: GameWidget(game: _game, autofocus: false),
            ),
          ),
          Positioned.fill(
            child: _QuestCinematicLayer(
              introProgress: _introController,
              disableAnimations: disableAnimations,
            ),
          ),
          const Positioned.fill(child: _QuestVignette()),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _QuestHeader(),
                  const SizedBox(height: 42),
                  _QuestContent(
                    introProgress: _introController,
                    pulseProgress: _pulseController,
                    disableAnimations: disableAnimations,
                    parallaxOffset: _parallaxOffset,
                    onParallaxChanged: _updateParallaxOffset,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestCinematicLayer extends StatelessWidget {
  const _QuestCinematicLayer({
    required this.introProgress,
    required this.disableAnimations,
  });

  final Animation<double> introProgress;
  final bool disableAnimations;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      key: const ValueKey('quest-cinematic-layer'),
      child: AnimatedBuilder(
        animation: introProgress,
        builder: (context, child) {
          final progress = disableAnimations ? 1.0 : introProgress.value;
          final flareOpacity = 0.16 + progress * 0.14;

          return Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _QuestCinematicPainter(progress: progress),
                ),
              ),
              Positioned(
                top: -120 + progress * 20,
                right: -80,
                width: 420,
                height: 420,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.neonBlue.withValues(alpha: flareOpacity),
                        AppColors.neonViolet.withValues(alpha: 0.08),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: -110,
                bottom: -150 + progress * 28,
                width: 520,
                height: 520,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.plasmaPink.withValues(alpha: 0.10),
                        AppColors.neonCyan.withValues(alpha: 0.05),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _QuestCinematicPainter extends CustomPainter {
  const _QuestCinematicPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final horizonPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.neonBlue.withValues(alpha: 0.08),
          Colors.transparent,
          AppColors.neonViolet.withValues(alpha: 0.10),
        ],
      ).createShader(Offset.zero & size);

    canvas.drawRect(Offset.zero & size, horizonPaint);

    final starPaint = Paint()..style = PaintingStyle.fill;
    for (var i = 0; i < 34; i++) {
      final xFactor = ((i * 37) % 100) / 100;
      final yFactor = ((i * 53) % 100) / 100;
      final drift = (progress - 0.5) * (i.isEven ? 8 : -6);
      final center = Offset(
        xFactor * size.width + drift,
        yFactor * size.height * 0.9,
      );
      final alpha = 0.12 + ((i % 5) * 0.025);
      starPaint.color = AppColors.starWhite.withValues(alpha: alpha);
      canvas.drawCircle(center, i % 3 == 0 ? 1.8 : 1.1, starPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _QuestCinematicPainter oldDelegate) {
    return oldDelegate.progress != progress;
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
  const _QuestContent({
    required this.introProgress,
    required this.pulseProgress,
    required this.disableAnimations,
    required this.parallaxOffset,
    required this.onParallaxChanged,
  });

  final Animation<double> introProgress;
  final Animation<double> pulseProgress;
  final bool disableAnimations;
  final Offset parallaxOffset;
  final ValueChanged<Offset> onParallaxChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1120) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 430,
                child: _QuestHeroPanel(
                  introProgress: introProgress,
                  disableAnimations: disableAnimations,
                ),
              ),
              const SizedBox(width: 36),
              Expanded(
                child: Column(
                  children: [
                    _QuestMapOverlay(
                      introProgress: introProgress,
                      pulseProgress: pulseProgress,
                      disableAnimations: disableAnimations,
                      parallaxOffset: parallaxOffset,
                      onParallaxChanged: onParallaxChanged,
                    ),
                    const SizedBox(height: 18),
                    _ActiveNodePanel(
                      introProgress: introProgress,
                      disableAnimations: disableAnimations,
                    ),
                  ],
                ),
              ),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _QuestHeroPanel(
              introProgress: introProgress,
              disableAnimations: disableAnimations,
            ),
            const SizedBox(height: 28),
            _QuestMapOverlay(
              introProgress: introProgress,
              pulseProgress: pulseProgress,
              disableAnimations: disableAnimations,
              parallaxOffset: parallaxOffset,
              onParallaxChanged: onParallaxChanged,
            ),
            const SizedBox(height: 18),
            _ActiveNodePanel(
              introProgress: introProgress,
              disableAnimations: disableAnimations,
            ),
          ],
        );
      },
    );
  }
}

class _QuestHeroPanel extends StatelessWidget {
  const _QuestHeroPanel({
    required this.introProgress,
    required this.disableAnimations,
  });

  final Animation<double> introProgress;
  final bool disableAnimations;

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

        return _QuestIntroReveal(
          progress: introProgress,
          disableAnimations: disableAnimations,
          start: 0.04,
          end: 0.34,
          slideOffset: const Offset(0, 22),
          child: _GlassPanel(
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
          ),
        );
      },
    );
  }
}

class _QuestMapOverlay extends StatelessWidget {
  const _QuestMapOverlay({
    required this.introProgress,
    required this.pulseProgress,
    required this.disableAnimations,
    required this.parallaxOffset,
    required this.onParallaxChanged,
  });

  final Animation<double> introProgress;
  final Animation<double> pulseProgress;
  final bool disableAnimations;
  final Offset parallaxOffset;
  final ValueChanged<Offset> onParallaxChanged;

  static const _mapHeight = 560.0;
  static const _mapCardWidth = 250.0;
  static const _mapCardHeight = 154.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 520) {
          return Column(
            key: const ValueKey('quest-map-surface'),
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
                    introProgress: introProgress,
                    disableAnimations: disableAnimations,
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
                key: const ValueKey('quest-map-surface'),
                spacing: 16,
                runSpacing: 16,
                children: [
                  for (final indexedNode in PortfolioContent.questNodes.indexed)
                    SizedBox(
                      width: cardWidth,
                      child: _QuestNodeCard(
                        node: indexedNode.$2,
                        index: indexedNode.$1,
                        introProgress: introProgress,
                        disableAnimations: disableAnimations,
                      ),
                    ),
                ],
              );
            },
          );
        }

        final activeNodeId = context.select<QuestCubit, String>(
          (cubit) => cubit.state.activeNodeId,
        );
        final allowParallax =
            MediaQuery.sizeOf(context).width >= 1025 && !disableAnimations;
        final effectiveParallax = allowParallax ? parallaxOffset : Offset.zero;

        return MouseRegion(
          key: const ValueKey('quest-map-surface'),
          onHover: allowParallax
              ? (event) {
                  final center = Offset(
                    constraints.maxWidth / 2,
                    _mapHeight / 2,
                  );
                  final raw = event.localPosition - center;
                  onParallaxChanged(
                    Offset(
                      (raw.dx / center.dx).clamp(-1.0, 1.0),
                      (raw.dy / center.dy).clamp(-1.0, 1.0),
                    ),
                  );
                }
              : null,
          onExit: allowParallax ? (_) => onParallaxChanged(Offset.zero) : null,
          child: SizedBox(
            height: _mapHeight,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: _QuestPathLayer(
                    nodes: PortfolioContent.questNodes,
                    activeNodeId: activeNodeId,
                    introProgress: introProgress,
                    pulseProgress: pulseProgress,
                    disableAnimations: disableAnimations,
                    parallaxOffset: effectiveParallax,
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
                    introProgress: introProgress,
                    disableAnimations: disableAnimations,
                    parallaxOffset: effectiveParallax,
                  ),
              ],
            ),
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
    required this.introProgress,
    required this.disableAnimations,
    required this.parallaxOffset,
  });

  final QuestNode node;
  final int index;
  final double mapWidth;
  final double mapHeight;
  final double cardWidth;
  final double cardHeight;
  final Animation<double> introProgress;
  final bool disableAnimations;
  final Offset parallaxOffset;

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
      child: _QuestNodeCard(
        node: node,
        index: index,
        compact: true,
        introProgress: introProgress,
        disableAnimations: disableAnimations,
        parallaxOffset: Offset(
          parallaxOffset.dx * (2.5 + index * 0.35),
          parallaxOffset.dy * (1.8 + index * 0.25),
        ),
      ),
    );
  }
}

class _QuestPathLayer extends StatefulWidget {
  const _QuestPathLayer({
    required this.nodes,
    required this.activeNodeId,
    required this.introProgress,
    required this.pulseProgress,
    required this.disableAnimations,
    required this.parallaxOffset,
  });

  final List<QuestNode> nodes;
  final String activeNodeId;
  final Animation<double> introProgress;
  final Animation<double> pulseProgress;
  final bool disableAnimations;
  final Offset parallaxOffset;

  @override
  State<_QuestPathLayer> createState() => _QuestPathLayerState();
}

class _QuestPathLayerState extends State<_QuestPathLayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _activeRouteController;

  @override
  void initState() {
    super.initState();
    _activeRouteController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 620),
      value: 1,
    );
  }

  @override
  void didUpdateWidget(covariant _QuestPathLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activeNodeId != widget.activeNodeId) {
      if (widget.disableAnimations) {
        _activeRouteController.value = 1;
      } else {
        _activeRouteController.forward(from: 0);
      }
    }

    if (!oldWidget.disableAnimations && widget.disableAnimations) {
      _activeRouteController.value = 1;
    }
  }

  @override
  void dispose() {
    _activeRouteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        widget.introProgress,
        widget.pulseProgress,
        _activeRouteController,
      ]),
      builder: (context, child) {
        final revealProgress = widget.disableAnimations
            ? 1.0
            : _timelineValue(widget.introProgress.value, 0.22, 0.66);
        final pulseProgress = widget.disableAnimations
            ? 0.0
            : widget.pulseProgress.value;
        final activeRouteProgress = widget.disableAnimations
            ? 1.0
            : _activeRouteController.value;

        return RepaintBoundary(
          key: const ValueKey('quest-map-path-layer'),
          child: CustomPaint(
            painter: _QuestMapPainter(
              nodes: widget.nodes,
              activeNodeId: widget.activeNodeId,
              revealProgress: revealProgress,
              activeRouteProgress: activeRouteProgress,
              pulseProgress: pulseProgress,
              parallaxOffset: widget.parallaxOffset,
            ),
          ),
        );
      },
    );
  }
}

class _QuestMapPainter extends CustomPainter {
  const _QuestMapPainter({
    required this.nodes,
    required this.activeNodeId,
    required this.revealProgress,
    required this.activeRouteProgress,
    required this.pulseProgress,
    required this.parallaxOffset,
  });

  final List<QuestNode> nodes;
  final String activeNodeId;
  final double revealProgress;
  final double activeRouteProgress;
  final double pulseProgress;
  final Offset parallaxOffset;

  @override
  void paint(Canvas canvas, Size size) {
    if (nodes.length < 2) {
      return;
    }

    final path = _buildQuestPath(nodes, size);
    final layerOffset = Offset(parallaxOffset.dx * 5, parallaxOffset.dy * 4);

    final glowPaint = Paint()
      ..color = AppColors.neonViolet.withValues(alpha: 0.13)
      ..strokeWidth = 18
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final basePaint = Paint()
      ..color = AppColors.neonBlue.withValues(alpha: 0.22)
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final revealGlowPaint = Paint()
      ..color = AppColors.neonCyan.withValues(alpha: 0.34)
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final revealPaint = Paint()
      ..color = AppColors.neonCyan.withValues(alpha: 0.68)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.save();
    canvas.translate(layerOffset.dx, layerOffset.dy);
    canvas
      ..drawPath(path, glowPaint)
      ..drawPath(path, basePaint);

    final revealPath = _extractPath(path, revealProgress);
    canvas
      ..drawPath(revealPath, revealGlowPaint)
      ..drawPath(revealPath, revealPaint);

    final activeIndex = nodes.indexWhere((node) => node.id == activeNodeId);
    if (activeIndex > 0) {
      final activePath = _buildQuestPath(
        nodes.take(activeIndex + 1).toList(),
        size,
      );
      final animatedActivePath = _extractPath(
        activePath,
        activeRouteProgress * revealProgress,
      );
      final pulse = math.sin(pulseProgress * math.pi * 2).abs();
      final activeGlowPaint = Paint()
        ..color = AppColors.plasmaPink.withValues(alpha: 0.18 + pulse * 0.08)
        ..strokeWidth = 20
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      final activePaint = Paint()
        ..color = AppColors.starWhite.withValues(alpha: 0.56 + pulse * 0.20)
        ..strokeWidth = 4.4
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas
        ..drawPath(animatedActivePath, activeGlowPaint)
        ..drawPath(animatedActivePath, activePaint);
    }

    for (final node in nodes) {
      final isActive = node.id == activeNodeId;
      final center = Offset(node.x * size.width, node.y * size.height);
      final color = _nodeColor(node.type);
      final pulse = isActive
          ? math.sin(pulseProgress * math.pi * 2).abs()
          : 0.0;
      final radius = isActive ? 36.0 + pulse * 5.0 : 27.0;

      final glow = Paint()
        ..shader = RadialGradient(
          colors: [
            color.withValues(alpha: isActive ? 0.54 : 0.22),
            color.withValues(alpha: isActive ? 0.16 : 0.07),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(center: center, radius: radius * 2.6));
      final ring = Paint()
        ..color = color.withValues(alpha: isActive ? 0.95 : 0.65)
        ..style = PaintingStyle.stroke
        ..strokeWidth = isActive ? 3.6 : 2.2;
      final selectedRing = Paint()
        ..color = AppColors.starWhite.withValues(alpha: 0.55 + pulse * 0.22)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      final core = Paint()
        ..color = color.withValues(alpha: isActive ? 0.48 : 0.28);

      canvas
        ..drawCircle(center, radius * 2.6, glow)
        ..drawCircle(center, radius, ring);
      if (isActive) {
        canvas.drawCircle(center, radius + 9 + pulse * 3, selectedRing);
      }
      canvas.drawCircle(center, 7, core);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _QuestMapPainter oldDelegate) {
    return oldDelegate.nodes != nodes ||
        oldDelegate.activeNodeId != activeNodeId ||
        oldDelegate.revealProgress != revealProgress ||
        oldDelegate.activeRouteProgress != activeRouteProgress ||
        oldDelegate.pulseProgress != pulseProgress ||
        oldDelegate.parallaxOffset != parallaxOffset;
  }
}

class _ActiveNodePanel extends StatelessWidget {
  const _ActiveNodePanel({
    required this.introProgress,
    required this.disableAnimations,
  });

  final Animation<double> introProgress;
  final bool disableAnimations;

  @override
  Widget build(BuildContext context) {
    final activeNodeId = context.select<QuestCubit, String>(
      (cubit) => cubit.state.activeNodeId,
    );
    final node = PortfolioContent.questNodes.firstWhere(
      (node) => node.id == activeNodeId,
      orElse: () => PortfolioContent.questNodes.first,
    );

    return _QuestIntroReveal(
      progress: introProgress,
      disableAnimations: disableAnimations,
      start: 0.68,
      end: 0.92,
      slideOffset: const Offset(0, 18),
      child: _GlassPanel(
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
            Text(
              node.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
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
      ),
    );
  }
}

class _QuestNodeCard extends StatefulWidget {
  const _QuestNodeCard({
    required this.node,
    required this.index,
    required this.introProgress,
    required this.disableAnimations,
    this.compact = false,
    this.parallaxOffset = Offset.zero,
  });

  final QuestNode node;
  final int index;
  final Animation<double> introProgress;
  final bool disableAnimations;
  final bool compact;
  final Offset parallaxOffset;

  @override
  State<_QuestNodeCard> createState() => _QuestNodeCardState();
}

class _QuestNodeCardState extends State<_QuestNodeCard> {
  var _hovered = false;
  var _focused = false;

  @override
  Widget build(BuildContext context) {
    final isActive = context.select<QuestCubit, bool>(
      (cubit) => cubit.state.activeNodeId == widget.node.id,
    );
    final isInteractive = isActive || _hovered || _focused;
    final color = _nodeColor(widget.node.type);
    final introStart = 0.40 + widget.index * 0.055;
    final introEnd = math.min(introStart + 0.24, 0.96);
    final duration = widget.disableAnimations ? Duration.zero : 180.ms;

    return _QuestIntroReveal(
      progress: widget.introProgress,
      disableAnimations: widget.disableAnimations,
      start: introStart,
      end: introEnd,
      slideOffset: const Offset(0, 16),
      child: Semantics(
        selected: isActive,
        button: true,
        child: InkWell(
          key: ValueKey('quest-node-${widget.node.id}'),
          borderRadius: BorderRadius.circular(22),
          onFocusChange: (focused) {
            setState(() {
              _focused = focused;
            });
          },
          onHover: (hovered) {
            setState(() {
              _hovered = hovered;
            });
          },
          onTap: () {
            context.read<QuestCubit>().selectNode(widget.node.id);
          },
          child: Transform.translate(
            offset: widget.parallaxOffset,
            transformHitTests: false,
            child: TweenAnimationBuilder<double>(
              duration: duration,
              tween: Tween(end: isInteractive ? 1.025 : 1),
              builder: (context, scale, child) {
                return Transform.scale(
                  scale: scale,
                  transformHitTests: false,
                  child: child,
                );
              },
              child: AnimatedContainer(
                duration: duration,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.neonBlue.withValues(alpha: 0.22)
                      : _hovered || _focused
                      ? AppColors.neonBlue.withValues(alpha: 0.13)
                      : AppColors.glass,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isActive
                        ? AppColors.neonCyan
                        : _focused
                        ? AppColors.starWhite.withValues(alpha: 0.74)
                        : AppColors.neonBlue.withValues(alpha: 0.26),
                    width: isActive || _focused ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(
                        alpha: isActive
                            ? 0.34
                            : _hovered || _focused
                            ? 0.22
                            : 0.12,
                      ),
                      blurRadius: isActive
                          ? 38
                          : _hovered || _focused
                          ? 28
                          : 18,
                      offset: Offset(0, isInteractive ? 12 : 6),
                    ),
                    if (isActive)
                      BoxShadow(
                        color: AppColors.starWhite.withValues(alpha: 0.10),
                        blurRadius: 18,
                        spreadRadius: 1,
                      ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(_nodeIcon(widget.node.type), color: color),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.node.subtitle,
                            style: const TextStyle(
                              color: AppColors.neonCyan,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        if (isActive) _SelectedNodeCue(nodeId: widget.node.id),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.node.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.node.description,
                      maxLines: widget.compact ? 2 : 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectedNodeCue extends StatelessWidget {
  const _SelectedNodeCue({required this.nodeId});

  final String nodeId;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      key: ValueKey('quest-node-selected-indicator-$nodeId'),
      decoration: BoxDecoration(
        color: AppColors.starWhite.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.starWhite.withValues(alpha: 0.46)),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 7, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check, color: AppColors.starWhite, size: 12),
            SizedBox(width: 4),
            Text(
              'Selected',
              style: TextStyle(
                color: AppColors.starWhite,
                fontSize: 10,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestIntroReveal extends StatelessWidget {
  const _QuestIntroReveal({
    required this.progress,
    required this.disableAnimations,
    required this.start,
    required this.end,
    required this.slideOffset,
    required this.child,
  });

  final Animation<double> progress;
  final bool disableAnimations;
  final double start;
  final double end;
  final Offset slideOffset;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (disableAnimations) {
      return child;
    }

    return AnimatedBuilder(
      animation: progress,
      child: child,
      builder: (context, child) {
        final reveal = _timelineValue(progress.value, start, end);
        return Opacity(
          opacity: reveal,
          child: Transform.translate(
            offset: Offset(
              slideOffset.dx * (1 - reveal),
              slideOffset.dy * (1 - reveal),
            ),
            transformHitTests: false,
            child: child,
          ),
        );
      },
    );
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

Path _buildQuestPath(List<QuestNode> nodes, Size size) {
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

  return path;
}

Path _extractPath(Path path, double progress) {
  final clampedProgress = progress.clamp(0.0, 1.0);
  if (clampedProgress <= 0) {
    return Path();
  }
  if (clampedProgress >= 1) {
    return path;
  }

  final metrics = path.computeMetrics().toList();
  final totalLength = metrics.fold<double>(
    0,
    (sum, metric) => sum + metric.length,
  );
  var remainingLength = totalLength * clampedProgress;
  final extractedPath = Path();

  for (final metric in metrics) {
    final length = math.min(metric.length, remainingLength);
    if (length <= 0) {
      break;
    }

    extractedPath.addPath(metric.extractPath(0, length), Offset.zero);
    remainingLength -= length;
  }

  return extractedPath;
}

double _timelineValue(double progress, double start, double end) {
  if (progress <= start) {
    return 0;
  }
  if (progress >= end) {
    return 1;
  }

  final normalized = ((progress - start) / (end - start)).clamp(0.0, 1.0);
  return Curves.easeOutCubic.transform(normalized);
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
