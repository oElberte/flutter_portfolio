import 'package:go_router/go_router.dart';

import '../../features/home/project_detail_page.dart';
import '../../features/home/quick_scan_page.dart';
import '../../features/quest/quest_page.dart';
import '../../features/quest/quest_zone_page.dart';

GoRouter createAppRouter() {
  return GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const QuestPage()),
      GoRoute(
        path: '/quick-scan',
        builder: (context, state) => const QuickScanPage(),
      ),
      GoRoute(
        path: '/quest/:nodeId',
        builder: (context, state) {
          final nodeId = state.pathParameters['nodeId'] ?? '';
          return QuestZonePage(nodeId: nodeId);
        },
      ),
      GoRoute(
        path: '/projects/:projectId',
        builder: (context, state) {
          final projectId = state.pathParameters['projectId'] ?? '';
          return ProjectDetailPage(projectId: projectId);
        },
      ),
    ],
  );
}
