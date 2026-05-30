import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_theme.dart';
import '../../data/portfolio_content.dart';
import '../../data/portfolio_models.dart';

class QuickScanPage extends StatelessWidget {
  const QuickScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.voidBlack,
              AppColors.deepSpace,
              Color(0xFF120A2D),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1180),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _QuickHeader(),
                    const SizedBox(height: 56),
                    const _HeroSummary(),
                    const SizedBox(height: 48),
                    const _ArchitectureLab(),
                    const SizedBox(height: 48),
                    const _ProjectGrid(),
                    const SizedBox(height: 48),
                    const _Timeline(),
                    const SizedBox(height: 48),
                    const _ContactPortal(),
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

class _QuickHeader extends StatelessWidget {
  const _QuickHeader();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        OutlinedButton.icon(
          onPressed: () => context.go('/'),
          icon: const Icon(Icons.arrow_back),
          label: const Text('Explore Mode'),
        ),
        FilledButton.icon(
          onPressed: () => _open(Uri.parse(PortfolioContent.resumeUrl)),
          icon: const Icon(Icons.description),
          label: const Text('Download CV'),
        ),
        OutlinedButton.icon(
          onPressed: () => _open(Uri.parse('mailto:${PortfolioContent.email}')),
          icon: const Icon(Icons.send),
          label: const Text('Contact'),
        ),
      ],
    );
  }
}

class _HeroSummary extends StatelessWidget {
  const _HeroSummary();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 820;
        final titleSize = constraints.maxWidth < 420
            ? 42.0
            : constraints.maxWidth < 820
            ? 52.0
            : 64.0;
        final title = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Scan Mode',
              style: TextStyle(
                color: AppColors.neonCyan,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              PortfolioContent.ownerName,
              style: Theme.of(
                context,
              ).textTheme.displayLarge?.copyWith(fontSize: titleSize),
            ),
            const SizedBox(height: 8),
            Text(
              PortfolioContent.title,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(color: AppColors.neonBlue),
            ),
          ],
        );

        final summary = _GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                PortfolioContent.valueProposition,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              const Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _SignalChip(label: 'Production Flutter'),
                  _SignalChip(label: 'Architecture'),
                  _SignalChip(label: 'Performance'),
                  _SignalChip(label: 'Animations'),
                  _SignalChip(label: 'Testing'),
                  _SignalChip(label: 'CI/CD'),
                ],
              ),
            ],
          ),
        );

        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [title, const SizedBox(height: 22), summary],
          ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.04);
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(child: title),
            const SizedBox(width: 36),
            Expanded(child: summary),
          ],
        ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.04);
      },
    );
  }
}

class _ArchitectureLab extends StatelessWidget {
  const _ArchitectureLab();

  @override
  Widget build(BuildContext context) {
    const layers = [
      ('Experience', 'Widgets, motion, accessibility, responsive web shell'),
      ('State', 'Cubit/BLoC boundaries, effects, hydration-ready state'),
      ('Domain', 'Use cases, policies, validation, business invariants'),
      ('Data', 'Repositories, DTOs, cache, API clients, platform bridges'),
      ('Quality', 'Widget tests, bloc tests, goldens, CI smoke checks'),
    ];

    return _Section(
      eyebrow: 'Signature Feature',
      title: 'Interactive Architecture Lab',
      child: Wrap(
        spacing: 14,
        runSpacing: 14,
        children: [
          for (final layer in layers.indexed)
            SizedBox(
              width: 210,
              child: _GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '0${layer.$1 + 1}',
                      style: const TextStyle(
                        color: AppColors.neonCyan,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      layer.$2.$1,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      layer.$2.$2,
                      style: Theme.of(context).textTheme.bodyMedium,
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

class _ProjectGrid extends StatelessWidget {
  const _ProjectGrid();

  @override
  Widget build(BuildContext context) {
    return _Section(
      eyebrow: 'Project Portals',
      title: 'Case studies built for technical proof',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cardWidth = constraints.maxWidth < 740
              ? constraints.maxWidth
              : (constraints.maxWidth - 28) / 3;

          return Wrap(
            spacing: 14,
            runSpacing: 14,
            children: [
              for (final project in PortfolioContent.projects)
                SizedBox(
                  width: cardWidth,
                  child: _ProjectCard(project: project),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.project});

  final ProjectSpotlight project;

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.token, color: AppColors.neonViolet),
          const SizedBox(height: 16),
          Text(project.title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          Text(project.summary, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final item in project.stack.take(3))
                _SignalChip(label: item),
            ],
          ),
          const SizedBox(height: 18),
          TextButton.icon(
            onPressed: () => context.go('/projects/${project.id}'),
            icon: const Icon(Icons.open_in_new),
            label: const Text('Open case study'),
          ),
          if (project.externalUrl case final url?)
            TextButton.icon(
              onPressed: () => _open(Uri.parse(url)),
              icon: const Icon(Icons.link),
              label: const Text('Open live/source'),
            ),
        ],
      ),
    );
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline();

  @override
  Widget build(BuildContext context) {
    return _Section(
      eyebrow: 'Journey',
      title: 'A specialist path, not a generic landing page',
      child: Column(
        children: [
          for (final milestone in PortfolioContent.milestones.indexed)
            _TimelineTile(
              milestone: milestone.$2,
              isLast: milestone.$1 == PortfolioContent.milestones.length - 1,
            ),
        ],
      ),
    );
  }
}

class _TimelineTile extends StatelessWidget {
  const _TimelineTile({required this.milestone, required this.isLast});

  final TimelineMilestone milestone;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.neonCyan,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.neonCyan.withValues(alpha: 0.5),
                    blurRadius: 18,
                  ),
                ],
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 92,
                color: AppColors.neonBlue.withValues(alpha: 0.28),
              ),
          ],
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 28),
            child: _GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    milestone.period,
                    style: const TextStyle(
                      color: AppColors.neonCyan,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    milestone.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    milestone.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ContactPortal extends StatelessWidget {
  const _ContactPortal();

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final introWidth = constraints.maxWidth < 420
              ? constraints.maxWidth
              : 420.0;

          return Wrap(
            spacing: 16,
            runSpacing: 16,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: introWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Open the contact portal',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Available for specialist Flutter, mobile architecture, AI-enabled product work, and technical leadership opportunities.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              FilledButton.icon(
                onPressed: () =>
                    _open(Uri.parse('mailto:${PortfolioContent.email}')),
                icon: const Icon(Icons.mail),
                label: const Text('Email'),
              ),
              OutlinedButton.icon(
                onPressed: () => _open(Uri.parse(PortfolioContent.githubUrl)),
                icon: const Icon(Icons.code),
                label: const Text('GitHub'),
              ),
              OutlinedButton.icon(
                onPressed: () => _open(Uri.parse(PortfolioContent.linkedInUrl)),
                icon: const Icon(Icons.business_center),
                label: const Text('LinkedIn'),
              ),
              OutlinedButton.icon(
                onPressed: () =>
                    _open(Uri.parse(PortfolioContent.portfolioUrl)),
                icon: const Icon(Icons.public),
                label: const Text('Current portfolio'),
              ),
              OutlinedButton.icon(
                onPressed: () => _open(Uri.parse(PortfolioContent.whatsAppUrl)),
                icon: const Icon(Icons.chat),
                label: const Text('WhatsApp'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.eyebrow,
    required this.title,
    required this.child,
  });

  final String eyebrow;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow,
          style: const TextStyle(
            color: AppColors.neonCyan,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(title, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 22),
        child,
      ],
    );
  }
}

class _GlassCard extends StatelessWidget {
  const _GlassCard({required this.child});

  final Widget child;

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
      child: Padding(padding: const EdgeInsets.all(22), child: child),
    );
  }
}

class _SignalChip extends StatelessWidget {
  const _SignalChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text(label));
  }
}

Future<void> _open(Uri uri) async {
  await launchUrl(
    uri,
    mode: uri.hasScheme
        ? LaunchMode.externalApplication
        : LaunchMode.platformDefault,
  );
}
