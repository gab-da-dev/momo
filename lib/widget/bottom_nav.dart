import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:badges/badges.dart' as badges;
// import 'package:m_delivery/pages/home_page.dart';
// import 'package:m_delivery/pages/login.dart';
// import 'package:m_delivery/pages/profile.dart';
import '../models/cart_provider.dart';
import '../pages/cart.dart';
import '../pages/home_page.dart';
import '../pages/profile.dart';
import '../utils/constants.dart';
// import 'package:m_delivery/models/cart_provider.dart';
import 'package:provider/provider.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GNav(
      backgroundColor: kMainColor,
      color: Colors.white,
      activeColor: Colors.white,
      tabBackgroundColor: Colors.lightGreen.shade800,
      padding: const EdgeInsets.all(16),
      gap: 8,
      tabs: [
        GButton(
          icon: Icons.home,
          text: 'home',
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const HomePage()));
          },
        ),
        GButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const Cart()));
          },
          icon: Icons.shopping_cart,
          text: 'Cart',
          leading: badges.Badge(
            badgeStyle: BadgeStyle(badgeColor: Colors.red.shade200),
            badgeContent: Consumer<CartProvider>(
              builder: (context, cart_data,_) => Text(cart_data.cartCount.toString()),
            ),
            position: BadgePosition.topEnd(top: -12, end: -12),
            child: Icon(Icons.shopping_cart),
          ),
        ),
        GButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const Profile()));
          },
          icon: Icons.settings,
          text: 'settings',
        ),
      ],
    );
  }
}
