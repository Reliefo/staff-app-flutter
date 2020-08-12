import 'package:flutter/material.dart';
import 'package:staffapp/data.dart';

class CartData extends ChangeNotifier {
  List<FoodItem> cartItems = [];

  CartData({
    this.cartItems
  });

  addItemToCart(MenuFoodItem foodItem) {
    cartItems.add(FoodItem.addMenuFoodItem(foodItem));
    notifyListeners();
  }

  increaseItemQuantity() {}

  decreaseItemQuantity() {}
}
