import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../models/checkout_provider.dart';
import '../models/order_provider.dart';
import '../utils/constants.dart';
import '../widget/bottom_nav.dart';

class DeliveryMap extends StatefulWidget {
  const DeliveryMap({Key? key}) : super(key: key);

  @override
  State<DeliveryMap> createState() => _DeliveryMapState();
}

class _DeliveryMapState extends State<DeliveryMap> {
  late WebViewController _controller;
  int loadingPercentage = 0;
  String? duration;
  String? distance;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            final providerOrder = Provider.of<OrderProvider>(context, listen: false);
            _controller.runJavaScript(
              'init(${providerOrder.order['latitude']}, ${providerOrder.order['longitude']}, ${providerOrder.order['driver_latitude']}, ${providerOrder.order['driver_longitude']})',
            );
          },
        ),
      )
      ..loadRequest(Uri.parse('assets/web/delivery_map.html'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('clicked');
          Navigator.pop(context);
        },
        backgroundColor: Colors.lightGreen,
        child: const Icon(Icons.phone),
      ),
      bottomNavigationBar: BottomNav(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: WebViewWidget(controller: _controller),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.face, size: 30),
                          const SizedBox(width: 50),
                          Column(
                            children: const [
                              Text('Gabriel'),
                              Text('Molopo'),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.watch_later_outlined, size: 30),
                          const SizedBox(width: 50),
                          Text('Arrive in $duration min'),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.directions, size: 30),
                          const SizedBox(width: 50),
                          Text('$distance km away'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
