import 'package:badges/badges.dart' as badges;
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:momo/pages/profile.dart';
// import 'package:m_delivery/pages/checkout.dart';
// import 'package:m_delivery/pages/profile.dart';
// import 'package:m_delivery/utils/constants.dart';
import 'package:provider/provider.dart';
// import 'package:m_delivery/models/cart_provider.dart';
// import 'package:m_delivery/widget/order_product_tile.dart';

import '../models/cart_provider.dart';
import '../utils/constants.dart';
import '../widget/order_product_tile.dart';
import 'checkout.dart';
import 'home_page.dart';

class Cart extends StatelessWidget {
  const Cart({Key? key}) : super(key: key);

  get price => null;

  get quantity => null;

  get name => null;

  get image_url => null;

  get totalPrice => null;

  set totalPrice(totalPrice) {}

  

  @override
  Widget build(BuildContext context) {
    final providerCart = Provider.of<CartProvider>(context);
    return Scaffold(
      bottomNavigationBar: Container(
        color: Colors.lightGreen,
        child: GNav(
          backgroundColor: kMainColor,
          color: Colors.white,
          activeColor: Colors.white,
          tabBackgroundColor: Colors.lightGreen.shade800,
          padding: const EdgeInsets.all(16),
          gap: 8,
          tabs: [
            GButton(
              active: false,
              icon: Icons.home,
              text: 'home',
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const HomePage()));
              },
            ),
            GButton(
              active: true,
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
        ),
        ),
      body: SafeArea(
        child: providerCart.cartCount == 0 ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                'Cart',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(child:
            Center(child: Image.asset('assets/images/empty_box.png'))),
            Expanded(
              flex: 2,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomePage()));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: kMainColor),
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Go to products',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ) : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                'Cart',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(right: 20),
                // height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: providerCart.cartCount,
                  itemBuilder: (context, index) {
                    final cartItem = providerCart.cart[index];
                    return OrderProductTile(
                      name: cartItem.name,
                      price: cartItem.totalPrice.toStringAsFixed(2),
                      image_url: cartItem.imageUrl,
                      quantity: cartItem.quantity,
                      index:index,

                    );

                  },
                ),
                // child: ,
              ),
            ),

            Expanded(
              child: Container(
                padding: const EdgeInsets.only(right: 20),
                // height: 100,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Item total',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'R${providerCart.cartTotal.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18, right: 18),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Checkout()));
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
                                'Proceed to checkout',
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
          ],
        ),
      ),
    );
  }
}
