import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/app_routes.dart';
import 'config/app_theme.dart';
import 'providers/language_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HospiApp());
}

class HospiApp extends StatelessWidget {
  const HospiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => LanguageProvider())],
      child: Builder(
        builder: (context) {
          final languageProvider = context.watch<LanguageProvider>();
          final theme = AppTheme.light(
            textScaleFactor: languageProvider.textScaleFactor,
            isHighContrast: languageProvider.highContrast,
          );

          return MaterialApp.router(
            title: 'HOSPI',
            debugShowCheckedModeBanner: false,
            theme: theme,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
