import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';

import '../config/app_theme.dart';
import '../providers/language_provider.dart';
import '../widgets/app_back_button.dart';

class AccessibilityScreen extends StatefulWidget {
  const AccessibilityScreen({super.key});

  @override
  State<AccessibilityScreen> createState() => _AccessibilityScreenState();
}

class _AccessibilityScreenState extends State<AccessibilityScreen> {
  static const Color _pastelPink = Color(0xFFFFF0F5);

  final FlutterTts _flutterTts = FlutterTts();
  bool _voiceEnabled = false;
  bool _isSpeaking = false;
  double? _previewScale;

  @override
  void dispose() {
    unawaited(_flutterTts.stop());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageProvider>();
    final isSpanish = language.selectedLanguage == 'es';
    final scale = _previewScale ?? language.textScaleFactor;

    return Scaffold(
      backgroundColor: _pastelPink,
      appBar: AppBar(
        leading: const AppBackButton(),
        title: Text(isSpanish ? 'Accesibilidad' : 'Accessibility'),
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
                      ? 'Personaliza la experiencia según tus necesidades.'
                      : 'Customize the experience to suit your needs.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 18),
                Card(
                  child: SwitchListTile(
                    secondary: const Icon(
                      Icons.record_voice_over_rounded,
                      color: AppColors.wine,
                    ),
                    title: Text(
                      isSpanish ? 'Lectura por voz' : 'Voice reading',
                    ),
                    subtitle: Text(
                      isSpanish
                          ? 'Activa la lectura hablada y escucha un ejemplo.'
                          : 'Enable spoken feedback and listen to a sample.',
                    ),
                    value: _voiceEnabled,
                    onChanged: _isSpeaking
                        ? null
                        : (enabled) =>
                              _toggleVoice(enabled, isSpanish: isSpanish),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _voiceEnabled && !_isSpeaking
                      ? () => _speakSample(isSpanish)
                      : null,
                  icon: const Icon(Icons.volume_up_rounded),
                  label: Text(
                    isSpanish ? 'Probar lectura por voz' : 'Test voice reading',
                  ),
                ),
                const SizedBox(height: 14),
                Card(
                  child: SwitchListTile(
                    secondary: const Icon(
                      Icons.contrast_rounded,
                      color: AppColors.wine,
                    ),
                    title: Text(isSpanish ? 'Alto contraste' : 'High contrast'),
                    subtitle: Text(
                      isSpanish
                          ? 'Aumenta la diferencia entre texto y fondo.'
                          : 'Increase the difference between text and background.',
                    ),
                    value: language.highContrast,
                    onChanged: language.setHighContrast,
                  ),
                ),
                const SizedBox(height: 14),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.text_fields_rounded,
                              color: AppColors.wine,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                isSpanish ? 'Tamaño del texto' : 'Text size',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            Text('${(scale * 100).round()}%'),
                          ],
                        ),
                        Slider(
                          value: scale,
                          min: 1.0,
                          max: 1.6,
                          divisions: 6,
                          label: '${(scale * 100).round()}%',
                          onChanged: (value) {
                            setState(() => _previewScale = value);
                          },
                          onChangeEnd: (value) async {
                            await language.setTextScaleFactor(value);
                            if (mounted) {
                              setState(() => _previewScale = null);
                            }
                          },
                        ),
                        Text(
                          isSpanish
                              ? 'Vista previa: texto más grande y fácil de leer.'
                              : 'Preview: larger, easier-to-read text.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontSize: 14 * scale),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _toggleVoice(bool enabled, {required bool isSpanish}) async {
    setState(() {
      _voiceEnabled = enabled;
      _isSpeaking = enabled;
    });

    try {
      if (enabled) {
        await _flutterTts.setLanguage(isSpanish ? 'es-ES' : 'en-US');
        await _flutterTts.setSpeechRate(0.45);
        await _flutterTts.speak(
          isSpanish
              ? 'Lectura por voz activada. Puedes probarla con el botón.'
              : 'Voice reading is enabled. You can test it with the button.',
        );
      } else {
        await _flutterTts.stop();
      }
    } on Exception {
      if (mounted) {
        setState(() {
          _voiceEnabled = false;
          _isSpeaking = false;
        });
        _showVoiceError(isSpanish);
      }
      return;
    }

    if (mounted) {
      setState(() => _isSpeaking = false);
    }
  }

  Future<void> _speakSample(bool isSpanish) async {
    setState(() => _isSpeaking = true);
    try {
      await _flutterTts.speak(
        isSpanish
            ? 'HOSPI. Tu comodidad, nuestra prioridad. Recepción está disponible las veinticuatro horas.'
            : 'HOSPI. Your comfort, our priority. Reception is available twenty-four hours a day.',
      );
    } on Exception {
      if (mounted) {
        _showVoiceError(isSpanish);
      }
    } finally {
      if (mounted) {
        setState(() => _isSpeaking = false);
      }
    }
  }

  void _showVoiceError(bool isSpanish) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isSpanish
              ? 'No fue posible iniciar la lectura por voz en este dispositivo.'
              : 'Voice reading could not be started on this device.',
        ),
      ),
    );
  }
}
