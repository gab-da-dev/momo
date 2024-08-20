import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  Future<bool> login(String email, String password) async {
    print('logging in with email $email and password $password');
    _isAuthenticated = true;
    notifyListeners();
    return true;
  }
}