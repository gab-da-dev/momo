import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../models/checkout_provider.dart';
import '../models/store_provider.dart';
import '../utils/constants.dart';
import '../widget/bottom_nav.dart';
import 'package:location/location.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class Map extends StatefulWidget {
  const Map({Key? key}) : super(key: key);

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  late WebViewController _controller;
  LocationData? location;
  bool _isControllerInitialized = false;

  @override
  void initState() {
    print('Current working directory: ${Directory.current.path}');
    super.initState();
    _initializeController(context).then((_) {
      setState(() {
        _isControllerInitialized = true;
      });
    });
    _getUserLocation();
  }

  Future<void> _initializeController(BuildContext context) async {
    final providerStore = Provider.of<StoreProvider>(context, listen: false);
    final providerCheckout = Provider.of<CheckoutProvider>(context, listen: false);

    final htmlContent = await rootBundle.loadString('assets/web/map.html');

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            if (location != null) {
              _controller.runJavaScript(
                'setCoordinates(${location!.latitude}, ${location!.longitude}, ${providerStore.store['lat']}, ${providerStore.store['lng']})',
              );
            }
          },
        ),
      )
      ..loadUrl(Uri.dataFromString(
        htmlContent,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8'),
      ).toString());
  }

  Future<void> _getUserLocation() async {
    Location locationService = Location();

    bool serviceEnabled = await locationService.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locationService.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    PermissionStatus permissionGranted = await locationService.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationService.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    location = await locationService.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNav(),
      body: SafeArea(
        child: Column(children: [
          Expanded(
            flex: 3,
            child: _isControllerInitialized
                ? WebViewWidget(controller: _controller)
                : const Center(child: CircularProgressIndicator()),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: kMainColor,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Save location',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

extension on WebViewController {
  loadUrl(String string) {}
}
