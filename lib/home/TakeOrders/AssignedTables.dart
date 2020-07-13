import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:staffapp/Store/DataStore.dart';
import 'package:staffapp/constants.dart';
import 'package:staffapp/data.dart';
import 'package:staffapp/home/TakeOrders/Billing.dart';

class AssignedTables extends StatelessWidget {
  final List<Tables> assignedTables = [];

  getAssignedTables(dataStore) {
    assignedTables.clear();
    dataStore.restaurant.tables.forEach((table) {
      if (table.staff != null) {
        table.staff.forEach((staff) {
          if (staff.oid == dataStore.staffId) {
            assignedTables.add(table);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final DataStore dataStore = Provider.of<DataStore>(context);
    getAssignedTables(dataStore);
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: assignedTables.isNotEmpty
              ? GridView.builder(
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
                            builder: (context) => Billing(
                              tableId: assignedTables[index].oid,
                            ),
                          ),
                        );
                      },
                    );
                  })
              : Center(
                  child: Text("Not Assigned to any tables."),
                ),
        ),
      ),
    );
  }
}
