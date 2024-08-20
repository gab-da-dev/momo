import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
// import 'package:m_delivery/network_services/fcm_user_token_service.dart';
// import 'package:m_delivery/network_services/product_ingredient_service.dart';
// import 'package:m_delivery/network_services/store_service.dart';
// import 'package:m_delivery/widget/productTypeListButton.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import '../models/order_provider.dart';
import '../models/product_ingredient_provider.dart';
import '../models/store_provider.dart';
import '../network_services/category_service.dart';
import '../network_services/fcm_user_token_service.dart';
import '../network_services/order_service.dart';
import '../network_services/product_ingredient_service.dart';
import '../network_services/product_service.dart';
import '../network_services/store_service.dart';
import '../widget/bottom_nav.dart';
import '../widget/order_status_tile.dart';
import '../widget/productTypeListButton.dart';
import '../widget/product_card.dart';
import 'product_view.dart';
// import 'package:m_delivery/widget/product_card.dart';
// import 'package:m_delivery/widget/bottom_nav.dart';
// import 'package:m_delivery/network_services/category_service.dart';
// import 'package:m_delivery/network_services/product_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  @override
  final CategoryService categoryService = CategoryService();
  final ProductService productsService = ProductService();
  final FcmUserTokenService fcmUserTokenService = FcmUserTokenService();
  final StoreService storeService = StoreService();
  final OrderService orderService = OrderService();
  final ProductIngredientService productIngredientService =
      ProductIngredientService();
  late List<dynamic> categories = [];
  late List<dynamic> products = [];
  late List<dynamic> productIngredients = [];
  var popularProducts;
  var store;
  var currentOrder;
  var categoryProducts;
  var isBetween;
  bool _saving = false;
  dynamic user_id;

  late FirebaseMessaging messaging;
  bool shouldShowBottomSheet = true; // Replace with your condition
  bool bottomSheetShown = false;

  @override
  void initState() {
    super.initState();
    messaging = FirebaseMessaging.instance;

    messaging.getToken().then((token) {
      fcmUserTokenService.saveFcmToken(token).then((value) => null);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print(event.notification);

      // TODO experimenting with what happens when the notification comes through
      orderService.getCurrentOrder().then((value) {
        setState(() {
          currentOrder = value;
        });

        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          var orderStore = Provider.of<OrderProvider>(context, listen: false);
          orderStore.setOrderData(currentOrder);
          // print(value['status']);
        });
      });
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');

      // TODO experimenting with what happens when the notification comes through
      orderService.getCurrentOrder().then((value) {
        setState(() {
          currentOrder = value;
        });

        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          var orderStore = Provider.of<OrderProvider>(context, listen: false);
          orderStore.setOrderData(currentOrder);
          // print(value['status']);
        });
      });
    });

    categoryService.getCategories().then((value) {
      setState(() {
        categories = value;
      });
    });

    productsService.getPopularProducts().then((value) {
      setState(() {
        popularProducts = value;
      });
    });

    productsService.getProducts().then((value) {
      setState(() {
        products = value;
        // print(products);
      });
    });

    productIngredientService.getProductIngredients().then((value) {
      setState(() {
        productIngredients = value;
      });
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        var ingredientStore =
            Provider.of<ProductIngredientProvider>(context, listen: false);
        ingredientStore.setIngredientsData(productIngredients);
        // print(value['status']);
      });
    });

    storeService.getStore().then((value) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        var providerStore = Provider.of<StoreProvider>(context, listen: false);
        providerStore.setStoreData(value);
        final now = DateTime.now();
        print(value);
        final startTime = DateTime(now.year, now.month, now.day, int.parse(value['open_time'].substring(0, 2)), int.parse(value['open_time'].substring(value['open_time'].length - 2))); // Replace with your desired start time
        final endTime = DateTime(now.year, now.month, now.day, int.parse(value['close_time'].substring(0, 2)), int.parse(value['close_time'].substring(value['close_time'].length - 2))); // Replace with your desired end time

        isBetween = now.isAfter(startTime) && now.isBefore(endTime);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!isBetween) {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  height: 200,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Store is currently closed.', style: TextStyle(fontSize: 24),),
                        Text('We open between ${value['open_time']} and ${value['close_time']}.', style: TextStyle(fontSize: 15)),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            print('Condition not met. Bottom sheet not shown.');
          }
        });
      });
    });

    orderService.getCurrentOrder().then((value) {
      setState(() {
        currentOrder = value;
      });

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        var orderStore = Provider.of<OrderProvider>(context, listen: false);
        orderStore.setOrderData(currentOrder);
      });
    });


  }

  Widget build(BuildContext context) {
    return ModalProgressHUD(
      opacity: 0.5,
      inAsyncCall: _saving,
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: BottomNav(),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                    child: Text(
                      "Harry's Fast Food",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Divider(
                    indent: 20,
                    endIndent: 20,
                  ),
                  if (currentOrder != null) ...[
                    if (currentOrder['status'] != null) OrderStatusTile(),
                  ],
                  Row(
                    children: [],
                  ),
                  PhysicalModel(
                    color: Colors.white,
                    shadowColor: Colors.black,
                    elevation: 5,
                    child: Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      margin: EdgeInsets.only(bottom: 10),
                      height: 40,
                      child: categories == null
                          ? Center(child: CircularProgressIndicator())
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: categories.length,
                              itemBuilder: (context, index) {
                                final cat = categories[index];
                                return ProductTypeListButton(
                                  label: cat.keys
                                      .toString()
                                      .substring(1)
                                      .replaceRange(
                                          categories[index]
                                                  .keys
                                                  .toString()
                                                  .length -
                                              2,
                                          null,
                                          ''),
                                  productList: cat[categories[index]
                                      .keys
                                      .toString()
                                      .substring(1)
                                      .replaceRange(
                                          categories[index]
                                                  .keys
                                                  .toString()
                                                  .length -
                                              2,
                                          null,
                                          '')],
                                );
                              },
                            ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              )),

              Expanded(
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        'Most popular',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: GestureDetector(
                        onTap: () {
                          // print(popularProducts['price']); return;

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductView(
                                        product: popularProducts,
                                      )));
                        },
                        child: popularProducts == null
                            ? Center(child: CircularProgressIndicator())
                            : ProductCard(
                                product_name: popularProducts['name'],
                                product_image: popularProducts['image'],
                                product_duration: popularProducts['prep_time'],
                                product_price: popularProducts['price'],
                                heroTag: 'popular_image',
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    for (int x = 0; x <= categories.length - 1; x++) ...[
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          categories[x]
                              .keys
                              .toString()
                              .substring(1)
                              .replaceRange(
                                  categories[x].keys.toString().length - 2,
                                  null,
                                  '')
                              .toString(),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CarouselSlider(
                          options: CarouselOptions(
                            height: 260.0,
                            enlargeCenterPage: true,
                            enableInfiniteScroll: false,
                          ),
                          items: [
                            for (int y = 0;
                                y <=
                                    categories[x][categories[x]
                                                .keys
                                                .toString()
                                                .substring(1)
                                                .replaceRange(
                                                    categories[x]
                                                            .keys
                                                            .toString()
                                                            .length -
                                                        2,
                                                    null,
                                                    '')]
                                            .length -
                                        1;
                                y++) ...[
                              Builder(
                                builder: (BuildContext context) {
                                  return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => ProductView(
                                                    product: categories[
                                                        x][categories[
                                                            x]
                                                        .keys
                                                        .toString()
                                                        .substring(1)
                                                        .replaceRange(
                                                            categories[x]
                                                                    .keys
                                                                    .toString()
                                                                    .length -
                                                                2,
                                                            null,
                                                            '')][y])));
                                      },
                                      child: ProductCard(
                                        index_key: categories[x],
                                        product_name: categories[x][
                                            categories[x]
                                                .keys
                                                .toString()
                                                .substring(1)
                                                .replaceRange(
                                                    categories[x]
                                                            .keys
                                                            .toString()
                                                            .length -
                                                        2,
                                                    null,
                                                    '')][y]['name'],
                                        product_image: categories[x][
                                            categories[x]
                                                .keys
                                                .toString()
                                                .substring(1)
                                                .replaceRange(
                                                    categories[x]
                                                            .keys
                                                            .toString()
                                                            .length -
                                                        2,
                                                    null,
                                                    '')][y]['image'],
                                        product_duration: categories[x][
                                            categories[x]
                                                .keys
                                                .toString()
                                                .substring(1)
                                                .replaceRange(
                                                    categories[x]
                                                            .keys
                                                            .toString()
                                                            .length -
                                                        2,
                                                    null,
                                                    '')][y]['prep_time'],
                                        product_price: categories[x][
                                            categories[x]
                                                .keys
                                                .toString()
                                                .substring(1)
                                                .replaceRange(
                                                    categories[x]
                                                            .keys
                                                            .toString()
                                                            .length -
                                                        2,
                                                    null,
                                                    '')][y]['price'],
                                        heroTag:
                                            '${categories[x][categories[x].keys.toString().substring(1).replaceRange(categories[x].keys.toString().length - 2, null, '')][y]['image']}_${categories[x].keys.toString().substring(1).replaceRange(categories[x].keys.toString().length - 2, null, '')}',
                                      ));
                                },
                              )
                            ]
                          ])
                    ],
                  ],
                ),
              )

              // page body
            ],
          ),
        ),
      ),
    );
  }
}
