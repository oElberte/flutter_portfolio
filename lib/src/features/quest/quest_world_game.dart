import 'dart:math' as math;

import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class QuestWorldGame extends FlameGame {
  final _random = math.Random(42);
  final List<_Particle> _particles = [];
  double _time = 0;

  @override
  Future<void> onLoad() async {
    for (var i = 0; i < 90; i++) {
      _particles.add(
        _Particle(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          speed: 0.015 + _random.nextDouble() * 0.04,
          radius: 0.8 + _random.nextDouble() * 2.8,
          phase: _random.nextDouble() * math.pi * 2,
        ),
      );
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;

    for (final particle in _particles) {
      particle.y -= particle.speed * dt;
      particle.phase += dt;
      if (particle.y < -0.05) {
        particle
          ..x = _random.nextDouble()
          ..y = 1.05;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    final worldSize = Size(size.x, size.y);
    final rect = Offset.zero & worldSize;

    _drawBackground(canvas, rect);
    _drawParticles(canvas, worldSize);

    super.render(canvas);
  }

  void _drawBackground(Canvas canvas, Rect rect) {
    final background = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.voidBlack,
          AppColors.deepSpace,
          Color(0xFF120A2D),
          AppColors.voidBlack,
        ],
      ).createShader(rect);

    canvas.drawRect(rect, background);

    final glow = Paint()
      ..shader =
          RadialGradient(
            colors: [
              AppColors.neonBlue.withValues(alpha: 0.22),
              Colors.transparent,
            ],
          ).createShader(
            Rect.fromCircle(
              center: Offset(rect.width * 0.62, rect.height * 0.38),
              radius: rect.shortestSide * 0.68,
            ),
          );

    canvas.drawRect(rect, glow);
  }

  void _drawParticles(Canvas canvas, Size worldSize) {
    for (final particle in _particles) {
      final pulse = (math.sin(particle.phase + _time * 1.4) + 1) / 2;
      final paint = Paint()
        ..color = AppColors.neonCyan.withValues(alpha: 0.2 + pulse * 0.45);

      canvas.drawCircle(
        Offset(particle.x * worldSize.width, particle.y * worldSize.height),
        particle.radius,
        paint,
      );
    }
  }
}

class _Particle {
  _Particle({
    required this.x,
    required this.y,
    required this.speed,
    required this.radius,
    required this.phase,
  });

  double x;
  double y;
  final double speed;
  final double radius;
  double phase;
}
