import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/app_theme.dart';
import '../providers/language_provider.dart';
import '../widgets/app_back_button.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  static const Color _pastelPink = Color(0xFFFFF0F5);

  @override
  Widget build(BuildContext context) {
    final isSpanish =
        context.watch<LanguageProvider>().selectedLanguage == 'es';

    return Scaffold(
      backgroundColor: _pastelPink,
      appBar: AppBar(
        leading: const AppBackButton(),
        title: Text(isSpanish ? 'Ayuda rápida' : 'Quick help'),
        backgroundColor: _pastelPink,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  isSpanish
                      ? 'Estamos aquí para ayudarte, las 24 horas.'
                      : 'We are here to help, 24 hours a day.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 18),
                _ContactCard(
                  icon: Icons.support_agent_rounded,
                  title: isSpanish ? 'Recepción' : 'Reception',
                  detail: isSpanish
                      ? 'Disponible las 24 horas'
                      : 'Available 24 hours',
                  contact: isSpanish
                      ? 'Marca Ext. 0 desde el teléfono de tu habitación.'
                      : 'Dial Ext. 0 from your room phone.',
                ),
                const SizedBox(height: 14),
                _ContactCard(
                  icon: Icons.emergency_rounded,
                  title: isSpanish ? 'Emergencias' : 'Emergency services',
                  detail: '911',
                  contact: isSpanish
                      ? 'Confirma con recepción que este sea el número de emergencias vigente en tu localidad.'
                      : 'Confirm with reception that this is the current emergency number for your location.',
                  isEmergency: true,
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: () => _showReceptionInstructions(context, isSpanish),
                  icon: const Icon(Icons.call_rounded),
                  label: Text(
                    isSpanish ? 'Contactar a recepción · Ext. 0' : 'Contact reception · Ext. 0',
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => _callEmergencyServices(context, isSpanish),
                  icon: const Icon(Icons.emergency_rounded),
                  label: Text(
                    isSpanish ? 'Llamar a emergencias · 911' : 'Call emergency services · 911',
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  isSpanish
                      ? 'En caso de peligro inmediato, utiliza el número de emergencias local. La llamada se realiza desde el dispositivo y puede requerir una aplicación de teléfono.'
                      : 'In immediate danger, use your local emergency number. The call is placed from your device and may require a phone app.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showReceptionInstructions(BuildContext context, bool isSpanish) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.support_agent_rounded, color: AppColors.wine),
        title: Text(isSpanish ? 'Recepción · Ext. 0' : 'Reception · Ext. 0'),
        content: Text(
          isSpanish
              ? 'Desde el teléfono de tu habitación, marca 0 para comunicarte con recepción.'
              : 'Dial 0 from your room phone to reach reception.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(isSpanish ? 'Entendido' : 'Got it'),
          ),
        ],
      ),
    );
  }

  Future<void> _callEmergencyServices(
    BuildContext context,
    bool isSpanish,
  ) async {
    final uri = Uri(scheme: 'tel', path: '911');
    try {
      final launched = await launchUrl(uri);
      if (!launched && context.mounted) {
        _showCallError(context, isSpanish);
      }
    } on Exception {
      if (context.mounted) {
        _showCallError(context, isSpanish);
      }
    }
  }

  void _showCallError(BuildContext context, bool isSpanish) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isSpanish
              ? 'No se pudo abrir la aplicación de llamadas. Marca el número local de emergencias desde tu teléfono.'
              : 'Could not open the phone app. Dial your local emergency number from your phone.',
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({
    required this.icon,
    required this.title,
    required this.detail,
    required this.contact,
    this.isEmergency = false,
  });

  final IconData icon;
  final String title;
  final String detail;
  final String contact;
  final bool isEmergency;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: isEmergency ? Colors.red.shade700 : AppColors.wine,
              size: 28,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    detail,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: isEmergency ? Colors.red.shade700 : AppColors.wine,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(contact, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
