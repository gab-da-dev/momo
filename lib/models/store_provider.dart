import 'dart:convert';

import 'package:flutter/cupertino.dart';
// import 'package:m_delivery/models/cart.dart';

class StoreProvider extends ChangeNotifier {
  var _store;

  get store => _store;

  set store(storeDara) {
    _store = storeDara;
    notifyListeners();
  }

  void setStoreData(storeData){
    _store = storeData;
    // print(_store);
    notifyListeners();
  }

}
