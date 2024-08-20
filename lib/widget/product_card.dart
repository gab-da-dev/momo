import 'package:flutter/material.dart';
// import 'package:m_delivery/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:m_delivery/utils/constants.dart';

import '../utils/constants.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key, required this.product_name, required this.product_price, required this.product_image, required this.product_duration, this.index_key, required this.heroTag,
  }) : super(key: key);

  final index_key;
  final String product_name;
  final double product_price;
  final String product_image;
  final String product_duration;
  final String heroTag;

  @override
  Widget build(BuildContext context) {

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: '$heroTag',
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 150,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
              ),
              child: CachedNetworkImage(
                imageUrl: '$kImageUrl$product_image',
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
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
              ),
              // child: CachedNetworkImage(imageUrl: 'http://192.168.18.10:81/products/8NqPPHlqQfdT5iOIlTl1ltJy24B1h869lBFUgA0o.jpg'),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 20.0),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Text(product_name,
                     style: TextStyle(
                         fontSize: kTileTitleSize, fontWeight: FontWeight.w700)),
                 Text('R${product_price.toStringAsFixed(2)}',
                     style: TextStyle(
                         fontSize: kTileTitleSize,
                         fontWeight: FontWeight.bold)),
               ],
             ),
           ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              children: [
                const SizedBox(
                  width: 5,
                ),
                Row(
                  children: [
                    Icon(Icons.access_time_rounded),
                    SizedBox(
                      width: 3,
                    ),
                    Text('$product_duration min',
                        style: TextStyle(
                            fontSize: kSecondaryTitleSize,
                            fontWeight: FontWeight.bold))
                  ],
                ),
              ],
            ),
          )
        ],
    );
  }
}

