import 'package:flutter/material.dart';
import 'package:staffapp/data.dart';
import 'package:staffapp/drawer/assignedTables.dart';

class DrawerMenu extends StatelessWidget {
  final Restaurant restaurant;
  final String staffName;
  final String staffId;
  DrawerMenu({
    this.restaurant,
    this.staffName,
    this.staffId,
  });
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        DrawerHeader(
          child: Container(
            child: Center(
              child: Text("Hey ! $staffName "),
            ),
          ),
        ),

        FlatButton(
          child: Center(
            child: Text('Assigned Tables'),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AssignedTables(
                  restaurant: restaurant,
                  staffId: staffId,
                ),
              ),
            );
          },
        ),

        Divider(),
        ///////////////////
      ],
    );
  }
}
