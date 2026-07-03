import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:splitly/config/routes/app_router.dart';
import 'package:splitly/config/theme/app_theme.dart';
import 'package:splitly/features/expenses/presentation/cubit/expenses_cubit.dart';
import 'package:splitly/features/expenses/presentation/widgets/splash_overlay.dart';

void main() => runApp(const SplitlyApp());

class SplitlyApp extends StatelessWidget {
  const SplitlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ExpensesCubit>(
      create: (_) => ExpensesCubit(),
      child: MaterialApp.router(
        title: 'Splitly',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.dark,
        routerConfig: AppRouter.router,
        builder: (BuildContext context, Widget? child) {
          return Stack(
            children: <Widget>[
              ?child,
              const Positioned.fill(child: SplashOverlay()),
            ],
          );
        },
      ),
    );
  }
}
