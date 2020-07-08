import 'package:flutter/material.dart';
import 'package:staffapp/constants.dart';
import 'package:staffapp/data.dart';
import 'package:staffapp/home/TakeOrders/FoodOrder/restaurantMenu.dart';

class TakeOrders extends StatelessWidget {
  final Restaurant restaurant;
  final String staffId;
  final List<Tables> assignedTables = [];

  TakeOrders({
    this.restaurant,
    this.staffId,
  });

  getAssignedTables() {
    assignedTables.clear();
    restaurant.tables.forEach((table) {
      if (table.staff != null) {
        table.staff.forEach((staff) {
          if (staff.oid == staffId) {
            assignedTables.add(table);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    getAssignedTables();
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: GridView.builder(
              itemCount: assignedTables.length,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                childAspectRatio: 2 / 1,
                maxCrossAxisExtent: 240,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.amber[200],
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.0),
                      ),
                    ),
                    margin: EdgeInsets.all(4),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: Text(
                        assignedTables[index].name,
                        style: kTitleStyle,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RestaurantMenu(
                          restaurant: restaurant,
                        ),
                      ),
                    );
                  },
                );
              }),
        ),
      ),
    );
  }
}
