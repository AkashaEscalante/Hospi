import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const HospiApp());

const Color rosa = Color(0xFFDDAEBB);
const Color rosaFuerte = Color(0xFFB9788D);
const Color crema = Color(0xFFFFF9F4);
const Color dorado = Color(0xFFB99A76);
const Color vino = Color(0xFF72515E);

final ValueNotifier<String> idioma = ValueNotifier('es');
final ValueNotifier<double> escalaTexto = ValueNotifier(1.0);
final ValueNotifier<bool> altoContraste = ValueNotifier(false);

String tr(String es, String en) => idioma.value == 'en' ? en : es;

Future<void> cambiarIdioma(String lang) async {
  idioma.value = lang;
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('idioma_hospi', lang);
}

class HospiApp extends StatefulWidget {
  const HospiApp({super.key});

  @override
  State<HospiApp> createState() => _HospiAppState();
}

class _HospiAppState extends State<HospiApp> {
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarIdioma();
  }

  Future<void> cargarIdioma() async {
    final prefs = await SharedPreferences.getInstance();
    idioma.value = prefs.getString('idioma_hospi') ?? 'es';
    if (mounted) setState(() => cargando = false);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: escalaTexto,
      builder: (context, escala, _) {
        return ValueListenableBuilder<bool>(
          valueListenable: altoContraste,
          builder: (context, contraste, _) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'HOSPI Hotel',
              theme: ThemeData(
                useMaterial3: true,
                fontFamily: 'Georgia',
                scaffoldBackgroundColor: contraste ? Colors.white : crema,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: rosaFuerte,
                  brightness: Brightness.light,
                ),
                textTheme: ThemeData.light().textTheme.apply(
                  fontSizeFactor: escala,
                  bodyColor: contraste ? Colors.black : vino,
                  displayColor: contraste ? Colors.black : vino,
                ),
                appBarTheme: const AppBarTheme(
                  backgroundColor: crema,
                  foregroundColor: vino,
                  elevation: 0,
                  centerTitle: false,
                ),
              ),
              home: cargando ? const PantallaCarga() : const BienvenidaPage(),
            );
          },
        );
      },
    );
  }
}

class PantallaCarga extends StatelessWidget {
  const PantallaCarga({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
    body: Center(child: CircularProgressIndicator(color: rosaFuerte)),
  );
}

class BienvenidaPage extends StatelessWidget {
  const BienvenidaPage({super.key});

  Future<void> entrar(BuildContext context, String lang) async {
    await cambiarIdioma(lang);
    if (!context.mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const InicioPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 110,
                  width: 110,
                  decoration: BoxDecoration(
                    color: rosa.withOpacity(.35),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.hotel_rounded, color: vino, size: 58),
                ),
                const SizedBox(height: 22),
                const Text(
                  'H O S P I',
                  style: TextStyle(
                    color: vino,
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 5,
                  ),
                ),
                const Text(
                  'H O T E L',
                  style: TextStyle(color: dorado, letterSpacing: 5),
                ),
                const SizedBox(height: 35),
                const Text(
                  'Bienvenido / Welcome',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: vino,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Selecciona tu idioma para continuar.\n'
                  'Select your language to continue.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF88747A), height: 1.6),
                ),
                const SizedBox(height: 35),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => entrar(context, 'es'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: rosaFuerte,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(19),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17),
                      ),
                    ),
                    child: const Text(
                      '🇲🇽  Español',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => entrar(context, 'en'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: vino,
                      side: const BorderSide(color: rosaFuerte),
                      padding: const EdgeInsets.all(19),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17),
                      ),
                    ),
                    child: const Text(
                      '🇺🇸  English',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ),
                const SizedBox(height: 35),
                const Text(
                  'HOSPI Hotel • Your stay, our priority',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: dorado, fontSize: 11),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InicioPage extends StatelessWidget {
  const InicioPage({super.key});

  void abrir(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: idioma,
      builder: (context, lang, _) {
        final en = lang == 'en';
        return Scaffold(
          appBar: AppBar(
            actions: [
              TextButton(
                onPressed: () => cambiarIdioma(en ? 'es' : 'en'),
                child: Text(
                  en ? '🇲🇽 ES' : '🇺🇸 EN',
                  style: const TextStyle(
                    color: vino,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Column(
                      children: [
                        Icon(Icons.hotel_rounded, color: vino, size: 65),
                        SizedBox(height: 10),
                        Text(
                          'H O S P I',
                          style: TextStyle(
                            fontSize: 32,
                            color: vino,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 3,
                          ),
                        ),
                        Text(
                          'H O T E L',
                          style: TextStyle(color: dorado, letterSpacing: 4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 35),
                  Text(
                    en ? 'Welcome to HOSPI' : 'Bienvenido a HOSPI',
                    style: const TextStyle(
                      fontSize: 27,
                      color: vino,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    en
                        ? 'Your stay begins here. Discover our spaces and services.'
                        : 'Tu experiencia de descanso comienza aquí. Descubre nuestros espacios y servicios.',
                    style: const TextStyle(
                      color: Color(0xFF88747A),
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF1D5DC), Color(0xFFE8BFC8)],
                      ),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.spa_rounded, color: vino, size: 35),
                        const SizedBox(height: 12),
                        Text(
                          en
                              ? 'A special place for you'
                              : 'Un lugar especial para ti',
                          style: const TextStyle(
                            color: vino,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          en
                              ? 'Comfort, tranquility and attention to every detail.'
                              : 'Comodidad, tranquilidad y atención en cada detalle.',
                          style: const TextStyle(color: vino, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    en ? 'Explore our hotel' : 'Explora nuestro hotel',
                    style: const TextStyle(
                      color: vino,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 18),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 1.15,
                    children: [
                      OpcionCard(
                        icono: Icons.map_rounded,
                        titulo: en ? 'Hotel map' : 'Mapa del hotel',
                        detalle: en
                            ? 'Find your destination'
                            : 'Encuentra tu destino',
                        onTap: () => abrir(context, const MapaPage()),
                      ),
                      OpcionCard(
                        icono: Icons.accessible_rounded,
                        titulo: en ? 'Accessibility' : 'Accesibilidad',
                        detalle: en
                            ? 'Options for everyone'
                            : 'Opciones para todos',
                        onTap: () => abrir(context, const AccesibilidadPage()),
                      ),
                      OpcionCard(
                        icono: Icons.info_outline_rounded,
                        titulo: en ? 'Information' : 'Información',
                        detalle: en
                            ? 'Our services'
                            : 'Conoce nuestros servicios',
                        onTap: () => abrir(context, const InformacionPage()),
                      ),
                      OpcionCard(
                        icono: Icons.support_agent_rounded,
                        titulo: en ? 'Help' : 'Ayuda',
                        detalle: en
                            ? 'We are here to help'
                            : 'Estamos para ayudarte',
                        onTap: () => abrir(context, const AyudaPage()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Center(
                    child: Text(
                      en
                          ? 'HOSPI Hotel • Your stay, our priority'
                          : 'HOSPI Hotel • Tu estancia, nuestra prioridad',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: dorado, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class OpcionCard extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String detalle;
  final VoidCallback onTap;

  const OpcionCard({
    super.key,
    required this.icono,
    required this.titulo,
    required this.detalle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: rosa, width: 1.3),
          boxShadow: [
            BoxShadow(
              color: rosa.withOpacity(.13),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icono, color: rosaFuerte, size: 32),
            const SizedBox(height: 9),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: vino,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              detalle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF88747A), fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}

// MAPA DEL HOTEL: plano visual de dos plantas con selección de destinos.

class MapaPage extends StatefulWidget {
  const MapaPage({super.key});

  @override
  State<MapaPage> createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  int piso = 0;
  String destino = 'Recepción';
  final FlutterTts voz = FlutterTts();

  final List<String> plantaBaja = [
    'Recepción',
    'Restaurante',
    'Baños',
    'Alberca',
    'Elevadores',
    'Jardín',
  ];

  final List<String> segundoPiso = [
    'Habitación 201',
    'Habitación 202',
    'Habitación 203',
    'Habitación 204',
    'Habitación 205',
    'Habitación 206',
    'Baños',
    'Elevadores',
  ];

  List<String> get lugares => piso == 0
      ? plantaBaja.map(traducirLugar).toList()
      : segundoPiso.map(traducirLugar).toList();

  String traducirLugar(String lugar) {
    const traducciones = {
      'Recepción': 'Reception',
      'Restaurante': 'Restaurant',
      'Baños': 'Restrooms',
      'Alberca': 'Swimming pool',
      'Elevadores': 'Elevators',
      'Jardín': 'Garden',
      'Habitación 201': 'Room 201',
      'Habitación 202': 'Room 202',
      'Habitación 203': 'Room 203',
      'Habitación 204': 'Room 204',
      'Habitación 205': 'Room 205',
      'Habitación 206': 'Room 206',
    };
    return idioma.value == 'en' ? (traducciones[lugar] ?? lugar) : lugar;
  }

  String nombreOriginal(String visible) {
    for (final item in [...plantaBaja, ...segundoPiso]) {
      if (traducirLugar(item) == visible) return item;
    }
    return visible;
  }

  IconData obtenerIcono(String lugar) {
    if (lugar.contains('Recepción') || lugar.contains('Reception'))
      return Icons.room_service_rounded;
    if (lugar.contains('Restaurante') || lugar.contains('Restaurant'))
      return Icons.restaurant_rounded;
    if (lugar.contains('Baños') || lugar.contains('Restrooms'))
      return Icons.wc_rounded;
    if (lugar.contains('Alberca') || lugar.contains('pool'))
      return Icons.pool_rounded;
    if (lugar.contains('Elevadores') || lugar.contains('Elevators'))
      return Icons.elevator_rounded;
    if (lugar.contains('Jardín') || lugar.contains('Garden'))
      return Icons.local_florist_rounded;
    return Icons.bed_rounded;
  }

  Future<void> escucharRuta() async {
    final nombre = traducirLugar(destino);
    final mensaje = idioma.value == 'en'
        ? 'Your destination is $nombre. Follow the central hallway from the main entrance. Use the elevator if you need to change floors.'
        : 'Tu destino es $nombre. Sigue el pasillo central desde la entrada principal. Utiliza el elevador si necesitas cambiar de planta.';
    try {
      await voz.setLanguage(idioma.value == 'en' ? 'en-US' : 'es-MX');
      await voz.setSpeechRate(.45);
      await voz.speak(mensaje);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            tr(
              'No se pudo iniciar el asistente de voz.',
              'The voice assistant could not be started.',
            ),
          ),
        ),
      );
    }
  }

  Widget tarjetaPlano(String lugar) {
    final seleccionado = destino == nombreOriginal(lugar);
    return InkWell(
      onTap: () => setState(() => destino = nombreOriginal(lugar)),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 88,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
        decoration: BoxDecoration(
          color: seleccionado ? const Color(0xFFF1D5DC) : crema,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: seleccionado ? rosaFuerte : rosa,
            width: seleccionado ? 2.5 : 1,
          ),
          boxShadow: seleccionado
              ? [BoxShadow(color: rosaFuerte.withOpacity(.18), blurRadius: 8)]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(obtenerIcono(lugar), color: vino, size: 27),
            const SizedBox(height: 6),
            Text(
              lugar,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: vino,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
            if (seleccionado)
              const Icon(Icons.check_circle, color: rosaFuerte, size: 13),
          ],
        ),
      ),
    );
  }

  Widget construirPlano() {
    final izquierda = piso == 0
        ? ['Recepción', 'Restaurante', 'Jardín']
        : ['Habitación 201', 'Habitación 202', 'Habitación 203', 'Baños'];
    final derecha = piso == 0
        ? ['Alberca', 'Baños', 'Elevadores']
        : ['Habitación 204', 'Habitación 205', 'Habitación 206', 'Elevadores'];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: rosa, width: 1.4),
        boxShadow: [
          BoxShadow(
            color: rosa.withOpacity(.12),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            piso == 0
                ? tr('PLANTA BAJA', 'GROUND FLOOR')
                : tr('SEGUNDO PISO', 'SECOND FLOOR'),
            style: const TextStyle(
              color: vino,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.5,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F0EC),
              border: Border.all(color: dorado),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.door_front_door_rounded,
                  color: dorado,
                  size: 25,
                ),
                const SizedBox(height: 3),
                Text(
                  tr('ENTRADA PRINCIPAL', 'MAIN ENTRANCE'),
                  style: const TextStyle(
                    color: vino,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 13),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: izquierda
                      .map(
                        (lugar) => Padding(
                          padding: const EdgeInsets.only(bottom: 9),
                          child: tarjetaPlano(traducirLugar(lugar)),
                        ),
                      )
                      .toList(),
                ),
              ),
              Container(
                width: 43,
                height: piso == 0 ? 285 : 380,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E7E9),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.symmetric(
                    vertical: BorderSide(color: rosaFuerte.withOpacity(.45)),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.arrow_upward_rounded,
                      color: rosaFuerte,
                      size: 18,
                    ),
                    const SizedBox(height: 12),
                    RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        tr('PASILLO', 'HALLWAY'),
                        style: const TextStyle(
                          color: vino,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Icon(
                      Icons.arrow_downward_rounded,
                      color: rosaFuerte,
                      size: 18,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: derecha
                      .map(
                        (lugar) => Padding(
                          padding: const EdgeInsets.only(bottom: 9),
                          child: tarjetaPlano(traducirLugar(lugar)),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: rosa.withOpacity(.22),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.elevator_rounded, color: vino, size: 19),
                const SizedBox(width: 7),
                Flexible(
                  child: Text(
                    tr(
                      'Zona de circulación y elevadores',
                      'Hallway and elevator area',
                    ),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: vino,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    voz.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: idioma,
      builder: (context, lang, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              tr('Mapa del hotel', 'Hotel map'),
              style: const TextStyle(color: vino),
            ),
            actions: [
              TextButton(
                onPressed: () => cambiarIdioma(lang == 'en' ? 'es' : 'en'),
                child: Text(
                  lang == 'en' ? 'ES' : 'EN',
                  style: const TextStyle(color: vino),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr('Explora nuestro hotel', 'Explore our hotel'),
                  style: const TextStyle(
                    color: vino,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  tr(
                    'Selecciona una planta y toca el espacio al que deseas ir.',
                    'Choose a floor and tap the place you want to visit.',
                  ),
                  style: const TextStyle(color: Color(0xFF88747A)),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: PisoButton(
                        texto: tr('Planta baja', 'Ground floor'),
                        seleccionado: piso == 0,
                        onTap: () => setState(() {
                          piso = 0;
                          if (obtenerPiso(destino) != 0) destino = 'Recepción';
                        }),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: PisoButton(
                        texto: tr('Segundo piso', 'Second floor'),
                        seleccionado: piso == 1,
                        onTap: () => setState(() {
                          piso = 1;
                          if (obtenerPiso(destino) != 1)
                            destino = 'Habitación 201';
                        }),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Icon(Icons.architecture_rounded, color: rosaFuerte),
                    const SizedBox(width: 8),
                    Text(
                      tr('Distribución del hotel', 'Hotel floor plan'),
                      style: const TextStyle(
                        color: vino,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                construirPlano(),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1D5DC),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on_rounded, color: vino),
                          const SizedBox(width: 8),
                          Text(
                            tr('Tu destino', 'Your destination'),
                            style: const TextStyle(
                              color: vino,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        traducirLugar(destino),
                        style: const TextStyle(
                          color: vino,
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        tr(
                          'El espacio seleccionado aparece resaltado en el plano. Sigue el pasillo central desde la entrada principal.',
                          'The selected space is highlighted on the plan. Follow the central hallway from the main entrance.',
                        ),
                        style: const TextStyle(color: vino, height: 1.5),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: escucharRuta,
                          icon: const Icon(Icons.volume_up_rounded),
                          label: Text(
                            tr('Escuchar indicaciones', 'Listen to directions'),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: rosaFuerte,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  tr(
                    'Plano ilustrativo de un hotel ficticio. No está a escala y las indicaciones son orientativas.',
                    'Illustrative plan of a fictional hotel. Not to scale; directions are for demonstration.',
                  ),
                  style: const TextStyle(
                    color: Color(0xFF88747A),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  int obtenerPiso(String lugar) =>
      lugar.startsWith('Habitación') || lugar.startsWith('Room') ? 1 : 0;
}

class PisoButton extends StatelessWidget {
  final String texto;
  final bool seleccionado;
  final VoidCallback onTap;

  const PisoButton({
    super.key,
    required this.texto,
    required this.seleccionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: seleccionado ? rosaFuerte : Colors.white,
        foregroundColor: seleccionado ? Colors.white : vino,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(color: rosa),
        ),
      ),
      child: Text(texto),
    );
  }
}

// ACCESIBILIDAD

class AccesibilidadPage extends StatelessWidget {
  const AccesibilidadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr('Accesibilidad', 'Accessibility'))),
      body: ValueListenableBuilder<double>(
        valueListenable: escalaTexto,
        builder: (context, escala, _) {
          return ValueListenableBuilder<bool>(
            valueListenable: altoContraste,
            builder: (context, contraste, _) {
              return ListView(
                padding: const EdgeInsets.all(22),
                children: [
                  const Icon(
                    Icons.accessible_rounded,
                    size: 65,
                    color: rosaFuerte,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    tr(
                      'Personaliza tu experiencia',
                      'Customize your experience',
                    ),
                    style: const TextStyle(
                      color: vino,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: rosa),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tr('Tamaño del texto', 'Text size'),
                          style: const TextStyle(
                            color: vino,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Slider(
                          value: escala,
                          min: 1,
                          max: 1.6,
                          divisions: 6,
                          activeColor: rosaFuerte,
                          label: '${(escala * 100).round()}%',
                          onChanged: (v) => escalaTexto.value = v,
                        ),
                        Text(
                          tr('Vista previa del texto', 'Text preview'),
                          style: TextStyle(
                            color: contraste ? Colors.black : vino,
                            fontSize: 16 * escala,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: rosa),
                    ),
                    child: SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      activeThumbColor: rosaFuerte,
                      title: Text(
                        tr('Alto contraste', 'High contrast'),
                        style: const TextStyle(
                          color: vino,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        tr(
                          'Usar colores más contrastantes.',
                          'Use higher-contrast colors.',
                        ),
                      ),
                      value: contraste,
                      onChanged: (v) => altoContraste.value = v,
                    ),
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton.icon(
                    onPressed: () {
                      escalaTexto.value = 1;
                      altoContraste.value = false;
                    },
                    icon: const Icon(Icons.refresh),
                    label: Text(tr('Restablecer opciones', 'Reset options')),
                    style: OutlinedButton.styleFrom(foregroundColor: vino),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    tr(
                      'Este plano muestra elevadores como parte de una demostración. Consulta con recepción para confirmar las condiciones reales de accesibilidad.',
                      'This demonstration plan shows elevators. Ask reception to confirm actual accessibility conditions.',
                    ),
                    style: const TextStyle(
                      color: Color(0xFF88747A),
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

// INFORMACIÓN DEL HOTEL

class InformacionPage extends StatelessWidget {
  const InformacionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr('Información', 'Information'))),
      body: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          Text(
            tr('Conoce HOSPI', 'Discover HOSPI'),
            style: const TextStyle(
              color: vino,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            tr(
              'Consulta los servicios y horarios de nuestro hotel.',
              'Explore our hotel services and opening hours.',
            ),
            style: const TextStyle(color: Color(0xFF88747A)),
          ),
          const SizedBox(height: 22),
          ServicioCard(
            icono: Icons.support_agent,
            titulo: tr('Recepción', 'Reception'),
            horario: tr('Disponible las 24 horas', 'Open 24 hours'),
          ),
          ServicioCard(
            icono: Icons.restaurant,
            titulo: tr('Restaurante', 'Restaurant'),
            horario: tr('7:00 a 22:00 horas', '7:00 AM to 10:00 PM'),
          ),
          ServicioCard(
            icono: Icons.pool,
            titulo: tr('Alberca', 'Swimming pool'),
            horario: tr('8:00 a 20:00 horas', '8:00 AM to 8:00 PM'),
          ),
          ServicioCard(
            icono: Icons.bed,
            titulo: tr('Habitaciones', 'Guest rooms'),
            horario: tr('Servicio de alojamiento', 'Accommodation service'),
          ),
          ServicioCard(
            icono: Icons.elevator,
            titulo: tr('Elevadores', 'Elevators'),
            horario: tr('Acceso entre plantas', 'Access between floors'),
          ),
          const SizedBox(height: 15),
          Text(
            tr(
              'Los horarios son datos ficticios de demostración.',
              'These are fictional demonstration hours.',
            ),
            style: const TextStyle(color: Color(0xFF88747A), fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class ServicioCard extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String horario;

  const ServicioCard({
    super.key,
    required this.icono,
    required this.titulo,
    required this.horario,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: rosa),
      ),
      child: Row(
        children: [
          Icon(icono, color: rosaFuerte, size: 32),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    color: vino,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  horario,
                  style: const TextStyle(
                    color: Color(0xFF88747A),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// CENTRO DE AYUDA

class AyudaPage extends StatefulWidget {
  const AyudaPage({super.key});

  @override
  State<AyudaPage> createState() => _AyudaPageState();
}

class _AyudaPageState extends State<AyudaPage> {
  int motivo = 0;
  bool solicitudEnviada = false;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: idioma,
      builder: (context, lang, _) {
        final motivos = lang == 'en'
            ? [
                'I need help finding a location',
                'I need accessibility assistance',
                'I have a question about services',
                'I need to contact reception',
              ]
            : [
                'Necesito ayuda con una ubicación',
                'Necesito asistencia de accesibilidad',
                'Tengo una pregunta sobre los servicios',
                'Necesito contactar con recepción',
              ];

        return Scaffold(
          appBar: AppBar(title: Text(tr('Centro de ayuda', 'Help center'))),
          body: ListView(
            padding: const EdgeInsets.all(22),
            children: [
              const Icon(
                Icons.support_agent_rounded,
                color: rosaFuerte,
                size: 70,
              ),
              const SizedBox(height: 15),
              Text(
                tr('¿Cómo podemos ayudarte?', 'How can we help you?'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: vino,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                tr(
                  'Selecciona el motivo de tu solicitud.',
                  'Choose the reason for your request.',
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF88747A)),
              ),
              const SizedBox(height: 25),
              DropdownButtonFormField<int>(
                value: motivo,
                isExpanded: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                items: List.generate(
                  motivos.length,
                  (i) => DropdownMenuItem(
                    value: i,
                    child: Text(motivos[i], overflow: TextOverflow.ellipsis),
                  ),
                ),
                onChanged: (v) {
                  if (v != null)
                    setState(() {
                      motivo = v;
                      solicitudEnviada = false;
                    });
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => setState(() => solicitudEnviada = true),
                  icon: const Icon(Icons.send),
                  label: Text(tr('Solicitar asistencia', 'Request assistance')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: rosaFuerte,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(17),
                  ),
                ),
              ),
              if (solicitudEnviada) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(17),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1D5DC),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    tr(
                      'Tu solicitud quedó registrada en esta demostración. Para recibir ayuda real, comunícate directamente con recepción.',
                      'Your request was recorded in this demonstration. To receive real assistance, contact reception directly.',
                    ),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: vino, height: 1.5),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              Text(
                tr(
                  'Esta función es una simulación. Todavía no envía notificaciones al personal del hotel.',
                  'This is a simulation. It does not send notifications to hotel staff.',
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF88747A), fontSize: 11),
              ),
            ],
          ),
        );
      },
    );
  }
}
