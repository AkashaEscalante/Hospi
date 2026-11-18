import 'dart:ui_web' as ui_web;

import 'package:flutter/widgets.dart';
import 'package:web/web.dart' as web;

const String _viewType = 'hospi-hotel-map';
bool _viewFactoryRegistered = false;

class HotelMapView extends StatelessWidget {
  const HotelMapView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!_viewFactoryRegistered) {
      ui_web.platformViewRegistry.registerViewFactory(_viewType, (viewId) {
        return web.HTMLIFrameElement()
          ..src = 'assets/assets/web/mapa_hotel.html'
          ..style.border = '0'
          ..style.height = '100%'
          ..style.width = '100%'
          ..title = 'Mapa accesible del hotel';
      });
      _viewFactoryRegistered = true;
    }

    return const HtmlElementView(viewType: _viewType);
  }
}
