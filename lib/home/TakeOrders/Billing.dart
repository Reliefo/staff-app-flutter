import 'package:flutter/material.dart';
import 'package:staffapp/constants.dart';
import 'package:staffapp/home/TakeOrders/FoodOrder/restaurantMenu.dart';

class Billing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kThemeColor,
          title: Text("Bill / take order"),
          actions: <Widget>[
            FlatButton(
              child: Text("Bill"),
              onPressed: () {},
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
//          icon: Icon(Icons.save),
          backgroundColor: kThemeColor,
          label: Text("Take Order"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RestaurantMenu(),
              ),
            );
          },
        ),
        body: Container(),
      ),
    );
  }
}
