import 'portfolio_models.dart';

abstract final class PortfolioContent {
  static const ownerName = 'Elberte Plínio';
  static const fullName = 'Elberte Plínio Gois Vieira Filho';
  static const title = 'Flutter Specialist | Software Engineer | AI Engineer';
  static const location = 'Goiânia, GO, Brazil';
  static const email = 'elberte.dev@gmail.com';
  static const githubUrl = 'https://github.com/oElberte';
  static const linkedInUrl = 'https://www.linkedin.com/in/oelberte/';
  static const portfolioUrl = 'https://elberte.com/';
  static const whatsAppUrl = 'https://wa.me/5534991355629';
  static const resumeUrl = '/cv/elberte-plinio.pdf';

  static const valueProposition =
      'Flutter Specialist with 5+ years of software development experience, building high-scale mobile products with Clean Architecture, native integrations, AI-assisted features, technical leadership, and measurable performance gains.';

  static const questNodes = [
    QuestNode(
      id: 'hero',
      title: 'Spawn Point',
      subtitle: 'Start the quest',
      description:
          'A cinematic intro into Elberte’s Flutter engineering journey, production impact, and strongest technical proof points.',
      type: QuestNodeType.hero,
      route: '/',
      x: 0.17,
      y: 0.78,
      tags: ['5+ years', 'Flutter Specialist', 'AI Engineer'],
    ),
    QuestNode(
      id: 'architecture',
      title: 'Architecture Lab',
      subtitle: 'System design',
      description:
          'Clean Architecture, BLoC/Cubit, modular boundaries, native integration, and maintainable high-scale Flutter delivery.',
      type: QuestNodeType.skill,
      route: '/quest/architecture',
      x: 0.43,
      y: 0.25,
      tags: ['Clean Architecture', 'BLoC/Cubit', 'Mobile Architect'],
    ),
    QuestNode(
      id: 'performance',
      title: 'Performance Forge',
      subtitle: 'Smooth by design',
      description:
          'Real production gains: 80% process efficiency, 45% cost reduction, 50% query improvement, and fewer redundant reads.',
      type: QuestNodeType.skill,
      route: '/quest/performance',
      x: 0.57,
      y: 0.58,
      tags: ['Performance', 'Cost reduction', 'CI/CD'],
    ),
    QuestNode(
      id: 'animations',
      title: 'AI + Motion Portal',
      subtitle: 'Modern app craft',
      description:
          'AI-driven features, multi-step agent integrations, LLM experiences, deep links, search, and polished mobile UX.',
      type: QuestNodeType.skill,
      route: '/quest/animations',
      x: 0.84,
      y: 0.25,
      tags: ['LLMs', 'Agent integrations', 'Flutter UX'],
    ),
    QuestNode(
      id: 'gav-resorts',
      title: 'GAV Resorts Portal',
      subtitle: 'Production app',
      description:
          'Flutter architecture work connected to distributed Nest.js and Go back-end services with strong delivery impact.',
      type: QuestNodeType.project,
      route: '/quest/gav-resorts',
      x: 0.20,
      y: 0.47,
      tags: ['Flutter', 'Nest.js/Go', '80% efficiency'],
    ),
    QuestNode(
      id: 'case-study',
      title: 'Boss Room',
      subtitle: 'Deep technical proof',
      description:
          'A specialist-level case study around architecture, performance, CI/CD, mentoring, and AI-enabled product work.',
      type: QuestNodeType.caseStudy,
      route: '/quest/case-study',
      x: 0.84,
      y: 0.78,
      tags: ['Architecture', 'Performance', 'AI'],
    ),
  ];

  static const projects = [
    ProjectSpotlight(
      id: 'gav-resorts',
      title: 'GAV Resorts Mobile Platform',
      summary:
          'Architected Flutter integration with distributed Nest.js and Go services while leading a legacy rebuild with measurable efficiency and cost gains.',
      problem:
          'The product depended on legacy flows and a distributed back-end that required reliable mobile integration, scalable delivery, and stronger deployment practices.',
      solution:
          'Led Flutter architecture improvements, connected the app to Nest.js/Go microservices, established automated testing, and improved CI/CD across multiple repositories.',
      impact:
          'Achieved an 80% process efficiency improvement, 45% operational cost reduction, and stronger deployment reliability with GitHub Actions, Codemagic, and Pulumi.',
      stack: [
        'Flutter',
        'Dart',
        'Nest.js',
        'Go',
        'Firebase',
        'CI/CD',
        'Pulumi',
      ],
    ),
    ProjectSpotlight(
      id: 'musicplayce',
      title: 'MusicPlayce',
      summary:
          'Built and maintained Flutter and web experiences for music streaming, discovery, AI-powered search, and user communication.',
      problem:
          'The app needed better content discovery, lower Firebase usage, improved engagement, and reliable communication flows.',
      solution:
          'Introduced HydratedBLoC persistence, integrated Algolia search, implemented Branch.io deep links, and added an LLM chatbot for FAQs and communication.',
      impact:
          'Reduced redundant Firebase reads by 75%, boosted engagement by 23%, and improved music/content discoverability.',
      stack: [
        'Flutter',
        'HydratedBLoC',
        'Firebase',
        'Cloud Firestore',
        'Algolia',
        'Branch.io',
        'LLM',
      ],
      externalUrl: 'https://musicplayce.com/',
    ),
    ProjectSpotlight(
      id: 'zellor-ai',
      title: 'Zellor AI Commerce Platform',
      summary:
          'Contributed to AI-enabled commerce tooling, including portal work, Shopify app experiences, and embeddable product carousels.',
      problem:
          'The platform needed faster data access, lower storage costs, AI-assisted suggestions, and higher-performing commerce experiences.',
      solution:
          'Migrated database/back-end foundations, integrated AI and LLM features, and optimized autoplay strategy across embeddable carousels.',
      impact:
          'Improved query performance by 50%, reduced storage costs by 30%, increased user sales by over 15%, and reduced costs by 20%.',
      stack: ['AI', 'LLM', 'Shopify', 'Web Portal', 'Database Migration'],
    ),
    ProjectSpotlight(
      id: 'cuidapet',
      title: 'Cuidapet',
      summary:
          'A personal Flutter pet-care services app built with modular architecture and MobX state management.',
      problem:
          'The project needed to model a real service marketplace with clean feature separation, cloud integration, and maintainable state.',
      solution:
          'Built a Flutter architecture using modular boundaries, Firebase/GCP integration, MySQL-backed services, and MobX state management.',
      impact:
          'Demonstrates end-to-end Flutter app structure, practical cloud integration, and production-inspired feature organization.',
      stack: ['Flutter', 'Firebase', 'GCP', 'MySQL', 'MobX'],
      externalUrl: 'https://github.com/oElberte/cuidapet',
    ),
    ProjectSpotlight(
      id: 'delivery-app',
      title: 'Delivery App',
      summary:
          'A food delivery app built in Flutter using Clean Architecture and the BLoC pattern.',
      problem:
          'The app needed a scalable structure for ordering flows, state transitions, and maintainable feature growth.',
      solution:
          'Applied Clean Architecture, BLoC, typed layers, and clear separation between presentation, domain, and data concerns.',
      impact:
          'Demonstrates disciplined Flutter architecture and testable app boundaries in a familiar product domain.',
      stack: ['Flutter', 'Dart', 'Clean Architecture', 'BLoC'],
      externalUrl: 'https://github.com/oElberte/delivery-app',
    ),
    ProjectSpotlight(
      id: 'clean-pokedex',
      title: 'Clean Pokédex',
      summary:
          'A rebuild of an early Flutter app using Clean Architecture and test-driven development principles.',
      problem:
          'An older learning app needed to be rethought with stronger architecture, maintainability, and testing discipline.',
      solution:
          'Rebuilt the app around Clean Architecture, TDD principles, CI/CD practices, and clearer feature boundaries.',
      impact:
          'Shows growth from first Flutter experiments into specialist-level architecture and quality habits.',
      stack: ['Flutter', 'Clean Architecture', 'TDD', 'CI/CD'],
      externalUrl: 'https://github.com/oElberte/pokedex-clean-architecture',
    ),
  ];

  static const milestones = [
    TimelineMilestone(
      title:
          'Salsa Technology — Flutter Specialist, Mobile Architect, AI Engineer',
      period: 'Oct 2025 – Present',
      description:
          'Architects high-scale Flutter apps, designs AI-driven features and multi-step agent integrations, mentors engineers, improves CI/CD, and optimizes app quality across iOS and Android.',
    ),
    TimelineMilestone(
      title: 'GAV Resorts — Flutter Engineer, Mobile Architect',
      period: 'Jul 2024 – Sep 2025',
      description:
          'Integrated Flutter with Nest.js/Go microservices, led a legacy rebuild with 80% efficiency gain and 45% cost reduction, and improved deployment pipelines.',
    ),
    TimelineMilestone(
      title: 'Zellor AI — Software Engineer, AI Engineer',
      period: 'Mar 2023 – Jun 2024',
      description:
          'Improved query performance by 50%, reduced storage costs by 30%, contributed to commerce platform features, and integrated AI/LLM experiences.',
    ),
    TimelineMilestone(
      title: 'MusicPlayce — Flutter Developer',
      period: 'Jul 2022 – Feb 2023',
      description:
          'Introduced HydratedBLoC, reduced redundant Firebase reads by 75%, added Algolia search, Branch.io deep links, and an LLM chatbot.',
    ),
    TimelineMilestone(
      title: 'Farsoft Systems — Flutter Developer',
      period: 'Feb 2021 – Jun 2022',
      description:
          'Contributed to CRM/ERP migration, built critical modules, emphasized clean code, testing, operational efficiency, and REST API integrations.',
    ),
  ];
}
