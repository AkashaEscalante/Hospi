import 'package:flutter/material.dart';

import '../config/app_theme.dart';
import '../widgets/app_back_button.dart';
import 'map_view.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('Mapa del hotel'),
        backgroundColor: const Color(0xFFFFF0F5),
        foregroundColor: AppColors.wine,
      ),
      body: const SafeArea(child: HotelMapView()),
    );
  }
}
