import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// import 'package:m_delivery/utils/constants.dart';
import 'package:provider/provider.dart';

import '../models/cart_provider.dart';
import '../utils/constants.dart';

class OrderProductTile extends StatelessWidget {
  const OrderProductTile({
    Key? key,
    required this.name,
    required this.price,
    required this.image_url,
    required this.quantity,
    required this.index,
  }) : super(key: key);

  final String name;
  final String price;
  final String image_url;
  final int quantity;
  final int index;

  @override
  Widget build(BuildContext context) {
    final providerCart = Provider.of<CartProvider>(context);
    return Container(
      height: 100,
      margin: EdgeInsets.only(right: 5),
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          CachedNetworkImage(
            imageUrl: image_url,
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
          // const CircleAvatar(
          //   radius: 50,
          //   backgroundImage: AssetImage('assets/images/AEX 18 May (4)kota.jpg'),
          // ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 0),
                  child: Text(name,
                      style: TextStyle(
                          fontSize: kTileTitleSize,
                          fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'R${price}',
                  style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: kSecondaryTitleSize),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        providerCart.decrementQuantity(index);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.lightGreen,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10))),
                        child: Icon(
                          Icons.remove,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(quantity.toString()),
                    SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        providerCart.incrementQuantity(index);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.lightGreen,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10))),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: (){
              providerCart.removeCartItem(index);
              print('remove element');
            },
            child: Icon(Icons.delete_forever),
          )
        ],
      ),
    );
  }
}
