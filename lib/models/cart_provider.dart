import 'dart:convert';

import 'package:flutter/cupertino.dart';

// import '../pages/cart.dart';
import 'cart.dart';

class CartProvider extends ChangeNotifier {
  List<Cart> _cart = [
    // Cart(1, "Number 7", 'null', 35.90, 1, [], 34.00, [],''),
    // Cart(1, "Number 1", 'null', 35.90, 1, [], 34.00, [],''),
    // Cart(1, "Number 7", 'null', 35.90, 1, [], 34.00, [],''),
  ];

  List<Cart> get cart => _cart;

  set cart(List<Cart> newCartItem) {
    _cart = newCartItem;
    notifyListeners();
  }

  int get cartCount {
    return _cart.length;
  }

  double get cartTotal{
    double total = 0;
    _cart.forEach((element) {
      total = total + (element.price * element.quantity); //TODO make the amount a double in the database and change from parsing here
      // print(element.price);
    });
    return total;
  }

  String getCartJson(){
    String cartJson = jsonEncode(_cart);
    return cartJson;
  }

  void removeCartItem(index) {
    _cart.removeAt(index);
    cartTotal;
    notifyListeners();
  }

  void addToCart(Cart) {
    _cart.add(Cart);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  void incrementQuantity(index) {
    _cart[index].quantity = _cart[index].quantity + 1;
    incrementQuantityPrice(index);
    notifyListeners();
  }

  void incrementQuantityPrice(index) {
    _cart[index].totalPrice = _cart[index].quantity * _cart[index].price; //Todo convert back to double in the database
    notifyListeners();
  }

  void decrementQuantity(index) {
    if (_cart[index].quantity != 1) {
      _cart[index].quantity = _cart[index].quantity - 1;
      decrementQuantityPrice(index);
      notifyListeners();
    }
  }
  void decrementQuantityPrice(index) {
    // if (_cart[index].quantity != 1) {
      _cart[index].totalPrice = _cart[index].totalPrice - (_cart[index].quantity * _cart[index].price); //Todo convert back to double in the database
      notifyListeners();
    // }
  }

}
