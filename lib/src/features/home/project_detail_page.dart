import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_theme.dart';
import '../../data/portfolio_content.dart';
import '../../data/portfolio_models.dart';

class ProjectDetailPage extends StatelessWidget {
  const ProjectDetailPage({required this.projectId, super.key});

  final String projectId;

  @override
  Widget build(BuildContext context) {
    final project = PortfolioContent.projects.firstWhere(
      (project) => project.id == projectId,
      orElse: () => PortfolioContent.projects.first,
    );
    final titleSize = MediaQuery.sizeOf(context).width < 520 ? 42.0 : 64.0;

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
                constraints: const BoxConstraints(maxWidth: 980),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => context.go('/quick-scan'),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Back to Quick Scan'),
                    ),
                    const SizedBox(height: 42),
                    Text(
                      'Project Portal',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.neonCyan,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      project.title,
                      style: Theme.of(
                        context,
                      ).textTheme.displayLarge?.copyWith(fontSize: titleSize),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      project.summary,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    if (project.externalUrl case final url?) ...[
                      const SizedBox(height: 22),
                      FilledButton.icon(
                        onPressed: () => _open(Uri.parse(url)),
                        icon: const Icon(Icons.link),
                        label: const Text('Open live/source'),
                      ),
                    ],
                    const SizedBox(height: 32),
                    _CaseStudyGrid(project: project),
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

Future<void> _open(Uri uri) async {
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

class _CaseStudyGrid extends StatelessWidget {
  const _CaseStudyGrid({required this.project});

  final ProjectSpotlight project;

  @override
  Widget build(BuildContext context) {
    final sections = [
      ('Problem', project.problem, Icons.report_problem_outlined),
      ('Solution', project.solution, Icons.architecture),
      ('Impact', project.impact, Icons.trending_up),
      ('Stack', project.stack.join(' • '), Icons.layers),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth < 760
            ? constraints.maxWidth
            : (constraints.maxWidth - 18) / 2;

        return Wrap(
          spacing: 18,
          runSpacing: 18,
          children: [
            for (final section in sections)
              SizedBox(
                width: width,
                child: _CaseStudyCard(
                  title: section.$1,
                  body: section.$2,
                  icon: section.$3,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _CaseStudyCard extends StatelessWidget {
  const _CaseStudyCard({
    required this.title,
    required this.body,
    required this.icon,
  });

  final String title;
  final String body;
  final IconData icon;

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
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.neonCyan),
            const SizedBox(height: 18),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            Text(body, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
