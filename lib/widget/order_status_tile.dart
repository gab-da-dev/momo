import 'package:flutter/material.dart';
// import 'package:m_delivery/pages/delivery_map.dart';
// import 'package:m_delivery/pages/product_view.dart';
// import 'package:m_delivery/utils/constants.dart';
import 'package:provider/provider.dart';

import '../models/order_provider.dart';
import '../pages/delivery_map.dart';

class OrderStatusTile extends StatelessWidget {
  const OrderStatusTile({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final providerOrder = Provider.of<OrderProvider>(context);
print(providerOrder.order);
    return Container(
      // color: Colors.grey,
      height: 120,
      padding: EdgeInsets.only(top: 10, bottom: 10, right: 10),
      child: Row(
            children: [
              if(providerOrder.order['status'] == 0 || providerOrder.order['status'] == 1 || providerOrder.order['status'] == 2|| providerOrder.order['status'] == 3)...[
                ActiveOrderWidget(title: 'Order placed',icon: Icon(
                  Icons.check_circle_outline_rounded,
                  size: 40,
                  color: Colors.lightGreen,
                ))
              ],
              if(providerOrder.order['status'] == 1 || providerOrder.order['status'] == 2|| providerOrder.order['status'] == 3)...[
                ActiveOrderWidget(title: 'In progress',icon: Icon(
                  Icons.access_time,
                  size: 40,
                  color: Colors.lightGreen,
                ))
              ]else...[
                OrderWidget(title: 'In progress',icon: Icon(
                  Icons.access_time,
                  size: 40,
                )),
              ],
              if(providerOrder.order['order_type'] == 'delivery')...[
                if(providerOrder.order['status'] == 3)...[
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DeliveryMap()));
                    },
                    child: ActiveOrderWidget(title: 'Track order', icon: Icon(
                      Icons.directions_bike_outlined,
                      size: 40,
                      color: Colors.lightGreen,
                    ),),
                  )
                ]else...[
                  OrderWidget(title: 'On the way',icon: Icon(
                      Icons.directions_bike_outlined,
                      size: 40,
                    ),),
                ],
              ]else...[
                if(providerOrder.order['status'] == 4)...[
                  ActiveOrderWidget(title: 'Ready for collection', icon: Icon(
                    Icons.fastfood,
                    size: 40,
                    color: Colors.lightGreen,
                  ),)
                ]else...[
                  OrderWidget(title: 'Ready for collection',icon: Icon(
                    Icons.fastfood,
                    size: 40,
                  ),),
                ],
              ],
    if(providerOrder.order['order_type'] == 'delivery')...[
              if(providerOrder.order['status'] == 4)...[
                ActiveOrderWidget(title: 'Delivered',icon: Icon(
                  Icons.fastfood,
                  size: 40,
                  color: Colors.lightGreen,
                ))

              ]else...[
                OrderWidget(title: 'Delivered',icon: Icon(
                  Icons.fastfood,
                  size: 40,
                ),),
              ],
            ],
          ]
          ),


    );
  }
}

class OrderWidget extends StatelessWidget {
  const OrderWidget({
    Key? key, required this.title, required this.icon,
  }) : super(key: key);
  final String title;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          icon,
          const SizedBox(
            height: 10,
          ),
          Text(title)
        ],
      ),
    );
  }
}

class ActiveOrderWidget extends StatelessWidget {
  const ActiveOrderWidget({
    Key? key, required this.title, required this.icon,
  }) : super(key: key);
  final String title;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          icon,
          const SizedBox(
            height: 10,
          ),
          Container(
            // color: Colors.lightGreen,
            // padding: EdgeInsets.all(5),
            child: Text(
              title,
              style: TextStyle(
                  color: Colors.lightGreen, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
