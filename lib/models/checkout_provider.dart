import 'dart:convert';
import 'package:flutter/cupertino.dart';

class CheckoutProvider extends ChangeNotifier {
  var _coordinates;
  bool _isDelivery = false;
  bool _isCollect = false;
  String _address = '';

  get coordinates => _coordinates;
  get address => _address;
  bool get isDelivery => _isDelivery;
  bool get isCollect => _isCollect;

  set coordinates(newCoordinates) {
    _coordinates = newCoordinates;
    notifyListeners();
  }

  void setIsDelivery(bool newBool){
    _isDelivery = newBool;
    if(_isDelivery){
      _isCollect = false;
    }
    notifyListeners();
  }

  void setIsCollect(bool newBool){
    _isCollect = newBool;
    if(_isCollect){
      _isDelivery = false;
    }
    notifyListeners();
  }

  void setCoordinates(newCoordinates){
    print(jsonDecode(newCoordinates));
    _coordinates = jsonDecode(newCoordinates);
    notifyListeners();
  }

  void setAddress(String address){
    _address = address;
    notifyListeners();
  }

}
