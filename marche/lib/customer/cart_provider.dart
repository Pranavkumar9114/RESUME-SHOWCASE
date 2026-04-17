import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _cartItems = [];  

  List<Map<String, dynamic>> get cartItems => _cartItems;

  CartProvider() {
    _loadCartItems();
  }

  void clearCart() {
  _cartItems.clear();  // Clear the cart list
  _saveCartItems();    // Save the cleared cart data to SharedPreferences
  notifyListeners();   // Notify listeners to update the UI
}

  Future<void> _loadCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getString('cart_items');
    if (cartData != null) {
      final List<dynamic> decodedData = json.decode(cartData);
      _cartItems.clear();
      _cartItems.addAll(decodedData.map((item) => Map<String, String>.from(item)).toList());
    }
    notifyListeners();
  }

  Future<void> _saveCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = json.encode(_cartItems);
    prefs.setString('cart_items', cartData);
  }

  void addItem(Map<String, String> productDetails) {
    _cartItems.add(productDetails);
    _saveCartItems(); 
    notifyListeners();
  }

  void removeItem(int index) {
    _cartItems.removeAt(index);
    _saveCartItems(); 
    notifyListeners();
  }
}
