import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../data/portfolio_content.dart';
import '../../data/portfolio_models.dart';

class QuestZonePage extends StatelessWidget {
  const QuestZonePage({required this.nodeId, super.key});

  final String nodeId;

  @override
  Widget build(BuildContext context) {
    final node = PortfolioContent.questNodes.firstWhere(
      (node) => node.id == nodeId,
      orElse: () => PortfolioContent.questNodes.first,
    );
    final content = _contentFor(node);

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
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1180),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _ZoneHeader(),
                    const SizedBox(height: 42),
                    _ZoneHero(node: node, content: content),
                    const SizedBox(height: 28),
                    if (node.id == 'architecture') ...[
                      const _ArchitectureLayerExplorer(),
                      const SizedBox(height: 28),
                    ],
                    _ZoneGrid(content: content),
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

class _ZoneHeader extends StatelessWidget {
  const _ZoneHeader();

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
          label: const Text('Back to Quest'),
        ),
        OutlinedButton.icon(
          onPressed: () => context.go('/quick-scan'),
          icon: const Icon(Icons.view_list),
          label: const Text('Quick Scan'),
        ),
      ],
    );
  }
}

class _ZoneHero extends StatelessWidget {
  const _ZoneHero({required this.node, required this.content});

  final QuestNode node;
  final _ZoneContent content;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 820;
        final titleSize = constraints.maxWidth < 460
            ? 40.0
            : compact
            ? 52.0
            : 64.0;

        final intro = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${node.title} Zone',
              style: const TextStyle(
                color: AppColors.neonCyan,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              content.headline,
              style: Theme.of(
                context,
              ).textTheme.displayLarge?.copyWith(fontSize: titleSize),
            ),
            const SizedBox(height: 16),
            Text(
              content.narrative,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 22),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [for (final tag in node.tags) _SignalChip(label: tag)],
            ),
          ],
        );

        final metrics = _GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Proof meter',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 18),
              for (final metric in content.metrics)
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _MetricLine(metric: metric),
                ),
              if (content.primaryRoute case final route?) ...[
                const SizedBox(height: 8),
                FilledButton.icon(
                  onPressed: () => context.go(route),
                  icon: const Icon(Icons.open_in_new),
                  label: Text(content.primaryCta),
                ),
              ],
            ],
          ),
        );

        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [intro, const SizedBox(height: 24), metrics],
          ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.04);
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(flex: 6, child: intro),
            const SizedBox(width: 34),
            Expanded(flex: 4, child: metrics),
          ],
        ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.04);
      },
    );
  }
}

class _ZoneGrid extends StatelessWidget {
  const _ZoneGrid({required this.content});

  final _ZoneContent content;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth < 760
            ? constraints.maxWidth
            : (constraints.maxWidth - 28) / 3;

        return Wrap(
          spacing: 14,
          runSpacing: 14,
          children: [
            for (final section in content.sections.indexed)
              SizedBox(
                width: cardWidth,
                child: _ZoneSectionCard(
                  index: section.$1,
                  title: section.$2.title,
                  body: section.$2.body,
                  icon: section.$2.icon,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ArchitectureLayerExplorer extends StatefulWidget {
  const _ArchitectureLayerExplorer();

  @override
  State<_ArchitectureLayerExplorer> createState() =>
      _ArchitectureLayerExplorerState();
}

class _ArchitectureLayerExplorerState
    extends State<_ArchitectureLayerExplorer> {
  int _selectedIndex = 0;

  static const _layers = [
    _ArchitectureLayer(
      label: 'Experience',
      title: 'Experience layer',
      summary: 'Widgets, motion, accessibility, responsive web shell.',
      proof:
          'Keeps product screens expressive while preserving readability, semantic structure, and responsive behavior.',
      responsibilities: [
        'Responsive Flutter Web composition',
        'Game-inspired motion and feedback',
        'Accessible CTAs and readable content hierarchy',
      ],
    ),
    _ArchitectureLayer(
      label: 'State',
      title: 'State layer',
      summary: 'Cubit/BLoC boundaries, effects, hydration-ready state.',
      proof:
          'Keeps user flows predictable and easy to test while separating UI rendering from interaction state.',
      responsibilities: [
        'QuestCubit selected-node state',
        'Focused state transitions',
        'bloc_test coverage for behavior',
      ],
    ),
    _ArchitectureLayer(
      label: 'Domain',
      title: 'Domain layer',
      summary: 'Use cases, policies, validation, business invariants.',
      proof:
          'Protects product rules from UI churn and keeps feature decisions explicit when apps scale.',
      responsibilities: [
        'Business rules and use-case orchestration',
        'Validation and invariants',
        'Framework-independent decisions',
      ],
    ),
    _ArchitectureLayer(
      label: 'Data',
      title: 'Data layer',
      summary: 'Repositories, DTOs, cache, API clients, platform bridges.',
      proof:
          'Creates seams for Firebase, REST, native APIs, local cache, and third-party SDK integrations.',
      responsibilities: [
        'Repository abstractions',
        'DTO and model mapping',
        'Cache, API, and platform integration boundaries',
      ],
    ),
    _ArchitectureLayer(
      label: 'Quality',
      title: 'Quality layer',
      summary: 'Widget tests, bloc tests, goldens, CI smoke checks.',
      proof:
          'Turns architecture into repeatable confidence through tests, browser validation, and release checks.',
      responsibilities: [
        'Widget and Cubit coverage',
        'Browser validation across breakpoints',
        'Analyze, test, and web build gates',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final selectedLayer = _layers[_selectedIndex];

    return _GlassCard(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final selector = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Interactive layer explorer',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              Text(
                'Click a layer to inspect responsibilities, trade-offs, and proof.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final layer in _layers.indexed)
                    _LayerSelectorButton(
                      label: layer.$2.label,
                      isSelected: layer.$1 == _selectedIndex,
                      onTap: () => setState(() => _selectedIndex = layer.$1),
                    ),
                ],
              ),
            ],
          );

          final detail = _LayerDetailCard(layer: selectedLayer);

          if (constraints.maxWidth < 760) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [selector, const SizedBox(height: 22), detail],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 4, child: selector),
              const SizedBox(width: 24),
              Expanded(flex: 5, child: detail),
            ],
          );
        },
      ),
    );
  }
}

class _LayerSelectorButton extends StatelessWidget {
  const _LayerSelectorButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.neonBlue.withValues(alpha: 0.22)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? AppColors.neonCyan
              : AppColors.neonBlue.withValues(alpha: 0.44),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.starWhite,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LayerDetailCard extends StatelessWidget {
  const _LayerDetailCard({required this.layer});

  final _ArchitectureLayer layer;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      child: DecoratedBox(
        key: ValueKey(layer.label),
        decoration: BoxDecoration(
          color: AppColors.neonBlue.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.neonCyan.withValues(alpha: 0.18)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(layer.title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              Text(layer.summary, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 18),
              for (final responsibility in layer.responsibilities)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _MetricLine(metric: responsibility),
                ),
              const SizedBox(height: 8),
              Text(
                layer.proof,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.starWhite.withValues(alpha: 0.82),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ZoneSectionCard extends StatelessWidget {
  const _ZoneSectionCard({
    required this.index,
    required this.title,
    required this.body,
    required this.icon,
  });

  final int index;
  final String title;
  final String body;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: AppColors.neonCyan),
              const SizedBox(height: 18),
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              Text(body, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        )
        .animate(delay: (80 * index).ms)
        .fadeIn(duration: 420.ms)
        .slideY(begin: 0.04);
  }
}

class _MetricLine extends StatelessWidget {
  const _MetricLine({required this.metric});

  final String metric;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.bolt, color: AppColors.neonCyan, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Text(metric, style: Theme.of(context).textTheme.bodyMedium),
        ),
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

class _ZoneContent {
  const _ZoneContent({
    required this.headline,
    required this.narrative,
    required this.metrics,
    required this.sections,
    this.primaryRoute,
    this.primaryCta = 'Open details',
  });

  final String headline;
  final String narrative;
  final List<String> metrics;
  final List<_ZoneSection> sections;
  final String? primaryRoute;
  final String primaryCta;
}

class _ZoneSection {
  const _ZoneSection({
    required this.title,
    required this.body,
    required this.icon,
  });

  final String title;
  final String body;
  final IconData icon;
}

class _ArchitectureLayer {
  const _ArchitectureLayer({
    required this.label,
    required this.title,
    required this.summary,
    required this.proof,
    required this.responsibilities,
  });

  final String label;
  final String title;
  final String summary;
  final String proof;
  final List<String> responsibilities;
}

_ZoneContent _contentFor(QuestNode node) {
  return switch (node.id) {
    'architecture' => const _ZoneContent(
      headline: 'Architecture that keeps teams fast after the first release.',
      narrative:
          'This zone explains how Elberte structures Flutter apps around clear boundaries, predictable state, native integration seams, and testable delivery paths.',
      metrics: [
        'Feature-first Flutter architecture with clean domain/data/presentation boundaries.',
        'BLoC/Cubit and HydratedBLoC experience across production apps.',
        'Mentoring and architecture guidance for mobile teams.',
      ],
      sections: [
        _ZoneSection(
          title: 'State boundaries',
          body:
              'Cubit/BLoC layers keep user flows predictable while making effects, persistence, and testing easier to reason about.',
          icon: Icons.account_tree,
        ),
        _ZoneSection(
          title: 'Integration seams',
          body:
              'Native APIs, Firebase, REST services, and platform concerns are isolated behind typed interfaces.',
          icon: Icons.extension,
        ),
        _ZoneSection(
          title: 'Quality gates',
          body:
              'Architecture choices are backed by tests, CI/CD, review discipline, and reusable module conventions.',
          icon: Icons.verified,
        ),
      ],
    ),
    'performance' => const _ZoneContent(
      headline: 'Performance wins proven by production metrics.',
      narrative:
          'This zone turns business impact into technical proof: fewer redundant reads, faster data access, lower cost, and better deployment confidence.',
      metrics: [
        '80% process efficiency improvement in a legacy rebuild.',
        '45% operational cost reduction on production systems.',
        '75% fewer redundant Firebase reads at MusicPlayce.',
      ],
      sections: [
        _ZoneSection(
          title: 'Rendering discipline',
          body:
              'Performance work starts with constrained rebuilds, intentional state updates, and adaptive UI structure.',
          icon: Icons.speed,
        ),
        _ZoneSection(
          title: 'Data efficiency',
          body:
              'Hydration, cache strategy, search integration, and query optimization reduce unnecessary round trips.',
          icon: Icons.storage,
        ),
        _ZoneSection(
          title: 'Delivery feedback',
          body:
              'CI/CD pipelines make quality and performance feedback visible before production releases.',
          icon: Icons.rocket_launch,
        ),
      ],
    ),
    'animations' => const _ZoneContent(
      headline: 'AI-enabled product work with polished Flutter experiences.',
      narrative:
          'This zone connects modern product craft: LLM features, agent-style flows, deep links, search, and interaction polish that still stays maintainable.',
      metrics: [
        'LLM chatbot work for FAQ and user communication flows.',
        'AI-assisted commerce features connected to Shopify/web portal work.',
        'Branch.io deep links and Algolia search for stronger discovery.',
      ],
      sections: [
        _ZoneSection(
          title: 'AI flows',
          body:
              'LLM and multi-step agent integrations are designed around user intent, guardrails, and product value.',
          icon: Icons.psychology,
        ),
        _ZoneSection(
          title: 'Discovery',
          body:
              'Search, deep links, and content routing improve how users reach the right experience.',
          icon: Icons.travel_explore,
        ),
        _ZoneSection(
          title: 'Motion system',
          body:
              'Game-inspired animations, cards, particles, and transitions make the portfolio itself a Flutter craft sample.',
          icon: Icons.auto_awesome_motion,
        ),
      ],
    ),
    'gav-resorts' => const _ZoneContent(
      headline:
          'A production portal for architecture, migration, and delivery.',
      narrative:
          'This project zone summarizes Elberte’s work connecting Flutter to distributed Nest.js/Go services and improving delivery reliability.',
      metrics: [
        '80% process efficiency gain.',
        '45% operational cost reduction.',
        'Improved CI/CD with GitHub Actions, Codemagic, and Pulumi.',
      ],
      primaryRoute: '/projects/gav-resorts',
      primaryCta: 'Open case study',
      sections: [
        _ZoneSection(
          title: 'Distributed backend',
          body:
              'Flutter app integration with Nest.js and Go services required stable contracts and reliable mobile architecture.',
          icon: Icons.hub,
        ),
        _ZoneSection(
          title: 'Legacy rebuild',
          body:
              'The rebuild focused on efficiency, maintainability, cost reduction, and safer delivery.',
          icon: Icons.construction,
        ),
        _ZoneSection(
          title: 'Delivery system',
          body:
              'Automated tests and deployment pipelines reduced release risk across repositories.',
          icon: Icons.alt_route,
        ),
      ],
    ),
    'case-study' => const _ZoneContent(
      headline: 'The boss room: specialist-level reasoning under constraints.',
      narrative:
          'This zone connects the strongest proof points: architecture decisions, performance metrics, AI-enabled products, and leadership.',
      metrics: [
        'Flutter Specialist, Mobile Architect, and AI Engineer experience.',
        'Production impact across GAV Resorts, MusicPlayce, Zellor AI, and Farsoft.',
        'Clear evidence of cost, performance, engagement, and delivery improvements.',
      ],
      primaryRoute: '/quick-scan',
      primaryCta: 'Open full portfolio',
      sections: [
        _ZoneSection(
          title: 'Technical judgment',
          body:
              'The work emphasizes boundaries, trade-offs, delivery confidence, and scalable team conventions.',
          icon: Icons.workspace_premium,
        ),
        _ZoneSection(
          title: 'Business impact',
          body:
              'Metrics show real value: lower cost, faster processes, fewer reads, better discovery, and improved engagement.',
          icon: Icons.trending_up,
        ),
        _ZoneSection(
          title: 'Leadership',
          body:
              'Architecture guidance, mentoring, CI/CD improvements, and review culture are part of the engineering story.',
          icon: Icons.groups,
        ),
      ],
    ),
    _ => _ZoneContent(
      headline: node.title,
      narrative: node.description,
      metrics: node.tags,
      primaryRoute: '/quick-scan',
      primaryCta: 'Open full portfolio',
      sections: [
        _ZoneSection(
          title: node.subtitle,
          body: node.description,
          icon: Icons.explore,
        ),
      ],
    ),
  };
}
