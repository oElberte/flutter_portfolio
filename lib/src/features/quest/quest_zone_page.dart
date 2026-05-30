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
