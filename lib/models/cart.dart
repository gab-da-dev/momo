// lib/pages/cart.dart
import 'package:flutter/material.dart';

class Cart {
  final int id;
  final String name;
  final String imageUrl;
  final double price; // Ensure this field exists
  int quantity; // Ensure this field exists
  List<dynamic> extraData; // Placeholder for extra data
  double totalPrice; // Ensure this field exists
  List<dynamic> additionalInfo; // Placeholder for additional info
  String notes; // Placeholder for notes

  Cart(
      this.id,
      this.name,
      this.imageUrl,
      this.price,
      this.quantity,
      this.extraData,
      this.totalPrice,
      this.additionalInfo,
      this.notes,
      );

  // Getter for quantity
  int get getQuantity => quantity;

  // Setter for quantity
  set setQuantity(int value) {
    quantity = value;
  }
}
