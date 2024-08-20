import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// import 'package:m_delivery/models/product_ingredient_provider.dart';
// import 'package:m_delivery/widget/custom_checkbox.dart';
import 'package:provider/provider.dart';
// import 'package:m_delivery/models/cart_provider.dart';
import '../models/cart.dart';
import '../models/cart_provider.dart';
import '../models/product_ingredient_provider.dart';
import '../utils/constants.dart';
import '../widget/bottom_nav.dart';
import '../widget/custom_checkbox.dart';

class ProductView extends StatefulWidget {
  const ProductView({Key? key, this.product}) : super(key: key);

  final dynamic product;

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  final removedIngredient = [];
  final extras = [];
  double totalPrice = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalPrice = widget.product["price"];
    // print(widget.product);
  }

  @override
  Widget build(BuildContext context) {
    final providerIngredient = Provider.of<ProductIngredientProvider>(context);
    final providerCart = Provider.of<CartProvider>(context);
    print(widget.product["price"]);
    String notes = '';
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          providerCart.addToCart(Cart(
              widget.product["id"],
              widget.product["name"],
              notes,
              widget.product["price"],
              1,
              extras,
              totalPrice,
              removedIngredient,
              kImageUrl + widget.product["image"]));
          Navigator.pop(context);
        },
        backgroundColor: Colors.lightGreen,
        child: const Icon(Icons.add_shopping_cart),
      ),
      bottomNavigationBar: BottomNav(),
      body: Stack(
        children: [
          Container(
            // flex: 1,
            height: 350,
            // color: Colors.deepOrange,
            child: Hero(
              tag: kImageUrl + widget.product["image"],
              child: CachedNetworkImage(
                imageUrl: kImageUrl + widget.product["image"],
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(
                    color: Colors.lightGreen,
                  ),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
                imageBuilder: (context, imageProvider) => Container(
                  // width: 80.0,
                  // height: 80.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.fitHeight),
                  ),
                ),
              ),
            ),
          ),
          Container(
            // flex: 2,
            child: DraggableScrollableSheet(
                initialChildSize: 0.65,
                minChildSize: 0.65,
                maxChildSize: 1.00,
                builder: (context, scrollableController) {
                  return Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15))),
                    child: SingleChildScrollView(
                      controller: scrollableController,
                      padding: EdgeInsets.only(left: 40, right: 40, top: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.product['name'],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'R${totalPrice.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 35,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              for (int x = 0;
                              x <= widget.product['ingredients'].length - 1;
                              x++) ...[
                                for (int y = 0;
                                y <=
                                    providerIngredient.ingredients.length -
                                        1;
                                y++) ...[
                                  if (providerIngredient.ingredients[y]['id']
                                      .toString() ==
                                      widget.product['ingredients'][x]) ...[
                                    Text('${providerIngredient.ingredients[y]['name']},'),
                                    SizedBox(width: 5,)
                                  ]
                                ]
                              ],
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Description',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                          Text(
                              '${widget.product['description']}'),
                          SizedBox(
                            height: 20,
                          ),
                          ExpansionTile(
                            title: Text(
                              'Remove ingredients',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                              ),
                            ),
                            children: <Widget>[
                              for (int x = 0;
                                  x <= widget.product['ingredients'].length - 1;
                                  x++) ...[
                                for (int y = 0;
                                    y <=
                                        providerIngredient.ingredients.length -
                                            1;
                                    y++) ...[
                                  if (providerIngredient.ingredients[y]['id']
                                          .toString() ==
                                      widget.product['ingredients'][x]) ...[
                                    LabeledCheckbox(
                                        label:
                                            'No ${providerIngredient.ingredients[y]['name']}',
                                        padding: EdgeInsets.only(right: 20),
                                        value: removedIngredient.contains(
                                                providerIngredient
                                                    .ingredients[x]['id'])
                                            ? true
                                            : false,
                                        onChanged: (onChanged) {
                                          // if true add to product ingredient array

                                          if (onChanged) {
                                            setState(() {
                                              removedIngredient.add(
                                                  providerIngredient
                                                      .ingredients[x]['id']);
                                            });
                                          } else {
                                            setState(() {
                                              removedIngredient.remove(
                                                  providerIngredient
                                                      .ingredients[x]['id']);
                                            });
                                          }
                                          // how to save the true value of this ingredient
                                          //
                                        }),
                                  ]
                                ]
                              ]
                            ],
                          ),
                          ExpansionTile(
                            title: Text(
                              'Add Extras',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                              ),
                            ),
                            children: <Widget>[
                              for (int x = 0;
                                  x <=
                                      providerIngredient.ingredients.length - 1;
                                  x++) ...[
                                LabeledCheckbox(
                                  label:
                                      'Add ${providerIngredient.ingredients[x]['name']}',
                                  padding: EdgeInsets.only(right: 20),
                                  value: extras.contains(providerIngredient
                                          .ingredients[x]['id'])
                                      ? true
                                      : false,
                                  onChanged: (onChanged) {
                                    if (onChanged) {
                                      setState(() {
                                        extras.add(providerIngredient
                                            .ingredients[x]['id']);
                                        print(totalPrice);
                                        for (int y = 0;
                                            y <= extras.length - 1;
                                            y++) {
                                          totalPrice = totalPrice +
                                              providerIngredient.ingredients[x]
                                                  ['price'];
                                        }
                                      });
                                    } else {
                                      setState(() {
                                        extras.remove(providerIngredient
                                            .ingredients[x]['id']);
                                        totalPrice = totalPrice -
                                            providerIngredient.ingredients[x]
                                                ['price'];
                                      });
                                    }
                                  },
                                  price: providerIngredient.ingredients[x]
                                      ['price'],
                                ),
                              ]
                            ],
                          ),
                          ExpansionTile(
                            title: Text(
                              'Add notes',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                              ),
                            ),
                            children: <Widget>[
                              TextField(
                                onChanged: (text) {
                                  notes = text;
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Note to store',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
