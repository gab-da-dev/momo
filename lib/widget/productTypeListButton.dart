import 'package:flutter/material.dart';

import '../pages/category_product_view.dart';
// import 'package:m_delivery/pages/category_product_view.dart';

class ProductTypeListButton extends StatelessWidget {
  const ProductTypeListButton({
    Key? key, required this.label, required this.productList,
  }) : super(key: key);

  final String label;
  final List<dynamic> productList;
  @override
  Widget build(BuildContext context) {
    // print(productList);
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CategoryProductView(category: label, productList: productList,)));
        },
        child: Container(
            margin: EdgeInsets.only(right: 5),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.lightGreen),
                borderRadius: BorderRadius.circular(10)),
            child: Text(label,
                style: TextStyle(
                  color: Colors.lightGreen,
                    fontSize: 15, fontWeight: FontWeight.w600))));
  }
}