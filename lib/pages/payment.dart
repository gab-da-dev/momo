import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../models/cart_provider.dart';
import '../models/checkout_provider.dart';
import '../models/order_provider.dart';
import '../models/store_provider.dart';
import '../network_services/payment_service.dart';
import '../widget/bottom_nav.dart';
import 'package:http/http.dart' as http;
import '../pages/success.dart';
// import 'package:webview_flutter/webview_flutter.dart';

class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}


class _PaymentState extends State<Payment> {
  final PaymentService paymentService = PaymentService();
  bool _asyncCall = false;
  late WebViewController _controller;

  Future<void> _initializeController(BuildContext context) async {
    final providerStore = Provider.of<StoreProvider>(context, listen: false);
    final providerCheckout = Provider.of<CheckoutProvider>(context, listen: false);
    final providerCart = Provider.of<CartProvider>(context, listen: false);

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
      ..addJavaScriptChannel(
        'JavascriptChannel',
        onMessageReceived: (JavaScriptMessage message) async {
          setState(() {
            _asyncCall = true;
          });

          SharedPreferences localStorage = await SharedPreferences.getInstance();
          dynamic user = json.decode(localStorage.getString('user').toString());

          paymentService.getPaymentToken(
            message.message,
            providerCart.getCartJson(),
            user["id"],
            providerCheckout.coordinates,
            providerCheckout.address,
          ).then((value) {
            providerCart.clearCart();
            if (value['status'] == 'successful') {
              setState(() {
                _asyncCall = false;
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Success(),
                ),
              );
            }
          });
        },
      )
      ..loadRequest(Uri.parse('assets/web/delivery_map.html'));
  }


  @override
  Widget build(BuildContext context) {
    final providerCart = Provider.of<CartProvider>(context);
    final providerCheckout = Provider.of<CheckoutProvider>(context);
    final providerStore = Provider.of<StoreProvider>(context);

    return ModalProgressHUD(
      inAsyncCall: _asyncCall,
      child: Scaffold(
        bottomNavigationBar: BottomNav(),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child:  WebViewWidget(controller: _controller),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handlePageFinished() {
    final providerCart = Provider.of<CartProvider>(context, listen: false);
    final providerCheckout = Provider.of<CheckoutProvider>(context, listen: false);
    final providerStore = Provider.of<StoreProvider>(context, listen: false);

    if (providerCheckout.isDelivery) {
      _controller.runJavaScript('setAmount(${providerCart.cartTotal + providerStore.store['delivery_cost']})');
    }
    if (providerCheckout.isCollect) {
      _controller.runJavaScript('setAmount(${providerCart.cartTotal})');
    }
  }
}
