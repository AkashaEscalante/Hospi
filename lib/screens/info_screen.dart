import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/app_theme.dart';
import '../providers/language_provider.dart';
import '../widgets/app_back_button.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  static const Color _pastelPink = Color(0xFFFFF0F5);

  @override
  Widget build(BuildContext context) {
    final isSpanish =
        context.watch<LanguageProvider>().selectedLanguage == 'es';

    return Scaffold(
      backgroundColor: _pastelPink,
      appBar: AppBar(
        leading: const AppBackButton(),
        title: Text(isSpanish ? 'Información del hotel' : 'Hotel information'),
        backgroundColor: _pastelPink,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 820),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              children: [
                Text(
                  isSpanish
                      ? 'Todo lo que necesitas para disfrutar tu estancia.'
                      : 'Everything you need to enjoy your stay.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 18),
                _InfoCard(
                  icon: Icons.schedule_rounded,
                  title: isSpanish ? 'Horarios' : 'Check-in and check-out',
                  child: Column(
                    children: [
                      _InfoRow(
                        label: isSpanish ? 'Check-in' : 'Check-in',
                        value: '15:00',
                      ),
                      const Divider(height: 20),
                      _InfoRow(
                        label: isSpanish ? 'Check-out' : 'Check-out',
                        value: '12:00',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                _InfoCard(
                  icon: Icons.wifi_rounded,
                  title: isSpanish ? 'Wi-Fi gratuito' : 'Free Wi-Fi',
                  child: Text(
                    isSpanish
                        ? 'La conexión Wi-Fi es gratuita para huéspedes. Solicita en recepción el nombre de la red y la contraseña vigentes.'
                        : 'Wi-Fi is free for guests. Ask reception for the current network name and password.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: 14),
                _InfoCard(
                  icon: Icons.free_breakfast_rounded,
                  title: isSpanish ? 'Desayuno buffet' : 'Breakfast buffet',
                  child: _InfoRow(
                    label: isSpanish ? 'Horario' : 'Hours',
                    value: '07:00 – 10:30',
                  ),
                ),
                const SizedBox(height: 14),
                _InfoCard(
                  icon: Icons.local_parking_rounded,
                  title: isSpanish ? 'Estacionamiento' : 'Parking',
                  child: Text(
                    isSpanish
                        ? 'Consulta en recepción la disponibilidad, las tarifas y las indicaciones de acceso.'
                        : 'Ask reception about availability, rates, and access instructions.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: 14),
                _InfoCard(
                  icon: Icons.support_agent_rounded,
                  title: isSpanish ? 'Recepción 24 horas' : '24-hour reception',
                  child: _InfoRow(
                    label: isSpanish ? 'Desde el teléfono de tu habitación' : 'From your room phone',
                    value: isSpanish ? 'Ext. 0' : 'Ext. 0',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  final IconData icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.wine),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyLarge)),
        const SizedBox(width: 12),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.wine,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
