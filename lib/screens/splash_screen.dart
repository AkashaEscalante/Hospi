import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../config/app_constants.dart';
import '../config/app_routes.dart';
import '../config/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    _timer = Timer(const Duration(milliseconds: 1800), () {
      if (!mounted) {
        return;
      }
      context.go(AppRoutes.language);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final scale = 0.8 + (_controller.value * 0.25);
            return Transform.scale(scale: scale, child: child);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 118,
                height: 118,
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.18),
                      blurRadius: 24,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Image.asset(
                      AppConstants.logoAssetPath,
                      fit: BoxFit.contain,
                      semanticLabel: 'HOSPI hotel logo',
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.hotel_rounded,
                          size: 58,
                          color: AppColors.primary,
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'HOSPI',
                style: theme.textTheme.displayLarge?.copyWith(
                  letterSpacing: 6,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Hospitality designed for comfort',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
