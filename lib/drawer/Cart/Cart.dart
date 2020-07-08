import 'package:flutter/material.dart';
import 'package:staffapp/data.dart';

class CartData extends ChangeNotifier {
  final List<FoodItem> cartItems = [];

  addItemToCart(MenuFoodItem foodItem) {
    cartItems.add(FoodItem.addMenuFoodItem(foodItem));
    notifyListeners();
  }

  increaseItemQuantity() {}

  decreaseItemQuantity() {}
}
