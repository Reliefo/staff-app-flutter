import 'package:flutter/material.dart';
import 'package:staffapp/data.dart';

class AssignedTables extends StatelessWidget {
  final Restaurant restaurant;
  final String staffId;
  final List<Tables> assignedTables = [];
  AssignedTables({
    this.restaurant,
    this.staffId,
  });
  getAssignedTables() {
    restaurant.tables.forEach((table) {
      table.staff.forEach((staff) {
        if (staff.oid == staffId) {
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
