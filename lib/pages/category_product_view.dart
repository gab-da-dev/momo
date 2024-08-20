import 'package:flutter/material.dart';
// import 'package:m_delivery/widget/product_tile.dart';
import '../widget/bottom_nav.dart';
import '../widget/product_tile.dart';

class CategoryProductView extends StatelessWidget {
  const CategoryProductView({Key? key, required this.category, required this.productList}) : super(key: key);

  final String category;
  final List<dynamic> productList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const BottomNav(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // app bar

            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                category,
                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                  padding: const EdgeInsets.only(right: 20),
                  // height: 100,
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: [
                      for (int x = 0; x <= productList.length - 1; x++)...[
                        ProductTile(product_id: productList[x]['id'],product_name: productList[x]['name'],product_price: productList[x]['price'],product_image: productList[x]['image'], product_ingredients: productList[x]['ingredients'],),
                      ]
                      ],
                  ),
                ),
            ),



            // const SizedBox(height: 10),

            // page body
          ],
        ),
      ),
    );
  }
}


