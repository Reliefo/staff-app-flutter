import 'package:flutter/material.dart';
import 'package:staffapp/data.dart';

class AssignedTables extends StatelessWidget {
  final Restaurant restaurant;
  final List<Tables> assignedTables = [];
  AssignedTables({
    this.restaurant,
  });
  getAssignedTables() {
    restaurant.tables.forEach((table) {
      table.staff.forEach((staff) {
        if (staff.oid == "id") {
          assignedTables.add(table);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    getAssignedTables();
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: ListView.builder(
              itemCount: assignedTables.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    assignedTables[index].name,
                  ),
                );
              }),
        ),
      ),
    );
  }
}
