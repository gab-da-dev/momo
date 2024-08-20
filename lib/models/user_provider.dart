import 'dart:convert';

import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier {
  var _user;

  get user => _user;

  set user(userData) {
    _user = userData;
    // print(_user);
    notifyListeners();
  }

  void setUserData(userData){
    _user = userData;
    // print(_user);
    notifyListeners();
  }

}
