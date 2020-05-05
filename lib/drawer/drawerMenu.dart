import 'package:flutter/material.dart';
import 'package:staffapp/data.dart';
import 'package:staffapp/drawer/assignedTables.dart';

class DrawerMenu extends StatelessWidget {
  final Restaurant restaurant;
  DrawerMenu({
    this.restaurant,
  });
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        DrawerHeader(
          child: Container(),
        ),

        FlatButton(
          child: Center(
            child: Text('Assigned Tables'),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AssignedTables(
                  restaurant: restaurant,
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
