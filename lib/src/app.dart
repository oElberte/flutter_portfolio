import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/quest/quest_cubit.dart';

class FlutterEngineerQuestApp extends StatefulWidget {
  const FlutterEngineerQuestApp({super.key});

  @override
  State<FlutterEngineerQuestApp> createState() =>
      _FlutterEngineerQuestAppState();
}

class _FlutterEngineerQuestAppState extends State<FlutterEngineerQuestApp> {
  late final _router = createAppRouter();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QuestCubit(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Engineer Quest',
        theme: AppTheme.dark,
        routerConfig: _router,
        builder: (context, child) => ResponsiveBreakpoints.builder(
          child: child ?? const SizedBox.shrink(),
          breakpoints: const [
            Breakpoint(start: 0, end: 600, name: MOBILE),
            Breakpoint(start: 601, end: 1024, name: TABLET),
            Breakpoint(start: 1025, end: 1920, name: DESKTOP),
            Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
        ),
      ),
    );
  }
}
