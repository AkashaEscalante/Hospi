import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HotelMapView extends StatefulWidget {
  const HotelMapView({super.key});

  @override
  State<HotelMapView> createState() => _HotelMapViewState();
}

class _HotelMapViewState extends State<HotelMapView> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFFFF0F5))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) {
              setState(() => _isLoading = false);
            }
          },
        ),
      )
      ..loadFlutterAsset('assets/web/mapa_hotel.html');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        WebViewWidget(controller: _controller),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(color: Color(0xFFE11D48)),
          ),
      ],
    );
  }
}
