import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// import 'package:m_delivery/pages/product_view.dart';
// import 'package:m_delivery/utils/constants.dart';
import 'package:provider/provider.dart';

import '../models/product_ingredient_provider.dart';
import '../pages/product_view.dart';
import '../utils/constants.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({
    Key? key, required this.product_name, required this.product_price, required this.product_image, required this.product_ingredients, required this.product_id,
  }) : super(key: key);

  final String product_name;
  final double product_price;
  final int product_id;
  final String product_image;
  final dynamic product_ingredients;

  @override
  Widget build(BuildContext context) {
    final providerIngredient = Provider.of<ProductIngredientProvider>(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductView(
                      product: {
                        'id': product_id,
                        'name': product_name,
                        'price': product_price,
                        'image': product_image,
                        'ingredients':product_ingredients
                      },
                    )));
      },
      child: Container(
        height: 100,
        margin: EdgeInsets.only(right: 5),
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            CachedNetworkImage(
              imageUrl: '${kImageUrl}${product_image}',
              placeholder: (context, url) => Center(
                child: CircularProgressIndicator(
                  color: Colors.lightGreen,
                ),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
              imageBuilder: (context, imageProvider) => Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Text(product_name,
                        style: TextStyle(
                            fontSize: kTileTitleSize,
                            fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      for (int x = 0;
                      x <= product_ingredients.length - 1;
                      x++) ...[
                        for (int y = 0;
                        y <=
                            providerIngredient.ingredients.length -
                                1;
                        y++) ...[
                          if (providerIngredient.ingredients[y]['id']
                              .toString() ==
                              product_ingredients[x]) ...[
                            Text('${providerIngredient.ingredients[y]['name']},'),
                            SizedBox(width: 5,)
                          ]
                        ]
                      ],
                    ],
                  ),

                ],
              ),
            ),
            Text(
              'R$product_price',
              style: TextStyle(fontSize: 20),
            )

          ],
        ),
      ),

    );
  }
}