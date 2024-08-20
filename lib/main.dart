import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:m_delivery/models/product_ingredient_provider.dart';
import 'package:momo/pages/login.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/cart_provider.dart';
import 'models/checkout_provider.dart';
import 'models/order_provider.dart';
import 'models/product_ingredient_provider.dart';
import 'models/store_provider.dart';
import 'models/user_provider.dart';
import 'pages/home_page.dart';
// import 'package:m_delivery/models/cart_provider.dart';
// import 'package:m_delivery/models/checkout_provider.dart';
// import 'package:m_delivery/pages/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.getInitialMessage();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers:[
        ChangeNotifierProvider(
        create:  (context) => CartProvider(),),
          ChangeNotifierProvider(
            create:  (context) => CheckoutProvider(),),
          ChangeNotifierProvider(
            create:  (context) => StoreProvider(),),
          ChangeNotifierProvider(
            create:  (context) => UserProvider(),),
          ChangeNotifierProvider(
            create:  (context) => OrderProvider(),),
          ChangeNotifierProvider(
            create:  (context) => ProductIngredientProvider(),),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: CheckAuth(),
        ),
      );

  }
}

class CheckAuth extends StatefulWidget {
  @override
  _CheckAuthState createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  bool isAuth = false;
  @override
  void initState() {
    _checkIfLoggedIn();
    super.initState();
  }

  void _checkIfLoggedIn() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    if(token != null){
      setState(() {
        isAuth = true;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    Widget child;
    final providerUser = Provider.of<UserProvider>(context);
    if (isAuth) {
      child = const HomePage();
      // providerUser.setUserData(value['data']['user']);
    } else {
      child = const Login();
    }
    return Scaffold(
      body: child,
    );
  }
}