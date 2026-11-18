import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../config/app_constants.dart';
import '../config/app_routes.dart';
import '../config/app_theme.dart';
import '../providers/language_provider.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<LanguageProvider>();
    final isSpanish = languageProvider.selectedLanguage == 'es';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Image.asset(
                        AppConstants.logoAssetPath,
                        fit: BoxFit.contain,
                        semanticLabel: isSpanish
                            ? 'Logotipo del hotel'
                            : 'Hotel logo',
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.language_rounded,
                            size: 56,
                            color: AppColors.primary,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    isSpanish ? 'Selecciona tu idioma' : 'Select your language',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isSpanish
                        ? 'Elige el idioma con el que prefieres navegar.'
                        : 'Choose the language you prefer for navigation.',
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: AppColors.muted),
                  ),
                  const SizedBox(height: 32),
                  FilledButton.icon(
                    onPressed: () async {
                      await languageProvider.setLanguage('es');
                      if (context.mounted) {
                        context.go(AppRoutes.home);
                      }
                    },
                    icon: const Icon(Icons.flag_rounded),
                    label: const Text('Español'),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () async {
                      await languageProvider.setLanguage('en');
                      if (context.mounted) {
                        context.go(AppRoutes.home);
                      }
                    },
                    icon: const Icon(Icons.language_rounded),
                    label: const Text('English'),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    '${AppConstants.appName} • ${AppConstants.hotelName}',
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
