import 'dart:convert';

import 'package:flutter/cupertino.dart';

class ProductIngredientProvider extends ChangeNotifier {
  var _ingredients;

  get ingredients => _ingredients;

  set ingredients(ingredientsData) {
    _ingredients = ingredientsData;
    // print(_ingredients);
    notifyListeners();
  }

  void setIngredientsData(ingredientsData){
    _ingredients = ingredientsData;
    // print(_ingredients);
    notifyListeners();
  }

}
