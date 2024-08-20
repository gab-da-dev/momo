import 'package:flutter/material.dart';
// import 'package:m_delivery/pages/payment.dart';
// import 'package:m_delivery/pages/map.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:momo/pages/payment.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';
import '../models/cart_provider.dart';
import '../models/checkout_provider.dart';
import '../models/store_provider.dart';
import '../network_services/map_service.dart';
import '../utils/constants.dart';
import '../widget/bottom_nav.dart';
import '../widget/custom_checkbox.dart';
import 'package:momo/pages/map.dart';

class Checkout extends StatefulWidget {
  const Checkout({Key? key}) : super(key: key);

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  final MapService mapService = MapService();
  var location;
  bool _asyncCall = false;

  @override
  void initState() {
    super.initState();


  }

  Future<dynamic> getUserLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    return _locationData;
  }

  @override
  Widget build(BuildContext context) {
    final providerCart = Provider.of<CartProvider>(context);
    final providerCheckout = Provider.of<CheckoutProvider>(context);
    final providerStore = Provider.of<StoreProvider>(context);
    // print(providerStore.store['delivery_cost']);
    return ModalProgressHUD(
      inAsyncCall: _asyncCall,
      child: Scaffold(
        bottomNavigationBar: Container(
          color: Colors.lightGreen,
          child: BottomNav(),
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'Checkout',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              LabeledCheckbox(label: 'Delivery', padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0), value: providerCheckout.isDelivery, onChanged: (value){
                // providerCheckout.setIsDelivery(value);
                setState(() {
                  _asyncCall = true;
                });
                providerCheckout.setIsDelivery(value);

                getUserLocation().then((value) {
                  location = value;
                  providerCheckout.setCoordinates('[${location.latitude}, ${location.longitude}]');
                  mapService.getReverseGeocode(location.latitude, location.longitude).then((value) {
                    providerCheckout.setAddress(value);
                    setState(() {
                      _asyncCall = false;
                    });
                  });
                  // controller.webViewController.runJavascript('setCoordinates(${location.latitude}, ${location.longitude},${providerStore.store['lat']}, ${providerStore.store['lng']})');
                });
                // print(value);
              }),
              LabeledCheckbox(label: 'Collect', padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0), value: providerCheckout.isCollect, onChanged: (value){
                providerCheckout.setIsCollect(value);
                print(value);
              }),

              if(providerCheckout.address!='')
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Delivery address', style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10,),
                    Text(providerCheckout.address),
                    const SizedBox(height: 10,),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Map()));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: kMainColor),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'Change address',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                      SizedBox(height: 10,),

                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Order Total',
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Item total'),
                    Text('R${providerCart.cartTotal.toStringAsFixed(2)}'),
                  ],
                ),
              ),
      if(providerCheckout.isDelivery)
        Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Delivery Cost'),
                    Text('R${providerStore.store['delivery_cost']}'), // TODO delivery cost from store
                  ],
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(20.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Text('Discount'),
              //       Text('20%'),
              //     ],
              //   ),
              // ),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    if(providerCheckout.isDelivery)
                    Text(
                      'R${(providerCart.cartTotal + providerStore.store['delivery_cost']).toStringAsFixed(2)}',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    if(providerCheckout.isCollect)
                      Text(
                        'R${providerCart.cartTotal}',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              if(providerCheckout.isDelivery || providerCheckout.isCollect)
              Padding(
                padding: const EdgeInsets.only(left: 18, right: 18),
                child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Payment()));
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: kMainColor),
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Center(
                          child: Text(
                            'Proceed to payment',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
