import 'dart:convert';

import 'package:flutter/cupertino.dart';

class OrderProvider extends ChangeNotifier {
  var _order;

  get order => _order;

  set order(orderData) {
    _order = orderData;
    print(_order);
    notifyListeners();
  }

  void setOrderData(orderData){
    _order = orderData;
    print(_order);
    notifyListeners();
  }

}
