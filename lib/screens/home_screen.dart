import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../config/app_constants.dart';
import '../config/app_routes.dart';
import '../config/app_theme.dart';
import '../providers/language_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageProvider>();
    final isSpanish = language.selectedLanguage == 'es';
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 700;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1050),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? 40 : 22,
                vertical: 22,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ENCABEZADO
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => context.go(AppRoutes.language),
                        tooltip: isSpanish
                            ? 'Volver a selección de idioma'
                            : 'Back to language selection',
                        icon: const Icon(Icons.arrow_back_rounded),
                        color: AppColors.wine,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          AppConstants.logoAssetPath,
                          height: 52,
                          width: 52,
                          fit: BoxFit.contain,
                          semanticLabel: isSpanish
                              ? 'Logotipo del hotel'
                              : 'Hotel logo',
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 52,
                              width: 52,
                              decoration: BoxDecoration(
                                color: AppColors.wine,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.hotel_rounded,
                                color: Colors.white,
                                size: 29,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'HOSPI',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2,
                                ),
                          ),
                          const Text(
                            'HOTEL EXPERIENCE',
                            style: TextStyle(
                              color: AppColors.muted,
                              fontSize: 9,
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.primarySoft,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: TextButton(
                          onPressed: () async {
                            await language.setLanguage(isSpanish ? 'en' : 'es');
                          },
                          child: Text(
                            isSpanish ? 'ES  |  EN' : 'EN  |  ES',
                            style: const TextStyle(
                              color: AppColors.wine,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 35),

                  // BIENVENIDA
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF72515E),
                          Color(0xFF9D7180),
                          Color(0xFFB9788D),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.wine.withValues(alpha: 0.22),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 13,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.17),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            isSpanish
                                ? '✦  BIENVENIDO A HOSPI'
                                : '✦  WELCOME TO HOSPI',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        Text(
                          isSpanish
                              ? 'Tu comodidad,\nnuestra prioridad.'
                              : 'Your comfort,\nour priority.',
                          style: Theme.of(context).textTheme.displayMedium
                              ?.copyWith(color: Colors.white, height: 1.2),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          isSpanish
                              ? 'Descubre todo lo que necesitas para disfrutar tu estancia.'
                              : 'Discover everything you need to enjoy your stay.',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: Color(0xFFEAD3AC),
                              size: 19,
                            ),
                            SizedBox(width: 7),
                            Text(
                              'HOSPI HOTEL',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 35),

                  Text(
                    isSpanish
                        ? '¿En qué podemos ayudarte?'
                        : 'How can we help?',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 7),
                  Text(
                    isSpanish
                        ? 'Explora nuestros servicios y herramientas.'
                        : 'Explore our services and tools.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                  const SizedBox(height: 20),

                  // ACCESOS PRINCIPALES
                  GridView.count(
                    crossAxisCount: isWide ? 2 : 1,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    childAspectRatio: isWide ? 2.8 : 3.1,
                    children: [
                      _FeatureCard(
                        title: isSpanish ? 'Mapa del hotel' : 'Hotel map',
                        subtitle: isSpanish
                            ? 'Encuentra tu destino fácilmente'
                            : 'Find your destination easily',
                        icon: Icons.map_rounded,
                        color: const Color(0xFFE9DFF2),
                        onTap: () => context.push(AppRoutes.map),
                      ),
                      _FeatureCard(
                        title: isSpanish ? 'Ayuda rápida' : 'Quick help',
                        subtitle: isSpanish
                            ? 'Estamos aquí para ayudarte'
                            : 'We are here to help',
                        icon: Icons.support_agent_rounded,
                        color: const Color(0xFFF6DCE4),
                        onTap: () => context.push(AppRoutes.help),
                      ),
                      _FeatureCard(
                        title: isSpanish ? 'Información' : 'Information',
                        subtitle: isSpanish
                            ? 'Servicios, horarios y más'
                            : 'Services, hours and more',
                        icon: Icons.info_outline_rounded,
                        color: const Color(0xFFF3E8D9),
                        onTap: () => context.push(AppRoutes.info),
                      ),
                      _FeatureCard(
                        title: isSpanish ? 'Accesibilidad' : 'Accessibility',
                        subtitle: isSpanish
                            ? 'Personaliza tu experiencia'
                            : 'Customize your experience',
                        icon: Icons.accessibility_new_rounded,
                        color: const Color(0xFFDCEDE6),
                        onTap: () => context.push(AppRoutes.accessibility),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // PIE DE PÁGINA
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: AppColors.primarySoft),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.favorite_rounded,
                          color: AppColors.primary,
                          size: 25,
                        ),
                        const SizedBox(width: 13),
                        Expanded(
                          child: Text(
                            isSpanish
                                ? 'Diseñado para que cada estancia sea especial.'
                                : 'Designed to make every stay special.',
                            style: const TextStyle(
                              color: AppColors.wine,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      'HOSPI HOTEL  •  © 2026',
                      style: TextStyle(
                        color: AppColors.muted.withValues(alpha: 0.7),
                        fontSize: 11,
                        letterSpacing: 1.5,
                      ),
                    ),
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

class _FeatureCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: pressed ? 0.97 : 1,
      duration: const Duration(milliseconds: 150),
      child: Card(
        elevation: 3,
        shadowColor: AppColors.wine.withValues(alpha: 0.08),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: widget.onTap,
          onHighlightChanged: (value) {
            setState(() => pressed = value);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            child: Row(
              children: [
                Container(
                  height: 54,
                  width: 54,
                  decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(widget.icon, color: AppColors.wine, size: 27),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.subtitle,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: AppColors.accent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
